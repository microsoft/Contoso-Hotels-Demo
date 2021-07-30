:: Copyright (c) Microsoft Corporation.  
:: Licensed under the MIT license.

:: domain users
net user /domain
pause
:: domain groups
net group /domain
pause
:: domain admins
net group "domain admins" /domain
pause
:: enterprise admins
net group "enterprise admins" /domain
pause