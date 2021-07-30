# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

<# 
.SYNOPSIS 
 
.DESCRIPTION 
  This script is intended to be run as a part of Update Management Pre/Post scripts.  
  It uses RunCommand to execute a PowerShell script
 
.PARAMETER SoftwareUpdateConfigurationRunContext 
  This is a system variable which is automatically passed in by Update Management during a deployment. 
#> 
 
param( 
    [string]$SoftwareUpdateConfigurationRunContext 
) 
 
#This requires a RunAs account 
$ServicePrincipalConnection = Get-AutomationConnection -Name "AzureRunAsConnection"
Connect-AzAccount `
    -ServicePrincipal `
    -Tenant $ServicePrincipalConnection.TenantID `
    -ApplicationId $ServicePrincipalConnection.ApplicationID `
    -CertificateThumbprint $ServicePrincipalConnection.CertificateThumbprint

$SubscriptionContext = Get-AzSubscription -SubscriptionId $ServicePrincipalConnection.SubscriptionID  | Write-Verbose
 
#If you wish to use the run context, it must be converted from JSON 
$context = ConvertFrom-Json  $SoftwareUpdateConfigurationRunContext 
$vmIds = $context.SoftwareUpdateConfigurationSettings.AzureVirtualMachines 
$runId = $context.SoftwareUpdateConfigurationRunId 
 
#The script you wish to run on each VM 
$scriptBlock = @'

$service = Get-Service ClusSvc -ErrorAction SilentlyContinue

if ($service) {
    $resource = Get-ClusterResource | ? ResourceType -match 'SQL Server Availability Group'

    if ($resource.OwnerNode.Name -match $env:COMPUTERNAME) {
        Move-ClusterGroup -Name $resource.OwnerGroup.Name
    }
}

'@ 
 
#The cmdlet only accepts a file, so temporarily write the script to disk using runID as a unique name 
Out-File -FilePath "$runID.ps1" -InputObject $scriptBlock 
 
#Start script on each machine 
$vmIds | ForEach-Object { 
    $vmId =  $_ 
     
    $split = $vmId -split "/"; 
    $resourceGroupName = $split[4]; 
    $vmName = $split[-1]; 

    Write-Output "Invoking command on '$($vmName)' ..." 
    Invoke-AzVMRunCommand -ResourceGroupName $resourceGroupName -Name $vmName -CommandId 'RunPowerShellScript' -ScriptPath "$runID.ps1" -AsJob 
} 
 
Write-Output "Waiting for machines to finish executing..." 
Get-Job | Wait-Job
#Clean up our variables: 
Remove-Item -Path "$runID.ps1"