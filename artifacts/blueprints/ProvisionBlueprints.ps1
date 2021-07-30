# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license.

Param (
    [string]$location,
    [string]$primaryOpsRGName,
    [string]$appServiceName,
    [string]$appServicePlanName
)

$blueprints = @(
    @{
        Name = 'Simple';
        ToPublish = $false
    },
    @{
        Name = 'ContosoHotels';
        ToPublish = $true;
        Parameters = @{
            primaryOpsRGName = $primaryOpsRGName;
            primaryLocation = $location;
            appServiceName = $appServiceName;
            appServicePlanName = $appServicePlanName
        }
    }
)


Write-Output "Checking if module Az.Blueprint is already installed"
$azBlueprintModuleInstalled = Get-InstalledModule -Name Az.Blueprint -ErrorAction SilentlyContinue

if (!$azBlueprintModuleInstalled) {
    Write-Output "Installing module: Az.Blueprint"
    Install-Module -Name Az.Blueprint -Force -AcceptLicense
}

Write-Output "Checking if module Az.Blueprint is already imported"
$module = Get-Module -Name Az.Blueprint

if (!$module) {

    Write-Output "Importing module: Az.Blueprint"
    Import-Module -Name Az.Blueprint -Force
}

foreach ($blueprint in $blueprints) {

    Write-Output "Checking if blueprint $($blueprint.Name) exists in Azure"
    $blueprintObject = Get-AzBlueprint -Name $blueprint.Name -ErrorAction SilentlyContinue

    if ($blueprintObject) {

        Write-Output "Checking if $($blueprint.Name) blueprint has assignments"
        $assignments = Get-AzBlueprintAssignment | Where-Object Name -match "$($blueprint.Name)"

        if ($assignments) {
            $assignments | Remove-AzBlueprintAssignment -Verbose
            Start-Sleep -Seconds 10
        }

        Remove-AzResource -ResourceId $blueprintObject.Id -Force -Verbose
    }

    Write-Output "Importing blueprint with artifacts: $($blueprint.Name)"
    Import-AzBlueprintWithArtifact -Name $blueprint.Name -InputPath ".\$($blueprint.Name)" -Force -Verbose

    if ($blueprint.ToPublish) {

        Write-Output "Getting imported blueprint: $($blueprint.Name)"
        $blueprintObject = Get-AzBlueprint -Name $blueprint.Name -ErrorVariable NotFound -ErrorAction SilentlyContinue

        if ($blueprintObject) {

            $version = "1.0.0.0"
            $changeNote = "New blueprint"

            Write-Output "Publishing blueprint: $($blueprint.Name), version: $version"
            Publish-AzBlueprint -Blueprint $blueprintObject -Version $version -ChangeNote $changeNote -Verbose

            Write-Output "Creating new assignment in location: $location"
            $assignmentObject = New-AzBlueprintAssignment -Name $blueprint.Name -Blueprint $blueprintObject -Location $location -Parameter $blueprint.Parameters -ErrorAction Stop -Verbose

            Write-Output "Provisioning state: $($assignmentObject.ProvisioningState)"

            $attempt = 0
            $sleepTimeout = 10

            while ($assignmentObject.ProvisioningState -ne 'Succeeded' -and $assignmentObject.ProvisioningState -ne 'Failed' -and $attempt -lt 30) {

                Write-Output "Checking provisioning state in $sleepTimeout sec"
                Start-Sleep -Seconds $sleepTimeout

                $assignmentObject  = Get-AzBlueprintAssignment -Name $blueprint.Name
                Write-Output "Provisioning state: $($assignmentObject.ProvisioningState)"
            }

            if ($assignmentObject.ProvisioningState -eq 'Failed') {
                Throw "Provisioning failed"
            } elseif ($assignmentObject.ProvisioningState -ne 'Succeeded') {
                Write-Output "Checking timed out."
            }
        }
        else {
            Throw "Something went wrong. Couldn't get blueprint: $($blueprint.Name)"
        }
    }
}

