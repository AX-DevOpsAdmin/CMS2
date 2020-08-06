
USE CMS2

GO

CREATE TABLE dbo.tblAuthsType(
	[atpID] [int] IDENTITY(1,1) NOT NULL,
	[authType] [varchar](500) NULL,
	[ndeID] [int] NULL,
 )
 
 GO
 
-- This adds the Authorisation Codes table, The Staff Authorisations table
-- and the Authorisation audit trail table
CREATE TABLE dbo.tblAuths(
	[authID] [int] IDENTITY(1,1) NOT NULL,
	[atpID] [int],
	[apprvID] [int],
	[authCode] [varchar](50),
	[authTask] [varchar](max) NULL,
	[authReqs] [varchar](max) NULL,
	[authRef] [varchar](500) NULL,
	[ndeID] [int] NULL,
 )
 
 GO

-- Table Authorisor
CREATE TABLE dbo.tblAuthorisor(
	asrID int IDENTITY(1,1) NOT NULL,
	staffID int,
	authID int,
	startdate datetime,
	enddate datetime,
	authoriser INT,
	authdate datetime,
	ndeID INT
 CONSTRAINT [PK_Authorisor] PRIMARY KEY CLUSTERED 
 (
	asrID ASC
) ON [PRIMARY]
) 
 GO
 
-- Table Staff Authorisations
-- DROP TABLE dbo.tblStaffAuths
CREATE TABLE dbo.tblStaffAuths(
	staID int IDENTITY(1,1) NOT NULL,
	adminID  int,
	admindate datetime,
	staffID int,
	startdate datetime,
	enddate datetime,
	authID int,
	authorisor int,
	authOK bit,
	authdate datetime,
	approver int,
	apprvOK bit,
	apprvdate datetime,
	ndeID INT
 CONSTRAINT [PK_staAuths] PRIMARY KEY CLUSTERED 
 (
	staID ASC
) ON [PRIMARY]
) 
 GO

-- Table Staff Auths Audit trail
--DROP TABLE dbo.tblStaffAuthsAudit
CREATE TABLE dbo.tblStaffAuthsAudit(
	saaID int IDENTITY(1,1) NOT NULL,
	authtype int,
	adminID  int,
	admindate datetime,
	staID int,
	staffID int,
	startdate datetime,
	enddate datetime,
	authID int,
	authorisor int,
	authOK bit,
	authdate datetime,
	approver int,
	apprvOK bit,
	apprvdate datetime,
	ndeID INT
 CONSTRAINT [PK_staffAuthsAudit] PRIMARY KEY CLUSTERED 
 (
	saaID ASC
) ON [PRIMARY]
) 
 GO
 
-- Table Authorisations Audit Trail
CREATE TABLE dbo.tblAuthsAudit(
	aaID int IDENTITY(1,1) NOT NULL,
	authoriser INT,
	authdate datetime,
	authtype int,
	authchange int,
	staffID int,
	authID int,
	startdate datetime,
	enddate datetime,	
	ndeID INT
 CONSTRAINT [PK_authsAudit] PRIMARY KEY CLUSTERED 
 (
	aaID ASC
) ON [PRIMARY]
) 
 GO

ALTER TABLE tblStaff
  ADD cmsadmin INT 
GO
 
ALTER TABLE tblStaff
  ADD authorisor INT 
  
/**
 INSERT INTO tblAuths
         (authID,apprvID,authCode,authTask,authReqs, authRef,ndeID)
 SELECT  authID, apprvID, authCode, authTask, authAddReqs, authRef, ndeID FROM CMS2Auths.dbo.tblAuths
         
**/ 