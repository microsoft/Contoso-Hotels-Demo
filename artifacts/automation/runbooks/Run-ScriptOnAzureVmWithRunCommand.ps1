# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

param(
    [Parameter(Mandatory=$true)]
    $VMResourceGroupName,

    [Parameter(Mandatory=$true)]
    $VMName,

    [Parameter(Mandatory=$true)]
    $RunbookName
)

# Authenticate with Azure.
$ServicePrincipalConnection = Get-AutomationConnection -Name "AzureRunAsConnection"
Connect-AzAccount `
    -ServicePrincipal `
    -Tenant $ServicePrincipalConnection.TenantID `
    -ApplicationId $ServicePrincipalConnection.ApplicationID `
    -CertificateThumbprint $ServicePrincipalConnection.CertificateThumbprint

$SubscriptionContext = Get-AzSubscription -SubscriptionId $ServicePrincipalConnection.SubscriptionID  | Write-Verbose

# Find out the resource group and account name
$AutomationResource = Get-AzResource -ResourceType Microsoft.Automation/AutomationAccounts -AzContext $SubscriptionContext
foreach ($Automation in $AutomationResource)
{
    $Job = Get-AzAutomationJob -ResourceGroupName $Automation.ResourceGroupName -AutomationAccountName $Automation.Name `
                                    -Id $PSPrivateMetadata.JobId.Guid -AzContext $SubscriptionContext -ErrorAction SilentlyContinue
    if (!([string]::IsNullOrEmpty($Job)))
    {
        $AutomationResourceGroup = $Job.ResourceGroupName
        $AutomationAccount = $Job.AutomationAccountName
        break;
    }
}

$ScriptFolder = "c:\scripts"
$ScriptPath = Join-Path $ScriptFolder ($RunbookName + ".ps1")
New-Item -Path $ScriptFolder -ItemType Directory -Force | Write-Verbose

# Download runbook to local host in Azure Automation sandbox
Export-AzAutomationRunbook -ResourceGroupName $AutomationResourceGroup -AutomationAccountName $AutomationAccount `
                                -Name $RunbookName -AzContext $SubscriptionContext -OutputFolder $ScriptFolder -Force | Write-Verbose

# Invoke command
$Result = Invoke-AzVMRunCommand -ResourceGroupName $VMResourceGroupName -VMName $VMName -AzContext $SubscriptionContext `
                                     -CommandId "RunPowerShellScript" -ScriptPath $ScriptPath

$Result
