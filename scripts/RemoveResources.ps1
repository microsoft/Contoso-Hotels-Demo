# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

$subscriptionId = '3ef9c878-c106-464a-820e-4ed22d65f3e2'
$prefix = 'CH1'
$suffix = 'Play'

#Connect-AzAccount
$context = Get-AzSubscription -SubscriptionId $subscriptionId
Set-AzContext $context

$RGNames = @("$prefix-OpsRG-Pri-$suffix", "$prefix-OpsRG-Sec-$suffix", `
             "$prefix-RetailRG-Sec-$suffix", "$prefix-RetailRG-Pri-$suffix", `
             "$prefix-InfraRG-Sec-$suffix", "$prefix-InfraRG-Pri-$suffix")

# Remove locks
ForEach ($RGName in $RGNames){
   Get-AzResourceLock -ResourceGroupName $RGName -ErrorAction SilentlyContinue | Remove-AzResourceLock -Force -Verbose
}

# Remove LA Workspace
$laWorkspaceName = "$prefix-LA-$suffix"
$laWorkspace = Get-AzResource -Name $laWorkspaceName
If($laWorkspace){
    Remove-AzOperationalInsightsWorkspace -ResourceGroupName $laWorkspace.ResourceGroupName -Name $laWorkspaceName -ForceDelete -Force -Verbose
}

# Remove Key Vaults
$keyVaultNames = @("$prefix-KV-Pri-$suffix","$prefix-KV-Sec-$suffix")
ForEach ($keyVaultName in $keyVaultNames){
   $keyVault = Get-AzResource -Name $keyVaultName
   If($keyVault){
      Remove-AzKeyVault -Name $keyVault.Name -ResourceGroupName $keyVault.ResourceGroupName -Force -Verbose
      Remove-AzKeyVault -Name $keyVault.Name -Location $keyVault.Location -InRemovedState -Force -Verbose
   }
}

# Remove Policy Assignments
$policyAssignments = Get-AzPolicyAssignment -Scope "/subscriptions/$subscriptionId"
If($policyAssignments){
   ForEach ($policyAssignment in $policyAssignments){
      Remove-AzPolicyAssignment -Id $policyAssignment.ResourceId -Verbose -Confirm:$false
   }
}

# Remove Policy Initiatives
$policyInitiatives = Get-AzPolicySetDefinition -Custom
If($policyInitiatives){
   ForEach ($policyInitiative in $policyInitiatives){
      Remove-AzPolicySetDefinition -Id $policyInitiative.ResourceId -Verbose -Force
   }
}

# Remove policy definitions
$policdefinitions = get-azpolicydefinition -custom -subscriptionid $subscriptionid | Where-Object {$_.Properties.Metadata.category -ne "Tiander"}
if($policdefinitions){
    foreach ($policdefinition in $policdefinitions){
        Remove-AzPolicyDefinition -id $policdefinition.resourceid -Force -Verbose
    }
}
# Remove Role Assignments
$roleAssignments = Get-AzRoleAssignment | Where-Object {$_.DisplayName -eq $null} | Where-Object {$_.SignInName -eq $null} | Where-Object {$_.ObjectType -eq "Unknown"}
if($roleAssignments){
    foreach ($roleAssignment in $roleAssignments){
        Remove-AzRoleAssignment -InputObject $roleAssignment -Confirm:$false -Verbose
    }
}

# Remove Recovery Vaults
$recoveryVaultNames = @("$prefix-RV-Pri-$suffix", "$prefix-RV-Sec-$suffix")

# Recovery Vault types combinations
$RVTypesList = @{'WorkloadType'='AzureVM'; 'BackupManagementType'='AzureVM'},
               @{'WorkloadType'='AzureVM'; 'BackupManagementType'='MAB'},
               @{'WorkloadType'='AzureFiles'; 'BackupManagementType'='MAB'},
               @{'WorkloadType'='AzureFiles'; 'BackupManagementType'='AzureStorage'},
               @{'WorkloadType'='MSSQL'; 'BackupManagementType'='MAB'},
               @{'WorkloadType'='MSSQL'; 'BackupManagementType'='AzureWorkload'}

ForEach ($recoveryVaultName in $recoveryVaultNames){
   $recoveryVault = Get-AzRecoveryServicesVault -Name $recoveryVaultName
   If($recoveryVault){
      Set-AzRecoveryServicesVaultContext -Vault $recoveryVault
      Set-AzRecoveryServicesAsrVaultContext -Vault $recoveryVault 

      # Disable SoftDeleteFeature on Recovery Vault
      Set-AzRecoveryServicesVaultProperty -VaultId $recoveryVault.Id -SoftDeleteFeatureState Disable -Confirm:$false -Verbose

      # Check each Recovery Services Backup Item for not having the "ToBeDeleted" status and delete backups
      ForEach($RVTypes in $RVTypesList){
         $allBkpItems = Get-AzRecoveryServicesBackupItem -BackupManagementType $RVTypes.BackupManagementType -WorkloadType $RVTypes.WorkloadType -VaultId $recoveryVault.Id -Verbose
         if($allBkpItems){
            $toBeDeletedBkpItems = $allBkpItems | Where-Object {$_.DeleteState -eq "ToBeDeleted"}
            if ($toBeDeletedBkpItems.Count -ne 0) {
               ForEach($bkpItem in $toBeDeletedBkpItems){
                  Undo-AzRecoveryServicesBackupItemDeletion -Item $bkpItem -VaultId $recoveryVault.Id -Force -Verbose
               }
            }
            # Remove Backup Items
            ForEach($bkpItem in $allBkpItems){
               Disable-AzRecoveryServicesBackupProtection -Item $bkpItem -RemoveRecoveryPoints -VaultId $recoveryVault.Id -Force -Verbose
            }
         }
      }
      
      # Remove Recovery Services Backup Containers
      $containers = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVMAppContainer -Status Registered -Verbose
      if($containers){
         ForEach($container in $containers){
            Unregister-AzRecoveryServicesBackupContainer -Container $container -Verbose
         }
      }

      # Remove Backup Protectable Items
      $backupProtectableItems = Get-AzRecoveryServicesBackupProtectableItem -WorkloadType MSSQL -VaultId $recoveryVault.ID -Verbose
      if($backupProtectableItems){
         ForEach($bkpProtectableItem in $backupProtectableItems){
            Disable-AzRecoveryServicesBackupAutoProtection -BackupManagementType AzureWorkload -InputItem $bkpProtectableItem -WorkloadType MSSQL -VaultId $recoveryVault.ID -Verbose
         }
      }

      # Remove Asr Policies
      $asrPolicies = Get-AzRecoveryServicesAsrPolicy
      if($asrPolicies){
         ForEach($asrPolicy in $asrPolicies){
            Remove-AzRecoveryServicesAsrPolicy -InputObject $asrPolicy -Verbose
         }
      }

      # Remove Backup Policies
      $backupPolicies = Get-AzRecoveryServicesBackupProtectionPolicy
      if($backupPolicies){
         ForEach($backupPolicy in $backupPolicies){
            Remove-AzRecoveryServicesBackupProtectionPolicy -Policy $backupPolicy -Force -Verbose
         }
      }

      # Remove Recovery Plan
      $recoveryPlan = Get-AzRecoveryServicesAsrRecoveryPlan
      if($recoveryPlan){
        Remove-AzRecoveryServicesAsrRecoveryPlan -InputObject $recoveryPlan -Confirm:$false -Verbose
      }

      # Remove Asr Recovery Services Asr Services Providers, Protection Containers and Asr Replication Protected Items
      $rvID = $recoveryVault.ID
      $asrFabricsNames = Get-AzResource -ResourceId "$rvID/replicationFabrics/" | Foreach-Object {$_.Name}
      ForEach($asrFabricsName in $asrFabricsNames){
         $asrFabric = Get-AzRecoveryServicesAsrFabric -Name $asrFabricsName -Verbose
         if($asrFabric){
            $servicesProviders = Get-AzRecoveryServicesAsrServicesProvider -Fabric $asrFabric
            ForEach($servicesProvider in $servicesProviders){
               Remove-AzRecoveryServicesAsrServicesProvider -InputObject $servicesProvider -Force -Verbose
            }
            $asrContainers = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $asrFabric -Verbose
            if($asrContainers){
               ForEach($asrContainer in $asrContainers){
                  $asrProtectedItems = Get-AzRecoveryServicesAsrReplicationProtectedItem -ProtectionContainer $asrContainer -Verbose
                  if($asrProtectedItems){
                     ForEach($asrProtectedItem in $asrProtectedItems){
                        Remove-AzRecoveryServicesAsrReplicationProtectedItem -InputObject $asrProtectedItem -Force -Verbose
                     }
                  }
               }
               Remove-AzRecoveryServicesAsrProtectionContainer -InputObject $asrContainer -Verbose
            }
            #Remove-AzRecoveryServicesAsrFabric -InputObject $asrFabric -Verbose
         }
      }
      Remove-AzRecoveryServicesVault -Vault $recoveryVault -Verbose
   }
}

# Remove Resource Groups
ForEach ($RGName in $RGNames){
   Remove-AzResourceGroup -Name $RGName -Force -Verbose -AsJob 
}
Get-Job | Wait-Job

# Additional Remove NSGs and VNets
$RGWithVnets = @("$prefix-OpsRG-Pri-$suffix", "$prefix-OpsRG-Sec-$suffix")
ForEach ($RGName in $RGWithVnets){
   Remove-AzResourceGroup -Name $RGName -Force -Verbose -AsJob 
}
Get-Job | Wait-Job
