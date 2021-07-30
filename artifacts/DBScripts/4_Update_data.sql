-- Copyright (c) Microsoft Corporation.  
-- Licensed under the MIT license.

USE [SmartHotel.Registration]
GO

update Bookings set floor = 1 where id <=10
update Bookings set floor = 2 where id > 10 and id <=20
update Bookings set floor = 3 where id > 20 and id <=30
update Bookings set floor = 4 where id > 30 and id <=40
update Bookings set floor = 5 where id > 40 and id <=50
update Bookings set floor = 6 where id > 50 and id <=60


DECLARE @i int = 0
WHILE @i < 60
BEGIN
    SET @i = @i + 1
    update Bookings set RoomNumber = @i where id  = @i
END


DECLARE @j int = 0;
DECLARE @CreditCard VARCHAR(50);
WHILE @j < 60
BEGIN
	SET @j = @j + 1
	SELECT @CreditCard = CAST(FLOOR(RAND()*(10000-1000)+1000) as varchar(4)) + '-' + CAST(FLOOR(RAND()*(10000-1000)+1000) as varchar(4)) + '-' + CAST(FLOOR(RAND()*(10000-1000)+1000) as varchar(4)) + '-' + CAST(FLOOR(RAND()*(10000-1000)+1000) as varchar(4))
	update Bookings set CreditCard = @CreditCard where id  = @j
END