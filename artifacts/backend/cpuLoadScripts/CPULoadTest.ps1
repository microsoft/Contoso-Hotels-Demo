# Copyright (c) Microsoft Corporation.  
# Licensed under the MIT license.

param (

)

$cs = Get-WmiObject -class Win32_ComputerSystem
$Cores = $cs.numberoflogicalprocessors
$NumHyperCores = $Cores + 1 

foreach ($loopnumber in 1..$NumHyperCores) 
{
    Start-Job -ScriptBlock {

        $result=1;
        foreach ($loopnumber in 1..2147483647)
        {
            $result = 1
            foreach ($number in 1..2147483647) 
            {
                $result = $result * $number
            }
        }
    }
}

Get-Job | Wait-Job
Get-Job | Receive-Job
Remove-Job *