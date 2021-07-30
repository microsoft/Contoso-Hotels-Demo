# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

configuration CreateADDSForest
{
	param(
        [Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
        [string]$domainName,

        [Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
        [PSCredential]$domainCredential,

        [Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
        [string]$dbServerName,

        [Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
        [string]$primaryDbServerIpAddress,

        [Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
        [string]$secondaryDbServerIpAddress
    )

    Import-DscResource -ModuleName ActiveDirectoryDsc
    Import-DscResource -ModuleName xDnsServer
    Import-DscResource -ModuleName BasicConfigurationDsc

    Node localhost
    {

        #Enable Network Performance Monitor
        BasicConfiguration ConfigVM
        {
            NPMDPort = '8084'
            VirtualMemorySize = '8192'
        }

        WindowsFeature ADDS
        {
            Name   = 'AD-Domain-Services'
            Ensure = 'Present'

            DependsOn = "[BasicConfiguration]ConfigVM"
        }

        WindowsFeature RSAT
        {
            Name   = 'RSAT-AD-PowerShell'
            Ensure = 'Present'
        }

        ADDomain CreateADDSForest
        {
            DomainName                    = $domainName
            Credential                    = $domainCredential
            SafemodeAdministratorPassword = $domainCredential
            ForestMode                    = 'WinThreshold'

            DependsOn = "[WindowsFeature]ADDS", "[WindowsFeature]RSAT"
        }

        xDnsServerForwarder SetDNSForwarder
        {
	        IsSingleInstance = 'Yes'
            IPAddresses = '168.63.129.16', '8.8.8.8'
            
            DependsOn = "[ADDomain]CreateADDSForest"
        }

        xDnsRecord 'AddPrimaryDbServerRecord'
        {
            Name   = $dbServerName
            Target = $primaryDbServerIpAddress
            Zone   = $domainName
            Type   = 'ARecord'
            Ensure = 'Present'

            DependsOn = "[ADDomain]CreateADDSForest"
        }

        xDnsRecord 'AddSecondaryDbServerRecord'
        {
            Name   = $dbServerName
            Target = $secondaryDbServerIpAddress
            Zone   = $domainName
            Type   = 'ARecord'
            Ensure = 'Present'

            DependsOn = "[ADDomain]CreateADDSForest"
        }

        ADUser SetPasswordToNeverExpires
        {
            Ensure = "Present"
            DomainName = $domainName
            UserName = ($domainCredential.UserName -split '@')[0]
            PasswordNeverExpires = $true
            Credential = $domainCredential

            DependsOn = "[ADDomain]CreateADDSForest"
        }        
    }
}
