:: Copyright (c) Microsoft Corporation.  
:: Licensed under the MIT license.

:: JoeWare Netsess SMB Enumeration against ContosoDC
c:\tools\NetSess\NetSess.exe contosodc.contoso.azure
pause
:: DirectoryServiceEnumeration against NuckC
net user "NuckC" /domain
pause