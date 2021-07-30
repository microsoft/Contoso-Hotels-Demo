# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

param (
	[string]$scriptDirectory,
	[string]$scriptFileName,
	[string]$scheduledTaskName,
	[string]$delayBeforeStartTest
)

$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

New-Item -Path $scriptDirectory -ItemType Directory -Force
Copy-Item $executingScriptDirectory\$scriptFileName $scriptDirectory -Force

$user = "System"
$repeatingTrigger = New-JobTrigger -RandomDelay (New-TimeSpan -Seconds $delayBeforeStartTest) -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 2) -RepeatIndefinitely
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 30)
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Unrestricted -File $scriptDirectory\$scriptFileName"
$taskPath = "\Microsoft\Windows\PowerShell\ScheduledTasks"

Register-ScheduledTask -TaskName $scheduledTaskName -Trigger $repeatingTrigger -Settings $settings -Action $action -TaskPath $taskPath -RunLevel Highest -User $user