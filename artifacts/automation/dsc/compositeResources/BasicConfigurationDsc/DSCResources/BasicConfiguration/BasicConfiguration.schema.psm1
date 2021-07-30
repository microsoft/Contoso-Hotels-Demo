# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

Configuration BasicConfiguration
{
    Param
    (
        [String]$WorkspaceId,

        [String]$WorkspaceKey,

        [string]$NPMDPort = '8084',

        [string]$VirtualMemorySize = '12288'
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ComputerManagementDsc
    Import-DscResource -ModuleName NetworkingDsc
    Import-DscResource -ModuleName xPSDesiredStateConfiguration

    # LocalConfigurationManager
    # {
    #     RebootNodeIfNeeded = $true
    # }        

    # VirtualMemory PagingSettings
    # {
    #     Type        = 'CustomSize'
    #     Drive       = 'C'
    #     InitialSize = $VirtualMemorySize
    #     MaximumSize = $VirtualMemorySize
    # }        

    # PendingReboot AfterVirtualMemoryChange
    # {
    #     Name = 'AfterVirtualMemoryChange'
    #     SkipWindowsUpdate = $true
    #     SkipPendingFileRename = $true
    #     SkipCcmClientSDK = $false

    #     DependsOn = "[VirtualMemory]PagingSettings"
    # }

    Firewall NPMDFirewallRule
    {
        Name                  = 'NPMDFirewallRule'
        DisplayName           = 'NPMD Firewall port exception'
        Group                 = 'Network Performance Monitor'
        Enabled               = 'True'
        Direction             = 'InBound'
        Protocol              = 'TCP'
        LocalPort             = ($NPMDPort)
        Ensure                = 'Present'
    }
    
    Firewall NPMDICMPV4TimeExceeded
    {
        Name                  = 'NPMDICMPV4TimeExceeded'
        DisplayName           = 'NPMD ICMPv4 Time Exceeded'
        Group                 = 'Network Performance Monitor'
        Enabled               = 'True'
        Direction             = 'InBound'
        Protocol              = 'ICMPv4'
        IcmpType              = '11'
        Ensure                = 'Present'
    }

    Firewall NPMDICMPv4DestinationUnreachable
    {
        Name                  = 'NPMDICMPv4DestinationUnreachable'
        DisplayName           = 'NPMD ICMPv4 Destination Unreachable'
        Group                 = 'Network Performance Monitor'
        Enabled               = 'True'
        Direction             = 'InBound'
        Protocol              = 'ICMPv4'
        IcmpType              = '3'
        Ensure                = 'Present'
    }

    Firewall NPMDICMPV6TimeExceeded
    {
        Name                  = 'NPMDICMPV6TimeExceeded'
        DisplayName           = 'NPMD ICMPv6 Time Exceeded'
        Group                 = 'Network Performance Monitor'
        Enabled               = 'True'
        Direction             = 'InBound'
        Protocol              = 'ICMPv6'
        IcmpType              = '3'
        Ensure                = 'Present'
    }

    Firewall NPMDICMPv6DestinationUnreachable
    {
        Name                  = 'NPMDICMPv6DestinationUnreachable'
        DisplayName           = 'NPMD ICMPv6 Destination Unreachable'
        Group                 = 'Network Performance Monitor'
        Enabled               = 'True'
        Direction             = 'InBound'
        Protocol              = 'ICMPv6'
        IcmpType              = '1'
        Ensure                = 'Present'
    }

    Registry NPMD
    {
        Ensure      = "Present"
        Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NPMD"
        ValueName   = "PortNumber"
        ValueData   = "8084"
        ValueType   = "Dword"
    }   


    # if ($WorkspaceId -and $WorkspaceKey) {

    #     $TempFolder = "C:\temp"
    #     $OIPackageLocalPath = $TempFolder + '\MMASetup-AMD64.exe'
    #     $DAPackageLocalPath = $TempFolder + '\InstallDependencyAgent-Windows.exe'

    #     #Install Microsoft Monotoring Agent
    #     File CreateTempFolder 
    #     {
    #         Type = 'Directory'
    #         DestinationPath = $TempFolder
    #         Ensure = "Present"
    #     }

    #     xRemoteFile OIPackage 
    #     {
    #         Uri = "http://download.microsoft.com/download/0/C/0/0C072D6E-F418-4AD4-BCB2-A362624F400A/MMASetup-AMD64.exe"
    #         DestinationPath = $OIPackageLocalPath
    #         DependsOn = "[File]CreateTempFolder"
    #     }

    #     Package OI
    #     {
    #         Ensure = "Present"
    #         Path  = $OIPackageLocalPath
    #         Name = "Microsoft Monitoring Agent"
    #         ProductId = "8A7F2C51-4C7D-4BFD-9014-91D11F24AAE2"
    #         Arguments = '/C:"setup.exe /qn ADD_OPINSIGHTS_WORKSPACE=1 OPINSIGHTS_WORKSPACE_ID=' + $WorkspaceId + ' OPINSIGHTS_WORKSPACE_KEY=' + $WorkspaceKey + ' AcceptEndUserLicenseAgreement=1"'
    #         DependsOn = "[xRemoteFile]OIPackage"
    #     }            

    #     Service OIService
    #     {
    #         Name = "HealthService"
    #         State = "Running"
    #         DependsOn = "[Package]OI"
    #     }

    #     #Install Dependency Agent
    #     xRemoteFile DAPackage 
    #     {
    #         Uri = "https://aka.ms/dependencyagentwindows"
    #         DestinationPath = $DAPackageLocalPath
    #     }

    #     xPackage DA 
    #     {
    #         Ensure="Present"
    #         Name = "Dependency Agent"
    #         Path = $DAPackageLocalPath
    #         Arguments = '/S'
    #         ProductId = ""
    #         InstalledCheckRegKey = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\DependencyAgent"
    #         InstalledCheckRegValueName = "DisplayName"
    #         InstalledCheckRegValueData = "Dependency Agent"
    #         DependsOn = "[Service]OIService", "[xRemoteFile]DAPackage"
    #     }
    # }
}
