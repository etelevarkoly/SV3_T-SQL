-- student_DB_v2.3 ; Etele Várkoly
-- database to store student data

-- KIPUCOLÁS.exe

USE master
GO
DROP DATABASE IF EXISTS eteleStudentDBv2
GO

-- INIT

CREATE DATABASE eteleStudentDBv2
GO

USE eteleStudentDBv2
GO

-- #################
-- CREATE_TABLES ###
-- #################

CREATE TABLE Users (
  userID INT IDENTITY(1, 1) NOT NULL,
  NeptunID CHAR(6) NOT NULL,
  FirstName VARCHAR(40) NOT NULL,
  LastName VARCHAR(40) NOT NULL,
  BirthDate DATE NOT NULL,
  BirthCountry CHAR(3) NOT NULL,
  BirthCity VARCHAR(40) NOT NULL,
  PostalCode VARCHAR(10) NOT NULL,
  Country CHAR(3) NOT NULL,
  City VARCHAR(40) NOT NULL,
  Address VARCHAR(100) NOT NULL,
  Gender CHAR(1) NOT NULL,
  TAJ CHAR(9) NULL,
  TaxID CHAR(10) NULL,
  IDNumber VARCHAR(20) NOT NULL,
  Email VARCHAR(80) NOT NULL,
  Phone VARCHAR(20) NOT NULL,
  LastModified DATETIME2 NOT NULL,
  CONSTRAINT PK_Users_userID PRIMARY KEY (userID),
  CONSTRAINT AK_Users_NeptunID UNIQUE (NeptunID),
  CONSTRAINT AK_Users_IDNumber UNIQUE (IDNumber),
  CONSTRAINT AK_Users_Email UNIQUE (Email)
)
GO

CREATE TABLE Training (
  TrainingID INT IDENTITY(1, 1) NOT NULL,
  TrainingCode VARCHAR(50) NOT NULL,
  FacultyID TINYINT NOT NULL,
  TrainingName_HU VARCHAR(160) NOT NULL,
  TrainingLevelID TINYINT NOT NULL,
  TrainingModeID TINYINT  NOT NULL,
  FinancingID TINYINT NOT NULL,
  SemesterCount TINYINT NOT NULL,
  LanguageID CHAR(2) NOT NULL,
  TStartSemester INT NOT NULL,
  CONSTRAINT PK_Training_TrainingID PRIMARY KEY (TrainingID),
  CONSTRAINT AK_Training_TrainingCode UNIQUE (TrainingCode)
)
GO

CREATE TABLE Major (
  MajorID INT IDENTITY(1, 1) NOT NULL,
  TrainingID INT NOT NULL,
  MajorCode VARCHAR(50) NOT NULL,
  MajorName_HU VARCHAR(160) NOT NULL,
  MStartSemester INT NOT NULL,
  CONSTRAINT PK_Major_MajorID PRIMARY KEY (MajorID),
  CONSTRAINT AK_Major_MajorCode UNIQUE (MajorCode)
)
GO

CREATE TABLE Curriculum (
  CurriculumID INT IDENTITY(1, 1) NOT NULL,
  MajorID INT NOT NULL,
  CurriculumCode VARCHAR(50) NOT NULL,
  CurriculumName_HU VARCHAR(160) NOT NULL,
  IsCurrent BIT NOT NULL,
  CcStartSemester INT NULL,
  CONSTRAINT PK_Curriculum_CurriculumID PRIMARY KEY (CurriculumID),
  CONSTRAINT AK_Curriculum_CurriculumCode UNIQUE (CurriculumCode)
)
GO

CREATE TABLE StudentTrainingSemester (
  TrainingSemesterID INT IDENTITY(1, 1) NOT NULL,
  userID INT NOT NULL,
  SemesterID INT NOT NULL,
  TrainingID INT NOT NULL,
  MajorID INT NOT NULL,
  CurriculumID INT NOT NULL,
  StatusID TINYINT NOT NULL,
  LastModified DATETIME2 NOT NULL,
  CONSTRAINT PK_StudentTrainingSemester PRIMARY KEY (TrainingSemesterID)
)
GO

CREATE TABLE Subjects (
  SubjectID INT IDENTITY(1, 1) NOT NULL,
  SubjectCode VARCHAR(50) NOT NULL,
  SubjectName_HU VARCHAR(200) NOT NULL,
  CurriculumID INT NOT NULL,
  Kredit TINYINT NOT NULL,
  IsMandatory BIT NOT NULL,
  SemesterID INT NOT NULL,
  RecommendedSemesterID INT NULL,
  SubjectTypeID TINYINT NOT NULL,
  CONSTRAINT PK_Subjects_SubjectID PRIMARY KEY (SubjectID),
  CONSTRAINT AK_Subjects_SubjectCode UNIQUE (SubjectCode)
)
GO

CREATE TABLE SubjectEnrollments (
  SubjectEnrollmentID INT IDENTITY(1, 1) NOT NULL,
  userID INT NOT NULL,
  SubjectID INT NOT NULL,
  SubjectEnrollmentDate DATETIME2 NOT NULL,
  SubjectDropOffDate DATETIME2 NULL,
  CONSTRAINT PK_SubjectEnrollments_SubjectEnrollmentID PRIMARY KEY (SubjectEnrollmentID)
)
GO

CREATE TABLE Exams (
  ExamID INT IDENTITY(1, 1) NOT NULL,
  SubjectID INT NOT NULL,
  ExamTypeID TINYINT NOT NULL,
  SemesterID INT NOT NULL,
  ExamStartDate DATETIME2 NOT NULL,
  CONSTRAINT PK_Exams_ExamID PRIMARY KEY (ExamID)
)
GO

CREATE TABLE ExamEnrollments (
  ExamEnrollmentID INT IDENTITY(1, 1) NOT NULL,
  ExamID INT NOT NULL,
  userID INT NOT NULL,
  ExamEnrollmentDate DATETIME2 NOT NULL,
  ExamDropOffDate DATETIME2 NULL,
  CONSTRAINT PK_ExamEnrollments_ExamEnrollmentID PRIMARY KEY (ExamEnrollmentID)
)
GO

CREATE TABLE ExamResults (
  ExamResultID INT IDENTITY(1, 1) NOT NULL,
  ExamEnrollmentID INT NOT NULL,
  Result INT NOT NULL,
  IsAppeared BIT NOT NULL,
  IsCountsIn BIT NOT NULL,
  CONSTRAINT PK_ExamResults_ExamResultID PRIMARY KEY (ExamResultID)
)
GO

CREATE TABLE DictResults (
  ResultID INT NOT NULL,
  ResultNum INT NOT NULL,
  Result_HU VARCHAR(30) NULL,
  ResultSign_HU VARCHAR(30) NULL,
  Result_EN VARCHAR(30) NULL,
  CONSTRAINT PK_DictResults_ResultID PRIMARY KEY (ResultID)
)
GO

CREATE TABLE DictFaculty (
  FacultyID TINYINT IDENTITY(1, 1) NOT NULL,
  FacultyCode VARCHAR(5) NOT NULL,
  FacultyName_HU VARCHAR(100) NOT NULL,
  FacultyName_EN VARCHAR(100) NOT NULL,
  CONSTRAINT PK_DictFaculty_FacultyID PRIMARY KEY (FacultyID)
)
GO

CREATE TABLE DictTrainingFinancingType (
  FinancingID TINYINT IDENTITY(1, 1) NOT NULL,
  FinancingName_HU VARCHAR(40) NOT NULL,
  FinancingName_EN VARCHAR(40) NOT NULL,
  CONSTRAINT PK_DictTrainingFinancingType PRIMARY KEY (FinancingID)
)
GO

CREATE TABLE DictTrainingMode (
  TrainingModeID TINYINT IDENTITY(1, 1) NOT NULL,
  ModeName_HU VARCHAR(40) NOT NULL,
  ModeName_EN VARCHAR(40) NOT NULL,
  CONSTRAINT PK_DictTrainingMode_TrainingModeID PRIMARY KEY (TrainingModeID)
)
GO

CREATE TABLE DictTrainingLevel (
  TrainingLevelID TINYINT IDENTITY(1, 1) NOT NULL,
  TrainingLevelName_HU VARCHAR(40) NOT NULL,
  TrainingLevelName_EN VARCHAR(40) NOT NULL,
  CONSTRAINT PK_DictTrainingLevel_TrainingLevelID PRIMARY KEY (TrainingLevelID)
)
GO

CREATE TABLE DictLanguage (
  LanguageID CHAR(2) NOT NULL,
  Language_HU VARCHAR(40) NOT NULL,
  Language_EN VARCHAR(40) NOT NULL,
  CONSTRAINT PK_DictLanguage_LanguageID PRIMARY KEY (LanguageID)
)
GO

CREATE TABLE DictStatus (
  StatusID TINYINT IDENTITY(1, 1) NOT NULL,
  StatusName_HU VARCHAR(40) NOT NULL,
  StatusName_EN VARCHAR(40) NOT NULL,
  CONSTRAINT PK_DictStatus_StatusID PRIMARY KEY (StatusID)
)
GO

CREATE TABLE DictSemester (
  SemesterID INT IDENTITY(1, 1) NOT NULL,
  SemesterNo CHAR(11) NOT NULL,
  CONSTRAINT PK_DictSemester_SemesterID PRIMARY KEY (SemesterID),
  CONSTRAINT AK_DictSemester_SemesterNo UNIQUE (SemesterNo)
)
GO

CREATE TABLE DictSubjectType (
  SubjectTypeID TINYINT IDENTITY(1, 1) NOT NULL,
  SubjectTypeName_HU VARCHAR(40) NOT NULL,
  SubjectTypeName_EN VARCHAR(40) NOT NULL,
  CONSTRAINT PK_DictSubjectType_SubjectTypeID PRIMARY KEY (SubjectTypeID)
)
GO

CREATE TABLE DictExamType (
  ExamTypeID TINYINT IDENTITY(1, 1) NOT NULL,
  ExamTypeName_HU VARCHAR(40) NOT NULL,
  ExamTypeName_EN VARCHAR(40) NOT NULL,
  CONSTRAINT PK_DictExamType_ExamTypeID PRIMARY KEY (ExamTypeID)
)
GO

CREATE TABLE DictCountry (
  CountryCode CHAR(3) NOT NULL,
  CountryName_HU VARCHAR(80) NOT NULL,
  CountryName_EN VARCHAR(80) NOT NULL,
  CONSTRAINT PK_DictCountry_CountryCode PRIMARY KEY (CountryCode)
)
GO

-- ################
-- FOREIGN_KEYS ###
-- ################ 

ALTER TABLE StudentTrainingSemester 
	ADD CONSTRAINT FK_StudentTrainingSemester_Users_userID 
	FOREIGN KEY (userID) 
	REFERENCES Users (userID)
GO

ALTER TABLE ExamEnrollments 
	ADD CONSTRAINT FK_ExamEnrollments_Users_userID
	FOREIGN KEY (userID) 
	REFERENCES Users (userID)
GO

ALTER TABLE SubjectEnrollments 
	ADD CONSTRAINT FK_SubjectEnrollments_Users_userID 
	FOREIGN KEY (userID) 
	REFERENCES Users (userID)
GO

ALTER TABLE StudentTrainingSemester 
	ADD CONSTRAINT FK_StudentTrainingSemester_Training_TrainingID 
	FOREIGN KEY (TrainingID) 
	REFERENCES Training (TrainingID)
GO

ALTER TABLE Major 
	ADD CONSTRAINT FK_Major_Training_TrainingID 
	FOREIGN KEY (TrainingID) 
	REFERENCES Training (TrainingID)
GO

ALTER TABLE StudentTrainingSemester 
	ADD CONSTRAINT FK_StudentTrainingSemester_Major_MajorID 
	FOREIGN KEY (MajorID) 
	REFERENCES Major (MajorID)
GO

ALTER TABLE Curriculum 
	ADD CONSTRAINT FK_Curriculum_Major_MajorID 
	FOREIGN KEY (MajorID) 
	REFERENCES Major (MajorID)
GO

ALTER TABLE StudentTrainingSemester 
	ADD CONSTRAINT FK_StudentTrainingSemester_Curriculum_CurriculumID 
	FOREIGN KEY (CurriculumID) 
	REFERENCES Curriculum (CurriculumID)
GO

ALTER TABLE Subjects 
	ADD CONSTRAINT FK_Subjects_Curriculum_CurriculumID 
	FOREIGN KEY (CurriculumID) 
	REFERENCES Curriculum (CurriculumID)
GO

ALTER TABLE Subjects 
	ADD CONSTRAINT FK_Subjects_DictSemester_SemesterID 
	FOREIGN KEY (SemesterID) 
	REFERENCES DictSemester (SemesterID)
GO

ALTER TABLE SubjectEnrollments 
	ADD CONSTRAINT FK_SubjectEnrollments_Subjects_SubjectID 
	FOREIGN KEY (SubjectID) 
	REFERENCES Subjects (SubjectID)
GO

ALTER TABLE Exams 
	ADD CONSTRAINT FK_Exams_Subjects_SubjectID 
	FOREIGN KEY (SubjectID) 
	REFERENCES Subjects (SubjectID)
GO

ALTER TABLE Exams 
	ADD CONSTRAINT FK_Exams_DictSemester_SemesterID
	FOREIGN KEY (SemesterID) 
	REFERENCES DictSemester (SemesterID)
GO

ALTER TABLE ExamEnrollments 
	ADD CONSTRAINT FK_ExamEnrollments_Exams_ExamID 
	FOREIGN KEY (ExamID) 
	REFERENCES Exams (ExamID)
GO

ALTER TABLE Training 
	ADD CONSTRAINT FK_Training_DictFaculty_FacultyID 
	FOREIGN KEY (FacultyID) 
	REFERENCES DictFaculty (FacultyID)
GO

ALTER TABLE Training 
	ADD CONSTRAINT FK_Training_DictTrainingFinancingType_FinancingID 
	FOREIGN KEY (FinancingID) 
	REFERENCES DictTrainingFinancingType (FinancingID)
GO

ALTER TABLE Training 
	ADD CONSTRAINT FK_Training_DictTrainingMode_TrainingModeID 
	FOREIGN KEY (TrainingModeID) 
	REFERENCES DictTrainingMode (TrainingModeID)
GO

ALTER TABLE Training 
	ADD CONSTRAINT FK_Training_DictTrainingLevel_TrainingLevelID 
	FOREIGN KEY (TrainingLevelID) 
	REFERENCES DictTrainingLevel (TrainingLevelID)
GO

ALTER TABLE Training 
	ADD CONSTRAINT FK_Training_DictLanguage_LanguageID 
	FOREIGN KEY (LanguageID) 
	REFERENCES DictLanguage (LanguageID)
GO

ALTER TABLE StudentTrainingSemester 
	ADD CONSTRAINT FK_StudentTrainingSemester_DictStatus_StatusID 
	FOREIGN KEY (StatusID) 
	REFERENCES DictStatus (StatusID)
GO

ALTER TABLE Subjects 
	ADD CONSTRAINT FK_Subjects_DictSemester_SemesterID 
	FOREIGN KEY (RecommendedSemesterID) 
	REFERENCES DictSemester (SemesterID)
GO

ALTER TABLE Training 
	ADD CONSTRAINT FK_Training_DictSemester_SemesterID 
	FOREIGN KEY (TStartSemester) 
	REFERENCES DictSemester (SemesterID)
GO

ALTER TABLE Major 
	ADD CONSTRAINT FK_Major_DictSemester_SemesterID 
	FOREIGN KEY (MStartSemester) 
	REFERENCES DictSemester (SemesterID)
GO

ALTER TABLE Curriculum 
	ADD CONSTRAINT FK_Curriculum_DictSemester_SemesterID 
	FOREIGN KEY (CcStartSemester) 
	REFERENCES DictSemester (SemesterID)
GO

ALTER TABLE Subjects 
	ADD CONSTRAINT FK_Subjects_DictSubjectType_SubjectTypeID 
	FOREIGN KEY (SubjectTypeID) 
	REFERENCES DictSubjectType (SubjectTypeID)
GO

ALTER TABLE Exams 
	ADD CONSTRAINT FK_Exams_DictExamType_ExamTypeID 
	FOREIGN KEY (ExamTypeID) 
	REFERENCES DictExamType (ExamTypeID)
GO

ALTER TABLE Users 
	ADD CONSTRAINT FK_Users_DictCountry_CountryCode 
	FOREIGN KEY (BirthCountry) 
	REFERENCES DictCountry (CountryCode)
GO

ALTER TABLE Users 
	ADD CONSTRAINT FK_Users_DictCountry_Country_CountryCode 
	FOREIGN KEY (Country) 
	REFERENCES DictCountry (CountryCode)
GO

ALTER TABLE ExamResults 
	ADD CONSTRAINT FK_ExamResults_ExamEnrollments_ExamEnrollmentID 
	FOREIGN KEY (ExamEnrollmentID) 
	REFERENCES ExamEnrollments (ExamEnrollmentID)
GO

ALTER TABLE ExamResults 
	ADD CONSTRAINT FK_ExamResults_DictResults_Result
	FOREIGN KEY (Result)
	REFERENCES DictResults (ResultID)
GO

-- #######################
-- DEFAULT_CONSTRAINTS ###
-- #######################

ALTER TABLE Users 
	ADD CONSTRAINT DF_Users_LastModified 
	DEFAULT (SYSDATETIME()) FOR LastModified
GO

ALTER TABLE Users 
	ADD CONSTRAINT DF_Users_Country
	DEFAULT ('HU') FOR Country
GO

ALTER TABLE StudentTrainingSemester 
	ADD CONSTRAINT DF_StudentTrainingSemester_LastModified 
	DEFAULT (SYSDATETIME()) FOR LastModified
GO

ALTER TABLE Subjects 
	ADD CONSTRAINT DF_Subjects_IsMandatory
	DEFAULT (1) FOR IsMandatory
GO

ALTER TABLE SubjectEnrollments 
	ADD CONSTRAINT DF_SubjectEnrollments_SubjectEnrollmentDate 
	DEFAULT (SYSDATETIME()) FOR SubjectEnrollmentDate
GO

ALTER TABLE ExamEnrollments  
	ADD CONSTRAINT DF_ExamEnrollments_ExamEnrollmentDate 
	DEFAULT (SYSDATETIME()) FOR ExamEnrollmentDate
GO

ALTER TABLE ExamResults 
	ADD CONSTRAINT DF_ExamResults_IsAppeared
	DEFAULT (1) FOR IsAppeared
GO 

ALTER TABLE ExamResults 
	ADD CONSTRAINT DF_ExamResults_IsCountsIn
	DEFAULT (1) FOR IsCountsIn
GO

-- #####################
-- CHECK_CONSTRAINTS ###
-- #####################

ALTER TABLE Users 
	ADD CONSTRAINT CK_Users_BirthDate 
	CHECK (BirthDate < SYSDATETIME())
GO

ALTER TABLE Users 
	ADD CONSTRAINT CK_Users_Gender 
	CHECK (Gender IN ('F', 'M'))
GO

ALTER TABLE Users
	ADD CONSTRAINT CK_Users_NeptunID 
	CHECK (NeptunID LIKE '[a-z,A-Z,0-9][a-z,A-Z,0-9][a-z,A-Z,0-9][a-z,A-Z,0-9][a-z,A-Z,0-9][a-z,A-Z,0-9]'
		AND (LEN(REPLACE(NeptunID, ' ', ''))) = 6)
GO

ALTER TABLE Users 
	ADD CONSTRAINT CK_Users_IDNumber 
	CHECK (LEN(REPLACE(IDNumber, ' ', '')) >= 8 
		-- AND NOT LTRIM(RTRIM(IDNumber)) = ''
		-- AND IDNumber NOT LIKE '% %'
		AND IDNumber NOT LIKE '%[^a-z,A-Z,0-9]%')
GO

ALTER TABLE Users 
	ADD CONSTRAINT CK_Users_Email
	CHECK (Email LIKE '%@___%.%')
GO

ALTER TABLE Subjects 
	ADD CONSTRAINT CK_Subjects_Kredit 
	CHECK (Kredit < 30)
GO

ALTER TABLE SubjectEnrollments 
	ADD CONSTRAINT CK_SubjectEnrollments_SubjectEncrollmentDate
	CHECK (SubjectEnrollmentDate <= SYSDATETIME())
GO

ALTER TABLE SubjectEnrollments 
	ADD CONSTRAINT CK_SubjectEnrollments_SubjectDropOffDate
	CHECK (SubjectDropOffDate <= SYSDATETIME())
GO

ALTER TABLE Exams 
	ADD CONSTRAINT CK_Exams_ExamStartDate 
	CHECK (ExamStartDate >= SYSDATETIME())
GO

ALTER TABLE ExamEnrollments 
	ADD CONSTRAINT CK_ExamEnrollments_ExamEncrollmentDate
	CHECK (ExamEnrollmentDate <= SYSDATETIME())
GO

ALTER TABLE ExamEnrollments 
	ADD CONSTRAINT CK_ExamEnrollments_ExamDropOffDate
	CHECK (ExamDropOffDate <= SYSDATETIME())
GO

ALTER TABLE DictSemester 
	ADD CONSTRAINT CK_DictSemester_SemesterNo 
	CHECK (SemesterNo LIKE '%____/____%/[1-2]')
GO

-- ####################
-- CREATE_FUNCTIONS ###
-- ####################

-- SCALAR_FUNCTION = returns the active semester count for a user
CREATE OR ALTER FUNCTION dbo.ActiveSemesters (@UID INT) RETURNS VARCHAR(1000) AS
	BEGIN
		IF 
			@UID IS NULL OR @UID = 0
			RETURN 1 ; 
		ELSE IF 
			@UID NOT IN (SELECT userID FROM Users)
			RETURN 2 ;
		ELSE
			DECLARE @AS TINYINT ;
			SELECT @AS = COUNT(1)
			FROM Users AS U 
			INNER JOIN StudentTrainingSemester AS STS 
			ON U.userID = STS.userID AND STS.userID = @UID
			WHERE STS.StatusID = 1
		RETURN @AS ;
	END

-- select dbo.ActiveSemesters(180)

GO

-- SCALAR_FUNCTION = returns the acquired/completed credits for a user based on the provided curriculumID
CREATE OR ALTER FUNCTION dbo.CompletedKredit (@UID INT, @CID INT) RETURNS VARCHAR(1000) AS
	BEGIN
		IF 
			@UID IS NULL OR @UID = 0 OR @CID IS NULL OR @CID = 0
			RETURN 1 ;
		ELSE IF 
			@UID NOT IN (SELECT userID FROM Users)
			RETURN 2 ;
		ELSE IF 
			@CID NOT IN (SELECT CurriculumID FROM Curriculum)
			RETURN 3 ; 
		ELSE IF 
			@CID NOT IN (SELECT CurriculumID FROM StudentTrainingSemester)
			RETURN 4 ;
		ELSE 
			DECLARE @CK INT ; 
			SELECT @CK = SUM(S.Kredit)
			FROM Subjects AS S 
			INNER JOIN SubjectEnrollments AS SE ON S.SubjectID = SE.SubjectID
			INNER JOIN Exams AS EX ON EX.SubjectID = S.SubjectID
			INNER JOIN ExamEnrollments AS EE ON EE.ExamID = EX.ExamID
			INNER JOIN ExamResults AS ER ON ER.ExamEnrollmentID = EE.ExamEnrollmentID
			WHERE SE.SubjectDropOffDate IS NULL 
				AND EE.ExamDropOffDate IS NULL
				AND ER.Result > 1
				AND SE.userID = @UID 
				AND S.CurriculumID = @CID
		RETURN @CK ;
	END

-- SELECT dbo.CompletedKredit(180, 366)

GO

-- ###################
-- CREATE_TRIGGERS ###
-- ###################

-- DML_TRIGGER to update the LastModified date in table 'Users'
CREATE OR ALTER TRIGGER uTrg_Users_LastModified ON dbo.Users
	FOR UPDATE 
AS 
	DECLARE @Count INT;
	SET @Count = @@ROWCOUNT;
	IF @Count = 0 
	RETURN ; 

	SET NOCOUNT ON ;
	
	UPDATE Users 
	SET LastModified = SYSDATETIME()
	WHERE userID IN (SELECT inserted.userID FROM inserted)

/*
BEGIN TRAN
	SELECT * FROM users WHERE userID IN (1, 2)
		UPDATE Users 
		SET City = 'Miskolc'
		WHERE userID IN (1, 2)
	SELECT * FROM Users WHERE userID IN (1, 2)
ROLLBACK TRAN
*/

GO

-- DML_TRIGGER to update the LastModified date in TermData table if - for example - a StudentStatus suddenly has to be changed
CREATE OR ALTER TRIGGER uTrg_StudentTrainingSemester ON dbo.StudentTrainingSemester
	FOR UPDATE 
AS 
	DECLARE @Count INT;
	SET @Count = @@ROWCOUNT;
	IF @Count = 0 
	RETURN ; 

	SET NOCOUNT ON ;

	/*	
	UPDATE StudentTrainingSemester 
	SET LastModified = SYSDATETIME()
	WHERE userID IN (SELECT inserted.userID FROM inserted)
	*/

	UPDATE StudentTrainingSemester
	SET LastModified = SYSDATETIME()
	FROM inserted AS I 
	INNER JOIN dbo.StudentTrainingSemester AS STS ON STS.userID = I.userID

/*
BEGIN TRAN
	SELECT * FROM StudentTrainingSemester WHERE userID IN (41, 180)
		UPDATE StudentTrainingSemester 
		SET StatusID = 2
		WHERE userID IN (41, 180)
	SELECT * FROM StudentTrainingSemester
ROLLBACK TRAN
*/

GO

-- DML_TRIGGER to update dates in SubjectEnrollments
CREATE OR ALTER TRIGGER uTrg_SubjectEnrollments ON dbo.SubjectEnrollments
	FOR UPDATE 
AS 
	DECLARE @Count INT ; 
	SET @Count = @@ROWCOUNT ;
	IF @Count = 0 
	RETURN ;

	SET NOCOUNT ON ; 

	IF UPDATE (SubjectEnrollmentDate)
	BEGIN
		UPDATE SubjectEnrollments 
		SET SubjectEnrollmentDate = SYSDATETIME()
		FROM inserted AS I 
		INNER JOIN SubjectEnrollments AS SE ON SE.SubjectEnrollmentID = I.SubjectEnrollmentID
			IF EXISTS (
						SELECT SE.SubjectDropOffDate FROM SubjectEnrollments AS SE 
						INNER JOIN inserted AS I ON SE.SubjectEnrollmentID = I.SubjectEnrollmentID
					  )
				UPDATE SubjectEnrollments 
				SET SubjectDropOffDate = NULL 
				FROM inserted AS I 
				INNER JOIN SubjectEnrollments AS SE ON SE.SubjectEnrollmentID = I.SubjectEnrollmentID
	END

	IF UPDATE (SubjectDropOffDate)
	BEGIN
		UPDATE SubjectEnrollments 
		SET SubjectDropOffDate = SYSDATETIME()
		FROM inserted AS I 
		INNER JOIN SubjectEnrollments AS SE ON SE.SubjectEnrollmentID = I.SubjectEnrollmentID
	END

/*
BEGIN TRAN
	SELECT * FROM SubjectEnrollments WHERE SubjectDropOffDate IS NOT NULL
		UPDATE SubjectEnrollments 
		SET SubjectEnrollmentDate = '19990101'
		WHERE userID IN (41, 203)
	SELECT * FROM SubjectEnrollments WHERE SubjectEnrollmentID IN (52,63,72,82)
ROLLBACK TRAN
*/

GO

-- DML_TRIGGER to update dates in ExamEnrollments
CREATE OR ALTER TRIGGER uTrg_ExamEnrollments ON dbo.ExamEnrollments
	FOR UPDATE 
AS 
	DECLARE @Count INT ; 
	SET @Count = @@ROWCOUNT ;
	IF @Count = 0 
	RETURN ;

	SET NOCOUNT ON ; 

	IF UPDATE (ExamEnrollmentDate)
	BEGIN
		UPDATE ExamEnrollments 
		SET ExamEnrollmentDate = SYSDATETIME()
		FROM inserted AS I 
		INNER JOIN ExamEnrollments AS EE ON EE.ExamEnrollmentID = I.ExamEnrollmentID
			IF EXISTS (
						SELECT EE.ExamDropOffDate 
						FROM ExamEnrollments AS EE 
						INNER JOIN inserted AS I ON EE.ExamEnrollmentID = I.ExamEnrollmentID
					  ) 
				UPDATE ExamEnrollments 
				SET ExamDropOffDate = NULL 
				FROM inserted AS I 
				INNER JOIN ExamEnrollments AS EE ON EE.ExamEnrollmentID = I.ExamEnrollmentID
	END

	IF UPDATE (ExamDropOffDate)
	BEGIN
		UPDATE ExamEnrollments 
		SET ExamDropOffDate = SYSDATETIME()
		FROM inserted AS I 
		INNER JOIN ExamEnrollments AS EE ON EE.ExamEnrollmentID = I.ExamEnrollmentID
	END

/*
BEGIN TRAN
	SELECT * FROM ExamEnrollments WHERE ExamDropOffDate IS NOT NULL
		UPDATE ExamEnrollments
		SET ExamEnrollmentDate = '19990101'
		WHERE userID IN (41, 180)
	SELECT * FROM ExamEnrollments [WHERE ExamEnrollmentID IN (n,...)]
ROLLBACK TRAN
*/

GO

-- ############################
-- CREATE_STORED_PROCEDURES ###
-- ############################

-- stored procedure to enroll for a subject
CREATE OR ALTER PROCEDURE dbo.SubjectEnroll 
	@UID INT,
	@SubID INT
AS 
	BEGIN
	SET NOCOUNT ON ;
		IF 
			@UID IS NULL OR @UID = 0 OR @SubID IS NULL OR @SubID = 0
			RETURN 100 ;
		ELSE IF 
			@UID NOT IN (SELECT userID FROM Users)
			RETURN 101 ;
		ELSE IF 
			@SubID NOT IN (SELECT SubjectID FROM Subjects)
			RETURN 102 ;
		ELSE
			INSERT SubjectEnrollments (userID, SubjectID)
			VALUES (@UID, @SubID)
	END

/*
-- usage
BEGIN TRAN
	DECLARE @R INT
	EXEC @R = dbo.SubjectEnroll @UID = 1, @SubID = 1 
	SELECT @R 
SELECT * FROM SubjectEnrollments WHERE UserID = 1 AND SubjectID = 1
ROLLBACK TRAN
*/

GO

-- stored procedure to drop a subject
CREATE OR ALTER PROCEDURE dbo.SubjectDrop 
	@UID INT,
	@SubID INT
AS 
	BEGIN
	SET NOCOUNT ON ;
		IF 
			@UID IS NULL OR @UID = 0 OR @SubID IS NULL OR @SubID = 0
			RETURN 100 ;
		ELSE IF 
			NOT EXISTS (SELECT 1 FROM SubjectEnrollments AS SE WHERE userID = @UID AND SubjectID = @SubID)
			RETURN 104 ;
		ELSE
			UPDATE SubjectEnrollments 
			SET SubjectDropOffDate = SYSDATETIME()
			WHERE userID = @UID AND SubjectID = @SubID
	END

/*
-- usage
BEGIN TRAN
	SELECT * FROM SubjectEnrollments WHERE UserID = 180 AND SubjectID = 1
	DECLARE @R INT
	EXEC @R = dbo.SubjectDrop @UID = 180 , @SubID = 1 
	SELECT @R 
SELECT * FROM SubjectEnrollments WHERE UserID = 1 AND SubjectID = 1
ROLLBACK TRAN
*/

GO

-- stored procedure to enroll for an exam
CREATE OR ALTER PROCEDURE dbo.ExamEnroll 
	@UID INT,
	@ExamID INT
AS 
	BEGIN
	SET NOCOUNT ON ;
		IF 
			@UID IS NULL OR @UID = 0 OR @ExamID IS NULL OR @ExamID = 0
			RETURN 100 ;
		ELSE IF 
			@UID NOT IN (SELECT userID FROM Users)
			RETURN 101 ;
		ELSE IF 
			@ExamID NOT IN (SELECT ExamID FROM Exams)
			RETURN 105 ;
		ELSE IF 
			NOT EXISTS (SELECT 1 FROM SubjectEnrollments AS SE 
						INNER JOIN Exams AS E ON E.SubjectID = SE.SubjectID
						WHERE SE.userID = @UID AND E.ExamID = @ExamID)
			RETURN 106 ;
		ELSE
			INSERT ExamEnrollments (userID, ExamID)
			VALUES (@UID, @ExamID)
	END

/*
-- usage
BEGIN TRAN
	DECLARE @R INT
	EXEC @R = dbo.ExamEnroll @UID = 180, @ExamID = 1 
	SELECT @R 
SELECT * FROM ExamEnrollments WHERE UserID = 180 AND ExamID = 1
ROLLBACK TRAN
*/

GO

-- stored procedure to drop an exam
CREATE OR ALTER PROCEDURE dbo.ExamDrop 
	@UID INT,
	@ExamID INT
AS 
	BEGIN
	SET NOCOUNT ON ;
		IF 
			@UID IS NULL OR @UID = 0 OR @ExamID IS NULL OR @ExamID = 0
			RETURN 100 ;
		ELSE IF 
			NOT EXISTS (SELECT 1 FROM ExamEnrollments AS EE WHERE userID = @UID AND ExamID = @ExamID)
			RETURN 107 ;
		ELSE IF 
			DATEDIFF(day, SYSDATETIME(), (SELECT E.ExamStartDate FROM Exams AS E WHERE E.ExamID = @ExamID)) < 2
			RETURN 126 ;
		ELSE
			UPDATE ExamEnrollments 
			SET ExamDropOffDate = SYSDATETIME()
			WHERE userID = @UID AND ExamID = @ExamID
	END

/*
-- usage
BEGIN TRAN
	DECLARE @R INT
	EXEC @R = dbo.ExamDrop @UID = 180, @ExamID = 1 
	SELECT @R 
SELECT * FROM ExamEnrollments WHERE UserID = 180 AND ExamID = 1
ROLLBACK TRAN
*/

GO

-- stored procedure to import .csv
CREATE OR ALTER PROCEDURE dbo.csvBulkInsert 
	@Table VARCHAR(50),
	@Path NVARCHAR(MAX),
	@Codepage VARCHAR(10) = 65001
AS 
	DECLARE @DynSQL NVARCHAR(MAX)

	SET @DynSQL = 
'BULK INSERT ' + @Table +
' FROM ''' + @Path + '''
WITH (FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', CODEPAGE = ' + @Codepage +', FIRSTROW = 1)'

EXEC sp_executesql @DynSQL

GO

-- ###############
-- DATA_IMPORT ###
-- ###############

BULK INSERT dbo.DictSemester 
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\DictSemester.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n') 
GO

BULK INSERT dbo.DictFaculty 
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\DictFaculty.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001) 
GO

BULK INSERT dbo.DictCountry
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\DictCountry.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001) 
GO

BULK INSERT dbo.DictLanguage
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\DictLanguage.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001) 
GO

BULK INSERT dbo.DictTrainingFinancingType
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\DictTrainingFinancingType.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001) 
GO

BULK INSERT dbo.DictTrainingMode
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\DictTrainingMode.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001) 
GO

BULK INSERT dbo.DictTrainingLevel
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\DictTrainingLevel.csv'
WITH (FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = 65001) 
GO

BULK INSERT dbo.DictStatus
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\DictStatus.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001) 
GO

BULK INSERT dbo.DictSubjectType
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\DictSubjectType.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001) 
GO

BULK INSERT dbo.DictExamType
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\DictExamType.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001) 
GO

BULK INSERT dbo.DictResults
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\DictResults.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001) 
GO

BULK INSERT dbo.Users
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\user_data_TO_IMPORT.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001)
GO

BULK INSERT dbo.Training
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\Training_TO_IMPORT.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001)
GO

BULK INSERT dbo.Major
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\Major_TO_IMPORT.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001)
GO

BULK INSERT dbo.Curriculum
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\Curriculum_TO_IMPORT.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001)
GO

BULK INSERT dbo.StudentTrainingSemester
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\StudentTrainingSemester_TO_IMPORT.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001)
GO

BULK INSERT dbo.Subjects
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\Subjects_TO_IMPORT.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001)
GO

BULK INSERT dbo.SubjectEnrollments
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\SubjectEnrollments_TO_IMPORT.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001)
GO

BULK INSERT dbo.Exams
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\Exams_TO_IMPORT.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001)
GO

BULK INSERT dbo.ExamEnrollments
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\ExamEnrollments_TO_IMPORT.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001, FIRSTROW = 2)
GO

BULK INSERT dbo.ExamResults
FROM 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\ExamResults_TO_IMPORT.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = 65001, FIRSTROW = 2)
GO

-- ####################
-- CREATE_VIEWS #######
-- ####################

-- total student count for each Faculty, training level and training mode
CREATE OR ALTER VIEW dbo.vStudentCountStat AS
	SELECT DF.FacultyCode AS 'FACULTY_CODE',
		DF.FacultyName_HU AS 'FACULTY_NAME',
		DTM.ModeName_HU AS 'TRAINING_MODEL',
		DTL.TrainingLevelName_HU AS 'TRAINING_LEVEL',
		COUNT(DISTINCT STS.userID) AS 'TOTAL_STUDENT_COUNT'
	FROM StudentTrainingSemester AS STS 
	INNER JOIN Training AS T ON T.TrainingID = STS.TrainingID 
	INNER JOIN DictFaculty AS DF ON DF.FacultyID = T.FacultyID
	INNER JOIN DictTrainingMode AS DTM ON DTM.TrainingModeID = T.TrainingModeID
	INNER JOIN DictTrainingLevel AS DTL ON DTL.TrainingLevelID = T.TrainingLevelID
	GROUP BY DF.FacultyName_HU, DF.FacultyCode, DTM.ModeName_HU, DTL.TrainingLevelName_HU
GO
-- select * from dbo.vStudentCountStat


-- total student count for each finance stype
CREATE OR ALTER VIEW dbo.vStudentFinanceTypeCount AS
	SELECT DTFT.FinancingName_HU AS 'FINANCE_TYPE_HU', 
		COUNT(DISTINCT STS.userID) AS 'TOTAL_STUDENT_COUNT'
	FROM DictTrainingFinancingType AS DTFT 
	INNER JOIN Training AS T ON T.FinancingID = DTFT.FinancingID
	INNER JOIN StudentTrainingSemester AS STS ON STS.TrainingID = T.TrainingID
	GROUP BY DTFT.FinancingName_HU
GO
-- select * from dbo.vStudentFinanceTypeCount


-- total student count for not attending on exams - Faculty
CREATE OR ALTER VIEW dbo.vExamAttendance AS 
	SELECT DF.FacultyCode AS 'FACULTY_CODE',
		COUNT(DISTINCT EE.userID) AS 'TOTAL_NOT_ATTENDED'
	FROM ExamResults AS ER
	INNER JOIN ExamEnrollments AS EE ON ER.ExamEnrollmentID = EE.ExamEnrollmentID
	INNER JOIN StudentTrainingSemester AS STS ON STS.userID = EE.userID 
	INNER JOIN Training AS T ON T.TrainingID = STS.TrainingID
	INNER JOIN DictFaculty AS DF ON DF.FacultyID = T.FacultyID
	WHERE ER.IsAppeared = 0
	GROUP BY DF.FacultyCode
GO
-- select * from dbo.vExamAttendance


-- total student count for subject DropOffs groupped by Faculty
CREATE OR ALTER VIEW dbo.vSubjectDropOffStat AS 
	SELECT 
		DF.FacultyCode AS 'FACULTY_CODE',
		COUNT(DISTINCT SE.SubjectDropOffDate) AS 'TOTAL_SUBJECT_DROPOFFS'
	FROM StudentTrainingSemester AS STS 
	INNER JOIN SubjectEnrollments AS SE ON STS.userID = SE.userID
	INNER JOIN Training AS T ON T.TrainingID = STS.TrainingID 
	INNER JOIN DictFaculty AS DF ON DF.FacultyID = T.FacultyID
	WHERE SE.SubjectDropOffDate IS NOT NULL
	GROUP BY DF.FacultyCode
GO
-- select * from dbo.vSubjectDropOffStat

-- #############################
-- CREATE_DATABASE_ROLES #######
-- #############################

-- DB_ROLE 1 ; StuDBEmpRole

USE eteleStudentDBv2
GO
CREATE ROLE StuDBEmpRole AUTHORIZATION dbo
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictTrainingFinancingType TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictTrainingFinancingType TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictTrainingFinancingType TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictResults TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictResults TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictResults TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictExamType TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictExamType TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictExamType TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictTrainingLevel TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictTrainingLevel TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictTrainingLevel TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictCountry TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictCountry TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictCountry TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictLanguage TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictLanguage TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictLanguage TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictSemester TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictSemester TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictSemester TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictFaculty TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictFaculty TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictFaculty TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictTrainingMode TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictTrainingMode TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictTrainingMode TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictStatus TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictStatus TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictStatus TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictSubjectType TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictSubjectType TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictSubjectType TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
GRANT EXECUTE ON SCHEMA::dbo TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
GRANT INSERT ON SCHEMA::dbo TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
GRANT SELECT ON SCHEMA::dbo TO StuDBEmpRole
GO
use eteleStudentDBv2
GO
GRANT UPDATE ON SCHEMA::dbo TO StuDBEmpRole
GO


-- DB_ROLE 2 ; StuDBTeacherRole

USE eteleStudentDBv2
GO
CREATE ROLE StuDBTeacherRole AUTHORIZATION dbo
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.Users TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.Users TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.Users TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictTrainingMode TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictTrainingMode TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictTrainingMode TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictExamType TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictExamType TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictExamType TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictStatus TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictStatus TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictStatus TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.Curriculum TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.Curriculum TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.Curriculum TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictTrainingFinancingType TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictTrainingFinancingType TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictTrainingFinancingType TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.Major TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.Major TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.Major TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.StudentTrainingSemester TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.StudentTrainingSemester TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.StudentTrainingSemester TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictCountry TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictCountry TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictCountry TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictLanguage TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictLanguage TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictLanguage TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
GRANT EXECUTE ON SCHEMA::dbo TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
GRANT INSERT ON SCHEMA::dbo TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
GRANT SELECT ON SCHEMA::dbo TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
GRANT UPDATE ON SCHEMA::dbo TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictSemester TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictSemester TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictSemester TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictSubjectType TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictSubjectType TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictSubjectType TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictTrainingLevel TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictTrainingLevel TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictTrainingLevel TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.Training TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.Training TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.Training TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictResults TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictResults TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictResults TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictFaculty TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictFaculty TO StuDBTeacherRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictFaculty TO StuDBTeacherRole
GO



-- DB_ROLE 3 ; StuDBStudentRole

USE eteleStudentDBv2
GO
CREATE ROLE StuDBStudentRole AUTHORIZATION dbo
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictSubjectType TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictSubjectType TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictSubjectType TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.Subjects TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.Subjects TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.Subjects TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictLanguage TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictLanguage TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictLanguage TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictStatus TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictStatus TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictStatus TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.Curriculum TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.Curriculum TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.Curriculum TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.Exams TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.Exams TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.Exams TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictTrainingFinancingType TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictTrainingFinancingType TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictTrainingFinancingType TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictTrainingLevel TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictTrainingLevel TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictTrainingLevel TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.Users TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.Users TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictSemester TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictSemester TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictSemester TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictTrainingMode TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictTrainingMode TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictTrainingMode TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictResults TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictResults TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictResults TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.StudentTrainingSemester TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.StudentTrainingSemester TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.StudentTrainingSemester TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.ExamResults TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.ExamResults TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.ExamResults TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.Training TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.Training TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.Training TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictFaculty TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictFaculty TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictFaculty TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictExamType TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictExamType TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictExamType TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.Major TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.Major TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.Major TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.SubjectEnrollments TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
GRANT EXECUTE ON SCHEMA::dbo TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
GRANT INSERT ON SCHEMA::dbo TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
GRANT SELECT ON SCHEMA::dbo TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
GRANT UPDATE ON SCHEMA::dbo TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.DictCountry TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY INSERT ON dbo.DictCountry TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY UPDATE ON dbo.DictCountry TO StuDBStudentRole
GO
use eteleStudentDBv2
GO
DENY DELETE ON dbo.ExamEnrollments TO StuDBStudentRole
GO


-- ###############################
-- CREATE_LOGINS_AND_USERS #######
-- ###############################


-- login 1

USE master
GO
CREATE LOGIN StuDBAdmin WITH PASSWORD=N'Pa55w0rd!' MUST_CHANGE, DEFAULT_DATABASE=eteleStudentDBv2, CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
ALTER SERVER ROLE bulkadmin ADD MEMBER StuDBAdmin
GO
use master;
GO
USE eteleStudentDBv2
GO
CREATE USER StuDBAdmin FOR LOGIN StuDBAdmin
GO
USE eteleStudentDBv2
GO
ALTER ROLE db_owner ADD MEMBER StuDBAdmin
GO


-- login 2 

USE master
GO
CREATE LOGIN StuDBEmp WITH PASSWORD=N'Pa55w0rd!' MUST_CHANGE, DEFAULT_DATABASE=eteleStudentDBv2, CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
ALTER SERVER ROLE bulkadmin ADD MEMBER StuDBEmp
GO
USE eteleStudentDBv2
GO
CREATE USER StuDBEmp FOR LOGIN StuDBEmp
GO
USE eteleStudentDBv2
GO
ALTER ROLE StuDBEmpRole ADD MEMBER StuDBEmp
GO


-- login 3 

USE master
GO
CREATE LOGIN StuDBTeacher WITH PASSWORD=N'Pa55w0rd!' MUST_CHANGE, DEFAULT_DATABASE=eteleStudentDBv2, CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
USE eteleStudentDBv2
GO
CREATE USER StuDBTeacher FOR LOGIN StuDBTeacher
GO
USE eteleStudentDBv2
GO
ALTER ROLE StuDBTeacherRole ADD MEMBER StuDBTeacher
GO


-- login 4 

USE master
GO
CREATE LOGIN StuDBStudent WITH PASSWORD=N'Pa55w0rd!' MUST_CHANGE, DEFAULT_DATABASE=eteleStudentDBv2, CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
use master;
GO
USE eteleStudentDBv2
GO
CREATE USER StuDBStudent FOR LOGIN StuDBStudent
GO
USE eteleStudentDBv2
GO
ALTER ROLE StuDBStudentRole ADD MEMBER StuDBStudent
GO

-- ################################
-- CREATE_APPLICATION_ROLE ########
-- ################################

USE eteleStudentDBv2
GO
CREATE APPLICATION ROLE StuDBAppRole WITH DEFAULT_SCHEMA = dbo, PASSWORD = N'Pa55w0rd!'
GO
USE eteleStudentDBv2
GO
ALTER AUTHORIZATION ON SCHEMA::dbo TO StuDBAppRole
GO
use eteleStudentDBv2
GO
GRANT EXECUTE ON dbo.csvBulkInsert TO StuDBAppRole
GO
use eteleStudentDBv2
GO
GRANT EXECUTE ON dbo.ExamDrop TO StuDBAppRole
GO
use eteleStudentDBv2
GO
GRANT EXECUTE ON dbo.ExamEnroll TO StuDBAppRole
GO
use eteleStudentDBv2
GO
GRANT EXECUTE ON dbo.SubjectDrop TO StuDBAppRole
GO
use eteleStudentDBv2
GO
GRANT EXECUTE ON dbo.SubjectEnroll TO StuDBAppRole
GO

-- #############################
-- CREATE_DAILY_BACKUP #########
-- #############################

-- TO_BE_DONE





-- ####################
-- DEBUG_AND_TEST #####
-- ####################

/* 
-- OSZTATLAN_TANAR
SELECT T.TrainingID, M.MajorID, C.CurriculumID, T.TrainingName_HU, M.MajorName_HU, C.CurriculumName_HU, C.IsCurrent 
FROM dbo.Major as M 
INNER JOIN dbo.Training AS T ON T.TrainingID = M.TrainingID
INNER JOIN dbo.Curriculum AS C ON C.MajorID = M.MajorID
WHERE T.TrainingID = 51
*/

/*
BEGIN TRAN
EXEC dbo.csvBulkInsert dictfaculty, 'C:\Users\user\Desktop\VIZSGAREMEK_DATA_IMPORT\DICTXD.csv'
SELECT * FROM DictFaculty
ROLLBACK TRAN
*/

/* 

-- DEFAULT_CONSTRAINT_DEBUG

DROP TABLE asd
CREATE TABLE asd (
id INT NOT NULL,
asd CHAR(3) NOT NULL
)
ALTER TABLE asd 
	ADD CONSTRAINT DF_asd
	DEFAULT ('HU') FOR asd
GO
INSERT asd (id)
VALUES (1)
SELECT * FROM asd

*/

/*

-- DML_TRIGGER_DEBUG

DROP TABLE asd 
CREATE TABLE asd (
asd INT NOT NULL,
LastModified DATETIME2 NOT NULL
CONSTRAINT DF_LastModified DEFAULT ('20000101')
)
GO

CREATE OR ALTER TRIGGER dbo.asd_Lastmodified ON dbo.asd
	FOR UPDATE 
AS 
	DECLARE @Count INT;
	SET @Count = @@ROWCOUNT;
	IF @Count = 0 
	RETURN ; 

	SET NOCOUNT ON ;
	
	/*
	UPDATE asd 
	SET LastModified = SYSDATETIME()
	WHERE asd IN (SELECT inserted.asd FROM inserted)
	*/

	UPDATE asd
	SET LastModified = SYSDATETIME()
	FROM inserted AS I 
	INNER JOIN asd AS U ON U.asd = I.asd
GO

SELECT * FROM asd
INSERT asd (asd)
VALUES (1)

UPDATE asd
SET asd = 100000 WHERE asd = 1

*/

/*

-- DML_TRIGGER DEBUG

DROP TABLE asd
CREATE TABLE asd (
SubjectEnrollmentID INT NOT NULL,
SubjectEnrollmentDate DATETIME2 NOT NULL,
SubjectDropOffDate DATETIME2 NULL
)
GO
INSERT asd (SubjectEnrollmentID,SubjectEnrollmentDate, SubjectDropOffDate)
VALUES (1,'20000101','30000101')
GO
INSERT asd (SubjectEnrollmentID,SubjectEnrollmentDate)
VALUES (2,'20000101')
GO
SELECT * FROM asd
GO
UPDATE asd 
SET SubjectEnrollmentDate = '20200101'
WHERE SubjectEnrollmentID = 2
GO
CREATE OR ALTER TRIGGER asd_enrollments ON dbo.asd
	FOR UPDATE 
AS 
	DECLARE @Count INT ; 
	SET @Count = @@ROWCOUNT ;
	IF @Count = 0 
	RETURN ;

	SET NOCOUNT ON ; 

	IF UPDATE (SubjectEnrollmentDate)
	BEGIN
		UPDATE asd 
		SET SubjectEnrollmentDate = SYSDATETIME()
		FROM inserted AS I 
		INNER JOIN asd AS SE ON SE.SubjectEnrollmentID = I.SubjectEnrollmentID
			IF (
				SELECT SE.SubjectDropOffDate 
				FROM asd AS SE 
				INNER JOIN inserted AS I 
				ON SE.SubjectEnrollmentID = I.SubjectEnrollmentID) IS NOT NULL 
				UPDATE asd 
				SET SubjectDropOffDate = NULL 
				FROM inserted AS I 
				INNER JOIN asd AS SE ON SE.SubjectEnrollmentID = I.SubjectEnrollmentID
	END

	IF UPDATE (SubjectDropOffDate)
	BEGIN
		UPDATE asd 
		SET SubjectDropOffDate = SYSDATETIME()
		FROM inserted AS I 
		INNER JOIN asd AS SE ON SE.SubjectEnrollmentID = I.SubjectEnrollmentID
	END
GO

*/

/*

-- SCALAR_FUNCTION_DEBUG

DROP TABLE userid, sts
CREATE TABLE userid (
	userid INT NOT NULL
)
GO
CREATE TABLE sts (
	userid INT NOT NULL,
	stsid TINYINT NOT NULL
)
GO
INSERT userid (userid)
VALUES (3)
INSERT sts (userid, stsid)
VALUES (3,5)
select * from sts
GO
CREATE OR ALTER FUNCTION dbo.kakukk (@UID INT) RETURNS VARCHAR(1000) AS
	BEGIN
		IF 
			@UID IS NULL OR @UID = 0
			RETURN 'INPUT_CANNOT_BE_NULL_OR_ZERO'
		ELSE IF 
			@UID NOT IN (SELECT userid FROM userid)
			RETURN 'USERID_NOT_FOUND'
		ELSE
			DECLARE @AS TINYINT ;
			SELECT @AS = COUNT(1)
			FROM userid AS U 
			INNER JOIN sts ON U.userid = sts.userid AND sts.userid = @UID
			WHERE sts.stsid = 10
		RETURN @AS ;
	END
GO
SELECT dbo.kakukk(3)

*/



/*

-- because there will only be test data in the DB this should be implemented later @STAGING phase

CREATE FUNCTION dbo.TAJCheck 
	(@TAJNo CHAR(9))
RETURNS BIT
AS
BEGIN
	DECLARE @I SMALLINT
    IF @TAJNo IS NULL 
		RETURN NULL
    ELSE IF LEN(@TAJNo) <> 9 OR @TAJNo LIKE '%[^0-9]%'	-- TRY_CAST(@TAJNo AS int) IS NULL 
		RETURN 0
    ELSE
		BEGIN
	        SET @I = (LEFT(@TAJNo, 1) * 3 + SUBSTRING(@TAJNo, 2, 1) * 7 + SUBSTRING(@TAJNo, 3, 1) * 3 + SUBSTRING(@TAJNo, 4, 1) * 7 + 
		        SUBSTRING(@TAJNo, 5, 1) * 3 + SUBSTRING(@TAJNo, 6, 1) * 7 + SUBSTRING(@TAJNo, 7, 1) * 3 + SUBSTRING(@TAJNo, 8, 1) * 7) % 10 
			IF @I = RIGHT(@TAJNo, 1)
				RETURN 1
		END
	RETURN 0
END	
GO

*/

/*
ALTER TABLE Users 
	ADD CONSTRAINT CK_Users_NeptunID 
	CHECK (LEN(NeptunID) = 6 AND NOT LTRIM(RTRIM(NeptunID)) = '' AND NeptunID LIKE '%[a-z,A-Z,0-9]%')
GO
*/

/*
TO_BE_IMPLEMENTED @staging, because there will only be test data in the DB @development

ALTER TABLE Users 
	ADD CONSTRAINT CK_Users_TAJ 
	CHECK (dbo.TAJCheck (TAJ) = 1)
GO
*/













































