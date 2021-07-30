# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

configuration EnsureFirewall
{
	param(
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
        [string]$ServiceName
    )


    Import-DscResource -ModuleName BasicConfigurationDsc

    Node localhost
    {
        BasicConfiguration ConfigVM
        {
            NPMDPort = '8084'
            VirtualMemorySize = '8192'
        }

        Service WindowsFirewall
        {
            Name        = $ServiceName
            StartupType = "Automatic"
            State       = "Running"
        }

    }
}