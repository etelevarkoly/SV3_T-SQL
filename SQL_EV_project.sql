USE AdventureWorks2019
GO 

-- 1. feladat

SELECT P.ProductID, 
	P.Name AS 'ProductName', 
	PL.Name AS 'LocationName', 
	PRI.Shelf,
	PRI.Bin, 
	PRI.Quantity,
	PRI.LocationID
FROM Production.Product AS P 
INNER JOIN Production.ProductInventory AS PRI ON PRI.ProductID = P.ProductID
INNER JOIN Production.Location AS PL ON PL.LocationID = PRI.LocationID
WHERE P.ProductID IN (
	SELECT P.ProductID
	FROM Production.Product AS P 
		INNER JOIN Production.ProductInventory AS PRI ON PRI.ProductID = P.ProductID
	WHERE PRI.Shelf = 'A' AND PRI.Quantity > 470 
	GROUP BY P.ProductID
	HAVING COUNT(1) > 1)
ORDER BY P.Name, PRI.Shelf
GO

-- 2. feladat

CREATE OR ALTER VIEW dbo.OrderPromotionList AS
SELECT 
	YEAR(SOH.DueDate) AS 'Rendelés éve',
	PC.Name AS 'Kategória neve',
	CASE 
		WHEN SO.Description LIKE '%Volume%' THEN 'Volume'
		WHEN SO.Description LIKE '%Mountain%' THEN 'Mountain'
		WHEN SO.Description LIKE '%Road%' THEN 'Road'
		WHEN SO.Description LIKE '%Touring%' THEN 'Touring'
		ELSE 'Other'
	END AS 'Kedvezmény típusa',
	SUM(SOD.LineTotal) AS 'Éves összeg'
FROM Production.ProductCategory AS PC 
INNER JOIN Production.ProductSubcategory AS PSC ON PSC.ProductCategoryID = PC.ProductCategoryID
INNER JOIN Production.Product AS P ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
INNER JOIN Sales.SalesOrderDetail AS SOD ON SOD.ProductID = P.ProductID
INNER JOIN Sales.SalesOrderHeader AS SOH ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Sales.SpecialOffer AS SO ON SO.SpecialOfferID = SOD.SpecialOfferID
WHERE SOD.SpecialOfferID <> 1
-- YEAR() is kell a DueDate GROUP BY részbe ;
-- ha CASE van a SELECT-ben és GROUP BY-t akarok használni, 
-- az egész CASE mezőt ide kell írjam.
GROUP BY YEAR(SOH.DueDate), PC.Name, 
	CASE 
		WHEN SO.Description LIKE '%Volume%' THEN 'Volume'
		WHEN SO.Description LIKE '%Mountain%' THEN 'Mountain'
		WHEN SO.Description LIKE '%Road%' THEN 'Road'
		WHEN SO.Description LIKE '%Touring%' THEN 'Touring'
		ELSE 'Other'
	END
-- ORDER BY 1, 2, 3
/*
SELECT * FROM dbo.OrderPromotionList ORDER BY 1, 2, 3
*/
GO

-- 3. feladat 

CREATE DATABASE probavizsga_vizsgaDB
GO

USE probavizsga_vizsgaDB
GO

CREATE TABLE Users (
	UserID TINYINT NOT NULL,
	UserName VARCHAR(200) NOT NULL,
	Email VARCHAR(50) NOT NULL, 
	BirthDate DATE NOT NULL,
	CONSTRAINT PK_Users_UserID PRIMARY KEY (UserID),
	CONSTRAINT UQ_Users_Email UNIQUE (Email)
)
GO

CREATE TABLE Exams (
	ExamID TINYINT NOT NULL,
	FacultyID TINYINT NOT NULL,
	TrainingID TINYINT NOT NULL,
	ExamDate DATE NOT NULL,
	ExamType VARCHAR(50) NOT NULL,
	MaxResult TINYINT NOT NULL,
	CONSTRAINT PK_Exams_ExamID PRIMARY KEY (ExamID)
)
GO

CREATE TABLE Training (
	TrainingID TINYINT NOT NULL,
	TrainingName VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Training_TrainingID PRIMARY KEY (TrainingID)
)
GO

CREATE TABLE ExamResults (
	ExamResultID TINYINT IDENTITY(1, 1) NOT NULL,
	ExamID TINYINT NOT NULL,
	UserID TINYINT NOT NULL,
	Result TINYINT NOT NULL,
	CONSTRAINT PK_ExamResults_ExamResultID PRIMARY KEY (ExamResultID)
)
GO

CREATE TABLE TrainingFaculty (
	FacultyID TINYINT IDENTITY(1, 1) NOT NULL,
	FacultyName VARCHAR(50) NOT NULL,
	CONSTRAINT PK_TrainingFaculty_FacultyID PRIMARY KEY (FacultyID)
)
GO

CREATE TABLE StudentTermData (
	TermID TINYINT IDENTITY(1, 1) NOT NULL,
	UserID TINYINT NOT NULL,
	TrainingID TINYINT NOT NULL,
	TrainingStartDate DATE NOT NULL,
	CONSTRAINT PK_StudentTermData_TermID PRIMARY KEY (TermID)
)
GO

ALTER TABLE StudentTermData 
	ADD CONSTRAINT FK_StudentTermData_Users_UserID 
	FOREIGN KEY (UserID)
	REFERENCES Users (UserID)
GO

ALTER TABLE StudentTermData 
	ADD CONSTRAINT FK_StudentTermData_Training_TrainingID
	FOREIGN KEY (TrainingID)
	REFERENCES Training (TrainingID)
GO

ALTER TABLE ExamResults
	ADD CONSTRAINT FK_ExamResults_Users_UserID
	FOREIGN KEY (UserID)
	REFERENCES Users (UserID)
GO

ALTER TABLE ExamResults
	ADD CONSTRAINT FK_ExamResults_Exams_ExamID
	FOREIGN KEY (ExamID)
	REFERENCES Exams (ExamID)
GO

ALTER TABLE Exams
	ADD CONSTRAINT FK_Exams_TrainingFaculty_FacultyID
	FOREIGN KEY (FacultyID)
	REFERENCES TrainingFaculty (FacultyID)
GO

ALTER TABLE Exams
	ADD CONSTRAINT FK_Exams_Training_TrainingID
	FOREIGN KEY (TrainingID)
	REFERENCES Training (TrainingID)
GO

ALTER TABLE Users 
	ADD CONSTRAINT CK_Users_BirthDate 
	CHECK (BirthDate > SYSDATETIME())
GO

ALTER TABLE Exams 
	ADD CONSTRAINT DF_Exams_MaxResult 
	DEFAULT (100) FOR MaxResult
GO

ALTER TABLE ExamResults 
	ADD CONSTRAINT CK_ExamResults_Result
	CHECK (Result >= 0)
GO

CREATE NONCLUSTERED INDEX IX_Users_UserName ON dbo.Users (
	UserName ASC
)
GO

-- 4. feladat

USE AdventureWorks2019
GO

CREATE OR ALTER PROCEDURE dbo.Inflation
	@SubCategoryID INT = NULL,
	@Color NVARCHAR(15) = NULL, 
	@NewListPrice MONEY
AS 
	IF NOT EXISTS 
		(SELECT 1 FROM Production.Product AS P 
		WHERE (P.Color = @Color OR @Color IS NULL) AND (P.ProductSubcategoryID = @SubCategoryID OR @SubCategoryID IS NULL))
		RETURN 1 ;
	ELSE IF 
		(SELECT COUNT(1) FROM Production.Product AS P 
		WHERE (P.Color = @Color OR @Color IS NULL) AND (P.ProductSubcategoryID = @SubCategoryID OR @SubCategoryID IS NULL)) > 30
		RETURN 2 ;
	ELSE IF 
		(SELECT AVG(P.ListPrice) * 0.2 FROM Production.Product AS P 
		WHERE (P.Color = @Color OR @Color IS NULL) AND (P.ProductSubcategoryID = @SubCategoryID OR @SubCategoryID IS NULL)) < @NewListPrice
		RETURN 3 ;
	ELSE
		UPDATE Production.Product 
	 -- SET ListPrice = @NewListPrice
		SET ListPrice += @NewListPrice
		WHERE (Color = @Color OR Color IS NULL) AND (ProductSubcategoryID = @SubCategoryID OR ProductSubcategoryID IS NULL)
/*
EXEC dbo.Inflation @SubCategoryID = 2, @Color = 'Red', @NewListPrice = 5000
*/
GO

-- 5. feladat

CREATE DATABASE Training
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Training', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Training.mdf' , SIZE = 112640KB , FILEGROWTH = 9%), 
 FILEGROUP TrainingData 
( NAME = N'TrainingData', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\TrainingData.ndf' , SIZE = 112640KB , FILEGROWTH = 9%)
 LOG ON 
( NAME = N'Training_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Training_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 COLLATE Hungarian_CI_AS
 WITH LEDGER = OFF
GO
ALTER DATABASE Training SET COMPATIBILITY_LEVEL = 160
GO
ALTER DATABASE Training SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE Training SET ANSI_NULLS OFF 
GO
ALTER DATABASE Training SET ANSI_PADDING OFF 
GO
ALTER DATABASE Training SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE Training SET ARITHABORT OFF 
GO
ALTER DATABASE Training SET AUTO_CLOSE OFF 
GO
ALTER DATABASE Training SET AUTO_SHRINK OFF 
GO
ALTER DATABASE Training SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE Training SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE Training SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE Training SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE Training SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE Training SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE Training SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE Training SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE Training SET  DISABLE_BROKER 
GO
ALTER DATABASE Training SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE Training SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE Training SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE Training SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE Training SET  READ_WRITE 
GO
ALTER DATABASE Training SET RECOVERY SIMPLE 
GO
ALTER DATABASE Training SET  MULTI_USER 
GO
ALTER DATABASE Training SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE Training SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE Training SET DELAYED_DURABILITY = DISABLED 
GO
USE Training
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = On;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = Primary;
GO
USE Training
GO

-- 2. 
EXEC sys.sp_configure N'backup compression default', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO

-- 3. 
USE [master]
GO
CREATE LOGIN [TrainingAdmin] WITH PASSWORD=N'Pa55w.rd' MUST_CHANGE, DEFAULT_DATABASE=[Training], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
USE [Training]
GO
CREATE USER [TrainingAdmin] FOR LOGIN [TrainingAdmin]
GO

USE [master]
GO
CREATE LOGIN [TrainingRO] WITH PASSWORD=N'Pa55w.rd' MUST_CHANGE, DEFAULT_DATABASE=[Training], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
USE [Training]
GO
CREATE USER [TrainingRO] FOR LOGIN [TrainingRO]
GO

-- 4. 
ALTER SERVER ROLE [dbcreator] ADD MEMBER [TrainingAdmin]
GO

-- 5. 
USE [Training]
GO
ALTER ROLE [db_owner] ADD MEMBER [TrainingAdmin]
GO
USE [Training]
GO
ALTER ROLE [db_datareader] ADD MEMBER [TrainingRO]
GO

-- 6. 
USE [Training]
GO
CREATE ROLE [RoleBA]
GO

-- 7. 
USE [Training]
GO
CREATE SCHEMA [BA]
GO
use [Training]
GO
GRANT SELECT ON SCHEMA::[BA] TO [RoleBA]
GO

-- 8. 
-- scriptet kért a feladat, viszont én tárolt eljárással oldottam meg
CREATE OR ALTER PROCEDURE dbo.TrainingBackup
AS
BACKUP DATABASE [Training] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Training.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'Training-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO

-- 9. & 10. 
USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'TrainingBackupJob', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'bekáp', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'WINDOWS\user', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'TrainingBackupJob', @server_name = N'DESKTOP_SERVER'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'TrainingBackupJob', @step_name=N'exec_backup', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dbo.TrainingBackup', 
		@database_name=N'Training', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'TrainingBackupJob', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'bekáp', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'WINDOWS\user', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'TrainingBackupJob', @name=N'szkedzsöl', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20230416, 
		@active_end_date=99991231, 
		@active_start_time=20000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO

-- 11. 
USE [msdb]
GO
CREATE USER [TrainingAdmin] FOR LOGIN [TrainingAdmin]
GO
USE [msdb]
GO
ALTER ROLE [SQLAgentUserRole] ADD MEMBER [TrainingAdmin]
GO
