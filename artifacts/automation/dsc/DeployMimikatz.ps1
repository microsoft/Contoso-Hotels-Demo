# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

configuration DeployMimikatz
{
	param(
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
        [string]$_artifactsStorageAccountName,

        [Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
        [string]$privateArtifactsContainer,

        [Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
        [PSCredential]$stagingSAKey,

        [Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
        [string]$securityResearchToolsBlob
    )

    Import-DscResource -ModuleName cAzureStorage
    Import-DscResource -ModuleName ComputerManagementDsc
    Import-DscResource -ModuleName BasicConfigurationDsc

    $storageAccountKey = $stagingSAKey.GetNetworkCredential().Password

    $tempFolder = "C:\temp"

    Node localhost
    {

        BasicConfiguration ConfigVM
        {
            NPMDPort = '8084'
            VirtualMemorySize = '8192'
        }

        Script DisableWindowsDefender
        {
            SetScript = { Set-MpPreference -DisableRealtimeMonitoring $true }
            TestScript = { (Get-MpPreference).DisableRealtimeMonitoring }
            GetScript = { return @{ 'Result' = $true } }
        }

        File CreateTempFolder {
            Type = 'Directory'
            DestinationPath = $tempFolder
            Ensure = "Present"
        }

        cAzureStorage CopyMimikatzDemoArtifacts
        {
            Path = $tempFolder
            StorageAccountName = $_artifactsStorageAccountName
            StorageAccountContainer = $privateArtifactsContainer
            StorageAccountKey = $storageAccountKey
            Blob = $securityResearchToolsBlob

            DependsOn = "[Script]DisableWindowsDefender", "[File]CreateTempFolder"
        }

        File CopyScripts
        {
            Ensure = "Present"
            Type = "Directory"
            Recurse = $true
            SourcePath = "$tempFolder\mimikatzDemoArtifacts\att&ck"
            DestinationPath = "C:\att&ck"

            DependsOn = "[cAzureStorage]CopyMimikatzDemoArtifacts"
        }

        File EnsureBackupFolder
        {
            Type = 'Directory'
            DestinationPath = 'C:\Tools\Backup'
        }

        Script GetMimikatz
        {
            SetScript = {
                $r = Invoke-WebRequest -Uri 'https://github.com/gentilkiwi/mimikatz/releases/latest' -UseBasicParsing
                $uri = "$($r.BaseResponse.ResponseUri.AbsoluteUri.Replace('tag', 'download'))/mimikatz_trunk.zip"
                Invoke-WebRequest -Uri $uri -OutFile 'C:\Tools\Backup\Mimikatz.zip'
            }
            TestScript = {
                return (Test-Path 'C:\Tools\Backup\Mimikatz.zip')
            }
            GetScript = {
                return (Test-Path 'C:\Tools\Backup\Mimikatz.zip')
            }

            DependsOn = "[Script]DisableWindowsDefender", "[File]EnsureBackupFolder"
        }

        Archive UnzipMimikatz
        {
            Path = 'C:\Tools\Backup\Mimikatz.zip'
            Destination = 'C:\Tools\Mimikatz'
            Ensure = 'Present'
            Force = $true
            DependsOn = '[Script]GetMimikatz'
        }

        # File CopyTools
        # {
        #     Ensure = "Present"
        #     Type = "Directory"
        #     Recurse = $true
        #     SourcePath = "$tempFolder\mimikatzDemoArtifacts\tools"
        #     DestinationPath = "C:\tools"

        #     DependsOn = "[cAzureStorage]CopyMimikatzDemoArtifacts"
        # }

        ScheduledTask ScheduleHarvestVictimPcAttack
        {
            TaskName           = 'Harvest VictimPc Attack'
            TaskPath           = '\mimikatzDemo'
            ActionExecutable   = '"C:\att&ck\1. LateralMovement\0. HarvestVictimPcNoPause.bat"'
            ScheduleType       = 'Once'
            RepeatInterval     = '01:00:00'
            RepetitionDuration = 'Indefinitely'

            DependsOn = "[File]CopyScripts"
        }  
    }
}