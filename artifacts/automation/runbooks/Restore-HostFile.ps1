# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

# This script is to help demo the Change Tracking feature.
# It and Update-HostFile when set on separate schedules separated by 123 hours
# will change and unchange the etc\hosts file.  This change
# will appear in the Change Tracking UX.

$hostspath = "C:\Windows\System32\drivers\etc\hosts"
$hostsoriginalpath = "C:\Windows\System32\drivers\etc\hosts.original"

if (Test-Path $hostsoriginalpath)
{
    # restore the original hosts file
    Copy-Item -Path $hostsoriginalpath -Destination $hostspath -Force
}
else
{
    # the hosts.original file does not exist so send error
    Write-Error "$hostsoriginalpath was not found.  Thus, the $hostspath has not been reverted to the original."
}

# Output the contents of the hosts file for reference
Get-Content "C:\Windows\System32\drivers\etc\hosts"
