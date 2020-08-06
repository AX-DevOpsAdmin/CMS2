

-- USE RonCMS2
GO

/* first add the field ndeID to ALL existing tables - CHANGE THE NODE DEFAULT */
--exec sp_MSforeachtable 'ALTER TABLE ? ADD ndeID INT NOT NULL default 3'
--GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
ndeID INT ,
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

-- DROP TABLE tblTempTeam
/**
CREATE TABLE dbo.tblTempTeam (
ttID INT IDENTITY(1,1) NOT NULL,
teamID INT,
tblID INT,
ndeID INT,
ttparentID INT,
ttlevel INT,
ttname VARCHAR(100)
CONSTRAINT [PK_tempteam] PRIMARY KEY CLUSTERED 
(
	ttID ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
**/
-- DROP TABLE tblHierarchy
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

