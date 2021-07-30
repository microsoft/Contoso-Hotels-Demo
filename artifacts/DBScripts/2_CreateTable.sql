-- Copyright (c) Microsoft Corporation.  
-- Licensed under the MIT license.

USE [SmartHotel.Registration]
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID('[dbo].[Bookings]'))

CREATE TABLE [dbo].[Bookings] (

    [Id]           INT            IDENTITY (1, 1) NOT NULL,

    [From]         DATETIME       NOT NULL,

    [To]           DATETIME       NOT NULL,

    [CustomerId]   NVARCHAR (MAX) NULL,

    [CustomerName] NVARCHAR (MAX) NULL,

    [Passport]     NVARCHAR (MAX) NULL,

    [Address]      NVARCHAR (MAX) NULL,

    [Amount]       INT            NOT NULL,

    [Total]        INT            NOT NULL,
    
    [CreditCard]     NVARCHAR (MAX)      NULL,
    [Floor]     INT     NOT NULL,   
    [RoomNumber]     INT   NOT NULL,      

    CONSTRAINT [PK_dbo.Bookings] PRIMARY KEY CLUSTERED ([Id] ASC)

);

