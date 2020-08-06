

 USE CMS2
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON

GO

/*  THIS IS TO BE RUN ONCE ONLY AGAINST THE NEW CMS DATABASE BEFORE ANY DATA IS MIGRATED */

--first add the field ndeID to ALL existing tables - 
exec sp_MSforeachtable 'ALTER TABLE ? ADD ndeID INT NOT NULL default 0'

GO

CREATE TABLE dbo.tblOrganisation (
orgID INT IDENTITY(1,1) NOT NULL,
orgName varchar(100)
CONSTRAINT [PK_org] PRIMARY KEY CLUSTERED 
(
	orgID ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE dbo.tblOrgAdmin (
ogaID INT IDENTITY(1,1) NOT NULL,
orgID INT,
staffID INT
CONSTRAINT [PK_orgadmin] PRIMARY KEY CLUSTERED 
(
	ogaID ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE dbo.tblNode (
ndeID INT IDENTITY(1,1) NOT NULL,
orgID INT,
ndename VARCHAR(100)
CONSTRAINT [PK_node] PRIMARY KEY CLUSTERED 
(
	ndeID ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE dbo.tblNodeAdmin (
ndaID INT IDENTITY(1,1) NOT NULL,
ndeID INT,
orgID INT,
staffID INT
CONSTRAINT [PK_nodeadmin] PRIMARY KEY CLUSTERED 
(
	ndaID ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

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

