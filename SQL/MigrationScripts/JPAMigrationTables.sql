
USE CMSJPA

GO

-- JPA Base data - Fitness/Dental/Vacs/MilSkills
CREATE TABLE dbo.jpaFitness(
    jpafitID INT IDENTITY(1,1) NOT NULL,
	fitnessType VARCHAR(100),
	period INT NULL
	CONSTRAINT [PK_JPAFitness] PRIMARY KEY CLUSTERED 
	( jpafitID ASC) ON [PRIMARY]
) 
 
 GO
 
 /**
 CREATE TABLE dbo.jpaDental(
	[dentalType] [varchar](50),
	period INT NULL
 )
 
 GO
 **/
 
 CREATE TABLE dbo.jpaVaccinations(
    jpavacID INT IDENTITY(1,1) NOT NULL,
	vaccination VARCHAR(100),
	period INT NULL
	CONSTRAINT [PK_JPAVaccs] PRIMARY KEY CLUSTERED 
	( jpavacID ASC) ON [PRIMARY]
 )
 
 GO
 
 CREATE TABLE dbo.jpaMilitarySkills(
    jpamsID INT IDENTITY(1,1) NOT NULL,
	milSkill VARCHAR(100),
	period INT NULL
	CONSTRAINT [PK_JPAMilSkills] PRIMARY KEY CLUSTERED 
	( jpamsID ASC) ON [PRIMARY]
 )
 
 GO
 
