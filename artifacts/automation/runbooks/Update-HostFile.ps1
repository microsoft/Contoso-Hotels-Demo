# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

# This script is to help demo the Change Tracking feature.
# It and Restore-HostFile when set on separate schedules separated by 123 hours
# will change and unchange the etc\hosts file.  This change
# will appear in the Change Tracking UX.

$hostspath = "C:\Windows\System32\drivers\etc\hosts"
$hostschangedpath = "C:\Windows\System32\drivers\etc\hosts.changed"
$hostsoriginalpath = "C:\Windows\System32\drivers\etc\hosts.original"

if (!(Test-Path $hostsoriginalpath))
{
    # create the hosts.original file
    $contentoriginal = @"
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host
	42.66.22.42	backup.marketingserver.com	# backup server

# localhost name resolution is handled within DNS itself.
#	127.0.0.1       localhost
#	::1             localhost
"@
    
    New-Item $hostsoriginalpath -ItemType File -Value $contentoriginal -Force
}
if (!(Test-Path $hostschangedpath))
{
    # create the hosts.changed file
    $contentchanged = @"
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host
	42.66.22.33	backup.marketingserver.com	# backup server

# localhost name resolution is handled within DNS itself.
#	127.0.0.1       localhost
#	::1             localhost
"@

    New-Item $hostschangedpath -ItemType File -Value $contentchanged -Force
}

# replace hosts with hosts.changed
Copy-Item -Path $hostschangedpath -Destination $hostspath -Force

# output the contents of the hosts file for verification
Get-Content "C:\Windows\System32\drivers\etc\hosts"
