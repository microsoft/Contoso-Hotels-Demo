# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

Param (
    [string]$workspaceResourceId = '/subscriptions/d414ea4b-83dc-47b3-b97f-a817d2fac5da/resourcegroups/ch-opsrg-pri-play/providers/microsoft.operationalinsights/workspaces/ch-la-play',
    [string]$sitePrimaryLocation = 'eastus',
    [string]$siteSecondaryLocation = 'westus2',
    [string]$priDiagStorageResourceId = '/subscriptions/d414ea4b-83dc-47b3-b97f-a817d2fac5da/resourceGroups/CH-OpsRG-Pri-Play/providers/Microsoft.Storage/storageAccounts/diagymr4exa6zjpriplay',
    [string]$secDiagStorageResourceId = '/subscriptions/d414ea4b-83dc-47b3-b97f-a817d2fac5da/resourceGroups/CH-OpsRG-Sec-Play/providers/Microsoft.Storage/storageAccounts/diagymr4exa6zjsecplay'
)

$storageAccountResourceIDs = @{
  $sitePrimaryLocation = $priDiagStorageResourceId;
  $siteSecondaryLocation = $secDiagStorageResourceId
}

$networkWatcherResources = @{}

$workspaceResourceGroupName = ($workspaceResourceId -split '/')[4]
$workspaceName = ($workspaceResourceId -split '/')[-1]

Write-Output "Getting log analytics workspace object"
$workspaceResource = Get-AzOperationalInsightsWorkspace -Name $workspaceName -ResourceGroupName $workspaceResourceGroupName

Write-Output "Getting network watchers"
$networkWatchers = Get-AzNetworkWatcher
Write-Output "Found $($networkWatchers.Count) network watchers"

foreach ($networkWatcher in $networkWatchers) {

  $networkWatcherResources += @{
    $networkWatcher.Location = $networkWatcher
  }
}

Write-Output "Getting netwotk security groups"
$networkSecurityGroups = Get-AzNetworkSecurityGroup
Write-Output "Found $($networkSecurityGroups.Count) netwotk security groups"

foreach ($networkSecurityGroup in $networkSecurityGroups) {

  $location = $networkSecurityGroup.Location
  $resourceId = $networkSecurityGroup.Id

  Write-Output "Processing network security group: $($networkSecurityGroup.Name)"
  Write-Output "Checking if network watcher flow log analytics is already enabled"

  $networkWatcherFlowLogStatus = Get-AzNetworkWatcherFlowLogStatus -NetworkWatcher $networkWatcherResources[$location] -TargetResourceId $resourceId

  if (!$networkWatcherFlowLogStatus.FlowAnalyticsConfiguration.networkWatcherFlowAnalyticsConfiguration.enabled) {

    Write-Output "Configuring network watcher flow log analytics for network security group: $($networkSecurityGroup.Name)"

    Set-AzNetworkWatcherConfigFlowLog -NetworkWatcher $networkWatcherResources[$location] -TargetResourceId $resourceId -EnableFlowLog $true `
      -StorageAccountId $storageAccountResourceIDs[$location] -EnableTrafficAnalytics -Workspace $workspaceResource -TrafficAnalyticsInterval 60
  }
  else {
    Write-Output "Network watcher flow log analytics is already enabled for network security group: $($networkSecurityGroup.Name)"
  }
}
