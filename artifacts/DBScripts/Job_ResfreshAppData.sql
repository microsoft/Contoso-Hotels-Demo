-- Copyright (c) Microsoft Corporation.  
-- Licensed under the MIT license.

USE [msdb]
GO

IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE name =  'Refresh SH360 App data')
EXEC msdb.dbo.sp_delete_job @job_name='Refresh SH360 App data', @delete_unused_schedule=1

/****** Object:  Job [Refresh SH360 App data]    Script Date: 11/12/2018 5:14:20 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [SH360]    Script Date: 11/12/2018 5:14:20 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'SH360' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'SH360'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Refresh SH360 App data', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'SH360', 
		@job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Truncate table]    Script Date: 11/12/2018 5:14:20 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Truncate table', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'TRUNCATE TABLE [dbo].[Bookings]', 
		@database_name=N'SmartHotel.Registration', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Fill table]    Script Date: 11/12/2018 5:14:20 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Fill table', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE [SmartHotel.Registration]
GO



DECLARE @cnt INT = 0;



DECLARE @Passport TABLE (Passport INT)

INSERT INTO @Passport VALUES (''2850168'')

INSERT INTO @Passport VALUES (''315123188'')

INSERT INTO @Passport VALUES (''176178376'')

INSERT INTO @Passport VALUES (''103087374'')

INSERT INTO @Passport VALUES (''28730664'')

INSERT INTO @Passport VALUES (''954305874'')

INSERT INTO @Passport VALUES (''972946143'')

INSERT INTO @Passport VALUES (''708685087'')

INSERT INTO @Passport VALUES (''861722896'')

INSERT INTO @Passport VALUES (''679997300'')

INSERT INTO @Passport VALUES (''867400639'')

INSERT INTO @Passport VALUES (''760800297'')

INSERT INTO @Passport VALUES (''964981996'')

INSERT INTO @Passport VALUES (''743019257'')

INSERT INTO @Passport VALUES (''361760285'')

INSERT INTO @Passport VALUES (''287353229'')

INSERT INTO @Passport VALUES (''587597740'')

INSERT INTO @Passport VALUES (''818357333'')

INSERT INTO @Passport VALUES (''778277744'')

INSERT INTO @Passport VALUES (''895820208'')

INSERT INTO @Passport VALUES (''28730664'')

INSERT INTO @Passport VALUES (''954305874'')

INSERT INTO @Passport VALUES (''972946143'')

INSERT INTO @Passport VALUES (''708685087'')

INSERT INTO @Passport VALUES (''861722896'')

INSERT INTO @Passport VALUES (''679997300'')

INSERT INTO @Passport VALUES (''867400639'')

INSERT INTO @Passport VALUES (''760800297'')

INSERT INTO @Passport VALUES (''964981996'')

INSERT INTO @Passport VALUES (''743019257'')

INSERT INTO @Passport VALUES (''361760285'')

INSERT INTO @Passport VALUES (''287353229'')

INSERT INTO @Passport VALUES (''587597740'')

INSERT INTO @Passport VALUES (''818357333'')

INSERT INTO @Passport VALUES (''28730664'')

INSERT INTO @Passport VALUES (''954305874'')

INSERT INTO @Passport VALUES (''972946143'')

INSERT INTO @Passport VALUES (''708685087'')

INSERT INTO @Passport VALUES (''861722896'')

INSERT INTO @Passport VALUES (''679997300'')

INSERT INTO @Passport VALUES (''867400639'')

INSERT INTO @Passport VALUES (''760800297'')

INSERT INTO @Passport VALUES (''964981996'')

INSERT INTO @Passport VALUES (''743019257'')

INSERT INTO @Passport VALUES (''361760285'')

INSERT INTO @Passport VALUES (''287353229'')

INSERT INTO @Passport VALUES (''587597740'')

INSERT INTO @Passport VALUES (''818357333'')

INSERT INTO @Passport VALUES (''28730664'')

INSERT INTO @Passport VALUES (''954305874'')

INSERT INTO @Passport VALUES (''972946143'')

INSERT INTO @Passport VALUES (''708685087'')

INSERT INTO @Passport VALUES (''861722896'')

INSERT INTO @Passport VALUES (''679997300'')

INSERT INTO @Passport VALUES (''867400639'')

INSERT INTO @Passport VALUES (''760800297'')

INSERT INTO @Passport VALUES (''964981996'')

INSERT INTO @Passport VALUES (''743019257'')

INSERT INTO @Passport VALUES (''361760285'')

INSERT INTO @Passport VALUES (''287353229'')

INSERT INTO @Passport VALUES (''587597740'')

INSERT INTO @Passport VALUES (''818357333'')

INSERT INTO @Passport VALUES (''28730664'')

INSERT INTO @Passport VALUES (''954305874'')

INSERT INTO @Passport VALUES (''972946143'')

INSERT INTO @Passport VALUES (''708685087'')

INSERT INTO @Passport VALUES (''861722896'')

INSERT INTO @Passport VALUES (''679997300'')

INSERT INTO @Passport VALUES (''867400639'')

INSERT INTO @Passport VALUES (''760800297'')

INSERT INTO @Passport VALUES (''964981996'')

INSERT INTO @Passport VALUES (''743019257'')

INSERT INTO @Passport VALUES (''361760285'')

INSERT INTO @Passport VALUES (''287353229'')

INSERT INTO @Passport VALUES (''587597740'')

INSERT INTO @Passport VALUES (''818357333'')

INSERT INTO @Passport VALUES (''28730664'')

INSERT INTO @Passport VALUES (''954305874'')

INSERT INTO @Passport VALUES (''972946143'')

INSERT INTO @Passport VALUES (''708685087'')

INSERT INTO @Passport VALUES (''861722896'')

INSERT INTO @Passport VALUES (''679997300'')

INSERT INTO @Passport VALUES (''867400639'')

INSERT INTO @Passport VALUES (''760800297'')

INSERT INTO @Passport VALUES (''964981996'')

INSERT INTO @Passport VALUES (''743019257'')

INSERT INTO @Passport VALUES (''361760285'')

INSERT INTO @Passport VALUES (''287353229'')

INSERT INTO @Passport VALUES (''587597740'')

INSERT INTO @Passport VALUES (''818357333'')

INSERT INTO @Passport VALUES (''28730664'')

INSERT INTO @Passport VALUES (''954305874'')

INSERT INTO @Passport VALUES (''972946143'')

INSERT INTO @Passport VALUES (''708685087'')

INSERT INTO @Passport VALUES (''861722896'')

INSERT INTO @Passport VALUES (''679997300'')

INSERT INTO @Passport VALUES (''867400639'')

INSERT INTO @Passport VALUES (''760800297'')

INSERT INTO @Passport VALUES (''964981996'')

INSERT INTO @Passport VALUES (''743019257'')

INSERT INTO @Passport VALUES (''361760285'')

INSERT INTO @Passport VALUES (''287353229'')

INSERT INTO @Passport VALUES (''587597740'')

INSERT INTO @Passport VALUES (''818357333'')

INSERT INTO @Passport VALUES (''28730664'')

INSERT INTO @Passport VALUES (''954305874'')

INSERT INTO @Passport VALUES (''972946143'')

INSERT INTO @Passport VALUES (''708685087'')

INSERT INTO @Passport VALUES (''861722896'')

INSERT INTO @Passport VALUES (''679997300'')

INSERT INTO @Passport VALUES (''867400639'')

INSERT INTO @Passport VALUES (''760800297'')

INSERT INTO @Passport VALUES (''964981996'')

INSERT INTO @Passport VALUES (''743019257'')

INSERT INTO @Passport VALUES (''361760285'')

INSERT INTO @Passport VALUES (''287353229'')

INSERT INTO @Passport VALUES (''587597740'')

INSERT INTO @Passport VALUES (''818357333'')

INSERT INTO @Passport VALUES (''28730664'')

INSERT INTO @Passport VALUES (''954305874'')

INSERT INTO @Passport VALUES (''972946143'')

INSERT INTO @Passport VALUES (''708685087'')

INSERT INTO @Passport VALUES (''861722896'')

INSERT INTO @Passport VALUES (''679997300'')

INSERT INTO @Passport VALUES (''867400639'')

INSERT INTO @Passport VALUES (''760800297'')

INSERT INTO @Passport VALUES (''964981996'')

INSERT INTO @Passport VALUES (''743019257'')

INSERT INTO @Passport VALUES (''361760285'')

INSERT INTO @Passport VALUES (''287353229'')

INSERT INTO @Passport VALUES (''587597740'')

INSERT INTO @Passport VALUES (''818357333'')

INSERT INTO @Passport VALUES (''28730664'')

INSERT INTO @Passport VALUES (''954305874'')

INSERT INTO @Passport VALUES (''972946143'')

INSERT INTO @Passport VALUES (''708685087'')

INSERT INTO @Passport VALUES (''861722896'')

INSERT INTO @Passport VALUES (''679997300'')

INSERT INTO @Passport VALUES (''867400639'')

INSERT INTO @Passport VALUES (''760800297'')

INSERT INTO @Passport VALUES (''964981996'')

INSERT INTO @Passport VALUES (''743019257'')

INSERT INTO @Passport VALUES (''361760285'')

INSERT INTO @Passport VALUES (''287353229'')

INSERT INTO @Passport VALUES (''587597740'')

INSERT INTO @Passport VALUES (''818357333'')

INSERT INTO @Passport VALUES (''28730664'')

INSERT INTO @Passport VALUES (''954305874'')

INSERT INTO @Passport VALUES (''972946143'')

INSERT INTO @Passport VALUES (''708685087'')

INSERT INTO @Passport VALUES (''861722896'')

INSERT INTO @Passport VALUES (''679997300'')

INSERT INTO @Passport VALUES (''867400639'')

INSERT INTO @Passport VALUES (''760800297'')

INSERT INTO @Passport VALUES (''964981996'')

INSERT INTO @Passport VALUES (''743019257'')

INSERT INTO @Passport VALUES (''361760285'')

INSERT INTO @Passport VALUES (''287353229'')

INSERT INTO @Passport VALUES (''587597740'')

INSERT INTO @Passport VALUES (''818357333'')

INSERT INTO @Passport VALUES (''28730664'')

INSERT INTO @Passport VALUES (''954305874'')

INSERT INTO @Passport VALUES (''972946143'')

INSERT INTO @Passport VALUES (''708685087'')

INSERT INTO @Passport VALUES (''861722896'')

INSERT INTO @Passport VALUES (''679997300'')

INSERT INTO @Passport VALUES (''867400639'')

INSERT INTO @Passport VALUES (''760800297'')

INSERT INTO @Passport VALUES (''964981996'')

INSERT INTO @Passport VALUES (''743019257'')

INSERT INTO @Passport VALUES (''361760285'')

INSERT INTO @Passport VALUES (''287353229'')

INSERT INTO @Passport VALUES (''587597740'')

INSERT INTO @Passport VALUES (''818357333'')





DECLARE @List TABLE (CustomerName varchar(100))

INSERT INTO @List VALUES (''Sophie Stevenson'')

INSERT INTO @List VALUES (''Louisa Lane'')

INSERT INTO @List VALUES (''Jim McKenzie'')

INSERT INTO @List VALUES (''Micheal Estrada'')

INSERT INTO @List VALUES (''Bessie Swanson'')

INSERT INTO @List VALUES (''Ray Garner'')

INSERT INTO @List VALUES (''Lydia Obrien'')

INSERT INTO @List VALUES (''Jacob Powers'')

INSERT INTO @List VALUES (''Ryan Dunn'')

INSERT INTO @List VALUES (''Alexander Harrington'')

INSERT INTO @List VALUES (''Nathaniel Fitzgerald'')

INSERT INTO @List VALUES (''Olivia Cohen'')

INSERT INTO @List VALUES (''Martin Todd'')

INSERT INTO @List VALUES (''Darrell Russell'')

INSERT INTO @List VALUES (''Russell Stevenson'')

INSERT INTO @List VALUES (''Jason McCoy'')

INSERT INTO @List VALUES (''Elijah Rodriquez'')

INSERT INTO @List VALUES (''Augusta Meyer'')

INSERT INTO @List VALUES (''Hattie Baker'')

INSERT INTO @List VALUES (''Joe Fitzgerald'')

INSERT INTO @List VALUES (''Christina Gregory'')

INSERT INTO @List VALUES (''Elizabeth Lowe'')

INSERT INTO @List VALUES (''Tillie Hopkins'')

INSERT INTO @List VALUES (''Barry Hawkins'')

INSERT INTO @List VALUES (''Dorothy Roberts'')

INSERT INTO @List VALUES (''Bradley Ross'')

INSERT INTO @List VALUES (''Florence Collins'')

INSERT INTO @List VALUES (''Olive Buchanan'')

INSERT INTO @List VALUES (''Viola Graham'')

INSERT INTO @List VALUES (''Gary Murray'')

INSERT INTO @List VALUES (''Mike Porter'')

INSERT INTO @List VALUES (''Vera Gilbert'')

INSERT INTO @List VALUES (''Harold Roy'')

INSERT INTO @List VALUES (''Marcus Watson'')

INSERT INTO @List VALUES (''Adelaide Sparks'')

INSERT INTO @List VALUES (''Steven Martin'')

INSERT INTO @List VALUES (''Pauline Wallace'')

INSERT INTO @List VALUES (''Devin Stone'')

INSERT INTO @List VALUES (''Roy Marshall'')

INSERT INTO @List VALUES (''Curtis Wilkerson'')

INSERT INTO @List VALUES (''Callie Gonzalez'')

INSERT INTO @List VALUES (''Emma Bryant'')

INSERT INTO @List VALUES (''Bertie Russell'')

INSERT INTO @List VALUES (''Glenn Manning'')

INSERT INTO @List VALUES (''Barbara Reid'')

INSERT INTO @List VALUES (''Millie Strickland'')

INSERT INTO @List VALUES (''Estella Hammond'')

INSERT INTO @List VALUES (''Tommy Nguyen'')

INSERT INTO @List VALUES (''Billy Moss'')

INSERT INTO @List VALUES (''Nelle Greene'')

INSERT INTO @List VALUES (''Helena Hernandez'')

INSERT INTO @List VALUES (''Louis Cooper'')

INSERT INTO @List VALUES (''Mathilda Yates'')

INSERT INTO @List VALUES (''Marcus Hodges'')

INSERT INTO @List VALUES (''Lou Bishop'')

INSERT INTO @List VALUES (''Randall Dawson'')

INSERT INTO @List VALUES (''Edgar Snyder'')

INSERT INTO @List VALUES (''Estelle Leonard'')

INSERT INTO @List VALUES (''Lizzie Keller'')

INSERT INTO @List VALUES (''Elizabeth Guerrero'')

INSERT INTO @List VALUES (''Ida Banks'')

INSERT INTO @List VALUES (''Herman Tyler'')

INSERT INTO @List VALUES (''Mollie Spencer'')

INSERT INTO @List VALUES (''Mollie Patterson'')

INSERT INTO @List VALUES (''Clifford Munoz'')

INSERT INTO @List VALUES (''Edwin Phelps'')

INSERT INTO @List VALUES (''Rhoda Powers'')

INSERT INTO @List VALUES (''Maurice Munoz'')

INSERT INTO @List VALUES (''Marc Lee'')

INSERT INTO @List VALUES (''Corey Cobb'')

INSERT INTO @List VALUES (''Sally McBride'')

INSERT INTO @List VALUES (''Lena Stevens'')

INSERT INTO @List VALUES (''Susie Franklin'')

INSERT INTO @List VALUES (''Gordon Rhodes'')

INSERT INTO @List VALUES (''Elizabeth Douglas'')

INSERT INTO @List VALUES (''Sarah Rogers'')

INSERT INTO @List VALUES (''Elizabeth Greer'')

INSERT INTO @List VALUES (''Jeffrey Diaz'')

INSERT INTO @List VALUES (''Mason Fuller'')

INSERT INTO @List VALUES (''Ollie Cook'')

INSERT INTO @List VALUES (''Lester Grant'')

INSERT INTO @List VALUES (''Jeremy Norris'')

INSERT INTO @List VALUES (''Alejandro Fowler'')

INSERT INTO @List VALUES (''Johanna Castillo'')

INSERT INTO @List VALUES (''Isaac Burke'')

INSERT INTO @List VALUES (''Lucile Kelley'')

INSERT INTO @List VALUES (''Ethel Armstrong'')

INSERT INTO @List VALUES (''Curtis Watts'')

INSERT INTO @List VALUES (''Olivia Chapman'')

INSERT INTO @List VALUES (''Ora Casey'')

INSERT INTO @List VALUES (''Iva Rhodes'')

INSERT INTO @List VALUES (''Vincent Wilkerson'')

INSERT INTO @List VALUES (''Johanna Dunn'')

INSERT INTO @List VALUES (''Eleanor Hammond'')

INSERT INTO @List VALUES (''Arthur Townsend'')

INSERT INTO @List VALUES (''Lettie Sandoval'')

INSERT INTO @List VALUES (''Susan Gomez'')

INSERT INTO @List VALUES (''Trevor Adkins'')

INSERT INTO @List VALUES (''Annie Dean'')

INSERT INTO @List VALUES (''Eric McGuire'')

INSERT INTO @List VALUES (''Dominic Brock'')

INSERT INTO @List VALUES (''Gary Hammond'')

INSERT INTO @List VALUES (''Bernice Stewart'')

INSERT INTO @List VALUES (''Maria Gordon'')

INSERT INTO @List VALUES (''Rosa Gonzalez'')

INSERT INTO @List VALUES (''Lettie Griffin'')

INSERT INTO @List VALUES (''Jessie Burton'')

INSERT INTO @List VALUES (''Susie Rodgers'')

INSERT INTO @List VALUES (''Jorge Powers'')

INSERT INTO @List VALUES (''Charlie Foster'')

INSERT INTO @List VALUES (''Owen Gray'')

INSERT INTO @List VALUES (''Lettie Dunn'')

INSERT INTO @List VALUES (''Dorothy Martinez'')

INSERT INTO @List VALUES (''Grace Lane'')

INSERT INTO @List VALUES (''Kate Erickson'')

INSERT INTO @List VALUES (''Nathaniel Reyes'')

INSERT INTO @List VALUES (''Fanny Morton'')

INSERT INTO @List VALUES (''Edith Hernandez'')

INSERT INTO @List VALUES (''Anne Fowler'')

INSERT INTO @List VALUES (''Francis Fox'')

INSERT INTO @List VALUES (''Rhoda Schwartz'')

INSERT INTO @List VALUES (''Stella Schultz'')

INSERT INTO @List VALUES (''Shawn Strickland'')

INSERT INTO @List VALUES (''Louis Mullins'')

INSERT INTO @List VALUES (''Adeline Collier'')

INSERT INTO @List VALUES (''Jim Turner'')

INSERT INTO @List VALUES (''Peter Bowers'')

INSERT INTO @List VALUES (''Eugene Frank'')

INSERT INTO @List VALUES (''Sylvia Wright'')

INSERT INTO @List VALUES (''Martha Gregory'')

INSERT INTO @List VALUES (''Nettie Morton'')

INSERT INTO @List VALUES (''Dorothy Douglas'')

INSERT INTO @List VALUES (''Ralph Harvey'')

INSERT INTO @List VALUES (''Josephine Collins'')

INSERT INTO @List VALUES (''Logan Moreno'')

INSERT INTO @List VALUES (''Albert Lindsey'')

INSERT INTO @List VALUES (''Jared Cobb'')

INSERT INTO @List VALUES (''Christine Oliver'')

INSERT INTO @List VALUES (''Troy Osborne'')

INSERT INTO @List VALUES (''Loretta Carpenter'')

INSERT INTO @List VALUES (''Sue Holmes'')

INSERT INTO @List VALUES (''Caroline Allen'')

INSERT INTO @List VALUES (''Della Day'')

INSERT INTO @List VALUES (''Delia Keller'')

INSERT INTO @List VALUES (''Adelaide Yates'')

INSERT INTO @List VALUES (''Jorge Schwartz'')

INSERT INTO @List VALUES (''Ina Dennis'')

INSERT INTO @List VALUES (''Rena Welch'')

INSERT INTO @List VALUES (''Marcus Palmer'')

INSERT INTO @List VALUES (''Cole Henderson'')

INSERT INTO @List VALUES (''Annie Blair'')

INSERT INTO @List VALUES (''Don Strickland'')

INSERT INTO @List VALUES (''Alfred Tucker'')

INSERT INTO @List VALUES (''Ernest Thomas'')

INSERT INTO @List VALUES (''Jay Buchanan'')

INSERT INTO @List VALUES (''Donald Brock'')

INSERT INTO @List VALUES (''Owen Gonzalez'')

INSERT INTO @List VALUES (''Ola Singleton'')

INSERT INTO @List VALUES (''Lewis Silva'')

INSERT INTO @List VALUES (''Ray Owen'')

INSERT INTO @List VALUES (''Corey Greer'')

INSERT INTO @List VALUES (''Leon Harrington'')

INSERT INTO @List VALUES (''Lilly Garcia'')

INSERT INTO @List VALUES (''Winifred Hale'')

INSERT INTO @List VALUES (''Adeline Greene'')

INSERT INTO @List VALUES (''Elnora Castro'')

INSERT INTO @List VALUES (''Amy Hart'')

INSERT INTO @List VALUES (''Eugenia McGee'')

INSERT INTO @List VALUES (''Ryan Silva'')

INSERT INTO @List VALUES (''Chris May'')

INSERT INTO @List VALUES (''Etta Harrison'')

INSERT INTO @List VALUES (''Ivan Nguyen'')

INSERT INTO @List VALUES (''Aaron Swanson'')

INSERT INTO @List VALUES (''Birdie Hill'')

INSERT INTO @List VALUES (''Virginia Parks'')

INSERT INTO @List VALUES (''James Lawson'')

INSERT INTO @List VALUES (''Fred Franklin'')

INSERT INTO @List VALUES (''Lillie Goodwin'')

INSERT INTO @List VALUES (''Alexander Snyder'')

INSERT INTO @List VALUES (''Cora Hines'')

INSERT INTO @List VALUES (''Cecelia McDaniel'')

INSERT INTO @List VALUES (''Martha Duncan'')

INSERT INTO @List VALUES (''Ella Kennedy'')

INSERT INTO @List VALUES (''Craig Padilla'')

INSERT INTO @List VALUES (''Hannah Black'')

INSERT INTO @List VALUES (''Frances Swanson'')

INSERT INTO @List VALUES (''Ada Floyd'')

INSERT INTO @List VALUES (''Ruth Neal'')

INSERT INTO @List VALUES (''Bernice Hawkins'')

INSERT INTO @List VALUES (''Fanny Payne'')

INSERT INTO @List VALUES (''Christian Floyd'')

INSERT INTO @List VALUES (''Clayton Mann'')

INSERT INTO @List VALUES (''Amy Berry'')

INSERT INTO @List VALUES (''Caroline Carter'')

INSERT INTO @List VALUES (''Alvin Lopez'')

INSERT INTO @List VALUES (''Jared Swanson'')

INSERT INTO @List VALUES (''Seth Spencer'')

INSERT INTO @List VALUES (''Dennis Dixon'')

INSERT INTO @List VALUES (''Michael Harvey'')

INSERT INTO @List VALUES (''Augusta Hansen'')

INSERT INTO @List VALUES (''Jay Weaver'')

INSERT INTO @List VALUES (''Lela Pittman'')

INSERT INTO @List VALUES (''Amanda Steele'')

INSERT INTO @List VALUES (''Winnie Wong'')

INSERT INTO @List VALUES (''Amanda Atkins'')

INSERT INTO @List VALUES (''Marc Vasquez'')

INSERT INTO @List VALUES (''Janie Gonzalez'')

INSERT INTO @List VALUES (''Lewis Wagner'')

INSERT INTO @List VALUES (''Marie Norman'')

INSERT INTO @List VALUES (''Charles Anderson'')

INSERT INTO @List VALUES (''Lloyd Knight'')

INSERT INTO @List VALUES (''Callie Ruiz'')

INSERT INTO @List VALUES (''Gertrude Parsons'')

INSERT INTO @List VALUES (''Derek Day'')

INSERT INTO @List VALUES (''George Sharp'')

INSERT INTO @List VALUES (''Russell Salazar'')

INSERT INTO @List VALUES (''Matthew Fox'')

INSERT INTO @List VALUES (''Ollie Soto'')

INSERT INTO @List VALUES (''Jessie Holmes'')

INSERT INTO @List VALUES (''Louis Rivera'')

INSERT INTO @List VALUES (''Hunter Delgado'')

INSERT INTO @List VALUES (''Nellie Cummings'')

INSERT INTO @List VALUES (''Chad Jefferson'')

INSERT INTO @List VALUES (''Ronnie Barber'')

INSERT INTO @List VALUES (''Jayden Brewer'')

INSERT INTO @List VALUES (''Timothy Wolfe'')

INSERT INTO @List VALUES (''Gordon Terry'')

INSERT INTO @List VALUES (''Cole Cohen'')

INSERT INTO @List VALUES (''Loretta McKinney'')

INSERT INTO @List VALUES (''Joe Mitchell'')

INSERT INTO @List VALUES (''Rachel Brown'')

INSERT INTO @List VALUES (''Violet Kennedy'')

INSERT INTO @List VALUES (''Dustin Garza'')

INSERT INTO @List VALUES (''Florence Benson'')

INSERT INTO @List VALUES (''Justin Henderson'')

INSERT INTO @List VALUES (''Jesse Christensen'')

INSERT INTO @List VALUES (''Christopher Johnson'')

INSERT INTO @List VALUES (''Charles Lee Garrett Campbell'')

INSERT INTO @List VALUES (''Andrew Griffith'')

INSERT INTO @List VALUES (''Mamie Barker'')

INSERT INTO @List VALUES (''Aiden Brock'')

INSERT INTO @List VALUES (''Cecilia Estrada'')

INSERT INTO @List VALUES (''Hallie Cobb'')

INSERT INTO @List VALUES (''Olga Watts'')

INSERT INTO @List VALUES (''Nannie Graham'')

INSERT INTO @List VALUES (''Louise Day'')

INSERT INTO @List VALUES (''Ethel Simmons'')

INSERT INTO @List VALUES (''Lester Moss'')

INSERT INTO @List VALUES (''Lizzie Collier'')

INSERT INTO @List VALUES (''Kyle Long'')

INSERT INTO @List VALUES (''Ruth Flowers'')

INSERT INTO @List VALUES (''Theresa Lambert'')

INSERT INTO @List VALUES (''Roy Blair'')

INSERT INTO @List VALUES (''Michael Soto'')

INSERT INTO @List VALUES (''William Davis'')

INSERT INTO @List VALUES (''Minnie Schultz'')

INSERT INTO @List VALUES (''Mitchell Curry'')

INSERT INTO @List VALUES (''Martha Jennings'')

INSERT INTO @List VALUES (''Sophie Cannon'')

INSERT INTO @List VALUES (''Cody Riley'')

INSERT INTO @List VALUES (''Lily Weber'')

INSERT INTO @List VALUES (''Eunice Goodman'')

INSERT INTO @List VALUES (''Howard French'')

INSERT INTO @List VALUES (''Chris Saunders'')

INSERT INTO @List VALUES (''Raymond Mendez'')

INSERT INTO @List VALUES (''Estella Soto'')

INSERT INTO @List VALUES (''Jorge Gill'')

INSERT INTO @List VALUES (''Luis Wade'')

INSERT INTO @List VALUES (''Katie Farmer'')

INSERT INTO @List VALUES (''Nelle Patton'')

INSERT INTO @List VALUES (''Sylvia Bush'')

INSERT INTO @List VALUES (''Olga Glover'')

INSERT INTO @List VALUES (''Agnes Tyler'')

INSERT INTO @List VALUES (''Herman Fisher'')

INSERT INTO @List VALUES (''Miguel Wallace'')

INSERT INTO @List VALUES (''Philip Barber'')

INSERT INTO @List VALUES (''Jonathan Ortiz'')

INSERT INTO @List VALUES (''Sue Fletcher'')

INSERT INTO @List VALUES (''Moisès Agramunt'')

INSERT INTO @List VALUES (''Salvador Antonell'')

INSERT INTO @List VALUES (''Silvestre Bolas'')

INSERT INTO @List VALUES (''Pau Pol Castellet'')

INSERT INTO @List VALUES (''Francesc Rispau'')

INSERT INTO @List VALUES (''Just Merino'')

INSERT INTO @List VALUES (''Vicenç Subirós'')

INSERT INTO @List VALUES (''Rubèn Barri'')

INSERT INTO @List VALUES (''Bernabè Sannicolas'')

INSERT INTO @List VALUES (''Isaac Jorba'')



DECLARE @Address TABLE (CustomerAddress varchar(200))

INSERT INTO @Address VALUES (''1127 Eraad Lane'')

INSERT INTO @Address VALUES (''1720 Fogug Boulevard'')

INSERT INTO @Address VALUES (''830 Wapcig View'')

INSERT INTO @Address VALUES (''67 Wuhenu Street'')

INSERT INTO @Address VALUES (''512 Tadta Pass'')

INSERT INTO @Address VALUES (''1399 Hoca Key'')

INSERT INTO @Address VALUES (''1201 Botdip Court'')

INSERT INTO @Address VALUES (''750 Hafek Center'')

INSERT INTO @Address VALUES (''483 Dunzek Road'')

INSERT INTO @Address VALUES (''56 Zinun Trail'')

INSERT INTO @Address VALUES (''655 Zivi Pike'')

INSERT INTO @Address VALUES (''1367 Zicsu Boulevard'')

INSERT INTO @Address VALUES (''1319 Abcus Lane'')

INSERT INTO @Address VALUES (''502 Hulnek Street'')

INSERT INTO @Address VALUES (''1132 Sakohe Boulevard'')

INSERT INTO @Address VALUES (''1208 Bifi Plaza'')

INSERT INTO @Address VALUES (''1966 Vuvwu Glen'')

INSERT INTO @Address VALUES (''681 Fikkep Grove'')

INSERT INTO @Address VALUES (''1916 Pinut Drive'')

INSERT INTO @Address VALUES (''1374 Epoeca Center'')

INSERT INTO @Address VALUES (''1285 Ijapa River'')

INSERT INTO @Address VALUES (''1868 Fonnub Plaza'')

INSERT INTO @Address VALUES (''737 Nabha Turnpike'')

INSERT INTO @Address VALUES (''492 Osise Court'')

INSERT INTO @Address VALUES (''56 Tokpuh Manor'')

INSERT INTO @Address VALUES (''1835 Bobvu Grove'')

INSERT INTO @Address VALUES (''972 Adleb Heights'')

INSERT INTO @Address VALUES (''1593 Notuz Parkway'')

INSERT INTO @Address VALUES (''1560 Nume Grove'')

INSERT INTO @Address VALUES (''998 Humzi Square'')

INSERT INTO @Address VALUES (''281 Ibama Path'')

INSERT INTO @Address VALUES (''841 Wope Point'')

INSERT INTO @Address VALUES (''1128 Jaspi Trail'')

INSERT INTO @Address VALUES (''1047 Depi Parkway'')

INSERT INTO @Address VALUES (''613 Pamic Pike'')

INSERT INTO @Address VALUES (''982 Onhip Ridge'')

INSERT INTO @Address VALUES (''876 Sovep Park'')

INSERT INTO @Address VALUES (''281 Ijiife Turnpike'')

INSERT INTO @Address VALUES (''661 Wafor Circle'')

INSERT INTO @Address VALUES (''91 Raama Grove'')

INSERT INTO @Address VALUES (''1694 Cavele Circle'')

INSERT INTO @Address VALUES (''1260 Efmu Pike'')

INSERT INTO @Address VALUES (''1248 Hazi Extension'')

INSERT INTO @Address VALUES (''1640 Hinfuw Avenue'')

INSERT INTO @Address VALUES (''494 Nigo Parkway'')

INSERT INTO @Address VALUES (''517 Morfe Point'')

INSERT INTO @Address VALUES (''2000 Bedev Road'')

INSERT INTO @Address VALUES (''1988 Jukev River'')

INSERT INTO @Address VALUES (''24 Sofani Parkway'')

INSERT INTO @Address VALUES (''267 Esutid Ridge'')

INSERT INTO @Address VALUES (''84 Juzav Boulevard'')

INSERT INTO @Address VALUES (''1745 Matik Pike'')

INSERT INTO @Address VALUES (''808 Mazob Circle'')

INSERT INTO @Address VALUES (''903 Topobi Lane'')

INSERT INTO @Address VALUES (''1096 Cufow Highway'')

INSERT INTO @Address VALUES (''875 Givad Pike'')

INSERT INTO @Address VALUES (''863 Ufasa Way'')

INSERT INTO @Address VALUES (''588 Dici View'')

INSERT INTO @Address VALUES (''1840 Getev Key'')

INSERT INTO @Address VALUES (''1543 Tezve Way'')

INSERT INTO @Address VALUES (''260 Zeaz Glen'')

INSERT INTO @Address VALUES (''303 Waobi Court'')

INSERT INTO @Address VALUES (''54 Samaj Ridge'')

INSERT INTO @Address VALUES (''1921 Inbu Way'')

INSERT INTO @Address VALUES (''500 Riduca Square'')

INSERT INTO @Address VALUES (''845 Feri Loop'')

INSERT INTO @Address VALUES (''534 Zujoza Drive'')

INSERT INTO @Address VALUES (''23 Vazse Grove'')

INSERT INTO @Address VALUES (''1491 Tino Key'')

INSERT INTO @Address VALUES (''1508 Hepik Junction'')

INSERT INTO @Address VALUES (''1919 Bijse Key'')

INSERT INTO @Address VALUES (''1231 Huko Street'')

INSERT INTO @Address VALUES (''320 Hacer Extension'')

INSERT INTO @Address VALUES (''1335 Najte Mill'')

INSERT INTO @Address VALUES (''1327 Getfeb Heights'')

INSERT INTO @Address VALUES (''912 Dekgi Street'')

INSERT INTO @Address VALUES (''154 Kupso View'')

INSERT INTO @Address VALUES (''1327 Utlom Turnpike'')

INSERT INTO @Address VALUES (''1739 Bagfac Heights'')

INSERT INTO @Address VALUES (''825 Dotfo Park'')

INSERT INTO @Address VALUES (''1394 Oluha Trail'')

INSERT INTO @Address VALUES (''61 Utbol Circle'')

INSERT INTO @Address VALUES (''109 Wijrud Point'')

INSERT INTO @Address VALUES (''1072 Awja Heights'')

INSERT INTO @Address VALUES (''1018 Obevir Extension'')

INSERT INTO @Address VALUES (''10 Gobfil Place'')

INSERT INTO @Address VALUES (''1080 Golac River'')

INSERT INTO @Address VALUES (''1182 Pevtak Pike'')

INSERT INTO @Address VALUES (''1138 Uzpu Road'')

INSERT INTO @Address VALUES (''1076 Viero Key'')

INSERT INTO @Address VALUES (''1468 Jifab Key'')

INSERT INTO @Address VALUES (''1662 Vuhcen View'')

INSERT INTO @Address VALUES (''941 Osotu Junction'')

INSERT INTO @Address VALUES (''1171 Magika Trail'')

INSERT INTO @Address VALUES (''1491 Okosun Road'')

INSERT INTO @Address VALUES (''530 Vakep Path'')

INSERT INTO @Address VALUES (''1447 Suco Trail'')

INSERT INTO @Address VALUES (''1358 Ikeku Circle'')

INSERT INTO @Address VALUES (''1810 Gejah Extension'')

INSERT INTO @Address VALUES (''678 Apecuc Heights'')

INSERT INTO @Address VALUES (''1869 Mavuga Trail'')

INSERT INTO @Address VALUES (''882 Emevo Key'')

INSERT INTO @Address VALUES (''562 Mokice View'')

INSERT INTO @Address VALUES (''385 Akuehe Trail'')

INSERT INTO @Address VALUES (''732 Wufi Drive'')

INSERT INTO @Address VALUES (''439 Koplim Street'')

INSERT INTO @Address VALUES (''1449 Majcu View'')

INSERT INTO @Address VALUES (''1646 Oriro Loop'')

INSERT INTO @Address VALUES (''378 Bihdu Highway'')

INSERT INTO @Address VALUES (''501 Ucgaj Turnpike'')

DECLARE @RoomNumber TABLE (RoomNumber INT)

INSERT INTO @RoomNumber VALUES (''2850168'')

INSERT INTO @RoomNumber VALUES (''315123188'')

INSERT INTO @RoomNumber VALUES (''176178376'')

INSERT INTO @RoomNumber VALUES (''103087374'')

INSERT INTO @RoomNumber VALUES (''28730664'')

INSERT INTO @RoomNumber VALUES (''954305874'')

INSERT INTO @RoomNumber VALUES (''972946143'')

INSERT INTO @RoomNumber VALUES (''708685087'')

INSERT INTO @RoomNumber VALUES (''861722896'')

INSERT INTO @RoomNumber VALUES (''679997300'')

INSERT INTO @RoomNumber VALUES (''867400639'')

INSERT INTO @RoomNumber VALUES (''760800297'')

INSERT INTO @RoomNumber VALUES (''964981996'')

INSERT INTO @RoomNumber VALUES (''743019257'')

INSERT INTO @RoomNumber VALUES (''361760285'')

INSERT INTO @RoomNumber VALUES (''287353229'')

INSERT INTO @RoomNumber VALUES (''587597740'')

INSERT INTO @RoomNumber VALUES (''818357333'')

INSERT INTO @RoomNumber VALUES (''778277744'')

INSERT INTO @RoomNumber VALUES (''895820208'')

INSERT INTO @RoomNumber VALUES (''28730664'')

INSERT INTO @RoomNumber VALUES (''954305874'')

INSERT INTO @RoomNumber VALUES (''972946143'')

INSERT INTO @RoomNumber VALUES (''708685087'')

INSERT INTO @RoomNumber VALUES (''861722896'')

INSERT INTO @RoomNumber VALUES (''679997300'')

INSERT INTO @RoomNumber VALUES (''867400639'')

INSERT INTO @RoomNumber VALUES (''760800297'')

INSERT INTO @RoomNumber VALUES (''964981996'')

INSERT INTO @RoomNumber VALUES (''743019257'')

INSERT INTO @RoomNumber VALUES (''361760285'')

INSERT INTO @RoomNumber VALUES (''287353229'')

INSERT INTO @RoomNumber VALUES (''587597740'')

INSERT INTO @RoomNumber VALUES (''818357333'')

INSERT INTO @RoomNumber VALUES (''28730664'')

INSERT INTO @RoomNumber VALUES (''954305874'')

INSERT INTO @RoomNumber VALUES (''972946143'')

INSERT INTO @RoomNumber VALUES (''708685087'')

INSERT INTO @RoomNumber VALUES (''861722896'')

INSERT INTO @RoomNumber VALUES (''679997300'')

INSERT INTO @RoomNumber VALUES (''867400639'')

INSERT INTO @RoomNumber VALUES (''760800297'')

INSERT INTO @RoomNumber VALUES (''964981996'')

INSERT INTO @RoomNumber VALUES (''743019257'')

INSERT INTO @RoomNumber VALUES (''361760285'')

INSERT INTO @RoomNumber VALUES (''287353229'')

INSERT INTO @RoomNumber VALUES (''587597740'')

INSERT INTO @RoomNumber VALUES (''818357333'')

INSERT INTO @RoomNumber VALUES (''28730664'')

INSERT INTO @RoomNumber VALUES (''954305874'')

INSERT INTO @RoomNumber VALUES (''972946143'')

INSERT INTO @RoomNumber VALUES (''708685087'')

INSERT INTO @RoomNumber VALUES (''861722896'')

INSERT INTO @RoomNumber VALUES (''679997300'')

INSERT INTO @RoomNumber VALUES (''867400639'')

INSERT INTO @RoomNumber VALUES (''760800297'')

INSERT INTO @RoomNumber VALUES (''964981996'')

INSERT INTO @RoomNumber VALUES (''743019257'')

INSERT INTO @RoomNumber VALUES (''361760285'')

INSERT INTO @RoomNumber VALUES (''287353229'')

INSERT INTO @RoomNumber VALUES (''587597740'')

INSERT INTO @RoomNumber VALUES (''818357333'')

INSERT INTO @RoomNumber VALUES (''28730664'')

INSERT INTO @RoomNumber VALUES (''954305874'')

INSERT INTO @RoomNumber VALUES (''972946143'')

INSERT INTO @RoomNumber VALUES (''708685087'')

INSERT INTO @RoomNumber VALUES (''861722896'')

INSERT INTO @RoomNumber VALUES (''679997300'')

INSERT INTO @RoomNumber VALUES (''867400639'')

INSERT INTO @RoomNumber VALUES (''760800297'')

INSERT INTO @RoomNumber VALUES (''964981996'')

INSERT INTO @RoomNumber VALUES (''743019257'')

INSERT INTO @RoomNumber VALUES (''361760285'')

INSERT INTO @RoomNumber VALUES (''287353229'')

INSERT INTO @RoomNumber VALUES (''587597740'')

INSERT INTO @RoomNumber VALUES (''818357333'')

INSERT INTO @RoomNumber VALUES (''28730664'')

INSERT INTO @RoomNumber VALUES (''954305874'')

INSERT INTO @RoomNumber VALUES (''972946143'')

INSERT INTO @RoomNumber VALUES (''708685087'')

INSERT INTO @RoomNumber VALUES (''861722896'')

INSERT INTO @RoomNumber VALUES (''679997300'')

INSERT INTO @RoomNumber VALUES (''867400639'')

INSERT INTO @RoomNumber VALUES (''760800297'')

INSERT INTO @RoomNumber VALUES (''964981996'')

INSERT INTO @RoomNumber VALUES (''743019257'')

INSERT INTO @RoomNumber VALUES (''361760285'')

INSERT INTO @RoomNumber VALUES (''287353229'')

INSERT INTO @RoomNumber VALUES (''587597740'')

INSERT INTO @RoomNumber VALUES (''818357333'')

INSERT INTO @RoomNumber VALUES (''28730664'')

INSERT INTO @RoomNumber VALUES (''954305874'')

INSERT INTO @RoomNumber VALUES (''972946143'')

INSERT INTO @RoomNumber VALUES (''708685087'')

INSERT INTO @RoomNumber VALUES (''861722896'')

INSERT INTO @RoomNumber VALUES (''679997300'')

INSERT INTO @RoomNumber VALUES (''867400639'')

INSERT INTO @RoomNumber VALUES (''760800297'')

INSERT INTO @RoomNumber VALUES (''964981996'')

INSERT INTO @RoomNumber VALUES (''743019257'')

INSERT INTO @RoomNumber VALUES (''361760285'')

INSERT INTO @RoomNumber VALUES (''287353229'')

INSERT INTO @RoomNumber VALUES (''587597740'')

INSERT INTO @RoomNumber VALUES (''818357333'')

INSERT INTO @RoomNumber VALUES (''28730664'')

INSERT INTO @RoomNumber VALUES (''954305874'')

INSERT INTO @RoomNumber VALUES (''972946143'')

INSERT INTO @RoomNumber VALUES (''708685087'')

INSERT INTO @RoomNumber VALUES (''861722896'')

INSERT INTO @RoomNumber VALUES (''679997300'')

INSERT INTO @RoomNumber VALUES (''867400639'')

INSERT INTO @RoomNumber VALUES (''760800297'')

INSERT INTO @RoomNumber VALUES (''964981996'')

INSERT INTO @RoomNumber VALUES (''743019257'')

INSERT INTO @RoomNumber VALUES (''361760285'')

INSERT INTO @RoomNumber VALUES (''287353229'')

INSERT INTO @RoomNumber VALUES (''587597740'')

INSERT INTO @RoomNumber VALUES (''818357333'')

INSERT INTO @RoomNumber VALUES (''28730664'')

INSERT INTO @RoomNumber VALUES (''954305874'')

INSERT INTO @RoomNumber VALUES (''972946143'')

INSERT INTO @RoomNumber VALUES (''708685087'')

INSERT INTO @RoomNumber VALUES (''861722896'')

INSERT INTO @RoomNumber VALUES (''679997300'')

INSERT INTO @RoomNumber VALUES (''867400639'')

INSERT INTO @RoomNumber VALUES (''760800297'')

INSERT INTO @RoomNumber VALUES (''964981996'')

INSERT INTO @RoomNumber VALUES (''743019257'')

INSERT INTO @RoomNumber VALUES (''361760285'')

INSERT INTO @RoomNumber VALUES (''287353229'')

INSERT INTO @RoomNumber VALUES (''587597740'')

INSERT INTO @RoomNumber VALUES (''818357333'')

INSERT INTO @RoomNumber VALUES (''28730664'')

INSERT INTO @RoomNumber VALUES (''954305874'')

INSERT INTO @RoomNumber VALUES (''972946143'')

INSERT INTO @RoomNumber VALUES (''708685087'')

INSERT INTO @RoomNumber VALUES (''861722896'')

INSERT INTO @RoomNumber VALUES (''679997300'')

INSERT INTO @RoomNumber VALUES (''867400639'')

INSERT INTO @RoomNumber VALUES (''760800297'')

INSERT INTO @RoomNumber VALUES (''964981996'')

INSERT INTO @RoomNumber VALUES (''743019257'')

INSERT INTO @RoomNumber VALUES (''361760285'')

INSERT INTO @RoomNumber VALUES (''287353229'')

INSERT INTO @RoomNumber VALUES (''587597740'')

INSERT INTO @RoomNumber VALUES (''818357333'')

INSERT INTO @RoomNumber VALUES (''28730664'')

INSERT INTO @RoomNumber VALUES (''954305874'')

INSERT INTO @RoomNumber VALUES (''972946143'')

INSERT INTO @RoomNumber VALUES (''708685087'')

INSERT INTO @RoomNumber VALUES (''861722896'')

INSERT INTO @RoomNumber VALUES (''679997300'')

INSERT INTO @RoomNumber VALUES (''867400639'')

INSERT INTO @RoomNumber VALUES (''760800297'')

INSERT INTO @RoomNumber VALUES (''964981996'')

INSERT INTO @RoomNumber VALUES (''743019257'')

INSERT INTO @RoomNumber VALUES (''361760285'')

INSERT INTO @RoomNumber VALUES (''287353229'')

INSERT INTO @RoomNumber VALUES (''587597740'')

INSERT INTO @RoomNumber VALUES (''818357333'')

INSERT INTO @RoomNumber VALUES (''28730664'')

INSERT INTO @RoomNumber VALUES (''954305874'')

INSERT INTO @RoomNumber VALUES (''972946143'')

INSERT INTO @RoomNumber VALUES (''708685087'')

INSERT INTO @RoomNumber VALUES (''861722896'')

INSERT INTO @RoomNumber VALUES (''679997300'')

INSERT INTO @RoomNumber VALUES (''867400639'')

INSERT INTO @RoomNumber VALUES (''760800297'')

INSERT INTO @RoomNumber VALUES (''964981996'')

INSERT INTO @RoomNumber VALUES (''743019257'')

INSERT INTO @RoomNumber VALUES (''361760285'')

INSERT INTO @RoomNumber VALUES (''287353229'')

INSERT INTO @RoomNumber VALUES (''587597740'')

INSERT INTO @RoomNumber VALUES (''818357333'')

DECLARE @Floor TABLE (Floor INT)

INSERT INTO @Floor VALUES (''2850168'')

INSERT INTO @Floor VALUES (''315123188'')

INSERT INTO @Floor VALUES (''176178376'')

INSERT INTO @Floor VALUES (''103087374'')

INSERT INTO @Floor VALUES (''28730664'')

INSERT INTO @Floor VALUES (''954305874'')

INSERT INTO @Floor VALUES (''972946143'')

INSERT INTO @Floor VALUES (''708685087'')

INSERT INTO @Floor VALUES (''861722896'')

INSERT INTO @Floor VALUES (''679997300'')

INSERT INTO @Floor VALUES (''867400639'')

INSERT INTO @Floor VALUES (''760800297'')

INSERT INTO @Floor VALUES (''964981996'')

INSERT INTO @Floor VALUES (''743019257'')

INSERT INTO @Floor VALUES (''361760285'')

INSERT INTO @Floor VALUES (''287353229'')

INSERT INTO @Floor VALUES (''587597740'')

INSERT INTO @Floor VALUES (''818357333'')

INSERT INTO @Floor VALUES (''778277744'')

INSERT INTO @Floor VALUES (''895820208'')

INSERT INTO @Floor VALUES (''28730664'')

INSERT INTO @Floor VALUES (''954305874'')

INSERT INTO @Floor VALUES (''972946143'')

INSERT INTO @Floor VALUES (''708685087'')

INSERT INTO @Floor VALUES (''861722896'')

INSERT INTO @Floor VALUES (''679997300'')

INSERT INTO @Floor VALUES (''867400639'')

INSERT INTO @Floor VALUES (''760800297'')

INSERT INTO @Floor VALUES (''964981996'')

INSERT INTO @Floor VALUES (''743019257'')

INSERT INTO @Floor VALUES (''361760285'')

INSERT INTO @Floor VALUES (''287353229'')

INSERT INTO @Floor VALUES (''587597740'')

INSERT INTO @Floor VALUES (''818357333'')

INSERT INTO @Floor VALUES (''28730664'')

INSERT INTO @Floor VALUES (''954305874'')

INSERT INTO @Floor VALUES (''972946143'')

INSERT INTO @Floor VALUES (''708685087'')

INSERT INTO @Floor VALUES (''861722896'')

INSERT INTO @Floor VALUES (''679997300'')

INSERT INTO @Floor VALUES (''867400639'')

INSERT INTO @Floor VALUES (''760800297'')

INSERT INTO @Floor VALUES (''964981996'')

INSERT INTO @Floor VALUES (''743019257'')

INSERT INTO @Floor VALUES (''361760285'')

INSERT INTO @Floor VALUES (''287353229'')

INSERT INTO @Floor VALUES (''587597740'')

INSERT INTO @Floor VALUES (''818357333'')

INSERT INTO @Floor VALUES (''28730664'')

INSERT INTO @Floor VALUES (''954305874'')

INSERT INTO @Floor VALUES (''972946143'')

INSERT INTO @Floor VALUES (''708685087'')

INSERT INTO @Floor VALUES (''861722896'')

INSERT INTO @Floor VALUES (''679997300'')

INSERT INTO @Floor VALUES (''867400639'')

INSERT INTO @Floor VALUES (''760800297'')

INSERT INTO @Floor VALUES (''964981996'')

INSERT INTO @Floor VALUES (''743019257'')

INSERT INTO @Floor VALUES (''361760285'')

INSERT INTO @Floor VALUES (''287353229'')

INSERT INTO @Floor VALUES (''587597740'')

INSERT INTO @Floor VALUES (''818357333'')

INSERT INTO @Floor VALUES (''28730664'')

INSERT INTO @Floor VALUES (''954305874'')

INSERT INTO @Floor VALUES (''972946143'')

INSERT INTO @Floor VALUES (''708685087'')

INSERT INTO @Floor VALUES (''861722896'')

INSERT INTO @Floor VALUES (''679997300'')

INSERT INTO @Floor VALUES (''867400639'')

INSERT INTO @Floor VALUES (''760800297'')

INSERT INTO @Floor VALUES (''964981996'')

INSERT INTO @Floor VALUES (''743019257'')

INSERT INTO @Floor VALUES (''361760285'')

INSERT INTO @Floor VALUES (''287353229'')

INSERT INTO @Floor VALUES (''587597740'')

INSERT INTO @Floor VALUES (''818357333'')

INSERT INTO @Floor VALUES (''28730664'')

INSERT INTO @Floor VALUES (''954305874'')

INSERT INTO @Floor VALUES (''972946143'')

INSERT INTO @Floor VALUES (''708685087'')

INSERT INTO @Floor VALUES (''861722896'')

INSERT INTO @Floor VALUES (''679997300'')

INSERT INTO @Floor VALUES (''867400639'')

INSERT INTO @Floor VALUES (''760800297'')

INSERT INTO @Floor VALUES (''964981996'')

INSERT INTO @Floor VALUES (''743019257'')

INSERT INTO @Floor VALUES (''361760285'')

INSERT INTO @Floor VALUES (''287353229'')

INSERT INTO @Floor VALUES (''587597740'')

INSERT INTO @Floor VALUES (''818357333'')

INSERT INTO @Floor VALUES (''28730664'')

INSERT INTO @Floor VALUES (''954305874'')

INSERT INTO @Floor VALUES (''972946143'')

INSERT INTO @Floor VALUES (''708685087'')

INSERT INTO @Floor VALUES (''861722896'')

INSERT INTO @Floor VALUES (''679997300'')

INSERT INTO @Floor VALUES (''867400639'')

INSERT INTO @Floor VALUES (''760800297'')

INSERT INTO @Floor VALUES (''964981996'')

INSERT INTO @Floor VALUES (''743019257'')

INSERT INTO @Floor VALUES (''361760285'')

INSERT INTO @Floor VALUES (''287353229'')

INSERT INTO @Floor VALUES (''587597740'')

INSERT INTO @Floor VALUES (''818357333'')

INSERT INTO @Floor VALUES (''28730664'')

INSERT INTO @Floor VALUES (''954305874'')

INSERT INTO @Floor VALUES (''972946143'')

INSERT INTO @Floor VALUES (''708685087'')

INSERT INTO @Floor VALUES (''861722896'')

INSERT INTO @Floor VALUES (''679997300'')

INSERT INTO @Floor VALUES (''867400639'')

INSERT INTO @Floor VALUES (''760800297'')

INSERT INTO @Floor VALUES (''964981996'')

INSERT INTO @Floor VALUES (''743019257'')

INSERT INTO @Floor VALUES (''361760285'')

INSERT INTO @Floor VALUES (''287353229'')

INSERT INTO @Floor VALUES (''587597740'')

INSERT INTO @Floor VALUES (''818357333'')

INSERT INTO @Floor VALUES (''28730664'')

INSERT INTO @Floor VALUES (''954305874'')

INSERT INTO @Floor VALUES (''972946143'')

INSERT INTO @Floor VALUES (''708685087'')

INSERT INTO @Floor VALUES (''861722896'')

INSERT INTO @Floor VALUES (''679997300'')

INSERT INTO @Floor VALUES (''867400639'')

INSERT INTO @Floor VALUES (''760800297'')

INSERT INTO @Floor VALUES (''964981996'')

INSERT INTO @Floor VALUES (''743019257'')

INSERT INTO @Floor VALUES (''361760285'')

INSERT INTO @Floor VALUES (''287353229'')

INSERT INTO @Floor VALUES (''587597740'')

INSERT INTO @Floor VALUES (''818357333'')

INSERT INTO @Floor VALUES (''28730664'')

INSERT INTO @Floor VALUES (''954305874'')

INSERT INTO @Floor VALUES (''972946143'')

INSERT INTO @Floor VALUES (''708685087'')

INSERT INTO @Floor VALUES (''861722896'')

INSERT INTO @Floor VALUES (''679997300'')

INSERT INTO @Floor VALUES (''867400639'')

INSERT INTO @Floor VALUES (''760800297'')

INSERT INTO @Floor VALUES (''964981996'')

INSERT INTO @Floor VALUES (''743019257'')

INSERT INTO @Floor VALUES (''361760285'')

INSERT INTO @Floor VALUES (''287353229'')

INSERT INTO @Floor VALUES (''587597740'')

INSERT INTO @Floor VALUES (''818357333'')

INSERT INTO @Floor VALUES (''28730664'')

INSERT INTO @Floor VALUES (''954305874'')

INSERT INTO @Floor VALUES (''972946143'')

INSERT INTO @Floor VALUES (''708685087'')

INSERT INTO @Floor VALUES (''861722896'')

INSERT INTO @Floor VALUES (''679997300'')

INSERT INTO @Floor VALUES (''867400639'')

INSERT INTO @Floor VALUES (''760800297'')

INSERT INTO @Floor VALUES (''964981996'')

INSERT INTO @Floor VALUES (''743019257'')

INSERT INTO @Floor VALUES (''361760285'')

INSERT INTO @Floor VALUES (''287353229'')

INSERT INTO @Floor VALUES (''587597740'')

INSERT INTO @Floor VALUES (''818357333'')

INSERT INTO @Floor VALUES (''28730664'')

INSERT INTO @Floor VALUES (''954305874'')

INSERT INTO @Floor VALUES (''972946143'')

INSERT INTO @Floor VALUES (''708685087'')

INSERT INTO @Floor VALUES (''861722896'')

INSERT INTO @Floor VALUES (''679997300'')

INSERT INTO @Floor VALUES (''867400639'')

INSERT INTO @Floor VALUES (''760800297'')

INSERT INTO @Floor VALUES (''964981996'')

INSERT INTO @Floor VALUES (''743019257'')

INSERT INTO @Floor VALUES (''361760285'')

INSERT INTO @Floor VALUES (''287353229'')

INSERT INTO @Floor VALUES (''587597740'')

INSERT INTO @Floor VALUES (''818357333'')


WHILE @cnt < 60



BEGIN

   INSERT INTO [dbo].[Bookings]

           ([From]

           ,[To]

           ,[CustomerId]

           ,[CustomerName]

           ,[Passport]

           ,[Address]

           ,[Amount]

           ,[Total]
           ,[RoomNumber]
           ,[Floor]  )

     VALUES

           (CONVERT (date, DATEADD(DAY, FLOOR(RAND()*(-5-10+1))+10, GETDATE()))

           ,CONVERT (date, DATEADD(DAY, FLOOR(RAND()*(5-1+1))+1, GETDATE()))

           ,FLOOR(RAND()*(99999-10000+1))+10000

           ,(SELECT TOP 1 * FROM @List ORDER BY NEWID())

           ,(SELECT TOP 1 * FROM @Passport ORDER BY NEWID())

           ,(SELECT TOP 1 * FROM @Address ORDER BY NEWID())

           ,(SELECT (FLOOR(RAND()*(40-10+1))+10)*100)
           ,0
           ,(SELECT TOP 1 * FROM @RoomNumber ORDER BY NEWID())

           ,(SELECT TOP 1 * FROM @Floor ORDER BY NEWID()))

   SET @cnt = @cnt + 1;

END;', 
		@database_name=N'SmartHotel.Registration', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Update table]    Script Date: 11/12/2018 5:14:20 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Update table', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'update Bookings set floor = 1 where id <=10
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
	SELECT @CreditCard = CAST(FLOOR(RAND()*(10000-1000)+1000) as varchar(4)) + ''-'' + CAST(FLOOR(RAND()*(10000-1000)+1000) as varchar(4)) + ''-'' + CAST(FLOOR(RAND()*(10000-1000)+1000) as varchar(4)) + ''-'' + CAST(FLOOR(RAND()*(10000-1000)+1000) as varchar(4))
	update Bookings set CreditCard = @CreditCard where id  = @j
END', 
		@database_name=N'SmartHotel.Registration', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'SH360 Weekly Schedule', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20181112, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'77d3c88e-efd8-4da8-a49c-bb170dab4e6d'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

