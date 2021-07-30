-- Copyright (c) Microsoft Corporation.  
-- Licensed under the MIT license.

USE master
GO
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE Name = 'SmartHotel.Registration')
CREATE DATABASE [SmartHotel.Registration]
