# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

configuration AddDCtoDomain
{
	param(
        [Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
        [string]$DomainName,

        [Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
        [PSCredential]$DomainCredential
    )

    Import-DscResource -ModuleName ActiveDirectoryDsc
    Import-DscResource -ModuleName BasicConfigurationDsc

    Node localhost
    {

        BasicConfiguration ConfigVM
        {
            NPMDPort = '8084'
            VirtualMemorySize = '8192'
        }

        WindowsFeature ADDS
        {
            Name   = 'AD-Domain-Services'
            Ensure = 'Present'

            DependsOn  = '[BasicConfiguration]ConfigVM'
        }

        WindowsFeature RSAT
        {
            Name   = 'RSAT-AD-PowerShell'
            Ensure = 'Present'
        }

        WaitForADDomain WaitForestAvailability
        {
            DomainName = $domainName
            Credential = $domainCredential

            DependsOn  = '[WindowsFeature]RSAT', '[WindowsFeature]ADDS'
        }

        ADDomainController AddDCtoDomain
        {
            DomainName                    = $domainName
            Credential                    = $domainCredential
            SafeModeAdministratorPassword = $domainCredential

            DependsOn                     = '[WaitForADDomain]WaitForestAvailability'
        }
    }
}