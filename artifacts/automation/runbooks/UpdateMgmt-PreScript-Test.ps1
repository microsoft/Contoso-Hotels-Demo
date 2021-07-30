# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.
 
#This requires a RunAs account 
$ServicePrincipalConnection = Get-AutomationConnection -Name 'AzureRunAsConnection' 
 
Add-AzureRmAccount `
    -ServicePrincipal `
    -TenantId $ServicePrincipalConnection.TenantId `
    -ApplicationId $ServicePrincipalConnection.ApplicationId `
    -CertificateThumbprint $ServicePrincipalConnection.CertificateThumbprint 
 
 
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
Out-File -FilePath "prescript.ps1" -InputObject $scriptBlock 
 
$resourceGroupName = 'CH-RetailRG-Pri-Dev'

$VMs = @( 'CH-AppBEVM00-Dev', 'CH-SQLVM00-Dev' )


#Start script on each machine 
$VMs | ForEach-Object { 
     
    $vmName = $_ 

    Write-Output "Invoking command on '$($vmName)' ..." 
    Invoke-AzureRmVMRunCommand -ResourceGroupName $resourceGroupName -Name $vmName -CommandId 'RunPowerShellScript' -ScriptPath "prescript.ps1" -AsJob 
} 
 
Write-Output "Waiting for machines to finish executing..." 
Get-Job | Wait-Job
Get-Job | Receive-Job
#Clean up our variables: 
#Remove-Item -Path "$runID.ps1"