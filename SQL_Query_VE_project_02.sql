USE AdventureWorks2019
GO

-- 1. feladat

SELECT TOP 20 SOH.SalesOrderID AS 'Rendelésszám',
			  SOH.DueDate AS 'Teljesítés dátuma',
			  SOH.TotalDue AS 'Rendelési összeg'
FROM Sales.SalesOrderHeader AS SOH 
INNER JOIN Sales.SalesOrderDetail AS SOD ON SOD.SalesOrderID = SOH.SalesOrderID
WHERE SOD.ProductID IN (
		SELECT P.ProductID
		FROM Production.Product AS P 
		INNER JOIN Sales.SalesOrderDetail AS SOD ON SOD.ProductID = P.ProductID
		WHERE P.Color = 'Yellow'
		GROUP BY P.ProductID
		) AND YEAR(SOH.DueDate) = 2014
GROUP BY SOH.SalesOrderID, SOH.DueDate, SOH.TotalDue
ORDER BY SOH.TotalDue DESC
GO

-- 2. feladat

CREATE OR ALTER VIEW dbo.Jersey2014 AS
SELECT P.ProductID,
	P.Name AS 'ProductName',
	SUM(IIF(SOD.SpecialOfferID = 1, SOD.LineTotal, NULL)) AS 'AmountWithNoOffer',
	SUM(IIF(SOD.SpecialOfferID <> 1, SOD.LineTotal, NULL)) AS 'AmountWithOffer',
	SUM(SOD.LineTotal) AS 'Amount'
FROM Production.Product AS P
INNER JOIN Sales.SalesOrderDetail AS SOD ON SOD.ProductID = P.ProductID
INNER JOIN Sales.SalesOrderHeader AS SOH ON SOH.SalesOrderID = SOD.SalesOrderID
WHERE P.ProductSubcategoryID = 23 AND YEAR(SOH.DueDate) = 2014
GROUP BY P.ProductID, P.Name
HAVING SUM(SOD.LineTotal) > 500
GO

SELECT * FROM dbo.Jersey2014
ORDER BY 2 DESC
GO

-- 3. feladat

CREATE DATABASE MovieScreenings
GO
USE MovieScreenings
GO

CREATE TABLE Cinemas (
	CinemaID TINYINT NOT NULL,
	CinemaName VARCHAR(100) NOT NULL,
	City VARCHAR(30) NOT NULL,
	MaxCapacity SMALLINT NOT NULL
	CONSTRAINT PK_Cinemas_CinemaID PRIMARY KEY (CinemaID)
)
GO

CREATE TABLE Movies (
	MovieID TINYINT NOT NULL,
	MovieName VARCHAR(100) NOT NULL,
	ProductionYear SMALLINT NOT NULL,
	MovieLength TINYINT NOT NULL,
	CONSTRAINT PK_Movies_MovieID PRIMARY KEY (MovieID)
)
GO

CREATE TABLE MovieScreenings (
	ScreeningID INT NOT NULL,
	ScreeningDate DATE NOT NULL, 
	CinemaID TINYINT NOT NULL, 
	MovieID TINYINT NOT NULL,
	NoOfViewers SMALLINT NOT NULL,
	RevenueHUF MONEY NOT NULL,
	CONSTRAINT PK_MovieScreenings_ScreeningID PRIMARY KEY (ScreeningID)
)
GO

ALTER TABLE MovieScreenings 
	ADD CONSTRAINT FK_MovieScreenings_Movies_MovieID
	FOREIGN KEY (MovieID)
	REFERENCES Movies (MovieID)
GO

ALTER TABLE MovieScreenings 
	ADD CONSTRAINT FK_MovieScreenings_Cinemas_CinemaID
	FOREIGN KEY (CinemaID)
	REFERENCES Cinemas (CinemaID)
GO

ALTER TABLE Cinemas 
	ADD CONSTRAINT UQ_Cinemas_CinemaName_City UNIQUE (CinemaName, City)
GO

ALTER TABLE Movies 
	ADD CONSTRAINT CK_Movies_ProductionYear CHECK (ProductionYear <= YEAR(SYSDATETIME()))
GO

ALTER TABLE MovieScreenings 
	ADD CONSTRAINT DF_MovieScreenings_ScreeningDate DEFAULT (SYSDATETIME()) FOR ScreeningDate
GO

ALTER TABLE MovieScreenings 
	ADD CONSTRAINT CK_MovieScreenings_NoOfViewers CHECK (NoOfViewers >= 0)
GO

ALTER TABLE MovieScreenings 
	ADD CONSTRAINT CK_MovieScreenings_RevenueHUF CHECK (RevenueHUF >= 0)
GO

CREATE NONCLUSTERED INDEX IX_Movies_MovieName ON dbo.Movies (MovieName)
GO

-- 4. feladat

USE AdventureWorks2019
GO

CREATE OR ALTER PROCEDURE HumanResources.InsertShift 
	@ShiftName NVARCHAR(50), 
	@StartTime TIME(7), 
	@EndTime TIME(7)
AS 
	IF @ShiftName IS NULL OR @StartTime IS NULL OR @EndTime IS NULL 
		RETURN 1 ;

	ELSE IF EXISTS (SELECT 1 FROM HumanResources.Shift AS HRS WHERE @ShiftName = HRS.Name)
		RETURN 2 ;

	ELSE IF EXISTS (SELECT 1 FROM HumanResources.Shift AS HRS WHERE @StartTime = HRS.StartTime AND @EndTime = HRS.EndTime)		
		RETURN 3 ;
	
	ELSE IF @StartTime > @EndTime
		RETURN 4 ;

	ELSE 
		INSERT HumanResources.Shift (Name, StartTime, EndTime)
		VALUES (@ShiftName, @StartTime, @EndTime)
		RETURN 0 ;

/* DEBUG_AND_TEST
BEGIN TRAN 
DECLARE @R INT
EXEC @R = HumanResources.InsertShift @ShiftName = 'TEST', @StartTime = '13:00:00', @EndTime = '15:00:00'
SELECT @R
select * from HumanResources.Shift
ROLLBACK TRAN
*/

GO

-- 5. feladat


-- 1. 


CREATE DATABASE [HungarianMovie]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HungarianMovie', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\HungarianMovie.mdf' , SIZE = 48128KB , FILEGROWTH = 14%), 
 FILEGROUP [HunMovieData] 
( NAME = N'HunDataFile', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\HunDataFile.ndf' , SIZE = 48128KB , FILEGROWTH = 14%)
 LOG ON 
( NAME = N'HungarianMovie_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\HungarianMovie_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 COLLATE Hungarian_CI_AS
 WITH LEDGER = OFF
GO
ALTER DATABASE [HungarianMovie] SET COMPATIBILITY_LEVEL = 160
GO
ALTER DATABASE [HungarianMovie] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HungarianMovie] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HungarianMovie] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HungarianMovie] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HungarianMovie] SET ARITHABORT OFF 
GO
ALTER DATABASE [HungarianMovie] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [HungarianMovie] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HungarianMovie] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE [HungarianMovie] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HungarianMovie] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HungarianMovie] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HungarianMovie] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HungarianMovie] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HungarianMovie] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HungarianMovie] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HungarianMovie] SET  DISABLE_BROKER 
GO
ALTER DATABASE [HungarianMovie] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HungarianMovie] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HungarianMovie] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HungarianMovie] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HungarianMovie] SET  READ_WRITE 
GO
ALTER DATABASE [HungarianMovie] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [HungarianMovie] SET  MULTI_USER 
GO
ALTER DATABASE [HungarianMovie] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HungarianMovie] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [HungarianMovie] SET DELAYED_DURABILITY = DISABLED 
GO
USE [HungarianMovie]
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
USE [HungarianMovie]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [HungarianMovie] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO


-- 2. 


USE [master]
GO
CREATE LOGIN [HunMovieAdmin] WITH PASSWORD=N'Pa55w.rd' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
USE [HungarianMovie]
GO
CREATE USER [HunMovieAdmin] FOR LOGIN [HunMovieAdmin]
GO

USE [master]
GO
CREATE LOGIN [HunMovieRO] WITH PASSWORD=N'Pa55w.rd' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
USE [HungarianMovie]
GO
CREATE USER [HunMovieRO] FOR LOGIN [HunMovieRO]
GO


-- 3. 


ALTER SERVER ROLE [dbcreator] ADD MEMBER [HunMovieAdmin]
GO


-- 4. 


USE [HungarianMovie]
GO
ALTER ROLE [db_owner] ADD MEMBER [HunMovieAdmin]
GO

USE [HungarianMovie]
GO
ALTER ROLE [db_datareader] ADD MEMBER [HunMovieRO]
GO


-- 5. 


USE [HungarianMovie]
GO
CREATE ROLE [RoleBI]
GO


-- 6. 


USE [HungarianMovie]
GO
CREATE SCHEMA [BI]
GO

use [HungarianMovie]
GO
GRANT SELECT ON SCHEMA::[BI] TO [RoleBI]
GO


-- 7. 


BACKUP DATABASE [HungarianMovie] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\HungarianMovie.bak' WITH NOFORMAT, NOINIT,  NAME = N'HungarianMovie-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO


-- 8. és 9. 


USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'HunMovieBackup', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP\user', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'HunMovieBackup', @server_name = N'DESKTOP'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'HunMovieBackup', @step_name=N'step1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP DATABASE [HungarianMovie] TO  DISK = N''C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\HungarianMovie.bak'' WITH NOFORMAT, NOINIT,  NAME = N''HungarianMovie-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO', 
		@database_name=N'HungarianMovie', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'HunMovieBackup', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP\user', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'HunMovieBackup', @name=N'HMB_Schedule_DAILY', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20230419, 
		@active_end_date=99991231, 
		@active_start_time=20000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO


-- 10. 


USE [msdb]
GO
CREATE USER [HunMovieAdmin] FOR LOGIN [HunMovieAdmin]
GO
USE [msdb]
GO
ALTER ROLE [SQLAgentUserRole] ADD MEMBER [HunMovieAdmin]
GO
