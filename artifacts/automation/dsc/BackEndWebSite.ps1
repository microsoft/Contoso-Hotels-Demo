# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

Configuration BackEndWebSite
{
	param
	(
		[Parameter(Mandatory)]
        [PSCredential] $AppPoolCredential,

		[Parameter(Mandatory)]
		[string]$SH360FilesSAName,

		[Parameter(Mandatory)]
		[PSCredential]$stagingSAKey,

		[Parameter(Mandatory)]
		[string]$SH360FilesContainerName,

		[Parameter(Mandatory)]
		[string]$SiteName,

		[Parameter(Mandatory)]
		[array]$ConfigReplacements,

		[Parameter(Mandatory)]
		[string]$AIKey
	)

    Import-DscResource -Module xWebAdministration, NetworkingDsc, ComputerManagementDsc, cAzureStorage
    Import-DscResource -ModuleName BasicConfigurationDsc

    $storageAccountKey = $stagingSAKey.GetNetworkCredential().Password

    Node localhost
    {

        BasicConfiguration ConfigVM
        {
            NPMDPort = '8084'
            VirtualMemorySize = '8192'
        }

        #Install the IIS Role
        WindowsFeature IIS
        {
            Ensure = “Present”
            Name = “Web-Server”

            DependsOn = "[BasicConfiguration]ConfigVM"
        }

        #Install ASP.NET 4.5
        WindowsFeature ASP
        {
            Ensure = “Present”
            Name = “Web-Asp-Net45”
            DependsOn = "[WindowsFeature]IIS"
        }

        WindowsFeature WebServerManagementConsole
        {
            Name = "Web-Mgmt-Console"
            Ensure = "Present"
            DependsOn = "[WindowsFeature]ASP"
        }

        WindowsFeature WebScriptingTools
        {
            Name = "Web-Scripting-Tools"
            Ensure = "Present"
            DependsOn = "[WindowsFeature]WebServerManagementConsole"
        }

        WindowsFeature HttpActivation
        {
            Name = "NET-WCF-HTTP-Activation45"
            Ensure = "Present"
            DependsOn = "[WindowsFeature]WebScriptingTools"
        }

        WindowsFeature WebHttpTracing
        {
            Name = "Web-Http-Tracing"
            Ensure = "Present"
            DependsOn = "[WindowsFeature]HttpActivation"
        }

        xWebAppPool CreateIisPool
        {
            Name = "sh360Pool"
            AutoStart = $true
            ManagedPipelineMode = "Integrated"
            ManagedRuntimeVersion = "v4.0"
            IdentityType = "SpecificUser"
            Credential = $AppPoolCredential
            Enable32BitAppOnWin64 = $false

            DependsOn = "[WindowsFeature]WebHttpTracing"
        }

        cAzureStorage DownloadFiles 
        {
            Path = "C:\inetpub\wwwroot\"
            StorageAccountName = $SH360FilesSAName
            StorageAccountContainer = $SH360FilesContainerName
            StorageAccountKey = $storageAccountKey
            Blob = $SiteName

            DependsOn = "[xWebAppPool]CreateIisPool"
        }

        Script ModifyWebConfig
        {
            SetScript = { 
                $configPath = "C:\inetpub\wwwroot\$using:SiteName\Web.config"
                $xml = [xml](Get-Content $configPath)
                foreach($replacement in $using:ConfigReplacements)
                {
                    $node = $xml.SelectSingleNode($replacement.ConfigXPath)
                    if($node -eq $null -or $node.NodeType -eq [System.Xml.XmlNodeType]::Element)
                    {
                        if($node -ne $null)
                        {
                            $node.ParentNode.RemoveChild($node)
                        }
                        $parentPath = (Split-Path $replacement.ConfigXPath -Parent) -replace '\\', '/'
                        $nodeName = Split-Path $replacement.ConfigXPath -Leaf
                        $parent = $xml.SelectSingleNode($parentPath)
                        $node = $xml.ImportNode(([xml]$replacement.ConfigValue).DocumentElement, $true)
                        $parent.AppendChild($node)
                    }
                    else
                    {
                        $node.Value = $replacement.ConfigValue
                    }
                }
                $xml.Save($configPath)
            }
            TestScript = { $false }
            GetScript = { @{ } }

            DependsOn = "[cAzureStorage]DownloadFiles"
        }

        Script ModifyAIConfig
        {
            SetScript = { 
                $configPath = "C:\inetpub\wwwroot\$using:SiteName\ApplicationInsights.config"
                if(Test-Path $configPath)
                {
                    $xml = [xml](Get-Content $configPath)

                    if($xml.ApplicationInsights.InstrumentationKey -eq $null)
                    {
                        $xml.ApplicationInsights.AppendChild($xml.CreateNode([System.Xml.XmlNodeType]::Element, 'InstrumentationKey', $xml.ApplicationInsights.NamespaceURI)).InnerText="$using:AIKey"
                    }
                    ($xml.ApplicationInsights.ChildNodes | where Name -EQ "InstrumentationKey").InnerText = "$using:AIKey"
                    $xml.Save($configPath)
                }
            }
            TestScript = { $false }
            GetScript = { @{ } }
            DependsOn = "[cAzureStorage]DownloadFiles"
        }


        Script InsertInstrumentationKey
        {
            GetScript = { return @{ 'Result' = $true } }
            TestScript = {
                $defaultPagePath = "C:\inetpub\wwwroot\$using:SiteName\Default.aspx"

                if (Test-Path $defaultPagePath) {
                    return ((Get-Content -Path $defaultPagePath -Raw) -match ('instrumentationKey:"' + $using:AIKey + '"'))
                }

                return $true
            }
            SetScript = {
                $defaultPagePath = "C:\inetpub\wwwroot\$using:SiteName\Default.aspx"

                if (Test-Path $defaultPagePath) {

                    ((Get-Content -Path "C:\inetpub\wwwroot\$using:SiteName\Default.aspx" -Raw) -replace 'INSTRUMENTATION_KEY', $using:AIKey) | Set-Content "C:\inetpub\wwwroot\$using:SiteName\Default.aspx"
                    ((Get-Content -Path "C:\inetpub\wwwroot\$using:SiteName\Checkin.aspx" -Raw) -replace 'INSTRUMENTATION_KEY', $using:AIKey) | Set-Content "C:\inetpub\wwwroot\$using:SiteName\Checkin.aspx"
                    ((Get-Content -Path "C:\inetpub\wwwroot\$using:SiteName\Checkout.aspx" -Raw) -replace 'INSTRUMENTATION_KEY', $using:AIKey) | Set-Content "C:\inetpub\wwwroot\$using:SiteName\Checkout.aspx"

                }
            }
            
            DependsOn = "[Script]ModifyAIConfig"
        }

        xWebSite CreateWebSite
        {
            Name = "Default Web Site"
            PhysicalPath = "C:\inetpub\wwwroot\$SiteName"
            ApplicationPool = "sh360Pool"
            
            DependsOn = "[Script]InsertInstrumentationKey"
        }


        Script EnableStatusMonitorV2
        {
            GetScript = { return @{ 'Result' = $true } }        
            TestScript = {
                Import-Module Az.ApplicationMonitor -ErrorVariable NotInstalled -ErrorAction SilentlyContinue
                return -not($NotInstalled)
            }
            SetScript = {
	            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 

                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
                Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
                Install-Module -Name PowerShellGet -Force

                $cmd = 'cmd /c start powershell -Command { Install-Module -Name Az.ApplicationMonitor -AcceptLicense -Force; Enable-ApplicationInsightsMonitoring -InstrumentationKey ' + $using:AIKey + ' -AcceptLicense }'

                Invoke-Expression $cmd
            }

            DependsOn = "[xWebSite]CreateWebSite"
        }
  }
}