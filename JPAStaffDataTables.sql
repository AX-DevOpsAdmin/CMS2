
USE CMSJPA

GO

-- DROP TABLE jpaStaffFitness
-- DROP TABLE jpaStaffVaccinations
 
-- JPA Staff data - Fitness/Dental/Vacs/MilSkills

CREATE TABLE dbo.jpaStaffFitness(
    jsfID  INT IDENTITY(1,1) NOT NULL,
    staffID  INT, 
    jpafitID INT,
	startdate DATETIME,
	enddate DATETIME
CONSTRAINT [PK_JPAStF] PRIMARY KEY CLUSTERED 
 (
	jsfID ASC
) ON [PRIMARY]
) 
 
 GO
 
 CREATE TABLE dbo.jpaStaffDental(
    jsdID  INT IDENTITY(1,1) NOT NULL,
    staffID  INT, 
	startdate DATETIME,
	enddate DATETIME,
CONSTRAINT [PK_JPAStD] PRIMARY KEY CLUSTERED 
 (
	jsdID ASC
) ON [PRIMARY]
) 
 
 GO
 
 CREATE TABLE dbo.jpaStaffVaccinations(
    jsvID  INT IDENTITY(1,1) NOT NULL,
    staffID  INT, 
    jpavacID INT,
	vacdate DATETIME
CONSTRAINT [PK_JPAStV] PRIMARY KEY CLUSTERED 
 (
	jsvID ASC
) ON [PRIMARY]
) 
 
 GO
 