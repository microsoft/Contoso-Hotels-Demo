# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

<# 

.DESCRIPTION

#> 

configuration InstallMonitoringAgents
{

    Import-DscResource -Module BasicConfigurationDsc

    Node $AllNodes.NodeName
    {
        #Enable Network Performance
        BasicConfiguration ConfigVM
        {
            NPMDPort = '8084'
            VirtualMemorySize = '8192'
            WorkspaceId = $Node.workspaceId
            WorkspaceKey = $Node.workspaceKey
        }

    }    
}