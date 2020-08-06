
-- CMSMigrateDBUpdate
-- Adds the ndeID and sets it to relevant value
-- Adds Hierarchy tables in preparation for migration

USE CMSMigrate
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON

GO

/*  THIS IS TO BE RUN  AGAINST EVERY CMS MIGRATE Dbase BEFORE DATA IS MIGRATED */

--first add the field ndeID to ALL existing tables - SET THE DEFAULT to the neccessary value
-- this will be whatever the tblNode ndeID is in the NEW CMS database for this CMS 
exec sp_MSforeachtable 'ALTER TABLE ? ADD ndeID INT NOT NULL default 0'

--GO

/***
CREATE TABLE dbo.tblHierarchy (
hrcID INT IDENTITY(1,1) NOT NULL,
teamID INT,
tblID INT,
ndeID INT,
hrcparentID INT,
hrclevel INT,
hrcname VARCHAR(100),
hrcchildren BIT
CONSTRAINT [PK_hierarchy] PRIMARY KEY CLUSTERED 
(
	hrcID ASC
) ON [PRIMARY]
) ON [PRIMARY]
**/
--DROP TABLE tblHierarchy
CREATE TABLE dbo.tblHierarchy (
hrcID INT ,
teamID INT,
tblID INT,
ndeID INT,
hrcparentID INT,
hrclevel INT,
hrcname VARCHAR(100),
hrcchildren BIT
)
GO
-- now go through relevant tables that have a related teamID field
-- and add hrcID - cos we will be using this in the future

ALTER TABLE tblTeamHierarchy
  ADD hrcID INT NOT NULL DEFAULT 0

  GO

ALTER TABLE tblPost
  ADD hrcID INT NOT NULL DEFAULT 0

  GO

ALTER TABLE tblOpTeam
  ADD hrcID INT NOT NULL DEFAULT 0

  GO

ALTER TABLE tbl_TaskUnit
  ADD hrcID INT NOT NULL DEFAULT 0
  
  GO

ALTER TABLE tblManager
  ADD hrcID INT NOT NULL DEFAULT 0
