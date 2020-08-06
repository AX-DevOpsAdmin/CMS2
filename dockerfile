USE [master]
GO
/****** Object:  Database [CMS2Template]    Script Date: 04/06/2016 15:22:12 ******/
CREATE DATABASE [CMS2Template] ON  PRIMARY 
( NAME = N'CMS_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\CMS2Template.MDF' , SIZE = 308096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'CMS_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\CMS2Template.LDF' , SIZE = 686016KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [CMS2Template] SET COMPATIBILITY_LEVEL = 80
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CMS2Template].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [CMS2Template] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [CMS2Template] SET ANSI_NULLS OFF
GO
ALTER DATABASE [CMS2Template] SET ANSI_PADDING OFF
GO
ALTER DATABASE [CMS2Template] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [CMS2Template] SET ARITHABORT OFF
GO
ALTER DATABASE [CMS2Template] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [CMS2Template] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [CMS2Template] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [CMS2Template] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [CMS2Template] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [CMS2Template] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [CMS2Template] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [CMS2Template] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [CMS2Template] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [CMS2Template] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [CMS2Template] SET  DISABLE_BROKER
GO
ALTER DATABASE [CMS2Template] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [CMS2Template] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [CMS2Template] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [CMS2Template] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [CMS2Template] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [CMS2Template] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [CMS2Template] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [CMS2Template] SET  READ_WRITE
GO
ALTER DATABASE [CMS2Template] SET RECOVERY FULL
GO
ALTER DATABASE [CMS2Template] SET  MULTI_USER
GO
ALTER DATABASE [CMS2Template] SET PAGE_VERIFY TORN_PAGE_DETECTION
GO
ALTER DATABASE [CMS2Template] SET DB_CHAINING OFF
GO
EXEC sys.sp_db_vardecimal_storage_format N'CMS2Template', N'ON'
GO
USE [CMS2Template]
GO
/****** Object:  User [NT AUTHORITY\IUSR]    Script Date: 04/06/2016 15:22:12 ******/
CREATE USER [NT AUTHORITY\IUSR] FOR LOGIN [NT AUTHORITY\IUSR]
GO
/****** Object:  User [NT AUTHORITY\ANONYMOUS LOGON]    Script Date: 04/06/2016 15:22:12 ******/
CREATE USER [NT AUTHORITY\ANONYMOUS LOGON] FOR LOGIN [NT AUTHORITY\ANONYMOUS LOGON]
GO
/****** Object:  User [BUILTIN\Administrators]    Script Date: 04/06/2016 15:22:13 ******/
CREATE USER [BUILTIN\Administrators] FOR LOGIN [BUILTIN\Administrators]
GO
/****** Object:  Schema [NT AUTHORITY\ANONYMOUS LOGON]    Script Date: 04/06/2016 15:22:13 ******/
CREATE SCHEMA [NT AUTHORITY\ANONYMOUS LOGON] AUTHORIZATION [NT AUTHORITY\ANONYMOUS LOGON]
GO
/****** Object:  Schema [BUILTIN\Administrators]    Script Date: 04/06/2016 15:22:13 ******/
CREATE SCHEMA [BUILTIN\Administrators] AUTHORIZATION [BUILTIN\Administrators]
GO
/****** Object:  StoredProcedure [dbo].[spTeamSearchResults]    Script Date: 04/06/2016 15:22:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spTeamSearchResults] 

@team varchar(50),
@sort int

AS



DECLARE @str varchar(255)

set @str = 'select * FROM dbo.vwTeamList where '

if @Team <>''

begin
	set @str=@str+' description like ' + '''' + @team +'%' + '''' +' and'
end

set @str=@str +'   1=1'

if @sort=1
	begin
		set @str=@str +' order by description asc, parentDescription asc'
	end

if @sort=2
	begin
		set @str=@str +' order by description desc, parentDescription desc'
	end

if @sort=3
	begin
		set @str=@str +' order by parentDescription asc,Description asc'
	end

if @sort=4
	begin
		set @str=@str +' order by parentDescription desc, Description desc'
	end

EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spTaskSearchResults]    Script Date: 04/06/2016 15:22:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[spTaskSearchResults] 
@nodeID INT,
@task varchar(50),
@ttID int,
@startDate varchar(50),
@endDate varchar(50),
@sort int,
@showOOA int

AS

SET dateformat dmy

DECLARE @str varchar(500)

DECLARE @noshow VARCHAR(50)
SET @noshow='Z-DO'

set @str = 'SELECT  tbl_Task.taskID, tbl_Task.ttID, tbl_Task.description AS task, tbl_Task.startDate, tbl_Task.endDate,'
set @str=@str+'tbl_Task.Cancellable, tbl_Task.ooa, tbl_Task.hqtask, tblTaskType.description AS Type '
set @str=@str+ 'FROM tbl_Task  INNER JOIN tblTaskType ON tbl_Task.ttID = tblTaskType.ttID '
set @str=@str+ '  WHERE tbl_Task.ndeID =' + CONVERT(VARCHAR(10),@nodeID) + ' AND tbl_Task.ttID <> 27 '

IF @task<>''
  set @str=@str+' AND tbl_Task.description like ' + '''' + @task +'%' + '''' 
ELSE
  set @str=@str+' AND tbl_Task.description NOT like ' + '''' + @noshow +'%' + '''' 


if @ttID <> 0
	Begin
	  set @str=@str + '  AND tbl_Task.ttID = ' + convert ( varchar(3),@ttID )

	End

-- if we are tasking from Hierarchy DO NOT allow Out of Area ( OOA) tasking
-- this MUST be done via the Tasking module
if @showOOA = 0
   begin
    --set @str=@str + '  and ooa = ' +'''' + '0' + ''''
    set @str=@str + ' AND ooa = 0 ' 
   end

set @str=@str + ' ORDER BY tbl_Task.description '

EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spTableUpdate]    Script Date: 04/06/2016 15:22:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spTableUpdate]
@RecID nvarchar (50),
@tabRecID varchar (20),
@tablename varchar(50),
@Description varchar (50),
@vpID varchar(4),
@Enduring varchar(1),
@Contingent varchar(1),
@amber varchar(4)

as

DECLARE @str varchar(255)

SELECT @str = 'UPDATE ' + @tablename + ' SET Description = ' + '''' + @Description + '''' + ', vpID = ' + '' + @vpID + ', Enduring = ' + '' + @Enduring + ', Contingent = ' + '' + @Contingent + '' + ', amber = ' + '' + @amber + ' where ' + @tabRecID + ' = ' + '' + @RecID + ''

EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spTableInsert]    Script Date: 04/06/2016 15:22:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spTableInsert]
  @tablename varchar(20),
  @Description varchar (50),
  @vpID varchar(4),
  @Enduring varchar(1),
  @Contingent varchar(1),
  @amber varchar(4)

as

--DECLARE @tablename varchar(50)
DECLARE @str varchar(255)

SELECT @str= 'INSERT ' + @tablename + '(Description, vpID, Enduring, Contingent, amber)  values (' + '''' + @Description + '''' + ', ' + '' + @vpID + '' + ', ' + '' + @Enduring + '' + ', ' + '' + @Contingent + '' + ', ' + '' + @amber + ')'

EXEC(@str)
GO
/****** Object:  Table [dbo].[tblAudit]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAudit](
	[audID] [smallint] IDENTITY(1,1) NOT NULL,
	[staffID] [int] NULL,
	[logOn] [datetime] NULL,
	[logOff] [datetime] NULL,
	[ndeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[audID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_TaskUnit]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_TaskUnit](
	[taskunitID] [int] IDENTITY(1,1) NOT NULL,
	[taskID] [int] NOT NULL,
	[teamID] [int] NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NOT NULL,
	[taskNote] [varchar](2000) NULL,
	[cancellable] [bit] NOT NULL,
	[active] [int] NOT NULL,
	[dateStamp] [datetime] NOT NULL,
	[updatedBy] [int] NOT NULL,
	[pending] [bit] NOT NULL,
	[ndeID] [int] NOT NULL,
	[hrcID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[taskunitID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_TaskStaff]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_TaskStaff](
	[taskStaffID] [int] IDENTITY(1,1) NOT NULL,
	[taskID] [int] NOT NULL,
	[staffID] [int] NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NOT NULL,
	[taskNote] [varchar](2000) NULL,
	[cancellable] [bit] NOT NULL,
	[active] [int] NOT NULL,
	[dateStamp] [datetime] NOT NULL,
	[updatedBy] [int] NOT NULL,
	[pending] [bit] NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tbl_TaskStaff] PRIMARY KEY CLUSTERED 
(
	[taskStaffID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_TaskCategory]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_TaskCategory](
	[taskCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[ttID] [int] NOT NULL,
	[description] [varchar](200) NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tbl_TaskCategory] PRIMARY KEY CLUSTERED 
(
	[taskCategoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Task]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Task](
	[taskID] [int] IDENTITY(1,1) NOT NULL,
	[ttID] [int] NOT NULL,
	[description] [varchar](1000) NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NOT NULL,
	[Cancellable] [bit] NOT NULL,
	[hqtask] [bit] NOT NULL,
	[ooa] [smallint] NULL,
	[sscID] [int] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tbl_Task] PRIMARY KEY CLUSTERED 
(
	[taskID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[spGetPersonnelAndQs]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetPersonnelAndQs]

@QStatus	INT,
@qualification	VARCHAR(1000),
@civi		INT,
@Gender		INT

AS

SET DATEFORMAT dmy

DECLARE @Str		VARCHAR(8000)

--Qualifications
IF @QStatus = 1
	BEGIN
		SET @Str = 'SELECT tblQTypes.Description + '' Q:' + ''' AS Type, tblQs.Description, tblQs.Amber, tblValPeriod.vpdays
		FROM tblQs
		INNER JOIN tblQTypes ON tblQs.QTypeID = tblQTypes.QtypeID
		INNER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
		WHERE tblQs.QID = ' + CONVERT(VARCHAR(3),@qualification) + ' '

		SET @Str = @Str + 'SELECT DISTINCT tblStaff.staffID, tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblStaffQs.ValidFrom
		FROM tblStaff
		INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
		INNER JOIN tblStaffQs ON tblStaff.staffID = tblStaffQs.StaffID
		INNER JOIN tblQs ON tblStaffQs.QID = tblQs.QID
		WHERE (tblStaffQs.QID = ' + CONVERT(VARCHAR(3),@qualification) + ')'
	END
	
	IF @civi = 0
		BEGIN
			SET @Str = @Str + 'AND tblRank.Weight <> 0 '
		END

	IF @Gender = '2'
		BEGIN
	       		SET @Str = @Str + ' AND tblStaff.sex =' + '''' + 'M' + '''' 
		END
	
	IF @Gender = '3'
		BEGIN
			SET @Str = @Str + ' AND tblStaff.sex =' + '''' + 'F' + '''' 
		END
		
	SET @Str = @Str + ' ORDER BY tblStaff.surname, tblStaff.serviceno'

--PRINT(@Str)
EXEC(@Str)
GO
/****** Object:  StoredProcedure [dbo].[spGetSelectedStaff]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- This will get all Staff Picked for Tasking in ManningTaskPersonnelAdd


CREATE     PROCEDURE [dbo].[spGetSelectedStaff]
@where VARCHAR(500)
AS

DECLARE @str VARCHAR(2000)

/**
SET @str = 'SELECT tblstaff.staffid, surname, serviceno, tblstaffharmony.ooadays 
    FROM tblStaff 
       left outer join tblstaffharmony on tblstaffharmony.staffid = tblstaff.staffid  
     where '
**/

SET @str = 'SELECT tblstaff.staffid, surname, serviceno, ddooa AS ooadays, ddssa AS ssadays, ddssb AS ssbdays
       FROM tblStaff 
         where '

SET @str = @str + @where 
SET @str = @str + ' order by surname '

EXEC (@str)
GO
/****** Object:  StoredProcedure [dbo].[spListCySteps]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- This will select the stages attached to the current cyle record


CREATE         PROCEDURE [dbo].[spListCySteps]
@RecID int,
@Where varchar(255)

as
DECLARE @str VARCHAR(255)

SELECT @str = 'SELECT tblCycleStage.description, cytStep FROM tblcycleSteps INNER JOIN tblcyclestage ON tblcyclestage.cysid = tblcycleSteps.cysID '
              +  @Where +  ' ORDER BY tblcycleSteps.cytStep'

exec @str

/*
SELECT tblCycleStage.description, cytStep
   FROM tblcycleSteps
     INNER JOIN tblcyclestage ON
        tblcyclestage.cysid = tblcycleSteps.cysID
    WHERE  tblcycleSteps.cyID = @recID
      ORDER BY tblcycleSteps.cytStep

*/
GO
/****** Object:  StoredProcedure [dbo].[spGetFromDate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spGetFromDate]

@todate  DATETIME,
@period INT,
@fromdate  DATETIME OUT

AS

DECLARE @dd INT
DECLARE @mm INT
DECLARE @yy INT
DECLARE @mdays INT
DECLARE @lpYear INT
DECLARE @lpdays INT

SET DATEFORMAT dmy

-- now work out the FROM date which is  to last
-- complete month end so take the months off for the period required 
-- + 1 take us to previous month
SET @period=@period+1
SET @fromdate=DATEADD ( month , - @period, @todate )  

SET @dd=DAY(@fromdate)
SET @mm=MONTH(@fromdate)
SET @yy=YEAR(@fromdate)

-- is it a leap year if @lpyear = 0 then yes
SET @lpYear = (@yy) % (4)
-- now set the days for Feb to 28 or 29 depending on leap year or not
SELECT @lpdays = 
   CASE @lpYear
     WHEN 0 THEN 29
     ELSE 28
   END

-- now find whether its 31, 30 or 28 day month
SELECT @mdays =
   CASE @mm
       WHEN 2 THEN @lpdays
       WHEN 4 THEN 30
       WHEN 6 THEN 30
       WHEN 9 THEN 30
       WHEN 11 THEN 30
       ELSE 31
   END 

-- now make sure the from date is the month end date
SET @fromdate=DATEADD ( DAY , (@mdays - @dd), @fromdate )
GO
/****** Object:  StoredProcedure [dbo].[spListTeamPostsInAndOut]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spListTeamPostsInAndOut] 
(
	@recID		INT,
	@all		INT,
	@thisDate	VARCHAR(16),
	@sort		INT
)

AS 

DECLARE @sqlString VARCHAR(4000)

SET DATEFORMAT dmy

IF @all = 1
	BEGIN
		SET @sqlString = 'SELECT staffPostID, tblPost.postID, tblPost.Assignno, tblPost.Ghost, tblManager.tmID AS Mgr, tblPost.description, tblPost.teamID, tblTeam.description AS TeamName '
		SET @sqlString = @sqlString + ',surname,firstname,serviceno,shortdesc,staffID,Trade,workphone,QTotal FROM tblPost INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID ' 
		SET @sqlString = @sqlString + 'LEFT OUTER JOIN tblManager on tblManager.postID =  tblPost.postID LEFT OUTER JOIN '
		SET @sqlString = @sqlString + '(SELECT * FROM vwStaffINPost WHERE  ''' + @thisDate + '''>= startDate AND (''' + @thisDate + '''<=ENDdate OR ENDDate IS NULL)) AS tempTable '
		SET @sqlString = @sqlString + 'ON tempTable.postId = tblPost.PostID '
		SET @sqlString = @sqlString + 'WHERE NOT EXISTS (SELECT taskStaffID FROM tbl_taskStaff WHERE ''' + @thisDate + ''' >=startDate AND ''' + @thisDate + ''' <=ENDDate AND tbl_taskStaff.staffId=tempTable.staffID AND active=1) '
		SET @sqlString = @sqlString + 'AND (tblPost.teamID = ' + CONVERT(VARCHAR(10),@recID) + ' OR tblPost.teamID IN (SELECT childID FROM vwAllChildren WHERE parentID = ' + CONVERT(VARCHAR(10),@recID) + ')) AND tblPost.Status = 1 '
		SET @sqlString = @sqlString + 'ORDER BY '

		IF @sort = 1
			BEGIN
				SET @sqlString = @sqlString + ' tempTable.weight ASc '
			END

		IF @sort = 2
			BEGIN
				SET @sqlString = @sqlString + ' tempTable.weight desc '
			END

		IF @sort = 3
			BEGIN
				SET @sqlString = @sqlString + ' surname desc '
			END

		IF @sort = 4
			BEGIN
				SET @sqlString = @sqlString + ' surname ASc '
			END

		IF @sort = 5
			BEGIN
				SET @sqlString = @sqlString + ' teamName desc '
			END

		IF @sort = 6
			BEGIN
				SET @sqlString = @sqlString + ' teamName ASc '
			END

		SET @sqlString = @sqlString + 'SELECT *, (SELECT Description FROM tbl_taskStaff INNER JOIN tbl_task ON tbl_taskStaff.tASkID = tbl_task.taskID '
		SET @sqlString = @sqlString + 'WHERE ''' + @thisDate + ''' >= tbl_taskStaff.startDate AND ''' + @thisDate + ''' <= tbl_taskStaff.ENDDate AND tbl_taskStaff.staffId = vwStaffINPost.staffID AND active = 1) AS Location, qualTotal AS QTotal FROM vwStaffINPost '
		SET @sqlString = @sqlString + 'WHERE EXISTS (SELECT taskStaffID FROM tbl_taskStaff WHERE ''' + @thisDate + ''' >=startDate AND ''' + @thisDate + ''' <=ENDDate AND tbl_taskStaff.staffId=vwStaffINPost.staffID AND active=1) '
		SET @sqlString = @sqlString + 'AND (teamID = ' + CONVERT(VARCHAR(10),@recID) + ' OR teamID IN (SELECT childID FROM vwAllChildren WHERE parentID = '+ CONVERT(VARCHAR(10),@recID) +' )) AND ''' + @thisDate + '''>= startDate AND (''' + @thisDate + '''<=ENDdate OR ENDDate IS NULL) AND GHOST=0 ORDER BY '

		IF @sort = 1
			BEGIN
				SET @sqlString = @sqlString + ' weight ASc '
			END

		IF @sort = 2
			BEGIN
				SET @sqlString = @sqlString + ' weight desc '
			END

		IF @sort = 3
			BEGIN
				SET @sqlString = @sqlString + ' surname desc '
			END

		IF @sort = 4
			BEGIN
				SET @sqlString = @sqlString + ' surname ASc '
			END

		IF @sort = 5
			BEGIN
				SET @sqlString = @sqlString + ' teamName desc '
			END

		IF @sort = 6
			BEGIN
				SET @sqlString = @sqlString + ' teamName ASc '
			END

		EXEC(@sqlString)

	END
ELSE
	BEGIN
		SET @sqlString = 'SELECT staffPostID,tblPost.postID, tblPost.ASsignno, tblPost.Ghost, tblManager.tmID AS Mgr, tblPost.description, tblPost.teamID, tblTeam.description AS TeamName '
		SET @sqlString = @sqlString + ',surname,firstname,serviceno,shortdesc,staffID,Trade,workphone,QTotal ' 
		SET @sqlString = @sqlString + 'FROM tblPost INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID LEFT OUTER JOIN tblManager ON tblManager.postID =  tblPost.postID ' 
		SET @sqlString = @sqlString + 'LEFT OUTER JOIN (SELECT * FROM vwStaffINPost WHERE  ''' + @thisDate + '''>= startDate AND (''' + @thisDate + '''<=ENDdate OR ENDDate IS NULL)) AS tempTable ' 
		SET @sqlString = @sqlString + 'ON tempTable.postId = tblPost.PostID ' 
		SET @sqlString = @sqlString + 'WHERE NOT EXISTS (SELECT tASkStaffID FROM tbl_taskStaff WHERE ''' + @thisDate + ''' >=startDate AND ''' + @thisDate + ''' <=ENDDate AND tbl_taskStaff.staffId=tempTable.staffID AND active=1) ' 
		SET @sqlString = @sqlString + 'AND (tblPost.teamID = ' + CONVERT(VARCHAR(10),@recID) + ') AND tblPost.Status = 1' 
		SET @sqlString = @sqlString + 'ORDER BY  ' 

		IF @sort = 1
			BEGIN
				SET @sqlString = @sqlString + ' tempTable.weight ASc '
			END

		IF @sort = 2
			BEGIN
				SET @sqlString = @sqlString + ' tempTable.weight desc '
			END

		IF @sort = 3
			BEGIN
				SET @sqlString = @sqlString + ' surname desc '
			END

		IF @sort = 4
			BEGIN
				SET @sqlString = @sqlString + ' surname ASc '
			END

		IF @sort = 5
			BEGIN
				SET @sqlString = @sqlString + ' teamName desc '
			END

		IF @sort = 6
			BEGIN
				SET @sqlString = @sqlString + ' teamName ASc '
			END

		SET @sqlString = @sqlString + 'SELECT *, (SELECT Description FROM tbl_taskStaff INNER JOIN tbl_task ON tbl_taskStaff.tASkID = tbl_task.taskID ' 
		SET @sqlString = @sqlString + 'WHERE ''' + @thisDate + ''' >= tbl_taskStaff.startDate AND ''' + @thisDate + ''' <= tbl_taskStaff.ENDDate AND tbl_taskStaff.staffId=vwStaffINPost.staffID AND active=1) AS Location,qualTotal AS QTotal FROM vwStaffINPost ' 
		SET @sqlString = @sqlString + 'WHERE EXISTS (SELECT tASkStaffID FROM tbl_tASkStaff WHERE ''' + @thisDate + ''' >=startDate AND ''' + @thisDate + ''' <=ENDDate AND tbl_taskStaff.staffId=vwStaffINPost.staffID AND active=1)  ' 
		SET @sqlString = @sqlString + 'AND teamID =  ' + CONVERT(VARCHAR(10),@recID) + ' AND ''' + @thisDate + '''>= startDate AND (''' + @thisDate + '''<=ENDdate OR ENDDate IS NULL) AND GHOST=0 ORDER BY  ' 

		IF @sort = 1
			BEGIN
				SET @sqlString = @sqlString + ' weight ASc '
			END

		IF @sort = 2
			BEGIN
				SET @sqlString = @sqlString + ' weight desc '
			END

		IF @sort = 3
			BEGIN
				SET @sqlString = @sqlString + ' surname desc '
			END

		IF @sort = 4
			BEGIN
				SET @sqlString = @sqlString + ' surname ASc '
			END

		IF @sort = 5
			BEGIN
				SET @sqlString = @sqlString + ' teamName desc '
			END

		IF @sort = 6
			BEGIN
				SET @sqlString = @sqlString + ' teamName ASc '
			END

		EXEC(@sqlString)
	END
GO
/****** Object:  StoredProcedure [dbo].[spListTable]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spListTable]

  @nodeID INT,
  @tablename varchar(50)

AS

DECLARE @str VARCHAR(2000)


SET @str='select * from ' + @tablename + ' WHERE ndeID= ' + CAST(@nodeID AS VARCHAR(10)) + ' '
EXEC (@str)
GO
/****** Object:  StoredProcedure [dbo].[spReIndexTables]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create      PROCEDURE [dbo].[spReIndexTables]
AS

DBCC DBREINDEX (tblStaffQs, '', 90)
DBCC DBREINDEX (tblPostQs, '', 90)
DBCC DBREINDEX (tblPostMilskill, '', 90)
DBCC DBREINDEX (tblStaffMilskill, '', 90)
DBCC DBREINDEX (tblStaffDental, '', 90)
DBCC DBREINDEX (tblStaffFitness, '', 90)
DBCC DBREINDEX (tblStaffMVs, '', 90)
DBCC DBREINDEX (tbl_TaskStaff, '', 90)
GO
/****** Object:  StoredProcedure [dbo].[spRecDetail]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[spRecDetail]
@RecID nvarchar (50),
@tabRecId varchar (20),
@tablename varchar(20)
as

DECLARE @str varchar(255)


SELECT @str = 'select * from ' + @tablename + ' where ' + @tabRecID  + ' = ' + '''' + @RecID + ''''

EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spQDetail]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spQDetail]
(
	@RecID	VARCHAR(50),
	@tabRecId	VARCHAR(20),
	@tablename	VARCHAR(20)
)

AS

EXEC ('SELECT ' + @tablename + '.*, tblValPeriod.description AS ValidityPeriod, tblQTypes.Description AS QType
FROM ' + @tablename + '
INNER JOIN tblValPeriod ON ' + @tablename + '.vpID = tblValPeriod.vpID
INNER JOIN tblQTypes ON ' + @tablename + '.QTypeID = tblQTypes.QTypeID
WHERE ' + @tabRecID  + ' = ' + '''' + @RecID + '''')
GO
/****** Object:  StoredProcedure [dbo].[spPostStaffSearchResults]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPostStaffSearchResults] 
(
	@surname	VARCHAR(50),
	@firstname	VARCHAR(50),
	@serviceno	VARCHAR(50),
	@ghost		BIT
)

AS

IF @surname = '' 
	BEGIN
 		SET @surname = '%'
	END

IF @firstname = '' 
	BEGIN
 		SET @firstname = '%'
	END

IF @serviceno = '' 
	BEGIN
 		SET @serviceno = '%'
	END

DECLARE @str VARCHAR(500)

IF @ghost <> 0
	BEGIN
		SET @str = 'SELECT staffid, surname, firstname, serviceno FROM tblStaff WHERE '
		SET @str = @str + 'surname LIKE ' + '''' + @surname + '%' + '''' + ' AND firstname LIKE ' + '''' + @firstname + '%' + '''' + ' AND serviceno LIKE ' + '''' + @serviceno + '%' + ''''
		SET @str = @str + ' AND 1=1 ORDER BY surname'
	END
ELSE
	BEGIN
		SET @str = 'SELECT staffID, surname, firstname, serviceno FROM tblstaff WHERE '
		SET @str = @str + 'surname LIKE ' + '''' + @surname + '%' + '''' + ' AND firstname LIKE ' + '''' + @firstname + '%' + '''' + ' AND serviceno LIKE ' + '''' + @serviceno + '%' + ''''
		SET @str = @str + 'AND staffid NOT IN (SELECT tblstaffpost.staffid FROM tblPost '
		SET @str = @str + 'RIGHT OUTER JOIN tblStaffPost ON tblstaff.postID = tblStaffPost.PostID '
		SET @str = @str + 'WHERE (tblStaffPost.endDate IS NULL) OR (tblStaffPost.endDate > GETDATE())) ORDER BY tblstaff.surname'
	END

EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spPostSearchResults]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spPostSearchResults] 
(   @nodeID INT,
	@post		VARCHAR(50),
	@assignno	VARCHAR(50),
	@hrcID		INT,
	@postholder	VARCHAR(50),
	@ghost		BIT,
	@status		BIT,
	@sort		INT
)

AS

DECLARE @str VARCHAR(2000)

SET @str = 'SELECT dbo.tblPost.postID, dbo.tblPost.description, dbo.tblPost.assignno, dbo.tblHierarchy.hrcID, dbo.tblHierarchy.hrcname AS team, 
                      dbo.tblRank.shortDesc + ' + '''' +' ''' + '+ dbo.tblStaff.surname + '  + '''' +' '''  + '+ dbo.tblStaff.firstname AS postholder, dbo.tblPost.Ghost, dbo.tblPost.Status'
SET @str = @str + ' FROM  dbo.tblPost INNER JOIN
                      dbo.tblRank ON dbo.tblPost.rankID = dbo.tblRank.rankID LEFT OUTER JOIN
                      dbo.tblHierarchy ON dbo.tblHierarchy.hrcID = dbo.tblPost.hrcID LEFT OUTER JOIN
                      dbo.tblStaffPost ON dbo.tblStaffPost.PostID = dbo.tblPost.postID AND (dbo.tblStaffPost.endDate IS NULL OR
                      dbo.tblStaffPost.endDate >= GETDATE()) LEFT OUTER JOIN
                      dbo.tblStaff ON dbo.tblStaff.staffID = dbo.tblStaffPost.StaffID '
SET @str = @str +  'WHERE tblPost.ndeID = ' + CONVERT(VARCHAR(5),@nodeID) + ' AND tblPost.hrcID<>0'

IF @post <> ''
	BEGIN
		SET @str = @str + ' AND tblPost.description LIKE ' + '''' + @post +'%' + '''' 
	END
IF @assignno <> ''
	BEGIN
		SET @str = @str + ' AND assignno LIKE ' + '''' + @assignno +'%' + ''''
	END

IF @hrcID <> 0
	BEGIN
		SET @str = @str + ' AND tblPost.hrcID = ' + CONVERT(VARCHAR(3),@hrcID) + ' '
	END

IF @postholder <> ''
	BEGIN
		SET @str = @str + ' AND dbo.tblStaff.surname LIKE ' + '''' + @postholder +'%' + ''''
	END

SET @str = @str + ' AND ghost = ' + CONVERT(VARCHAR(3),@ghost) + ' '

SET @str = @str + ' AND tblPost.status = ' + CONVERT(VARCHAR(3),@status) + ' AND 1=1'

IF @sort = 1
	BEGIN
		SET @str = @str + ' ORDER BY tblPost.description ASC, assignNo ASC'
	END

IF @sort = 2
	BEGIN
		SET @str = @str + ' ORDER BY tblPost.description DESC, assignNo DESC'
	END

IF @sort = 3
	BEGIN
		SET @str = @str + ' ORDER BY tblPost.assignNo ASC, tblPost.Description ASC'
	END

IF @sort = 4
	BEGIN
		SET @str = @str + ' ORDER BY assignNo DESC, tblPost.Description DESC'
	END

IF @sort = 5
	BEGIN
		SET @str = @str + ' ORDER BY tblPost.hrcID ASC, postHolder ASC'
	END

IF @sort = 6
	BEGIN
		SET @str = @str + ' ORDER BY tblPost.hrcID DESC, postHolder DESC'
	END

IF @sort = 7
	BEGIN
		SET @str = @str + ' ORDER BY postHolder ASC, tblPost.hrcID ASC'
	END

IF @sort = 8
	BEGIN
		SET @str = @str + ' ORDER BY postHolder DESC, tblPost.hrcID DESC'
	END

EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spQualificationStaffSearchResults]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spQualificationStaffSearchResults] 
(
    @nodeID INT,
	@surname	VARCHAR(50),
	@firstname	VARCHAR(50),
	@serviceno	VARCHAR(50),
	@TypeID		INT,
	@QID		INT
)

AS

IF @surname = '' 
	BEGIN
 		SET @surname='%'
	END

IF @firstname = '' 
	BEGIN
 		SET @firstname='%'
	END

IF @serviceno = '' 
	BEGIN
 		SET @serviceno='%'
	END

DECLARE @str VARCHAR(400)

SET @str = 'SELECT staffid, surname, firstname, serviceno FROM tblstaff WHERE ndeID = ' + CONVERT(VARCHAR(50), @nodeID) + ' AND active = 1'
SET @str = @str + ' AND NOT EXISTS (SELECT staffQID FROM tblStaffQs WHERE tblStaffQs.StaffID = tblstaff.StaffID AND typeID = ' + CONVERT(varchar(20),@TypeID) + ' AND QID = '+ CONVERT(varchar(20),@QID) + ') AND '

SET @str = @str + ' surname LIKE ' + '''' + @surname +'%' + '''' + ' AND firstname LIKE ' + '''' + @firstname +'%'+  '''' + '  AND serviceno LIKE ' + '''' + @serviceno +'%'+  ''''

SET @str = @str + ' ORDER BY surname'

EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spPersonnelToTaskSearchResults]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[spPersonnelToTaskSearchResults]
(
    @nodeID INT,
	@surname	VARCHAR(50),
	@firstname	VARCHAR(50),
	@serviceno	VARCHAR(50),
	--@TaskID	INT,
	@hrcID	INT,
	@pQ1		INT,
	@pQ2		INT,
	@pQ3		INT
)

AS

IF @surname = '' 
	BEGIN
 		SET @surname = '%'
	END

IF @firstname = '' 
	BEGIN
 		SET @firstname = '%'
	END

IF @serviceno = '' 
	BEGIN
 		SET @serviceno = '%'
	END

DECLARE @exist VARCHAR(2000)
DECLARE @str VARCHAR(2000)

SET @str = 'SELECT tblStaff.staffID, surname, firstname, serviceno,'
SET @str = @str + 'tblStaff.dischargeDate AS startReset, tblStaff.ddooa AS ooadays,'
SET @str = @str + ' tblStaff.ddssa AS ssadays,tblStaff.ddssb AS ssbdays, tblStaff.lastOOA FROM tblStaff '
SET @str = @str + 'INNER JOIN tblStaffPost ON tblStaffPost.StaffID = tblStaff.staffID  '
SET @str = @str + 'INNER JOIN tblPost ON tblPost.postID = tblStaffPost.PostID  '
SET @str = @str + 'INNER JOIN tblHierarchy ON tblHierarchy.hrcID = tblPost.hrcID '
SET @str = @str + 'WHERE  tblStaff.ndeID=' + CONVERT(VARCHAR(10),@nodeID) + ' AND tblPost.Ghost =0  AND '
SET @str = @str + '((Active = 1 AND endDate IS NULL) OR enddate > GETDATE()) AND '
SET @str = @str + ' surname LIKE ' + '''' + @surname +'%' + '''' + ' AND firstname LIKE ' + '''' + @firstname +'%'+  '''' + ' AND serviceno LIKE ' + '''' + @serviceno +'%'+  ''''

-- build up the query to searcg for Qs
SET @exist = ''
IF @hrcID <> 0 
	BEGIN
		SET @str = @str + ' AND tblHierarchy.hrcID= ' + CONVERT(VARCHAR(10),@hrcID) + ' AND enddate IS NULL '
	END
	
IF @pQ1 <> 0
	BEGIN 
		SET @exist = @exist + ' AND EXISTS (SELECT staffQID FROM tblStaffQs WHERE tblStaffQs.staffID = staffNo' 
		SET @exist = @exist + ' AND tblStaffQs.qID= ' +  CONVERT(VARCHAR(10),@pQ1) + ' AND tblStaffQs.typeID = 1  '
		SET @exist = @exist + ' AND tblStaffQs.validfrom < ' + '''' + CONVERT(VARCHAR(12),GETDATE())  + ''''
		SET @exist = @exist + ' AND (validend is NULL OR tblStaffQs.validend > ' + '''' + CONVERT(VARCHAR(12),GETDATE()) + '''' + ')' 
		SET @exist = @exist + ')' 
	END

IF @pQ2 <> 0 
	BEGIN 
		SET @exist = @exist + ' AND EXISTS (SELECT staffQID FROM tblStaffQs WHERE tblStaffQs.staffID = staffNo' 
		SET @exist = @exist + ' AND tblStaffQs.qID= ' + CONVERT(VARCHAR(10),@pQ2) + ' AND tblStaffQs.typeID = 1  '
		SET @exist = @exist + ' AND tblStaffQs.validfrom < ' + '''' + CONVERT(VARCHAR(12),GETDATE()) + ''''
		SET @exist = @exist + ' AND (validend is NULL OR tblStaffQs.validend > ' + '''' + CONVERT(VARCHAR(12),GETDATE()) + '''' + ')' 
		SET @exist = @exist + ')' 
  END

IF @pQ3 <> 0 
	BEGIN 
		SET @exist = @exist + ' AND EXISTS (SELECT staffQID FROM tblStaffQs WHERE tblStaffQs.staffID = staffNo' 
		SET @exist = @exist + ' AND tblStaffQs.qID= ' + CONVERT(VARCHAR(10),@pQ3) + ' AND tblStaffQs.typeID = 1  '
		SET @exist = @exist + ' AND tblStaffQs.validfrom < ' + '''' + CONVERT(VARCHAR(12),GETDATE()) + ''''
		SET @exist = @exist + ' AND (validend is NULL OR tblStaffQs.validend > ' + '''' + CONVERT(VARCHAR(12),GETDATE()) + '''' + ')' 
		SET @exist  =@exist + ')' 
	END

-- now add on the EXISTS clause
SET @str = @str + @exist

SET @str = @str + ' ORDER BY lastooa, surname'

EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spPersonnelSearchResultsTemp]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPersonnelSearchResultsTemp] 

@firstName varchar(50),
@surname varchar(50),
@serviceno varchar(50),
@RankId int,
@post varchar(50),
@TradeID int,
@sort int



AS

if @firstname = '' 
	Begin
 		set @firstname='%'
	End
if @surname = '' 
	Begin
 		set @surname='%'
	End
if @serviceno = '' 
	Begin
 		set @serviceno='%'
	End
/*if @post = '' 
	Begin
 		set @post='%'
	End*/

DECLARE @str varchar(255)

set @str = 'select staffid,serviceno,firstname,surname,shortdesc as rank FROM dbo.vwPersonnelSummaryList where '

set @str=@str+' firstname like ' + '''' + @firstName +'%' + '''' + '  and surname like' + '''' + @surname +'%'+  ''''+ '  and serviceno like ' + '''' + @serviceno +'%' + '''' 

if @Post <> ''

	Begin
		set @str=@str + '  and PostDescription like '+ ''''+ @Post+'%' + ''''

	End

if @RankID <>0 
	Begin
		set @str=@str + ' and RankID = ' + convert ( varchar(3),@RankID )
	End

if @TradeID <>0 
	Begin
		set @str=@str + ' and TradeID = ' + convert ( varchar(3),@TradeID )
	End

set @str=@str +' and  1=1 '


if @sort=1
	begin
		set @str=@str + 'order by surname asc, firstname asc'
	end

if @sort=2
	begin
		set @str=@str + 'order by surname desc,firstname desc'
	end

if @sort=3
	begin
		set @str=@str + 'order by firstname asc, surname asc'
	end

if @sort=4
	begin
		set @str=@str + 'order by firstname desc,surname desc'
	end

if @sort=5
	begin
		set @str=@str + 'order by serviceno asc, surname asc'
	end

if @sort=6
	begin
		set @str=@str + 'order by serviceno desc,surname desc'
	end

EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spPersonnelSearchResults]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPersonnelSearchResults]
(
    @nodeID INT,
	@firstName	VARCHAR(50),
	@surname	VARCHAR(50),
	@serviceno	VARCHAR(50),
	@RankId		INT,
	@post		VARCHAR(50),
	@TradeID	INT,
	@sort		INT,
	@assignNo	VARCHAR(30),
	@thisDate	VARCHAR(30),
	@mgr		INT,
	@Admin		INT
)

AS

IF @firstname = '' 
	BEGIN
 		SET @firstname='%'
	END

IF @surname = '' 
	BEGIN
 		SET @surname='%'
	END

IF @serviceno = '' 
	BEGIN
 		SET @serviceno='%'
	END

/***
DECLARE @str VARCHAR(1000)

SET @str = 'SELECT assignNo, staffid, serviceno, firstname, surname, shortdesc AS rank, lastOOA, teamID, team, postID, manager, administrator, messtat FROM vwPersonnelSummaryList WHERE '
SET @str=@str+' assignNo <> ' + '''' + 'Ghost' + '''' + ' AND firstname LIKE ' + '''' + @firstName +'%' + '''' + ' AND surname LIKE' + '''' + @surname +'%' + '''' + ' AND serviceno LIKE ' + '''' + @serviceno + '%' + '''' 
SET @str=@str+' AND ((' + '''' + @thisDate + '''' + ' >= startDate AND (' + '''' + @thisDate + '''' + ' <= enddate OR endDate IS NULL)) OR (startDate IS NULL AND endDate IS NULL))'
SET @str=@str+' '
***/
DECLARE @str VARCHAR(2000)
                      
SET @str=' SELECT assignNo, tblStaff.staffid, serviceno, firstname, surname, shortdesc AS rank, lastOOA, tblHierarchy.hrcID, tblHierarchy.hrcname, '
SET @str=@str+' tblPost.postID, manager, administrator, tblMES.description AS messtat '
SET @str=@str+'FROM dbo.tblStaff INNER JOIN dbo.tblRank ON dbo.tblStaff.rankID = dbo.tblRank.rankID '
SET @str=@str+' INNER JOIN dbo.tblStaffPost ON dbo.tblStaffPost.StaffID = dbo.tblStaff.staffID AND (endDate IS NULL OR endDate > GETDATE()) '
SET @str=@str+' INNER JOIN dbo.tblPost ON dbo.tblPost.postID = dbo.tblStaffPost.PostID '
SET @str=@str+' INNER JOIN dbo.tblHierarchy ON dbo.tblPost.hrcID = dbo.tblHierarchy.hrcID '
SET @str=@str+' LEFT OUTER JOIN dbo.tblManager ON dbo.tblManager.postID = dbo.tblPost.postID'
SET @str=@str+' LEFT OUTER JOIN dbo.tblMES ON dbo.tblMES.mesID = dbo.tblStaff.mesID '
SET @str=@str+' WHERE  tblStaff.ndeID=' + CONVERT(VARCHAR(10),@nodeID) + ' AND tblStaff.active=1 AND tblPost.assignno <> ' + '''' + 'Ghost' + '''' 
SET @str=@str+' AND firstname LIKE ' + '''' + @firstName +'%' + '''' + ' AND surname LIKE' + '''' + @surname +'%' + '''' + ' AND serviceno LIKE ' + '''' + @serviceno + '%' + '''' 
SET @str=@str+' '

IF @Post <> ''
	BEGIN
		SET @str=@str + ' AND tblPost.Description LIKE ' + '''' + @Post + '%' + ''''
	END

IF @assignNo <> ''
	BEGIN
		SET @str=@str + ' AND assignNo LIKE ' + '''' + @assignNo + '%' + ''''
	END

IF @RankID <> 0 
	BEGIN
		SET @str=@str + ' AND tblStaff.RankID = ' + CONVERT(VARCHAR(3),@RankID)
	END

IF @TradeID <> 0
	BEGIN
		SET @str=@str + ' AND tblStaff.TradeID = ' + CONVERT(VARCHAR(3),@TradeID)
	END

IF @mgr <> 0
	BEGIN
		SET @str=@str + ' AND manager > 0 ' 
	END

IF @admin <> 0 
	BEGIN
		SET @str=@str + ' AND administrator = 1' 
	END

--SET @str=@str + ' AND teamID IS NOT NULL AND 1=1 '

IF @sort=1
	BEGIN
		SET @str=@str + 'ORDER BY surname ASC, firstname ASC'
	END

IF @sort=2
	BEGIN
		SET @str=@str + 'ORDER BY surname DESC, firstname DESC'
	END

IF @sort=3
	BEGIN
		SET @str=@str + 'ORDER BY firstname ASC, surname ASC'
	END

IF @sort=4
	BEGIN
		SET @str=@str + 'ORDER BY firstname DESC, surname DESC'
	END

IF @sort=5
	BEGIN
		SET @str=@str + 'ORDER BY serviceno ASC, surname ASC'
	END

IF @sort=6
	BEGIN
		SET @str=@str + 'ORDER BY serviceno DESC, surname DESC'
	END

IF @sort=7
	BEGIN
		SET @str=@str + 'ORDER BY hrcname ASC, surname ASC'
	END

IF @sort=8
	BEGIN
		SET @str=@str + 'ORDER BY hrcname DESC, surname DESC'
	END

IF @sort=9
	BEGIN
		SET @str=@str + 'ORDER BY assignNo ASC'
	END

IF @sort=10
	BEGIN
		SET @str=@str + 'ORDER BY assignNo DESC'
	END

IF @sort=11
	BEGIN
		SET @str=@str + 'ORDER BY lastOOA ASC'
	END

IF @sort=12
	BEGIN
		SET @str=@str + 'ORDER BY lastOOA DESC'
	END

EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spPersonnelSearchList]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPersonnelSearchList]
(
    @nodeID INT,
	@firstName	VARCHAR(50),
	@surname	VARCHAR(50),
	@serviceno	VARCHAR(50),
	@RankId	INT,
	@TradeID	INT,
	@Active	INT,
	@sort		INT
)

AS

IF @firstName = '' 
	BEGIN
 		SET @firstname = '%'
	END

IF @surname = '' 
	BEGIN
 		SET @surname = '%'
	END

IF @serviceno = '' 
	BEGIN
 		SET @serviceno = '%'
	END

DECLARE @str varchar(1000)

SET @str = 'SELECT tblStaff.staffid, serviceno, firstname, surname, shortDESC AS rank
FROM tblStaff 
INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
WHERE tblStaff.ndeID=' + CONVERT(VARCHAR(10),@nodeID) + ' AND  firstname LIKE ' + '''' + @firstName + '%' + '''' + ' AND surname LIKE ' + '''' + @surname + '%' + '''' + 
' AND serviceno LIKE ' + '''' + @serviceno + '%' + '''' 

SET @str = @str + '  '

IF @RankID <> 0 
	BEGIN
		SET @str = @str + ' AND tblRank.RankID = ' + CONVERT(VARCHAR(3),@RankID )
	END

IF @TradeID <> 0 
	BEGIN
		SET @str = @str + ' AND tblStaff.TradeID = ' + CONVERT(VARCHAR(3),@TradeID )
	END

IF @Active = 0 
	BEGIN
            SET @str = @str + ' AND active = 0 '
        END

IF @Active = 1 
	BEGIN
           SET @str = @str + ' AND active =  1 '
	END

IF @sort = 1
	BEGIN
		SET @str = @str + 'ORDER BY surname ASC, firstname ASC'
	END

IF @sort = 2
	BEGIN
		SET @str = @str + 'ORDER BY surname DESC, firstname DESC'
	END

IF @sort = 3
	BEGIN
		SET @str = @str + 'ORDER BY firstname ASC, surname ASC'
	END

IF @sort = 4
	BEGIN
		SET @str = @str + 'ORDER BY firstname DESC, surname DESC'
	END

IF @sort = 5
	BEGIN
		SET @str = @str + 'ORDER BY serviceno ASC, surname ASC'
	END

IF @sort = 6
	BEGIN
		SET @str = @str + 'ORDER BY serviceno DESC, surname DESC'
	END

IF @sort = 7
	BEGIN
		SET @str = @str + 'ORDER BY Team ASC, surname ASC'
	END

IF @sort = 8
	BEGIN
		SET @str = @str + 'ORDER BY Team DESC, surname DESC'
	END

EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spPersonnelPostSearchResults]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spPersonnelPostSearchResults] 

@Description varchar(50),
@AssignNo varchar(50)



AS

--if @Description = '' 
--	Begin
 --		set @Description='%'
--	End
--if @AssignNo = '' 
--	Begin
-- 		set @AssignNo='%'
--	End


DECLARE @str varchar(300)

set @str = 'select postid,assignno,vwVacantPosts.description,tblteam.description as Team FROM dbo.vwVacantPosts left outer join tblTeam on tblTeam.TeamID = vwVacantPosts.teamID where '

--set @str=@str+' vwVacantPosts.description like ' + '''' + @description +'%' + '''' + '  and assignno like' + '''' + @assignno +'%'+  ''''
if @Description <> ''
  set @str=@str+' vwVacantPosts.description like ' + '''' + @description +'%' + '''AND'

if @AssignNo <> '' 
  set @str=@str+ ' assignno like' + '''' + @assignno +'%'+  '''AND'

set @str=@str +' 1=1 order by vwVacantPosts.description'

EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spListDetails]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListDetails]
(
	@tablename VARCHAR(50)
)

AS

EXEC ('SELECT ' + @tablename + '.*, tblValPeriod.description AS ValidityPeriod, tblQTypes.Description AS QType
FROM ' + @tablename + '
INNER JOIN tblValPeriod ON ' + @tablename + '.vpID = tblValPeriod.vpID
INNER JOIN tblQTypes ON ' + @tablename + '.QTypeID = tblQTypes.QTypeID')
GO
/****** Object:  Table [dbo].[tblWing]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblWing](
	[wingID] [int] IDENTITY(1,1) NOT NULL,
	[grpID] [int] NULL,
	[description] [varchar](50) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK__tblWing__57A801BA] PRIMARY KEY CLUSTERED 
(
	[wingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblValPeriod]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblValPeriod](
	[vpID] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NULL,
	[vplength] [smallint] NULL,
	[vptype] [smallint] NULL,
	[vpdays] [int] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [vpID] PRIMARY KEY CLUSTERED 
(
	[vpID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = Months   0 = Years' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblValPeriod', @level2type=N'COLUMN',@level2name=N'vptype'
GO
/****** Object:  Table [dbo].[tblUnitHarmonyTarget]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUnitHarmonyTarget](
	[uhpID] [int] IDENTITY(4,1) NOT NULL,
	[bnagrnmin] [decimal](10, 2) NULL,
	[bnagrnmax] [decimal](10, 2) NULL,
	[bnayelmin] [decimal](10, 2) NULL,
	[bnayelmax] [decimal](10, 2) NULL,
	[bnaambmin] [decimal](10, 2) NULL,
	[bnaambmax] [decimal](10, 2) NULL,
	[bnared] [decimal](10, 2) NULL,
	[ooagrnmin] [decimal](10, 2) NULL,
	[ooagrnmax] [decimal](10, 2) NULL,
	[ooayelmin] [decimal](10, 2) NULL,
	[ooayelmax] [decimal](10, 2) NULL,
	[ooaambmin] [decimal](10, 2) NULL,
	[ooaambmax] [decimal](10, 2) NULL,
	[ooared] [decimal](10, 2) NULL,
	[ndeID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTrainingCourse]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTrainingCourse](
	[tcID] [int] IDENTITY(1,1) NOT NULL,
	[tctype] [smallint] NOT NULL,
	[msqID] [int] NOT NULL,
	[description] [char](10) NULL,
	[startdate] [smalldatetime] NULL,
	[enddate] [smalldatetime] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tbltrainingcourse] PRIMARY KEY CLUSTERED 
(
	[tcID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type of Training Course 1 = MS 0 = "Q"' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblTrainingCourse', @level2type=N'COLUMN',@level2name=N'tctype'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID of parent MS or Q record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblTrainingCourse', @level2type=N'COLUMN',@level2name=N'msqID'
GO
/****** Object:  Table [dbo].[tblTradeGroup]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTradeGroup](
	[TradeGroupID] [int] IDENTITY(19,1) NOT NULL,
	[TradeGroup] [int] NOT NULL,
	[description] [varchar](50) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblTradeGroup] PRIMARY KEY CLUSTERED 
(
	[TradeGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTrade]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTrade](
	[tradeID] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NULL,
	[tradeGroupID] [int] NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [tradeID] PRIMARY KEY CLUSTERED 
(
	[tradeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'related tradegroup key' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblTrade', @level2type=N'COLUMN',@level2name=N'tradeGroupID'
GO
/****** Object:  Table [dbo].[tblTempHierarchy]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTempHierarchy](
	[teamID] [int] NOT NULL,
	[ParentID] [int] NOT NULL,
	[Teamin] [int] NOT NULL,
	[ndeID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTeamHierarchy]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTeamHierarchy](
	[teamID] [int] NOT NULL,
	[ParentID] [int] NOT NULL,
	[Teamin] [int] NOT NULL,
	[ndeID] [int] NOT NULL,
	[hrcID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTeam]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTeam](
	[teamID] [int] IDENTITY(1,1) NOT NULL,
	[parentID] [int] NULL,
	[teamIn] [int] NULL,
	[teamCP] [bit] NULL,
	[teamSize] [int] NULL,
	[description] [varchar](50) NULL,
	[weight] [int] NULL,
	[cycleID] [int] NULL,
	[firstStage] [int] NULL,
	[cycleStart] [datetime] NULL,
	[belongsto] [int] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblTeam] PRIMARY KEY CLUSTERED 
(
	[teamID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTaskType]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTaskType](
	[ttID] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NOT NULL,
	[WithList] [int] NOT NULL,
	[Active] [int] NOT NULL,
	[Section] [int] NOT NULL,
	[Order] [int] NOT NULL,
	[taskcolor] [varchar](10) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tbltasktype] PRIMARY KEY CLUSTERED 
(
	[ttID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTaskStatus]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTaskStatus](
	[otsID] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [otsID] PRIMARY KEY CLUSTERED 
(
	[otsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTaskPending]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTaskPending](
	[tpID] [smallint] IDENTITY(1,1) NOT NULL,
	[tskID] [int] NULL,
	[ndeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[tpID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTaskNotes]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTaskNotes](
	[taskNoteID] [int] IDENTITY(1,1) NOT NULL,
	[taskNote] [varchar](3000) NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblTaskNotes] PRIMARY KEY CLUSTERED 
(
	[taskNoteID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTasked]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTasked](
	[tskID] [int] IDENTITY(1,1) NOT NULL,
	[ttID] [int] NOT NULL,
	[staffID] [int] NOT NULL,
	[description] [varchar](100) NOT NULL,
	[trainingID] [int] NULL,
	[accepted] [bit] NULL,
	[startdate] [datetime] NOT NULL,
	[enddate] [datetime] NOT NULL,
	[priority] [smallint] NULL,
	[cancelable] [bit] NOT NULL,
	[pending] [bit] NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tbltasked] PRIMARY KEY CLUSTERED 
(
	[tskID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'related Task Type record ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblTasked', @level2type=N'COLUMN',@level2name=N'ttID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'related staff record ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblTasked', @level2type=N'COLUMN',@level2name=N'staffID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'related traing course record ID if Task is Training' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblTasked', @level2type=N'COLUMN',@level2name=N'trainingID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = Yes 0 = No  - accepted on training course if task is training' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblTasked', @level2type=N'COLUMN',@level2name=N'accepted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'9 = Highest      0 = Lowest' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblTasked', @level2type=N'COLUMN',@level2name=N'priority'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = Yes   0 = No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblTasked', @level2type=N'COLUMN',@level2name=N'cancelable'
GO
/****** Object:  Table [dbo].[tblTaskClash]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTaskClash](
	[ClashID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[taskStaffID] [int] NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblTaskClash] PRIMARY KEY CLUSTERED 
(
	[ClashID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTask]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTask](
	[taskID] [int] IDENTITY(1,1) NOT NULL,
	[ttID] [int] NULL,
	[description] [varchar](50) NULL,
	[hqtask] [bit] NOT NULL,
	[ooa] [bit] NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tbltask] PRIMARY KEY CLUSTERED 
(
	[taskID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'related TaskType record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblTask', @level2type=N'COLUMN',@level2name=N'ttID'
GO
/****** Object:  Table [dbo].[tblStatus]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStatus](
	[statusID] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_userStatus] PRIMARY KEY CLUSTERED 
(
	[statusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status of log-in eg Adminstrator, Team manger etc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblStatus', @level2type=N'COLUMN',@level2name=N'description'
GO
/****** Object:  Table [dbo].[tblStaffQs]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStaffQs](
	[StaffQID] [int] IDENTITY(1,1) NOT NULL,
	[StaffID] [int] NOT NULL,
	[TypeID] [int] NOT NULL,
	[ValidFrom] [datetime] NOT NULL,
	[ValidEnd] [datetime] NULL,
	[Competent] [char](1) NOT NULL,
	[QID] [int] NULL,
	[AuthName] [varchar](20) NULL,
	[UpBy] [int] NULL,
	[UpDated] [datetime] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblStaffQs] PRIMARY KEY CLUSTERED 
(
	[StaffQID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblStaffPost]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblStaffPost](
	[StaffPostID] [int] IDENTITY(1,1) NOT NULL,
	[StaffID] [int] NOT NULL,
	[PostID] [int] NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblStaffPost] PRIMARY KEY CLUSTERED 
(
	[StaffPostID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblStaffPhoto]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStaffPhoto](
	[stphID] [int] IDENTITY(1,1) NOT NULL,
	[staffID] [int] NOT NULL,
	[staffphoto] [image] NULL,
	[photoPath] [varchar](200) NULL,
	[fileSize] [int] NULL,
	[contentType] [varchar](50) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblStaffPhoto] PRIMARY KEY CLUSTERED 
(
	[stphID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblStaffMVs]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStaffMVs](
	[StaffMVID] [int] IDENTITY(1,1) NOT NULL,
	[StaffID] [int] NOT NULL,
	[MVID] [int] NOT NULL,
	[ValidFrom] [datetime] NOT NULL,
	[ValidTo] [datetime] NOT NULL,
	[Competent] [char](1) NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblStaffMVs] PRIMARY KEY CLUSTERED 
(
	[StaffMVID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblStaffMilSkill]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStaffMilSkill](
	[StaffMSID] [int] IDENTITY(1,1) NOT NULL,
	[StaffID] [int] NOT NULL,
	[MSID] [int] NOT NULL,
	[ValidFrom] [datetime] NOT NULL,
	[ValidTo] [datetime] NOT NULL,
	[Competent] [char](1) NOT NULL,
	[Exempt] [int] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblStaffMilSkill] PRIMARY KEY CLUSTERED 
(
	[StaffMSID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblStaffHarmony]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblStaffHarmony](
	[sthmID] [smallint] IDENTITY(1,1) NOT NULL,
	[staffID] [int] NULL,
	[ooadays] [int] NULL,
	[ndeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[sthmID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblStaffFitness]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStaffFitness](
	[StaffFitnessID] [int] IDENTITY(1,1) NOT NULL,
	[StaffID] [int] NOT NULL,
	[FitnessID] [int] NOT NULL,
	[ValidFrom] [datetime] NOT NULL,
	[ValidTo] [datetime] NOT NULL,
	[Competent] [char](1) NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblStaffFitness] PRIMARY KEY CLUSTERED 
(
	[StaffFitnessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblStaffDental]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStaffDental](
	[StaffDentalID] [int] IDENTITY(1,1) NOT NULL,
	[StaffID] [int] NOT NULL,
	[DentalID] [int] NOT NULL,
	[ValidFrom] [datetime] NOT NULL,
	[ValidTo] [datetime] NOT NULL,
	[Competent] [char](1) NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblStaffDental] PRIMARY KEY CLUSTERED 
(
	[StaffDentalID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblStaff]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStaff](
	[staffID] [int] IDENTITY(1,1) NOT NULL,
	[surname] [varchar](50) NOT NULL,
	[firstname] [varchar](25) NOT NULL,
	[serviceno] [varchar](10) NOT NULL,
	[knownas] [varchar](50) NULL,
	[rankID] [int] NOT NULL,
	[tradeID] [int] NULL,
	[statusID] [int] NULL,
	[administrator] [bit] NOT NULL,
	[homephone] [char](15) NULL,
	[mobileno] [char](15) NULL,
	[arrivaldate] [datetime] NULL,
	[postingduedate] [datetime] NULL,
	[passportno] [char](30) NULL,
	[passportexpiry] [datetime] NULL,
	[issueoffice] [varchar](50) NULL,
	[pob] [varchar](50) NULL,
	[poc] [varchar](30) NULL,
	[handbookissued] [datetime] NULL,
	[welfarewishes] [varchar](200) NULL,
	[postID] [int] NULL,
	[postoveride] [bit] NULL,
	[ponotes] [varchar](200) NULL,
	[capoveride] [bit] NULL,
	[capnotes] [varchar](200) NULL,
	[notes] [varchar](200) NULL,
	[picture] [varchar](50) NULL,
	[sex] [char](1) NULL,
	[dob] [datetime] NULL,
	[remedial] [bit] NOT NULL,
	[workPhone] [varchar](15) NULL,
	[dischargeDate] [datetime] NULL,
	[active] [bit] NOT NULL,
	[ddssa] [int] NULL,
	[ddssb] [int] NULL,
	[taskOOA] [bit] NOT NULL,
	[lastOOA] [datetime] NULL,
	[mesID] [int] NULL,
	[ddooa] [int] NULL,
	[exempt] [bit] NULL,
	[weaponNo] [varchar](15) NULL,
	[susat] [bit] NULL,
	[expiryDate] [datetime] NULL,
	[ndeID] [int] NOT NULL,
	[CMSAdministrator] [bit] NOT NULL,
 CONSTRAINT [PK_tblStaff] PRIMARY KEY CLUSTERED 
(
	[staffID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID of tblRank record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblStaff', @level2type=N'COLUMN',@level2name=N'rankID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID of tblTrade record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblStaff', @level2type=N'COLUMN',@level2name=N'tradeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID of tblStatus record - shows user is Team Mgr, Administrator etc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblStaff', @level2type=N'COLUMN',@level2name=N'statusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gives Admin rights to Administration Module' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblStaff', @level2type=N'COLUMN',@level2name=N'administrator'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Passport Issueing Office' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblStaff', @level2type=N'COLUMN',@level2name=N'issueoffice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Place of Birth (Town)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblStaff', @level2type=N'COLUMN',@level2name=N'pob'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Welfare POC (Point of Contact ?)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblStaff', @level2type=N'COLUMN',@level2name=N'poc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Welfare Handbook Issued' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblStaff', @level2type=N'COLUMN',@level2name=N'handbookissued'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID of tblPost record assigned to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblStaff', @level2type=N'COLUMN',@level2name=N'postID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1= Yes  0=No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblStaff', @level2type=N'COLUMN',@level2name=N'postoveride'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Capability Overide  1 = Yes  0 = No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblStaff', @level2type=N'COLUMN',@level2name=N'capoveride'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'probably needs a blob' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblStaff', @level2type=N'COLUMN',@level2name=N'picture'
GO
/****** Object:  Table [dbo].[tblSSC]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSSC](
	[sscID] [smallint] IDENTITY(1,1) NOT NULL,
	[ssCode] [int] NULL,
	[ssType] [int] NULL,
	[description] [varchar](50) NULL,
	[ssNotes] [varchar](500) NULL,
	[ndeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[sscID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSquadron]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSquadron](
	[sqnID] [int] IDENTITY(1,1) NOT NULL,
	[wingID] [int] NULL,
	[description] [varchar](50) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK__tblSquadron__59904A2C] PRIMARY KEY CLUSTERED 
(
	[sqnID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblReports]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblReports](
	[rptID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](20) NULL,
	[ndeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[rptID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRankWeight]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRankWeight](
	[rwID] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NULL,
	[rankWt] [smallint] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [rwID] PRIMARY KEY CLUSTERED 
(
	[rwID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRank]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRank](
	[rankID] [int] IDENTITY(15,1) NOT NULL,
	[shortDesc] [varchar](15) NOT NULL,
	[description] [varchar](50) NULL,
	[status] [bit] NOT NULL,
	[Weight] [int] NOT NULL,
	[weightScore] [int] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblrank] PRIMARY KEY CLUSTERED 
(
	[rankID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = Active   0 = Inactive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblRank', @level2type=N'COLUMN',@level2name=N'status'
GO
/****** Object:  Table [dbo].[tblQWeight]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblQWeight](
	[qwID] [int] IDENTITY(1,1) NOT NULL,
	[qwtype] [char](2) NULL,
	[description] [varchar](50) NULL,
	[qwvalue] [int] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [qwID] PRIMARY KEY CLUSTERED 
(
	[qwID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblQTypes]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblQTypes](
	[QtypeID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[Auth] [bit] NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblQTypes] PRIMARY KEY CLUSTERED 
(
	[QtypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblQs]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblQs](
	[QID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[QTypeID] [int] NOT NULL,
	[vpID] [int] NULL,
	[Amber] [int] NULL,
	[Enduring] [bit] NULL,
	[Contingent] [bit] NULL,
	[LongDesc] [varchar](300) NULL,
	[ndeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[QID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPostQStatus]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPostQStatus](
	[PostQStatus] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NULL,
	[QWType] [char](2) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblPostQStatus] PRIMARY KEY CLUSTERED 
(
	[PostQStatus] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPostQs]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPostQs](
	[PostQID] [int] IDENTITY(1,1) NOT NULL,
	[PostID] [int] NOT NULL,
	[TypeID] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[Competent] [bit] NOT NULL,
	[QID] [int] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblPostQs] PRIMARY KEY CLUSTERED 
(
	[PostQID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPostMilSkill]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPostMilSkill](
	[postMSID] [int] IDENTITY(1,1) NOT NULL,
	[postID] [int] NOT NULL,
	[MSID] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[Competent] [bit] NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblPostMilSkill] PRIMARY KEY CLUSTERED 
(
	[postMSID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPost]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPost](
	[postID] [int] IDENTITY(1,1) NOT NULL,
	[assignno] [varchar](50) NOT NULL,
	[description] [varchar](50) NULL,
	[teamID] [int] NULL,
	[positionDesc] [varchar](50) NULL,
	[rankID] [int] NULL,
	[tradeID] [int] NULL,
	[RWID] [int] NULL,
	[notes] [varchar](255) NULL,
	[qoveride] [bit] NULL,
	[msoveride] [bit] NULL,
	[overborne] [bit] NULL,
	[manager] [bit] NULL,
	[QTotal] [int] NOT NULL,
	[Ghost] [bit] NULL,
	[Status] [bit] NOT NULL,
	[ndeID] [int] NOT NULL,
	[hrcID] [int] NOT NULL,
 CONSTRAINT [PK_tblpost] PRIMARY KEY CLUSTERED 
(
	[postID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID of team post is assigned to ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblPost', @level2type=N'COLUMN',@level2name=N'teamID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Free Format Position Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblPost', @level2type=N'COLUMN',@level2name=N'positionDesc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID of Rank record assigned to Post' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblPost', @level2type=N'COLUMN',@level2name=N'rankID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID of trade record post is assigned to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblPost', @level2type=N'COLUMN',@level2name=N'tradeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Inherited from Rank weight' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblPost', @level2type=N'COLUMN',@level2name=N'RWID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = override Q''s  o = no overide' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblPost', @level2type=N'COLUMN',@level2name=N'qoveride'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = overide MS  0 = no MS overide' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblPost', @level2type=N'COLUMN',@level2name=N'msoveride'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = No  1 = Yes(Ignore for Capability)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblPost', @level2type=N'COLUMN',@level2name=N'overborne'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Team Manager 1= Yes 0 = No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblPost', @level2type=N'COLUMN',@level2name=N'manager'
GO
/****** Object:  Table [dbo].[tblPosition]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPosition](
	[positionID] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [positionID] PRIMARY KEY CLUSTERED 
(
	[positionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPassword]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPassword](
	[pwID] [int] IDENTITY(1,1) NOT NULL,
	[staffID] [int] NOT NULL,
	[staffpw] [varchar](100) NOT NULL,
	[pswd] [varchar](32) NULL,
	[dPswd] [varchar](32) NULL,
	[expires] [datetime] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblPassword] PRIMARY KEY CLUSTERED 
(
	[pwID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary Key' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblPassword', @level2type=N'COLUMN',@level2name=N'pwID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Related Staff record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblPassword', @level2type=N'COLUMN',@level2name=N'staffID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Staff Password' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblPassword', @level2type=N'COLUMN',@level2name=N'staffpw'
GO
/****** Object:  Table [dbo].[tblOrganisation]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOrganisation](
	[orgID] [int] IDENTITY(1,1) NOT NULL,
	[orgName] [varchar](100) NULL,
 CONSTRAINT [PK_org] PRIMARY KEY CLUSTERED 
(
	[orgID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblOrgAdmin]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblOrgAdmin](
	[ogaID] [int] IDENTITY(1,1) NOT NULL,
	[orgID] [int] NULL,
	[staffID] [int] NULL,
 CONSTRAINT [PK_orgadmin] PRIMARY KEY CLUSTERED 
(
	[ogaID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblOpTeam]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblOpTeam](
	[optID] [int] IDENTITY(1,1) NOT NULL,
	[teamID] [int] NULL,
	[ndeID] [int] NOT NULL,
	[hrcID] [int] NOT NULL,
 CONSTRAINT [PK_tblopteam] PRIMARY KEY CLUSTERED 
(
	[optID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID of tblTeam record assigned to Op' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblOpTeam', @level2type=N'COLUMN',@level2name=N'teamID'
GO
/****** Object:  Table [dbo].[tblOpTaskCategory]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOpTaskCategory](
	[otcID] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [otcID] PRIMARY KEY CLUSTERED 
(
	[otcID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblOpTask]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOpTask](
	[optID] [int] IDENTITY(1000,1) NOT NULL,
	[taskno] [bigint] NULL,
	[name] [varchar](50) NULL,
	[location] [varchar](50) NULL,
	[catID] [int] NULL,
	[projo] [varchar](50) NULL,
	[detcdr] [varchar](50) NULL,
	[nomrole] [varchar](50) NULL,
	[startdate] [datetime] NULL,
	[enddate] [datetime] NULL,
	[oporder] [varchar](50) NULL,
	[statusID] [int] NULL,
	[overview] [varchar](50) NULL,
	[documents] [varchar](200) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblOpTask] PRIMARY KEY CLUSTERED 
(
	[optID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique number for task ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblOpTask', @level2type=N'COLUMN',@level2name=N'taskno'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'task name  - free format' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblOpTask', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'task location  - free format' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblOpTask', @level2type=N'COLUMN',@level2name=N'location'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID of parent Opt Category record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblOpTask', @level2type=N'COLUMN',@level2name=N'catID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID of parent Op Status record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblOpTask', @level2type=N'COLUMN',@level2name=N'statusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'list of attached documents' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblOpTask', @level2type=N'COLUMN',@level2name=N'documents'
GO
/****** Object:  Table [dbo].[tblOpEqpt]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblOpEqpt](
	[opeID] [int] IDENTITY(1,1) NOT NULL,
	[eqptID] [int] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblopeqpt] PRIMARY KEY CLUSTERED 
(
	[opeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID of parent Equipment assigned to Op' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblOpEqpt', @level2type=N'COLUMN',@level2name=N'eqptID'
GO
/****** Object:  Table [dbo].[tblOpAction]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOpAction](
	[opaID] [int] IDENTITY(1,1) NOT NULL,
	[taskID] [int] NULL,
	[opadate] [datetime] NULL,
	[opaction] [varchar](50) NULL,
	[documents] [varchar](200) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblopaction] PRIMARY KEY CLUSTERED 
(
	[opaID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID of parent tbloptask record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblOpAction', @level2type=N'COLUMN',@level2name=N'taskID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date action record is added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblOpAction', @level2type=N'COLUMN',@level2name=N'opadate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'list of attached documents pertaining to action' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblOpAction', @level2type=N'COLUMN',@level2name=N'documents'
GO
/****** Object:  Table [dbo].[tblOOADays]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblOOADays](
	[ooaID] [smallint] IDENTITY(1,1) NOT NULL,
	[ooamaxdays] [int] NULL,
	[amberdays] [int] NULL,
	[ndeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ooaID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblNodeAdmin]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblNodeAdmin](
	[ndaID] [int] IDENTITY(1,1) NOT NULL,
	[ndeID] [int] NULL,
	[orgID] [int] NULL,
	[staffID] [int] NULL,
 CONSTRAINT [PK_nodeadmin] PRIMARY KEY CLUSTERED 
(
	[ndaID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblNode]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblNode](
	[ndeID] [int] IDENTITY(1,1) NOT NULL,
	[orgID] [int] NULL,
	[ndename] [varchar](100) NULL,
 CONSTRAINT [PK_node] PRIMARY KEY CLUSTERED 
(
	[ndeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMSWeight]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMSWeight](
	[mswID] [int] IDENTITY(1,1) NOT NULL,
	[mswtype] [char](1) NULL,
	[description] [varchar](50) NULL,
	[mswvalue] [smallint] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [mswID] PRIMARY KEY CLUSTERED 
(
	[mswID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMilitaryVacs]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMilitaryVacs](
	[mvID] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NULL,
	[vpID] [int] NULL,
	[mvrequired] [bit] NULL,
	[Combat] [bit] NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [mvID] PRIMARY KEY CLUSTERED 
(
	[mvID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = Yes   0 = No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblMilitaryVacs', @level2type=N'COLUMN',@level2name=N'mvrequired'
GO
/****** Object:  Table [dbo].[tblMilitarySkills]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMilitarySkills](
	[msID] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NULL,
	[vpID] [int] NULL,
	[exempt] [int] NULL,
	[Combat] [bit] NULL,
	[Fear] [bit] NULL,
	[Amber] [int] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [msID] PRIMARY KEY CLUSTERED 
(
	[msID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMES]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMES](
	[mesID] [smallint] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NULL,
	[ndeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[mesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblManager]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblManager](
	[tmID] [int] IDENTITY(1,1) NOT NULL,
	[postID] [int] NOT NULL,
	[tmlevelID] [int] NOT NULL,
	[tmLevel] [int] NOT NULL,
	[ndeID] [int] NOT NULL,
	[hrcID] [int] NOT NULL,
 CONSTRAINT [PK_tblManager] PRIMARY KEY CLUSTERED 
(
	[tmID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'RecId of level - Grp,Wing,Sqn,Flight,Team,SubTeam' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblManager', @level2type=N'COLUMN',@level2name=N'tmlevelID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mgr level 0=Grp 1=Wng 2=Sqn 3=Flt 4=Team 5=SubTeam' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblManager', @level2type=N'COLUMN',@level2name=N'tmLevel'
GO
/****** Object:  Table [dbo].[tblHierarchy]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblHierarchy](
	[hrcID] [int] IDENTITY(1,1) NOT NULL,
	[teamID] [int] NULL,
	[tblID] [int] NULL,
	[ndeID] [int] NULL,
	[hrcparentID] [int] NULL,
	[hrclevel] [int] NULL,
	[hrcname] [varchar](100) NULL,
	[hrcchildren] [bit] NULL,
 CONSTRAINT [PK_hierarchy] PRIMARY KEY CLUSTERED 
(
	[hrcID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblHarmonyPeriod]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblHarmonyPeriod](
	[hpID] [smallint] IDENTITY(1,1) NOT NULL,
	[ooaperiod] [int] NULL,
	[ooared] [int] NULL,
	[ooaamber] [int] NULL,
	[ssaperiod] [int] NULL,
	[ssared] [int] NULL,
	[ssaamber] [int] NULL,
	[ssbperiod] [int] NULL,
	[ssbred] [int] NULL,
	[ssbamber] [int] NULL,
	[ndeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[hpID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblHarmonyOverride]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblHarmonyOverride](
	[hmovID] [smallint] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NULL,
	[ndeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[hmovID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGroup]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGroup](
	[grpID] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NULL,
	[hqTasking] [bit] NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK__tblGroup__55BFB948] PRIMARY KEY CLUSTERED 
(
	[grpID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblGenericPW]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblGenericPW](
	[gpwID] [smallint] IDENTITY(1,1) NOT NULL,
	[genericPW] [varchar](100) NULL,
	[ndeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[gpwID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblFlight]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblFlight](
	[fltID] [int] IDENTITY(1,1) NOT NULL,
	[sqnID] [int] NULL,
	[description] [varchar](50) NULL,
	[cycleID] [int] NULL,
	[cycleStart] [datetime] NULL,
	[cycleEnd] [datetime] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK__tblFlight__5B78929E] PRIMARY KEY CLUSTERED 
(
	[fltID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblFitness]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblFitness](
	[FitnessID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[vpID] [int] NOT NULL,
	[Combat] [bit] NULL,
	[Exempt] [int] NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblFitness] PRIMARY KEY CLUSTERED 
(
	[FitnessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblEquipmentTemp]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblEquipmentTemp](
	[EquipmentID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblEquipmentTemp] PRIMARY KEY CLUSTERED 
(
	[EquipmentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblDept]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblDept](
	[deptID] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](20) NULL,
	[ndeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[deptID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblDental]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblDental](
	[DentalID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[vpID] [int] NOT NULL,
	[Combat] [bit] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblDental] PRIMARY KEY CLUSTERED 
(
	[DentalID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblDefaultPhoto]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblDefaultPhoto](
	[defaultPhotoID] [int] IDENTITY(1,1) NOT NULL,
	[staffID] [int] NULL,
	[staffPhoto] [image] NULL,
	[photoPath] [varchar](200) NULL,
	[fileSize] [varchar](50) NULL,
	[contentType] [varchar](50) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblDefaultPhoto] PRIMARY KEY CLUSTERED 
(
	[defaultPhotoID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCycleSteps]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCycleSteps](
	[cytID] [int] IDENTITY(1,1) NOT NULL,
	[cytStep] [int] NULL,
	[cyID] [int] NULL,
	[cysID] [char](10) NULL,
	[ndeID] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Order in which Cycle Stages happen for this Cycle record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCycleSteps', @level2type=N'COLUMN',@level2name=N'cytStep'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'related tblCycle recid' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCycleSteps', @level2type=N'COLUMN',@level2name=N'cyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'related tblCycleStage recID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCycleSteps', @level2type=N'COLUMN',@level2name=N'cysID'
GO
/****** Object:  Table [dbo].[tblCycleStage]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCycleStage](
	[cysID] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NULL,
	[ndeID] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cycle Stage Unique ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCycleStage', @level2type=N'COLUMN',@level2name=N'cysID'
GO
/****** Object:  Table [dbo].[tblCycle]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCycle](
	[cyID] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NULL,
	[cydays] [int] NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [cyID] PRIMARY KEY CLUSTERED 
(
	[cyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblContact]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblContact](
	[ContactID] [int] NOT NULL,
	[EmailName] [varchar](30) NULL,
	[Email] [varchar](30) NULL,
	[MilPhone] [varchar](10) NULL,
	[Ext] [varchar](6) NULL,
	[ndeID] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblConfig]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblConfig](
	[configID] [int] IDENTITY(1,1) NOT NULL,
	[deptID] [int] NULL,
	[pla] [bit] NULL,
	[tas] [bit] NULL,
	[man] [bit] NULL,
	[per] [bit] NULL,
	[uni] [bit] NULL,
	[cap] [bit] NULL,
	[pre] [bit] NULL,
	[fit] [bit] NULL,
	[boa] [bit] NULL,
	[sch] [bit] NULL,
	[nom] [bit] NULL,
	[ran] [bit] NULL,
	[aut] [bit] NULL,
	[ind] [bit] NULL,
	[pos] [bit] NULL,
	[rod] [bit] NULL,
	[paq] [bit] NULL,
	[ndeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[configID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCondFormat]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCondFormat](
	[cfID] [int] IDENTITY(4,1) NOT NULL,
	[description] [varchar](50) NULL,
	[cfminval] [decimal](10, 2) NULL,
	[cfmaxval] [decimal](10, 2) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [cfID] PRIMARY KEY CLUSTERED 
(
	[cfID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Minimum % value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCondFormat', @level2type=N'COLUMN',@level2name=N'cfminval'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Maximum % value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCondFormat', @level2type=N'COLUMN',@level2name=N'cfmaxval'
GO
/****** Object:  Table [dbo].[tblCapabilityCategoryDetail]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCapabilityCategoryDetail](
	[CpCategoryDetalID] [int] IDENTITY(1,1) NOT NULL,
	[CpID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
	[DetailID] [int] NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblCapabilityCategoryDetail] PRIMARY KEY CLUSTERED 
(
	[CpCategoryDetalID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCapabilityCategory]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCapabilityCategory](
	[CpCatID] [int] IDENTITY(1,1) NOT NULL,
	[ShortDesc] [varchar](50) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblCapabilityCategory] PRIMARY KEY CLUSTERED 
(
	[CpCatID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCapability]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCapability](
	[cpID] [int] IDENTITY(1,1) NOT NULL,
	[cptitle] [varchar](30) NULL,
	[description] [varchar](50) NULL,
	[cpteam] [varchar](50) NULL,
	[cpaerial] [varchar](50) NULL,
	[cpother] [varchar](50) NULL,
	[cp5sqn] [varchar](50) NULL,
	[cpgse] [varchar](50) NULL,
	[cpmgt] [varchar](50) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblCapability] PRIMARY KEY CLUSTERED 
(
	[cpID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Team Capability' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCapability', @level2type=N'COLUMN',@level2name=N'cpteam'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Aerial Capability' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCapability', @level2type=N'COLUMN',@level2name=N'cpaerial'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Other Capability' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCapability', @level2type=N'COLUMN',@level2name=N'cpother'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'5 Sqn Capability' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCapability', @level2type=N'COLUMN',@level2name=N'cp5sqn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'GSE Capability' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCapability', @level2type=N'COLUMN',@level2name=N'cpgse'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mgt Capability' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCapability', @level2type=N'COLUMN',@level2name=N'cpmgt'
GO
/****** Object:  Table [dbo].[tblAuthsAudit]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAuthsAudit](
	[aaID] [int] IDENTITY(1,1) NOT NULL,
	[authorisor] [int] NULL,
	[authdate] [datetime] NULL,
	[authtype] [bit] NULL,
	[authchange] [int] NULL,
	[staffID] [int] NULL,
	[authID] [int] NULL,
	[startdate] [datetime] NULL,
	[enddate] [datetime] NULL,
	[ndeID] [int] NULL,
 CONSTRAINT [PK_authsAudit] PRIMARY KEY CLUSTERED 
(
	[aaID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This table is maintained via  DATABASE TRIGGERS on tblAuthorisors and tblStaffAuths' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblAuthsAudit', @level2type=N'COLUMN',@level2name=N'aaID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0=tblAuthorisors (staff able to authorise)  1=tblStaffAuths (staff who have been authorised)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblAuthsAudit', @level2type=N'COLUMN',@level2name=N'authtype'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'type of change to table in authtype. 1= ADD  2=EDIT   3=DELETE ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblAuthsAudit', @level2type=N'COLUMN',@level2name=N'authchange'
GO
/****** Object:  Table [dbo].[tblAuths]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblAuths](
	[authID] [int] IDENTITY(1,1) NOT NULL,
	[apprvID] [int] NOT NULL,
	[authCode] [varchar](50) NOT NULL,
	[authTask] [varchar](max) NULL,
	[authReqs] [varchar](max) NULL,
	[authRef] [varchar](500) NULL,
	[ndeID] [int] NOT NULL,
 CONSTRAINT [PK_tblAuths] PRIMARY KEY CLUSTERED 
(
	[authID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblAuthorisor]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAuthorisor](
	[asrID] [int] IDENTITY(1,1) NOT NULL,
	[staffID] [int] NULL,
	[authID] [int] NULL,
	[startdate] [datetime] NULL,
	[enddate] [datetime] NULL,
	[authorisor] [int] NULL,
	[authdate] [datetime] NULL,
	[ndeID] [int] NULL,
 CONSTRAINT [PK_Authorisor] PRIMARY KEY CLUSTERED 
(
	[asrID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This table will fire a DATABASE TRIGGER for ADD, EDIT, DELETE events' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblAuthorisor', @level2type=N'COLUMN',@level2name=N'asrID'
GO
/****** Object:  Table [dbo].[tblStaffAuths]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblStaffAuths](
	[staID] [int] IDENTITY(1,1) NOT NULL,
	[staffID] [int] NULL,
	[authID] [int] NULL,
	[startdate] [datetime] NULL,
	[enddate] [datetime] NULL,
	[authorisor] [int] NULL,
	[authdate] [datetime] NULL,
	[ndeID] [int] NULL,
 CONSTRAINT [PK_staAuths] PRIMARY KEY CLUSTERED 
(
	[staID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This table will fire a DATABASE TRIGGER for ADD, EDIT, DELETE events' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblStaffAuths', @level2type=N'COLUMN',@level2name=N'staID'
GO
/****** Object:  StoredProcedure [dbo].[spPeRsQsObtained]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spPeRsQsObtained]
(
	@staffID	INT,
	@postID	INT
)

AS

SET DATEFORMAT DMY

SELECT tblQs.QTypeID, tblQs.Description, tempTableJoin.surname, tempTableJoin.firstname, tempTableJoin.staffID, tempTableJoin.staffQID, tblQs.Amber, tblValPeriod.vpdays, tblStaffQs.ValidFrom
FROM tblStaffQs
RIGHT OUTER JOIN
(SELECT staffQID, tblStaff.surname, tblStaff.firstname, tblStaff.staffID, QID
FROM tblStaffQs
LEFT OUTER JOIN tblStaff ON tblStaffQs.StaffID = tblStaff.staffID
WHERE tblStaff.staffID = @StaffID) tempTableJoin ON tblStaffQs.StaffQID = tempTableJoin.staffQID
RIGHT OUTER JOIN tblQs
LEFT OUTER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
LEFT OUTER JOIN tblPostQs ON tblPostQs.QID = tblQs.QID ON tblStaffQs.QID = tblQs.QID
WHERE (tblPostQs.PostID = @PostID)
ORDER BY tblQs.Description
GO
/****** Object:  StoredProcedure [dbo].[spPersQs]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPersQs]
(
	@StaffID	INT,
	@PostID	INT
)

AS

SET DATEFORMAT dmy

DECLARE @nodeID INT

SET @nodeID=(SELECT ndeID FROM tblPost WHERE tblPost.postID=@PostID)

-- First get all the STAFF Q's for this STAFF/HIERARCHY ( nodeID)
SELECT tblQs.QID, tblQs.QtypeID, tblQs.Description, tblStaff.staffID, TEST.StaffQID, tblValPeriod.vpdays, tblQs.Amber, TEST.ValidFrom, TEST.Competent, (SELECT COUNT (tblPostQs.QID)
FROM tblStaffQs
RIGHT OUTER JOIN
(SELECT staffQID, tblStaff.surname, tblStaff.firstname, tblStaff.staffID, QID
FROM tblStaffQs
LEFT OUTER JOIN tblStaff ON tblStaffQs.StaffID = tblStaff.staffID
WHERE tblStaff.staffID = @StaffID) tempTableJoin ON tblStaffQs.StaffQID = tempTableJoin.staffQID
RIGHT OUTER JOIN tblQs
LEFT OUTER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
LEFT OUTER JOIN tblPostQs ON tblPostQs.QID = tblQs.QID ON tblStaffQs.QID = tblQs.QID
WHERE tblPostQs.PostID = @PostID AND tblPostQs.QID = TEST.QID) AS Req
FROM tblStaff
INNER JOIN tblStaffQs AS TEST ON TEST.ndeID=@nodeID AND tblStaff.staffID = TEST.StaffID
INNER JOIN tblQs ON TEST.QID = tblQs.QID
INNER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
WHERE tblStaff.staffID = @StaffID

-- Now get all the POST Q's for this POST/HIERARCHY ( nodeID)
UNION

SELECT tblQs.QID, tblQs.QTypeID, tblQs.Description, tempTableJoin.staffID, tempTableJoin.staffQID, tblValPeriod.vpdays, tblQs.Amber, tblStaffQs.ValidFrom, tblStaffQs.Competent, 1 AS Req
FROM tblStaffQs
RIGHT OUTER JOIN
(SELECT staffQID, tblStaff.surname, tblStaff.firstname, tblStaff.staffID, QID
FROM tblStaffQs
LEFT OUTER JOIN tblStaff ON tblStaffQs.StaffID = tblStaff.staffID
WHERE tblStaff.staffID = @StaffID) tempTableJoin ON tblStaffQs.StaffQID = tempTableJoin.staffQID
RIGHT OUTER JOIN tblQs
LEFT OUTER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
LEFT OUTER JOIN tblPostQs ON tblPostQs.QID = tblQs.QID ON tblStaffQs.QID = tblQs.QID
WHERE tblPostQs.PostID = @PostID AND tblQs.QID NOT IN (SELECT tblQs.QID
FROM tblStaff
INNER JOIN tblStaffQs ON tblStaffQs.ndeID=@nodeID AND tblStaff.staffID = tblStaffQs.StaffID
INNER JOIN tblQs ON tblStaffQs.QID = tblQs.QID
INNER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
WHERE tblStaff.staffID = @StaffID)

-- Now get all the STAFF Q's for this STAFF/OTHER HIERARCHY ( NOT nodeID)-
-- this will pick up any Qs they brought with them when they posted from one Hierarchy eg:90SU to another eg RAFP
UNION

SELECT tblQs.QID, 0, tblQs.Description, tblStaff.staffID, TEST.StaffQID, tblValPeriod.vpdays, tblQs.Amber, TEST.ValidFrom, TEST.Competent,0 AS req
FROM tblStaff
INNER JOIN tblStaffQs AS TEST ON TEST.ndeID<>@nodeID AND tblStaff.staffID = TEST.StaffID
INNER JOIN tblQs ON TEST.QID = tblQs.QID 
INNER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
WHERE tblStaff.staffID = @StaffID
GO
/****** Object:  StoredProcedure [dbo].[spPersTaskHistory]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spPersTaskHistory] 
@recID INT

as

SET DATEFORMAT DMY

select tbltaskType.ttID, tbltaskType.description AS task , tbltasked.description,startdate,endDate,cancelable 
    from tblTasked 
     inner join tbltasktype on
         tbltasktype.ttID = tbltasked.ttid
          where staffID = @recID 
            order by startdate desc
GO
/****** Object:  StoredProcedure [dbo].[spPeRsVacsObtained]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPeRsVacsObtained]
    @nodeID INT,
	@staffID INT
AS

SELECT tblMilitaryVacs.description, tempTableJoin.surname, tempTableJoin.firstname, tempTableJoin.staffID, tempTableJoin.validFrom,tempTableJoin.validTo, tempTableJoin.competent, tempTableJoin.staffMVID
FROM tblMilitaryVacs
LEFT OUTER JOIN (SELECT staffMVID, tblStaff.surname, tblStaff.firstname, tblStaff.staffID, mvID, validfrom, validTo, competent FROM tblStaffMVs
LEFT OUTER JOIN tblStaff ON tblStaffMVs.StaffID = tblStaff.staffID
WHERE tblStaff.staffID = @staffID) AS tempTableJoin ON dbo.tblMilitaryVacs.mvID = tempTableJoin.MVID
-- WHERE tblMilitaryVacs.ndeID = @nodeID
ORDER BY tblMilitaryVacs.description
GO
/****** Object:  StoredProcedure [dbo].[spPeRsUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPeRsUpdate] 
(
	@staffID INT,
	@fname varchar(50),
	@sname varchar (50),
	@serviceno varchar (50),
	@knownas varchar (50),
	@phone varchar (50),
	@mobile varchar (50),
	@workPhone varchar (50),
	@pob varchar (50),
	@ppno varchar (50),
	@ppby varchar (50),
	@poc varchar (50),
	@welwish varchar(255),
	@notes varchar(255),
	@ardate varchar (50),
	@psdate varchar (50),
	@ooadate varchar (50),
	@dsgdate varchar (50),
	@ppdate varchar (50),
	@wwdate varchar (50),
	@rank int,
	@trade int,
	@admin INT,
	@sex char(1),
	@dob varchar(50),
	@mes int,
	@weaponno varchar(15),
	@susat bit
)

AS

SET DATEFORMAT dmy

UPDATE tblStaff SET
firstname = @fname, surname = @sname, serviceno = @serviceno, knownas = @knownas,
homephone = @phone, mobileno = @mobile, workPhone = @workPhone, pob = @pob, passportno = @ppno,
issueoffice = @ppby, poc = @poc, welfarewishes = @welwish, notes = @notes, arrivaldate = @ardate,
postingduedate = @psdate, lastooa = @ooadate, passportexpiry = @ppdate, handbookissued = @wwdate,
rankID = @rank, tradeID = @trade, administrator = @admin, sex = @sex, dob = @dob,
dischargeDate = @dsgdate, mesID = @mes, weaponNo = @weaponno, susat = @susat
  WHERE tblStaff.staffID = @staffID
GO
/****** Object:  StoredProcedure [dbo].[spPersUntask]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPersUntask]
(
	@taskStaffID	int
)

AS

DELETE tbl_TaskStaff
WHERE taskStaffID = @taskStaffID

--UPDATE tbl_TaskStaff SET
--active = 0
--WHERE taskStaffID = @taskStaffID
GO
/****** Object:  StoredProcedure [dbo].[spPostManagerUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[spPostManagerUpdate]
@postID int,
@Manager int,
@tmLevelID int,
@tmLevel int

as

update tblPost
set  Manager = @Manager
where PostID=@PostID

if @Manager=1
begin
	if not exists (select tmID from tblManager where postId=@postID)
	begin
		insert tblManager (postID,tmLevelID,tmLevel)
		values  (@postID,@tmLevelID,@tmLevel)
	end		
end
if @Manager=0
begin
	if exists (select tmID from tblManager where postId=@postID)
	begin
		delete tblManager where postId=@postID
	end		
end
GO
/****** Object:  StoredProcedure [dbo].[spPostInsert]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spPostInsert]
(
    @nodeID INT,
	@Description	VARCHAR(50),
	@AssignNo	VARCHAR(8),
	@hrcID      INT,
	@Position	VARCHAR(50),
	@RankID		INT,
	@TradeID	INT,
	@RWID		INT,
	@Notes		VARCHAR(255),
	@QOveride	INT,
	@MSOveride 	INT,
	@Overborne 	INT,
	@manager    INT,
	@Ghost		BIT,
	@Status		BIT,
	@blnFlag	BIT OUTPUT
)

AS

SET NOCOUNT ON

DECLARE @tmlID		INT
DECLARE @lvlID		INT
DECLARE @postID		INT

IF @Ghost = 1
	BEGIN
		IF (SELECT COUNT(*) FROM tblPost WHERE hrcID = @hrcID AND Ghost = 1) > 0
			BEGIN
				SET @blnFlag = 1
			END
		ELSE
			BEGIN
				INSERT INTO tblPost(ndeID,Description, AssignNo, hrcID, PositionDesc, RankID, TradeID, RWID, Notes, QOveride, MSOveride, overborne, Ghost, Status, manager)
				VALUES (@nodeID, @Description, @AssignNo, @hrcID, @Position, @RankID, @TradeID, @RWID, @Notes, @QOveride, @MSOveride, @Overborne, @Ghost, @Status, 1)
	
				SET @blnFlag = 0
	
				-- Its a Ghost post so make them a manager - cos there is no other reason for a ghost post
				SET @postID = @@IDENTITY 
				--SET @lvlID = (SELECT teamin FROM tblTeam WHERE tblTeam.teamID = @teamID)
                SET @lvlID = (SELECT hrclevel FROM tblHierarchy WHERE tblHierarchy.hrcID = @hrcID)
			    INSERT INTO tblManager (postID,tmLevelID,tmLevel, ndeID,hrcID )
			               VALUES (@postID,0 , @lvlID,@nodeID, @hrcID  )
			END
			
	END
ELSE
	BEGIN
		INSERT INTO tblPost(ndeID, Description, AssignNo, hrcID, PositionDesc, RankID, TradeID, RWID, Notes, QOveride, MSOveride, overborne, Ghost, Status)
		            VALUES (@nodeID,@Description, @AssignNo, @hrcID,@Position, @RankID, @TradeID, @RWID, @Notes, @QOveride, @MSOveride, @Overborne, @Ghost, @Status)
	END

IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spPostDetailSummary]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spPostDetailSummary]
(
	@postID INT
)

AS
SELECT tblPost.postID, tblPost.hrcID, tblPost.assignno,tblPost.description, tblHierarchy.hrcname AS Team,tblstaffpost.StaffID AS postholder 
  FROM tblPost
   INNER JOIN tblHierarchy ON tblHierarchy.hrcID=tblPost.hrcID
   LEFT OUTER JOIN  tblStaffPost ON tblPost.PostID = tblStaffPost.PostID AND (endDate IS NULL OR endDate > GETDATE())
   WHERE tblPost.postID = @postID
GO
/****** Object:  StoredProcedure [dbo].[spPostDetail]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spPostDetail]
(
	@PostID	INT
)

AS
SELECT tblPost.postID, tblPost.description, tblPost.assignno, tblHierarchy.hrcname AS team,tblRank.shortDesc + ' ' + tblStaff.surname + ', ' + tblStaff.firstname AS postholder, 
       tblPost.Ghost, tblPost.Status, tblPost.teamID,tblPost.hrcID, tblPost.positionDesc AS [position], tblPost.RWID AS RWID, tblPost.rankID, tblRank.shortDesc AS Rank, 
       tblPost.tradeID, tblTrade.description AS Trade, tblRankWeight.description AS RankWeight, tblPost.notes, tblPost.qoveride, tblPost.msoveride, tblPost.overborne, 
       tblManager.tmID AS manager, tblStaffPost.StaffPostID
FROM tblPost
INNER JOIN tblHierarchy ON tblHierarchy.hrcID=tblPost.hrcID
LEFT OUTER JOIN tblTrade ON tblPost.tradeID = tblTrade.tradeID
LEFT OUTER JOIN tblRankWeight ON tblPost.RWID = tblRankWeight.rwID
LEFT OUTER JOIN tblRank ON tblPost.rankID = tblRank.rankID
LEFT OUTER JOIN tblManager ON tblPost.postID = tblManager.postID
LEFT OUTER JOIN tblStaffPost ON tblStaffPost.PostID = tblPost.postID AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE())
LEFT OUTER JOIN tblStaff ON tblStaff.staffID = tblStaffPost.StaffID
WHERE tblPost.postId = @PostID

/**
SELECT tblPost.postID, tblPost.description, tblPost.assignno, tblTeam.description AS team, tblRank.shortDesc + ' ' + tblStaff.surname + ', ' + tblStaff.firstname AS postholder, 
       tblPost.Ghost, tblPost.Status, tblPost.teamID,tblPost.hrcID, tblPost.positionDesc AS [position], tblPost.RWID AS RWID, tblPost.rankID, tblRank.shortDesc AS Rank, 
       tblPost.tradeID, tblTrade.description AS Trade, tblRankWeight.description AS RankWeight, tblPost.notes, tblPost.qoveride, tblPost.msoveride, tblPost.overborne, 
       tblManager.tmID AS manager
FROM tblPost
LEFT OUTER JOIN tblTrade ON tblPost.tradeID = tblTrade.tradeID
LEFT OUTER JOIN tblRankWeight ON tblPost.RWID = tblRankWeight.rwID
LEFT OUTER JOIN tblRank ON tblPost.rankID = tblRank.rankID
LEFT OUTER JOIN tblManager ON tblPost.postID = tblManager.postID
LEFT OUTER JOIN tblTeam ON tblTeam.teamID = tblPost.teamID
LEFT OUTER JOIN tblStaffPost ON tblStaffPost.PostID = tblPost.postID AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE())
LEFT OUTER JOIN tblStaff ON tblStaff.staffID = tblStaffPost.StaffID
WHERE tblPost.postId = @PostID
**/
GO
/****** Object:  StoredProcedure [dbo].[spPostDel]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPostDel]
(
	@recID	INT,
	@DelOK	INT OUTPUT
)

AS

-- is there a body in the post
IF EXISTS (SELECT TOP 1 staffID from tblStaffPost WHERE tblStaffPost.postID = @recID AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()))
	SET @DelOk = '1' 
ELSE
	SET @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spPopulateStaffPostDetails]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create     PROCEDURE [dbo].[spPopulateStaffPostDetails]

as

INSERT INTO tblStaffPost  (StaffID, PostID, startDate)
       SELECT StaffID, PostID, arrivaldate
       FROM tblStaff
GO
/****** Object:  StoredProcedure [dbo].[spListTeamPostsInAndOutStartEnd]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spListTeamPostsInAndOutStartEnd]
(
	@tmID		INT,
	@all		INT,
	@startDate	VARCHAR(16),
	@endDate	VARCHAR(16),
	@sort		INT,
	@vacant	INT,
	@civi		INT
)

AS

DECLARE @fltID	INT
DECLARE @sqnID	INT
DECLARE @wingID	INT
DECLARE @groupID	INT
DECLARE @teamIN	INT
DECLARE @rankID	INT
DECLARE @unit   	VARCHAR(25)
DECLARE @StaffID	INT

DECLARE @Str		VARCHAR(4000)

DECLARE @first	INT

SET @teamIN = (SELECT teamIN from tblTeam WHERE tblTeam.teamID = @tmID)
SET @unit = (SELECT description from tblTeam WHERE tblTeam.teamID = @tmID)

-- so we know its the first time through the cursor loop below
SET @first = 0

-- temp table to hold list of units
CREATE TABLE #tempunit
(
	tmID		INT,
	tmIN		INT,
	tmDesc		VARCHAR(50)
)

INSERT INTO #tempunit
	SELECT teamID, teamIN, description from tblTeam 
	WHERE tblTeam.teamID = @tmID

IF @all = 1
	BEGIN
		-- we are looking at Group level down
		IF @teamIN = 0
			BEGIN
				-- first get the GroupID - we need it later
				SET @groupID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @tmID)
		
				-- now get all the Wings in the Group
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblWing
					INNER JOIN tblTeam ON tblTeam.parentID = tblWing.wingID AND tblTeam.teamIN = 1 
					WHERE tblWing.grpID = @groupID
		
				-- now get all the Squadrons in the wing
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblWing
					INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
					INNER JOIN tblTeam ON tblTeam.parentID = tblSquadron.sqnID AND tblTeam.teamIN = 2 
					WHERE tblWing.grpID = @groupID
		
				-- Now get all flight teams
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblWing
					INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
					INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID                  
					INNER JOIN tblTeam ON tblTeam.parentID = tblFlight.fltID AND tblTeam.teamIN = 3 
					WHERE tblWing.grpID = @groupID
		
				-- Now the teams in the flights
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblWing
					INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
					INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID                  
					INNER JOIN tblTeam AS t1 ON t1.parentID=tblflight.fltid
					INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
					WHERE tblWing.grpID = @groupID AND tblteam.teamin = 4
		
				-- Now the teams in the team
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblWing
					INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
					INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID                  
					INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
					INNER JOIN tblteam AS t2 ON t2.parentID=t1.teamID
					INNER JOIN tblteam ON tblteam.parentID = t2.teamID                
					WHERE tblWing.grpID = @groupID AND tblteam.teamin = 5 
		
			END
		
		-- we are looking at Wing level down
		IF @teamIN = 1
			BEGIN
				-- first get the WingID - we need it later
				SET @wingID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @tmID)
		
				-- now get all the Squadrons in the wing
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblSquadron
					INNER JOIN tblTeam ON tblTeam.parentID = tblSquadron.sqnID AND tblTeam.teamIN = 2 
					WHERE tblSquadron.wingID = @wingID
		
				-- now get all flight teams
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblSquadron
					INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID                  
					INNER JOIN tblTeam ON tblTeam.parentID = tblFlight.fltID AND tblTeam.teamIN = 3 
					WHERE tblSquadron.wingID = @wingID
		
				-- Now the teams in the flights
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblSquadron
					INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID
					INNER JOIN tblTeam AS t1 ON t1.parentID=tblflight.fltid
					INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
					WHERE tblSquadron.wingID = @wingID AND tblteam.teamin = 4
		
				-- Now the teams in the team
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblSquadron
					INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID                  
					INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
					INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
					INNER JOIN tblteam ON tblteam.parentID = t2.teamID                
					WHERE tblSquadron.wingID = @wingID AND tblteam.teamin = 5
			END
		
		-- we are looking at Sqn level down
		IF @teamIN = 2
			BEGIN
				-- first get the sqnID - we need it later
				SET @sqnID =(SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @tmID)
		
				-- first get all flight teams
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblFlight
					INNER JOIN tblTeam ON tblTeam.parentID=tblFlight.fltID AND tblTeam.teamIN = 3 
					WHERE tblFlight.sqnID = @sqnID
		
				-- Now the teams in the flight
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblFlight
					INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
					INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
					WHERE tblflight.sqnid = @sqnID AND tblteam.teamin = 4
		
				-- Now the teams in the team
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblFlight
					INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
					INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
					INNER JOIN tblteam ON tblteam.parentID = t2.teamID                
					WHERE tblflight.sqnid = @sqnID AND tblteam.teamin = 5
			END
		
		-- we are looking at Flight level down
		IF @teamIN = 3
			BEGIN
				-- first get the flightID - we need it later
				SET @fltID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @tmID)
		
				-- Now the teams in the flight
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblFlight
					INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
					INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
					WHERE tblflight.fltid = @fltID AND tblteam.teamin = 4
		
				-- Now the teams in the team
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblFlight
					INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
					INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
					INNER JOIN tblteam ON tblteam.parentID = t2.teamID                
					WHERE tblflight.fltid = @fltID AND tblteam.teamin = 5
			END
		
		-- we are looking at Team level down
		IF @teamIN = 4
			BEGIN
				-- Now the teams in the team
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblTeam AS T2
					INNER JOIN tblteam ON tblteam.parentID = t2.teamID                
					WHERE T2.teamID = @tmID AND tblteam.teamin = 5
			END
	END

SET DATEFORMAT dmy

IF  @all = 1
	BEGIN
		--Finds people who are present
		SET @Str = 'SELECT staffPostID, tblPost.postID, tblPost.assignno, tblManager.tmID AS Mgr, tblPost.description, tblPost.teamID, #tempunit.tmDesc /*tblTeam.Description*/ AS TeamName, surname, firstname, serviceno, shortdesc, staffID, Trade, QTotal
		FROM tblPost
		INNER JOIN #tempunit ON tblPost.teamID = #tempunit.tmID
		LEFT OUTER JOIN tblManager ON tblManager.postID =  tblPost.postID '

		IF @vacant = 1
			BEGIN
				SET @Str = @Str + 'LEFT OUTER JOIN '
			END
		ELSE
			BEGIN
				SET @Str = @Str + 'INNER JOIN '
			END

		SET @Str = @Str + '(SELECT * FROM vwStaffInPost WHERE ''' + @startDate + ''' >= startDate AND (''' + @startDate + ''' <= enddate OR endDate IS NULL)) AS tempTable ON tempTable.postId = tblPost.PostID 
		WHERE '

		IF @civi = 0 AND @vacant = 0
			BEGIN
				SET @Str = @Str + 'tempTable.Trade <> ' + '''' + 'Civilian' + '''' + ' AND '
			END		

		SET @Str = @Str + 'tblPost.Status = 1 AND tblPost.Ghost = 0 AND NOT EXISTS (SELECT taskStaffID FROM tbl_taskStaff WHERE ''' + @startDate + ''' >= startDate AND ''' + @startDate + ''' <= endDate AND tbl_taskStaff.staffId = tempTable.staffID AND active = 1)'

		IF @vacant = 1
			BEGIN
				SET @Str = @Str + ' AND serviceno IS NULL'
			END

		SET @Str = @Str + ' AND (tblPost.teamID = ' + CONVERT(VARCHAR(10),@tmID) + ' OR tblPost.teamID IN (SELECT childID FROM vwAllChildren WHERE parentID = ' + CONVERT(VARCHAR(10),@tmID) + '))
		ORDER BY '

		IF @sort = 1
			BEGIN
				SET @Str = @Str + 'tempTable.weight ASC '
			END
		
		IF @sort = 2
			BEGIN
				SET @Str = @Str + 'tempTable.weight DESC '
			END
		
		IF @sort = 3
			BEGIN
				SET @Str = @Str + 'surname DESC '
			END

		IF @sort = 4
			BEGIN
				SET @Str = @Str + 'surname ASC '
			END
		
		IF @sort = 5
			BEGIN
				SET @Str = @Str + 'teamName DESC '
			END
		
		IF @sort = 6
			BEGIN
				SET @Str = @Str + 'teamName ASC '
			END

		--Finds people who are absent
		SET @Str = @Str + 'SELECT *, (SELECT Description FROM tbl_taskStaff 
		INNER JOIN tbl_task ON tbl_taskStaff.taskID = tbl_task.taskID 
		WHERE ''' + @startDate + ''' >= tbl_taskStaff.startDate AND ''' + @endDate + ''' <= tbl_taskStaff.endDate AND tbl_taskStaff.staffId = vwStaffInPost.staffID AND active = 1) AS Location, qualTotal AS QTotal FROM vwStaffInPost 
		WHERE '

		IF @civi = 0
			BEGIN
				SET @Str = @Str + 'Trade <> ' + '''' + 'Civilian' + '''' + ' AND '
			END

		SET @Str = @Str + 'vwStaffInPost.Status = 1 AND vwStaffInPost.Ghost = 0 AND EXISTS (SELECT taskStaffID FROM tbl_taskStaff WHERE ((''' + @startDate + ''' >= startDate AND ''' + @endDate + ''' <= endDate) OR (''' + @startDate + ''' < startDate AND ''' + @endDate + ''' <= endDate AND ''' + @endDate + ''' >= startDate) OR (''' + @startDate + ''' >= startDate AND ''' + @startDate + ''' <= endDate AND ''' + @endDate + ''' > endDate) OR (''' + @startDate + ''' < startDate AND ''' + @endDate + ''' > endDate)) AND tbl_taskStaff.staffId = vwStaffInPost.staffID AND active = 1) '
		
		IF @vacant = 1
			BEGIN
				SET @Str = @Str + 'AND serviceno IS NULL '
			END

		SET @Str = @Str + 'AND (teamID = ' + CONVERT(VARCHAR(10),@tmID) + ' OR teamID IN (SELECT childID FROM vwAllChildren WHERE parentID = ' + CONVERT(VARCHAR(10),@tmID) +')) AND ''' + @startDate + ''' >= startDate AND (''' + @endDate + ''' <= enddate OR endDate IS NULL) ORDER BY '

		IF @sort = 1
			BEGIN
				SET @Str = @Str + 'weight ASC'
			END
		
		IF @sort = 2
			BEGIN
				SET @Str = @Str + 'weight DESC'
			END
		
		IF @sort = 3
			BEGIN
				SET @Str = @Str + 'surname DESC'
			END

		IF @sort = 4
			BEGIN
				SET @Str = @Str + 'surname ASC'
			END
		
		IF @sort = 5
			BEGIN
				SET @Str = @Str + 'teamName DESC'
			END
		
		IF @sort = 6
			BEGIN
				SET @Str = @Str + 'teamName ASC'
			END		
	END
ELSE
	BEGIN
		--Finds people who are present
		SET @Str = 'SELECT staffPostID, tblPost.postID, tblPost.assignno, tblManager.tmID AS Mgr, tblPost.description, tblPost.teamID, /*#tempunit.tmDesc*/ tblTeam.Description AS TeamName, surname, firstname, serviceno, shortdesc, staffID, Trade, QTotal
		FROM tblPost 
		--INNER JOIN #tempunit ON tblPost.teamID = #tempunit.tmID
		INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
		LEFT OUTER JOIN tblManager ON tblManager.postID = tblPost.postID '

		IF @vacant = 1
			BEGIN
				SET @Str = @Str + 'LEFT OUTER JOIN '
			END
		ELSE
			BEGIN
				SET @Str = @Str + 'INNER JOIN '
			END

		SET @Str = @Str + '(SELECT * FROM vwStaffInPost WHERE ''' + @startDate + ''' >= startDate AND (''' + @startDate + ''' <= enddate OR endDate IS NULL)) AS tempTable ON tempTable.postId = tblPost.PostID 
		WHERE '

		IF @civi = 0 AND @vacant = 0
			BEGIN
				SET @Str = @Str + 'tempTable.Trade <> ' + '''' + 'Civilian' + '''' + ' AND '
			END
		
		SET @Str = @Str + 'tblPost.Status = 1 AND tblPost.Ghost = 0 AND NOT EXISTS (SELECT taskStaffID FROM tbl_taskStaff WHERE ((''' + @startDate + ''' >= startDate AND ''' + @endDate + ''' <= endDate) OR (''' + @startDate + ''' < startDate AND ''' + @endDate + ''' <= endDate AND ''' + @endDate + ''' >= startDate) OR (''' + @startDate + ''' >= startDate AND ''' + @startDate + ''' <= endDate AND ''' + @endDate + ''' > endDate) OR (''' + @startDate + ''' < startDate AND ''' + @endDate + ''' > endDate)) AND tbl_taskStaff.staffId = tempTable.staffID AND active = 1) '
		
		IF @vacant = 1
			BEGIN
				SET @Str = @Str + 'AND serviceno IS NULL '
			END		

		SET @Str = @Str + 'AND (tblPost.teamID = ' + CONVERT(VARCHAR(10),@tmID) + ') ' 

		SET @Str = @Str + 'ORDER BY '

		IF @sort = 1
			BEGIN
				SET @Str = @Str + 'tempTable.weight ASC '
			END
		
		IF @sort = 2
			BEGIN
				SET @Str = @Str + 'tempTable.weight DESC '
			END
		
		IF @sort = 3
			BEGIN
				SET @Str = @Str + 'surname DESC '
			END

		IF @sort = 4
			BEGIN
				SET @Str = @Str + 'surname ASC '
			END
		
		IF @sort = 5
			BEGIN
				SET @Str = @Str + 'teamName DESC '
			END
		
		IF @sort = 6
			BEGIN
				SET @Str = @Str + 'teamName ASC '
			END		

		--Finds people who are abcent
		SET @Str = @Str + 'SELECT *, (SELECT Description FROM tbl_taskStaff
		INNER JOIN tbl_task ON tbl_taskStaff.taskID = tbl_task.taskID 
		WHERE ''' + @startDate + ''' >= tbl_taskStaff.startDate AND ''' + @endDate + ''' <= tbl_taskStaff.endDate AND tbl_taskStaff.staffId = vwStaffInPost.staffID AND active = 1) AS Location, qualTotal AS QTotal FROM vwStaffInPost 
		WHERE '
		
		IF @civi = 0
			BEGIN
				SET @Str = @Str + 'Trade <> ' + '''' + 'Civilian' + '''' + ' AND '
			END

		SET @Str = @Str + 'vwStaffInPost.Status = 1 AND vwStaffInPost.Ghost = 0 AND EXISTS (SELECT taskStaffID FROM tbl_taskStaff WHERE ((''' + @startDate + ''' >= startDate AND ''' + @endDate + ''' <= endDate) OR (''' + @startDate + ''' < startDate AND ''' + @endDate + ''' <= endDate AND ''' + @endDate + ''' >= startDate) OR (''' + @startDate + ''' >= startDate AND ''' + @startDate + ''' <= endDate AND ''' + @endDate + ''' > endDate) OR (''' + @startDate + ''' < startDate AND ''' + @endDate + ''' > endDate)) AND tbl_taskStaff.staffId = vwStaffInPost.staffID AND active = 1) '
		
		IF @vacant = 1
			BEGIN
				SET @Str = @Str + 'AND serviceno IS NULL '
			END

		SET @Str = @Str + 'AND teamID = ' + CONVERT(VARCHAR(10),@tmID) + ' AND ''' + @startDate + ''' >= startDate AND (''' + @endDate + ''' <= enddate OR endDate IS NULL) ORDER BY '
		
		IF @sort = 1
			BEGIN
				SET @Str = @Str + 'weight ASC '
			END
		
		IF @sort = 2
			BEGIN
				SET @Str = @Str + 'weight DESC '
			END
		
		IF @sort = 3
			BEGIN
				SET @Str = @Str + 'surname DESC '
			END

		IF @sort = 4
			BEGIN
				SET @Str = @Str + 'surname ASC '
			END
		
		IF @sort = 5
			BEGIN
				SET @Str = @Str + 'teamName DESC '
			END
		
		IF @sort = 6
			BEGIN
				SET @Str = @Str + 'teamName ASC '
			END 
	END

--PRINT(@Str)
EXEC(@Str)

DROP TABLE #tempunit
GO
/****** Object:  StoredProcedure [dbo].[spListDental]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListDental]
  @ndeID INT
AS

SELECT DentalID,dbo.tblDental.description , tblDental.vpID, dbo.tblValPeriod.description AS ValidityPeriod, Combat
   FROM dbo.tblDental 
   INNER JOIN dbo.tblValPeriod ON dbo.tblDental.vpID = dbo.tblValPeriod.vpID
   --WHERE tblDental.ndeID=@ndeID
GO
/****** Object:  StoredProcedure [dbo].[spPeRsMilitarySkillsObtained]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPeRsMilitarySkillsObtained]
(
	@staffID INT,
	@postID INT,
	@startDate VARCHAR(20)
)

AS

SET DATEFORMAT dmy

--DECLARE @TodayDate DATETIME

/** - need to see ALL MSkills for individual - NOT just ones that are post mandatory
SELECT tblMilitarySkills.description, tempTableJoin.surname, tempTableJoin.firstname, tempTableJoin.staffID, tempTableJoin.validFrom, tempTableJoin.validTo, tblMilitarySkills.exempt as qexempt, tempTableJoin.competent,tempTableJoin.exempt, tempTableJoin.staffMSID, tblValPeriod.vpdays, tblMilitarySkills.Amber
FROM tblMilitarySkills
INNER JOIN tblPostMilSkill ON tblPostMilSkill.msID = tblMilitarySkills.msID
INNER JOIN tblValPeriod ON tblMilitarySkills.msvpID = tblValPeriod.vpID
LEFT OUTER JOIN (SELECT staffMSID, tblStaff.surname, tblStaff.firstname, tblStaff.staffID, MSID, validfrom,validTo, competent, tblStaffMilskill.exempt
FROM tblStaffMilskill LEFT OUTER JOIN tblStaff ON tblStaffMilskill.StaffID = tblStaff.staffID WHERE tblStaff.staffID = @staffID) AS tempTableJoin ON dbo.tblMilitarySkills.MSID = tempTableJoin.MSID
WHERE tblPostMilSkill.PostID = @PostID

**/

SELECT tblMilitarySkills.description, tblStaff.surname, tblStaff.firstname, tblStaff.staffID, tblStaffMilskill.validFrom,
       tblStaffMilskill.validTo, tblMilitarySkills.exempt as qexempt, tblStaffMilskill.competent,tblStaffMilskill.exempt, 
       tblStaffMilskill.staffMSID, tblValPeriod.vpdays, tblMilitarySkills.Amber
   FROM tblStaff
    INNER JOIN tblStaffMilskill ON tblStaffMilskill.StaffID = tblStaff.staffID
    INNER JOIN tblMilitarySkills ON tblMilitarySkills.msID = tblStaffMilskill.MSID
    INNER JOIN tblValPeriod ON tblMilitarySkills.vpID = tblValPeriod.vpID
    WHERE tblStaff.staffID = @staffID
GO
/****** Object:  StoredProcedure [dbo].[spPeRsInsert]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPeRsInsert]
(
    @nodeID INT,
	@fname varchar(50),
	@sname varchar (50),
	@serviceno varchar (50),
	@knownas varchar (50),
	@phone varchar (50),
	@mobile varchar (50),
	@workPhone varchar (50),
	@pob varchar (50),
	@ppno varchar (50),
	@ppby varchar (50),
	@poc varchar (50),
	@welwish varchar(255),
	@notes varchar(255),
	@ardate varchar (50),
	@psdate varchar (50),
	@ooadate varchar (50),
	@dsgdate varchar (50),
	@ppdate varchar (50),
	@wwdate varchar (50),
	@rank int,
	@trade int,
	@admin int,
	@sex char(1),
	@dob varChar(50),
	@mes int,
	@weaponno varchar(15),
	@susat bit,
	@randomWord varchar(9) OUT,
	@staffID int OUT
)

AS

DECLARE @Start char(10)
DECLARE @End char(10)
DECLARE @pw varchar(32)
DECLARE @charset varchar(300)
DECLARE @randCharsetPos int


-- get generic password

set @randomWord = ''
set @charset = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

--  Build a random word, 9 Chars long from the charset

while len(@randomWord) < 9
BEGIN
	set @randCharsetPos = (select CAST ((rand() * LEN(@charset)) AS INT))
	set @randomWord = @randomWord + (select substring(@charset, @randCharsetPos, 1))
END
	
SET @pw = (SELECT substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', @randomWord)),3,32))

SET DATEFORMAT dmy

BEGIN TRANSACTION
	INSERT INTO tblStaff
	(
		ndeID, firstname, surname, serviceno, knownas, homephone, mobileno, workPhone, pob, passportno, issueoffice, poc, welfarewishes, notes, arrivaldate, 
		postingduedate, lastOOA, dischargeDate, passportexpiry, handbookissued, rankID, tradeID,administrator, sex, dob, mesID, weaponno, susat
	)
	VALUES
	(
		@nodeID,@fname, @sname, @serviceno, @knownas, @phone, @mobile, @workPhone, @pob, @ppno, @ppby, @poc, @welwish, @notes, @ardate, @psdate, 
		@ooadate, @dsgdate, @ppdate, @wwdate, @rank, @trade, @admin, @sex, @dob,@mes, @weaponno, @susat
	)

	-- now set the default password
	SET @staffID = @@IDENTITY 

	INSERT INTO tblPassword  (staffID, staffpw, pswd, dPswd, expires)
					   VALUES(@staffID, @randomWord, @pw, @pw, GETDATE()+90)

	INSERT INTO tblStaffPhoto (ndeID, staffID)
						VALUES(@nodeID,@staffID)
COMMIT

/****** Object:  StoredProcedure [dbo].[spResetPW]    Script Date: 06/20/2014 10:34:15 ******/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[spQTypeUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spQTypeUpdate]
(
	@QTypeID	INT,
	@Description	VARCHAR(50),
	@Auth		BIT,
	@blnExists	BIT OUTPUT
)

AS

UPDATE tblQTypes SET
Description = @Description,
Auth = @Auth
WHERE QTypeID = @QTypeID

SET @blnExists = 0
GO
/****** Object:  StoredProcedure [dbo].[spQTypeInsert]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spQTypeInsert]
(
    @nodeID INT,
	@Description	VARCHAR(50),
	@Auth		BIT,
	@blnExists	BIT OUTPUT
)

AS

IF EXISTS (SELECT Description FROM tblQTypes WHERE Description = @Description)
	BEGIN
		SET @blnExists = 1
	END
ELSE
	BEGIN
		INSERT INTO tblQTypes (ndeID,Description,Auth)
		               VALUES (@nodeID, @Description,@Auth)

		SET @blnExists = 0
	END
GO
/****** Object:  StoredProcedure [dbo].[spQTypeDel]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spQTypeDel]
(
	@recID		INT,
	@DelOK	INT OUTPUT
)

AS

-- has it got a Q assigned to it
IF EXISTS (SELECT TOP 1 QTypeID FROM tblQs WHERE tblQs.QTypeID = @recID)    
	SET @DelOk = '1' 
ELSE
	SET @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spQsAvailable]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spQsAvailable]
(
	@StaffID	INT,
	@TypeID		INT
)

AS

SELECT tblQs.QID, tblQs.Description, tblQs.ndeID, tblQTypes.Auth
FROM tblQs
INNER JOIN tblQTypes ON tblQs.QTypeID = tblQTypes.QtypeID
WHERE tblQs.QTypeID = @TypeID AND NOT EXISTS (SELECT QID FROM tblStaffQs WHERE tblQs.QID = tblStaffQs.QID AND StaffID = @StaffID AND tblStaffQs.TypeID = @TypeID)
ORDER BY tblQs.description
GO
/****** Object:  StoredProcedure [dbo].[spQsAuthority]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spQsAuthority]
@StaffID int,
@authby VARCHAR(50) OUT

AS

SET @authby=(SELECT SUBSTRING(tblRank.shortDesc,1,LEN(tblRank.shortDesc)) + ' ' + SUBSTRING(tblStaff.firstname, 1, 1)  + ' ' + tblstaff.surname 
                  FROM tblStaff
                    INNER JOIN tblRank ON tblrank.rankID=tblstaff.rankID
                     WHERE tblStaff.staffID = @StaffID)
GO
/****** Object:  StoredProcedure [dbo].[spQs]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spQs]
(
	@QTypeID	INT
)

AS

SELECT tblQs.*, tblValPeriod.description AS ValidityPeriod
   FROM tblQs
	LEFT OUTER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
	 WHERE tblQs.QTypeID = @QTypeID
	  ORDER BY tblQs.description
GO
/****** Object:  StoredProcedure [dbo].[spQInsert]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spQInsert]
(
    @nodeID INT,
	@Description	VARCHAR(50),
	@QTypeID	INT,
	@vpID		INT,
	@Amber	INT,
	@Enduring	BIT,
	@Contingent	BIT,
	@LongDesc	VARCHAR(300),
	@Exists		BIT OUTPUT
)

AS

BEGIN TRANSACTION
	IF NOT EXISTS(SELECT Description FROM tblQs WHERE Description = @Description)
		BEGIN
			INSERT INTO tblQs
			(
			ndeID,
			Description,
			QTypeID,
			vpID,
			Amber,
			Enduring,
			Contingent,
			LongDesc
			)
     			VALUES
			(
			@nodeID,
			@Description,
			@QTypeID,
			@vpID,
			@Amber,
			@Enduring,
			@Contingent,
			@LongDesc
			)

			SET @Exists = '0'
		END
	ELSE
		BEGIN
			SET @Exists = '1'
		END

IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END

COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [dbo].[spPostQualificationsTypeDetails]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spPostQualificationsTypeDetails]
(
	@RecID	INT,
	@TypeID INT
)

AS

SELECT Description AS Type FROM tblQTypes WHERE QTypeID = @TypeID

SELECT tblPost.postID, tblPostQs.PostQID, tblQs.Description, tblPostQs.Status, tblPostQStatus.Description AS StatusDesc, tblPostQs.Competent
FROM tblPost
INNER JOIN tblPostQs ON tblPost.postID = tblPostQs.PostID
LEFT OUTER JOIN tblQs ON tblPostQs.QID = tblQs.QID
LEFT OUTER JOIN tblPostQStatus ON tblPostQStatus.PostQStatus = tblPostQs.Status
WHERE tblPost.PostID = @RecID AND tblPostQs.TypeID = @TypeID
ORDER BY tblQs.description
GO
/****** Object:  StoredProcedure [dbo].[spPostQsSummary]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPostQsSummary] 
(
	@RecID		INT
)

AS

SELECT tblQs.QTypeID, tblQs.description
FROM tblPost
INNER JOIN tblPostQs ON tblPost.PostID = tblPostQs.PostID
INNER JOIN tblQs ON tblPostQs.QID = tblQs.QID
WHERE tblPost.PostID = @RecID
ORDER BY tblQs.description
GO
/****** Object:  StoredProcedure [dbo].[spPostQsAvailable]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPostQsAvailable]
(
	@PostID	INT,
	@TypeID INT
)

AS

SELECT QID, Description, ndeID
  FROM tblQs
   WHERE tblQs.QTypeID = @TypeID AND NOT EXISTS (SELECT QID FROM tblPostQs WHERE tblPostQs.QID=tblQs.QID AND tblPostQs.PostID = @PostID)
   ORDER BY Description
GO
/****** Object:  StoredProcedure [dbo].[spPostOutUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spPostOutUpdate]
(
	@StaffPostID	INT,
	@endDate	VARCHAR(30)
)

AS

SET DATEFORMAT dmy

DECLARE @tempIdentity	INT
DECLARE @staffId	INT
DECLARE @postID		INT
DECLARE @endOfMonth	VARCHAR(30)
DECLARE @ghost		BIT

SET @staffId = (SELECT staffId FROM tblStaffPost WHERE StaffPostID = @StaffPostID)
SET @endOfMonth = @endDate
SET @endOfMonth = RIGHT(@endOfMonth,8)
SET @endOfMonth = '01' + @endOfMonth
SET @endOfMonth = CONVERT(DATETIME,@endOfMonth,103)
SET @endOfMonth = DATEADD(MONTH, 1, @endOfMonth)
SET @endOfMonth = DATEADD(DAY, -1, @endOfMonth)
SET @postID = (SELECT postID FROM tblStaffPost WHERE staffPostID = @staffPostID)
SET @ghost = (SELECT ghost FROM tblPost WHERE PostID = @postID)

IF @ghost = 0
	BEGIN
--		UPDATE tbl_TaskStaff SET
--		active = 0
--		WHERE staffID = @staffID AND startDate > CONVERT(DATETIME,@endDate) AND startDate <= CONVERT(DATETIME,@endOfMonth)

		SET @tempIdentity = (SELECT TOP 1 taskid FROM tbl_task WHERE ttID = 27)

        -- add a tasked record so the calendar can pick it up
		INSERT INTO tbl_taskStaff (taskID,staffID,startDate,endDate,Cancellable,Active)
		VALUES(@tempIdentity,@staffID,CONVERT(DATETIME,@endDate)+1,CONVERT(DATETIME,@endOfMonth),0,1)
		
		-- now flag the staff record as inactive cos they are posted
		UPDATE tblstaff 
		  SET active = 0
		   WHERE tblstaff.staffid = @staffid

       -- If its a ghost post then leave it as a manager - cos we can't update it via CMS later as Gohost Posts are Read Only
		DELETE tblManager WHERE postID = @postID
		
		-- Now update tblStaffPost record - including any Ghost Post 
        -- because they cannot access them if they are inactive
         UPDATE tblStaffPost 
		  SET endDate = @endDate
			WHERE endDate IS NULL AND tblStaffPost.staffID = @StaffID
			
	END
ELSE   -- it's a ghost post so just oick em out
    BEGIN
      UPDATE tblStaffPost 
		  SET endDate = @endDate
			WHERE StaffPostID = @StaffPostID
    END
GO
/****** Object:  StoredProcedure [dbo].[spPostMSDetails]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPostMSDetails]
(
	@RecID	INT
)

AS

SELECT 'Military Skills' AS Type
SELECT tblPost.PostID, PostMSID, tblMilitarySkills.description, tblPostMilSkill.status, tblPostQStatus.description AS StatusDesc, competent
FROM tblPost
INNER JOIN tblPostMilSkill ON tblPost.PostID = tblPostMilSkill.PostID
INNER JOIN tblMilitarySkills ON tblPostMilSkill.MSID = tblMilitarySkills.MSID
INNER JOIN tblPostQStatus ON tblPostQStatus.PostQStatus = tblPostMilSkill.status
WHERE tblPost.PostID = @recid
ORDER BY tblMilitarySkills.description
GO
/****** Object:  StoredProcedure [dbo].[spPostMSAvailable]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spPostMSAvailable]

@nodeID INT,
@PostID int

AS

SELECT  msID, [description]  
  FROM tblMilitarySkills
    WHERE tblMilitarySkills.ndeID = @nodeID AND 
          NOT EXISTS (SELECT msID FROM tblPostMilSkill WHERE tblMilitarySkills.msID = tblPostMilSkill.msID and postID =@PostID)
     ORDER BY tblMilitarySkills.[description]
GO
/****** Object:  StoredProcedure [dbo].[spPostStaffRemoveTest]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[spPostStaffRemoveTest]
@PostID INT,
@StaffPostID INT
AS

delete tblStaffPost where StaffPostID = @StaffPostID
GO
/****** Object:  StoredProcedure [dbo].[spRankWtUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create       PROCEDURE [dbo].[spRankWtUpdate]
@RecID int,
@rwValue int,
@Description varchar (50)


as

update tblRankWeight
  set rankwt = @rwValue, description = @description
   where tblRankWeight.rwid = @recid
GO
/****** Object:  StoredProcedure [dbo].[spRankWtInsert]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spRankWtInsert]
@rwValue int,
@Description varchar (50)

as


insert tblRankWeight (rankwt, Description)
values (@rwValue,@Description)
GO
/****** Object:  StoredProcedure [dbo].[spRankDetailUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRankDetailUpdate]
@RankID int,
@ShortDesc varchar(15),
@Description varchar (50),
@Status int,
@Weight int

as

update tblRank
set shortDesc = @ShortDesc,Description = @Description,Status = @Status
,weight=@weight
where rankID=@RankID
GO
/****** Object:  StoredProcedure [dbo].[spRankDetailInsert]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRankDetailInsert]
@nodeID INT,
@ShortDesc varchar(15),
@Description varchar (50),
@Status int,
@Weight int

as

insert tblRank (shortDesc,Description,Status,weight,ndeID)
values (@ShortDesc,@Description,@Status,@weight, @nodeID)
GO
/****** Object:  StoredProcedure [dbo].[spRankDetail]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRankDetail]
@recID int
AS

SELECT     dbo.tblRank.shortDesc, dbo.tblRank.description, dbo.tblRank.status, dbo.tblRankWeight.rankWt, 
                      dbo.tblRankWeight.description AS RWDescription
FROM         dbo.tblRank INNER JOIN
                      dbo.tblRankWeight ON dbo.tblRank.Weight = dbo.tblRankWeight.rwID where rankId = @RecID
GO
/****** Object:  StoredProcedure [dbo].[spRankDel]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spRankDel]
@recID int,
@DelOK int OUTPUT
as

-- has it got staff assigned to it
IF EXISTS (SELECT TOP 1 staffID from tblStaff WHERE tblStaff.rankID = @recID)    
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spQWeightUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create      PROCEDURE [dbo].[spQWeightUpdate]
@RecID int,
@Type varchar (2),
@Description varchar (50),
@wt int


as

update tblQWeight
  set qwtype = @type, qwvalue = @wt, description = @description
   where tblqweight.qwid = @recid
GO
/****** Object:  StoredProcedure [dbo].[spQWeightInsert]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[spQWeightInsert]
	@nodeID INT,
	@Type VARCHAR (2),
	@Description VARCHAR (50),
	@wt INT

 AS

INSERT tblQWeight (ndeID, qwtype, Description, qwvalue)
           VALUES (@nodeID, @type, @Description, @wt)
GO
/****** Object:  StoredProcedure [dbo].[spQUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spQUpdate]
(
	@QID		INT,
	@Description	VARCHAR(50),
	@QTypeID	INT,
	@vpID		INT,
	@Amber	INT,
	@Enduring	BIT,
	@Contingent	BIT,
	@LongDesc	VARCHAR(300)
)

AS

BEGIN TRANSACTION
	BEGIN
		UPDATE tblQs SET
		Description = @Description,
		QTypeID = @QTypeID,
		vpID = @vpID,
		Amber = @Amber,
		Enduring = @Enduring,
		Contingent = @Contingent,
		LongDesc = @LongDesc
		WHERE QID = @QID
	END

IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END

COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [dbo].[spQualificationsTypeDetails]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spQualificationsTypeDetails]
(
	@RecID	INT,
	@TypeID	INT
)

AS

SELECT Description AS Type, Auth FROM tblQTypes WHERE QTypeID = @TypeID
SELECT tblStaff.staffID, tblStaffQs.StaffQID, tblQs.description, tblStaffQs.ValidFrom, tblStaffQs.Competent, tblQs.Amber, tblValPeriod.vpdays, tblStaffQs.AuthName
FROM tblStaff
INNER JOIN tblStaffQs ON tblStaff.staffID = tblStaffQs.StaffID
INNER JOIN tblQs ON tblStaffQs.QID = tblQs.QID
INNER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
WHERE tblStaff.staffID = @RecID AND tblStaffQs.TypeID = @TypeID
ORDER BY tblQs.description
GO
/****** Object:  StoredProcedure [dbo].[spQDel]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spQDel]
(
	@recID		INT,
	@DelOK	INT OUTPUT
)

AS

-- has a Q been assigned to a post
IF EXISTS (SELECT TOP 1 QID FROM tblPostQs WHERE tblPostQs.QID = @recID)    
	SET @DelOk = '1' 
ELSE
	SET @DelOk = '0'

-- has a Q been assigned to personnel
IF EXISTS (SELECT TOP 1 QID FROM tblStaffQs WHERE tblStaffQs.QID = @recID)    
	SET @DelOk = '1' 
ELSE
	SET @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spPsTyDel]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE      PROCEDURE [dbo].[spPsTyDel]
@recID int,
@DelOK int OUTPUT

as

-- has it got task assigned to it
IF EXISTS (SELECT TOP 1 taskID FROM tbl_Task WHERE tbl_Task.ttID = @recID)
	SET @DelOk = '1' 
ELSE
	SET @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spPsTaInsert]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spPsTaInsert]
   @ptaskid int,
   @pstaffid int,
   @ptask varchar(250),
   @pstart varchar (20),
   @pend varchar (20),
   @pcancel int

AS

-- these are working variables
declare @stdate datetime
declare @endate datetime
declare @stnum INT
declare @endnum int
declare @newstart datetime
declare @newend datetime

-- variables from any existing task that may need to be split
declare @tkID INT
declare @tkstart datetime
declare @tkend datetime
declare @tktask varchar (250)
declare @tktaskID int
declare @tkcancel bit


-- now set the dates we need for any split records we need to inserts
set @stdate = convert(datetime, @pstart, 103)
set @endate = convert(datetime, @pend, 103)

set @endnum = convert(int, @stdate - 1, 112)
set @stnum =  convert(int, @endate + 1, 112)

set @newstart = convert(datetime, @stnum, 103)
set @newend =  convert(datetime,  @endnum, 103)


-- first see if we have a conflicting task
DECLARE tasked CURSOR SCROLL FOR
  SELECT 
       tbltasked.tskID, tbltasked.ttID, tbltasked.description, 
       tbltasked.startdate, tbltasked.enddate, tbltasked.cancelable 
        from tbltasked 
          where tbltasked.startdate < @stdate and 
                tbltasked.enddate > @endate and 
                staffid = @pstaffid
OPEN tasked

FETCH FIRST FROM tasked INTO @tkID,@tktaskID, @tktask, @tkstart, @tkend, @tkcancel

-- there is a tasked record already so now we have to split to before and after the new tasked and then
-- insert the new one
IF @@FETCH_STATUS = 0
  BEGIN
    
    -- now split the existing task and create one before and one after the task 
    -- we are going to create
    INSERT tblTasked(ttID, staffID, description, startdate, enddate, cancelable)
      values (@tktaskID, @pstaffID, @tktask, @tkstart, @newend, @tkcancel)

   -- now the one after  
    INSERT tblTasked(ttID, staffID, description, startdate, enddate, cancelable)
      values (@tktaskID, @pstaffID, @tktask, @newstart, @tkend, @tkcancel)  

   -- now delete the existing one
    DELETE FROM tbltasked WHERE tbltasked.tskID = @tkID

  END  

CLOSE tasked
DEALLOCATE tasked

  -- now the one we have just tasked
  INSERT tblTasked(ttID, staffID, description, startdate, enddate, cancelable)
    values (@ptaskID, @pstaffID, @ptask, @stdate, @endate, @pcancel)
GO
/****** Object:  StoredProcedure [dbo].[spPsTaDel]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spPsTaDel]
@recID int,
@DelOK int OUTPUT
as

-- has it got staff assigned to it  
IF EXISTS (SELECT TOP 1 staffID from tbl_TaskStaff WHERE tbl_TaskStaff.taskID = @recID)  
	SET @DelOk = '1' 
ELSE
	SET @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spPostUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spPostUpdate]
(
	@postID		INT,
	@Description	VARCHAR(50),
	@AssignNo	VARCHAR(8),
	--@TeamID		INT,
	@hrcID      INT,
	@Position	VARCHAR(50),
	@RankID		INT,
	@TradeID	INT,
	@RWID		INT,
	@Notes		VARCHAR(255),
	@QOveride	INT,
	@MSOveride 	INT,
	@Overborne 	INT,
	@manager    INT,
	@Ghost		BIT,
	@Status		BIT,
	@blnFlag	BIT OUTPUT
)

AS

DECLARE @level INT
DECLARE @ndeID INT

SET NOCOUNT ON

DECLARE @CurrentTeamID	INT
SET @CurrentTeamID = (SELECT teamID FROM tblPost WHERE PostID = @PostID)
/**
IF @Ghost = 1
	BEGIN
		IF (SELECT COUNT(*) FROM tblPost WHERE teamID <> @CurrentTeamID AND teamID = @TeamID AND Ghost = 1) > 0
			BEGIN
				SET @blnFlag = 1
			END
		ELSE
			BEGIN
				SET DATEFORMAT dmy
	
				UPDATE tblPost SET
				Description = @Description,
				AssignNo = @AssignNo,
				--TeamID = @TeamID,
				hrcID=@hrcID,
				PositionDesc = @Position,
				RankID = @RankID,
				TradeID = @TradeID,
				RWID = @RWID,
				Notes = @Notes,
				QOveride = @QOveride,
				MSOveride = @MSOveride,
				overborne = @Overborne,
				manager=@manager,
				Ghost = @Ghost,
				Status = @Status
				WHERE PostID=@PostID
				
				SET @blnFlag = 0
				
				EXEC spUpdateTeamManagersAfterMove
			END
	END
ELSE
**/
	BEGIN
		SET DATEFORMAT dmy
	
		UPDATE tblPost SET
		Description = @Description,
		AssignNo = @AssignNo,
		--TeamID = @TeamID,
		hrcID=@hrcID,
		PositionDesc = @Position,
		RankID = @RankID,
		TradeID = @TradeID,
		RWID = @RWID,
		Notes = @Notes,
		QOveride = @QOveride,
		MSOveride = @MSOveride,
		overborne = @Overborne,
		manager=@manager,
		Ghost = @Ghost,
		Status = @Status
		WHERE PostID=@PostID
		
		SET @blnFlag = 0
		
		--EXEC spUpdateTeamManagersAfterMove
		IF @Manager=0
         BEGIN
	       IF EXISTS (SELECT tmID FROM tblManager WHERE postId=@postID)
		     DELETE tblManager where postId=@postID
         END
        ELSE
         BEGIN
           SET @level = (SELECT hrclevel FROM tblHierarchy WHERE tblHierarchy.hrcID = (SELECT hrcID FROM tblPost WHERE postID = @postID))
           IF NOT EXISTS (SELECT tmID FROM tblManager WHERE postId=@postID)
               INSERT tblManager (postID,tmLevelID,tmLevel, ndeID,hrcID )
		             VALUES     (@postID,0 , @level,(SELECT ndeID FROM tblPost WHERE postID = @postID), @hrcID  )
		   ELSE
		     UPDATE tblManager
		         SET tmLevel=@level,
		             hrcID=@hrcID  
		             WHERE postID=@postID
         END
         
	END

IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END

SET NOCOUNT OFF

/************
if @Manager=1
begin
	if not exists (select tmID from tblManager where postId=@postID)
	begin
		insert tblManager (postID,tmLevelID,tmLevel)
		values  (@postID,@tmLevelID,@tmLevel)
	end		
end
if @Manager=0
begin
	if exists (select tmID from tblManager where postId=@postID)
	begin
		delete tblManager where postId=@postID
	end		
end

***************/
GO
/****** Object:  StoredProcedure [dbo].[spPeRsDentalObtained]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE         PROCEDURE [dbo].[spPeRsDentalObtained]
@nodeID INT,
@staffID INT
AS

SET DATEFORMAT DMY

declare @TodayDate varchar(20)

set @TodayDate = convert (varchar(20),DATEPART(year, GETDATE()))+'-'+convert (varchar(20),DATEPART(month, GETDATE()))+'-'+convert (varchar(20),DATEPART(day, GETDATE()))

SELECT     dbo.tblDental.description, tempTableJoin.surname, tempTableJoin.firstname, tempTableJoin.staffID,tempTableJoin.validFrom,tempTableJoin.validTo,
tempTableJoin.competent,tempTableJoin.staffDentalID
FROM         dbo.tblDental LEFT OUTER JOIN


(select  staffDentalID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,DentalID,validfrom,validTo, competent from dbo.tblStaffDental  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffDental.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID ) as tempTableJoin ON dbo.tblDental.DentalID = tempTableJoin.DentalID
  --WHERE dbo.tblDental.ndeID=@nodeID
GO
/****** Object:  StoredProcedure [dbo].[spPersDel]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[spPersDel]
@recID int,
@DelOK int OUTPUT
as

-- has it got staff assigned to it
IF EXISTS (SELECT TOP 1 staffID from tblStaffPost WHERE tblStaffPost.staffID = @recID)    
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spOpTsDel]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE      PROCEDURE [dbo].[spOpTsDel]
@recID int,
@DelOK int OUTPUT
as

-- has it got staff assigned to it
IF EXISTS (SELECT TOP 1 catID from tblOpTask WHERE tblOpTask.statusID = @recID)    
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spOpTkUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create     PROCEDURE [dbo].[spOpTkUpdate]
@recID int,
@name varchar(50),
@location varchar (50),
@projo varchar (50),
@detcdr varchar (50),
@nomrol varchar (50),
@opord varchar (50),
@stdate varchar (50),
@endate varchar (50),
@oview varchar (50),
@opcat int,
@opstat int

as
--DECLARE @Start char(10)
--DECLARE @End char(10)
--SET @Start = (SELECT CONVERT (char(10), @stdate, 103))
--SET @End = (SELECT CONVERT (char(10), @endate, 103))

SET DATEFORMAT dmy 
UPDATE tblOpTask 
 set name = @name, location=@location, projo=@projo, detcdr=@detcdr,nomrole=@nomrol, oporder=@opord, 
            overview=@oview,startdate=@stdate,enddate=@endate, catID=@opcat,statusID=@opstat
  where optID=@RecID
GO
/****** Object:  StoredProcedure [dbo].[spOpTkInsert]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[spOpTkInsert]
@name varchar(50),
@location varchar (50),
@projo varchar (50),
@detcdr varchar (50),
@nomrol varchar (50),
@opord varchar (50),
@stdate varchar (50),
@endate varchar (50),
@oview varchar (50),
@opcat int,
@opstat int

as
DECLARE @Start char(10)
DECLARE @End char(10)

--SET @Start = (SELECT CONVERT (char(10), @stdate, 103))
--SET @End = (SELECT CONVERT (char(10), @endate, 103))

SET DATEFORMAT dmy 
insert tblOpTask (name, location, projo, detcdr,nomrole, oporder, overview,startdate,enddate, catID,statusID )
values (@name,@location,@projo,@detcdr,@nomrol,@opord,@oview,@stdate,@endate, @opcat, @opstat)
GO
/****** Object:  StoredProcedure [dbo].[spOpTkDetail]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[spOpTkDetail] 
  @recID INT
AS
select tblOpTask.optID,taskno, name, location, projo, detcdr,nomrole, oporder, overview,startdate,enddate, 
       catID, statusID, tblOpTaskCategory.description as category, tblTaskStatus.description as status 
   from tblOpTask
  inner join tblOpTaskCategory ON
     tblOpTask.catID = tblOpTaskCategory.otcID
  inner join tblTaskStatus ON
     tblOpTask.statusID = tblTaskStatus.otsID
   where tblOpTask.optID = @recID
GO
/****** Object:  StoredProcedure [dbo].[spOpTcDel]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE      PROCEDURE [dbo].[spOpTcDel]
@recID int,
@DelOK int OUTPUT
as

-- has it got staff assigned to it
IF EXISTS (SELECT TOP 1 catID from tblOpTask WHERE tblOpTask.catID = @recID)    
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spOpTaUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[spOpTaUpdate]
@recid int,
@action varchar(50),
@taskID int

as
DECLARE @currDate char(10)

SET @currdate = (SELECT CONVERT (char(10), getdate(), 103))
SET DATEFORMAT dmy 
update tblOpAction 
 set opaction=@action, taskID=@taskID, opadate=@currdate
   where tblOpAction.opaID = @recid
GO
/****** Object:  StoredProcedure [dbo].[spOpTaInsert]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spOpTaInsert]
@action varchar(50),
@taskID int

as
DECLARE @currDate char(10)

SET @currdate = (SELECT CONVERT (char(10), getdate(), 103))
SET DATEFORMAT dmy 
insert tblOpAction (opaction, taskID, opadate)
values (@action,@taskID, @currdate)
GO
/****** Object:  StoredProcedure [dbo].[spOpTaDetail]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spOpTaDetail] 
  @recID INT
AS
select tblOpAction.opaID,taskID,opaction, opadate, tblOpAction.documents, tblOpTask.name as name from tblOpAction
  inner join tblOpTask ON
     tblOpTask.optID = tblOpAction.taskID
   where tblOpAction.opaID = @recID
GO
/****** Object:  StoredProcedure [dbo].[spOOADaysUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spOOADaysUpdate]
@RecID int,
@ooadays int,
@ambdays int

as


UPDATE tblOOADays SET ooamaxdays=@ooadays,
                      amberdays=@ambdays 
   WHERE tblOOADays.ooaID=@RecID
GO
/****** Object:  StoredProcedure [dbo].[spOOADaysInsert]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spOOADaysInsert]
@nodeID INT,
@ooadays int, 
@ambdays int


AS

INSERT tblOOADays (ndeID, ooamaxdays, amberdays)
values (@nodeID, @ooadays, @ambdays)
GO
/****** Object:  StoredProcedure [dbo].[spNominalRoleList]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spNominalRoleList]
(
	@tmID	INT
)

AS

SET DATEFORMAT dmy

IF @tmID <> 0
	BEGIN
		SELECT distinct tblStaff.staffID, tblStaff.surname, tblStaff.firstname, tblRank.shortDesc AS rank, tblStaff.arrivaldate, tblStaff.pob, tblStaff.dob, 
                tblStaff.serviceno, tblStaff.notes, tblStaff.homephone, tblStaff.poc, tblStaff.welfarewishes, 
                tblStaff.mobileno, tblteam.description + ' - ' + tblPost.description AS post
		FROM tblStaff
		INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
		INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
		INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
		INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
		WHERE (tblPost.Ghost = 0) AND (tblStaff.active = 1) AND (tblTeam.teamID = @tmID) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate > GETDATE())
		ORDER BY tblStaff.surname
	END
ELSE
	BEGIN
		SELECT distinct tblStaff.staffID, tblStaff.surname, tblStaff.firstname, tblRank.shortDesc AS rank, tblStaff.arrivaldate, tblStaff.pob, tblStaff.dob, 
                tblStaff.serviceno, tblStaff.notes, tblStaff.homephone, tblStaff.poc, tblStaff.welfarewishes, 
                tblStaff.mobileno, tblteam.description + ' - ' + tblPost.description AS post
		FROM tblStaff
		INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
		INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
		INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
		INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
		WHERE (tblPost.Ghost = 0) AND (tblStaff.active = 1) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate > GETDATE())
		ORDER BY tblStaff.surname
	END
GO
/****** Object:  StoredProcedure [dbo].[spMSWUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMSWUpdate]
@MSWID int,
@MSWtype char,
@Description varchar (100),
@MSWValue int

as

update tblMSWeight
set MSWtype = @MSWtype,Description = @Description, MSWValue = @MSWValue
where MSWID=@MSWID
GO
/****** Object:  StoredProcedure [dbo].[spMSWInsert]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMSWInsert]
@nodeID INT,
@MSWtype CHAR,
@Description VARCHAR (100),
@MSWValue INT

AS

 INSERT tblMSWeight (ndeID, MSWtype,Description,MSWValue)
             VALUES (@nodeID,@MSWtype,@Description,@MSWValue)
GO
/****** Object:  StoredProcedure [dbo].[spMSUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMSUpdate]
(
	@MSID		INT,
	@Description	VARCHAR(100),
	@MSVPID		INT,
	@Amber		INT,
	@Exempt		INT,
	@Combat		INT,
	@Fear		INT
)

AS

SET NOCOUNT ON

BEGIN TRANSACTION
	BEGIN
		UPDATE tblMilitarySkills SET
		Description = @Description,
		vpID = @MSVPID,
		Amber = @Amber,
		Exempt = @Exempt,
		Combat = @Combat,
		Fear = @Fear
		WHERE MSID = @MSID
	END

IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END

COMMIT TRANSACTION

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spMSInsert]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMSInsert]
(
    @nodeID INT,
	@Description	VARCHAR(100),
	@MSVPID		INT,
	@Amber		INT,
	@Exempt		INT,
	@Combat 	BIT,
	@Fear 		BIT
)

AS

SET NOCOUNT ON

BEGIN TRANSACTION
	IF NOT EXISTS(SELECT Description FROM tblMilitarySkills WHERE ndeID=@nodeID AND Description = @Description )
		BEGIN
			INSERT INTO tblMilitarySkills
			(   ndeID,
				Description,
				vpID,
				Amber,
				Exempt,
				Combat,
				Fear
			)
			VALUES
			(   @nodeID,
				@Description,
				@MSVPID,
				@Amber,
				@Exempt,
				@Combat,
				@Fear
			)
		END

IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END

COMMIT TRANSACTION

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spMSDel]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE    PROCEDURE [dbo].[spMSDel]
@recID int,
@DelOK int OUTPUT
as

-- has it got staff assigned to it
IF EXISTS (SELECT TOP 1 staffID from tblStaffMilSkill WHERE tblStaffMilSkill.MSID = @recID)    
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spMSAvailable]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spMSAvailable]

@nodeID INT,
@StaffID INT

AS

 SELECT msID, [description], Exempt FROM tblMilitarySkills
	WHERE NOT EXISTS (SELECT msID FROM tblStaffMilSkill WHERE tblMilitarySkills.msID = tblStaffMilSkill.msID AND staffID =@StaffID)
	      AND tblMilitarySkills.ndeID=@nodeID
		ORDER BY tblMilitarySkills.[description]
GO
/****** Object:  StoredProcedure [dbo].[spMiSkillsDetails]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMiSkillsDetails]
@RecID int
as
		
SELECT     dbo.tblStaff.staffID,staffMSID, dbo.tblMilitarySkills.description, ValidFrom,ValidTo, competent
FROM         dbo.tblStaff INNER JOIN
dbo.tblStaffMilSkill ON dbo.tblStaff.staffID = dbo.tblStaffMilSkill.staffID INNER JOIN
dbo.tblMilitarySkills ON dbo.tblStaffMilSkill.MSID = dbo.tblMilitarySkills.MSID
where  dbo.tblStaff.staffID=@recid
order by description
GO
/****** Object:  StoredProcedure [dbo].[spMilitaryVacDetails]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMilitaryVacDetails]
@RecID int
as


		
		SELECT     dbo.tblStaff.staffID,staffMVID, dbo.tblMilitaryVacs.description, ValidFrom, competent
		FROM         dbo.tblStaff INNER JOIN
                dbo.tblStaffMVs ON dbo.tblStaff.staffID = dbo.tblStaffMVs.staffID INNER JOIN
                dbo.tblMilitaryVacs ON dbo.tblStaffMVs.MVID = dbo.tblMilitaryVacs.MVID
		where  dbo.tblStaff.staffID=@recid
		order by description
GO
/****** Object:  StoredProcedure [dbo].[spMilitaryskillWeightingDetail]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMilitaryskillWeightingDetail]
@RecID int
as
SELECT     mswID, mswtype, description, mswvalue
FROM         dbo.tblMSWeight where mswID = @RecID
GO
/****** Object:  StoredProcedure [dbo].[spMilitarySkillDetail]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMilitarySkillDetail]
(
	@RecID INT
)

AS

SELECT MSID, tblMilitarySkills.description AS MSDescription, tblValPeriod.vpID, tblValPeriod.description AS ValidityPeriod, Amber, Exempt, Combat, Fear
FROM tblMilitarySkills
INNER JOIN tblValPeriod ON tblMilitarySkills.vpID = tblValPeriod.vpID
WHERE MSID = @RecID
GO
/****** Object:  StoredProcedure [dbo].[spMESUpdate]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        PROCEDURE [dbo].[spMESUpdate]
@RecID int,
@Description varchar (50)


as

update tblMES
  set description = @description
   where tblMES.mesID = @recid
GO
/****** Object:  StoredProcedure [dbo].[spMESInsert]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[spMESInsert]
@nodeID INT,
@Description varchar (50)

AS

INSERT tblMES (ndeID, Description)
       VALUES (@nodeID, @Description)
GO
/****** Object:  StoredProcedure [dbo].[spMESDetail]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   PROCEDURE [dbo].[spMESDetail]
@recID int

AS


SELECT    dbo.tblMES.MESID, dbo.tblMES.description FROM dbo.tblMES WHERE MESId = @RecID

SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  StoredProcedure [dbo].[spMESDel]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  PROCEDURE [dbo].[spMESDel]
@recID int,
@DelOK int OUTPUT
AS

  
 
  IF EXISTS (SELECT TOP 1 staffID from tblStaff WHERE tblStaff.MESID = @recID )    
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'

-- SELECT dbo.tblMES.MESID, dbo.tblMES.description FROM dbo.tblMES WHERE MESId = @RecID

SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  StoredProcedure [dbo].[spManningReportMultiple2]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spManningReportMultiple2]
@hrcID				INT,
@QStatus			INT,
@QCount				INT,
@MSStatus			INT,
@MSCount			INT,
@VacStatus			INT,
@VacCount			INT,
@FitnessStatus			INT,
@fitnessCount			INT,
@DentalStatus			INT,
@dentalCount			INT,
@withWithout			INT,
@WHEREClause			VARCHAR(8000),
@qualification			VARCHAR(1000),
@milskill			VARCHAR(1000),
@vacs				VARCHAR(1000),
@fitness			VARCHAR(1000),
@dental				VARCHAR(1000),
@thisDate			VARCHAR(30),
@civi				INT,
@ENDDate			VARCHAR(30),
@Gender				INT

AS

SET DATEFORMAT dmy
DECLARE @rankID			INT
DECLARE @unit   		VARCHAR(25)

DECLARE @MyCounter		INT

SET @MyCounter = 0
DECLARE @Str			VARCHAR(8000)
DECLARE @searched		VARCHAR(8000)
declare @strDescriptions	VARCHAR(400)

SET @unit = (SELECT hrcname from tblHierarchy WHERE tblHierarchy.hrcID = @hrcID)

WITH tblChild AS
		(
		  SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
		  UNION ALL
		  SELECT tblHierarchy.hrcID, tblHierarchy.hrcName FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
		)
     SELECT hrcID, hrcname INTO #ttHRC FROM tblChild 
  

SET @Str = 'SELECT DISTINCT TOP 100 PERCENT #tthrc.hrcid, tblStaff.staffID, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblStaff.sex, tblStaff.lastOOA, tblStaff.arrivaldate,'  
SET @Str = @Str + 'tblStaff.postingduedate, tblStaff.dischargeDate, tblRank.shortDesc, #ttHRC.hrcname AS Team, tblMES.description AS MES '
SET @Str = @Str + 'FROM #ttHRC INNER JOIN tblPost ON tblPost.hrcID = #ttHRC.hrcID '
SET @Str = @Str + 'INNER JOIN tblStaffPost ON tblStaffPost.postID = tblPost.postID '
SET @Str = @Str + 'INNER JOIN tblStaff ON tblStaff.staffID=tblStaffPost.staffID '
SET @Str = @Str + 'INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID '
--SET @Str = @Str + 'INNER JOIN #tempunit ON tblPost.teamID = #tempunit.tmID '
SET @Str = @Str + 'LEFT OUTER JOIN tblMES ON tblMES.mesID = tblStaff.mesID '

IF @withWithout = 1
	BEGIN
		IF @QStatus = 0
			BEGIN
				/*WHILE @MyCounter <= @QCount
					BEGIN*/
						SET @Str = @Str + 'LEFT OUTER JOIN  (SELECT * FROM dbo.tblStaffQs) AS Q' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = Q' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						/*SET @MyCounter = @MyCounter + 1
					END*/
			END
	
		IF @MSStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @MSCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffMilSkill WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''' ) AS milSkill' + CONVERT(VARCHAR(3),@MyCounter ) + ' ON dbo.tblStaff.staffID = milSkill' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
	
		IF @VacStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @VacCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffMVs WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS MVs' + CONVERT(VARCHAR(3),@MyCounter ) + ' ON dbo.tblStaff.staffID = MVs' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID  '
						SET @MyCounter = @MyCounter + 1
					END
			END
	
		IF @FitnessStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @fitnessCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffFitness WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS fitness' +  CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = fitness' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
	
		IF @DentalStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @dentalCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffDental WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS dental' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = dental' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END

	        SET @Str = @Str + 'WHERE tblPost.Ghost = 0 '

		IF @civi = 0
			BEGIN
				SET @Str = @Str + 'AND tblRank.Weight <> 0'
			END
	
	        IF @Gender = '2'
			BEGIN
	        		SET @Str = @Str + ' AND dbo.tblStaff.sex =' + '''' + 'M' + '''' 
			END
	
		IF @Gender = '3'
			BEGIN
				SET @Str = @Str + ' AND dbo.tblStaff.sex =' + '''' + 'F' + '''' 
			END
	
		SET @Str = @Str + ' AND ((' + '''' + @thisDate + '''' + '>= tblStaffPost.startDate AND (' + '''' + @thisDate + '''' + '<= tblStaffPost.ENDdate OR tblStaffPost.ENDDate IS NULL)) OR (tblStaffPost.startDate IS NULL AND tblStaffPost.ENDDate IS NULL)) '
		SET @Str = @Str + @WHEREClause
	END
ELSE
	BEGIN
		SET @Str = @Str + ' WHERE NOT EXISTS ('
		
		SET @Str = @Str + 'SELECT DISTINCT TOP 100 PERCENT tblStaff.staffID, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblRank.shortDesc, #ttHRC.hrcname AS Team
		FROM dbo.tblStaff AS innertblStaff
		INNER JOIN dbo.tblRank ON dbo.tblStaff.rankID = dbo.tblRank.rankID
		INNER JOIN tblStaffPost ON dbo.tblStaff.staffID = tblStaffPost.staffID
		INNER JOIN tblPost ON tblPost.postId = tblStaffPost.PostID
		INNER JOIN #ttHRC ON tblPost.hrcID = #ttHRC.hrcID '
	
		IF @QStatus = 1	
			BEGIN
				/*WHILE @MyCounter < @QCount
					BEGIN*/
						SET @Str = @Str + 'LEFT OUTER JOIN  (SELECT * FROM dbo.tblStaffQs) AS Q' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = Q' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						/*SET @MyCounter = @MyCounter + 1
					END*/
			END
		
		IF @MSStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @MSCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffMilSkill WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS milSkill' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = milSkill' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
		
		IF @VacStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @VacCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffMVs WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS MVs' + CONVERT(VARCHAR(3),@MyCounter ) + ' ON dbo.tblStaff.staffID = MVs' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID  '
						SET @MyCounter = @MyCounter + 1
					END
			END
		
		IF @FitnessStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @fitnessCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffFitness WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS fitness' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = fitness' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
		
		IF @DentalStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @dentalCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffDental WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS dental' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = dental' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
			
		SET @Str = @Str + ' WHERE tblPost.Ghost = 0 AND tblstaff.staffID = innerTblStaff.StaffID '

		SET @Str = @Str + @WHEREClause

		SET @Str = @Str + ')'
	END

	IF @civi = 0
		BEGIN
			SET @Str = @Str + 'AND tblRank.Weight <> 0'
		END

	SET @Str = @Str + ' AND ((' + '''' + @thisDate + '''' + '>= tblStaffPost.startDate AND (' + '''' + @thisDate + '''' + '<= tblStaffPost.ENDdate OR tblStaffPost.ENDDate IS NULL)) OR (tblStaffPost.startDate IS NULL AND tblStaffPost.ENDDate IS NULL)) '
	SET @Str = @Str + 'ORDER BY #ttHRC.hrcID, surname'

	IF @qualification <> ''
		BEGIN
			SET @strDescriptions =  'SELECT QTypeID, description FROM tblQs WHERE qid IN (' + @qualification + ')'
			EXEC (@strDescriptions)
		END
	
	IF @milskill <> ''
		BEGIN
			SET @strDescriptions =  'SELECT description FROM tblMilitarySkills WHERE msID IN (' + @milskill  + ')'
			EXEC (@strDescriptions)
		END
	
	IF @vacs <> ''
		BEGIN
			SET @strDescriptions =  'SELECT description FROM tblMilitaryVacs WHERE mvID IN (' + @vacs  + ')'
			EXEC (@strDescriptions)
		END
	
	IF @fitness <> ''
		BEGIN
			SET @strDescriptions =  'SELECT description FROM tblFitness WHERE fitnessID IN (' + @fitness  + ')'
			EXEC (@strDescriptions)
		END
	
	IF @dental <> ''
		BEGIN
			SET @strDescriptions =  'SELECT description FROM tblDental WHERE dentalID IN (' + @dental  + ')'
			EXEC (@strDescriptions)
		END
	
EXEC(@Str)
--PRINT(@Str)

DROP TABLE #ttHRC
GO
/****** Object:  StoredProcedure [dbo].[spManningReportMultiple]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spManningReportMultiple]

@QStatus			INT,
@QCount				INT,
@MSStatus			INT,
@MSCount			INT,
@VacStatus			INT,
@VacCount			INT,
@FitnessStatus			INT,
@fitnessCount			INT,
@DentalStatus			INT,
@dentalCount			INT,
@withWithout			INT,
@WHEREClause			VARCHAR(8000),
@qualification			VARCHAR(1000),
@milskill			VARCHAR(1000),
@vacs				VARCHAR(1000),
@fitness			VARCHAR(1000),
@dental				VARCHAR(1000),
@teamID				INT,
@thisDate			VARCHAR(30),
@civi				INT,
@ENDDate			VARCHAR(30),
@Gender				INT

AS

SET DATEFORMAT dmy

DECLARE @fltID			INT
DECLARE @sqnID			INT
DECLARE @wingID			INT
DECLARE @groupID		INT
DECLARE @teamIN			INT
DECLARE @rankID			INT
DECLARE @unit   		VARCHAR(25)

DECLARE @MyCounter		INT

SET @MyCounter = 0
DECLARE @Str			VARCHAR(8000)
DECLARE @searched		VARCHAR(8000)
declare @strDescriptions	VARCHAR(400)

SET @teamIN = (SELECT teamIN from tblTeam WHERE tblTeam.teamID = @teamID)
SET @unit = (SELECT description from tblTeam WHERE tblTeam.teamID = @teamID)

-- temp table to hold list of units
CREATE TABLE #tempunit
(
	tmID			INT,
	tmIN			INT,
	tmDesc			VARCHAR(50)
)

INSERT INTO #tempunit
	SELECT teamID, teamIN, description
	FROM tblTeam 
	WHERE tblTeam.teamID = @teamID

-- we are looking at Group level down
IF @teamIN = 0
	BEGIN
		-- first get the GroupID - we need it later
		SET @groupID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @teamID)

		-- now get all the Wings in the Group
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblTeam ON tblTeam.parentID = tblWing.wingID AND tblTeam.teamIN = 1
			WHERE tblWing.grpID = @groupID

		-- now get all the Squadrons in the wing
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
			INNER JOIN tblTeam ON tblTeam.parentID = tblSquadron.sqnID AND tblTeam.teamIN = 2
			WHERE tblWing.grpID = @groupID

		-- now get all flight teams
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID
			INNER JOIN tblTeam ON tblTeam.parentID = tblFlight.fltID AND tblTeam.teamIN = 3
			WHERE tblWing.grpID = @groupID

		-- Now the teams in the flights
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID                  
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
			WHERE tblWing.grpID = @groupID AND tblteam.teamin = 4

		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID                  
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE tblWing.grpID = @groupID AND tblteam.teamin = 5
	END

-- we are looking at Wing level down
IF @teamIN = 1
	BEGIN
		-- first get the WingID - we need it later
		SET @wingID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @teamID)

		-- now get all the Squadrons in the wing
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblSquadron
			INNER JOIN tblTeam ON tblTeam.parentID = tblSquadron.sqnID AND tblTeam.teamIN = 2 
			WHERE tblSquadron.wingID = @wingID

		-- now get all flight teams
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblSquadron
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID                  
			INNER JOIN tblTeam ON tblTeam.parentID = tblFlight.fltID AND tblTeam.teamIN = 3
			WHERE tblSquadron.wingID = @wingID

		-- Now the teams in the flights
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblSquadron
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
			WHERE tblSquadron.wingID = @wingID AND tblteam.teamin = 4

		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblSquadron
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE tblSquadron.wingID = @wingID AND tblteam.teamin = 5
	END

-- we are looking at Sqn level down
IF @teamIN = 2
	BEGIN
		-- first get the sqnID - we need it later
		SET @sqnID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @teamID)

		-- first get all flight teams
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam ON tblTeam.parentID = tblFlight.fltID AND tblTeam.teamIN = 3
			WHERE tblFlight.sqnID = @sqnID

		-- Now the teams in the flight
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
			WHERE tblflight.sqnid=@sqnID AND tblteam.teamin = 4

		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE tblflight.sqnid=@sqnID AND tblteam.teamin = 5
	END

-- we are looking at Flight level down
IF @teamIN = 3
	BEGIN
		-- first get the flightID - we need it later
		SET @fltID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @teamID)

		-- Now the teams in the flight
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
			WHERE tblflight.fltid=@fltID AND tblteam.teamin = 4

		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE tblflight.fltid=@fltID AND tblteam.teamin = 5
	END

-- we are looking at Team level down
IF @teamIN = 4
	BEGIN
		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblTeam AS T2
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE T2.teamID = @teamID AND tblteam.teamin = 5
	END


SET @Str = 'SELECT DISTINCT TOP 100 PERCENT tblStaff.staffID, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblStaff.sex, tblStaff.lastOOA, tblStaff.arrivaldate,'  
SET @Str = @Str + 'tblStaff.postingduedate, tblStaff.dischargeDate, tblRank.shortDesc, #tempunit.tmDesc AS Team, tblMES.description AS MES '
SET @Str = @Str + 'FROM dbo.tblStaff INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID '
SET @Str = @Str + 'INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID '
SET @Str = @Str + 'INNER JOIN tblPost ON tblPost.postId = tblStaffPost.PostID '
SET @Str = @Str + 'INNER JOIN #tempunit ON tblPost.teamID = #tempunit.tmID '
SET @Str = @Str + 'LEFT OUTER JOIN tblMES ON tblMES.mesID = tblStaff.mesID '

IF @withWithout = 1
	BEGIN
		IF @QStatus = 0
			BEGIN
				/*WHILE @MyCounter <= @QCount
					BEGIN*/
						SET @Str = @Str + 'LEFT OUTER JOIN  (SELECT * FROM dbo.tblStaffQs) AS Q' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = Q' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						/*SET @MyCounter = @MyCounter + 1
					END*/
			END
	
		IF @MSStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @MSCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffMilSkill WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''' ) AS milSkill' + CONVERT(VARCHAR(3),@MyCounter ) + ' ON dbo.tblStaff.staffID = milSkill' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
	
		IF @VacStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @VacCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffMVs WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS MVs' + CONVERT(VARCHAR(3),@MyCounter ) + ' ON dbo.tblStaff.staffID = MVs' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID  '
						SET @MyCounter = @MyCounter + 1
					END
			END
	
		IF @FitnessStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @fitnessCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffFitness WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS fitness' +  CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = fitness' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
	
		IF @DentalStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @dentalCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffDental WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS dental' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = dental' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END

	        SET @Str = @Str + 'WHERE tblPost.Ghost = 0 '

		IF @civi = 0
			BEGIN
				SET @Str = @Str + 'AND tblRank.Weight <> 0'
			END
	
	        IF @Gender = '2'
			BEGIN
	        		SET @Str = @Str + ' AND dbo.tblStaff.sex =' + '''' + 'M' + '''' 
			END
	
		IF @Gender = '3'
			BEGIN
				SET @Str = @Str + ' AND dbo.tblStaff.sex =' + '''' + 'F' + '''' 
			END
	
		SET @Str = @Str + ' AND ((' + '''' + @thisDate + '''' + '>= tblStaffPost.startDate AND (' + '''' + @thisDate + '''' + '<= tblStaffPost.ENDdate OR tblStaffPost.ENDDate IS NULL)) OR (tblStaffPost.startDate IS NULL AND tblStaffPost.ENDDate IS NULL)) '
		SET @Str = @Str + @WHEREClause
	END
ELSE
	BEGIN
		SET @Str = @Str + ' WHERE NOT EXISTS ('
		
		SET @Str = @Str + 'SELECT DISTINCT TOP 100 PERCENT tblStaff.staffID, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblRank.shortDesc, #tempunit.tmDesc AS Team
		FROM dbo.tblStaff AS innertblStaff
		INNER JOIN dbo.tblRank ON dbo.tblStaff.rankID = dbo.tblRank.rankID
		INNER JOIN tblStaffPost ON dbo.tblStaff.staffID = tblStaffPost.staffID
		INNER JOIN tblPost ON tblPost.postId = tblStaffPost.PostID
		INNER JOIN #tempunit ON tblPost.teamID = #tempunit.tmID '
	
		IF @QStatus = 1	
			BEGIN
				/*WHILE @MyCounter < @QCount
					BEGIN*/
						SET @Str = @Str + 'LEFT OUTER JOIN  (SELECT * FROM dbo.tblStaffQs) AS Q' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = Q' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						/*SET @MyCounter = @MyCounter + 1
					END*/
			END
		
		IF @MSStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @MSCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffMilSkill WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS milSkill' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = milSkill' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
		
		IF @VacStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @VacCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffMVs WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS MVs' + CONVERT(VARCHAR(3),@MyCounter ) + ' ON dbo.tblStaff.staffID = MVs' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID  '
						SET @MyCounter = @MyCounter + 1
					END
			END
		
		IF @FitnessStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @fitnessCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffFitness WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS fitness' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = fitness' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
		
		IF @DentalStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @dentalCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffDental WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS dental' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = dental' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
			
		SET @Str = @Str + ' WHERE tblPost.Ghost = 0 AND tblstaff.staffID = innerTblStaff.StaffID '

		SET @Str = @Str + @WHEREClause

		SET @Str = @Str + ')'
	END

	IF @civi = 0
		BEGIN
			SET @Str = @Str + 'AND tblRank.Weight <> 0'
		END

	SET @Str = @Str + ' AND ((' + '''' + @thisDate + '''' + '>= tblStaffPost.startDate AND (' + '''' + @thisDate + '''' + '<= tblStaffPost.ENDdate OR tblStaffPost.ENDDate IS NULL)) OR (tblStaffPost.startDate IS NULL AND tblStaffPost.ENDDate IS NULL)) '
	SET @Str = @Str + 'ORDER BY Team, surname'

	IF @qualification <> ''
		BEGIN
			SET @strDescriptions =  'SELECT QTypeID, description FROM tblQs WHERE qid IN (' + @qualification + ')'
			EXEC (@strDescriptions)
		END
	
	IF @milskill <> ''
		BEGIN
			SET @strDescriptions =  'SELECT description FROM tblMilitarySkills WHERE msID IN (' + @milskill  + ')'
			EXEC (@strDescriptions)
		END
	
	IF @vacs <> ''
		BEGIN
			SET @strDescriptions =  'SELECT description FROM tblMilitaryVacs WHERE mvID IN (' + @vacs  + ')'
			EXEC (@strDescriptions)
		END
	
	IF @fitness <> ''
		BEGIN
			SET @strDescriptions =  'SELECT description FROM tblFitness WHERE fitnessID IN (' + @fitness  + ')'
			EXEC (@strDescriptions)
		END
	
	IF @dental <> ''
		BEGIN
			SET @strDescriptions =  'SELECT description FROM tblDental WHERE dentalID IN (' + @dental  + ')'
			EXEC (@strDescriptions)
		END
	
EXEC(@Str)
--PRINT(@Str)

DROP TABLE #tempunit
GO
/****** Object:  StoredProcedure [dbo].[spManningReport]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spManningReport]

@QStatus int,
@QType int,
@MSStatus int,
@VacStatus int,
@FitnessStatus int,
@DentalStatus int,
@RecordID int,
@whereClause varchar(400)


AS

DECLARE @str varchar(4000)
DECLARE @searched varchar (1000)

set @str = 'SELECT distinct TOP 100 PERCENT dbo.tblStaff.staffID, dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.serviceno, dbo.tblRank.shortDesc FROM dbo.tblStaff INNER JOIN dbo.tblRank ON dbo.tblStaff.rankID = dbo.tblRank.rankID '

if @QStatus=1

begin
	set @str=@str+' left outer join (select * from dbo.tblStaffQs where typeid=1) as generalQ ON dbo.tblStaff.staffID = generalQ.StaffID '

	set @str=@str+' left outer join (select * from dbo.tblStaffQs where typeid=2) as technicalQ ON dbo.tblStaff.staffID = technicalQ.StaffID '

	set @str=@str+' left outer join (select * from dbo.tblStaffQs where typeid=3) as operationalQ ON dbo.tblStaff.staffID = operationalQ.StaffID '

	set @str=@str+' left outer join (select * from dbo.tblStaffQs where typeid=4) as driverQ ON dbo.tblStaff.staffID = driverQ.StaffID '

end

if @MSStatus=1

begin
	set @str=@str+' left outer join dbo.tblStaffMilSkill ON dbo.tblStaff.staffID = dbo.tblStaffMilSkill.StaffID '
end

if @VacStatus=1

begin
	set @str=@str+' left outer join dbo.tblStaffMVs ON dbo.tblStaff.staffID = dbo.tblStaffMVs.StaffID  '
end

if @FitnessStatus=1

begin
	set @str=@str+' left outer join dbo.tblStaffFitness ON dbo.tblStaff.staffID = dbo.tblStaffFitness.StaffID '
end

if @DentalStatus=1

begin
	set @str=@str+' left outer join dbo.tblStaffDental ON dbo.tblStaff.staffID = dbo.tblStaffDental.StaffID '
end

set @str=@str+' where 1=1 '

set @str=@str+@whereClause

set @str=@str+ ' order by surname'
if @QStatus = 1

begin
	if @Qtype=1
	begin
		select description from tblGeneralQs where genQid = @recordID
	end
	if @Qtype=2
	begin
		select description from tblTechQs where tqID = @recordID
	end
	if @Qtype=3
	begin
		select description from tblOpsQs where opQid = @recordID
	end
	if @Qtype=4
	begin
		select description from tblDriverQs where drvQid = @recordID
	end

end

if @MSStatus = 1

begin

	select description from tblMilitarySkills where msid = @recordID
end
if @VacStatus = 1

begin

	select description from tblMilitaryVacs where mvid = @recordID
end
if @FitnessStatus = 1

begin

	select description from tblFitness where fitnessid = @recordID
end
if @DentalStatus = 1

begin

	select description from tblDental where dentalid = @recordID
end

	
EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spLogOn]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLogOn]

@ServiceNo VARCHAR(20),
@password VARCHAR(20),
@StaffID INT OUT,
@node INT OUT,
@Status INT OUT,
@Active INT OUT,
@CMSAdmin INT OUT,
@Admin INT OUT,
@hrcID INT OUT,
--@HQTask INT OUT,
--@teamID	INT OUT,
--@teamIDStr VARCHAR(200) OUT,
@pswdExp INT OUT,
@error INT OUT

AS

--DECLARE @teamIN INT
--DECLARE @mgr INT
--SET @teamIN = 0
--SET @Status  = 0
--SET @SqnMgr  = 0 
SET @error = 0
SET @hrcID=0


IF EXISTS (SELECT staffID FROM tblStaff WHERE tblStaff.serviceNo = @serviceNo)
BEGIN
	
	SELECT @StaffID = staffID, @CMSAdmin=CMSAdministrator, @Admin = administrator, @Active = active, @node = ndeID FROM tblStaff WHERE tblStaff.serviceNo = @serviceNo
	
	-- work out how many days left until the password expires.
	SET @pswdExp =  datediff(dd,getDate(),(SELECT expires FROM tblPassword WHERE staffID = @StaffID))

	IF (SELECT substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', @password)),3,32)) = (SELECT pswd FROM tblPassword WHERE staffID = @StaffID)
	BEGIN
		/*Check if the user is part of HQTask (Redundant now but left in to prevent breakage)*/
		--EXEC spCheckHQTask @staffID, @HQTask OUTPUT
		
		/*Set which Team the user belongs  and whether or not they are a manager*/
		--SELECT @mgr = tblPost.manager, @teamID = tblPost.teamID, @hrcID=hrcID, @teamIN = tblTeam.teamIN 
		SELECT @Status = tblPost.manager, @hrcID=hrcID
			FROM tblStaffPost 
			   INNER JOIN tblPost ON tblPost.postID = tblStaffPost.postID 
			   --INNER JOIN tblTeam ON tblTeam.teamID=tblPost.teamID
			   WHERE tblStaffPost.staffid = @staffID AND 
			         startdate < getdate() AND 
			         (enddate is NULL OR enddate > getdate()) 
			        -- AND  tblPost.manager = '1'
			
	    -- Now get the Hierarchy element his individual belongs to
	   
		/* Work out the teamID's for the tree view to fully expand */
		/**
		DECLARE @teamINLoop INT
		DECLARE @teamIDLoop INT
		SET @teamINLoop = (SELECT Teamin FROM tblTeamHierarchy WHERE teamID = @teamID)
		SET @teamIDLoop = @teamID
		SET @teamIDStr = ','+CAST(@teamID AS VARCHAR(20))
		
		WHILE @teamINLoop > 1 
			BEGIN
				SET @teamINLoop = (SELECT Teamin FROM tblTeamHierarchy WHERE teamID = @teamIDLoop)
				SET @teamIDLoop = (SELECT parentID FROM tblTeamHierarchy WHERE teamID = @teamIDLoop)
				SET @teamIDStr =  ','+CAST(@teamIDLoop AS VARCHAR(20))+@teamIDStr
			END
		
		SET @teamIDStr = SUBSTRING(@teamIDStr,2,LEN(@teamIDStr))
	
			
		IF @mgr = 1
		BEGIN
			SET @Status = 1				
			IF @teamIN < 3 
            BEGIN
              SET @SqnMgr = 1
            END 
		END
			**/
		/* Add successful login to the Audit log */
		IF EXISTS (SELECT dbo.tblAudit.audID FROM dbo.tblAudit WHERE dbo.tblAudit.staffID = @staffID)
        BEGIN
            UPDATE dbo.tblAudit 
            SET dbo.tblAudit.staffID = @staffID, dbo.tblAudit.logOn = getDate(), dbo.tblAudit.logOff=NULL
            WHERE dbo.tblAudit.staffID = @staffID
        END
        ELSE
        BEGIN
            INSERT dbo.tblAudit (staffid,logOn)
            VALUES (@staffID, getDate())
        END
		
		--IF (SELECT substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', @password)),3,32)) <> (SELECT dPswd FROM tblPassword WHERE staffID = @StaffID)
		IF ((SELECT substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', @password)),3,32)) <> (SELECT dPswd FROM tblPassword WHERE staffID = @StaffID))
		     OR (SELECT dPswd FROM tblPassword WHERE staffID = @StaffID) IS NULL
		BEGIN
			IF (SELECT expires FROM tblPassword WHERE staffID = @StaffID) > getDate()
			BEGIN	
				
				IF @pswdExp < 6 	
				BEGIN
					SET @error = 4 /* Password will expire within 5 days*/
				END
			END
			ELSE
			BEGIN
				SET @error = 3 /* Password has expired*/
			END	
		END
		ELSE
		BEGIN
			SET @error = 2 /* Default Password - change password page*/
		END
	END
	ELSE
	BEGIN
		SET @error = 1 /* Password Not Matching */
	END
END
ELSE
BEGIN
	SET @error = 1 /* Role not matching*/
END
--print (@error)
GO
/****** Object:  StoredProcedure [dbo].[spLogOff]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- This should update the audit record with the log-off details
-- NB we will update A record for this person that is still open - but it might
-- not be THE record if they closed IE and didn't log off

CREATE  PROCEDURE [dbo].[spLogOff] 
  @StaffID   INT
    AS 

    UPDATE dbo.tblAudit
        SET dbo.tblAudit.logOff=getdate()
          WHERE dbo.tblAudit.staffID=@staffID


/*******************
DECLARE @audID INT

DECLARE aud CURSOR SCROLL FOR
  
SELECT tblAudit.audID 
    FROM tblAudit
    WHERE tblAudit.staffID = @staffID AND
          tblAudit.logOn <= getdate() AND
          tblAudit.logOff IS NULL  
                

OPEN aud

-- get the last open audit - which should be last log-on
FETCH LAST FROM aud INTO @audID

-- got the audit record so update it
IF @@FETCH_STATUS = 0
 BEGIN
     UPDATE dbo.tblAudit
        SET dbo.tblAudit.logOff=getdate()
          WHERE dbo.tblAudit.audID=@audID
 END
  
CLOSE aud
DEALLOCATE aud

****************/
GO
/****** Object:  StoredProcedure [dbo].[spListWings]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE      PROCEDURE [dbo].[spListWings] AS
select tblWing.wingID, tblWing.description, tblGroup.description grp from tblWing
  inner join tblGroup ON
     tblGroup.grpID = tblWing.grpID
GO
/****** Object:  StoredProcedure [dbo].[spListTrades]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE     PROCEDURE [dbo].[spListTrades] 
 @nodeID INT
AS
select tblTrade.tradeID, tblTrade.description, tblTradeGroup.tradegroup 
      from tblTrade
       left outer join tblTradeGroup ON tblTradeGroup.tradegroupID = tblTrade.tradegroupID
        WHERE tblTrade.ndeID=@nodeID
        order by tblTrade.description
GO
/****** Object:  StoredProcedure [dbo].[spListTradeGroup]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE     PROCEDURE [dbo].[spListTradeGroup] 
  @nodeID INT
AS
  SELECT tradegroupID, tradegroup, description 
    FROM tblTradeGroup WHERE ndeID=@nodeID
GO
/****** Object:  StoredProcedure [dbo].[spListTeamTasks]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spListTeamTasks]
(
	@teamID		INT,
	@thisDate	VARCHAR(16)
)

AS

DECLARE @startofMonth VARCHAR(16)

SET DATEFORMAT dmy

SET @startofMonth = right(@thisDate,8)
SET @startofMonth='01 ' + @startofMonth

BEGIN
	SELECT DISTINCT tbl_TaskUnit.taskUnitID, tbl_TaskUnit.TaskID, tbl_Task.Description
	FROM tbl_TaskUnit
	INNER JOIN tbl_Task ON tbl_TaskUnit.TaskID = tbl_Task.TaskID
	WHERE (dbo.tbl_TaskUnit.teamID = @teamID) AND (CONVERT(DATETIME, @startofMonth) <= CONVERT(DATETIME, tbl_TaskUnit.endDate))
END
GO
/****** Object:  StoredProcedure [dbo].[spListOpTasks]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[spListOpTasks] AS
select tblOpTask.optID,taskno, name, location, startdate, tblOpTaskCategory.description as category from tblOpTask
  inner join tblOpTaskCategory ON
     tblOpTask.catID = tblOpTaskCategory.otcID
GO
/****** Object:  StoredProcedure [dbo].[spListOpActions]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spListOpActions] AS
select tblOpAction.opaID,taskID,opaction, tblOpTask.name as name from tblOpAction
  inner join tblOpTask ON
     tblOpTask.optID = tblOpAction.taskID
GO
/****** Object:  StoredProcedure [dbo].[spListMilitaryVacs]    Script Date: 04/06/2016 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListMilitaryVacs]
   @ndeID INT
AS

SELECT dbo.tblMilitaryVacs.mvID, dbo.tblMilitaryVacs.description, dbo.tblMilitaryVacs.mvrequired, dbo.tblValPeriod.description AS ValidityPeriod, Combat
   FROM dbo.tblMilitaryVacs 
     INNER JOIN dbo.tblValPeriod ON dbo.tblMilitaryVacs.vpID = dbo.tblValPeriod.vpID
     --WHERE tblMilitaryVacs.ndeID=@ndeID
GO
/****** Object:  StoredProcedure [dbo].[spListMilitaryskillsWeighting]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListMilitaryskillsWeighting] 
@nodeID INT
AS

  SELECT mswID, mswtype, description, mswvalue
    FROM dbo.tblMSWeight
       WHERE dbo.tblMSWeight.ndeID=@nodeID
GO
/****** Object:  StoredProcedure [dbo].[spListMilitaryskills]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListMilitaryskills]
  @ndeID INT
AS

SELECT MSID, tblMilitarySkills.description AS MSDescription, tblMilitarySkills.vpID, tblValPeriod.description AS ValidityPeriod, Amber, Exempt, Combat, Fear
FROM tblMilitarySkills
  INNER JOIN tblValPeriod ON tblMilitarySkills.vpID = tblValPeriod.vpID
  WHERE tblMilitarySkills.ndeID=@ndeID
GO
/****** Object:  StoredProcedure [dbo].[spListMES]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spListMES] 
 @nodeID INT
AS
SELECT MESID,dbo.tblMES.description 
    FROM dbo.tblMES
      WHERE ndeID=@nodeID
GO
/****** Object:  StoredProcedure [dbo].[spListHierarchyDropDown]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListHierarchyDropDown] 
  @ndeID INT
AS
  SELECT hrcID, hrcname, hrclevel, hrcparentID
   FROM tblHierarchy WHERE ndeID=@ndeID
GO
/****** Object:  StoredProcedure [dbo].[spListFlights]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE       PROCEDURE [dbo].[spListFlights] AS
select tblFlight.fltID, tblFlight.description, tblSquadron.description sqn from tblFlight
  inner join tblSquadron ON
     tblSquadron.sqnID = tblFlight.sqnID
          order by sqn, tblFlight.description
GO
/****** Object:  StoredProcedure [dbo].[spListFitness]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListFitness]
  @ndeID INT
AS

SELECT fitnessID, dbo.tblFitness.description, dbo.tblValPeriod.description AS ValidityPeriod, Combat
   FROM dbo.tblFitness 
     INNER JOIN dbo.tblValPeriod ON dbo.tblFitness.vpID = dbo.tblValPeriod.vpID
    -- WHERE tblFitness.ndeID=@ndeID
GO
/****** Object:  StoredProcedure [dbo].[spListDetailsForCategory]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spListDetailsForCategory]
@CategoryID int
as




if @CategoryID > 1 and @CategoryID <> 8
	Begin
		Select positionId as DetailID,Description from tblPosition
		order by description
	End
Else
	Begin
		if @CategoryID =1
			Select EquipmentID as DetailID,Description from tblEquipmentTemp
			order by description
		Else
			Begin
				Select genQID as DetailID,Description from tblGeneralQs
				order by description
			End
	End
GO
/****** Object:  StoredProcedure [dbo].[spListStaff]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spListStaff] AS
select tblStaff.staffID, tblStaff.serviceno, tblStaff.firstname,tblStaff.surname, tblRank.shortdesc rank from tblStaff
  inner join tblRank ON
     tblRank.rankID = tblStaff.rankID
         ORDER BY tblStaff.surname
GO
/****** Object:  StoredProcedure [dbo].[spListSSC]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[spListSSC] 
  @nodeID INT
AS
  SELECT  tblSSC.sscID, tblSSC.description, tblSSC.ssCode,tblSSC.ssType   
     FROM  tblSSC
       WHERE tblSSC.ndeID=@nodeID
GO
/****** Object:  StoredProcedure [dbo].[spListSquadrons]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create     PROCEDURE [dbo].[spListSquadrons] AS
select tblSquadron.SqnID, tblSquadron.description, tblwing.description wing from tblSquadron
  inner join tblwing ON
     tblwing.wingID = tblSquadron.wingID
GO
/****** Object:  StoredProcedure [dbo].[spListRanks2]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[spListRanks2] AS
  select * from tblRank 
    order by weight desc
GO
/****** Object:  StoredProcedure [dbo].[spListRanks]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListRanks]
  @nodeID INT
AS

 SELECT * FROM tblRank 
    WHERE tblRank.ndeID=@nodeID
        ORDER BY weight desc
GO
/****** Object:  StoredProcedure [dbo].[spListQTypes]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListQTypes]
  @ndeID INT
AS

SELECT QTypeID, Description AS Type, Auth
  FROM tblQTypes WHERE ndeID=@ndeID
GO
/****** Object:  StoredProcedure [dbo].[spListQs]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spListQs] 
  @ndeID INT

AS

SELECT QID, description, QTypeID AS TypeID 
   FROM tblQs WHERE ndeID=@ndeID
   ORDER BY description

--select * from vwQualificationList
--order by description
GO
/****** Object:  StoredProcedure [dbo].[spListPosts2]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListPosts2]

AS

SELECT DISTINCT tblPost.description
FROM tblPost
WHERE tblPost.Ghost = 0
ORDER BY tblPost.description ASC
GO
/****** Object:  StoredProcedure [dbo].[spListPosts]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     procedure [dbo].[spListPosts]
as
  SELECT    distinct  dbo.tblPost.postID, dbo.tblPost.assignno, dbo.tblPost.description, dbo.tblPost.positionDesc as position,
             dbo.tblTeam.description AS team, dbo.tblStaff.surname + ' ' + dbo.tblStaff.firstname as postholder
    FROM         dbo.tblPost
      LEFT OUTER JOIN dbo.tblTeam ON dbo.tblTeam.teamID = dbo.tblPost.teamID
      -- Ron 190608  - so we only show current post holder
      LEFT OUTER JOIN dbo.tblStaffPost on 
             (dbo.tblStaffPost.postID = dbo.tblPost.postID AND
                dbo.tblStaffPost.endDate IS NULL)  
      LEFT OUTER JOIN dbo.tblStaff on dbo.tblStaff.staffID = dbo.tblStaffPost.staffID 
         -- LEFT OUTER JOIN dbo.tblStaff on dbo.tblStaff.postID = dbo.tblPost.postID
      -- Ron end
             order by dbo.tblPost.description
/*
SELECT     dbo.tblPost.postID, dbo.tblPost.assignno, dbo.tblPost.description, dbo.tblPost.teamID, dbo.tblTeam.description AS TeamDescription, 
                      dbo.tblPost.positionID, dbo.tblPosition.description AS PositionDescription, dbo.tblPost.rankID, dbo.tblRank.shortDesc AS RankShortDescription, 
                      dbo.tblPost.tradeID, dbo.tblTrade.description AS TradeDescription, dbo.tblPost.RWID, 
                      dbo.tblRankWeight.description AS RankWeightDescription
FROM         dbo.tblPost INNER JOIN
                      dbo.tblTeam ON dbo.tblPost.teamID = dbo.tblTeam.teamID INNER JOIN
                      dbo.tblPosition ON dbo.tblPost.positionID = dbo.tblPosition.positionID INNER JOIN
                      dbo.tblRank ON dbo.tblPost.rankID = dbo.tblRank.rankID INNER JOIN
                      dbo.tblTrade ON dbo.tblPost.tradeID = dbo.tblTrade.tradeID INNER JOIN
                      dbo.tblRankWeight ON dbo.tblPost.RWID = dbo.tblRankWeight.rwID

*/
GO
/****** Object:  StoredProcedure [dbo].[spListTeamPosts]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE     PROCEDURE [dbo].[spListTeamPosts] 
@recID INT
AS

  SELECT    distinct  dbo.tblPost.postID, dbo.tblPost.assignno, dbo.tblPost.description, dbo.tblPost.positionDesc as position,
             dbo.tblTeam.description AS team, dbo.tblStaff.surname + ' ' + dbo.tblStaff.firstname as postholder,dbo.tblPost.manager
  FROM         dbo.tblPost
   LEFT OUTER JOIN dbo.tblTeam ON dbo.tblTeam.teamID = dbo.tblPost.teamID
   LEFT OUTER JOIN dbo.tblStaff on dbo.tblStaff.postID = dbo.tblPost.postID
where tblPost.teamID = @recID
GO
/****** Object:  StoredProcedure [dbo].[spListTaskTypesForTasking]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spListTaskTypesForTasking]

as
/** Ron 25/07/08 - this doesnt appear to be used - so use it now
    for getting list of tasktypes for tasking but only if they have Tasks attached
    that do not affect Harmony Status ie: ooa=0

select * from tblTaskType where Active=1 and ttid not in (12,13,14,15,16,21,24,26)
order by [section],[order] ,description
**/
select ttID, tblTaskTYpe.description, withlist,active,[section],[order] 
from tblTaskType
  where exists(select taskID from tbl_task 
                where tbl_task.ttID = tbltasktype.ttID AND
                      tbl_task.ooa=0)   
   and Active=1
     order by [section],[order] ,tblTaskTYpe.description
GO
/****** Object:  StoredProcedure [dbo].[spListTaskTypes]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListTaskTypes]

  @nodeID INT
AS

 SELECT ttID, [description], taskcolor FROM tblTaskType 
   WHERE ndeID=@nodeID AND Active=1 
    ORDER BY [section],[order] ,tblTaskTYpe.description
GO
/****** Object:  StoredProcedure [dbo].[spListTasks]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spListTasks] AS
select tbl_TaskCategory.taskCategoryID, tbl_TaskCategory.description, tblTaskType.description type from tbl_TaskCategory
  inner join tblTaskType ON
     tbl_TaskCategory.taskTypeID = tblTaskType.ttID
where tblTaskType.active=1
order by ttID
GO
/****** Object:  StoredProcedure [dbo].[spListTaskCategoriesByType]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        PROCEDURE [dbo].[spListTaskCategoriesByType]
@taskTypeID int
as

select * from tbl_TaskCategory where taskTypeID=@taskTypeID
order by description
GO
/****** Object:  StoredProcedure [dbo].[spPeRsFitnessObtained]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[spPeRsFitnessObtained]
@nodeID INT,
@staffID INT
AS

SELECT     dbo.tblFitness.description, tempTableJoin.surname, tempTableJoin.firstname, tempTableJoin.staffID,tempTableJoin.validFrom,tempTableJoin.validTo,
tempTableJoin.competent,tempTableJoin.staffFitnessID
FROM         dbo.tblfitness LEFT OUTER JOIN


(select  staffFitnessID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,fitnessID,validfrom,validTo, competent from dbo.tblStaffFitness  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffFitness.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID) as tempTableJoin ON dbo.tblFitness.fitnessID = tempTableJoin.fitnessID
  --WHERE tblFitness.ndeID=@nodeID
GO
/****** Object:  StoredProcedure [dbo].[spPeRsDetailSummary]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPeRsDetailSummary]
(
	@RecID INT,
	@thisdate varchar(20)
)

AS

SET DATEFORMAT dmy

SELECT tblStaff.staffID, tblStaff.serviceno, tblStaff.firstname, tblStaff.surname, tblStaff.knownas, tblRank.shortDesc AS rank, tblTrade.description AS trade, tblTrade.tradeID, tempJoinTable.team, tempJoinTable.post, tempJoinTable.PostID, tempJoinTable.startDate, tempJoinTable.endDate, remedial, exempt, expiryDate
FROM tblStaff
INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
INNER JOIN tblTrade ON tblStaff.tradeID = tblTrade.tradeID
LEFT OUTER JOIN (SELECT tblStaffPost.staffpostID, tblStaffPost.staffID AS StaffID, tblTeam.description AS team, tblPost.description AS post, tblStaffPost.PostID, assignno, tblStaffPost.startDate, tblStaffPost.endDate
FROM tblStaffPost
INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
WHERE (@thisdate >= startDate AND @thisdate <= endDate) OR (@thisdate >= startDate AND endDate IS NULL)) AS tempJoinTable ON tblStaff.staffID = tempJoinTable.StaffID
WHERE tblStaff.staffid = @RecID
ORDER BY startDate DESC
GO
/****** Object:  StoredProcedure [dbo].[spPersDetailByStaffID]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPersDetailByStaffID]
-- @serviceNo varChar(16)
@staffID INT
as

--select * from tblStaff where serviceNo=@serviceNo
SELECT * FROM tblStaff WHERE staffID=@staffID
GO
/****** Object:  StoredProcedure [dbo].[spPersDetailByServiceNo]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPersDetailByServiceNo]
@serviceNo varChar(16)
as

select * from tblStaff where serviceNo=@serviceNo
GO
/****** Object:  StoredProcedure [dbo].[spPeRsDetail]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spPeRsDetail] 

@recID INT

AS

SELECT tblStaff.staffID, tblPost.hrcID, tblStaff.serviceno, tblStaff.firstname,tblStaff.surname,knownas, 
       tblRank.shortdesc rank,sex,dob,tblTrade.description trade, homephone, mobileno,
       workPhone,arrivaldate,postingduedate,lastOOA,dischargeDate, pob,passportno,passportexpiry,
       issueoffice, poc, handbookissued,administrator, welfarewishes, tblStaff.notes, 
       tblStaff.rankID, tblStaff.tradeID,tblStaff.mesID, -- tblStaffPost.postID, 
       tblMES.description AS messtat, tblStaff.weaponNo, tblStaff.susat, tblTrade.tradeID
FROM tblStaff
INNER JOIN tblRank ON tblRank.rankID = tblStaff.rankID
LEFT OUTER JOIN tblStaffPost ON tblStaffPost.staffID=tblStaff.staffID AND (endDate IS NULL or endDate > GETDATE())
LEFT OUTER JOIN tblPost ON tblPost.postID=tblstaffPost.postID
LEFT OUTER JOIN tblTrade ON tblTrade.tradeID = tblStaff.TradeID
LEFT OUTER JOIN tblMES ON tblMES.mesID = tblStaff.mesID
WHERE tblStaff.staffID = @recID
GO
/****** Object:  StoredProcedure [dbo].[spGetHierarchyQtypes]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetHierarchyQtypes]
  @nodeID INT,
  @staffID INT
  
AS

CREATE TABLE #tempqt
(
  ttID INT,
  ttname VARCHAR(50),
  ttauth BIT
)

-- first insert current hierarchy QTypes
INSERT INTO #tempqt
  SELECT QTypeID, Description, auth
      FROM tblQTypes WHERE ndeID=@nodeID
 
-- now check if the staff member we are looking at
-- has any Qs from a previous posting in a DIFFERENT Hierarchy
IF EXISTS (SELECT TOP 1 staffID FROM tblStaffQs WHERE StaffID = @staffID and ndeID <> @nodeID)
  BEGIN
    INSERT INTO #tempqt
         SELECT 0, 'Other Qs', 0
  END
 SELECT ttID AS QTypeID, ttname AS Description, ttauth AS auth  from #tempqt
 DROP TABLE #tempqt
GO
/****** Object:  StoredProcedure [dbo].[spGetHierarchyList]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetHierarchyList] 
 @nodeID INT
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT T1.hrcID, T1.hrcname, T1.hrclevel, t2.hrcName AS parent
        FROM tblHierarchy AS T1
        LEFT OUTER JOIN tblHierarchy AS T2 ON T2.hrcID=T1.hrcparentID 
        WHERE T1.ndeID=@nodeID
END
GO
/****** Object:  StoredProcedure [dbo].[spGetHierarchyDetail]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Gets individual Hierarchy for Display/Edit in System Administration
CREATE PROCEDURE [dbo].[spGetHierarchyDetail]
    @hrcID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT T1.hrcID, T1.hrcparentID AS parentID, T1.hrcname, T1.hrclevel, T1.hrcchildren, t2.hrcName AS parent
        FROM tblHierarchy AS T1
        LEFT OUTER JOIN tblHierarchy AS T2 ON T2.hrcID=T1.hrcparentID 
        WHERE T1.hrcID=@hrcID
END
GO
/****** Object:  StoredProcedure [dbo].[spGetHierarchy3]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetHierarchy3]
(
     @nodeID INT,
	 @recID INT
)

AS

DECLARE @childID INT
DECLARE @hrcID INT
DECLARE @parentID INT
DECLARE @level INT
DECLARE @name VARCHAR(100)
DECLARE @path VARCHAR(255)

/**
DECLARE @chID INT
DECLARE @chprnt INT
DECLARE @chlevel INT
DECLARE @chname VARCHAR(100)
**/

--DECLARE @ttorder INT
DECLARE @error INT
DECLARE @lastlevel INT
DECLARE @children BIT
DECLARE @open BIT

; WITH tblChild AS
		(
		   SELECT T1.hrcID, T1.hrcName, T1.hrcparentID, T1.hrclevel, T1.hrcchildren, CAST(T1.hrcID AS VARCHAR(255)) AS hrcPath -- , 0 AS depth
		     FROM tblHierarchy T1 WHERE T1.hrcparentID = 0 AND T1.ndeID=@nodeID
		  UNION ALL
		   SELECT T2.hrcID, T2.hrcName,T2.hrcparentID, T2.hrclevel, T2.hrcchildren, CAST(hrcPath + '.' + CAST(T2.hrcID AS VARCHAR(255)) AS VARCHAR(255))    --  depth + 1
		     FROM tblHierarchy T2
		        INNER JOIN tblChild ON T2.hrcparentID=tblChild.hrcID
		  )
		  SELECT * INTO #ttTemp FROM tblChild ORDER BY hrcPath
		  

CREATE TABLE #ttopen(
    ttopenID INT
)

CREATE TABLE #tthrc(
   tthrcID INT,
   ttparentID INT,
   ttlevel INT,
   ttlastlevel INT,
   ttname VARCHAR (100),
   ttchildren BIT,
   ttpath VARCHAR(255),
   ttopen BIT
)
 
-- @recID is actually the hrcID of the Hierarchy unit that the person
-- logged on belongs to 
SET @childID=@recID  
SET @parentID= (SELECT hrcparentID FROM tblHierarchy WHERE hrcID=@recid) 
SET @error = 1    -- make sure we don't try and do stuff if there is no records   
SET @level = (SELECT hrclevel FROM tblhierarchy WHERE hrcID = @childID)
SET @lastlevel = @level   -- so we now how deep the levels go

--SET @ttorder=1
SET @open=0

-- first we get all the elements on the same level as the one we need ( @recid) 
-- cos if we don't then the web page does not display properly

DECLARE hrc1 CURSOR SCROLL
FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren FROM tblhierarchy WHERE hrcparentID = @parentID
OPEN hrc1
FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children

WHILE @@FETCH_STATUS = 0
 BEGIN
  INSERT INTO #ttopen
	 	SELECT @hrcID	         
  SET @error = @@ERROR
  
  FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children
  
 END

CLOSE hrc1
DEALLOCATE hrc1

-- now we go up one level	
SET @level = (SELECT hrclevel FROM tblhierarchy WHERE hrcID = @recid) - 1 
SET @childID=@parentID

-- Now we work our way up to the top of the hierarchy
-- but make sure we include all other branches of this part of the tree

WHILE @level >=0        -- @error will be based on the hierarchy level
	  BEGIN             -- we are going from bottom to top of selected Child branch
	     
		 DECLARE hrc1 CURSOR SCROLL
		 FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren FROM tblhierarchy WHERE hrcID = @childID
	     
		 OPEN hrc1
		 FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children


		 IF @@FETCH_STATUS = 0
		  BEGIN
		   -- SET @lastlevel = @level   -- so we now how deep the levels go
		    -- update the last child entry
			--  INSERT INTO #tthrc
			--	 SELECT 0, @hrcID, @parentID,@level, @name, @children, @open
			  INSERT INTO #ttopen
				 	SELECT @hrcID	         
			  SET @error = @@ERROR
		  END
		 
		 CLOSE hrc1
		 DEALLOCATE hrc1

		SET @error = 1   -- make sure we don't try and do stuff if there is no records   
		-- now move evrything up a level
		SET @childID=@parentID
		SET @level = @level - 1
		
  END

  DECLARE hrc1 CURSOR SCROLL
         FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren, hrcPath FROM #ttTemp 
     
		OPEN hrc1
		FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children, @path
				
		WHILE @@FETCH_STATUS = 0
		 BEGIN
		   -- update the last child entry
		   IF EXISTS (SELECT #ttopen.ttopenID FROM #ttopen WHERE #ttopen.ttopenID = @hrcID)
		     SET @open = 1
		   ELSE
		     SET @open=0
			  
		    INSERT INTO #tthrc
				 SELECT @hrcID, @parentID,@level,@lastlevel, @name, @children, @path, @open
			  FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children, @path			  
		 END
CLOSE hrc1
DEALLOCATE hrc1

  SELECT tthrcID AS hrcID,ttparentID AS hrcParentID, ttlevel AS hrcLevel, ttlastlevel AS lastlevel,
         ttname AS hrcName, ttchildren AS hrcChildren, ttopen AS hrcOpen
         FROM #tthrc ORDER BY #tthrc.ttpath
         
  DROP TABLE #tthrc 
  DROP TABLE #ttTemp
  DROP TABLE #ttopen
GO
/****** Object:  StoredProcedure [dbo].[spGetHierarchy2]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetHierarchy2]
(
	 @childID INT
)

AS

--DECLARE @childID INT
DECLARE @hrcID INT
DECLARE @parentID INT
DECLARE @level INT
DECLARE @name VARCHAR(100)

DECLARE @chID INT
DECLARE @chprnt INT
DECLARE @chlevel INT
DECLARE @chname VARCHAR(100)

DECLARE @ttorder INT
DECLARE @error INT
DECLARE @lastlevel INT
DECLARE @children BIT
DECLARE @open BIT


CREATE TABLE #tthrc(
   ttOrder INT,
   tthrcID INT,
   ttparentID INT,
   ttlevel INT,
   ttname VARCHAR (100),
   ttchildren BIT,
   ttopen BIT
)
  
--SET @childID=(SELECT hrcID FROM tblHierarchy WHERE teamID=@teamID)
   
SET @error = 1    -- make sure we don't try and do stuff if there is no records   

SET @level = (SELECT hrclevel FROM tblhierarchy WHERE hrcID = @childID)

SET @ttorder=1
SET @open=0

-- Now we work our way up to the top of the hierarchy
-- but make sure we include all other branches of this part of the tree
WHILE @level >=0        -- @error will be based on the hierarchy level
	  BEGIN             -- we are going from bottom to top of selected Child branch
	     
		 DECLARE hrc1 CURSOR SCROLL
		 FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren FROM tblhierarchy WHERE hrcID = @childID
	     
		 OPEN hrc1
		 FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children


		 IF @@FETCH_STATUS = 0
		  BEGIN
		    SET @lastlevel = @level   -- so we now how deep the levels go
		    -- update the last child entry
			  INSERT INTO #tthrc
				 SELECT 0, @hrcID, @parentID,@level, @name, @children, @open
				 		         
			  SET @error = @@ERROR
		  END
		 
		 CLOSE hrc1
		 DEALLOCATE hrc1

		SET @error = 1   -- make sure we don't try and do stuff if there is no records   
            
        DECLARE hrc1 CURSOR SCROLL
         FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren FROM tblhierarchy WHERE hrcparentid = @parentID
     
		OPEN hrc1
		FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children
				
		WHILE @@FETCH_STATUS = 0
		 BEGIN
		   -- update the last child entry
		   IF NOT EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.tthrcID = @hrcID)
			  INSERT INTO #tthrc
				 SELECT 0, @hrcID, @parentID,@level, @name, @children, @open
		        
			  SET @error = @@ERROR
			  SET @ttorder= @ttorder + 1

			  FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children			  
		 END
		CLOSE hrc1
		DEALLOCATE hrc1
		
		-- now move evrything up a level
		SET @childID=@parentID
		SET @level = @level - 1
		
  END


  DECLARE hrc2 CURSOR SCROLL
     FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren FROM tblhierarchy WHERE hrclevel = 0
     
   OPEN hrc2
   FETCH NEXT FROM hrc2 INTO @hrcID, @parentID,@level, @name, @children

   WHILE @@FETCH_STATUS = 0
	 BEGIN
	   -- make sure we don't add duplicates
	   IF NOT EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.tthrcID = @hrcID)
		  INSERT INTO #tthrc
			 SELECT 0, @hrcID, @parentID,@level, @name, @children,@open   
       
        -- now add the ist level children
		DECLARE hrc1 CURSOR SCROLL
		 FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren FROM tblhierarchy WHERE hrcparentID = @hrcID
	     
		OPEN hrc1
		FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children
        
		WHILE @@FETCH_STATUS = 0
		 BEGIN
		   -- make sure we don't add duplicates
		   IF NOT EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.tthrcID = @hrcID)
			  INSERT INTO #tthrc
				 SELECT 0, @hrcID, @parentID,@level, @name, @children,@open        
		
		   FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children
		 END
		 
		CLOSE hrc1
		DEALLOCATE hrc1
		
		 FETCH NEXT FROM hrc2 INTO @hrcID, @parentID,@level, @name, @children
      END
  
  CLOSE hrc2
  DEALLOCATE hrc2

  -- now order the table so we read it in Hierarchical order
  SET @ttorder = 1
  DECLARE hrc2 CURSOR SCROLL
     FOR SELECT tthrcID, ttparentID FROM #tthrc WHERE ttlevel = 0
  
   OPEN hrc2
   FETCH NEXT FROM hrc2 INTO @hrcID, @parentID

   WHILE @@FETCH_STATUS = 0
	 BEGIN
	 
	   UPDATE #tthrc SET ttOrder = @ttorder WHERE #tthrc.tthrcID= @hrcID AND ttOrder = 0
	   SET @ttorder=@ttorder+1
	   
	   -- now 1st level children
	   DECLARE hrc1 CURSOR SCROLL
	     FOR SELECT tthrcID, ttparentID, ttname FROM #tthrc WHERE ttparentID = @hrcID AND ttorder = 0
	     
		OPEN hrc1
		FETCH NEXT FROM hrc1 INTO @hrcID, @parentID, @name
       
		WHILE @@FETCH_STATUS = 0
		 BEGIN
		  UPDATE #tthrc SET ttOrder = @ttorder WHERE #tthrc.tthrcID= @hrcID
	      SET @ttorder=@ttorder+1 
	      
	      IF EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.ttparentID = @hrcID)
	      BEGIN
	         UPDATE #tthrc SET ttOrder = @ttorder 
	                       WHERE #tthrc.tthrcID= @hrcID
	         SET @ttorder=@ttorder+1
	          
		     SET @parentID = @hrcID
	         -- now loop down through the branch for all the childrren if there are any  
	         SET @error = 0
	         WHILE @error=0
	           BEGIN
		      
				   IF EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.ttparentID = @hrcID AND ttOrder=0)
					 BEGIN
							SET @chID = (select top 1 tthrcID FROM #tthrc WHERE #tthrc.ttparentID = @hrcID AND ttorder = 0)
							SET @name = (select top 1 ttname FROM #tthrc WHERE #tthrc.ttparentID = @hrcID AND ttorder = 0)
							
							UPDATE #tthrc SET ttOrder = @ttorder WHERE #tthrc.tthrcID= @chID
							SET @ttorder=@ttorder+1	 
							
							-- check to see if child has children
							 IF EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.ttparentID = @chID AND ttOrder=0) 
							   SET @hrcID = @chID  
							 ELSE
							 SET @hrcID = (SELECT ttparentID FROM #tthrc WHERE #tthrc.tthrcID =@chID AND ttOrder> 0)                 
							
					END
					
					ELSE IF EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.tthrcID = (SELECT ttparentID FROM #tthrc WHERE #tthrc.tthrcID =@hrcID) AND ttOrder>0)
					BEGIN
						SET @hrcID = (SELECT ttparentID FROM #tthrc WHERE #tthrc.tthrcID =@hrcID)
					END
					
					ELSE IF EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.ttparentID = @parentID AND ttOrder=0)
					 BEGIN
						SET @hrcID = @parentID
					 END
					ELSE
					  SET @error = 1
	         END
	      END	
	       FETCH NEXT FROM hrc1 INTO @hrcID, @parentID, @name	    
		  
		 END
		 
		CLOSE hrc1
		DEALLOCATE hrc1
	   FETCH NEXT FROM hrc2 INTO @hrcID, @parentID
	 END
    CLOSE hrc2
	DEALLOCATE hrc2

   -- Now we set the Open flag - BUT - only for parents with children
   -- these will be either:
   -- OPEN  - They have children in the tree so the they will have the minus ( - ) sign
   -- in the tree structure ie: they are OPEN
   -- CLOSED - They have children but NOT in the current structure so they will have the
   -- plus ( + ) sign that will open up theire structure when clicked
   DECLARE hrc2 CURSOR SCROLL
     FOR SELECT tthrcID FROM #tthrc WHERE ttchildren=1
  
   OPEN hrc2
   FETCH NEXT FROM hrc2 INTO @hrcID

   WHILE @@FETCH_STATUS = 0
	 BEGIN
	 
	     IF EXISTS (SELECT TOP 1 #tthrc.ttparentID FROM #tthrc WHERE #tthrc.ttparentID =@hrcID)
	      UPDATE #tthrc SET ttOpen = 1 WHERE #tthrc.tthrcID= @hrcID 
	     
	     FETCH NEXT FROM hrc2 INTO @hrcID
	     
	 END
	 
	 CLOSE hrc2
	 DEALLOCATE hrc2
	
  SELECT ttOrder AS hrcOrder, tthrcID AS hrcID,ttparentID AS hrcParentID, ttlevel AS hrcLevel,
         ttname AS hrcName, ttchildren AS hrcChildren, ttopen AS hrcOpen
         FROM #tthrc ORDER BY #tthrc.ttOrder
  DROP TABLE #tthrc
GO
/****** Object:  StoredProcedure [dbo].[spGetHierarchy]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spGetHierarchy]
AS

CREATE TABLE #hierarchy (hrID int, hrPID INT, hrDesc varchar(50), hrPDesc VARCHAR(50), hrlevel INT)

INSERT INTO #hierarchy (hrID, hrPID, hrDesc, hrPDesc, hrlevel)
              SELECT dbo.tblTeam.teamID, ParentID, dbo.tblTeam.description, 
                   dbo.tblgroup.description, '0'          
              FROM         dbo.tblTeam INNER JOIN
                             dbo.tblgroup ON dbo.tblTeam.ParentID = dbo.tblgroup.grpID
                WHERE dbo.tblTeam.teamIn = 0

INSERT INTO #hierarchy (hrID, hrPID, hrDesc, hrPDesc, hrlevel)
              SELECT dbo.tblTeam.teamID, ParentID, dbo.tblTeam.description, 
                   dbo.tblWing.description, '1'          
              FROM         dbo.tblTeam INNER JOIN
                             dbo.tblWing ON dbo.tblTeam.ParentID = dbo.tblWing.wingID
                WHERE dbo.tblTeam.teamIn = 1

INSERT INTO #hierarchy (hrID, hrPID, hrDesc, hrPDesc, hrlevel)
               SELECT dbo.tblTeam.teamID,ParentID,dbo.tblTeam.description,
                      dbo.tblSquadron.description, '2' 
                 FROM dbo.tblTeam INNER JOIN
                      dbo.tblSquadron ON dbo.tblTeam.ParentID = dbo.tblSquadron.sqnID
                 WHERE dbo.tblTeam.teamIn = 2

INSERT INTO #hierarchy (hrID, hrPID, hrDesc, hrPDesc, hrlevel)
               SELECT dbo.tblTeam.teamID, ParentID,dbo.tblTeam.description, 
                      dbo.tblFlight.description, '3'
                  FROM dbo.tblTeam INNER JOIN
                      dbo.tblFlight ON dbo.tblTeam.ParentID = dbo.tblFlight.fltID
                WHERE  dbo.tblTeam.teamIn = 3

INSERT INTO #hierarchy (hrID, hrPID, hrDesc, hrPDesc, hrlevel)
               SELECT MainTeamTable.teamID, MainTeamTable.ParentID,MainTeamTable.description, 
                      dbo.tblTeam.description, '4' 
                  FROM dbo.tblTeam as MainTeamTable INNER JOIN
                        dbo.tblTeam ON MainTeamTable.ParentID = dbo.tblTeam.TeamID
                 WHERE MainTeamTable.teamIn = 4


SELECT * from #hierarchy
        ORDER BY hrPID, hrID

DROP TABLE #hierarchy


SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  StoredProcedure [dbo].[spGetHarmonyStatus]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetHarmonyStatus]
(
	@hrcID		INT,
	@repunit	INT, 
	@repby		INT,
	@establishment	DEC(5, 2) OUTPUT,
	@strength	DEC(5, 2) OUTPUT,
	@ooaredtot	DEC (5, 2) OUTPUT,
	@bnaredtot	DEC (5, 2) OUTPUT,     
	@ooapcnt	DEC (5, 2) OUTPUT,     
	@bnapcnt	DEC (5, 2) OUTPUT,      
	@status		DEC (5, 2) OUTPUT
)

AS

DECLARE @nodeID INT

SET @nodeID=(SELECT ndeID FROM tblHierarchy WHERE hrcID = @hrcID)

-- @repunit is Report By parameter  0=Unit  1=Unit/Trade  2=Unit/Rank
-- @repby is Harmony Status reporting parameter 
-- 0=Harmony of Unit Strength  1= Harmony by Unit Establishment
DECLARE @gender int
DECLARE @str VARCHAR(2000)
DECLARE @where VARCHAR(2000)

-- Unit strength - number in posts and Unit Establishment - total posts
DECLARE @strpcnt DEC (5, 2)
DECLARE @estpcnt DEC (5, 2)

-- Unit Harmony Target Limits
DECLARE @ooared DEC (5, 2)
DECLARE @ooayel DEC (5, 2)
DECLARE @ooaamb DEC (5, 2)
DECLARE @ooagrn DEC (5, 2)

DECLARE @bnared DEC (5, 2)
DECLARE @bnayel DEC (5, 2)
DECLARE @bnaamb DEC (5, 2)
DECLARE @bnagrn DEC (5, 2)

-- Harmony Period RED days
DECLARE @hpooared DEC (5, 2)
DECLARE @hpssared DEC (5, 2)
DECLARE @hpssbred DEC (5, 2)

-- The Harmony Status itself - the Holy Grail
-- 0 = Green, 1 = Yellow, 2 = Amber, 3 = Red
-- DECLARE @status INT

-- The code starts here
SET @ooaredtot = 0
SET @bnaredtot = 0

-- first get the Harmony Days that show RED if exceeded
DECLARE hper CURSOR FOR 
	SELECT ooared, ssared, ssbred FROM tblHarmonyPeriod
	    WHERE ndeID=@nodeID

OPEN hper

FETCH NEXT FROM hper INTO @hpooared, @hpssared, @hpssbred

CLOSE hper
DEALLOCATE hper

-- now get the Unit Harmony Limits 
-- these will be used to calculate harmony status
DECLARE hpunit CURSOR FOR 
	SELECT ooared, ooaambmin, ooayelmin, ooagrnmax,bnared, bnaambmin, bnayelmin, bnagrnmax
	FROM tblUnitHarmonyTarget WHERE ndeID = @nodeID
OPEN hpunit

FETCH NEXT FROM hpunit INTO @ooared, @ooaamb, @ooayel, @ooagrn, @bnared, @bnaamb, @bnayel, @bnagrn

CLOSE hpunit
DEALLOCATE hpunit;

--SET @teamIN = (SELECT teamIN FROM tblTeam WHERE tblTeam.hrcID = @hrcID)

WITH tblChild AS
		(
		  SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
		  UNION ALL
		  SELECT tblHierarchy.hrcID, tblHierarchy.hrcName FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
		)
     SELECT hrcID, hrcname INTO #tmtemp FROM tblChild 
     




-- now get all the posts in each team  - but ignore the Ghost crap
-- and ONLY get Service posts   ie: Rank.weight > 0

-- first get the Established Posts
SET @establishment = (SELECT COUNT(*) FROM tblPost
	INNER JOIN tblRank ON tblRank.rankID = tblPost.rankID
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID 
	WHERE tblPost.Ghost = 0 AND tblPost.Status = 1 AND tblRank.weight <> 0)

-- Now get the Actual Strength ie: Only the posts with someone in them
SET @strength = (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblRank ON tblRank.rankID = tblStaff.rankID
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID = tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID 
	WHERE tblPost.Ghost = 0 AND tblPost.Status = 1 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) AND tblRank.weight <> 0)

-- now get the total staff breaking OOA Harmony
SET @ooaredtot = (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblRank ON tblRank.rankID = tblStaff.rankID
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID = tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID 
	WHERE ddooa >= @hpooared AND tblPost.Ghost = 0 AND tblPost.Status = 1 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= getdate()) AND tblRank.weight <> 0)

-- now get the total staff breakin BNA Harmony
SET @bnaredtot = (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID  
	WHERE (ddssa >= @hpssared OR ddssb >= @hpssbred )AND tblPost.Ghost = 0 AND tblPost.Status = 1 AND 
	      (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) AND tblRank.weight <> 0)

-- now make sure total Bed Nights Away INCLUDES Out of Area days

-- Ron 07/07/11 - No - this skews the BNA count
--SET @bnaredtot = @bnaredtot + @ooaredtot

-- default to zeros in case all the posts are empty
SET @estpcnt=0.00
SET @strpcnt=0.00
SET @ooapcnt=0.00
SET @bnapcnt=0.00

IF @establishment <> 0
	BEGIN
		SET @estpcnt = (@establishment / 100)
		SET @strpcnt = (@strength * (100 / @establishment))

		IF @repby = 1   -- Harmony by Unit Establishment
			BEGIN
				SET @ooapcnt = (@ooaredtot  * (100 / @establishment))
				SET @bnapcnt = (@bnaredtot  * (100 / @establishment))
			END
	END

IF @strength <> 0
	BEGIN
		IF @repby = 0   -- Harmony by Unit Strength
			BEGIN
				SET @ooapcnt = (@ooaredtot  * (100 / @strength))
				SET @bnapcnt = (@bnaredtot  * (100 / @strength))
			END
	END

-- now set the Harmony Status
-- 0 = Green, 1=Yellow, 2=Amber, 3=Red
IF (@ooapcnt >= @ooared OR @bnapcnt >= @bnared)
	SET @status = 3
ELSE IF (@ooapcnt >= @ooaamb OR @bnapcnt >= @bnaamb)
	SET @status = 2
ELSE IF (@ooapcnt >= @ooayel OR @bnapcnt >= @bnayel)
	SET @status = 1
ELSE 
	SET @status = 0

DROP TABLE #tmtemp
GO
/****** Object:  StoredProcedure [dbo].[spGetHarmonyReportDetails]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetHarmonyReportDetails]
(
	@hrcID	INT,
	@gender	INT
)

AS

IF @gender = 0
	BEGIN
		SELECT tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblStaff.lastOOA, tblStaff.ddooa AS ooaDays, 
		        tblStaff.ddssa AS ssadays, tblStaff.ddssb AS ssbdays, tblHierarchy.hrcname AS Team
		FROM tblStaff
		INNER JOIN tblRank ON tblRank.rankID = tblStaff.rankID
		INNER JOIN tblStaffPost ON tblStaffPost.StaffID = tblStaff.staffID
		INNER JOIN tblPost ON tblPost.postID = tblStaffPost.PostID
		INNER JOIN tblHierarchy ON tblHierarchy.hrcID = tblPost.hrcID
		WHERE (tblPost.Ghost = 0) AND (tblStaffPost.endDate IS NULL) AND (tblHierarchy.hrcID = @hrcID) AND (tblRank.Weight <> 0)
		ORDER BY tblHierarchy.hrcname, tblRank.weight DESC
	END

IF @gender = 1
	BEGIN
		SELECT tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblStaff.lastOOA, tblStaff.ddooa AS ooaDays, 
		tblStaff.ddssa AS ssadays, tblStaff.ddssb AS ssbdays, tblHierarchy.hrcname AS Team
		FROM tblStaff
		INNER JOIN tblRank ON tblRank.rankID = tblStaff.rankID
		INNER JOIN tblStaffPost ON tblStaffPost.StaffID = tblStaff.staffID
		INNER JOIN tblPost ON tblPost.postID = tblStaffPost.PostID
		INNER JOIN tblHierarchy ON tblHierarchy.hrcID = tblPost.hrcID
		WHERE (tblPost.Ghost = 0) AND (tblStaffPost.endDate IS NULL) AND (tblHierarchy.hrcID = @hrcID) AND (tblRank.Weight <> 0) AND (tblStaff.sex = 'M')
		ORDER BY tblHierarchy.hrcname, tblRank.weight DESC
	END

IF @gender = 2
	BEGIN
		SELECT tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblStaff.lastOOA, tblStaff.ddooa AS ooaDays, tblStaff.ddssa AS ssadays, 
		       tblStaff.ddssb AS ssbdays, tblHierarchy.hrcname AS Team
		FROM tblStaff
		INNER JOIN tblRank ON tblRank.rankID = tblStaff.rankID
		INNER JOIN tblStaffPost ON tblStaffPost.StaffID = tblStaff.staffID
		INNER JOIN tblPost ON tblPost.postID = tblStaffPost.PostID
		INNER JOIN tblHierarchy ON tblHierarchy.hrcID = tblPost.hrcID
		WHERE (tblPost.Ghost = 0) AND (tblStaffPost.endDate IS NULL) AND (tblHierarchy.hrcID = @hrcID) AND (tblRank.Weight <> 0) AND (tblStaff.sex = 'F')
		ORDER BY tblHierarchy.hrcname, tblRank.weight DESC
	END
GO
/****** Object:  StoredProcedure [dbo].[spGetHarmonyReport]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetHarmonyReport]
(
	@hrcID		INT,
	@gender		INT
)

AS

DECLARE @fltID		INT
DECLARE @sqnID		INT
DECLARE @wingID		INT
DECLARE @groupID	INT
--DECLARE @teamIN		INT
DECLARE @rankID		INT
--DECLARE @unit   	VARCHAR(25)
DECLARE @StaffID	INT
DECLARE @enddate	DATETIME
DECLARE @remedial	INT
DECLARE @exempt		INT

DECLARE @Posted		INT
DECLARE @Less		INT
DECLARE @Greater	INT
DECLARE @Deployable	INT
DECLARE @Permanent	INT
DECLARE @Temp		INT

DECLARE @first		INT

--SET @teamIN = (SELECT teamIN from tblTeam WHERE tblTeam.teamID = @tmID)
--SET @unit = (SELECT description from tblTeam WHERE tblTeam.teamID = @tmID)

-- so we know its the first time through the cursor loop below
SET @first = 0

-- temp table to hold list of units
WITH tblChild AS
		(
		  SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
		  UNION ALL
		  SELECT tblHierarchy.hrcID, tblHierarchy.hrcName FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
		)
     SELECT hrcID, hrcname INTO #ttHRC FROM tblChild 

SET DATEFORMAT dmy

-- People who have a valid ccs record
IF @gender = 0
	BEGIN
		SELECT tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblStaff.lastOOA, tblStaff.ddooa AS ooaDays, 
		       tblStaff.ddssa AS ssadays, tblStaff.ddssb AS ssbdays, #ttHRC.hrcname AS Team, tblRank.weight
		FROM tblStaff
		INNER JOIN tblRank ON tblRank.rankID = tblStaff.rankID
		INNER JOIN tblStaffPost ON tblStaffPost.StaffID = tblStaff.staffID
		INNER JOIN tblPost ON tblPost.postID = tblStaffPost.PostID
		INNER JOIN #ttHRC ON tblPost.hrcID = #ttHRC.hrcID
		--INNER JOIN tblTeam ON tblTeam.teamID = tblPost.teamID
		WHERE (tblPost.Ghost = 0) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate > GETDATE()) AND (tblRank.Weight <> 0)
		ORDER BY #ttHRC.hrcname, tblRank.weight DESC
	END

IF @gender = 1
	BEGIN
		SELECT tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblStaff.lastOOA, tblStaff.ddooa AS ooaDays, tblStaff.ddssa AS ssadays, 
		tblStaff.ddssb AS ssbdays, #ttHRC.hrcname AS Team, tblRank.weight
		FROM tblStaff
		INNER JOIN tblRank ON tblRank.rankID = tblStaff.rankID
		INNER JOIN tblStaffPost ON tblStaffPost.StaffID = tblStaff.staffID
		INNER JOIN tblPost ON tblPost.postID = tblStaffPost.PostID
		INNER JOIN #ttHRC ON tblPost.hrcID = #ttHRC.hrcID
		--INNER JOIN tblTeam ON tblTeam.teamID = tblPost.teamID
		WHERE (tblPost.Ghost = 0) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate > GETDATE()) AND (tblRank.Weight <> 0) AND (tblStaff.sex = 'M')
		ORDER BY #ttHRC.hrcname, tblRank.weight DESC
	END

IF @gender = 2
	BEGIN
		SELECT tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblStaff.lastOOA, tblStaff.ddooa AS ooaDays, tblStaff.ddssa AS ssadays, 
		        tblStaff.ddssb AS ssbdays, #ttHRC.hrcname AS Team, tblRank.weight
		FROM tblStaff
		INNER JOIN tblRank ON tblRank.rankID = tblStaff.rankID
		INNER JOIN tblStaffPost ON tblStaffPost.StaffID = tblStaff.staffID
		INNER JOIN tblPost ON tblPost.postID = tblStaffPost.PostID
		INNER JOIN #ttHRC ON tblPost.hrcID = #ttHRC.hrcID
		--INNER JOIN tblTeam ON tblTeam.teamID = tblPost.teamID
		WHERE (tblPost.Ghost = 0) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate > GETDATE()) AND (tblRank.Weight <> 0) AND (tblStaff.sex = 'F')
		ORDER BY #ttHRC.hrcname, tblRank.weight DESC
	END

DROP TABLE #ttHRC
GO
/****** Object:  StoredProcedure [dbo].[spGetHarmonyPeriods]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spGetHarmonyPeriods] 
  @nodeID INT
AS

SELECT hpID, ooaperiod, ooared, ooaamber,ssaperiod,ssared,ssaamber,ssbperiod,ssbred,ssbamber
  FROM tblHarmonyPeriod WHERE ndeID=@nodeID
GO
/****** Object:  StoredProcedure [dbo].[spGetHarmonyLimits]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spGetHarmonyLimits] 

AS

SELECT TOP 1 ooaperiod, ooared, ooaamber,
             ssaperiod, ssared, ssaamber,
             ssbperiod, ssbred, ssbamber
  FROM tblHarmonyPeriod
GO
/****** Object:  StoredProcedure [dbo].[spGetHarmonyDays]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE        PROCEDURE [dbo].[spGetHarmonyDays] 

@staffID INT,
@fromdate DATETIME,
@todate DATETIME,
@period INT,
@type INT,
@type1 INT,
@days    INT  OUT

AS

--DECLARE @fromdate DATETIME
DECLARE @start DATETIME
DECLARE @end DATETIME

DECLARE @diff INT

SET dateformat dmy

-- default Out of Area Days to Zero
SET @days=0

-- first the get the start date of the period
--EXEC spGetFromDate @todate, @period, @fromdate = @fromdate OUTPUT

-- now we go back through time to the period start and calculate ooa days for this body
-- @type and @type1 are the parameters for OOA or BNA - 
-- if we are only interested in OOA days then @type AND @type1 will BOTH = 1
-- if we are interested in Bed Night Away (BNA) days then @type = 1 and @type1 = 2
-- this is so that we catch all days cos BNA INCLUDE OOA
DECLARE ddOOA CURSOR  FOR
  SELECT 
      tbl_TaskStaff.startDate, tbl_TaskStaff.endDate
        FROM tbl_task
          INNER JOIN tbl_TaskStaff ON
           tbl_task.taskID = tbl_TaskStaff.taskID
              WHERE tbl_TaskStaff.staffID = @staffID  AND
                    tbl_TaskStaff.startDate < @toDate AND
                    tbl_TaskStaff.endDate > @fromDate AND
                    tbl_TaskStaff.Active = 1          AND
                    (tbl_Task.ooa = @type OR tbl_Task.ooa = @type1)

OPEN ddOOA

FETCH NEXT FROM ddOOA INTO @start, @end
WHILE @@FETCH_STATUS = 0
 BEGIN
  
   -- now we need to make sure we only get the days that fall within the period
   IF @start < @fromDate AND @end < @todate 
     BEGIN
        -- the task starts before the period so get the days from period end to 
        -- task end and add to OOA days BUT don't include 1st day
        SET @diff=DATEDIFF ( DAY , @fromdate , @end )  
        --SELECT @diff AS 'One'       
     END
   ELSE 
   IF @start > @fromDate AND @end > @todate 
     BEGIN
        -- the task ends after the period so get the days from task start to 
        -- period end and add to OOA days BUT add 1 cos DATEDIFF doesn't include 1st day
        SET @diff=(DATEDIFF ( DAY , @start , @todate ) + 1)  
        --SELECT @diff AS 'TWO'       
     END

   ELSE
   IF @start > @fromDate AND @end < @todate
     BEGIN
       -- The task falls entirely in the period so just
       -- get the number of days for the task
       SET @diff=(DATEDIFF ( DAY , @start , @end ) + 1) 
       --SELECT @diff AS 'Three'
     END

   -- now add to OOA days
   SET @days=@days + @diff
           
   FETCH NEXT FROM ddOOA INTO @start, @end

 END

--SELECT @days
   
CLOSE ddOOA
DEALLOCATE ddOOA
GO
/****** Object:  StoredProcedure [dbo].[spGetGenPW]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spGetGenPW]
 @nodeID INT
AS

SELECT gpwID, genericPW 
  FROM dbo.tblGenericPW
    WHERE ndeID=@nodeID
GO
/****** Object:  StoredProcedure [dbo].[spGetFitnessStatus]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetFitnessStatus]
(
	@hrcID		INT,
	@List		VARCHAR(800)
)

AS

DECLARE @Pos		INT
DECLARE @Len		INT
DECLARE @fitnessID		INT
	
DECLARE @first 		INT

SET @Len = LEN(@List)
-- so we know its the first time through the cursor loop below
SET @first = 0

-- temp table to hold list of units
; WITH tblChild AS
		(
		   SELECT T1.hrcID, T1.hrcName, CAST(T1.hrcID AS VARCHAR(255)) AS hrcPath -- , 0 AS depth
		     FROM tblHierarchy T1 WHERE T1.hrcID=@hrcID
		  UNION ALL
		   SELECT T2.hrcID, T2.hrcName, CAST(hrcPath + '.' + CAST(T2.hrcID AS VARCHAR(255)) AS VARCHAR(255))    --  depth + 1
		     FROM tblHierarchy T2
		        INNER JOIN tblChild ON T2.hrcparentID=tblChild.hrcID
		  )
     SELECT hrcID, hrcname INTO #tempunit FROM tblChild  ORDER BY hrcPath

SET DATEFORMAT dmy

-- temp table to hold list of fitness
CREATE TABLE #tempfitness
(
	fitnessID		INT
)

-- temp table to hold all ranks within Unit Hierarchy
CREATE TABLE #templist
(
	staffID			INT,
	shortDesc		VARCHAR(50),
	surname		VARCHAR(50),
	firstname		VARCHAR(50),
	serviceno		VARCHAR(50),
	description		VARCHAR(50),
	validfrom		DATETIME,
	validto			DATETIME,
	remedial			INT,
	exempt			INT,
	expiryDate		DATETIME,
	weight			INT
)

SET @Pos = 0
WHILE (CHARINDEX(',',@List,@Pos)-@Pos) > 0
	BEGIN
		SET @fitnessID = SUBSTRING(@List,@Pos,(CHARINDEX(',',@List,@Pos)-@Pos))

		INSERT INTO #tempfitness(fitnessID)
		SELECT @fitnessID
		SET @Pos = CHARINDEX(',',@List,@Pos)+1
	END
		
DECLARE un1 SCROLL CURSOR FOR
	SELECT fitnessID FROM #tempfitness

OPEN un1

FETCH NEXT FROM un1 INTO @fitnessID

-- People who have a valid fitness record
WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO #templist
			SELECT DISTINCT tblStaff.staffID, tblRank.shortdesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, /*NULL*/ #tempunit.hrcName, 
			                tblStaffFitness.ValidFrom, tblStaffFitness.ValidTo, tblStaff.remedial, tblStaff.Exempt, tblStaff.expiryDate, tblRank.Weight
			FROM tblStaff
			INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
			INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
			INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
			INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
			LEFT OUTER JOIN tblStaffFitness ON tblStaff.staffID = tblStaffFitness.StaffID
			WHERE tblStaffFitness.FitnessID = @fitnessID AND tblStaff.remedial = 0 AND tblStaff.exempt = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.enddate > GETDATE()) AND tblPost.Ghost = 0 AND tblRank.Weight <> 0

		FETCH NEXT FROM un1 INTO @fitnessID
	END

CLOSE un1
DEALLOCATE un1

-- people who are exempt
INSERT INTO #templist
	SELECT DISTINCT tblStaff.staffID, tblRank.shortdesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, /*NULL*/ #tempunit.hrcName, 
	                NULL, NULL, tblStaff.remedial, tblStaff.Exempt, tblStaff.expiryDate, tblRank.Weight
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
	WHERE (tblStaff.remedial = 0 AND tblStaff.Exempt = 1) AND (tblRank.Weight <> 0) AND tblPost.Ghost = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.enddate > GETDATE())

-- people who are on remedial
INSERT INTO #templist
	SELECT DISTINCT tblStaff.staffID, tblRank.shortdesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, /*NULL*/ #tempunit.hrcName, 
	                NULL, NULL, tblStaff.remedial, tblStaff.Exempt, tblStaff.expiryDate, tblRank.Weight
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
	WHERE (tblStaff.remedial = 1 AND tblStaff.Exempt = 0) AND (tblRank.Weight <> 0) AND tblPost.Ghost = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.enddate > GETDATE())

-- people who have no fitness record
INSERT INTO #templist
	SELECT DISTINCT tblStaff.staffID, tblRank.shortdesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, /*NULL*/ #tempunit.hrcName, 
	                NULL, NULL, tblStaff.remedial, tblStaff.Exempt, tblStaff.expiryDate, tblRank.Weight
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
	WHERE NOT EXISTS(SELECT staffid FROM tblstafffitness WHERE tblstafffitness.staffid = tblstaff.staffid) AND tblStaff.remedial = 0 AND tblStaff.exempt = 0 AND 
	                 tblRank.Weight <> 0 AND tblPost.Ghost = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.enddate > GETDATE()) 

SELECT * FROM #templist ORDER BY Description, Weight DESC

DROP TABLE #tempunit
DROP TABLE #tempfitness
DROP TABLE #templist
GO
/****** Object:  StoredProcedure [dbo].[spGetCyclesAndStages]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- This will select All the Cycles and their Attached Stages in the order they were
-- attached - by tblCycleSteps order

CREATE   PROCEDURE [dbo].[spGetCyclesAndStages]

AS

SELECT tblCycle.cyID AS cycleID, tblCycle.Description AS Cycle, tblCycleStage.cysID AS stageID, 
       tblCycleStage.description AS Stage, tblCycleSteps.cytStep AS Step, tblCycleSteps.cyID AS stcyID,
       tblCycleSteps.cysID AS stcysID, tblCycleSteps.cytID
   FROM tblCycleSteps
       INNER JOIN tblCycle ON
          tblCycle.cyID = tblCycleSteps.cyID
       INNER JOIN tblCycleStage ON
          tblCycleStage.cysID = tblCycleSteps.cysID
           ORDER by tblCycle.cyID, tblCycleSteps.cytStep
GO
/****** Object:  StoredProcedure [dbo].[spGetCurrStages]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- This will select the stages attached to the current cyle record


CREATE          PROCEDURE [dbo].[spGetCurrStages]
@RecID int

AS

SELECT tblCycleStage.description, tblCycleStage.cysID, cytStep
   FROM tblcycleSteps
     INNER JOIN tblcyclestage ON
        tblcyclestage.cysid = tblcycleSteps.cysID
    WHERE  tblcycleSteps.cyID = @recID
      ORDER BY tblcycleSteps.cytStep
GO
/****** Object:  StoredProcedure [dbo].[spGetCISIndividualAuth]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetCISIndividualAuth]
(
    @nodeID INT,
	@surname	VARCHAR(50),
	@firstname	VARCHAR(50),
	@serviceno	VARCHAR(50),
	@hrcID	INT
)

AS

SET @surname = @surname + '%'
SET @firstname = @firstname + '%'
SET @serviceno = @serviceno + '%'

/*
IF @surname =''
	BEGIN
		SET @surname = '%'
	END

IF @firstname  ='' 
	BEGIN
		SET @firstname = '%'
	END

IF @serviceno  ='' 
	BEGIN
		SET @serviceno = '%'
	END
*/
-- Here we get the list of staff - BUT - we ONLY want people who have Q's that have
-- been Authorised - otherwise we are just going to see a blank certificate
IF @hrcID<> 0 
	BEGIN
	SELECT DISTINCT tblStaff.staffID, tblStaff.serviceno, tblRank.shortDesc, tblStaff.firstname, tblStaff.surname 
		  FROM tblPost
		   INNER JOIN tblStaffPost ON tblStaffPost.postID = tblPost.postID AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) 
		   INNER JOIN tblStaff ON tblStaff.staffID=tblStaffPost.StaffID AND tblStaff.active=1
		   INNER JOIN tblStaffQs ON tblStaffQs.StaffID = tblStaff.staffID AND tblStaffQs.AuthName IS NOT NULL
		   INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID 
		    WHERE tblPost.hrcID=@hrcID  AND
		         surname LIKE @surname  AND firstname LIKE @firstname AND serviceno LIKE @serviceno 
	END
ELSE
    BEGIN
		SELECT tblStaff.staffID, tblTeam.teamID, tblStaff.serviceno, tblRank.shortDesc, tblStaff.firstname, tblStaff.surname 
		  FROM tblStaff 
		   INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID 
		   LEFT OUTER JOIN tblStaffPost ON tblStaffPost.StaffID = tblStaff.staffID AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE())
		   LEFT OUTER JOIN tblMES ON tblMES.mesID = tblStaff.mesID 
		   LEFT OUTER JOIN tblPost ON tblPost.postID = tblStaffPost.PostID AND tblPost.Ghost = 0
		   LEFT OUTER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID 
		   LEFT OUTER JOIN tblManager ON tblManager.postID = tblPost.postID 
		    WHERE tblStaff.ndeID=@nodeID AND tblStaff.active=1 --AND
		         -- surname LIKE @surname  AND firstname LIKE @firstname AND serviceno LIKE @serviceno 
    END
GO
/****** Object:  StoredProcedure [dbo].[spGetCISIndividual]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetCISIndividual]
(
	@staffID			INT
)

AS

SET DATEFORMAT dmy

DECLARE @qtID INT

CREATE TABLE #tempqt
(
	qtID		INT
)

CREATE TABLE #tempq
(
	staffID		INT,
	expiry		DATETIME,
	days		INT,
	qdesc		VARCHAR(50),
	longdesc	VARCHAR(300),
	authname	VARCHAR(50)
)

CREATE TABLE #tempstaff
(
	staffID		INT,
	assignno	VARCHAR(50),
	serviceno	VARCHAR(10),
	rank		VARCHAR(15),
	surname		VARCHAR(50),
	firstname	VARCHAR(25),
	post		VARCHAR(50)
)

CREATE TABLE #temparea
(
	staffID		INT,
	hrcname		VARCHAR(500),
	hrcparent	VARCHAR(500)
)

CREATE TABLE #templist
(
	staffID		INT,
	assignno	VARCHAR(50),
	serviceno	VARCHAR(10),
	rank		VARCHAR(15),
	surname		VARCHAR(50),
	firstname	VARCHAR(25),
	wg		VARCHAR(50),
	sqn		VARCHAR(50),
	post		VARCHAR(50),
--	vpdays		INT,
	expiry		DATETIME,
	description	VARCHAR(50),
	longdesc	VARCHAR(300),
	authname	VARCHAR(20)
)

----------------------------------------------------------------------------------------------------

INSERT INTO #tempqt
	SELECT QTypeID
	FROM tblQTypes
	WHERE Auth = 1
	
----------------------------------------------------------------------------------------------------

DECLARE un1 SCROLL CURSOR FOR
	SELECT qtID FROM #tempqt

OPEN un1

FETCH NEXT FROM un1 INTO @qtID

WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO #tempq
			SELECT tblStaff.staffID, tblStaffQs.ValidFrom, tblValPeriod.vpdays, tblQs.Description, tblQs.LongDesc, tblStaffQs.AuthName
			FROM tblStaff
			INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID --AND tblRank.Weight <> 0
			INNER JOIN tblStaffQs ON tblStaffQs.TypeID = @qtID AND tblStaff.staffID = tblStaffQs.StaffID
			INNER JOIN tblQs ON tblStaffQs.QID = tblQs.QID
			INNER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
			WHERE tblStaff.staffID=@staffID
		
		FETCH NEXT FROM un1 INTO @qtID		
		
	END

CLOSE un1
DEALLOCATE un1

----------------------------------------------------------------------------------------------------
INSERT INTO #tempstaff
	SELECT tblStaff.staffID, tblPost.assignno, tblStaff.serviceno, tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblPost.description
	FROM tblStaff
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	WHERE (tblStaff.staffID = @staffID) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE())
	ORDER BY tblStaff.staffID

----------------------------------------------------------------------------------------------------
INSERT INTO #temparea
SELECT sp.staffID, u.hrcname AS unit, p.hrcname AS parent
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblHierarchy u ON u.hrcID = p1.hrcID
	LEFT JOIN tblHierarchy p ON p.hrcID = u.hrcparentID
	WHERE (sp.enddate IS NULL OR sp.enddAte >= GETDATE())
---------------------------------------------------------------------------------

INSERT INTO #templist
	SELECT #tempstaff.staffID, #tempstaff.assignno, #tempstaff.serviceno, #tempstaff.rank, #tempstaff.surname, #tempstaff.firstname, #temparea.hrcparent, #temparea.hrcname, 
	       #tempstaff.post, dateadd(d, #tempq.days, #tempq.expiry) as expiry, #tempq.qdesc, #tempq.longdesc, #tempq.authname
	FROM #tempstaff
	INNER JOIN #temparea ON #tempstaff.staffID = #temparea.staffID
	LEFT JOIN #tempq ON #tempstaff.staffID = #tempq.staffID

----------------------------------------------------------------------------------------------------

SELECT * FROM #templist

DROP TABLE #tempqt
DROP TABLE #tempq
DROP TABLE #tempstaff
DROP TABLE #temparea
DROP TABLE #templist
GO
/****** Object:  StoredProcedure [dbo].[spGetCISAuth]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetCISAuth]
(
	@hrcID			INT
)

AS

DECLARE @qtID		INT
DECLARE @staffID	INT

--DECLARE @fltID		INT
--DECLARE @sqnID		INT
--DECLARE @wingID		INT
--DECLARE @groupID	INT

-- temp table to hold list of units
WITH tblChild AS 
  (
     SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
  )
  SELECT hrcID, hrcname INTO #tempunit FROM tblChild 

CREATE TABLE #tempqt
(
	qtID		INT
)

CREATE TABLE #tempstaff
(
	staffID		INT,
	assignno	VARCHAR(50),
	serviceno	VARCHAR(10),
	rank		VARCHAR(15),
	surname		VARCHAR(50),
	firstname	VARCHAR(25),
	post		VARCHAR(50)
)

CREATE TABLE #temparea
(
	staffID		INT,
	hrcname		VARCHAR(500),
	hrcparent	VARCHAR(500)
)

CREATE TABLE #tempq
(
	staffID		INT,
	expiry		DATETIME,
	days		INT,
	qdesc		VARCHAR(500),
	longdesc	VARCHAR(500),
	authname	VARCHAR(500)
)

CREATE TABLE #templist
(
	staffID		INT,
	assignno	VARCHAR(50),
	serviceno	VARCHAR(10),
	rank		VARCHAR(15),
	surname		VARCHAR(50),
	firstname	VARCHAR(25),
	hrcparent	VARCHAR(50),
	hrcname		VARCHAR(50),
	post		VARCHAR(50),
	expiry		DATETIME,
--	vpdays		INT,
	description	VARCHAR(50),
	longdesc	VARCHAR(300),
	authname	VARCHAR(20)
)

INSERT INTO #tempqt
	SELECT QTypeID
	FROM tblQTypes
	WHERE Auth = 1
	

----------------------------------------------------------------------------------------------------

DECLARE un1 SCROLL CURSOR FOR
	SELECT qtID FROM #tempqt

OPEN un1

FETCH NEXT FROM un1 INTO @qtID

WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO #tempq
			SELECT tblStaff.staffID, tblStaffQs.ValidFrom, tblValPeriod.vpdays, tblQs.Description, tblQs.LongDesc, tblStaffQs.AuthName
			FROM tblPost
			--FROM tblStaff
			INNER JOIN tblStaffPost ON tblStaffPost.PostID=tblPost.postID AND tblStaffPost.endDate IS NULL
			INNER JOIN tblStaff ON tblStaff.staffID=tblStaffPost.StaffID
			INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID AND tblRank.Weight <> 0
			INNER JOIN tblStaffQs ON tblStaffQs.TypeID = @qtID AND tblStaff.staffID = tblStaffQs.StaffID
			INNER JOIN tblQs ON tblStaffQs.QID = tblQs.QID
			INNER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
			WHERE tblPost.hrcID=@hrcID
	
			ORDER BY tblStaff.staffID
		
		FETCH NEXT FROM un1 INTO @qtID		
		
	END

CLOSE un1
DEALLOCATE un1

----------------------------------------------------------------------------------------------------

INSERT INTO #tempstaff
	SELECT tblStaff.staffID, tblPost.assignno, tblStaff.serviceno, tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblPost.description
	FROM #tempunit
	INNER JOIN tblPost ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblRank ON tblRank.rankID =tblPost.rankID AND tblRank.Weight <> 0
	INNER JOIN tblStaffPost ON tblStaffPost.postID=tblPost.postID
	INNER JOIN tblStaff ON tblStaff.staffID = tblStaffPost.StaffID AND tblStaff.rankID=tblRank.rankID
	WHERE (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) AND (tblPost.Ghost = 0)
	ORDER BY tblRank.Weight

----------------------------------------------------------------------------------------------------

INSERT INTO #temparea
SELECT sp.staffID, u.hrcname AS unit, p.hrcname AS parent
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblHierarchy u ON u.hrcID = p1.hrcID
	LEFT JOIN tblHierarchy p ON p.hrcID = u.hrcparentID
	WHERE (sp.enddate IS NULL OR sp.enddAte >= GETDATE())
/*****************
	SELECT sp.staffID, s.description as squadron, w.description as wing, g.description as group1
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblTeam t1 ON p1.teamID = t1.teamID
	LEFT JOIN tblTeam t2 ON t1.parentID = t2.teamID
	LEFT JOIN tblTeam t3 ON t2.parentID = t3.teamID
	LEFT JOIN tblFlight f ON t3.parentID = f.fltID
	LEFT JOIN tblSquadron s ON f.sqnID = s.sqnID
	LEFT JOIN tblWing w ON s.wingId = w.wingID
	LEFT JOIN tblGroup g ON w.grpID = g.grpID
	WHERE (t1.teamIn = 5) AND (sp.enddate IS NULL) OR (sp.enddAte >= GETDATE())
	
	
	UNION
	
	
	SELECT sp.staffID, s.description, w.description, g.description
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblTeam t1 ON p1.teamID = t1.teamID
	LEFT JOIN tblTeam t2 ON t1.parentID = t2.teamID
	LEFT JOIN tblFlight f ON t2.parentID = f.fltID
	LEFT JOIN tblSquadron s ON f.sqnID = s.sqnID
	LEFT JOIN tblWing w ON s.wingId = w.wingID
	LEFT JOIN tblGroup g ON w.grpID = g.grpID
	WHERE (t1.teamIn = 4) AND (sp.enddate IS NULL) OR (sp.enddAte >= GETDATE())
	
	
	UNION
	
	
	SELECT sp.staffID, s.description, w.description, g.description
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblTeam t1 ON p1.teamID = t1.teamID
	LEFT JOIN tblFlight f ON t1.parentID = f.fltID
	LEFT JOIN tblSquadron s ON f.sqnID = s.sqnID
	LEFT JOIN tblWing w ON s.wingId = w.wingID
	LEFT JOIN tblGroup g ON w.grpID = g.grpID
	WHERE (t1.teamIn = 3) AND (sp.enddate IS NULL) OR (sp.enddAte >= GETDATE())
	
	
	UNION
	
	
	SELECT  sp.staffID, NULL, w.description, g.description
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblTeam t1 ON p1.teamID = t1.teamID
	LEFT JOIN tblSquadron s ON t1.parentID = s.sqnID
	LEFT JOIN tblWing w ON s.wingID = w.wingID
	LEFT JOIN tblGroup g ON w.grpID = g.grpID
	WHERE (t1.teamIn = 2) AND (sp.enddate IS NULL) OR (sp.enddAte >= GETDATE())
	
	
	UNION
	
	
	SELECT  sp.staffID, NULL, NULL, g.description
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblTeam t1 ON p1.teamID = t1.teamID
--	INNER JOIN #tempunit ON p1.teamID = #tempunit.tmID
	LEFT JOIN tblWing w ON t1.parentID = w.wingID
	LEFT JOIN tblGroup g ON w.grpID = g.grpID
	WHERE (t1.teamIn = 1) AND (sp.enddate IS NULL) OR (sp.enddAte >= GETDATE())
*******/
----------------------------------------------------------------------------------------------------

INSERT INTO #templist
	SELECT #tempstaff.staffID, #tempstaff.assignno, #tempstaff.serviceno, #tempstaff.rank, #tempstaff.surname, #tempstaff.firstname, #temparea.hrcparent, 
	       #temparea.hrcname, #tempstaff.post, dateadd(d, #tempq.days, #tempq.expiry) AS expiry, #tempq.qdesc, #tempq.longdesc, #tempq.authname
	FROM #tempstaff
	INNER JOIN #tempq ON #tempstaff.staffID = #tempq.staffID
	INNER JOIN #temparea ON #tempstaff.staffID = #temparea.staffID

----------------------------------------------------------------------------------------------------

SELECT * FROM #templist

DROP TABLE #tempunit
DROP TABLE #tempqt
DROP TABLE #tempstaff
DROP TABLE #temparea
DROP TABLE #tempq
DROP TABLE #templist
GO
/****** Object:  StoredProcedure [dbo].[spGetAvailStages]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- This will select the stages available to be added


CREATE         PROCEDURE [dbo].[spGetAvailStages]
@RecID int

AS

SELECT tblCycleStage.description, tblcycleStage.cysID
   FROM tblcycleStage
    WHERE NOT EXISTS(SELECT cytID FROM tblcyclesteps WHERE 
                     (tblcyclesteps.cysID = tblCycleStage.cysID AND
                     tblcyclesteps.cyID = @RecID))
GO
/****** Object:  StoredProcedure [dbo].[spGetAllStages]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- This will select All stages attached to a cyle record


CREATE   PROCEDURE [dbo].[spGetAllStages]

AS

SELECT tblCycleStage.cysID, 
       tblCycleStage.description AS Stage, 
       tblCycleSteps.cytStep AS Step, 
       tblCycleSteps.cyID,
       tblCycleSteps.cysID AS stcysID, 
       tblCycleSteps.cytID
   FROM tblCycleSteps 
    INNER JOIN tblCycleStage ON
     tblCycleStage.cysID = tblCycleSteps.cysID
       ORDER by tblCycleSteps.cyID, tblCycleSteps.cytStep
GO
/****** Object:  StoredProcedure [dbo].[spGetAllCycles]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- This will select All Cycles that have attached Stages


CREATE  PROCEDURE [dbo].[spGetAllCycles]

AS

SELECT DISTINCT tblCycle.cyID, 
       tblCycle.Description 
   FROM tblCycleSteps
   INNER JOIN tblCycle ON
    tblCycle.cyID = tblCycleSteps.cyID
GO
/****** Object:  StoredProcedure [dbo].[spGetAEReport]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spGetAEReport] 

@servNo VARCHAR(15)

AS
 -- DECLARE @servNo VARCHAR(15)
 -- SET @servNo = 'R8413691'
	DECLARE @staffID INT
	SET @staffID = (SELECT TOP 1 staffID FROM tblStaff WHERE serviceno = @servNo)
   
    SELECT tblStaff.staffID, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblRank.shortDesc, tblStaff.mesID, tblMES.description AS mesDesc
	FROM tblStaff LEFT OUTER JOIN tblMES ON tblStaff.mesID = tblMES.mesID LEFT OUTER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
	WHERE staffID = @staffID

CREATE TABLE #ttblAERep( 
	theType VARCHAR(1),
	ID INT,
	[Desc] VARCHAR(20),
	ValidFrom DATETIME,
	vpdays INT,
	Amber INT
)

DECLARE @ValidFrom DATETIME

DECLARE CURSORNAME CURSOR
FOR 

--SELECT statement to loop through goes here

SELECT 'A' AS theType, tblQs.QID AS ID, tblQs.Description, tblValPeriod.vpdays, tblQs.Amber
FROM tblQs LEFT OUTER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID  
WHERE tblQs.QID IN ('334','335')
	UNION 
SELECT 'B' AS theType, tblMilitarySkills.MSID AS ID, tblMilitarySkills.Description, tblValPeriod.vpdays, tblMilitarySkills.Amber
FROM tblMilitarySkills LEFT OUTER JOIN tblValPeriod ON tblMilitarySkills.vpID = tblValPeriod.vpID 
WHERE tblMilitarySkills.MSID IN ('15','44')
	UNION 
SELECT 'C' AS theType, tblFitness.FitnessID AS ID, tblFitness.Description, tblValPeriod.vpdays, 0 AS Amber
FROM tblFitness LEFT OUTER JOIN tblValPeriod ON tblFitness.vpID = tblValPeriod.vpID 
WHERE tblFitness.FitnessID IN ('7','15')

OPEN CURSORNAME

-- Declare your variables to host the selected firelds from the select statement

DECLARE @theType VARCHAR(1)
DECLARE @ID INT
DECLARE @Desc VARCHAR(20)
DECLARE @vpDays INT
DECLARE @Amber INT

FETCH NEXT FROM CURSORNAME INTO @theType, @ID, @Desc, @vpDays, @Amber
WHILE @@FETCH_STATUS = 0

BEGIN
	
	SET @ValidFrom = NULL;
	
	IF @theType = 'A' AND @ID IN ('334','335')
	BEGIN
		SELECT @ValidFrom = ValidFrom FROM tblStaffQs WHERE staffID = @staffID AND QID = @ID
	END
	ELSE IF @theType = 'B' AND @ID IN ('15','44')
	BEGIN
		SELECT @ValidFrom = ValidFrom FROM tblStaffMilSkill WHERE staffID = @staffID AND MSID = @ID
	END
	ELSE IF @theType = 'C' AND @ID IN ('7','15')
	BEGIN
		SELECT @ValidFrom = ValidFrom FROM tblStaffFitness WHERE staffID = @staffID AND FitnessID = @ID
	END
	
	INSERT INTO #ttblAERep
	VALUES(@theType,@ID,@Desc,@ValidFrom, @vpDays, @Amber)

	FETCH NEXT FROM CURSORNAME INTO @theType, @ID, @Desc, @vpDays, @Amber
END

CLOSE CURSORNAME 
DEALLOCATE CURSORNAME 


IF (SELECT ValidFrom FROM #ttblAERep WHERE theType = 'C' AND ID = 15) IS NULL OR ((SELECT ValidFrom FROM #ttblAERep WHERE theType = 'C' AND ID = 15) IS NULL AND (SELECT ValidFrom FROM #ttblAERep WHERE theType = 'C' AND ID = 7) IS NULL)
BEGIN
	DELETE FROM #ttblAERep WHERE theType = 'C' AND ID = 15
END
ELSE IF(SELECT ValidFrom FROM #ttblAERep WHERE theType = 'C' AND ID = 7) IS NULL
BEGIN
	DELETE FROM #ttblAERep WHERE theType = 'C' AND ID = 7
END

SELECT * FROM #ttblAERep ORDER BY theType
DROP TABLE #ttblAERep
GO
/****** Object:  StoredProcedure [dbo].[spFltTeamPosts]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- get all the posts for the teams in the current squadron (sqnID = @levelID  level = 2)
CREATE   PROCEDURE [dbo].[spFltTeamPosts]
@posts    VARCHAR(8000) OUTPUT,
@parentID VARCHAR(50),
@level    VARCHAR(2)

AS

DECLARE @ID int
DECLARE @teamID INT
DECLARE @list VARCHAR (1000)

DECLARE team CURSOR SCROLL FOR
  SELECT tblpost.postID from tblteam 
    INNER JOIN tblpost ON
               tblpost.teamid = tblteam.teamid   
               WHERE  tblTeam.parentid = @parentID
                       AND
                       tblTeam.teamin = @level

OPEN team

-- now get the all the postid's
FETCH FIRST FROM team INTO @ID

WHILE @@FETCH_STATUS = 0
  BEGIN
     IF @posts IS NULL
          SET @posts = '''' + cast(@ID as char(3)) + ''''
     ELSE
     BEGIN
          SET @posts = @posts + ',' + '''' + cast(@ID as char(3)) + ''''
     END

     -- now get the next post
     FETCH NEXT FROM team INTO @ID

  END

CLOSE team
DEALLOCATE team

-- now we have all the flight posts so get the team posts ( level 4)
DECLARE team CURSOR SCROLL FOR
  SELECT tblTeam.TeamID from tblteam 
       WHERE  tblTeam.parentid = @parentID
              AND
              tblTeam.teamin = @level

OPEN team

FETCH FIRST FROM team INTO @ID
-- now go through all the sub-Teams for this Team  
-- this will give us all the posts for each Team at the next (lowest) level ( 5)
SET @level = @level + 1
WHILE @@FETCH_STATUS = 0
  BEGIN
    -- EXEC spTeamPosts @list OUTPUT, @parentID = @ID, @level = @level
    SET @list = NULL
    DECLARE subtm CURSOR SCROLL FOR
       SELECT tblpost.postID from tblteam 
         INNER JOIN tblpost ON
               tblpost.teamid = tblteam.teamid   
         WHERE  tblTeam.parentid = @ID
                AND
                tblTeam.teamin = @level

    OPEN subtm

    -- now get the first sub-team
    FETCH FIRST FROM subtm INTO @teamID
    WHILE @@FETCH_STATUS = 0
    BEGIN

       -- now add the posts for this sub-team to list
       IF @list IS NULL
          SET @list = '''' + cast(@teamID as char(3)) + ''''
       ELSE
        BEGIN
          SET @list = @list + ',' + '''' + cast(@teamID as char(3)) + ''''
        END

       -- now get the first sub-team
       FETCH NEXT FROM subtm INTO @teamID

    END
 
    CLOSE subtm
    DEALLOCATE subtm

    -- now add the posts for this flight to list
    IF @list IS NOT NULL
     BEGIN
       IF @posts IS NULL
          SET @posts = @list
       ELSE
        BEGIN
          SET @posts = @posts + ',' + @list
        END
     END

   -- now get the next flight for this squadron
   FETCH NEXT FROM team INTO @ID

  END

CLOSE team
DEALLOCATE team
GO
/****** Object:  StoredProcedure [dbo].[spFlightInsert]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spFlightInsert]
(
	@sqnID		INT,
	@Description	VARCHAR(50),
	@blnExists	BIT OUTPUT
)

AS

SET NOCOUNT ON

IF EXISTS (SELECT Description FROM tblFlight WHERE Description = @Description)
	BEGIN
		SET @blnExists = 1
	END
ELSE
	BEGIN
		INSERT INTO tblFlight (Description, sqnID)
		VALUES (@Description, @sqnID)

		SET @blnExists = 0
	END

IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spFlightDetail]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create        PROCEDURE [dbo].[spFlightDetail]
@RecID int
as

select tblFlight.fltID, tblFlight.sqnID, tblFlight.description, tblsquadron.description sqn from tblFlight
  inner join tblsquadron ON
     tblFlight.sqnID = tblSquadron.sqnID
       where fltID=@RecID
GO
/****** Object:  StoredProcedure [dbo].[spFlightDel]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[spFlightDel]
@recID int,
@DelOK int OUTPUT
as

-- has it got a team assigned to it
IF EXISTS (SELECT TOP 1 teamID from tblTeam WHERE (tblTeam.parentID = @recID AND tblTeam.teamIn= '3'))    
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spFitnessUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFitnessUpdate]
@recid 		int,
@Description	varchar(100),
@VPID		int,
@Combat		bit

AS

UPDATE tblFitness SET
	Description = @Description,
	vpID = @VPID,
	Combat = @Combat
	WHERE fitnessID = @recid
GO
/****** Object:  StoredProcedure [dbo].[spFitnessInsert]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFitnessInsert]
@nodeID INT,
@Description	VARCHAR (100),
@VPID 		INT,
@Combat		BIT

AS

  INSERT tblFitness (ndeID, Description, vpID, Combat)
             VALUES (@nodeID,@Description, @VPID, @Combat)
GO
/****** Object:  StoredProcedure [dbo].[spFitnessDetails]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFitnessDetails]
@RecID int
as


		
		SELECT     dbo.tblStaff.staffID,staffFitnessID, dbo.tblFitness.description, ValidFrom, validTo,competent
		FROM         dbo.tblStaff INNER JOIN
                dbo.tblStaffFitness ON dbo.tblStaff.staffID = dbo.tblStaffFitness.staffID INNER JOIN
                dbo.tblFitness ON dbo.tblStaffFitness.FitnessID = dbo.tblFitness.FitnessID
		where  dbo.tblStaff.staffID=@recid
		order by description
GO
/****** Object:  StoredProcedure [dbo].[spFitnessDetail]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFitnessDetail]
@RecID	int

AS

SELECT fitnessID,dbo.tblFitness.description , dbo.tblFitness.vpID, dbo.tblValPeriod.description AS ValidityPeriod, Combat
   FROM dbo.tblFitness 
   INNER JOIN dbo.tblValPeriod ON dbo.tblFitness.vpID = dbo.tblValPeriod.vpID
    WHERE fitnessID = @RecID
GO
/****** Object:  StoredProcedure [dbo].[spFitnessDel]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE     PROCEDURE [dbo].[spFitnessDel]
@recID int,
@DelOK int OUTPUT
as

-- has it got staff assigned to it
IF EXISTS (SELECT TOP 1 staffID from tblStafffitness WHERE tblStafffitness.fitnessID = @recID)    
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spFitnessAvailable]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spFitnessAvailable]

@nodeID INT,
@StaffID INT

AS

  SELECT FitnessID, [description]  FROM tblFitness
		WHERE NOT EXISTS (SELECT FitnessID FROM tblStaffFitness WHERE tblFitness.FitnessID = tblStaffFitness.FitnessID and staffID =@StaffID)
		     -- AND tblFitness.ndeID=@nodeID
		ORDER BY  tblFitness.[description]
GO
/****** Object:  StoredProcedure [dbo].[spEnduringQs]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spEnduringQs]
@nodeID INT
AS

	SELECT qID, description FROM tblQs WHERE ndeID=@nodeID AND enduring = 1
GO
/****** Object:  StoredProcedure [dbo].[spDentalUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDentalUpdate]
@recid		int,
@Description	varchar (100),
@VPID		int,
@Combat		bit

AS

UPDATE tblDental SET
Description = @Description,
vpID = @VPID,
Combat = @Combat
WHERE DentalID = @recid
GO
/****** Object:  StoredProcedure [dbo].[spDentalInsert]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDentalInsert]
@nodeID INT,
@Description	varchar (100),
@VPID		int,
@Combat		bit

AS

INSERT tblDental (ndeID, Description, vpID, Combat)
          VALUES (0, @Description, @VPID, @Combat)
GO
/****** Object:  StoredProcedure [dbo].[spDentalDetails]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDentalDetails]
@RecID int
as


		
		SELECT     dbo.tblStaff.staffID,staffDentalID, dbo.tblDental.description, ValidFrom, validTo,competent
		FROM         dbo.tblStaff INNER JOIN
                dbo.tblStaffDental ON dbo.tblStaff.staffID = dbo.tblStaffDental.staffID INNER JOIN
                dbo.tblDental ON dbo.tblStaffDental.DentalID = dbo.tblDental.DentalID
		where  dbo.tblStaff.staffID=@recid
		order by description
GO
/****** Object:  StoredProcedure [dbo].[spDentalDetail]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDentalDetail]
@RecID	int

AS

SELECT DentalID,dbo.tblDental.description , dbo.tblDental.vpID, dbo.tblValPeriod.description AS ValidityPeriod, Combat
FROM dbo.tblDental INNER JOIN dbo.tblValPeriod ON dbo.tblDental.vpID = dbo.tblValPeriod.vpID
WHERE DentalID = @RecID
GO
/****** Object:  StoredProcedure [dbo].[spDentalDel]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE      PROCEDURE [dbo].[spDentalDel]
@recID int,
@DelOK int OUTPUT
as

-- has it got staff assigned to it
IF EXISTS (SELECT TOP 1 staffID from tblStaffDental WHERE tblStaffDental.dentalID = @recID)    
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spDentalAvailable]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spDentalAvailable]
@nodeID INT,
@StaffID INT

AS
 
 SELECT DentalID, [description]  FROM tblDental
		WHERE --tblDental.ndeID=@nodeID AND
		      NOT EXISTS (SELECT DentalID FROM tblStaffDental WHERE tblDental.DentalID = tblStaffDental.DentalID and staffID =@StaffID)
		  ORDER BY tblDental.[description]
GO
/****** Object:  StoredProcedure [dbo].[spDeleteRec]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spDeleteRec]
@RecID INT,
@tabRecID varchar(50),
@tablename varchar(50)

as

DECLARE @str varchar(255)

-- start Transaction - cos if its the staff table we also want to delete the
-- related password record

BEGIN TRANSACTION

  SELECT @str = 'DELETE FROM ' + @tablename +  + ' where ' + @tabRecID + ' = ' + CAST(@RecID AS VARCHAR(10))

  EXEC(@str)

  IF @tablename = 'tblStaff'
    BEGIN
       
       DELETE FROM tblPassword WHERE tblPassword.staffID = @RecID
    END

COMMIT
GO
/****** Object:  StoredProcedure [dbo].[spDeletePost]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeletePost]
(
	@RecID		VARCHAR(20),
	@DelOK		INT
)

AS
 
SET NOCOUNT ON

UPDATE tblStaff SET
tblStaff.postID = NULL
WHERE tblStaff.postID = @RecID

-- so we don't leave stafpost etails loafing around - this for Ghost Posts only
-- cos real posts can't be deleted once there is a posting history
DELETE FROM tblPost WHERE tblPost.postID = @RecID
DELETE FROM tblStaffPost WHERE tblStaffPost.postID = @RecID
DELETE FROM tblPostQs WHERE tblPostQs.postID = @RecID
DELETE FROM tblPostMilSkill WHERE tblPostMilSkill.postID = @RecID

IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spDeleteOK]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spDeleteOK]
 @Recid    int,
 @table    varchar(50),
 @tableID  varchar(50),
 @where    varchar (200),
 @delOK    int OUTPUT

AS
 IF EXISTS (SELECT wingID from tblWing WHERE tblWing.grpID = @recID) 
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spCyStageUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create       PROCEDURE [dbo].[spCyStageUpdate]
@RecID int,
@Description varchar (50)


as

update tblCycleStage 
  set description = @description
   where tblcyclestage.cysid = @recid
GO
/****** Object:  StoredProcedure [dbo].[spCyStageInsert]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       PROCEDURE [dbo].[spCyStageInsert]
@Description varchar (50)


as

insert tblCycleStage (Description)
values (@Description)
GO
/****** Object:  StoredProcedure [dbo].[spCyStageDel]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE    PROCEDURE [dbo].[spCyStageDel]
@recID int,
@DelOK int OUTPUT
as

-- Check to see if cycle is assigned to a team
IF EXISTS (SELECT TOP 1 cytID from tblCycleSteps WHERE tblCycleSteps.cysID = @recID ) 
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spCycleUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[spCycleUpdate]
@RecID int,
@days int,
@Description varchar (50)


as

update tblCycle 
  set cydays = @days, description = @description
   where tblcycle.cyid = @recid
GO
/****** Object:  StoredProcedure [dbo].[spCycleStageUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       PROCEDURE [dbo].[spCycleStageUpdate]
@RecID int,
@Description varchar (50)


as

update tblCycleStage 
  set description = @description
   where tblcyclestage.cysid = @recid
GO
/****** Object:  StoredProcedure [dbo].[spCycleInsert]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[spCycleInsert]
@days int,
@Description varchar (50)


as

insert tblCycle (Description, cydays)
values (@Description, @days)
GO
/****** Object:  StoredProcedure [dbo].[spCycleDel]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spCycleDel]
@recID int,
@DelOK int OUTPUT
as

-- Check to see if cycle is assigned to a team
IF EXISTS (SELECT TOP 1 teamID from tblTeam WHERE tblTeam.cycleID = @recID ) 
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spCreatePopulateTblTeamHierarchy]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCreatePopulateTblTeamHierarchy] as

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblTeamHierarchy]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblTeamHierarchy]


CREATE TABLE [dbo].[tblTeamHierarchy] (
	[teamID] [int]  NOT NULL ,
	[ParentID] [int] NOT NULL,
	[Teamin] [int] NOT NULL 
) ON [PRIMARY]

declare @TeamID int
declare @ParentID int
declare @teamIn int
declare @ParentGroup int
declare @ParentWing int
declare @ParentSqn int
declare @ParentFlight int
declare @ParentTeamAbove int
declare @parentTeam int

DECLARE myCursor CURSOR SCROLL FOR
  SELECT TeamID,ParentID,TeamIn from tblTeam
    
OPEN myCursor

-- now get the all the postid's
FETCH FIRST FROM myCursor INTO @TeamID,@ParentID,@teamIn

WHILE @@FETCH_STATUS = 0
  BEGIN
	if @teamIn= 1
		begin
			set @ParentGroup = (select grpID from tblWing where wingID = @ParentID)
			set @parentTeam = (select TeamID from tblTeam where teamIn=0 and parentID = @ParentGroup)

		end
	if @teamIn= 2
		begin
			set @ParentWing = (select wingID from tblSquadron where sqnID = @ParentID)
			set @parentTeam = (select TeamID from tblTeam where teamIn=1 and parentID = @ParentWing)

		end
	if @teamIn= 3
		begin
			set @ParentSqn = (select sqnID from tblFlight where fltID = @ParentID)
			set @parentTeam = (select TeamID from tblTeam where teamIn=2 and parentID = @ParentSqn)

		end
	if @teamIn= 4 or @teamIn=5
		begin
			set @ParentTeam = (select teamID from tblTeam where TeamID = @ParentID)
		end
			if @parentTeam is null
			begin
				set @parentTeam = 999
			end	
			insert tblTeamHierarchy select @TeamID,@parentTeam,@TeamIn



     -- now get the next post
     FETCH NEXT FROM myCursor INTO @TeamID,@ParentID,@teamIn

  END

CLOSE myCursor
DEALLOCATE myCursor
GO
/****** Object:  StoredProcedure [dbo].[spContingentQs]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spContingentQs]
  @nodeID INT
AS


	SELECT qID, description FROM tblQs WHERE ndeID=@nodeID AND contingent = 1
GO
/****** Object:  StoredProcedure [dbo].[spContactUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************************************************************************************************/
/*      NAME:           	spContactUpdate	                  			   					   			      */
/*      DESCR:         	contact_edit_update.asp - updates the contact from tblContact							                   */
/****************************************************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[spContactUpdate]
(
    @nodeID INT,
	@EmailName 	varchar(30),
	@Email 		varchar(30),
	@MilPhone 	varchar(10),
	@Ext 		varchar(6)
)

AS

SET NOCOUNT ON

BEGIN TRANSACTION
	BEGIN
		UPDATE tblContact 
		 SET EmailName = @EmailName,
		     Email = @Email,
		     MilPhone = @MilPhone,
		     Ext = @Ext
		WHERE tblContact.ndeID = @nodeID
	END
IF @@error <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

COMMIT TRANSACTION

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spContactSelect]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************************************************************************************************/
/*      NAME:           	spContactSelect		                  			   					   			      */
/*      DESCR:         	contact_edit.asp - displays user profile from tblUser									                   */
/****************************************************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[spContactSelect]
(
    @nodeID INT,
	@RetEmailName 	varchar(30) OUTPUT,
	@RetEmail		varchar(30) OUTPUT,
	@RetMilPhone 	varchar(10) OUTPUT,
	@RetExt 		varchar(6) OUTPUT
)
AS
SET NOCOUNT ON
BEGIN TRANSACTION
		BEGIN
			SELECT
			@RetEmailName = EmailName,
			@RetEmail = Email,
			@RetMilPhone = MilPhone, 
			@RetExt = Ext
			FROM tblContact
			WHERE ndeID=@nodeID
		END
IF @@error <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
COMMIT TRANSACTION
SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spContactList]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************************************************************************************************/
/*      NAME:           	spContactList		                  			   					   			      */
/*      DESCR:         	contact.asp - displays the contact from tblContact									                   */
/****************************************************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[spContactList]
@nodeID INT
AS
SELECT ContactID, EmailName, Email, MilPhone, Ext
FROM tblContact
WHERE ndeID = @nodeID
GO
/****** Object:  StoredProcedure [dbo].[spContactDelete]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************************************************************************************************/
/*      NAME:           	spContactDelete		                  			   					   			      */
/*      CREATED BY:    	Alistair Ferguson                           			   					 			  	      */
/*      DESCR:         	contact_delete.asp - updates the contact from tblContact								                   */
/*      DATE:           	15 May 2008                            			  					   			 	      */
/****************************************************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[spContactDelete]
(
	@ContactID	int,
	@EmailName 	varchar(30),
	@Email 		varchar(30),
	@MilPhone 	varchar(10),
	@Ext 		varchar(6)
)
AS
SET NOCOUNT ON
BEGIN TRANSACTION
	BEGIN
		UPDATE tblContact SET
		EmailName = @EmailName,
		Email = @Email,	
		MilPhone = @MilPhone,
		Ext = @Ext
			
		WHERE ContactID = @ContactID
	END
IF @@error <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
COMMIT TRANSACTION
SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spConfigUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConfigUpdate]
(
	@configID		INT,
	@pla		BIT,
	@tas		BIT,
	@man		BIT,
	@per		BIT,
	@uni		BIT,
	@cap		BIT,
	@pre		BIT,
	@fit		BIT,
	@boa		BIT,
	@sch		BIT,
	@nom		BIT,
	@ran		BIT,
	@aut		BIT,
	@ind		BIT,
	@pos		BIT,
	@rod		BIT,
	@paq		BIT
)

AS

BEGIN TRANSACTION
	BEGIN
		UPDATE tblConfig SET
		pla = @pla,
		tas = @tas,
		man = @man, 
		per = @per,
		uni = @uni,
		cap = @cap,
		pre = @pre,
		fit = @fit,
		boa = @boa,
		sch = @sch,
		nom = @nom,
		ran = @ran,
		aut = @aut,
		ind = @ind,
		pos = @pos,
		rod = @rod,
		paq = @paq

		WHERE configID = @configID
	END

IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END

COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [dbo].[spConfigSelect]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConfigSelect]
(
	@configID		INT
)

AS

BEGIN
	SELECT configID, pla, tas, man, per, uni, cap, pre, fit, boa, sch, nom, ran, aut, ind, pos, rod, paq
	FROM tblConfig
	WHERE configID = @configID
END
GO
/****** Object:  StoredProcedure [dbo].[spConfigList]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConfigList]
(
	@nodeID		INT
)

AS

SELECT configID, pla, tas, man, per, uni, cap, pre, fit, boa, sch, nom, ran, aut, ind, pos, rod, paq
FROM tblConfig
WHERE ndeID = @nodeID
GO
/****** Object:  StoredProcedure [dbo].[spConfig]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConfig]
(
	@nodeID		INT
)

AS

SELECT pla, tas, man, per, uni, cap, pre, fit, boa, sch, nom, ran, aut, ind, pos, rod, paq
   FROM tblConfig
     WHERE ndeID = @nodeID
GO
/****** Object:  StoredProcedure [dbo].[spCondFUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  PROCEDURE [dbo].[spCondFUpdate]
@recID int,
@cfmin int,
@cfmax int,
@Description varchar (50)

as

update tblCondFormat 
  set cfminval = @cfmin, cfmaxval = @cfmax, description = @description
   where tblCondFormat.cfid = @recid
GO
/****** Object:  StoredProcedure [dbo].[spCondFInsert]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[spCondFInsert]
@nodeID INT,
@cfmin INT,
@cfmax INT,
@Description VARCHAR (50)


AS

INSERT tblCondFormat (ndeID, cfminval, cfmaxval, Description)
              VALUES (@nodeID, @cfmin, @cfmax, @Description)
GO
/****** Object:  StoredProcedure [dbo].[spCISAuthList]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCISAuthList]
(
	@tmID			INT
)

AS

DECLARE @fltID		INT
DECLARE @sqnID		INT
DECLARE @wingID		INT
DECLARE @groupID		INT
DECLARE @teamIN		INT
DECLARE @rankID		INT
DECLARE @unit   		VARCHAR(25)
DECLARE @StaffID		INT
DECLARE @enddate		DATETIME
DECLARE @remedial		INT
DECLARE @exempt		INT

DECLARE @Posted		INT
DECLARE @Less		INT
DECLARE @Greater		INT
DECLARE @Deployable		INT
DECLARE @Permanent		INT
DECLARE @Temp		INT

DECLARE @first		INT

SET @teamIN = (SELECT teamIN from tblTeam WHERE tblTeam.teamID = @tmID)
SET @unit = (SELECT description from tblTeam WHERE tblTeam.teamID = @tmID)

-- so we know its the first time through the cursor loop below
SET @first=0

-- temp table to hold list of units
CREATE TABLE #tempunit
(
	tmID		INT,
	tmIN		INT,
	tmDesc		VARCHAR(50)
)

-- temp table to hold all ranks within Unit Hierarchy
CREATE TABLE #tempqt
(
	qtID		INT
)

CREATE TABLE #tempq
(
	qID		INT,
	qtID		INT,
	description	VARCHAR(20),
	shortdesc	VARCHAR(50)
)

CREATE TABLE #templist
(
	StaffID		INT
)

INSERT INTO #tempunit
	SELECT teamID, teamIN, description
	FROM tblTeam 
	WHERE tblTeam.teamID = @tmID

-- we are looking at Group level down
IF @teamIN = 0
	BEGIN
		-- first get the GroupID - we need it later
		SET @groupID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @tmID)

		-- now get all the Wings in the Group
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblTeam ON tblTeam.parentID = tblWing.wingID AND tblTeam.teamIN = 1
			WHERE tblWing.grpID = @groupID

		-- now get all the Squadrons in the wing
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
			INNER JOIN tblTeam ON tblTeam.parentID = tblSquadron.sqnID AND tblTeam.teamIN = 2
			WHERE tblWing.grpID = @groupID

		-- now get all flight teams
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID
			INNER JOIN tblTeam ON tblTeam.parentID = tblFlight.fltID AND tblTeam.teamIN = 3
			WHERE tblWing.grpID = @groupID

		-- Now the teams in the flights
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID                  
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
			WHERE tblWing.grpID = @groupID AND tblteam.teamin = 4

		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID                  
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE tblWing.grpID = @groupID AND tblteam.teamin = 5
	END

-- we are looking at Wing level down
IF @teamIN = 1
	BEGIN
		-- first get the WingID - we need it later
		SET @wingID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @tmID)

		-- now get all the Squadrons in the wing
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblSquadron
			INNER JOIN tblTeam ON tblTeam.parentID = tblSquadron.sqnID AND tblTeam.teamIN = 2 
			WHERE tblSquadron.wingID = @wingID

		-- now get all flight teams
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblSquadron
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID                  
			INNER JOIN tblTeam ON tblTeam.parentID = tblFlight.fltID AND tblTeam.teamIN = 3
			WHERE tblSquadron.wingID = @wingID

		-- Now the teams in the flights
		INSERT INTO #tempunit

			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblSquadron
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
			WHERE tblSquadron.wingID = @wingID AND tblteam.teamin = 4

		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblSquadron
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE tblSquadron.wingID = @wingID AND tblteam.teamin = 5
	END

-- we are looking at Sqn level down
IF @teamIN = 2
	BEGIN
		-- first get the sqnID - we need it later
		SET @sqnID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @tmID)

		-- first get all flight teams
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam ON tblTeam.parentID = tblFlight.fltID AND tblTeam.teamIN = 3
			WHERE tblFlight.sqnID = @sqnID

		-- Now the teams in the flight
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
			WHERE tblflight.sqnid=@sqnID AND tblteam.teamin = 4

		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE tblflight.sqnid=@sqnID AND tblteam.teamin = 5
	END

-- we are looking at Flight level down
IF @teamIN = 3
	BEGIN
		-- first get the flightID - we need it later
		SET @fltID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @tmID)

		-- Now the teams in the flight
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
			WHERE tblflight.fltid=@fltID AND tblteam.teamin = 4

		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE tblflight.fltid=@fltID AND tblteam.teamin = 5
	END

-- we are looking at Team level down
IF @teamIN = 4
	BEGIN
		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblTeam AS T2
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE T2.teamID = @tmID AND tblteam.teamin = 5
	END
GO
/****** Object:  StoredProcedure [dbo].[spCheckManager]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE    PROCEDURE [dbo].[spCheckManager]
@RecID int,
@StaffID int,
@manager int OUT
AS

DECLARE @childID INT
DECLARE @hrcID INT
DECLARE @parentID INT
DECLARE @level INT
DECLARE @name VARCHAR(100)


DECLARE @lastlevel INT

SET @childID=@recID  

SET @level = (SELECT hrclevel FROM tblhierarchy WHERE hrcID = @childID)
SET @manager = 0

                     
-- Now we work our way up to the top of the hierarchy
-- but make sure we include all other branches of this part of the tree

WHILE @level >=0 
	  BEGIN             -- we are going from bottom to top of selected Child branch
	     
		 DECLARE hrc1 CURSOR SCROLL
		 FOR SELECT hrcID, hrcparentID FROM tblhierarchy WHERE hrcID = @childID
	     
		 OPEN hrc1
		 FETCH NEXT FROM hrc1 INTO @hrcID, @parentID


		 IF @@FETCH_STATUS = 0
		  BEGIN
		    SET @lastlevel = @level   -- so we now how deep the levels go
		    
		    -- now find out if they are a manager at this level BUT
		    -- check to see if they are in this hierarchy else @manager will be NULL
		    IF EXISTS(SELECT tblStaffPost.staffID FROM tblStaffPost      
                      INNER JOIN tblPost ON tblStaffPost.postID = tblPost.postID      
                      WHERE tblPost.hrcID = @hrcID AND
                            tblStaffPost.staffid = @staffID AND
                            tblStaffPost.startdate < getdate() AND
                            (tblStaffPost.enddate is NULL OR tblStaffPost.enddate >getdate()) )
             
             SET @manager= (SELECT manager FROM tblStaffPost      
                                   INNER JOIN tblPost ON tblStaffPost.postID = tblPost.postID      
                                   WHERE tblPost.hrcID = @hrcID AND
                                         tblStaffPost.staffid = @staffID AND
                                         tblStaffPost.startdate < getdate() AND
                                         (tblStaffPost.enddate is NULL OR tblStaffPost.enddate >getdate()) )
		           
		  END
		 
		 CLOSE hrc1
		 DEALLOCATE hrc1
		     	
    	 -- they're a manager in this Hierarchy so we don't need to go further
    	 IF @manager=1
           SET @level=0
           
        -- now move evrything up a level
		   SET @childID=@parentID
		   SET @level = @level - 1
		
  END
GO
/****** Object:  StoredProcedure [dbo].[spCheckIfTeamMember]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCheckIfTeamMember]

@teamID int,
@staffId int,
@inThisTeam int output

as
if exists (SELECT     dbo.tblStaff.staffID
FROM         dbo.tblStaff INNER JOIN
                      dbo.tblStaffPost ON dbo.tblStaff.staffID = dbo.tblStaffPost.StaffID INNER JOIN
                      dbo.tblPost ON dbo.tblStaffPost.PostID = dbo.tblPost.postID where teamId = @teamID and tblStaff.staffID = @staffID)

or exists(select @StaffID from tblStaff where staffID = @StaffID and Administrator=1) 

begin
	set @inThisTeam = 1
end

else

begin
	set @inThisTeam=0
end
print @inThisTeam
GO
/****** Object:  StoredProcedure [dbo].[spCheckIfServiceNoExists]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[spCheckIfServiceNoExists]
@ServiceNo varchar(100),
@alreadyExists int output
AS

if exists (select staffID from tblstaff where serviceNo = @ServiceNo)
	begin
		set @alreadyExists=1
	end
else

	begin
		set @alreadyExists=0
	end
GO
/****** Object:  StoredProcedure [dbo].[spCheckHQTask]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCheckHQTask]
(
	@StaffID	INT,
	@HQTask		INT OUT
)

AS

DECLARE @teamIn		INT
DECLARE @parentID	INT
DECLARE @teamID		INT
DECLARE @levelID	INT
DECLARE @HQLevel	INT

SET @teamIn = 0

-- first find current team
DECLARE mgr1 CURSOR SCROLL FOR
	SELECT tblTeam.teamID, tblTeam.teamin, tblTeam.parentID 
	FROM tblStaffPost             
	INNER JOIN tblPost on tblStaffPost.postID = tblPost.postID
	INNER JOIN tblTeam ON tblTeam.teamID = tblPost.teamID
	WHERE (tblStaffPost.staffid = @staffID) AND (tblStaffPost.startdate < GETDATE()) AND (tblStaffPost.enddate IS NULL) OR (tblStaffPost.enddate > GETDATE())

OPEN mgr1

FETCH FIRST FROM mgr1 INTO @teamID, @teamIn, @levelID

CLOSE mgr1
DEALLOCATE mgr1

-- If teamIN = 0 then we are already at grp level
IF @teamIN = '0'
	BEGIN
		SET @parentID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @teamID)
	END

-- now check back up the hierarchy to see if HQTasking is set
WHILE (@teamIN > 0)
	BEGIN
		SELECT @parentID =
			CASE @teamIN
			WHEN  '5' THEN
				(SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @levelID)
			WHEN  '4' THEN
				(SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @levelID)
			WHEN '3' THEN
				(SELECT sqnID FROM tblflight WHERE tblflight.fltID = @levelID)
			WHEN '2' THEN
				(SELECT wingID FROM tblsquadron WHERE tblsquadron.sqnID = @levelID)
			WHEN '1' THEN
				(SELECT grpID FROM tblwing WHERE tblwing.wingID = @levelID)
--			WHEN '0' THEN
--				(SELECT grpID FROM tblgroup WHERE tblgroup.grpID = @levelID)

          END

          -- so we can read the parent record on the next iteration
          SET @levelID = @parentID
     
          -- make sure we go up a level in the hierarchy
          SET @teamin = @teamin - 1
END

-- now we should be at Group - level @teamin = 0  - so get the HQTasking flag
SET @HQTask = (SELECT HQTasking FROM tblgroup WHERE tblgroup.grpID = @parentID)
GO
/****** Object:  StoredProcedure [dbo].[spChangePassword]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE                PROCEDURE [dbo].[spChangePassword]

@StaffID INT,
@pswd VARCHAR(10),
@pswdExp INT OUT,
@error INT OUT

AS

SET DATEFORMAT dmy
/* 	This sp gets the Expired number of days and adds it onto todays date to work out the new password 
	expiry date then it updates the users password and password expiry date. 
*/

DECLARE @pswdExpDate DATETIME
SET @error = 0
SET @pswdExp = 90 -- Days till expiry / 

SET @pswdExpDate =  convert(DATETIME,(convert(VARCHAR(10),getDate()+ @pswdExp,3)))

IF (SELECT substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', @pswd)),3,32)) = (SELECT pswd FROM tblPassword WHERE staffID = @StaffID)
BEGIN
	SET @error = 1
END
ELSE
BEGIN
	UPDATE tblPassword
	SET pswd = (SELECT substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', @pswd)),3,32)), expires = @pswdExpDate, dPswd = NULL
	WHERE staffID = @StaffID
END


/****** Object:  StoredProcedure [dbo].[spPeRsInsert]    Script Date: 06/19/2014 11:44:12 ******/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[spCapabilityUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spCapabilityUpdate]
@cpID int,
@cpTitle varchar (50),
@Description varchar (50),
@cpTeam varchar (50),
@cpAerial varchar (50),
@cpOther varchar (50),
@cp5Sqn varchar (50),
@cpGSE varchar (50),
@cpMgt varchar (50)

as

update tblCapability
set cpTitle = @cptitle, Description = @Description,cpTeam = @cpTeam, cpAerial = @cpAerial,
cpOther = @cpOther, cp5Sqn = @cp5Sqn,cpGSE = @cpGSE,
cpMgt = @cpMgt
where cpID=@cpID
GO
/****** Object:  StoredProcedure [dbo].[spCapabilityMinorDetail]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        PROCEDURE [dbo].[spCapabilityMinorDetail]
@RecID int
as

select cpID, CPTitle, Description from tblCapability
       where cpID=@RecID
GO
/****** Object:  StoredProcedure [dbo].[spCapabilityInsert]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCapabilityInsert]

@cpTitle varchar (50),
@Description varchar (50),
@cpTeam varchar (50),
@cpAerial varchar (50),
@cpOther varchar (50),
@cp5Sqn varchar (50),
@cpGSE varchar (50),
@cpMgt varchar (50)

as

insert tblCapability
( cpTitle  , Description ,cpTeam , cpAerial ,
cpOther , cp5Sqn ,cpGSE ,
cpMgt )

values(@cptitle, @Description ,@cpTeam, @cpAerial,
@cpOther, @cp5Sqn,@cpGSE,
@cpMgt)
GO
/****** Object:  StoredProcedure [dbo].[spCapabilityDetail]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        PROCEDURE [dbo].[spCapabilityDetail]
@RecID int
as

select * from tblCapability
       where cpID=@RecID
GO
/****** Object:  StoredProcedure [dbo].[spCapabilityCategorySummary]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCapabilityCategorySummary]
@RecID int
as
Declare @CategoryID int
set @CategoryID=2

SELECT     tblCapabilityCategory.shortDesc as Category FROM dbo.tblCapabilityCategory where  dbo.tblCapabilityCategory.CpCatID = 1

SELECT count(dbo.tblCapabilityCategoryDetail.detailID) AS DetailCount, dbo.tblCapabilityCategoryDetail.detailID,dbo.tblEquipmentTemp.description
FROM         dbo.tblCapabilityCategoryDetail
inner join dbo.tblEquipmentTemp on dbo.tblEquipmentTemp.equipmentID = dbo.tblCapabilityCategoryDetail.detailID

where dbo.tblCapabilityCategoryDetail.cpID = @RecID and dbo.tblCapabilityCategoryDetail.CategoryID = 1
GROUP BY dbo.tblCapabilityCategoryDetail.detailID,dbo.tblEquipmentTemp.description
order by dbo.tblEquipmentTemp.description

while @CategoryID <8
	Begin

		SELECT     tblCapabilityCategory.shortDesc as Category FROM dbo.tblCapabilityCategory where  dbo.tblCapabilityCategory.CpCatID = @CategoryID

		SELECT     count(dbo.tblCapabilityCategoryDetail.detailID) AS DetailCount, dbo.tblCapabilityCategoryDetail.detailID,dbo.tblPosition.description
		FROM         dbo.tblCapabilityCategoryDetail
		inner join dbo.tblPosition on dbo.tblPosition.positionID = dbo.tblCapabilityCategoryDetail.detailID
		
		where dbo.tblCapabilityCategoryDetail.cpID = @RecID and dbo.tblCapabilityCategoryDetail.CategoryID = @CategoryID
		GROUP BY dbo.tblCapabilityCategoryDetail.detailID,dbo.tblPosition.description
		order by dbo.tblPosition.description
	set @CategoryID=@CategoryID+1
	End

SELECT     tblCapabilityCategory.shortDesc as Category FROM dbo.tblCapabilityCategory where  dbo.tblCapabilityCategory.CpCatID = 8

SELECT     count(dbo.tblCapabilityCategoryDetail.detailID) AS DetailCount, dbo.tblCapabilityCategoryDetail.detailID,dbo.tblGeneralQs.description
FROM         dbo.tblCapabilityCategoryDetail
inner join dbo.tblGeneralQs on dbo.tblGeneralQs.genQID = dbo.tblCapabilityCategoryDetail.detailID

where dbo.tblCapabilityCategoryDetail.cpID = @RecID and dbo.tblCapabilityCategoryDetail.CategoryID = 8
GROUP BY dbo.tblCapabilityCategoryDetail.detailID,dbo.tblGeneralQs.description
order by dbo.tblGeneralQs.description


SELECT     tblCapabilityCategory.shortDesc as Category FROM dbo.tblCapabilityCategory where  dbo.tblCapabilityCategory.CpCatID = 9

SELECT     count(dbo.tblCapabilityCategoryDetail.detailID) AS DetailCount, dbo.tblCapabilityCategoryDetail.detailID,dbo.tblPosition.description
FROM         dbo.tblCapabilityCategoryDetail
inner join dbo.tblPosition on dbo.tblPosition.positionID = dbo.tblCapabilityCategoryDetail.detailID

where dbo.tblCapabilityCategoryDetail.cpID = @RecID and dbo.tblCapabilityCategoryDetail.CategoryID = 9
GROUP BY dbo.tblCapabilityCategoryDetail.detailID,dbo.tblPosition.description
order by dbo.tblPosition.description
GO
/****** Object:  StoredProcedure [dbo].[spCapabilityCategoryDetails]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spCapabilityCategoryDetails]
@RecID int, @CategoryID int
as




if @CategoryID > 1 and @CategoryID <> 8
	Begin
		select ShortDesc as Category from tblCapabilityCategory where CpCatID = @CategoryID

		SELECT     count(dbo.tblCapabilityCategoryDetail.detailID) AS DetailCount, dbo.tblCapabilityCategoryDetail.detailID,dbo.tblPosition.description
		FROM         dbo.tblCapabilityCategoryDetail
		inner join dbo.tblPosition on dbo.tblPosition.positionID = dbo.tblCapabilityCategoryDetail.detailID
		
		where dbo.tblCapabilityCategoryDetail.cpID = @RecID and dbo.tblCapabilityCategoryDetail.CategoryID = @CategoryID
		GROUP BY dbo.tblCapabilityCategoryDetail.detailID,dbo.tblPosition.description
		order by Description
	End
Else
	Begin
		if @CategoryID =1
			Begin
				select ShortDesc as Category from tblCapabilityCategory where CpCatID = @CategoryID

				SELECT count(dbo.tblCapabilityCategoryDetail.detailID) AS DetailCount, dbo.tblCapabilityCategoryDetail.detailID,dbo.tblEquipmentTemp.description
				FROM         dbo.tblCapabilityCategoryDetail
				inner join dbo.tblEquipmentTemp on dbo.tblEquipmentTemp.equipmentID = dbo.tblCapabilityCategoryDetail.detailID
				
				where dbo.tblCapabilityCategoryDetail.cpID = @RecID and dbo.tblCapabilityCategoryDetail.CategoryID = @CategoryID
				GROUP BY dbo.tblCapabilityCategoryDetail.detailID,dbo.tblEquipmentTemp.description
				order by Description
			End
		Else
			Begin
				select ShortDesc as Category from tblCapabilityCategory where CpCatID = @CategoryID

				SELECT     count(dbo.tblCapabilityCategoryDetail.detailID) AS DetailCount, dbo.tblCapabilityCategoryDetail.detailID,dbo.tblGeneralQs.description
				FROM         dbo.tblCapabilityCategoryDetail
				inner join dbo.tblGeneralQs on dbo.tblGeneralQs.genQID = dbo.tblCapabilityCategoryDetail.detailID
				
				where dbo.tblCapabilityCategoryDetail.cpID = @RecID and dbo.tblCapabilityCategoryDetail.CategoryID = @CategoryID
				GROUP BY dbo.tblCapabilityCategoryDetail.detailID,dbo.tblGeneralQs.description
				order by Description
			End
	End
GO
/****** Object:  StoredProcedure [dbo].[spAddStaffQs]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddStaffQs]
(
	@staffID	INT,
	@QTypeID	INT,
	@QID		INT,
	@QDate		VARCHAR(20),
	@QComp		VARCHAR(20),
	@Auth		VARCHAR(20),
	@UpBy		INT,
	@UpDated	DATETIME
)

AS

SET DATEFORMAT dmy

DECLARE @nodeID INT

SET @nodeID = (SELECT ndeID FROM tblStaff WHERE tblStaff.staffID=@staffID)

INSERT INTO tblStaffQs (StaffID, TypeID, QID, ValidFrom, Competent, AuthName, UpBy, UpDated, ndeID) 
                VALUES (@staffID, @QTypeID, @QID, @QDate, @QComp, @Auth, @UpBy, @UpDated, @nodeID)
GO
/****** Object:  StoredProcedure [dbo].[spAddStaffGroupQs]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddStaffGroupQs]
(
	@serviceno	VARCHAR(50),
	@QTypeID	INT,
	@QID		INT,
	@QDate		VARCHAR(20),
	@QComp		VARCHAR(20),
	@Auth		VARCHAR(20),
	@UpBy		INT,
	@Updated	DATETIME
)

AS

SET DATEFORMAT dmy

DECLARE @StaffID int
DECLARE @nodeID INT

SET @staffID = (SELECT staffId FROM tblStaff WHERE serviceNo = @serviceno)
SET @nodeID = (SELECT ndeID FROM tblStaff WHERE tblStaff.staffID=@staffID)

INSERT INTO tblStaffQs (StaffID, TypeID, QID, ValidFrom, Competent, AuthName, UpBy, Updated,ndeID)
VALUES  (@staffID, @QTypeID, @QID, @QDate, @QComp, @Auth, @UpBy, @Updated,@nodeID)
GO
/****** Object:  StoredProcedure [dbo].[spAddPostQs]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spAddPostQs]
	@PostID		INT,
	@TypeID		INT,
	@QID		INT,
	@Status		VARCHAR(20),
	@Competent		VARCHAR(20)

AS

SET DATEFORMAT dmy

DECLARE @nodeID INT
DECLARE @stype VARCHAR(5)
DECLARE @StatusVal		INT

SET @nodeID = (SELECT ndeID FROM tblPost WHERE tblPost.postID=@PostID)
SET @stype = (SELECT QWType  FROM tblPostQStatus WHERE tblPostQStatus.PostQStatus = @Status)
INSERT INTO tblPostQs (	PostID,	TypeID,	QID,Status,Competent,ndeID) 
               VALUES (	@PostID,@TypeID,@QID,@Status,@Competent,@nodeID)


SET @StatusVal = (SELECT tblQWeight.qwvalue FROM tblPostQStatus 
                      INNER JOIN tblQWeight ON tblPostQStatus.QWType = tblQWeight.qwtype 
                         WHERE tblQWeight.ndeID=@nodeID AND tblQWeight.QWType = @stype)
/**
SET @StatusVal = (SELECT tblQWeight.qwvalue FROM tblPostQStatus 
                      INNER JOIN tblQWeight ON tblPostQStatus.QWType = tblQWeight.qwtype 
                         WHERE tblQWeight.ndeID=@nodeID AND tblPostQStatus.PostQStatus = @Status)
**/

UPDATE tblPost 
 SET QTotal = (QTotal + @StatusVal)
   WHERE PostID = @PostID
GO
/****** Object:  StoredProcedure [dbo].[spAddCyStages]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- This will add new  stages to the current cyle record
-- while retaining any existing stages in the correct order
-- It is used by BOTH Add and Remove stages so there is a possibilty that the Remove
-- process will remove them all so @stages will be blank and none will be added

CREATE  PROCEDURE [dbo].[spAddCyStages]
@RecID int,
@stages varchar (50)

as

declare @pos int
declare @addID int
declare @step int

select @step = '1'

set @pos = charindex(',', @stages, 1)

-- Its all or nothing here
BEGIN TRANSACTION
 
  -- first delete the existing stages
  DELETE FROM tblcyclesteps WHERE tblcyclesteps.cyID = @recid

  IF @@error <> 0
    ROLLBACK TRAN

  -- now add the new ones - this means we will keep them all in the order required
  WHILE @pos > 0
    BEGIN
       set @addID = LTRIM(RTRIM(LEFT(@stages, @pos -1 )))

       INSERT INTO tblCycleSteps (cyID, cysID, cytStep)
                   VALUES(@recID, CAST(@addID AS INT), @step)
       IF @@error <> 0
          ROLLBACK TRAN

       set @stages = RIGHT(@stages, LEN(@stages) - @pos)
       set @pos = charindex(',', @stages, 1)
       set @step = @step + 1
       -- select @addid, @pos, @stages

    END 

COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [dbo].[sp_TaskUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE         PROCEDURE [dbo].[sp_TaskUpdate]

@taskID int,
@ttID int,
@Description varchar (50),
--@startDate varchar (20),
--@endDate varchar (20),
@cancellable int,
@ooaTask int,
@sscID int,
@hqTask int

as

-- Ron 070708  - don't need dates - but keep them for compatability
DECLARE @startDate varchar(50)
DECLARE @endDate varchar(50)

SET @startDate = '01/01/2000'
SET @endDate = '01/01/2050'

update tbl_Task
set ttID=@ttID, Description=@Description, startDate=@startDate, endDate=@endDate,
    cancellable=@cancellable, ooa=@ooaTask, sscID=@sscID, hqTask=@hqTask
where taskID=@taskID
GO
/****** Object:  StoredProcedure [dbo].[sp_ListTaskPersonnelWithDates]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ListTaskPersonnelWithDates]
(
	@recID		INT, 		--taskID
	@startDate	DATETIME,	--start of period to filter
	@endDate	DATETIME	--end of period to filter
)

AS

SET DATEFORMAT dmy

SELECT tbl_TaskStaff.taskStaffID,tbl_Task.taskID, tblStaff.staffID, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tbl_TaskStaff.startDate,tbl_TaskStaff.endDate,tbl_TaskStaff.cancellable, tblPost.description AS Post, tblTeam.description AS TEAM
FROM tbl_Task 
INNER JOIN tbl_TaskStaff ON tbl_Task.taskID = tbl_TaskStaff.taskID 
INNER JOIN tblStaff ON tbl_TaskStaff.staffID = tblStaff.staffID
LEFT OUTER JOIN tblStaffPost ON tblStaffPost.staffID = tblStaff.staffID AND tblStaffPost.enddate IS NULL
LEFT OUTER JOIN tblPost ON tblPost.postID = tblStaffPost.postID
LEFT OUTER JOIN tblTeam ON tblTeam.teamID = tblPost.teamID
WHERE tbl_Task.TaskID = @recID AND tbl_TaskStaff.active = 1 AND tblPost.Ghost = 0 AND (
(tbl_TaskStaff.startDate >= @startDate AND tbl_TaskStaff.startDate <= @endDate)		--these 3 lines
OR													
(tbl_TaskStaff.endDate >= @startDate and tbl_TaskStaff.endDate <= @endDate))		--find all tasks
ORDER BY tblStaff.surname, tbl_TaskStaff.startDate ASC
GO
/****** Object:  StoredProcedure [dbo].[sp_ListTaskPersonnel]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE      PROCEDURE [dbo].[sp_ListTaskPersonnel]
@recID INT
AS

 SELECT     dbo.tbl_TaskStaff.taskStaffID,dbo.tbl_Task.taskID, dbo.tblStaff.staffID, 
            dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.serviceno, 
            dbo.tbl_TaskStaff.startDate, 
            dbo.tbl_TaskStaff.endDate,dbo.tbl_TaskStaff.cancellable
FROM   dbo.tbl_Task 
  INNER JOIN dbo.tbl_TaskStaff ON 
         dbo.tbl_Task.taskID = dbo.tbl_TaskStaff.taskID 
  INNER JOIN
      dbo.tblStaff ON dbo.tbl_TaskStaff.staffID = dbo.tblStaff.staffID
where dbo.tbl_Task.TaskID = @recID and dbo.tbl_TaskStaff.active=1
order by dbo.tblStaff.surname, dbo.tbl_TaskStaff.startDate asc
GO
/****** Object:  StoredProcedure [dbo].[spGroupUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spGroupUpdate]
(
	@GroupID	INT,
	@Description	VARCHAR(50),
	@HQTask		INT,
	@blnExists	BIT OUTPUT
)

AS

SET NOCOUNT ON

UPDATE tblGroup SET
Description = @Description,
HQTasking = @HQTask
WHERE grpID = @GroupID

SET @blnExists = 0

IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spListCapabilityCategoryDetails]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spListCapabilityCategoryDetails]
@RecID int, @CategoryID int
as




if @CategoryID > 1 and @CategoryID <> 8
	Begin
		

		SELECT     dbo.tblCapabilityCategoryDetail.CpCategoryDetalID as DetailID,dbo.tblPosition.description
		FROM       dbo.tblCapabilityCategoryDetail
		inner join dbo.tblPosition on dbo.tblPosition.positionID = dbo.tblCapabilityCategoryDetail.detailID
		
		where dbo.tblCapabilityCategoryDetail.cpID = @RecID and dbo.tblCapabilityCategoryDetail.CategoryID = @CategoryID
		order BY dbo.tblPosition.description
	End
Else
	Begin
		if @CategoryID =1
			Begin
				

				SELECT  dbo.tblCapabilityCategoryDetail.CpCategoryDetalID as detailID,dbo.tblEquipmentTemp.description
				FROM         dbo.tblCapabilityCategoryDetail
				inner join dbo.tblEquipmentTemp on dbo.tblEquipmentTemp.equipmentID = dbo.tblCapabilityCategoryDetail.detailID
				
				where dbo.tblCapabilityCategoryDetail.cpID = @RecID and dbo.tblCapabilityCategoryDetail.CategoryID = @CategoryID
				order BY dbo.tblEquipmentTemp.description
			End
		Else
			Begin
				

				SELECT    dbo.tblCapabilityCategoryDetail.CpCategoryDetalID as detailID,dbo.tblGeneralQs.description
				FROM         dbo.tblCapabilityCategoryDetail
				inner join dbo.tblGeneralQs on dbo.tblGeneralQs.genQID = dbo.tblCapabilityCategoryDetail.detailID
				
				where dbo.tblCapabilityCategoryDetail.cpID = @RecID and dbo.tblCapabilityCategoryDetail.CategoryID = @CategoryID
				order BY dbo.tblGeneralQs.description
			End
	End
GO
/****** Object:  StoredProcedure [dbo].[spHrcDetail]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spHrcDetail]
(
	@hrcID	INT
)

AS

SELECT * FROM tblHierarchy WHERE hrcID=@hrcID
/**
WITH tblChild AS
		(
		  SELECT hrcID, hrcname,hrclevel FROM tblHierarchy WHERE hrcID=@hrcID
		  UNION ALL
		  SELECT tblHierarchy.hrcID,tblHierarchy.hrcname,tblHierarchy.hrclevel  
		   FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
		)
		SELECT * FROM tblChild
		**/
GO
/****** Object:  StoredProcedure [dbo].[spHPUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spHPUpdate]
@RecID int,
@ooaper int,
@ooared int,
@ooaamb int,

@ssaper int,
@ssared int,
@ssaamb int,

@ssbper int,
@ssbred int,
@ssbamb int

as

update tblHarmonyPeriod 
  SET ooaperiod=@ooaper,
      ooared=@ooared,
      ooaamber=@ooaamb,
      ssaperiod=@ssaper,
      ssared=@ssared,
      ssaamber=@ssaamb,
      ssbperiod=@ssbper,
      ssbred=@ssbred,
      ssbamber=@ssbamb
    where tblHarmonyPeriod.hpid = @recid
GO
/****** Object:  StoredProcedure [dbo].[spHPInsert]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[spHPInsert]
@ooaper int,
@ooared int,
@ooaamb int,

@ssaper int,
@ssared int,
@ssaamb int,

@ssbper int,
@ssbred int,
@ssbamb int

as

insert tblHarmonyPeriod 
       (ooaperiod,ooared,ooaamber,ssaperiod,ssared,ssaamber,ssbperiod,ssbred,ssbamber)
values (@ooaper,@ooared,@ooaamb,@ssaper,@ssared,@ssaamb,@ssbper,@ssbred,@ssbamb)
GO
/****** Object:  StoredProcedure [dbo].[spHmGiUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spHmGiUpdate]
(
	@RecID		VARCHAR(50),
	@Description	VARCHAR(50)
)

AS

SET NOCOUNT ON

UPDATE tblHarmonyOverride
  SET Description = @Description 
    WHERE hmovID = @RecID 

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spHmGiInsert]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spHmGiInsert]
(
	@nodeID INT,
	@Description	VARCHAR(50)
)

AS

SET NOCOUNT ON
INSERT tblHarmonyOverride (ndeID, Description)  
                   VALUES (@nodeID, @Description)

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spHierarchyUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spHierarchyUpdate]
(
    @hrcID INT,
	@parentID	INT,
	@hrcName	VARCHAR(50),
	@nodeID INT,
	@blnExists	BIT OUTPUT
)

AS

DECLARE @level INT
DECLARE @oldparentID INT

SET NOCOUNT ON

IF EXISTS (SELECT hrcname FROM tblHierarchy WHERE hrcname = @hrcName AND hrcID <> @hrcID)
	BEGIN
		SET @blnExists = 1
	END
ELSE
 BEGIN
	BEGIN TRANSACTION
	  
	  -- get the existing parent cos if they moved the Hierarchy we need to check if
	  -- old parent has any other children
	  IF NOT EXISTS (SELECT hrcID FROM tblHierarchy WHERE hrcID=@hrcID AND hrcparentID=@parentID)
	   BEGIN
	      SET @oldparentID = (SELECT hrcparentID FROM tblHierarchy WHERE hrcID = @hrcID) 
	   END
	     
	  SET @level=(SELECT hrcLevel FROM tblHierarchy WHERE hrcID = @parentID) + 1
	  
      UPDATE tblHierarchy 
        SET hrcparentID = @parentID,
            hrclevel=@level,
            hrcname=@hrcName
            WHERE hrcID=@hrcID
            
	  SET @blnExists = 0
	  
	  -- now make sure the parent is shown to have children
	  UPDATE tblHierarchy 
	    SET hrcchildren=1 WHERE hrcID=@parentID

      -- If the Hierachy has been moved to a different parent and the OLD parent has no
      -- other children set the flag to 0
      IF NOT EXISTS (SELECT TOP 1 hrcID FROM tblHierarchy WHERE hrcparentID=@oldparentID)
	        UPDATE tblHierarchy 
	          SET hrcchildren=0 WHERE hrcID=@oldparentID
	          
      IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		 
	  COMMIT
  END
  SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spHierarchyInsert]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spHierarchyInsert]
(
	@parentID	INT,
	@hrcName	VARCHAR(50),
	@nodeID INT,
	@blnExists	BIT OUTPUT
)

AS

DECLARE @level INT

SET NOCOUNT ON

IF EXISTS (SELECT hrcname FROM tblHierarchy WHERE hrcname = @hrcName)
	BEGIN
		SET @blnExists = 1
	END
ELSE
	BEGIN
	    
	  SET @level=(SELECT hrcLevel FROM tblHierarchy WHERE hrcID = @parentID) + 1
	  
      INSERT INTO tblHierarchy (teamID,tblID,ndeID,hrcparentID,hrclevel,hrcname,hrcchildren)
	  VALUES (0,0,@nodeID,@parentID, @level,@hrcName,0)

	  SET @blnExists = 0
	  
	  -- now make sure the parent is shown to have children
	  UPDATE tblHierarchy 
	    SET hrcchildren=1 WHERE hrcID=@parentID
	END

IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spHierarchyDel]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spHierarchyDel]
@hrcID int,
@DelOK int OUTPUT
as

-- If Hierarchy has children or posts the we can't delete it
IF (
    EXISTS (SELECT TOP 1 hrcID FROM tblHierarchy WHERE tblHierarchy.hrcID = @hrcID AND tblHierarchy.hrcchildren=1)
    OR
    EXISTS (SELECT TOP 1 hrcID from tblPost WHERE tblPost.hrcID=@hrcID)
    ) 
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spGetTradeHarmonyStatus]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetTradeHarmonyStatus] 
(
	@hrcID		INT,
	@tradeID	INT, 
	@repby		INT,
	@establishment	DEC(5, 2) OUTPUT,
	@strength	DEC(5, 2) OUTPUT,
	@ooatot		INT OUTPUT,
	@bnatot		INT OUTPUT, 
	@ooaavg		DEC(5, 2) OUTPUT,
	@bnaavg		DEC(5, 2) OUTPUT,  
	@ooaredtot	DEC(5, 2) OUTPUT,
	@bnaredtot	DEC(5, 2) OUTPUT,  
	@ooaredavg	DEC(5, 2) OUTPUT,
	@bnaredavg	DEC(5, 2) OUTPUT,     
	@ooapcnt	DEC(5, 2) OUTPUT,     
	@bnapcnt	DEC(5, 2) OUTPUT,      
	@status		DEC(5, 2) OUTPUT
)

AS

-- This Report is by  2=Unit/Rank
-- @repby is Harmony Status reporting parameter 
-- 0=Harmony of Unit Strength  1= Harmony by Unit Establishment
/*
DECLARE @fltID INT
DECLARE @sqnID INT
DECLARE @wingID INT
DECLARE @groupID INT
DECLARE @teamIN INT
*/
DECLARE @gender int
DECLARE @str VARCHAR(2000)
DECLARE @where VARCHAR(2000)

-- Unit strength - number in posts and Unit Establishment - total posts
--DECLARE @strength DEC (5, 2)
--DECLARE @establishment DEC (5, 2)
--DECLARE @strpcnt DEC (5, 2)
--DECLARE @estpcnt DEC (5, 2)

-- total staff who have broken OOA and BNA harmony
--DECLARE @ooaredtot INT
--DECLARE @bnaredtot INT

-- OOA and BNA Harmony Days broken as a %age
-- These are the figures we need to compare against the Unit Harmony Limits
--DECLARE @ooapcnt DEC (5, 2)
--DECLARE @bnapcnt DEC (5, 2)

-- Unit Harmony Target Limits
DECLARE @ooared DEC (5, 2)
DECLARE @ooayel DEC (5, 2)
DECLARE @ooaamb DEC (5, 2)
DECLARE @ooagrn DEC (5, 2)

DECLARE @bnared DEC (5, 2)
DECLARE @bnayel DEC (5, 2)
DECLARE @bnaamb DEC (5, 2)
DECLARE @bnagrn DEC (5, 2)

-- Harmony Period RED days
DECLARE @hpooared DEC (5, 2)
DECLARE @hpssared DEC (5, 2)
DECLARE @hpssbred DEC (5, 2)

-- The Harmony Status itself - the Holy Grail
-- 0 = Green, 1 = Yellow, 2 = Amber, 3 = Red
-- DECLARE @status INT

-- The code starts here
SET @ooaredtot = 0
SET @bnaredtot = 0
SET @ooatot = 0
SET @bnatot = 0

-- first get the Harmony Days that show RED if exceeded
DECLARE hper CURSOR FOR 
	SELECT TOP 1 ooared, ssared, ssbred  FROM tblHarmonyPeriod

OPEN hper

FETCH NEXT FROM hper INTO  @hpooared, @hpssared,@hpssbred

CLOSE hper
DEALLOCATE hper

-- now get the Unit Harmony Limits 
-- these will be used to calculate harmony status
DECLARE hpunit CURSOR FOR 
	SELECT TOP 1 ooared, ooaambmin, ooayelmin, ooagrnmax,bnared, bnaambmin, bnayelmin, bnagrnmax
	FROM tblUnitHarmonyTarget

OPEN hpunit

FETCH NEXT FROM hpunit INTO  @ooared, @ooaamb, @ooayel,@ooagrn, @bnared,@bnaamb,@bnayel, @bnagrn

CLOSE hpunit
DEALLOCATE hpunit

WITH tblChild AS
		(
		  SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
		  UNION ALL
		  SELECT tblHierarchy.hrcID, tblHierarchy.hrcName FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
		)
     SELECT hrcID, hrcname INTO #tmtemp FROM tblChild 

-- now get all the posts in each team  - but ignore the Ghost crap

-- first get the Established Posts
SET @establishment = (SELECT COUNT(*) FROM tblPost
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID 
	WHERE  tblPost.Ghost = 0 AND tblPost.Status = 1 AND tblPost.tradeID = @tradeID)

-- Now get the Actual Strength ie: Only the posts with someone in them
SET @strength= (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID 
	WHERE tblPost.Ghost = 0 AND tblPost.Status = 1 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= getdate()) AND tblStaff.tradeID=@tradeID)

-- get the total OOA days for this Unit/Trade/Rank
SET @ooatot = (SELECT SUM(ddooa) FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID 
	WHERE tblStaff.tradeID = @tradeID AND tblPost.Ghost = 0 AND tblPost.Status = 1 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()))

IF @ooatot IS NULL SET @ooatot = 0

-- now get the total BNA days
SET @bnatot = (SELECT SUM(ddssb) FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID  
	WHERE tblStaff.tradeID = @tradeID AND tblPost.Ghost = 0 AND tblPost.Status = 1 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()))

IF @bnatot IS NULL SET @bnatot = 0

-- now get the total staff breaking OOA Harmony
SET @ooaredtot = (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID  
	WHERE ddooa >= @hpooared  AND tblStaff.tradeID = @tradeID AND tblPost.Ghost = 0 AND tblPost.Status = 1 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()))

-- now get the total staff breakin BNA Harmony
SET @bnaredtot = (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID = tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID  
	WHERE (ddssa >= @hpssared OR ddssb >= @hpssbred) AND tblStaff.tradeID = @tradeID AND tblPost.Ghost = 0 AND tblPost.Status = 1 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()))

-- default to zeros in case all the posts are empty
--SET @estpcnt=0.00
--SET @strpcnt=0.00
SET @ooapcnt=0.00
SET @bnapcnt=0.00
SET @ooaredavg=0.00
SET @bnaredavg=0.00
SET @ooaavg=0.00
SET @bnaavg=0.00

--set @establishment=30
IF @establishment <> 0
	BEGIN
		IF @repby=1   -- Harmony by Unit Establishment
			BEGIN
				SET @ooapcnt= (@ooaredtot  * (100 / @establishment))
				SET @bnapcnt= (@bnaredtot  * (100 / @establishment))
			END
	END

IF @strength <> 0
	BEGIN
		-- now get the Average OOA/BNA days - always against the actual strength
		SET @ooaredavg= (@ooaredtot  / @strength)
		SET @bnaredavg= (@bnaredtot  / @strength)
		SET @ooaavg= (@ooatot  / @strength)
		SET @bnaavg= (@bnatot  / @strength)
		
		IF @repby=0   -- Harmony by Unit Strength
			BEGIN
				SET @ooapcnt= (@ooaredtot  * (100 / @strength))
				SET @bnapcnt= (@bnaredtot  * (100 / @strength))
			END
	END

-- now set the Harmony Status
-- 0 = Green, 1=Yellow, 2=Amber, 3=Red
IF (@ooapcnt >= @ooared OR @bnapcnt >= @bnared)
	SET @status = 3
ELSE IF (@ooapcnt >= @ooaamb OR @bnapcnt >= @bnaamb)
	SET @status = 2
ELSE IF (@ooapcnt >= @ooayel OR @bnapcnt >= @bnayel)
	SET @status = 1
ELSE 
	SET @status = 0

DROP TABLE #tmtemp
GO
/****** Object:  StoredProcedure [dbo].[spGetTeamID]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetTeamID]

@hrcID INT,
@teamID INT OUT

AS

BEGIN
   SET @teamID=(SELECT teamID FROM tblHierarchy WHERE hrcID=@hrcID)
END
GO
/****** Object:  StoredProcedure [dbo].[spGetTeamHarmonyStatus]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetTeamHarmonyStatus] 
(
	@hrcID		INT,
	@repunit	INT, 
	@repby		INT,
	@establishment	DEC(5, 2) OUTPUT,
	@strength	DEC(5, 2) OUTPUT,
	@ooatot		DEC(5, 2) OUTPUT,
	@bnatot		DEC(5, 2) OUTPUT,     
	@ooapcnt	DEC(5, 2) OUTPUT,     
	@bnapcnt	DEC(5, 2) OUTPUT,      
	@status		DEC(5, 2) OUTPUT
)

AS

DECLARE @nodeID INT

SET @nodeID=(SELECT ndeID FROM tblHierarchy WHERE hrcID = @hrcID)

-- @repunit is Report By parameter  0=Unit  1=Unit/Trade  2=Unit/Rank
-- @repby is Harmony Status reporting parameter 
-- 0=Harmony of Unit Strength  1= Harmony by Unit Establishment

DECLARE @fltID INT
DECLARE @sqnID INT
DECLARE @wingID INT
DECLARE @groupID INT
DECLARE @teamIN INT
DECLARE @gender int
DECLARE @str VARCHAR(2000)
DECLARE @where VARCHAR(2000)

-- Unit strength - number in posts and Unit Establishment - total posts
--DECLARE @strength DEC (5, 2)
--DECLARE @establishment DEC (5, 2)
DECLARE @strpcnt DEC (5, 2)
DECLARE @estpcnt DEC (5, 2)

-- total staff who have broken OOA and BNA harmony
--DECLARE @ooatot INT
--DECLARE @bnatot INT

-- OOA and BNA Harmony Days broken as a %age
-- These are the figures we need to compare against the Unit Harmony Limits
--DECLARE @ooapcnt DEC (5, 2)
--DECLARE @bnapcnt DEC (5, 2)

-- Unit Harmony Target Limits
DECLARE @ooared DEC (5, 2)
DECLARE @ooayel DEC (5, 2)
DECLARE @ooaamb DEC (5, 2)
DECLARE @ooagrn DEC (5, 2)

DECLARE @bnared DEC (5, 2)
DECLARE @bnayel DEC (5, 2)
DECLARE @bnaamb DEC (5, 2)
DECLARE @bnagrn DEC (5, 2)

-- Harmony Period RED days
DECLARE @hpooared DEC (5, 2)
DECLARE @hpssared DEC (5, 2)
DECLARE @hpssbred DEC (5, 2)

-- The Harmony Status itself - the Holy Grail
-- 0 = Green, 1 = Yellow, 2 = Amber, 3 = Red
-- DECLARE @status INT

-- The code starts here
SET @ooatot = 0
SET @bnatot = 0

-- first get the Harmony Days that show RED if exceeded
DECLARE hper CURSOR FOR 
    SELECT ooared, ssared, ssbred  FROM tblHarmonyPeriod WHERE ndeID=@nodeID

OPEN hper

FETCH NEXT FROM hper INTO  @hpooared, @hpssared,@hpssbred

CLOSE hper
DEALLOCATE hper

-- now get the Unit Harmony Limits 
-- these will be used to calculate harmony status
DECLARE hpunit CURSOR FOR 
    SELECT ooared, ooaambmin, ooayelmin, ooagrnmax,bnared, bnaambmin, bnayelmin, bnagrnmax
               FROM tblUnitHarmonyTarget
			     WHERE ndeID=@nodeID

OPEN hpunit

FETCH NEXT FROM hpunit INTO  @ooared, @ooaamb, @ooayel,@ooagrn, @bnared,@bnaamb,@bnayel, @bnagrn
CLOSE hpunit
DEALLOCATE hpunit

--set @teamIN = (SELECT teamIN from tblTeam WHERE tblTeam.teamID = @teamID)

CREATE TABLE #tmtemp
(
	tmhrcID	INT,
	tmDesc	VARCHAR(50)
)

INSERT INTO #tmtemp
	SELECT hrcID, hrcname from tblHierarchy 
	WHERE tblHierarchy.hrcID = @hrcID


-- now get all the posts in each team  - but ignore the Ghost crap
-- and ONLY get Service posts   ie: Rank.weight > 0

-- first get the Established Posts  
SET @establishment = (SELECT COUNT(*) FROM tblPost
	INNER JOIN tblRank ON tblRank.rankID=tblPost.rankID  
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.tmhrcID 
	WHERE tblPost.Ghost = 0 AND tblPost.Status = 1 AND tblRank.weight <> 0)

-- Now get the Actual Strength ie: Only the posts with someone in them
SET @strength= (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.tmhrcID 
	WHERE tblPost.Ghost = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= getdate()) AND tblPost.Status = 1 AND tblRank.weight <> 0)

-- now get the total staff breaking OOA Harmony
SET @ooatot = (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID 
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.teamID = #tmtemp.tmhrcID 
	WHERE ddooa >= @hpooared AND tblPost.Ghost = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= getdate()) AND tblPost.Status = 1 AND tblRank.weight <> 0)

IF @ooatot IS NULL SET @ooatot = 0

-- now get the total staff breakin BNA Harmony
SET @bnatot = (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.teamID = #tmtemp.tmhrcID  
	WHERE (ddssa >= @hpssared OR ddssb >= @hpssbred) AND tblPost.Ghost = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= getdate()) AND tblPost.Status = 1 AND tblRank.weight <> 0)

IF @bnatot IS NULL SET @bnatot = 0

-- default to zeros in case all the posts are empty
SET @estpcnt=0.00
SET @strpcnt=0.00
SET @ooapcnt=0.00
SET @bnapcnt=0.00

IF @establishment <> 0
	BEGIN
		SET @estpcnt= (@establishment / 100)
		SET @strpcnt= (@strength * (100 / @establishment))

		IF @repby=1   -- Harmony by Unit Establishment
			BEGIN
				SET @ooapcnt= (@ooatot  * (100 / @establishment))
				SET @bnapcnt= (@bnatot  * (100 / @establishment))
			END
	END

IF @strength <> 0
	BEGIN
		IF @repby=0   -- Harmony by Unit Strength
			BEGIN
				SET @ooapcnt= (@ooatot  * (100 / @strength))
				SET @bnapcnt= (@bnatot  * (100 / @strength))
			END
	END

-- now set the Harmony Status
-- 0 = Green, 1=Yellow, 2=Amber, 3=Red
IF (@ooapcnt >= @ooared OR @bnapcnt >= @bnared)
	SET @status = 3
ELSE IF (@ooapcnt >= @ooaamb OR @bnapcnt >= @bnaamb)
	SET @status = 2
ELSE IF (@ooapcnt >= @ooayel OR @bnapcnt >= @bnayel)
	SET @status = 1
ELSE 
	SET @status = 0

DROP TABLE #tmtemp
GO
/****** Object:  StoredProcedure [dbo].[spGetTaskedDetails]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[spGetTaskedDetails]
@RecID int,
@taskName varchar(50),
@start varchar(20),
@end varchar (20)

as

declare @stDate datetime
declare @enDate datetime

set @stDate = CONVERT(datetime, @start, 103)
set @enDate = CONVERT(datetime, @end, 103)

select tbltasked.description AS Task, tblstaff.surname + ' ' + tblstaff.firstname as staff,
       tbltasked.startdate as stDate , tbltasked.enddate as enDate
     from tbltasked
       inner join tblstaff on 
             tblstaff.staffid = tbltasked.staffid
     where tbltasked.ttID = @recID AND tbltasked.description like @taskname + '%' and
           tbltasked.startdate >= @stDate AND
           tbltasked.enddate <= @enDate
        order by tbltasked.startdate
GO
/****** Object:  StoredProcedure [dbo].[spGetSubPersbyRank]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spGetSubPersbyRank]
(
	@hrcID		INT,
	@rankID	INT
)

AS

DECLARE @unit	VARCHAR(25)
DECLARE @rank	VARCHAR(25)
DECLARE @rankwt	INT
DECLARE @str VARCHAR(2000)
DECLARE @str1 VARCHAR(2000)

-- temp table to hold list of units
WITH tblChild AS 
  ( 
    SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
    UNION ALL 
    SELECT tblHierarchy.hrcID, tblHierarchy.hrcName FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
    )
SELECT hrcID, hrcname INTO #tempunit FROM tblChild 

-- temp table to hold all ranks within Unit Hierarchy
CREATE TABLE #temprank
(
	serviceNo varchar(50),
	rank varchar(50),
	firstname varchar(50),
	surname varchar(50),
	postDesc varchar(50)
)

-- now get the ranks of all the people in each team
INSERT INTO #temprank
	SELECT tblStaff.serviceno, tblRank.shortDesc, tblStaff.firstname, tblStaff.surname, tblPost.description
	FROM #tempunit
	INNER JOIN tblPost ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblStaffPost ON tblStaffPost.postID=tblPost.postID
	INNER JOIN tblStaff ON tblStaff.staffID = tblStaffPost.StaffID AND tblStaff.rankID=@rankID
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID	
	WHERE (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) AND (tblPost.Ghost = 0) 
	ORDER BY tblPost.Description

SELECT * FROM #temprank

DROP TABLE #tempunit
DROP TABLE #temprank
GO
/****** Object:  StoredProcedure [dbo].[spGetStaffTeams]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[spGetStaffTeams] 
@recID INT
AS
select tblTeam.teamID
       FROM tblStaffPost
             INNER JOIN tblPost on tblPost.postID=tblStaffPost.postID
               INNER JOIN tblTeam on tblTeam.teamID = tblPost.TeamID
                   WHERE tblStaffPost.staffID = @recID
GO
/****** Object:  StoredProcedure [dbo].[spGetUnitHP]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[spGetUnitHP]
@nodeID INT

AS

-- should only be 1 - but just to make sure we only get 1
SELECT TOP 1 * FROM tblUnitHarmonyTarget
  WHERE ndeID=@nodeID
GO
/****** Object:  StoredProcedure [dbo].[spGetUnitHarmonyTarget]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE    PROCEDURE [dbo].[spGetUnitHarmonyTarget]
 @nodeID INT
AS

SELECT TOP 1 *  FROM tblUnitHarmonyTarget WHERE ndeID=@nodeID
GO
/****** Object:  StoredProcedure [dbo].[spGetUnitHarmonyReportDetails]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spGetUnitHarmonyReportDetails] 
(
	@teamID		INT,
	@repunit	INT, 
	@repby		INT
)

AS

-- @repunit is Report By parameter  0=Unit  1=Unit/Trade  2=Unit/Rank
-- @repby is Harmony Status reporting parameter 
-- 0=Harmony of Unit Strength  1= Harmony by Unit Establishment

DECLARE @fltID INT
DECLARE @sqnID INT
DECLARE @wingID INT
DECLARE @groupID INT
DECLARE @teamIN INT
DECLARE @gender int
DECLARE @str VARCHAR(2000)
DECLARE @where VARCHAR(2000)

-- Unit strength - number in posts and Unit Establishment - total posts
DECLARE @strength DEC (5, 2)
DECLARE @establishment DEC (5, 2)
DECLARE @strpcnt DEC (5, 2)
DECLARE @estpcnt DEC (5, 2)

-- total staff who have broken OOA and BNA harmony
DECLARE @ooatot INT
DECLARE @bnatot INT

-- OOA and BNA Harmony Days broken as a %age
-- These are the figures we need to compare against the Unit Harmony Limits
DECLARE @ooapcnt DEC (5, 2)
DECLARE @bnapcnt DEC (5, 2)

-- Unit Harmony Target Limits
DECLARE @ooared DEC (5, 2)
DECLARE @ooayel DEC (5, 2)
DECLARE @ooaamb DEC (5, 2)
DECLARE @ooagrn DEC (5, 2)

DECLARE @bnared DEC (5, 2)
DECLARE @bnayel DEC (5, 2)
DECLARE @bnaamb DEC (5, 2)
DECLARE @bnagrn DEC (5, 2)

-- Harmony Period RED days
DECLARE @hpooared DEC (5, 2)
DECLARE @hpssared DEC (5, 2)
DECLARE @hpssbred DEC (5, 2)

-- The Harmony Status itself - the Holy Grail
-- 0 = Green, 1 = Yellow, 2 = Amber, 3 = Red
DECLARE @status INT

-- The code starts here
SET @ooatot = 0
SET @bnatot = 0

-- first get the Harmony Days that show RED if exceeded
DECLARE hper CURSOR FOR 
    SELECT TOP 1 ooared, ssared, ssbred  FROM tblHarmonyPeriod

OPEN hper

FETCH NEXT FROM hper INTO @hpooared, @hpssared,@hpssbred

CLOSE hper
DEALLOCATE hper

-- now get the Unit Harmony Limits 
-- these will be used to calculate harmony status
DECLARE hpunit CURSOR FOR 
	SELECT TOP 1 ooared, ooaambmin, ooayelmin, ooagrnmax, bnared, bnaambmin, bnayelmin, bnagrnmax
	FROM tblUnitHarmonyTarget

OPEN hpunit

FETCH NEXT FROM hpunit INTO @ooared, @ooaamb, @ooayel, @ooagrn, @bnared, @bnaamb, @bnayel, @bnagrn

CLOSE hpunit
DEALLOCATE hpunit

SET @teamIN = (SELECT teamIN FROM tblTeam WHERE tblTeam.teamID = @teamID)

CREATE TABLE #tmtemp
(
	tmID	INT,
	tmIN	INT,
	tmDesc	VARCHAR(50)
)

INSERT INTO #tmtemp
	SELECT teamID, teamIN, description
	FROM tblTeam 
	WHERE tblTeam.teamID = @teamID

-- we are looking at Group level down
IF @teamIN = 0
	BEGIN
		-- first get the GroupID - we need it later
		SET @groupID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @teamID)

		-- now get all the Wings in the Group
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblTeam ON tblTeam.parentID = tblWing.wingID AND tblTeam.teamIN = 1
			WHERE tblWing.grpID = @groupID

		-- now get all the Squadrons in the wing
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
			INNER JOIN tblTeam ON tblTeam.parentID = tblSquadron.sqnID AND tblTeam.teamIN = 2
			WHERE tblWing.grpID = @groupID

		-- now get all flight teams
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID
			INNER JOIN tblTeam ON tblTeam.parentID = tblFlight.fltID AND tblTeam.teamIN = 3
			WHERE tblWing.grpID = @groupID

		-- Now the teams in the flights
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID                  
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
			WHERE tblWing.grpID = @groupID AND tblteam.teamin = 4

		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblWing
			INNER JOIN tblSquadron ON tblSquadron.wingID = tblWing.wingID
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID                  
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE tblWing.grpID = @groupID AND tblteam.teamin = 5
	END

-- we are looking at Wing level down
IF @teamIN = 1
	BEGIN
		-- first get the WingID - we need it later
		SET @wingID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @teamID)

		-- now get all the Squadrons in the wing
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblSquadron
			INNER JOIN tblTeam ON tblTeam.parentID = tblSquadron.sqnID AND tblTeam.teamIN = 2 
			WHERE tblSquadron.wingID = @wingID

		-- now get all flight teams
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblSquadron
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID                  
			INNER JOIN tblTeam ON tblTeam.parentID = tblFlight.fltID AND tblTeam.teamIN = 3
			WHERE tblSquadron.wingID = @wingID

		-- Now the teams in the flights
		INSERT INTO #tempunit

			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblSquadron
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
			WHERE tblSquadron.wingID = @wingID AND tblteam.teamin = 4

		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblSquadron
			INNER JOIN tblFlight ON tblFlight.sqnID = tblSquadron.sqnID
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE tblSquadron.wingID = @wingID AND tblteam.teamin = 5
	END

-- we are looking at Sqn level down
IF @teamIN = 2
	BEGIN
		-- first get the sqnID - we need it later
		SET @sqnID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @teamID)

		-- first get all flight teams
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam ON tblTeam.parentID = tblFlight.fltID AND tblTeam.teamIN = 3
			WHERE tblFlight.sqnID = @sqnID

		-- Now the teams in the flight
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
			WHERE tblflight.sqnid=@sqnID AND tblteam.teamin = 4

		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE tblflight.sqnid=@sqnID AND tblteam.teamin = 5
	END

-- we are looking at Flight level down
IF @teamIN = 3
	BEGIN
		-- first get the flightID - we need it later
		SET @fltID = (SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @teamID)

		-- Now the teams in the flight
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam ON tblTeam.parentID = t1.teamID
			WHERE tblflight.fltid=@fltID AND tblteam.teamin = 4

		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblFlight
			INNER JOIN tblTeam AS t1 ON t1.parentID = tblflight.fltid
			INNER JOIN tblteam AS t2 ON t2.parentID = t1.teamID
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE tblflight.fltid=@fltID AND tblteam.teamin = 5
	END

-- we are looking at Team level down
IF @teamIN = 4
	BEGIN
		-- Now the teams in the team
		INSERT INTO #tempunit
			SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
			FROM tblTeam AS T2
			INNER JOIN tblteam ON tblteam.parentID = t2.teamID
			WHERE T2.teamID = @teamID AND tblteam.teamin = 5
	END

-- now get all the posts in each team  - but ignore the Ghost crap

-- first get the Established Posts
SET @establishment = (SELECT COUNT(*) FROM tblPost
	INNER JOIN #tmtemp ON tblPost.teamID = #tmtemp.tmID 
	WHERE tblPost.Ghost = 0)

-- Now get the Actual Strength ie: Only the posts with someone in them
SET @strength= (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.teamID = #tmtemp.tmID 
	WHERE tblPost.Ghost = 0 AND tblStaffPost.endDate IS NULL)

-- now get the total staff breaking OOA Harmony
SET @ooatot = (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.teamID = #tmtemp.tmID 
	WHERE ddooa >= @hpooared  AND tblPost.Ghost = 0 AND tblStaffPost.endDate IS NULL)

-- now get the total staff breakin BNA Harmony
SET @bnatot = (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.teamID = #tmtemp.tmID  
	WHERE (ddssa >= @hpssared OR ddssb >= @hpssbred )AND tblPost.Ghost = 0 AND tblStaffPost.endDate IS NULL)

-- default to zeros in case all the posts are empty
SET @estpcnt=0.00
SET @strpcnt=0.00
SET @ooapcnt=0.00
SET @bnapcnt=0.00

IF @establishment <> 0
	BEGIN
		SET @estpcnt = (@establishment / 100)
		SET @strpcnt = (@strength * (100 / @establishment))

		IF @repby = 1   -- Harmony by Unit Establishment
			BEGIN
				SET @ooapcnt = (@ooatot  * (100 / @establishment))
				SET @bnapcnt = (@bnatot  * (100 / @establishment))
			END
	END

IF @strength <> 0
	BEGIN
		IF @repby = 0   -- Harmony by Unit Strength
			BEGIN
				SET @ooapcnt = (@ooatot  * (100 / @strength))
				SET @bnapcnt = (@bnatot  * (100 / @strength))
			END
	END

-- now set the Harmony Status
-- 0 = Green, 1=Yellow, 2=Amber, 3=Red
IF (@ooapcnt >= @ooared OR @bnapcnt >= @bnared)
	SET @status = 3
ELSE IF (@ooapcnt >= @ooaamb OR @bnapcnt >= @bnaamb)
	SET @status = 2
ELSE IF (@ooapcnt >= @ooayel OR @bnapcnt >= @bnayel)
	SET @status = 1
ELSE 
	SET @status = 0

SELECT @establishment AS established,
       @strength      AS strength,
       @estpcnt       AS estpcnt ,
       @strpcnt       AS strpcnt ,
       @ooatot        AS ooatot,
       @bnatot        AS bnatot,
       @ooapcnt       AS ooapcnt,
       @bnapcnt       AS bnapcnt,
       @status        AS harmony

DROP TABLE #tmtemp
GO
/****** Object:  StoredProcedure [dbo].[spGetUnitHarmonyLimits]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spGetUnitHarmonyLimits] 

AS

SELECT TOP 1 *  FROM tblUnitHarmonyTarget
GO
/****** Object:  StoredProcedure [dbo].[spGroupInsert]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spGroupInsert]
(
	@Description	VARCHAR(50),
	@HQTask		INT,
	@blnExists	BIT OUTPUT
)

AS

SET NOCOUNT ON

IF EXISTS (SELECT Description FROM tblGroup WHERE Description = @Description)
	BEGIN
		SET @blnExists = 1
	END
ELSE
	BEGIN
		INSERT INTO tblGroup (Description, HQTasking)
		VALUES (@Description, @HQTask)

		SET @blnExists = 0
	END

IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spGroupDetail]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE      PROCEDURE [dbo].[spGroupDetail]
@recID int
as


select * from tblGroup where tblGroup.grpID=@recID
GO
/****** Object:  StoredProcedure [dbo].[spGroupDel]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spGroupDel]
@recID int,
@DelOK int OUTPUT
as

IF EXISTS (SELECT wingID from tblWing WHERE tblWing.grpID = @recID) 
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spGetRunOutDate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetRunOutDate]
(
	@hrcID			INT,
	@QStatus		INT,
	@qualification		VARCHAR(1000),
	@MSStatus		INT,
	@milskill		VARCHAR(1000),
	@VacStatus		INT,
	@vacs			VARCHAR(1000),
	@FitnessStatus		INT,
	@fitness		VARCHAR(1000),
	@DentalStatus		INT,
	@dental		VARCHAR(1000),
	@civi			INT,
	@Gender		INT
)

AS

SET DATEFORMAT dmy

DECLARE @fltID		INT
DECLARE @sqnID		INT
DECLARE @wingID		INT
DECLARE @groupID		INT
DECLARE @teamIN		INT
DECLARE @fitnessID		INT
DECLARE @unit   		VARCHAR(25)

DECLARE @Pass		INT
DECLARE @Remedial		INT
DECLARE @Exempt		INT
DECLARE @Untested		INT

DECLARE @first 		INT
DECLARE @Str			VARCHAR(8000)

SET @teamIN = (SELECT teamIN from tblTeam WHERE tblTeam.teamID = @hrcID)
SET @unit = (SELECT description from tblTeam WHERE tblTeam.teamID = @hrcID)
SET @Str = ''

-- so we know its the first time through the cursor loop below
SET @first = 0
; WITH tblChild AS
  (
    SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
    UNION ALL
    SELECT tblHierarchy.hrcID, tblHierarchy.hrcName FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
  )
  SELECT hrcID, hrcname INTO #tempunit FROM tblChild 
    
--Qualifications
IF @QStatus = 1
	BEGIN
		SET @Str = 'SELECT tblQTypes.Description + '' Q:' + ''' AS Type, tblQs.Description, tblQs.Amber, tblValPeriod.vpdays
		FROM tblQs
		INNER JOIN tblQTypes ON tblQs.QTypeID = tblQTypes.QtypeID
		INNER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
		WHERE tblQs.QID = ' + CONVERT(VARCHAR(3),@qualification) + ''

		SET @Str = @Str + 'SELECT DISTINCT tblStaff.staffID, tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, #tempunit.hrcname , tblStaffQs.ValidFrom
		FROM tblStaff
		INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
		INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
		INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
		INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
		INNER JOIN tblStaffQs ON tblStaff.staffID = tblStaffQs.StaffID
		WHERE (tblStaffQs.QID = ' + CONVERT(VARCHAR(3),@qualification) + ') AND (tblPost.Ghost = 0) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) '
	END

--Military Skills
IF @MSStatus = 1
	BEGIN
		SET @Str = 'SELECT ''' + 'Military Skill:' + ''' AS Type, tblMilitarySkills.description, tblMilitarySkills.Amber, tblValPeriod.vpdays
		FROM tblMilitarySkills
		INNER JOIN tblValPeriod ON tblMilitarySkills.vpID = tblValPeriod.vpID
		WHERE tblMilitarySkills.msID = ' + CONVERT(VARCHAR(3),@milSkill) + ''

		SET @Str = @Str + 'SELECT DISTINCT tblStaff.staffID, tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, #tempunit.hrcname , tblStaffMilSkill.ValidFrom
		FROM tblStaff
		INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
		INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
		INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
		INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
		INNER JOIN tblStaffMilSkill ON tblStaff.staffID = tblStaffMilSkill.StaffID
		WHERE (tblStaffMilSkill.msID = ' + CONVERT(VARCHAR(3),@milskill) + ') AND (tblPost.Ghost = 0) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) '
	END

--Vaccinations
IF @VacStatus = 1
	BEGIN
		SET @Str = 'SELECT ''' + 'Vaccination:' + ''' AS Type, tblMilitaryVacs.description, 0 AS Amber, tblValPeriod.vpdays
		FROM tblMilitaryVacs
		INNER JOIN tblValPeriod ON tblMilitaryVacs.vpID = tblValPeriod.vpID
		WHERE tblMilitaryVacs.mvID = ' + CONVERT(VARCHAR(3),@vacs) + ''

		SET @Str = @Str + 'SELECT DISTINCT tblStaff.staffID, tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, #tempunit.hrcname , tblStaffMVs.ValidFrom
		FROM tblStaff
		INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
		INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
		INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
		INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
		INNER JOIN tblStaffMVs ON tblStaff.staffID = tblStaffMVs.StaffID
		WHERE (tblStaffMVs.mvID = ' + CONVERT(VARCHAR(3),@vacs) + ') AND (tblPost.Ghost = 0) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) '
	END

--Fitness
IF @FitnessStatus = 1
	BEGIN
		SET @Str = 'SELECT ''' + 'Fitness:' + ''' AS Type, tblFitness.Description, 0 AS Amber, tblValPeriod.vpdays
		FROM tblFitness
		INNER JOIN tblValPeriod ON tblFitness.vpID = tblValPeriod.vpID
		WHERE tblFitness.FitnessID = ' + CONVERT(VARCHAR(3),@fitness) + ''

		SET @Str = @Str + 'SELECT DISTINCT tblStaff.staffID, tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, #tempunit.hrcname , tblStaffFitness.ValidFrom
		FROM tblStaff
		INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
		INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
		INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
		INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
		INNER JOIN tblStaffFitness ON tblStaff.staffID = tblStaffFitness.StaffID
		WHERE (tblStaffFitness.FitnessID = ' + CONVERT(VARCHAR(3),@fitness) + ') AND (tblPost.Ghost = 0) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) '
	END

--Dental
IF @DentalStatus = 1
	BEGIN
		SET @str = 'SELECT ''' + 'Dental:' + ''' AS Type, tblDental.Description, 0 AS Amber, tblValPeriod.vpdays
		FROM tblDental
		INNER JOIN tblValPeriod ON tblDental.vpID = tblValPeriod.vpID
		WHERE tblDental.DentalID = ' + CONVERT(VARCHAR(3),@dental) + ''

		SET @Str = @Str + 'SELECT DISTINCT tblStaff.staffID, tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, #tempunit.hrcname , tblStaffDental.ValidFrom
		FROM tblStaff
		INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
		INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
		INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
		INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
		INNER JOIN tblStaffDental ON tblStaff.staffID = tblStaffDental.StaffID
		WHERE (tblStaffDental.DentalID = ' + CONVERT(VARCHAR(3),@dental) + ') AND (tblPost.Ghost = 0) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) '
	END
	
	IF @civi = 0
		BEGIN
			SET @Str = @Str + 'AND tblRank.Weight <> 0'
		END

	IF @Gender = '2'
		BEGIN
	       		SET @Str = @Str + ' AND tblStaff.sex =' + '''' + 'M' + '''' 
		END
	
	IF @Gender = '3'
		BEGIN
			SET @Str = @Str + ' AND tblStaff.sex =' + '''' + 'F' + '''' 
		END
		
	SET @Str = @Str + ' ORDER BY #tempunit.hrcname'

--PRINT(@Str)
EXEC(@Str)
GO
/****** Object:  StoredProcedure [dbo].[spGetRankHarmonyStatus]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetRankHarmonyStatus] 
(
	@hrcID		INT,
	@rankID		INT, 
	@repby		INT,
	@establishment	DEC(5, 2) OUTPUT,
	@strength	DEC(5, 2) OUTPUT,
	@ooatot		INT        OUTPUT,
	@bnatot		INT        OUTPUT, 
	@ooaavg		DEC(5, 2) OUTPUT,
	@bnaavg		DEC(5, 2) OUTPUT,  
	@ooaredtot	DEC(5, 2) OUTPUT,
	@bnaredtot	DEC(5, 2) OUTPUT,  
	@ooaredavg	DEC(5, 2) OUTPUT,
	@bnaredavg	DEC(5, 2) OUTPUT,     
	@ooapcnt	DEC(5, 2) OUTPUT,     
	@bnapcnt	DEC(5, 2) OUTPUT,      
	@status		DEC(5, 2) OUTPUT
)

AS

DECLARE @nodeID INT

SET @nodeID=(SELECT ndeID FROM tblHierarchy WHERE hrcID = @hrcID)

-- This Report is by  2=Unit/Rank
-- @repby is Harmony Status reporting parameter 
-- 0=Harmony of Unit Strength  1= Harmony by Unit Establishment

--DECLARE @fltID INT
--DECLARE @sqnID INT
--DECLARE @wingID INT
--DECLARE @groupID INT
--DECLARE @teamIN INT
DECLARE @gender int
DECLARE @str VARCHAR(2000)
DECLARE @where VARCHAR(2000)

-- Unit strength - number in posts and Unit Establishment - total posts
--DECLARE @strength DEC (5, 2)
--DECLARE @establishment DEC (5, 2)
DECLARE @strpcnt DEC (5, 2)
DECLARE @estpcnt DEC (5, 2)

-- total staff who have broken OOA and BNA harmony
--DECLARE @ooaredtot INT
--DECLARE @bnaredtot INT

-- OOA and BNA Harmony Days broken as a %age
-- These are the figures we need to compare against the Unit Harmony Limits
--DECLARE @ooapcnt DEC (5, 2)
--DECLARE @bnapcnt DEC (5, 2)

-- Unit Harmony Target Limits
DECLARE @ooared DEC (5, 2)
DECLARE @ooayel DEC (5, 2)
DECLARE @ooaamb DEC (5, 2)
DECLARE @ooagrn DEC (5, 2)

DECLARE @bnared DEC (5, 2)
DECLARE @bnayel DEC (5, 2)
DECLARE @bnaamb DEC (5, 2)
DECLARE @bnagrn DEC (5, 2)

-- Harmony Period RED days
DECLARE @hpooared DEC (5, 2)
DECLARE @hpssared DEC (5, 2)
DECLARE @hpssbred DEC (5, 2)

-- The Harmony Status itself - the Holy Grail
-- 0 = Green, 1 = Yellow, 2 = Amber, 3 = Red
-- DECLARE @status INT

-- The code starts here
SET @ooaredtot = 0
SET @bnaredtot = 0
SET @ooatot = 0
SET @bnatot = 0

-- first get the Harmony Days that show RED if exceeded
DECLARE hper CURSOR FOR 
    SELECT ooared, ssared, ssbred  FROM tblHarmonyPeriod WHERE ndeID=@nodeID

OPEN hper

FETCH NEXT FROM hper INTO  @hpooared, @hpssared,@hpssbred

CLOSE hper
DEALLOCATE hper

-- now get the Unit Harmony Limits 
-- these will be used to calculate harmony status
DECLARE hpunit CURSOR FOR 
	SELECT ooared, ooaambmin, ooayelmin, ooagrnmax,bnared, bnaambmin, bnayelmin, bnagrnmax
	  FROM tblUnitHarmonyTarget
	    WHERE ndeID=@nodeID

OPEN hpunit

FETCH NEXT FROM hpunit INTO  @ooared, @ooaamb, @ooayel,@ooagrn, @bnared,@bnaamb,@bnayel, @bnagrn

CLOSE hpunit
DEALLOCATE hpunit

--SET @teamIN = (SELECT teamIN from tblTeam WHERE tblTeam.hrcID = @hrcID)

; WITH tblChild AS
		(
		  SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
		  UNION ALL
		  SELECT tblHierarchy.hrcID, tblHierarchy.hrcName FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
		)
     SELECT hrcID, hrcname INTO #tmtemp FROM tblChild 
     


-- now get all the posts in each team  - but ignore the Ghost crap

-- first get the Established Posts
SET @establishment = (SELECT COUNT(*) FROM tblPost
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID 
	WHERE tblPost.Ghost = 0 AND tblPost.Status = 1 AND tblPost.rankID = @rankID)

-- Now get the Actual Strength ie: Only the posts with someone in them
SET @strength= (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID 
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID 
	WHERE tblPost.Ghost = 0 AND tblPost.Status = 1 AND tblStaff.rankID = @rankID AND (tblStaffPost.endDate IS NULL OR dbo.tblStaffPost.endDate > GETDATE()) AND tblRank.weight <> 0)

-- get the total OOA days for this Unit/Trade/Rank
SET @ooatot = (SELECT SUM(ddooa) FROM tblStaff
	INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID 
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID 
	WHERE tblStaff.rankID = @rankID AND tblPost.Ghost = 0 AND tblPost.Status = 1 AND (tblStaffPost.endDate IS NULL OR dbo.tblStaffPost.endDate > GETDATE()) AND tblRank.weight <> 0)

IF @ooatot IS NULL SET @ooatot = 0

-- now get the total BNA days
SET @bnatot = (SELECT SUM(ddssb) FROM tblStaff
	INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID 
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID  
	WHERE tblStaff.rankID=@rankID AND tblPost.Ghost = 0 AND tblPost.Status = 1 AND (tblStaffPost.endDate IS NULL OR dbo.tblStaffPost.endDate > GETDATE()) AND tblRank.weight <> 0)

IF @bnatot IS NULL SET @bnatot = 0

-- now get the total staff breaking OOA Harmony
SET @ooaredtot = (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID 
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID 
	WHERE ddooa >= @hpooared  AND tblStaff.rankID = @rankID AND tblPost.Ghost = 0 AND tblPost.Status = 1 AND (tblStaffPost.endDate IS NULL OR dbo.tblStaffPost.endDate > GETDATE()) AND tblRank.weight <> 0)

-- now get the total staff breakin BNA Harmony
SET @bnaredtot = (SELECT COUNT(*) FROM tblStaff
	INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID 
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID  
	WHERE (ddssa >= @hpssared OR ddssb >= @hpssbred) AND tblStaff.rankID = @rankID AND tblPost.Ghost = 0 AND tblPost.Status = 1 AND (tblStaffPost.endDate IS NULL OR dbo.tblStaffPost.endDate > GETDATE()) AND tblRank.weight <> 0)

-- default to zeros in case all the posts are empty
SET @estpcnt=0.00
SET @strpcnt=0.00
SET @ooapcnt=0.00
SET @bnapcnt=0.00
SET @ooaredavg=0.00
SET @bnaredavg=0.00
SET @ooaavg=0.00
SET @bnaavg=0.00

IF @establishment <> 0
	BEGIN
		SET @estpcnt= (@establishment / 100)
		SET @strpcnt= (@strength * (100 / @establishment))

		IF @repby=1   -- Harmony by Unit Establishment
			BEGIN
				SET @ooapcnt= (@ooaredtot  * (100 / @establishment))
				SET @bnapcnt= (@bnaredtot  * (100 / @establishment))
			END	
	END

IF @strength <> 0
	BEGIN
		-- now get the Average OOA/BNA days - always against the actual strength
		SET @ooaredavg= (@ooaredtot  / @strength)
		SET @bnaredavg= (@bnaredtot  / @strength)
		SET @ooaavg= (@ooatot  / @strength)
		SET @bnaavg= (@bnatot  / @strength)
		
		IF @repby=0   -- Harmony by Unit Strength
			BEGIN
				SET @ooapcnt= (@ooaredtot  * (100 / @strength))
				SET @bnapcnt= (@bnaredtot  * (100 / @strength))
			END	
	END

-- now set the Harmony Status
-- 0 = Green, 1=Yellow, 2=Amber, 3=Red
IF (@ooapcnt >= @ooared OR @bnapcnt >= @bnared)
	SET @status = 3
ELSE IF (@ooapcnt >= @ooaamb OR @bnapcnt >= @bnaamb)
	SET @status = 2
ELSE IF (@ooapcnt >= @ooayel OR @bnapcnt >= @bnayel)
	SET @status = 1
ELSE 
	SET @status = 0

DROP TABLE #tmtemp
GO
/****** Object:  StoredProcedure [dbo].[spGetPostTeams]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   PROCEDURE [dbo].[spGetPostTeams] 
@recID INT
AS
select tblTeam.teamID
       FROM tblPost
               INNER JOIN tblTeam on tblTeam.teamID = tblPost.TeamID
                   WHERE tblPost.postID = @recID
GO
/****** Object:  StoredProcedure [dbo].[spgetPostStaff]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[spgetPostStaff]
@recID INT
AS

select tblStaffPost.staffPostID, tblStaff.staffid, tblStaffPost.startdate, tblstaffPost.enddate, tblstaff.surname +', ' + tblstaff.firstname AS Name,
       tblPost.postID, tblPost.assignno,tblPost.positiondesc as Position, tblStaff.serviceno,
       tblRank.description as rank, tblTrade.description as trade,tblrankweight.rankwt as rankweight,
       tblPost.description , tblTeam.description as Team, tblpost.notes, tblpost.qoveride, 
       tblpost.msoveride,tblpost.overborne, 
       --(select StaffID from tblStaff inner join tblPost on tblPost.PostID = tblStaff.PostID where  tblPost.postID = @recID) as Vacant
       (select TOP 1 staffPostId from tblStaffPost inner join tblPost on tblPost.PostID = tblStaffPost.PostID where  tblPost.postID = @recID) as Vacant
       FROM tblPost
        LEFT OUTER JOIN tblStaffPost on tblPost.postID = tblStaffPost.postID
        LEFT OUTER JOIN tblStaff on tblStaff.staffID = tblStaffPost.staffID
         LEFT OUTER JOIN tblTeam on tblTeam.teamID = tblPost.TeamID
         LEFT OUTER JOIN tblRank on tblRank.rankID = tblPost.rankID
         LEFT OUTER JOIN tblTrade on tblTrade.tradeID = tblPost.tradeID 
         LEFT OUTER JOIN tblRankweight on tblRankweight.rwID = tblPost.rwID        
         
                   WHERE tblPost.postID = @recID
/**
select * from vwStaffPostHistory     WHERE postID = @recID

select tblPost.postID, tblPost.assignno,tblPost.description , tblTeam.description as Team, (select StaffID from tblStaff inner join tblPost on tblPost.PostID = tblStaff.PostID where  tblPost.postID = @recID) as Vacant
       FROM tblPost
         LEFT OUTER JOIN tblTeam on tblTeam.teamID = tblPost.TeamID
                   WHERE tblPost.postID = @recID

**/
GO
/****** Object:  StoredProcedure [dbo].[spGetPersonnelHP]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[spGetPersonnelHP]
@nodeID INT

AS

-- should only be 1 - but just to make sure we only get 1
SELECT TOP 1 * FROM tblHarmonyPeriod
  WHERE ndeID=@nodeID
GO
/****** Object:  StoredProcedure [dbo].[spGetPersonnelbyRank]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spGetPersonnelbyRank]
(
	@hrcID		INT,
	@rankID	INT
)

AS
-- temp table to hold list of units
WITH tblChild AS 
  (
     SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
  )
  SELECT hrcID, hrcname INTO #tempunit FROM tblChild 
  
-- temp table to hold all ranks within Unit Hierarchy
CREATE TABLE #temprank
(
	serviceNo varchar(50),
	rank varchar(50),
	firstname varchar(50),
	surname varchar(50),
	postDesc varchar(50)
)

-- now get the ranks of all the people in each team
INSERT INTO #temprank
	SELECT tblStaff.serviceno, tblRank.shortDesc, tblStaff.firstname, tblStaff.surname, tblPost.description
	FROM #tempunit
	INNER JOIN tblPost ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblStaffPost ON tblStaffPost.postID=tblPost.postID
	INNER JOIN tblStaff ON tblStaff.staffID = tblStaffPost.StaffID AND tblStaff.rankID=@rankID
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID	
	WHERE (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) AND (tblPost.Ghost = 0) 
	ORDER BY tblPost.Description

SELECT * FROM #temprank

DROP TABLE #tempunit
DROP TABLE #temprank
GO
/****** Object:  StoredProcedure [dbo].[spGetPersonnelbyPost]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetPersonnelbyPost]
(
	@tmID		INT,
	@sub		INT,
	@post		VARCHAR(50)
)

AS

DECLARE @fltID	INT
DECLARE @sqnID	INT
DECLARE @wingID	INT
DECLARE @groupID	INT
DECLARE @teamIN	INT
DECLARE @unit	VARCHAR(25)
DECLARE @rank	VARCHAR(25)
DECLARE @rankwt	INT

DECLARE @first	INT

SET @teamIN = (SELECT teamIN FROM tblTeam WHERE tblTeam.teamID = @tmID)
SET @unit = (SELECT description FROM tblTeam WHERE tblTeam.teamID = @tmID)

-- so we know its the first time through the cursor loop below
SET @first=0

-- temp table to hold list of units
CREATE TABLE #tempunit
(
	tmID int,
	tmIN int,
	tmDesc varchar(50)
)

-- temp table to hold all ranks within Unit Hierarchy
CREATE TABLE #temppost
(
	serviceNo varchar(50),
	rank varchar(50),
	firstname varchar(50),
	surname varchar(50),
	postDesc varchar(50)
)

INSERT INTO #tempunit
	SELECT teamID, teamIN, description
	FROM tblTeam 
	WHERE tblTeam.teamID = @tmID

IF @sub <> 0
	BEGIN
		-- we are looking at Group level down
		IF @teamIN = 0
			BEGIN
				-- first get the GroupID - we need it later
				SET @groupID=(SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @tmID)
	
				-- now get all the Wings in the Group
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblWing
					INNER JOIN tblTeam ON tblTeam.parentID=tblWing.wingID AND tblTeam.teamIN = 1 
					WHERE tblWing.grpID = @groupID
	
				-- now get all the Squadrons in the wing
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblWing
					INNER JOIN tblSquadron ON tblSquadron.wingID=tblWing.wingID
					INNER JOIN tblTeam ON tblTeam.parentID=tblSquadron.sqnID AND tblTeam.teamIN = 2 
					WHERE tblWing.grpID = @groupID
	
				-- now get all flight teams
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblWing
					INNER JOIN tblSquadron ON tblSquadron.wingID=tblWing.wingID
					INNER JOIN tblFlight ON tblFlight.sqnID=tblSquadron.sqnID                  
					INNER JOIN tblTeam ON tblTeam.parentID=tblFlight.fltID AND tblTeam.teamIN = 3 
					WHERE tblWing.grpID = @groupID
	
				-- now the teams in the flights
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblWing
					INNER JOIN tblSquadron ON tblSquadron.wingID=tblWing.wingID
					INNER JOIN tblFlight ON tblFlight.sqnID=tblSquadron.sqnID                  
					INNER JOIN tblTeam AS t1 ON t1.parentID=tblflight.fltid
					INNER JOIN tblteam ON tblTeam.parentID=t1.teamID
					WHERE tblWing.grpID = @groupID AND tblteam.teamin=4
	
				-- now the teams in the team
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblWing
					INNER JOIN tblSquadron ON tblSquadron.wingID=tblWing.wingID
					INNER JOIN tblFlight ON tblFlight.sqnID=tblSquadron.sqnID                  
					INNER JOIN tblTeam AS t1 ON t1.parentID=tblflight.fltid
					INNER JOIN tblteam AS t2 ON t2.parentID=t1.teamID
					INNER JOIN tblteam ON tblteam.parentID=t2.teamID                
					WHERE tblWing.grpID = @groupID AND tblteam.teamin=5
	
			END
		
		-- we are looking at Wing level down
		IF @teamIN = 1
			BEGIN
				-- first get the WingID - we need it later
				SET @wingID=(SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @tmID)
	
				-- now get all the Squadrons in the wing
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblSquadron
					INNER JOIN tblTeam ON tblTeam.parentID=tblSquadron.sqnID AND tblTeam.teamIN = 2 
					WHERE tblSquadron.wingID = @wingID
	
				-- now get all flight teams
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblSquadron
					INNER JOIN tblFlight ON tblFlight.sqnID=tblSquadron.sqnID                  
					INNER JOIN tblTeam ON tblTeam.parentID=tblFlight.fltID AND tblTeam.teamIN = 3 
					WHERE tblSquadron.wingID = @wingID
	
				-- now the teams in the flights
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblSquadron
					INNER JOIN tblFlight ON tblFlight.sqnID=tblSquadron.sqnID                  
					INNER JOIN tblTeam AS t1 ON t1.parentID=tblflight.fltid
					INNER JOIN tblteam ON tblTeam.parentID=t1.teamID
					WHERE tblSquadron.wingID = @wingID AND tblteam.teamin=4
	
				-- now the teams in the team
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblSquadron
					INNER JOIN tblFlight ON tblFlight.sqnID=tblSquadron.sqnID                  
					INNER JOIN tblTeam AS t1 ON t1.parentID=tblflight.fltid
					INNER JOIN tblteam AS t2 ON t2.parentID=t1.teamID
					INNER JOIN tblteam ON tblteam.parentID=t2.teamID                
					WHERE tblSquadron.wingID = @wingID AND tblteam.teamin=5   
	
			END
		
		-- we are looking at Sqn level down
		IF @teamIN = 2
			BEGIN
				-- first get the sqnID - we need it later
				SET @sqnID=(SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @tmID)
	
				-- first get all flight teams
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblFlight
					INNER JOIN tblTeam ON tblTeam.parentID=tblFlight.fltID AND tblTeam.teamIN = 3 
					WHERE tblFlight.sqnID = @sqnID
	
				-- now the teams in the flight
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblFlight
					INNER JOIN tblTeam AS t1 ON t1.parentID=tblflight.fltid
					INNER JOIN tblteam ON tblTeam.parentID=t1.teamID
					WHERE tblflight.sqnid=@sqnID AND tblteam.teamin=4
	
				-- now the teams in the team
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblFlight
					INNER JOIN tblTeam AS t1 ON t1.parentID=tblflight.fltid
					INNER JOIN tblteam AS t2 ON t2.parentID=t1.teamID
					INNER JOIN tblteam ON tblteam.parentID=t2.teamID                
					WHERE tblflight.sqnid=@sqnID AND tblteam.teamin=5       
	
			END
	
		-- we are looking at Flight level down
		IF @teamIN = 3
			BEGIN
				-- first get the flightID - we need it later
				SET @fltID=(SELECT parentID FROM tblTeam WHERE tblTeam.teamID = @tmID)
	
				-- now the teams in the flight
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblFlight
					INNER JOIN tblTeam AS t1 ON t1.parentID=tblflight.fltid
					INNER JOIN tblteam ON tblTeam.parentID=t1.teamID
					WHERE tblflight.fltid=@fltID AND tblteam.teamin=4
	
				-- now the teams in the team
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblFlight
					INNER JOIN tblTeam AS t1 ON t1.parentID=tblflight.fltid
					INNER JOIN tblteam AS t2 ON t2.parentID=t1.teamID
					INNER JOIN tblteam ON tblteam.parentID=t2.teamID                
					WHERE tblflight.fltid=@fltID AND tblteam.teamin=5
	
			END
	
		-- we are looking at Team level down
		IF @teamIN = 4
			BEGIN
				-- now the teams in the team
				INSERT INTO #tempunit
					SELECT tblTeam.teamID, tblTeam.teamIN, tblTeam.description
					FROM tblTeam AS T2
					INNER JOIN tblteam ON tblteam.parentID=t2.teamID                
					WHERE T2.teamID=@tmID AND tblteam.teamin=5
	
			END
	END

-- now get the ranks of all the people in each team
INSERT INTO #temppost
	SELECT tblStaff.serviceno, tblRank.shortDesc, tblStaff.firstname, tblStaff.surname, tblPost.description
	FROM tblStaff
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	INNER JOIN #tempunit ON tblPost.teamID = #tempunit.tmID
	--INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
	WHERE (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) AND (tblPost.Ghost = 0) AND (tblPost.description = '' + @post)
	ORDER BY tblPost.Description	

SELECT * FROM #temppost

DROP TABLE #tempunit
DROP TABLE #temppost
GO
/****** Object:  StoredProcedure [dbo].[spGetMonthlySpecialistEnduringStats]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spGetMonthlySpecialistEnduringStats]
(
	@hrcID				INT,
	@Enduring			VARCHAR(500)
)

AS

DECLARE @Pos			INT
DECLARE @Len			INT

DECLARE @fltID			INT
DECLARE @sqnID			INT
DECLARE @wingID			INT
DECLARE @groupID			INT
DECLARE @teamIN			INT
DECLARE @qID			VARCHAR(25)
DECLARE @unit   			VARCHAR(25)
DECLARE @qs				VARCHAR(25)

DECLARE @tempstaffID			INT
DECLARE @tempquals			INT
DECLARE @tempqualstypeid		INT
DECLARE @StaffQualCount 		INT

DECLARE @QualCount 			DEC(5,2)
DECLARE @FirstQuartile 		DEC(5,2)
DECLARE @SecondQuartile 		DEC(5,2)
DECLARE @ThirdQuartile 		DEC(5,2)

DECLARE @FirstCount 			INT
DECLARE @SecondCount 		INT
DECLARE @ThirdCount 			INT
DECLARE @FourthCount		INT


DECLARE @Description			VARCHAR(50)
DECLARE @Current			INT
DECLARE @Required			INT

DECLARE @first			INT

SET @Len = LEN(@Enduring)

SET @unit = (SELECT hrcname from tblHierarchy WHERE tblHierarchy.hrcID = @hrcID)

; WITH tblChild AS
		(
		   SELECT T1.hrcID, T1.hrcName, T1.hrcparentID, CAST(T1.hrcID AS VARCHAR(255)) AS hrcPath -- , 0 AS depth
		     FROM tblHierarchy T1 WHERE T1.hrcID=@hrcID
		 UNION ALL
		   SELECT T2.hrcID, T2.hrcName,T2.hrcparentID, CAST(hrcPath + '.' + CAST(T2.hrcID AS VARCHAR(255)) AS VARCHAR(255))    --  depth + 1
		    FROM tblHierarchy T2
		      INNER JOIN tblChild ON T2.hrcparentID=tblChild.hrcID
		  )
		  SELECT * INTO #tempunit FROM tblChild ORDER BY hrcPath
		  
	
-- so we know its the first time through the cursor loop below
SET @first = 0

-- temp table to hold list of types and qs
CREATE TABLE #temptypeQ
(
	qID		INT
)

-- temp table to hold the records by chosen rank
CREATE TABLE #unit
(
	#Description	VARCHAR(50),
	#Current	INT,
	#Required	INT
)

CREATE TABLE #tempcount
(
	firstquater	INT,
	secondquater	INT,
	thirdquater	INT,
	fourthquater	INT	
)

SET @Pos = 0
WHILE (CHARINDEX(',',@Enduring,@Pos)-@Pos) > 0
	BEGIN
		SET @qID = SUBSTRING(@Enduring,@Pos,(CHARINDEX(',',@Enduring,@Pos)-@Pos))

		INSERT INTO #temptypeQ(qID)
		SELECT @qID
		SET @Pos = CHARINDEX(',',@Enduring,@Pos)+1
	END

DECLARE un1 SCROLL CURSOR FOR
	SELECT qID FROM #temptypeQ
OPEN un1

FETCH NEXT FROM un1 INTO @qID

-- now get the harmony status of each rank within the unit
WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN
			SET @Description = (SELECT description FROM tblQs WHERE qID = @qID)
		END
		
		-- Retreives the Establishment.  Posts that exist within the team.
		SET @Required = (SELECT COUNT(*) FROM tblPost
			INNER JOIN tblRank ON tblRank.rankID = tblPost.rankID
			INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
			--INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
			INNER JOIN tblPostQs ON tblPost.postID = tblPostQs.PostID
			WHERE (tblPost.Ghost = 0) AND (tblRank.Weight <> 0) AND (tblPostQs.QID = @qID))

 
		-- Retreives the Strength.  Posts that actually has a person in them.
		SET @Current = (SELECT COUNT(*) FROM tblPost
			INNER JOIN tblStaffPost ON tblPost.postID = tblStaffPost.PostID
			--INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
			INNER JOIN tblRank ON tblPost.rankID = tblRank.rankID
			INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
			INNER JOIN tblStaffQs ON tblStaffPost.StaffID = tblStaffQs.StaffID
			WHERE (tblPost.Ghost = 0) AND (tblRank.Weight <> 0) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) AND (tblStaffQs.QID = @qID))

		-- Now add to the temptable
		INSERT INTO #unit
			SELECT @Description, @Current, @Required

		FETCH NEXT FROM un1 INTO @qID
	END

CLOSE un1
DEALLOCATE un1

-------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE staff SCROLL CURSOR FOR
	SELECT tblStaff.staffID
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaffPost.StaffID = tblStaff.staffID
	INNER JOIN tblPost On tblStaffPost.PostID = tblPost.PostID
	INNER JOIN tblRank ON tblPost.rankID = tblRank.rankID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	WHERE (tblPost.Ghost = 0) AND (tblRank.Weight <> 0) AND tblStaffpost.enddate IS NULL OR tblStaffpost.enddate > GETDATE()

OPEN staff


SET @QualCount = (SELECT COUNT(*) FROM #temptypeQ)

SET @FirstQuartile = (@QualCount / 100) * 25
SET @SecondQuartile = (@QualCount / 100) * 50
SET @ThirdQuartile = (@QualCount / 100) * 75

SET @StaffQualCount = 0
SET @FirstCount = 0
SET @SecondCount = 0 	
SET @ThirdCount = 0 	
SET @FourthCount = 0

FETCH NEXT FROM staff INTO @tempstaffID

	WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE quals SCROLL CURSOR FOR
				Select qID from #temptypeQ
			OPEN quals

			FETCH NEXT FROM quals INTO @tempquals

				WHILE @@FETCH_STATUS = 0
					BEGIN
						IF (SELECT COUNT(*) FROM tblStaffQs WHERE (tblStaffQs.StaffID = @tempstaffID) AND (tblStaffQs.QID = @tempquals)) != 0
							
								SET @StaffQualCount = @StaffQualCount + 1
							
						FETCH NEXT FROM quals INTO @tempquals
					END

					If @StaffQualCount > 0 AND @StaffQualCount <= @FirstQuartile
						SET @FirstCount = @FirstCount + 1

					If @StaffQualCount > @FirstQuartile And @StaffQualCount <= @SecondQuartile
					 	SET @SecondCount = @SecondCount + 1

					If @StaffQualCount > @SecondQuartile And @StaffQualCount <= @ThirdQuartile
						SET @ThirdCount = @ThirdCount + 1

					If @StaffQualCount > @ThirdQuartile
						SET @FourthCount = @FourthCount + 1

					SET @StaffQualCount = 0

			DEALLOCATE quals
			FETCH NEXT FROM staff INTO @tempstaffID
		END

DEALLOCATE staff

INSERT INTO #tempcount(firstquater, secondquater, thirdquater, fourthquater)VALUES(@FirstCount, @SecondCount, @ThirdCount, @FourthCount)

SELECT
	firstquater AS firstquater,
	secondquater AS secondquater,
	thirdquater AS thirdquater,
	fourthquater AS fourthquater
FROM #tempcount

SELECT
	#Description AS hrcname,
	#Current AS [Current],
	#Required AS Requirement
FROM #unit

DROP TABLE #tempunit
DROP TABLE #temptypeQ
DROP TABLE #unit
DROP TABLE #tempcount
GO
/****** Object:  StoredProcedure [dbo].[spGetMonthlySpecialistContingentStats]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spGetMonthlySpecialistContingentStats]
(
	@hrcID				INT,
	@Contingent			VARCHAR(500)
)

AS

DECLARE @Pos			INT
DECLARE @Len			INT

DECLARE @fltID			INT
DECLARE @sqnID			INT
DECLARE @wingID			INT
DECLARE @groupID			INT
DECLARE @teamIN			INT
DECLARE @qID			VARCHAR(25)
DECLARE @unit   			VARCHAR(25)
DECLARE @qs				VARCHAR(25)

DECLARE @tempstaffID			INT
DECLARE @tempquals			INT
DECLARE @tempqualstypeid		INT
DECLARE @StaffQualCount 		INT

DECLARE @QualCount 			DEC(5,2)
DECLARE @FirstQuartile 		DEC(5,2)
DECLARE @SecondQuartile 		DEC(5,2)
DECLARE @ThirdQuartile 		DEC(5,2)

DECLARE @FirstCount 			INT
DECLARE @SecondCount 		INT
DECLARE @ThirdCount 			INT
DECLARE @FourthCount		INT

DECLARE @Description			VARCHAR(50)
DECLARE @Current			INT
DECLARE @Required			INT

DECLARE @first			INT

SET @Len = LEN(@Contingent)

SET @unit = (SELECT hrcname from tblHierarchy WHERE tblHierarchy.hrcID = @hrcID)

; WITH tblChild AS
		(
		   SELECT T1.hrcID, T1.hrcName, T1.hrcparentID, CAST(T1.hrcID AS VARCHAR(255)) AS hrcPath -- , 0 AS depth
		     FROM tblHierarchy T1 WHERE T1.hrcID=@hrcID
		 UNION ALL
		   SELECT T2.hrcID, T2.hrcName,T2.hrcparentID, CAST(hrcPath + '.' + CAST(T2.hrcID AS VARCHAR(255)) AS VARCHAR(255))    --  depth + 1
		    FROM tblHierarchy T2
		      INNER JOIN tblChild ON T2.hrcparentID=tblChild.hrcID
		  )
		  SELECT * INTO #tempunit FROM tblChild ORDER BY hrcPath
		  
	
-- so we know its the first time through the cursor loop below
SET @first = 0

-- temp table to hold list of types and qs
CREATE TABLE #temptypeQ
(
	qID		INT
)

-- temp table to hold the records by chosen rank
CREATE TABLE #unit
(
	#Description	VARCHAR(50),
	#Current	INT,
	#Required	INT
)

CREATE TABLE #tempcount
(
	firstquater	INT,
	secondquater	INT,
	thirdquater	INT,
	fourthquater	INT	
)

SET @Pos = 0
WHILE (CHARINDEX(',',@Contingent,@Pos)-@Pos) > 0
	BEGIN
		SET @qID = SUBSTRING(@Contingent,@Pos,(CHARINDEX(',',@Contingent,@Pos)-@Pos))

		INSERT INTO #temptypeQ(qID)
		SELECT @qID
		SET @Pos = CHARINDEX(',',@Contingent,@Pos)+1
	END

DECLARE un1 SCROLL CURSOR FOR
	SELECT qID FROM #temptypeQ
OPEN un1

FETCH NEXT FROM un1 INTO @qID

-- now get the harmony status of each rank within the unit
WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN
			SET @Description = (SELECT description FROM tblQs WHERE qID = @qID)
		END
		
		-- Retreives the Establishment.  Posts that exist within the team.
		SET @Required = (SELECT COUNT(*) FROM tblPost
			INNER JOIN tblRank ON tblRank.rankID = tblPost.rankID
			INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
			--INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
			INNER JOIN tblPostQs ON tblPost.postID = tblPostQs.PostID
			WHERE (tblPost.Ghost = 0) AND (tblRank.Weight <> 0) AND (tblPostQs.QID = @qID))

 
		-- Retreives the Strength.  Posts that actually has a person in them.
		SET @Current = (SELECT COUNT(*) FROM tblPost
			INNER JOIN tblStaffPost ON tblPost.postID = tblStaffPost.PostID
			--INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
			INNER JOIN tblRank ON tblPost.rankID = tblRank.rankID
			INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
			INNER JOIN tblStaffQs ON tblStaffPost.StaffID = tblStaffQs.StaffID
			WHERE (tblPost.Ghost = 0) AND (tblRank.Weight <> 0) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) AND (tblStaffQs.QID = @qID))


		-- Now add to the temptable
		INSERT INTO #unit
			SELECT @Description, @Current, @Required

		FETCH NEXT FROM un1 INTO @qID
	END

CLOSE un1
DEALLOCATE un1

-------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE staff SCROLL CURSOR FOR
	SELECT tblStaff.staffID
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaffPost.StaffID = tblStaff.staffID
	INNER JOIN tblPost On tblStaffPost.PostID = tblPost.PostID
	INNER JOIN tblRank ON tblPost.rankID = tblRank.rankID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	WHERE (tblPost.Ghost = 0) AND (tblRank.Weight <> 0) AND tblStaffpost.enddate IS NULL OR tblStaffpost.enddate > GETDATE()

OPEN staff

SET @QualCount = (SELECT COUNT(*) FROM #temptypeQ)

SET @FirstQuartile = (@QualCount / 100) * 25
SET @SecondQuartile = (@QualCount / 100) * 50
SET @ThirdQuartile = (@QualCount / 100) * 75

SET @StaffQualCount = 0
SET @FirstCount = 0
SET @SecondCount = 0 	
SET @ThirdCount = 0 	
SET @FourthCount = 0

FETCH NEXT FROM staff INTO @tempstaffID

	WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE quals SCROLL CURSOR FOR
				SELECT qID FROM #temptypeQ

			OPEN quals

			FETCH NEXT FROM quals INTO @tempquals

				WHILE @@FETCH_STATUS = 0
					BEGIN
						IF (SELECT COUNT(*) FROM tblStaffQs WHERE (tblStaffQs.StaffID = @tempstaffID) AND (tblStaffQs.QID = @tempquals)) != 0
							
								SET @StaffQualCount = @StaffQualCount + 1
							
						FETCH NEXT FROM quals INTO @tempquals
					END

					If @StaffQualCount > 0 AND @StaffQualCount <= @FirstQuartile
						SET @FirstCount =  @FirstCount + 1

					If @StaffQualCount > @FirstQuartile And @StaffQualCount <= @SecondQuartile
					 	SET @SecondCount =  @SecondCount + 1

					If @StaffQualCount > @SecondQuartile And @StaffQualCount <= @ThirdQuartile
						SET @ThirdCount = @ThirdCount + 1

					If @StaffQualCount > @ThirdQuartile
						SET @FourthCount = @FourthCount + 1

					SET @StaffQualCount = 0

			DEALLOCATE quals
			FETCH NEXT FROM staff INTO @tempstaffID
		END

DEALLOCATE staff

INSERT INTO #tempcount(firstquater, secondquater, thirdquater, fourthquater)VALUES(@FirstCount, @SecondCount, @ThirdCount, @FourthCount)

SELECT
	firstquater AS firstquater,
	secondquater AS secondquater,
	thirdquater AS thirdquater,
	fourthquater AS fourthquater
FROM #tempcount

SELECT
	#Description AS hrcname,
	#Current AS [Current],
	#Required AS Requirement
FROM #unit

DROP TABLE #tempunit
DROP TABLE #temptypeQ
DROP TABLE #unit
DROP TABLE #tempcount
GO
/****** Object:  StoredProcedure [dbo].[spGetMonthlyRankStats]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spGetMonthlyRankStats]
(
	@hrcID			INT,
	@List			VARCHAR(800)
)

AS

DECLARE @Pos		INT
DECLARE @Len		INT

DECLARE @fltID		INT
DECLARE @sqnID		INT
DECLARE @wingID		INT
DECLARE @groupID		INT
DECLARE @teamIN		INT
DECLARE @rankID		INT
DECLARE @unit   		VARCHAR(25)
DECLARE @rank		VARCHAR(25)
DECLARE @rankWeight		INT

DECLARE @Establishment	INT
DECLARE @Strength		INT
DECLARE @Combat		INT

DECLARE @UN2_staffID	INT
DECLARE @CR_Count 		INT

DECLARE @FEAR		INT
DECLARE @CombatReady	INT

DECLARE @first 		INT

SET @Len = LEN(@List)

SET @unit = (SELECT hrcname from tblHierarchy WHERE tblHierarchy.hrcID = @hrcID)

; WITH tblChild AS
		(
		   SELECT T1.hrcID, T1.hrcName, T1.hrcparentID, CAST(T1.hrcID AS VARCHAR(255)) AS hrcPath -- , 0 AS depth
		     FROM tblHierarchy T1 WHERE T1.hrcID=@hrcID
		 UNION ALL
		   SELECT T2.hrcID, T2.hrcName,T2.hrcparentID, CAST(hrcPath + '.' + CAST(T2.hrcID AS VARCHAR(255)) AS VARCHAR(255))    --  depth + 1
		    FROM tblHierarchy T2
		      INNER JOIN tblChild ON T2.hrcparentID=tblChild.hrcID
		  )
		  SELECT * INTO #tempunit FROM tblChild ORDER BY hrcPath
		  
		  
-- so we know its the first time through the cursor loop below
SET @first=0

-- temp table to hold list of ranks
CREATE TABLE #temprank
(
	rankID			INT
)

-- temp table to hold all ranks within Unit Hierarchy
CREATE TABLE #templist
(
	tmID			INT,
	staffID			INT,
	rankID			INT,
	rankWeight		INT,
	rankDesc		VARCHAR(30),
	tmDesc			VARCHAR(30)
)

-- temp table to hold the records by chosen rank
CREATE TABLE #unit
(
	RankDesc		VARCHAR(25),
	RankWeight		INT,
	Establishment		INT,
	Strength		INT,
	CR			INT,
	FEAR			INT
)

SET @Pos = 0
WHILE (CHARINDEX(',',@List,@Pos)-@Pos) > 0
	BEGIN
		SET @RankID = SUBSTRING(@List,@Pos,(CHARINDEX(',',@List,@Pos)-@Pos))

		INSERT INTO #temprank(RankID)
		SELECT @RankID
		SET @Pos = CHARINDEX(',',@List,@Pos)+1
	END

-- Ranks of all the posts in each team
INSERT INTO #templist
	SELECT DISTINCT tblPost.hrcID, 0, tblPost.rankID, tblRank.weight, tblRank.description, #tempunit.hrcname
        FROM tblPost
	INNER JOIN tblRank ON tblRank.rankID = tblPost.rankID
        INNER JOIN #temprank ON tblRank.rankID = #temprank.rankID
        INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
        --INNER JOIN tblHierarchy ON tblPost.hrcID = tblHierarchy.hrcID
        WHERE tblPost.Ghost = 0 AND tblRank.weight <> 0

DECLARE un1 SCROLL CURSOR FOR
	SELECT rankID, rankWeight FROM #templist GROUP BY rankID, rankWeight
OPEN un1

FETCH NEXT FROM un1 INTO @rankID, @rankWeight

-- now get the harmony status of each rank within the unit
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Establishment = 0
		SET @Strength = 0
		SET @CombatReady = 0
		SET @FEAR = 0
		SET @rank = (SELECT tblRank.description FROM tblRank WHERE tblRank.rankID = @rankID)
		SET @rankWeight = (SELECT tblRank.weight FROM tblRank WHERE tblRank.rankID = @rankID)

		-- Retreives the Establishment.  Posts that exist within the team.
		SET @Establishment = (SELECT COUNT(*) FROM tblPost
			INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID 
			WHERE  tblPost.Ghost = 0 AND tblPost.rankID = @rankID)

		-- Retreives the Strength.  Posts that actually has a person in them.
		SET @Strength = (SELECT COUNT(*) FROM tblStaff
			INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID 
			INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
			INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
			INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
			WHERE tblPost.Ghost = 0 AND tblStaff.rankID = @rankID AND (tblStaffPost.endDate IS NULL OR dbo.tblStaffPost.endDate > GETDATE()) AND tblRank.weight <> 0)

			DECLARE un2 SCROLL CURSOR FOR
				SELECT tblstaff.staffId FROM tblStaff
					INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID 
					INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
					INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
					INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID 
					WHERE tblPost.Ghost = 0 AND tblStaff.rankID = @rankID AND (tblStaffPost.endDate IS NULL OR dbo.tblStaffPost.endDate > GETDATE()) AND tblRank.weight <> 0
			OPEN un2

			FETCH NEXT FROM UN2 INTO @UN2_staffID

			WHILE @@FETCH_STATUS = 0
				BEGIN
					
					SET @CR_Count = 0
						--check to see if the staff id is Combat Ready 
						IF (SELECT COUNT(*) AS Vacinations FROM dbo.tblMilitaryVacs WHERE combat = 1) = 
							(SELECT DISTINCT COUNT(*) AS Vacinations FROM tblStaff
							INNER JOIN tblStaffMVs ON tblStaff.staffID = tblStaffMVs.StaffID
							INNER JOIN tblMilitaryVacs on dbo.tblStaffMVs.MVID = dbo.tblMilitaryVacs.mvID
							WHERE tblMilitaryVacs.combat = 1 AND tblStaffMVs.validTo > GETDATE() AND tblstaff.staffId = @UN2_staffID)
						SET @CR_Count = 1

						IF (SELECT COUNT(*) AS Dentistry FROM tblStaff
							INNER JOIN dbo.tblStaffDental ON dbo.tblStaff.staffID = dbo.tblStaffDental.StaffID
							INNER JOIN dbo.tblDental ON dbo.tblStaffDental.DentalID = dbo.tblDental.DentalID
							WHERE tblDental.combat = 1 AND tblStaffDental.validTo > GETDATE() AND tblstaff.staffId = @UN2_staffID) > 0
						SET @CR_Count = @CR_Count + 1

						If (SELECT COUNT(*) AS Fitness FROM tblStaff
							INNER JOIN dbo.tblStaffFitness ON dbo.tblStaff.staffID = dbo.tblStaffFitness.StaffID
							INNER JOIN dbo.tblFitness ON dbo.tblStaffFitness.FitnessID = dbo.tblFitness.FitnessID
							WHERE tblFitness.Combat = 1 AND tblStaffFitness.ValidTo > GETDATE() AND tblstaff.staffId = @UN2_staffID) > 0
						SET @CR_Count = @CR_Count + 1

						IF (SELECT COUNT(*) AS CCS FROM tblStaff
							INNER JOIN dbo.tblStaffMilSkill ON dbo.tblStaff.staffID = dbo.tblStaffMilSkill.StaffID
							INNER JOIN dbo.tblMilitarySkills ON dbo.tblStaffMilSkill.MSID = dbo.tblMilitarySkills.msID
							WHERE tblMilitarySkills.Combat = 1 AND tblStaffMilSkill.validTo > GETDATE() AND tblstaff.staffId = @UN2_staffID) > 0
						SET @CR_Count = @CR_Count + 1
					
					
					 	--if staff id is combat ready now check to see if they are also fear
						--fear is CR plus any military skill that is check as fear ie tblMilitarySkills.Fear = 1
						if @CR_Count = 4 and  (SELECT COUNT(*) FROM tblStaff
							INNER JOIN dbo.tblStaffMilSkill ON dbo.tblStaff.staffID = dbo.tblStaffMilSkill.StaffID
							INNER JOIN dbo.tblMilitarySkills ON dbo.tblStaffMilSkill.MSID = dbo.tblMilitarySkills.msID
							AND tblstaff.staffId = @UN2_staffID AND tblStaffMilSkill.validTo > GETDATE() 
							AND tblMilitarySkills.msID in(SELECT msID FROM tblMilitarySkills WHERE tblMilitarySkills.Fear = 1)) > 0

							SET @FEAR = @FEAR + 1

						if @CR_Count = 4
							SET @CombatReady = @CombatReady + 1
					
					FETCH NEXT FROM UN2 INTO @UN2_staffID

				END

			CLOSE un2
			DEALLOCATE un2
			
		-- Now add to the temptable
		INSERT INTO #unit
			SELECT @rank,@rankWeight, @Establishment, @Strength, @CombatReady, @FEAR
			
		FETCH NEXT FROM un1 INTO @rankID, @rankWeight 
	END

CLOSE un1
DEALLOCATE un1

SELECT
	RankDesc AS Rank,
--	RankWeight AS Weight,
	Establishment AS Established,
	Strength AS Strength,
	CR AS CombatReady,
	FEAR AS FEAR
FROM #unit ORDER BY RankWeight DESC

SELECT * from #tempunit
DROP TABLE #tempunit
DROP TABLE #temprank
DROP TABLE #templist
DROP TABLE #unit
GO
/****** Object:  StoredProcedure [dbo].[spGetMonthlyNonEffectiveStats]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spGetMonthlyNonEffectiveStats]
(
	@hrcID			INT
)

AS

DECLARE @fltID		INT
DECLARE @sqnID		INT
DECLARE @wingID		INT
DECLARE @groupID		INT
DECLARE @teamIN		INT
DECLARE @rankID		INT
DECLARE @unit   		VARCHAR(25)
DECLARE @StaffID		INT
DECLARE @enddate		DATETIME
DECLARE @remedial		INT
DECLARE @exempt		INT

DECLARE @Posted		INT
DECLARE @Less		INT
DECLARE @Greater		INT
DECLARE @Deployable		INT
DECLARE @Permanent		INT
DECLARE @Temp		INT

DECLARE @first		INT

SET @unit = (SELECT hrcname from tblHierarchy WHERE tblHierarchy.hrcID = @hrcID)

; WITH tblChild AS
		(
		   SELECT T1.hrcID, T1.hrcName, T1.hrcparentID, CAST(T1.hrcID AS VARCHAR(255)) AS hrcPath -- , 0 AS depth
		     FROM tblHierarchy T1 WHERE T1.hrcID=@hrcID
		 UNION ALL
		   SELECT T2.hrcID, T2.hrcName,T2.hrcparentID, CAST(hrcPath + '.' + CAST(T2.hrcID AS VARCHAR(255)) AS VARCHAR(255))    --  depth + 1
		    FROM tblHierarchy T2
		      INNER JOIN tblChild ON T2.hrcparentID=tblChild.hrcID
		  )
		  SELECT * INTO #tempunit FROM tblChild ORDER BY hrcPath
		  

-- so we know its the first time through the cursor loop below
SET @first=0


-- temp table to hold all ranks within Unit Hierarchy
CREATE TABLE #tempnoneffective
(
	#staffID			INT,
	#PostID			INT,
	#firstname		VARCHAR(50),
	#surname		VARCHAR(50),
	#startdate		DATETIME,
	#enddate		DATETIME,
	#remedial		INT,
	#exempt		INT,
	#description		VARCHAR(50)
)


set dateformat dmy

-- People who have a valid ccs record
INSERT INTO #tempnoneffective
	SELECT DISTINCT tblStaff.staffID, tblStaffPost.PostID, tblStaff.firstname, tblStaff.surname, tblStaffPost.startDate, tblStaffPost.endDate, tblStaff.exempt, 
	                tblStaff.remedial, #tempunit.hrcname
	FROM tblStaffPost
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	--INNER JOIN tblTeam ON tblPost.hrcID = tblTeam.hrcID ON tblStaffPost.PostID = tblPost.postID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblStaff ON tblStaffPost.StaffID = tblStaff.staffID
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID 
	WHERE tblRank.weight <> 0 AND tblPost.Ghost = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate > GETDATE())

INSERT INTO #tempnoneffective
	SELECT DISTINCT tblStaff.staffID, tblStaffPost.PostID, tblStaff.firstname, tblStaff.surname, tblStaffPost.startDate, tblStaffPost.endDate, tblStaff.exempt, 
	                tblStaff.remedial, #tempunit.hrcname
	FROM tblStaffPost
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	--INNER JOIN tblTeam ON tblPost.hrcID = tblTeam.hrcID 
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblStaff ON tblStaffPost.StaffID = tblStaff.staffID
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID 
	WHERE (tblRank.rankID <> 0) AND (tblStaffPost.endDate BETWEEN GETDATE() - 30 AND GETDATE()) AND (tblPost.Ghost = 0)

SET @Posted = (SELECT COUNT(*) FROM #tempnoneffective WHERE #enddate >= GETDATE() AND #enddate <= GETDATE() + 28)
SET @Less = (SELECT COUNT(*) FROM #tempnoneffective WHERE #enddate BETWEEN GETDATE() - 28 AND GETDATE())
SET @Greater = (SELECT COUNT(*) FROM #tempnoneffective WHERE #enddate < GETDATE() - 28)
SET @Deployable = 0
SET @Permanent = (SELECT COUNT(*) FROM #tempnoneffective WHERE #exempt = 1 AND (#enddate >= GETDATE() OR #enddate IS NULL))
SET @Temp = (SELECT COUNT(*) FROM #tempnoneffective WHERE #remedial = 1 AND (#enddate >= GETDATE() OR #enddate IS NULL))

SELECT DISTINCT
	@Posted AS Posted,
	@Less AS LessThan,
	@Greater AS GreaterThan,
	@Deployable AS Deployable,
	@Permanent AS Permanent,
	@Temp AS Temp
FROM #tempnoneffective

DROP TABLE #tempunit
DROP TABLE #tempnoneffective
GO
/****** Object:  StoredProcedure [dbo].[spGetMonthlyFitnessStats]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spGetMonthlyFitnessStats]
(
	@hrcID		INT,
	@List		VARCHAR(800)
)

AS

DECLARE @Pos		INT
DECLARE @Len		INT

DECLARE @fltID		INT
DECLARE @sqnID		INT
DECLARE @wingID		INT
DECLARE @groupID		INT
DECLARE @teamIN		INT
DECLARE @fitnessID		INT
DECLARE @unit   		VARCHAR(25)

DECLARE @Pass		INT
DECLARE @Remedial		INT
DECLARE @Exempt		INT
DECLARE @Untested		INT

DECLARE @first 		INT

SET @Len = LEN(@List)

SET @unit = (SELECT hrcname from tblHierarchy WHERE tblHierarchy.hrcID = @hrcID)

; WITH tblChild AS
		(
		   SELECT T1.hrcID, T1.hrcName, T1.hrcparentID, CAST(T1.hrcID AS VARCHAR(255)) AS hrcPath -- , 0 AS depth
		     FROM tblHierarchy T1 WHERE T1.hrcID=@hrcID
		 UNION ALL
		   SELECT T2.hrcID, T2.hrcName,T2.hrcparentID, CAST(hrcPath + '.' + CAST(T2.hrcID AS VARCHAR(255)) AS VARCHAR(255))    --  depth + 1
		    FROM tblHierarchy T2
		      INNER JOIN tblChild ON T2.hrcparentID=tblChild.hrcID
		  )
		  SELECT * INTO #tempunit FROM tblChild ORDER BY hrcPath
		  
	-- so we know its the first time through the cursor loop below
SET @first = 0

-- temp table to hold list of fitness
CREATE TABLE #tempfitness
(
	fitnessID		INT
)

-- temp table to hold all ranks within Unit Hierarchy
CREATE TABLE #templist
(
	#staffID			INT,
	#validfrom		DATETIME,
	#validto			DATETIME,
	#remedial		INT,
	#exempt		INT
)


SET @Pos = 0
WHILE (CHARINDEX(',',@List,@Pos)-@Pos) > 0
	BEGIN
		SET @fitnessID = SUBSTRING(@List,@Pos,(CHARINDEX(',',@List,@Pos)-@Pos))

		INSERT INTO #tempfitness(fitnessID)
		SELECT @fitnessID
		SET @Pos = CHARINDEX(',',@List,@Pos)+1
	END
		
DECLARE un1 SCROLL CURSOR FOR
	SELECT fitnessID FROM #tempfitness

OPEN un1

FETCH NEXT FROM un1 INTO @fitnessID

-- People who have a valid fitness record
WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO #templist
			SELECT DISTINCT tblStaff.staffID, tblStaffFitness.ValidFrom, tblStaffFitness.ValidTo, tblStaff.remedial, tblStaff.Exempt
			FROM tblStaff
			INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
			INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
			INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
			INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
			LEFT OUTER JOIN tblStaffFitness ON tblStaff.staffID = tblStaffFitness.StaffID
			WHERE tblStaffFitness.FitnessID = @fitnessID AND tblStaff.remedial = 0 AND tblStaff.exempt = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.enddate > GETDATE()) AND tblPost.Ghost = 0 AND tblRank.Weight <> 0

		FETCH NEXT FROM un1 INTO @fitnessID	
	END

CLOSE un1
DEALLOCATE un1

-- people who are on remedial
INSERT INTO #templist
	SELECT DISTINCT tblStaff.staffID, NULL, NULL, tblStaff.remedial, tblStaff.Exempt
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
	WHERE (tblStaff.remedial = 1 AND tblStaff.Exempt = 0) AND (tblRank.Weight <> 0) AND tblPost.Ghost = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.enddate > GETDATE())

-- people who are exempt
INSERT INTO #templist
	SELECT DISTINCT tblStaff.staffID, NULL, NULL, tblStaff.remedial, tblStaff.Exempt
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
	WHERE (tblStaff.remedial = 0 AND tblStaff.Exempt = 1) AND (tblRank.Weight <> 0) AND tblPost.Ghost = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.enddate > GETDATE())

-- people who have NO fitness record
INSERT INTO #templist
	SELECT DISTINCT tblStaff.staffID, NULL, NULL, tblStaff.remedial, tblStaff.Exempt
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
	WHERE NOT EXISTS(SELECT staffid FROM tblstafffitness WHERE tblstafffitness.staffid=tblstaff.staffid) AND tblStaff.remedial = 0 AND tblStaff.exempt = 0 AND tblRank.Weight <> 0 AND tblPost.Ghost = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.enddate > GETDATE())

SET @Pass = (SELECT COUNT(*) FROM #templist WHERE #validto >= GETDATE() AND #remedial = 0 AND #exempt = 0)
SET @Remedial = (SELECT COUNT(*) FROM #templist WHERE #remedial = 1)
SET @Exempt = (SELECT COUNT(*) FROM #templist WHERE #exempt = 1)
SET @Untested = (SELECT COUNT(*) FROM #templist WHERE (#validto IS NULL OR #validto < GETDATE()) AND #remedial = 0 AND #exempt = 0)

SELECT DISTINCT
	@Pass AS Passed,
	@Remedial AS Remedial,
	@Exempt AS Exempt,
	@Untested AS Untested
FROM #templist

--select * from #templist

DROP TABLE #tempfitness
DROP TABLE #tempunit
DROP TABLE #templist
GO
/****** Object:  StoredProcedure [dbo].[spGetMonthlyEqualityDiversityStats]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spGetMonthlyEqualityDiversityStats]
(
	@hrcID		INT,
	@genID	INT
)

AS

DECLARE @fltID	INT
DECLARE @sqnID	INT
DECLARE @wingID	INT
DECLARE @groupID	INT
DECLARE @teamIN	INT
DECLARE @rankID	INT
DECLARE @unit   	VARCHAR(25)

DECLARE @Pass	INT
DECLARE @Untrained	INT

DECLARE @first INT


SET @unit = (SELECT hrcname from tblHierarchy WHERE tblHierarchy.hrcID = @hrcID)

; WITH tblChild AS
		(
		   SELECT T1.hrcID, T1.hrcName, T1.hrcparentID, CAST(T1.hrcID AS VARCHAR(255)) AS hrcPath -- , 0 AS depth
		     FROM tblHierarchy T1 WHERE T1.hrcID=@hrcID
		 UNION ALL
		   SELECT T2.hrcID, T2.hrcName,T2.hrcparentID, CAST(hrcPath + '.' + CAST(T2.hrcID AS VARCHAR(255)) AS VARCHAR(255))    --  depth + 1
		    FROM tblHierarchy T2
		      INNER JOIN tblChild ON T2.hrcparentID=tblChild.hrcID
		  )
		  SELECT * INTO #tempunit FROM tblChild ORDER BY hrcPath
		 
-- so we know its the first time through the cursor loop below
SET @first = 0

-- temp table to hold all ranks within Unit Hierarchy
CREATE TABLE #tempqs
(
	#staffID	INT,
	#firstname	VARCHAR(30),
	#surname	VARCHAR(30),
	#YesNo		BIT
)

-- People who have a valid ccs record
INSERT INTO #tempqs
	SELECT DISTINCT tblStaff.staffID, tblStaff.firstname, tblStaff.surname, 1
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	--INNER JOIN tblTeam ON tblPost.hrcID = tblTeam.hrcID
	INNER JOIN tblRank ON tblPost.rankID = tblRank.rankID
	INNER JOIN tblStaffQs ON tblStaff.staffID = tblStaffQs.StaffID
	WHERE tblStaffQs.QID = @genID AND (tblStaffPost.endDate IS NULL OR tblStaffPost.enddate > GETDATE())AND tblPost.Ghost = 0 AND tblRank.Weight <> 0 

-- people who have NO Q
INSERT INTO #tempqs
	SELECT DISTINCT tblStaff.staffID, tblStaff.firstname, tblStaff.surname, 0                   
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	--INNER JOIN tblTeam ON tblPost.hrcID = tblTeam.hrcID
	INNER JOIN tblRank ON tblPost.rankID = tblRank.rankID
	WHERE NOT EXISTS(SELECT staffid FROM tblStaffQs 
	WHERE tblStaffQs.staffid=tblstaff.staffid AND tblStaffQs.QID = @genID) AND tblRank.Weight <> 0 AND tblPost.Ghost = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.enddate > GETDATE())

SET @Pass = (SELECT COUNT(*) FROM #tempqs WHERE #YesNo = 1)
SET @Untrained = (SELECT COUNT(*) FROM #tempqs WHERE #YesNo = 0)

SELECT DISTINCT
	@Pass AS Passed,
	@Untrained AS Untrained
FROM #tempqs

DROP TABLE #tempunit
DROP TABLE #tempqs
GO
/****** Object:  StoredProcedure [dbo].[spGetMonthlyDataProtectionStats]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spGetMonthlyDataProtectionStats]
(
	@hrcID	INT,
	@genID	INT
)

AS

DECLARE @fltID	INT
DECLARE @sqnID	INT
DECLARE @wingID	INT
DECLARE @groupID	INT
DECLARE @teamIN	INT
DECLARE @rankID	INT
DECLARE @unit   	VARCHAR(25)

DECLARE @Pass	INT
DECLARE @Untrained	INT

DECLARE @first INT

SET @unit = (SELECT hrcname from tblHierarchy WHERE tblHierarchy.hrcID = @hrcID)

; WITH tblChild AS
		(
		   SELECT T1.hrcID, T1.hrcName, T1.hrcparentID, CAST(T1.hrcID AS VARCHAR(255)) AS hrcPath -- , 0 AS depth
		     FROM tblHierarchy T1 WHERE T1.hrcID=@hrcID
		 UNION ALL
		   SELECT T2.hrcID, T2.hrcName,T2.hrcparentID, CAST(hrcPath + '.' + CAST(T2.hrcID AS VARCHAR(255)) AS VARCHAR(255))    --  depth + 1
		    FROM tblHierarchy T2
		      INNER JOIN tblChild ON T2.hrcparentID=tblChild.hrcID
		  )
		  SELECT * INTO #tempunit FROM tblChild ORDER BY hrcPath
		  
-- so we know its the first time through the cursor loop below
SET @first = 0

-- temp table to hold all ranks within Unit Hierarchy
CREATE TABLE #tempqs
(
	#staffID	INT,
	#firstname	VARCHAR(30),
	#surname	VARCHAR(30),
	#YesNo		BIT
)

-- People who have a valid Q record
INSERT INTO #tempqs
	SELECT DISTINCT tblStaff.staffID, tblStaff.firstname, tblStaff.surname, 1
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	--INNER JOIN tblTeam ON tblPost.hrcID = tblTeam.hrcID
	INNER JOIN tblRank ON tblPost.rankID = tblRank.rankID
	INNER JOIN tblStaffQs ON tblStaff.staffID = tblStaffQs.StaffID
	WHERE tblStaffQs.QID = @genID AND (tblStaffPost.endDate IS NULL OR tblStaffPost.enddate > GETDATE())AND tblPost.Ghost = 0 AND tblRank.Weight <> 0

-- people who have NO Q
INSERT INTO #tempqs
	SELECT DISTINCT tblStaff.staffID, tblStaff.firstname, tblStaff.surname, 0                   
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	--INNER JOIN tblTeam ON tblPost.hrcID = tblTeam.hrcID
	INNER JOIN tblRank ON tblPost.rankID = tblRank.rankID
	WHERE NOT EXISTS(SELECT staffid FROM tblStaffQs 
	WHERE tblStaffQs.staffid = tblstaff.staffid AND tblStaffQs.QID = @genID) AND tblRank.Weight <> 0 AND tblPost.Ghost = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.enddate > GETDATE())

SET @Pass = (SELECT COUNT(*) FROM #tempqs WHERE #YesNo = 1)
SET @Untrained = (SELECT COUNT(*) FROM #tempqs WHERE #YesNo = 0)

SELECT DISTINCT
	@Pass AS Passed,
	@Untrained AS Untrained
FROM #tempqs

DROP TABLE #tempunit
DROP TABLE #tempqs
GO
/****** Object:  StoredProcedure [dbo].[spGetMonthlyCCSStats]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spGetMonthlyCCSStats]
(
	@hrcID		INT,
	@msID		INT
)

AS

DECLARE @fltID		INT
DECLARE @sqnID		INT
DECLARE @wingID		INT
DECLARE @groupID	INT
DECLARE @teamIN		INT
DECLARE @rankID		INT
DECLARE @unit   	VARCHAR(25)

DECLARE @Pass		INT
DECLARE @Exempt		INT
DECLARE @Untrained	INT

DECLARE @first INT

SET @unit = (SELECT hrcname from tblHierarchy WHERE tblHierarchy.hrcID = @hrcID)

; WITH tblChild AS
		(
		   SELECT T1.hrcID, T1.hrcName, T1.hrcparentID, CAST(T1.hrcID AS VARCHAR(255)) AS hrcPath -- , 0 AS depth
		     FROM tblHierarchy T1 WHERE T1.hrcID=@hrcID
		 UNION ALL
		   SELECT T2.hrcID, T2.hrcName,T2.hrcparentID, CAST(hrcPath + '.' + CAST(T2.hrcID AS VARCHAR(255)) AS VARCHAR(255))    --  depth + 1
		    FROM tblHierarchy T2
		      INNER JOIN tblChild ON T2.hrcparentID=tblChild.hrcID
		  )
		  SELECT * INTO #tempunit FROM tblChild ORDER BY hrcPath
		  
-- so we know its the first time through the cursor loop below
SET @first = 0

-- temp table to hold all ranks within Unit Hierarchy
CREATE TABLE #tempccs
(
	#staffID	INT,
	#validfrom	DATETIME,
	#validto	DATETIME,
	#exempt		INT
)


-- People who have a valid ccs record
INSERT INTO #tempccs
	SELECT DISTINCT tblStaff.staffID, tblStaffMilSkill.ValidFrom, tblStaffMilSkill.ValidTo, tblStaffMilSkill.Exempt 
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblRank ON tblPost.rankID = tblRank.rankID
	INNER JOIN tblStaffMilSkill ON tblStaff.staffID = tblStaffMilSkill.StaffID
	WHERE tblStaffMilSkill.MSID = @msID AND (tblStaffPost.endDate IS NULL OR tblStaffPost.enddate > GETDATE())AND tblPost.Ghost = 0 AND tblRank.Weight <> 0

-- People who have no or invalid ccs record
INSERT INTO #tempccs
	SELECT DISTINCT tblStaff.staffID, NULL, NULL, 0                   
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	--INNER JOIN tblTeam ON tblPost.hrcID = tblTeam.hrcID
	INNER JOIN tblRank ON tblPost.rankID = tblRank.rankID
	WHERE NOT EXISTS(SELECT staffid FROM tblStaffMilSkill 
	WHERE tblStaffMilSkill.staffid=tblstaff.staffid AND tblStaffMilSkill.MSID = @msID) AND tblRank.Weight <> 0 AND tblPost.Ghost = 0 AND (tblStaffPost.endDate IS NULL OR tblStaffPost.enddate > GETDATE())

SET @Pass = (SELECT COUNT(*) FROM #tempccs WHERE #validto > GETDATE() AND #exempt = 0)
SET @Exempt = (SELECT COUNT(*) FROM #tempccs WHERE #exempt = 1)
SET @Untrained = (SELECT COUNT(*) FROM #tempccs WHERE #validto < GETDATE() AND #exempt = 0 OR #validto IS NULL AND #exempt = 0)

SELECT DISTINCT
	@Pass AS Passed,
	@Exempt AS Exempt,
	@Untrained AS Untrained
FROM #tempccs

DROP TABLE #tempunit
DROP TABLE #tempccs
GO
/****** Object:  StoredProcedure [dbo].[spGetMilStatusOnly]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[spGetMilStatusOnly] 
@staffID INT,
@postID int,

@thisDate varchar(30),
@MilStatus int output
AS

SET dateformat dmy

--declare @PostID int
declare @milSkillStatus char(1)
declare @vacStatus char(1)
declare @fitnessStatus char(1)
declare @dentalStatus char(1)


set @MilStatus =1
set @milSkillStatus='G'
set @vacStatus='G'
set @fitnessStatus='G'
set @dentalStatus='R'

--First Check Mil Skills Status--
if exists (SELECT     staffMSID
FROM         dbo.tblMilitarySkills inner join tblPostMilSkill on tblPostMilSkill.msID = tblMilitarySkills.msID
inner  JOIN
(select  staffMSID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,MSID,validfrom,validTo, competent from dbo.tblStaffMilskill  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffMilskill.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID and validFrom <= @thisDate and (validTo >=@thisDate and DATEADD(month, -1, validTo)<= @thisDate)) as tempTableJoin ON dbo.tblMilitarySkills.MSID = tempTableJoin.MSID
where tblPostMilSkill.PostID=@PostID )

begin
	set @milSkillStatus='A'
end

if exists (SELECT     staffMSID,validTo
FROM         dbo.tblMilitarySkills inner join tblPostMilSkill on tblPostMilSkill.msID = tblMilitarySkills.msID
left outer  JOIN
(select  staffMSID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,MSID,validfrom,validTo, competent from dbo.tblStaffMilskill  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffMilskill.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID and validFrom <= @thisDate and validTo >=@thisDate) as tempTableJoin ON dbo.tblMilitarySkills.MSID = tempTableJoin.MSID
where tblPostMilSkill.PostID=@PostID and staffMSID is null or validTo <@thisDate)

begin
	set @milSkillStatus='R'
end

--Secondly Check Vaccination Status--
if exists (SELECT     staffMVID
FROM         dbo.tblMilitaryVacs inner JOIN
(select  staffMVID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,mvID,validfrom,validTo, competent from dbo.tblStaffMVs  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffMVs.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID
and validFrom <= @thisDate and (validTo >=@thisDate and DATEADD(month, -1, validTo)<= @thisDate)) as tempTableJoin ON dbo.tblMilitaryVacs.mvID = tempTableJoin.MVID
)

begin
	set @vacStatus='A'
end

if exists (SELECT     staffMVID,validTo
FROM         dbo.tblMilitaryVacs LEFT OUTER JOIN
(select  staffMVID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,mvID,validfrom,validTo, competent from dbo.tblStaffMVs  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffMVs.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID) as tempTableJoin ON dbo.tblMilitaryVacs.mvID = tempTableJoin.MVID

where  staffMVID is null or validTo <@thisDate)

begin
	set @vacStatus='R'
end

--Thirdly Check Fitness Status--
if exists (SELECT     staffFitnessID
FROM         dbo.tblFitness inner JOIN
(select  staffFitnessID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,FitnessID,validfrom,validTo, competent from dbo.tblStaffFitness  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffFitness.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID
and validFrom <= @thisDate and (validTo >=@thisDate and DATEADD(month, -1, validTo)<= @thisDate)) as tempTableJoin ON dbo.tblFitness.FitnessID = tempTableJoin.FitnessID
)

begin
	set @fitnessStatus='A'
end

if exists (SELECT     staffFitnessID,validTo
FROM         dbo.tblFitness LEFT OUTER JOIN
(select  staffFitnessID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,fitnessID,validfrom,validTo, competent from dbo.tblStaffFitness  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffFitness.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID) as tempTableJoin ON dbo.tblFitness.fitnessID = tempTableJoin.fitnessID

where  staffFitnessID is null or validTo <@thisDate)



begin
	set @fitnessStatus='R'
end

--Fourthly Check Dental Status--

if exists (SELECT     staffDentalID,validTo
FROM         dbo.tblDental LEFT OUTER JOIN
(select  staffDentalID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,DentalID,validfrom,validTo, competent from dbo.tblStaffDental  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffDental.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID) as tempTableJoin ON dbo.tblDental.DentalID = tempTableJoin.DentalID

where  staffDentalID is not null  and validTo >@thisDate)

begin
	set @DentalStatus='G'
end

if exists (SELECT     staffDentalID
FROM         dbo.tblDental inner JOIN
(select  staffDentalID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,DentalID,validfrom,validTo, competent from dbo.tblStaffDental  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffDental.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID
and validFrom <= @thisDate and (validTo >=@thisDate and DATEADD(month, -1, validTo)<= @thisDate)) as tempTableJoin ON dbo.tblDental.DentalID = tempTableJoin.DentalID
)

begin
	set @DentalStatus='A'
end

if @milSkillStatus='A' or @vacStatus ='A' or @fitnessStatus ='A'  or @DentalStatus ='A'

begin
	set @MilStatus = 0
end

if @milSkillStatus='R' or @vacStatus ='R' or @fitnessStatus  ='R' or @DentalStatus = 'R'

begin
	set @MilStatus = 0
end
GO
/****** Object:  StoredProcedure [dbo].[spGetMilstatus]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetMilstatus] 
@postID int,
@staffID INT,
@thisDate varchar(30) 

AS

SET dateformat dmy

--declare @PostID int
declare @milSkillStatus char(1)
declare @vacStatus char(1)
declare @fitnessStatus char(1)
declare @dentalStatus char(1)
declare @overallStatus char(1)

set @overallStatus = 'G'
set @milSkillStatus='G'
set @vacStatus='G'
set @fitnessStatus='G'
set @dentalStatus='R'

--First Check Mil Skills Status--
if exists (SELECT     staffMSID
FROM         dbo.tblMilitarySkills inner join tblPostMilSkill on tblPostMilSkill.msID = tblMilitarySkills.msID
inner  JOIN
(select  staffMSID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,MSID,validfrom,validTo, competent from dbo.tblStaffMilskill  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffMilskill.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID and validFrom <= @thisDate and (validTo >=@thisDate and DATEADD(month, -1, validTo)<= @thisDate)) as tempTableJoin ON dbo.tblMilitarySkills.MSID = tempTableJoin.MSID
where tblPostMilSkill.PostID=@PostID )

begin
	set @milSkillStatus='A'
end

if exists (SELECT     staffMSID,validTo
FROM         dbo.tblMilitarySkills inner join tblPostMilSkill on tblPostMilSkill.msID = tblMilitarySkills.msID
left outer  JOIN
(select  staffMSID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,MSID,validfrom,validTo, competent from dbo.tblStaffMilskill  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffMilskill.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID and validFrom <= @thisDate and validTo >=@thisDate) as tempTableJoin ON dbo.tblMilitarySkills.MSID = tempTableJoin.MSID
where tblPostMilSkill.PostID=@PostID and staffMSID is null or validTo < @thisDate)

begin
	set @milSkillStatus='R'
end

--Secondly Check Vaccination Status--
if exists (SELECT     staffMVID
FROM         dbo.tblMilitaryVacs inner JOIN
(select  staffMVID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,mvID,validfrom,validTo, competent from dbo.tblStaffMVs  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffMVs.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID
and validFrom <= @thisDate and (validTo >=@thisDate and DATEADD(month, -1, validTo)<= @thisDate)) as tempTableJoin ON dbo.tblMilitaryVacs.mvID = tempTableJoin.MVID
)

begin
	set @vacStatus='A'
end

if exists (SELECT     staffMVID,validTo
FROM         dbo.tblMilitaryVacs LEFT OUTER JOIN
(select  staffMVID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,mvID,validfrom,validTo, competent from dbo.tblStaffMVs  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffMVs.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID) as tempTableJoin ON dbo.tblMilitaryVacs.mvID = tempTableJoin.MVID
where  (staffMVID is null or validTo < @thisDate) AND mvrequired <> 0)

begin
	set @vacStatus='R'
end

--Thirdly Check Fitness Status--
if exists (SELECT  staffFitnessID
FROM         dbo.tblFitness inner JOIN
(select  staffFitnessID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,FitnessID,validfrom,validTo, competent from dbo.tblStaffFitness  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffFitness.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID
and validFrom <= @thisDate and (validTo >=@thisDate and DATEADD(month, -1, validTo)<= @thisDate)) as tempTableJoin ON dbo.tblFitness.FitnessID = tempTableJoin.FitnessID) 

begin
	set @fitnessStatus='A'
end

if exists (SELECT TOP 1 staffFitnessID FROM tblFitness RIGHT OUTER JOIN (select staffFitnessID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,fitnessID,validfrom,validTo, competent from dbo.tblStaffFitness  RIGHT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffFitness.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID = @staffID) as tempTableJoin ON dbo.tblFitness.fitnessID = tempTableJoin.fitnessID
WHERE (staffFitnessID IS NULL) or (validTo < @thisDate))

begin
	set @fitnessStatus='R'
end

if exists(select remedial from tblStaff where staffId= @staffID and remedial =1)
begin
	set @fitnessStatus='A'
end

if exists(select exempt from tblStaff where staffId= @staffID and exempt =1)
begin
	set @fitnessStatus='A'
end


--Fourthly Check Dental Status--
if exists (SELECT     staffDentalID,validTo
FROM         dbo.tblDental LEFT OUTER JOIN
(select  staffDentalID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,DentalID,validfrom,validTo, competent from dbo.tblStaffDental  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffDental.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID) as tempTableJoin ON dbo.tblDental.DentalID = tempTableJoin.DentalID

where  staffDentalID is not null and validTo >@thisDate)

begin
	set @DentalStatus='G'
end

if exists (SELECT     staffDentalID
FROM         dbo.tblDental inner JOIN
(select  staffDentalID,dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.staffID,DentalID,validfrom,validTo, competent from dbo.tblStaffDental  LEFT OUTER JOIN
dbo.tblStaff ON dbo.tblStaffDental.StaffID = dbo.tblStaff.staffID where dbo.tblStaff.staffID=@staffID
and validFrom <= @thisDate and (validTo >=@thisDate and DATEADD(month, -1, validTo)<= @thisDate)) as tempTableJoin ON dbo.tblDental.DentalID = tempTableJoin.DentalID
)

begin
	set @DentalStatus='A'
end



if @milSkillStatus='A' or @vacStatus ='A' or @fitnessStatus ='A'  or @DentalStatus ='A'

begin
	set @overallStatus = 'A'
end

if @milSkillStatus='R' or @vacStatus ='R' or @fitnessStatus  ='R' or @DentalStatus = 'R'

begin
	set @overallStatus = 'R'
end

select @milSkillStatus as milSkillStatus, @vacStatus as vacStatus,@fitnessStatus as fitnessStatus, @dentalStatus as dentalStatus, @overallStatus as overallStatus
GO
/****** Object:  StoredProcedure [dbo].[sp_TaskInsert]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_TaskInsert]
@nodeID INT,
@ttID INT,
@Description VARCHAR (50),
@cancellable INT,
@ooaTask INT,
@sscID INT,
@hqTask INT

AS

SET DATEFORMAT dmy 

-- Ron 070708  - don't need dates - but keep them for compatability
DECLARE @startDate varchar(50)
DECLARE @endDate varchar(50)

SET @startDate = '01/01/2000'
SET @endDate = '31/12/2050'

   INSERT tbl_Task (ndeID, ttID, Description, startDate, endDate, cancellable,ooa,sscID,hqTask)
            VALUES (@nodeID,@ttID, @Description, @startDate, @endDate, @cancellable, @ooaTask,@sscID, @hqTask)
GO
/****** Object:  StoredProcedure [dbo].[sp_TaskDetail]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TaskDetail]
(
	@recID	INT
)

AS

SELECT tbl_Task.taskID, tbl_Task.description AS Task, tblTaskType.description AS Type, tblTaskType.ttID AS ttID, tbl_Task.endDate, 
       tbl_Task.Cancellable, tbl_Task.ooa, tbl_Task.sscID, tblSSC.ssCode, tblSSC.description AS SSC, tbl_Task.hqTask
  FROM tblTaskType 
    INNER JOIN tbl_Task ON tblTaskType.ttID = tbl_Task.ttID
    LEFT OUTER JOIN tblSSC ON tblSSC.sscID = tbl_Task.sscID
     WHERE tbl_Task.taskID = @recID
GO
/****** Object:  StoredProcedure [dbo].[sp_TaskCategoryDetail]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_TaskCategoryDetail]
@recID int
AS

select tbl_TaskCategory.taskCategoryID as taskID, tbl_TaskCategory.taskTypeID as ttID, tbl_TaskCategory.description, tblTaskType.description type  from tbl_TaskCategory
  inner join tblTaskType ON
     tbl_TaskCategory.taskTypeID = tblTaskType.ttID
where tblTaskType.active=1 and tbl_TaskCategory.taskCategoryID = @recID
GO
/****** Object:  StoredProcedure [dbo].[sp_ListTaskUnitsWithDates]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ListTaskUnitsWithDates]
(
	@recID INT 		--taskID
)

AS

SET DATEFORMAT dmy

SELECT tbl_TaskUnit.taskunitID, tbl_Task.taskID, tbl_TaskUnit.teamID, tblTeam.description AS team, tbl_TaskUnit.startDate, tbl_TaskUnit.endDate, tbl_TaskUnit.taskNote, tbl_TaskUnit.cancellable, tbl_TaskUnit.active
FROM tbl_Task
INNER JOIN tbl_TaskUnit ON tbl_Task.taskID = tbl_TaskUnit.taskID
INNER JOIN tblTeam ON tbl_TaskUnit.teamID = tblTeam.teamID
WHERE tbl_Task.taskID = @recID
ORDER BY tblTeam.description, tbl_TaskUnit.startDate ASC
GO
/****** Object:  StoredProcedure [dbo].[spFlightUpdate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spFlightUpdate]
(
	@RecID		INT,
	@sqnID		INT,
	@Description	VARCHAR(50),
	@blnExists	BIT OUTPUT
)

AS

SET NOCOUNT ON

UPDATE tblFlight SET
sqnID = @sqnID,
Description = @Description
WHERE fltID = @RecID

SET @blnExists = 0

IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spGetLastOOADate]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- This will return the Last OOA date for staffID passed
-- its called from spHarmonyCheck and runs overnight
CREATE     PROCEDURE [dbo].[spGetLastOOADate] 
  @StaffID   INT,
  @enddate DATETIME OUTPUT
    AS 

-- default to NULL
SET @enddate=NULL

DECLARE edte CURSOR SCROLL FOR
 SELECT tbl_TaskStaff.enddate FROM tbl_TaskStaff 
   INNER JOIN tbl_Task ON
       tbl_Task.taskID= tbl_TaskStaff.taskID 
          WHERE tbl_TaskStaff.staffid = @staffid
            and tbl_TaskStaff.endDate <= getdate() -- see below - replace this line ?
            and tbl_TaskStaff.active=1    -- was not cancelled
            and tbl_Task.ooa= 1
              --order by tbl_TaskStaff.enddate desc

OPEN edte

-- get the last task they completed - this is the date we want
FETCH LAST FROM edte INTO @enddate

CLOSE edte
DEALLOCATE edte


/* This should pick up only the tasks that finished today
   but we need to do it as above initially to pick up last historic
   OOA date - and maybe we should leave it like that cos it runs overnight
   so timing issue
DECLARE @today     varchar(20)

SET @today = (SELECT CONVERT (char(10), getdate(), 103))
and  CONVERT (char(10), tbl_TaskStaff.enddate, 103)=@today
  
********************/
GO
/****** Object:  StoredProcedure [dbo].[spGetHP]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  PROCEDURE [dbo].[spGetHP]
@RecID INT

AS

SELECT * from tblHarmonyPeriod
   WHERE tblHarmonyPeriod.hpID=@recID
GO
/****** Object:  StoredProcedure [dbo].[spGetHierarchyTrail]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetHierarchyTrail]
   @recID INT
   
AS

DECLARE @childID INT
DECLARE @hrcID INT
DECLARE @parentID INT
DECLARE @level INT
DECLARE @name VARCHAR(100)

DECLARE @lastlevel INT
DECLARE @crumbtrail VARCHAR(200)

CREATE TABLE #ttopen(
    ttopenID INT
)

--SET @recID=32
SET @childID=@recID  

SET @level = (SELECT hrclevel FROM tblhierarchy WHERE hrcID = @childID)

-- Now we work our way up to the top of the hierarchy
-- but make sure we include all other branches of this part of the tree

WHILE @level >=0    
	  BEGIN             -- we are going from bottom to top of selected Child branch
	     
		 DECLARE hrc1 CURSOR SCROLL
		 FOR SELECT hrcID, hrcparentID FROM tblhierarchy WHERE hrcID = @childID
	     
		 OPEN hrc1
		 FETCH NEXT FROM hrc1 INTO @hrcID, @parentID


		 IF @@FETCH_STATUS = 0
		  BEGIN
		    SET @lastlevel = @level   -- so we now how deep the levels go
		    -- update the last child entry
			  INSERT INTO #ttopen
				 	SELECT @hrcID	         
		  END
		 
		 CLOSE hrc1
		 DEALLOCATE hrc1

    	-- now move evrything up a level
		SET @childID=@parentID
		SET @level = @level - 1
		
  END

  DECLARE hrc1 CURSOR SCROLL
         FOR SELECT  hrcID, hrcname 
                FROM tblhierarchy WHERE hrclevel > 0
     
		OPEN hrc1
		FETCH NEXT FROM hrc1 INTO @hrcID, @name
				
		WHILE @@FETCH_STATUS = 0
		 BEGIN
		   -- update the last child entry
		   IF EXISTS (SELECT #ttopen.ttopenID FROM #ttopen WHERE #ttopen.ttopenID = @hrcID)
		     BEGIN
		      
		       IF @crumbtrail IS NULL
		          SET @crumbtrail= @name 
		       ELSE
		          SET @crumbtrail=@crumbtrail+ '>'+ @name 
		     END
			 
			 FETCH NEXT FROM hrc1 INTO @hrcID, @name			  
		 END
CLOSE hrc1
DEALLOCATE hrc1

SELECT @crumbtrail AS crumbtrail

DROP TABLE #ttopen
GO
/****** Object:  StoredProcedure [dbo].[spTaskDetail]    Script Date: 04/06/2016 15:22:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spTaskDetail]
 @recID int
AS

SELECT tblTask.taskID, tblTask.ttID, tblTask.description, tblTaskType.description type 
  FROM tblTask
     INNER JOIN tblTaskType ON tblTask.ttID = tblTaskType.ttID
       WHERE tblTask.taskID = @recID
GO
/****** Object:  View [dbo].[vw_Tasks]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Tasks]
AS
SELECT     TOP (100) PERCENT dbo.tbl_Task.taskID, dbo.tbl_Task.ttID, dbo.tbl_Task.description AS task, dbo.tbl_Task.startDate, dbo.tbl_Task.endDate, dbo.tbl_Task.Cancellable, 
                      dbo.tbl_Task.ooa, dbo.tbl_Task.hqtask, dbo.tblTaskType.description AS Type
FROM         dbo.tbl_Task INNER JOIN
                      dbo.tblTaskType ON dbo.tbl_Task.ttID = dbo.tblTaskType.ttID
WHERE     (dbo.tblTaskType.ttID <> 27)
ORDER BY task
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tbl_Task"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblTaskType"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 125
               Right = 396
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 6480
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Tasks'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Tasks'
GO
/****** Object:  View [dbo].[tempQsRequiredByPost]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tempQsRequiredByPost]
AS
SELECT     TOP 100 PERCENT dbo.tblPost.postID, dbo.tblPost.assignno, ISNULL(SUM(dbo.tblQWeight.qwvalue), 0) AS QTotal
FROM         dbo.tblPost LEFT OUTER JOIN
                      dbo.tblPostQs ON dbo.tblPostQs.PostID = dbo.tblPost.postID LEFT OUTER JOIN
                      dbo.tblPostQStatus LEFT OUTER JOIN
                      dbo.tblQWeight ON dbo.tblPostQStatus.QWType = dbo.tblQWeight.qwtype ON dbo.tblPostQs.Status = dbo.tblPostQStatus.PostQStatus
GROUP BY dbo.tblPost.postID, dbo.tblPost.assignno
ORDER BY dbo.tblPost.postID
GO
/****** Object:  StoredProcedure [dbo].[spWingInsert]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spWingInsert]
(
	@GroupID	INT,
	@Description	VARCHAR(50),
	@blnExists	BIT OUTPUT
)

AS

SET NOCOUNT ON

IF EXISTS (SELECT Description FROM tblWing WHERE Description = @Description)
	BEGIN
		SET @blnExists = 1
	END
ELSE
	BEGIN
		INSERT INTO tblWing (Description, grpID)
		VALUES (@Description, @GroupID)

		SET @blnExists = 0
	END

IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spWingDetail]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE    PROCEDURE [dbo].[spWingDetail]
@WingID int
as

select tblWing.wingID, tblWing.description, tblGroup.grpID, tblGroup.description Grp
   from tblWing 
    INNER JOIN tblGroup on
       tblGroup.grpID = tblWing.grpID
     where tblWing.wingID=@WingID
GO
/****** Object:  StoredProcedure [dbo].[spWingDel]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spWingDel]
@recID int,
@DelOK int OUTPUT
as

-- has it got a squadron or a team assigned to it
IF (
    EXISTS (SELECT TOP 1 sqnID from tblSquadron WHERE tblSquadron.wingID = @recID)
    OR
    EXISTS (SELECT TOP 1 teamID from tblTeam WHERE (tblTeam.parentID = @recID AND tblTeam.teamIn= '1'))
    ) 
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spUpdateStaffQ]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateStaffQ]
(
	@validFrom	VARCHAR(20),
	@competent	VARCHAR(5),
	@StaffQID	INT,
	@Auth		VARCHAR(20),
	@UpBy		INT,
	@UpDated	DATETIME)

AS

SET DATEFORMAT dmy

UPDATE tblStaffQs 
  SET validFrom = @validfrom,
      competent = @competent,
      AuthName = @Auth,
      UpBy = @UpBy,
      Updated = @Updated
      WHERE StaffQID = @StaffQID
GO
/****** Object:  View [dbo].[vwVacantPosts]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwVacantPosts]
AS
SELECT    MainTable. postID, assignno, description, teamID, positionDesc,MainTable. tradeID, RWID, MainTable.notes, qoveride, msoveride, overborne, staffid
FROM         dbo.tblPost MainTable left outer join tblstaff on tblStaff.postID = MainTable.postid
/*WHERE     (NOT EXISTS
                          (SELECT     StaffID
                            FROM          tblStaff
                            WHERE      tblStaff.PostID = MainTable.PostID))*/
GO
/****** Object:  View [dbo].[vwTempTeamInWingHierarchy]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vwTempTeamInWingHierarchy]
AS

SELECT     dbo.tblPost.postID, dbo.tblPost.description, dbo.tblTeam.description AS Team,'0' AS SubTeam, '0' AS TeamIn,'0' AS flt, '0' AS sqn, 
                      dbo.tblWing.wingID AS wing,dbo.tblGroup.grpid AS [Group]
FROM         dbo.tblPost INNER JOIN
                      dbo.tblTeam ON dbo.tblPost.teamID = dbo.tblTeam.teamID INNER JOIN
                      
                      
                      dbo.tblWing ON dbo.tblTeam.parentID = dbo.tblWing.wingID inner join
	         dbo.tblGroup ON  dbo.tblWing.grpid = dbo.tblGroup.grpid		
WHERE     (dbo.tblTeam.teamIn = 1)
GO
/****** Object:  View [dbo].[vwTempTeamInTeamHierarchy]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTempTeamInTeamHierarchy]
AS
SELECT     dbo.tblPost.postID, dbo.tblPost.description, dbo.tblTeam.description AS Team,'0' AS SubTeam, InTeam.teamID AS TeamIn, dbo.tblFlight.fltID AS flt, 
                      dbo.tblSquadron.sqnID AS sqn, dbo.tblWing.wingID AS wing ,dbo.tblGroup.grpid AS [Group]
FROM         dbo.tblPost INNER JOIN
                      dbo.tblTeam ON dbo.tblPost.teamID = dbo.tblTeam.teamID INNER JOIN
                      dbo.tblTeam InTeam ON dbotblTeam.ParentID = InTeam.teamID INNER JOIN
                      dbo.tblFlight ON InTeam.parentID = dbo.tblFlight.fltID INNER JOIN
                      dbo.tblSquadron ON dbo.tblFlight.sqnID = dbo.tblSquadron.sqnID INNER JOIN
                      dbo.tblWing ON dbo.tblSquadron.wingID = dbo.tblWing.wingID inner join
dbo.tblGroup ON  dbo.tblWing.grpid = dbo.tblGroup.grpid	
WHERE     (dbo.tblTeam.teamIn = 4)
GO
/****** Object:  View [dbo].[vwTempTeamInSqnHierarchy]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTempTeamInSqnHierarchy]
AS

SELECT     dbo.tblPost.postID, dbo.tblPost.description, dbo.tblTeam.description AS Team,'0' AS SubTeam, '0' AS TeamIn,'0' AS flt, dbo.tblSquadron.sqnID AS sqn, 
                      dbo.tblWing.wingID AS wing ,dbo.tblGroup.grpid AS [Group]
FROM         dbo.tblPost INNER JOIN
                      dbo.tblTeam ON dbo.tblPost.teamID = dbo.tblTeam.teamID INNER JOIN
                      
                      dbo.tblSquadron ON dbo.tblTeam.parentID = dbo.tblSquadron.sqnID INNER JOIN
                      dbo.tblWing ON dbo.tblSquadron.wingID = dbo.tblWing.wingID  inner join
	        dbo.tblGroup ON  dbo.tblWing.grpid = dbo.tblGroup.grpid	
WHERE     (dbo.tblTeam.teamIn = 2)
GO
/****** Object:  View [dbo].[vwTempTeamInGroupHierarchy]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTempTeamInGroupHierarchy]
AS

SELECT     dbo.tblPost.postID, dbo.tblPost.description, dbo.tblTeam.description AS TeamIn,'0' AS SubTeam, '0' AS Team,'0' AS flt, '0' AS sqn, 
                      '0' AS wing,dbo.tblGroup.grpid AS [Group]
FROM         dbo.tblPost INNER JOIN
                      dbo.tblTeam ON dbo.tblPost.teamID = dbo.tblTeam.teamID INNER JOIN
                      
                      
                      
	         dbo.tblGroup ON  dbo.tblTeam.parentID = dbo.tblGroup.grpid		
WHERE     (dbo.tblTeam.teamIn = 0)
GO
/****** Object:  View [dbo].[vwTempTeamInFltHierarchy]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTempTeamInFltHierarchy]
AS
SELECT     dbo.tblPost.postID, dbo.tblPost.description, dbo.tblTeam.description AS Team,'0' AS SubTeam, '0' AS TeamIn,dbo.tblTeam.parentID AS flt, dbo.tblSquadron.sqnID AS sqn, 
                      dbo.tblWing.wingID AS wing ,dbo.tblGroup.grpid AS [Group]
FROM         dbo.tblPost INNER JOIN
                      dbo.tblTeam ON dbo.tblPost.teamID = dbo.tblTeam.teamID INNER JOIN
                      dbo.tblFlight ON dbo.tblTeam.parentID = dbo.tblFlight.fltID INNER JOIN
                      dbo.tblSquadron ON dbo.tblFlight.sqnID = dbo.tblSquadron.sqnID INNER JOIN
                      dbo.tblWing ON dbo.tblSquadron.wingID = dbo.tblWing.wingID  inner join
	        dbo.tblGroup ON  dbo.tblWing.grpid = dbo.tblGroup.grpid
WHERE     (dbo.tblTeam.teamIn = 3)
GO
/****** Object:  View [dbo].[vwTempSubTeamInTeamHierarchy]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTempSubTeamInTeamHierarchy]
AS
SELECT     dbo.tblPost.postID, dbo.tblPost.description, dbo.tblTeam.description AS Team,InSubTeam.teamID AS SubTeam, InTeam.teamID AS TeamIn, dbo.tblFlight.fltID AS flt, 
                      dbo.tblSquadron.sqnID AS sqn, dbo.tblWing.wingID AS wing ,dbo.tblGroup.grpid AS [Group]
FROM         dbo.tblPost INNER JOIN

                      dbo.tblTeam ON dbo.tblPost.teamID = dbo.tblTeam.teamID INNER JOIN

		      dbo.tblTeam as InSubTeam ON dbo.tblTeam.ParentID = InSubTeam.teamID INNER JOIN
                      dbo.tblTeam as InTeam ON InSubTeam.ParentID = InTeam.teamID INNER JOIN
                      dbo.tblFlight ON InTeam.parentID = dbo.tblFlight.fltID INNER JOIN
                      dbo.tblSquadron ON dbo.tblFlight.sqnID = dbo.tblSquadron.sqnID INNER JOIN
                      dbo.tblWing ON dbo.tblSquadron.wingID = dbo.tblWing.wingID  inner join
	        dbo.tblGroup ON  dbo.tblWing.grpid = dbo.tblGroup.grpid
WHERE     (dbo.tblTeam.teamIn = 5)
GO
/****** Object:  View [dbo].[vwTempFitnessTestDetails]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTempFitnessTestDetails]
AS
SELECT DISTINCT 
                      TOP 100 PERCENT dbo.tblStaff.staffID, dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.serviceno, dbo.tblFitness.Description, 
                      dbo.tblStaffFitness.ValidFrom AS FitnessValidFrom, dbo.tblTeam.description AS Team, dbo.tblStaffPost.startDate AS PostStartDate, 
                      dbo.tblStaffPost.endDate AS PostEndDate
FROM         dbo.tblStaff INNER JOIN
                      dbo.tblStaffFitness ON dbo.tblStaff.staffID = dbo.tblStaffFitness.StaffID INNER JOIN
                      dbo.tblFitness ON dbo.tblStaffFitness.FitnessID = dbo.tblFitness.FitnessID INNER JOIN
                      dbo.tblStaffPost ON dbo.tblStaff.staffID = dbo.tblStaffPost.StaffID INNER JOIN
                      dbo.tblPost ON dbo.tblStaffPost.PostID = dbo.tblPost.postID INNER JOIN
                      dbo.tblTeam ON dbo.tblPost.teamID = dbo.tblTeam.teamID
ORDER BY dbo.tblStaffFitness.ValidFrom
GO
/****** Object:  View [dbo].[vwTeamListForDetail]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE     view [dbo].[vwTeamListForDetail]  AS
SELECT     dbo.tblTeam.teamID, ParentID, dbo.tblTeam.description, dbo.tblTeam.teamSize, dbo.tblTeam.weight,
           teamIn, 'Group' as teamInName, dbo.tblGroup.description AS ParentDescription, 
           TeamCP, dbo.tblTeam.cycleID, dbo.tblTeam.cycleStart
FROM         dbo.tblTeam INNER JOIN
                      dbo.tblGroup ON dbo.tblTeam.ParentID = dbo.tblGroup.grpID
WHERE     (dbo.tblTeam.teamIn = 0)

UNION

SELECT     dbo.tblTeam.teamID, ParentID, dbo.tblTeam.description, dbo.tblTeam.teamSize, dbo.tblTeam.weight,
           teamIn, 'Wing' as teamInName, dbo.tblWing.description AS ParentDescription, 
           TeamCP, dbo.tblTeam.cycleID, dbo.tblTeam.cycleStart
FROM         dbo.tblTeam INNER JOIN
                      dbo.tblWing ON dbo.tblTeam.ParentID = dbo.tblWing.wingID
WHERE     (dbo.tblTeam.teamIn = 1)

union

SELECT     dbo.tblTeam.teamID, ParentID,dbo.tblTeam.description, dbo.tblTeam.teamSize, dbo.tblTeam.weight,
           teamIn,'Sqn' as teamInName,  dbo.tblSquadron.description AS ParentDescription, 
           TeamCP, dbo.tblTeam.cycleID, dbo.tblTeam.cycleStart
FROM         dbo.tblTeam INNER JOIN
                      dbo.tblSquadron ON dbo.tblTeam.ParentID = dbo.tblSquadron.sqnID
WHERE     (dbo.tblTeam.teamIn = 2)

union

SELECT     dbo.tblTeam.teamID, ParentID,dbo.tblTeam.description, dbo.tblTeam.teamSize, dbo.tblTeam.weight,
           teamIn,'Flight' as teamInName  , dbo.tblFlight.description AS ParentDescription, 
           TeamCP, dbo.tblTeam.cycleID, dbo.tblTeam.cycleStart
FROM         dbo.tblTeam INNER JOIN
                      dbo.tblFlight ON dbo.tblTeam.ParentID = dbo.tblFlight.fltID
WHERE     (dbo.tblTeam.teamIn = 3)

union

SELECT    MainTeamTable.teamID, MainTeamTable.ParentID,MainTeamTable.description, MainTeamTable.teamSize, 
          MainTeamTable.weight, MainTeamTable.teamIn,'Team' as teamInName  , 
          dbo.tblTeam.description AS ParentDescription, 
          MainTeamTable.TeamCP, MainTeamTable.cycleID, MainTeamTable.cycleStart
FROM         dbo.tblTeam as MainTeamTable INNER JOIN
                      dbo.tblTeam ON MainTeamTable.ParentID = dbo.tblTeam.TeamID
WHERE     (MainTeamTable.teamIn = 4)

UNION

SELECT    MainTeamTable.teamID, MainTeamTable.ParentID,MainTeamTable.description, MainTeamTable.teamSize, 
          MainTeamTable.weight, MainTeamTable.teamIn,'Team' as teamInName  , 
          dbo.tblTeam.description AS ParentDescription, 
          MainTeamTable.TeamCP, MainTeamTable.cycleID, MainTeamTable.cycleStart
FROM         dbo.tblTeam as MainTeamTable INNER JOIN
                      dbo.tblTeam ON MainTeamTable.ParentID = dbo.tblTeam.TeamID
WHERE     (MainTeamTable.teamIn = 5)
GO
/****** Object:  View [dbo].[vwTeamList2]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE view [dbo].[vwTeamList2]  AS

SELECT     dbo.tblTeam.teamID, ParentID, dbo.tblTeam.description, dbo.tblTeam.teamSize, dbo.tblTeam.weight,teamIn, 'Wing' as teamInName, dbo.tblWing.description AS ParentDescription, TeamCP
FROM         dbo.tblTeam INNER JOIN
                      dbo.tblWing ON dbo.tblTeam.ParentID = dbo.tblWing.wingID
WHERE     (dbo.tblTeam.teamIn = 1)

union

SELECT	TopView.teamID, ParentID,TopView.description, TopView.teamSize, TopView.weight,teamIn,'Sqn' as teamInName,
	
	(select tblWing.Description from tblWing inner join tblSquadron on tblSquadron.WingID = tblWing.WingID
	where tblSquadron.SqnID = TopView.ParentId)
	+ ' > ' + dbo.tblSquadron.description AS ParentDescription, TeamCP

	FROM dbo.tblTeam as TopView INNER JOIN
        dbo.tblSquadron ON TopView.ParentID = dbo.tblSquadron.sqnID
	WHERE     (TopView.teamIn = 2)

union


SELECT	TopView.teamID, ParentID,TopView.description, TopView.teamSize, TopView.weight,teamIn,'Flight' as teamInName,
	(select tblWing.Description from tblWing inner join tblSquadron on tblSquadron.WingID = tblWing.WingID
	where tblSquadron.SqnID = (select tblSquadron.SqnID from tblSquadron inner join tblFlight on tblFlight.SqnID = tblSquadron.SqnID
	where tblFlight.FltID = TopView.ParentId))
	+ ' > ' + (select tblSquadron.Description from tblSquadron inner join tblFlight on tblFlight.SqnID = tblSquadron.SqnID
	where tblFlight.FltID = TopView.ParentId)
	+ ' > ' + dbo.tblFlight.description AS ParentDescription,
	TeamCP

	FROM dbo.tblTeam as TopView INNER JOIN
        dbo.tblFlight ON TopView.ParentID = dbo.tblFlight.fltID
	WHERE (TopView.teamIn = 3)

union

SELECT	TopView.teamID, TopView.ParentID,TopView.description, TopView.teamSize, TopView.weight,TopView.teamIn,'Team' as teamInName,
	
	--Case TopView.TeamIn 
	--when 3 then
	--(select tblSquadron.Description from tblSquadron inner join tblFlight on tblFlight.FltID = tblSquadron.SqnID
	--where tblFlight.fltID = (select tblFlight.fltID from tblflight inner join tblTeam on tblTeam.ParentID = tblFlight.FltID
	--where tblTeam.TeamID = TopView.ParentId))
	--+ ' > ' +
	


	--(select tblFlight.Description from tblFlight inner join tblTeam on tblTeam.ParentID = tblFlight.FltID
	--where tblTeam.TeamID = TopView.ParentId)
	--+ ' > ' + dbo.tblTeam.description
	--when 3 then

	--(select tblFlight.Description from tblFlight inner join tblTeam on tblTeam.ParentID = tblFlight.FltID
	--where tblTeam.TeamID = TopView.ParentId)
	--+ ' > ' + dbo.tblTeam.description



	--else
	dbo.tblTeam.description
	--End
	
	AS ParentDescription,
	TopView.TeamCP
	FROM dbo.tblTeam as TopView INNER JOIN dbo.tblTeam ON TopView.ParentID = dbo.tblTeam.TeamID
	WHERE (TopView.teamIn = 4)
GO
/****** Object:  View [dbo].[vwTeamHierachyChild4]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTeamHierachyChild4]
AS
SELECT     TOP 100 PERCENT dbo.tblTeamHierarchy.teamID,tblTeamHierarchy_4.teamID AS child4
FROM         dbo.tblTeamHierarchy LEFT OUTER JOIN
                      dbo.tblTeamHierarchy tblTeamHierarchy_1 ON dbo.tblTeamHierarchy.teamID = tblTeamHierarchy_1.ParentID LEFT OUTER JOIN
                      dbo.tblTeamHierarchy tblTeamHierarchy_2 ON tblTeamHierarchy_1.teamID = tblTeamHierarchy_2.ParentID LEFT OUTER JOIN
                      dbo.tblTeamHierarchy tblTeamHierarchy_3 ON tblTeamHierarchy_2.teamID = tblTeamHierarchy_3.ParentID LEFT OUTER JOIN
                      dbo.tblTeamHierarchy tblTeamHierarchy_4 ON tblTeamHierarchy_3.teamID = tblTeamHierarchy_4.ParentID
where tblTeamHierarchy_4.teamID is not null
ORDER BY dbo.tblTeamHierarchy.teamID,child4 asc
GO
/****** Object:  View [dbo].[vwTeamHierachyChild3]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTeamHierachyChild3]
AS
SELECT     TOP 100 PERCENT dbo.tblTeamHierarchy.teamID,tblTeamHierarchy_3.teamID AS child3
FROM         dbo.tblTeamHierarchy LEFT OUTER JOIN
                      dbo.tblTeamHierarchy tblTeamHierarchy_1 ON dbo.tblTeamHierarchy.teamID = tblTeamHierarchy_1.ParentID LEFT OUTER JOIN
                      dbo.tblTeamHierarchy tblTeamHierarchy_2 ON tblTeamHierarchy_1.teamID = tblTeamHierarchy_2.ParentID LEFT OUTER JOIN
                      dbo.tblTeamHierarchy tblTeamHierarchy_3 ON tblTeamHierarchy_2.teamID = tblTeamHierarchy_3.ParentID 
where tblTeamHierarchy_3.teamID is not null
ORDER BY dbo.tblTeamHierarchy.teamID,child3 asc
GO
/****** Object:  View [dbo].[vwTeamHierachyChild2]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTeamHierachyChild2]
AS
SELECT     TOP 100 PERCENT dbo.tblTeamHierarchy.teamID,tblTeamHierarchy_2.teamID AS child2
FROM         dbo.tblTeamHierarchy LEFT OUTER JOIN
                      dbo.tblTeamHierarchy tblTeamHierarchy_1 ON dbo.tblTeamHierarchy.teamID = tblTeamHierarchy_1.ParentID LEFT OUTER JOIN
                      dbo.tblTeamHierarchy tblTeamHierarchy_2 ON tblTeamHierarchy_1.teamID = tblTeamHierarchy_2.ParentID 
where tblTeamHierarchy_2.teamID is not null
ORDER BY dbo.tblTeamHierarchy.teamID,child2 asc
GO
/****** Object:  View [dbo].[vwTeamHierachyChild1]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTeamHierachyChild1]
AS
SELECT     TOP 100 PERCENT dbo.tblTeamHierarchy.teamID,tblTeamHierarchy_1.teamID AS child1
FROM         dbo.tblTeamHierarchy LEFT OUTER JOIN
                      dbo.tblTeamHierarchy tblTeamHierarchy_1 ON dbo.tblTeamHierarchy.teamID = tblTeamHierarchy_1.ParentID 
where tblTeamHierarchy_1.teamID is not null
ORDER BY dbo.tblTeamHierarchy.teamID,child1 asc
GO
/****** Object:  View [dbo].[vwTaskMovements]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTaskMovements]
AS
SELECT     TOP (100) PERCENT dbo.tbl_TaskStaff.taskStaffID, dbo.tblStaff.staffID, dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.serviceno, dbo.tbl_TaskStaff.startDate, 
                      dbo.tbl_TaskStaff.endDate, dbo.tbl_Task.description, dbo.tblTaskType.description AS Type
FROM         dbo.tblStaff INNER JOIN
                      dbo.tbl_TaskStaff ON dbo.tblStaff.staffID = dbo.tbl_TaskStaff.staffID INNER JOIN
                      dbo.tbl_Task ON dbo.tbl_TaskStaff.taskID = dbo.tbl_Task.taskID INNER JOIN
                      dbo.tblTaskType ON dbo.tbl_Task.ttID = dbo.tblTaskType.ttID
WHERE     (dbo.tbl_TaskStaff.active = 1)
ORDER BY dbo.tblStaff.surname, dbo.tbl_TaskStaff.startDate DESC
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblStaff"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 204
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tbl_TaskStaff"
            Begin Extent = 
               Top = 6
               Left = 242
               Bottom = 125
               Right = 402
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tbl_Task"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblTaskType"
            Begin Extent = 
               Top = 126
               Left = 236
               Bottom = 245
               Right = 396
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTaskMovements'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTaskMovements'
GO
/****** Object:  View [dbo].[vwTaskCategoryList]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTaskCategoryList]
AS
SELECT     dbo.tbl_TaskCategory.taskCategoryID AS qID, dbo.tbl_TaskCategory.description, dbo.tbl_TaskCategory.taskTypeID AS typeID, 
                      dbo.tblTaskType.description AS TypeDescription
FROM         dbo.tbl_TaskCategory INNER JOIN
                      dbo.tblTaskType ON dbo.tbl_TaskCategory.taskTypeID = dbo.tblTaskType.ttID
GO
/****** Object:  View [dbo].[vwStaffQs]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwStaffQs]
AS
SELECT     TOP 100 PERCENT dbo.tblStaff.staffID, dbo.tblStaffQs.QID AS staffQID, dbo.tblStaffQs.TypeID, dbo.tblStaffQs.Competent, dbo.tblStaffQs.ValidFrom, 
                      dbo.tblStaffQs.ValidEnd
FROM         dbo.tblStaff INNER JOIN
                      dbo.tblStaffQs ON dbo.tblStaff.staffID = dbo.tblStaffQs.StaffID

ORDER BY dbo.tblStaff.staffID
GO
/****** Object:  View [dbo].[vwstaffPostWithEndDate]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwstaffPostWithEndDate]
AS
SELECT     TOP 100 PERCENT dbo.tblStaff.serviceno AS serviceno, dbo.tblStaffPost.StaffID, dbo.tblStaffPost.startDate, dbo.tblStaffPost.endDate
FROM         dbo.tblStaffPost INNER JOIN
                      dbo.tblStaff ON dbo.tblStaffPost.StaffID = dbo.tblStaff.staffID
WHERE     (dbo.tblStaffPost.endDate IS NOT NULL)
ORDER BY dbo.tblStaffPost.endDate
GO
/****** Object:  View [dbo].[vwStaffPostQs]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwStaffPostQs]
AS
SELECT     TOP 100 PERCENT dbo.tblStaffPost.StaffID, dbo.tblStaffPost.PostID, dbo.tblPostQs.QID AS PostQID, dbo.tblPostQs.typeID , dbo.tblPostQs.Status, dbo.tblPostQStatus.QWType, 
                      dbo.tblQWeight.qwvalue, dbo.tblStaffPost.startDate, dbo.tblStaffPost.endDate
FROM         dbo.tblStaffPost INNER JOIN
                      dbo.tblPostQs ON dbo.tblStaffPost.PostID = dbo.tblPostQs.PostID INNER JOIN
                      dbo.tblPostQStatus ON dbo.tblPostQs.Status = dbo.tblPostQStatus.PostQStatus INNER JOIN
                      dbo.tblQWeight ON dbo.tblPostQStatus.QWType = dbo.tblQWeight.qwtype

ORDER BY dbo.tblStaffPost.StaffID
GO
/****** Object:  View [dbo].[vwStaffPostMS]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwStaffPostMS]
AS
SELECT     TOP 100 PERCENT dbo.tblStaffPost.StaffID, dbo.tblStaffPost.PostID, dbo.tblStaffPost.startDate, dbo.tblStaffPost.endDate, 
                      dbo.tblMilitarySkills.description, dbo.tblPostMilSkill.MSID, 1 AS qWValue, dbo.tblMilitarySkills.msID AS PostMSID
FROM         dbo.tblStaffPost INNER JOIN
                      dbo.tblPostMilSkill ON dbo.tblStaffPost.PostID = dbo.tblPostMilSkill.postID INNER JOIN
                      dbo.tblMilitarySkills ON dbo.tblPostMilSkill.MSID = dbo.tblMilitarySkills.msID
ORDER BY dbo.tblStaffPost.StaffID, dbo.tblStaffPost.PostID
GO
/****** Object:  View [dbo].[vwStaffPostHistory]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwStaffPostHistory]
AS
SELECT     dbo.tblStaffPost.StaffPostID, dbo.tblStaffPost.StaffID, dbo.tblStaffPost.PostID, dbo.tblStaffPost.startDate, dbo.tblStaffPost.endDate, dbo.tblStaff.surname, 
                      dbo.tblStaff.firstname, dbo.tblStaff.serviceno, dbo.tblPost.assignno, dbo.tblPost.description AS postDescription
FROM         dbo.tblStaffPost INNER JOIN
                      dbo.tblStaff ON dbo.tblStaffPost.StaffID = dbo.tblStaff.staffID INNER JOIN
                      dbo.tblPost ON dbo.tblStaffPost.PostID = dbo.tblPost.postID
GO
/****** Object:  View [dbo].[vwStaffMS]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwStaffMS]
AS
SELECT     TOP 100 PERCENT dbo.tblStaff.staffID, dbo.tblStaffMilSkill.ValidFrom, dbo.tblStaffMilSkill.ValidTo AS validEnd, 
                      dbo.tblStaffMilSkill.MSID AS staffMSID
FROM         dbo.tblStaff INNER JOIN
                      dbo.tblStaffMilSkill ON dbo.tblStaff.staffID = dbo.tblStaffMilSkill.StaffID
ORDER BY dbo.tblStaff.staffID
GO
/****** Object:  View [dbo].[vwStaffInPost]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[vwStaffInPost]

AS

SELECT     TOP 100 PERCENT dbo.tblStaffPost.StaffPostID, dbo.tblPost.postID, dbo.tblPost.assignno, dbo.tblPost.Ghost, dbo.tblPost.Status, dbo.tblManager.tmID AS Mgr, 
                      dbo.tblPost.description, dbo.tblPost.teamID, dbo.tblTeam.description AS TeamName, dbo.tblStaffPost.startDate, dbo.tblStaffPost.endDate, 
                      dbo.tblStaff.firstname, dbo.tblStaff.surname, dbo.tblStaff.serviceno, dbo.tblRank.rankID, dbo.tblRank.shortDesc, dbo.tblRank.Weight, 
                      dbo.tblRank.weightScore, dbo.tblStaff.staffID, dbo.tblTrade.description AS Trade, dbo.tblPost.QTotal AS QualTotal, dbo.tblStaff.workPhone, 
                      dbo.tblStaff.lastOOA, dbo.tblStaff.active, dbo.tblStaff.dischargeDate, DATEADD([Year], - 1, dbo.tblStaff.dischargeDate) AS startReset, 
                      dbo.tblStaff.ddooa AS ooadays
FROM         dbo.tblTrade INNER JOIN
                      dbo.tblStaff ON dbo.tblTrade.tradeID = dbo.tblStaff.tradeID RIGHT OUTER JOIN
                      dbo.tblPost INNER JOIN
                      dbo.tblTeam ON dbo.tblPost.teamID = dbo.tblTeam.teamID LEFT OUTER JOIN
                      dbo.tblStaffPost ON dbo.tblPost.postID = dbo.tblStaffPost.PostID ON dbo.tblStaff.staffID = dbo.tblStaffPost.StaffID LEFT OUTER JOIN
                      dbo.tblRank ON dbo.tblStaff.rankID = dbo.tblRank.rankID LEFT OUTER JOIN
                      dbo.tblManager ON dbo.tblManager.postID = dbo.tblPost.postID LEFT OUTER JOIN
                      dbo.tblStaffHarmony ON dbo.tblStaffHarmony.staffID = dbo.tblStaff.staffID
ORDER BY dbo.tblPost.teamID, dbo.tblPost.postID DESC, dbo.tblStaffPost.startDate, dbo.tblStaffPost.endDate
GO
/****** Object:  View [dbo].[vwPostMovements]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPostMovements]
AS
SELECT     TOP 100 PERCENT dbo.tblStaffPost.StaffPostID, dbo.tblStaff.staffID, dbo.tblPost.assignno, dbo.tblPost.description, dbo.tblStaff.surname, 
                      dbo.tblStaff.firstname, dbo.tblStaff.serviceno, dbo.tblStaffPost.startDate, dbo.tblStaffPost.endDate, dbo.tblTeam.description AS Team
FROM         dbo.tblStaff INNER JOIN
                      dbo.tblStaffPost ON dbo.tblStaff.staffID = dbo.tblStaffPost.StaffID INNER JOIN
                      dbo.tblPost ON dbo.tblStaffPost.PostID = dbo.tblPost.postID INNER JOIN
                      dbo.tblTeam ON dbo.tblPost.teamID = dbo.tblTeam.teamID
ORDER BY dbo.tblStaff.surname, dbo.tblStaffPost.startDate DESC
GO
/****** Object:  View [dbo].[vwPostList]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPostList]

AS

SELECT DISTINCT tblPost.postID, tblPost.description, tblPost.assignno, tblTeam.teamID, tblTeam.description AS team, tblRank.shortDesc + ' ' + tblStaff.surname + ', ' + tblStaff.firstname AS postholder, tblPost.Ghost, tblPost.Status
FROM tblPost
INNER JOIN tblRank ON tblPost.rankID = tblRank.rankID
LEFT OUTER JOIN tblTeam ON tblTeam.teamID = tblPost.teamID
LEFT OUTER JOIN tblStaffPost ON tblStaffPost.PostID = tblPost.postID AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE())
LEFT OUTER JOIN tblStaff ON tblStaff.staffID = tblStaffPost.StaffID
GO
/****** Object:  View [dbo].[vwPersonnelSummaryList]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vwPersonnelSummaryList]
AS
SELECT dbo.tblStaff.staffID, dbo.tblStaff.serviceno, dbo.tblStaff.firstname, 
       dbo.tblStaff.surname, dbo.tblRank.shortDesc, dbo.tblStaff.rankID,dbo.tblStaff.tradeID,
       dbo.tblPost.description AS PostDescription,dbo.tblStaffPost.PostID, 
       dbo.tblPost.assignno, dbo.tblTeam.teamID, dbo.tblTeam.description AS team, 
       dbo.tblStaffPost.startDate, dbo.tblStaffPost.endDate, dbo.tblManager.tmID AS Manager, 
       dbo.tblStaff.lastOOA, dbo.tblStaff.administrator,dbo.tblMES.description AS messtat 
    FROM dbo.tblStaff 
      INNER JOIN dbo.tblRank ON dbo.tblStaff.rankID = dbo.tblRank.rankID 
      LEFT OUTER JOIN dbo.tblStaffPost ON dbo.tblStaffPost.StaffID = dbo.tblStaff.staffID 
      LEFT OUTER JOIN dbo.tblMES ON dbo.tblMES.mesID = dbo.tblStaff.mesID 
      LEFT OUTER JOIN dbo.tblPost ON dbo.tblPost.postID = dbo.tblStaffPost.PostID 
      LEFT OUTER JOIN dbo.tblTeam ON dbo.tblPost.teamID = dbo.tblTeam.teamID 
      LEFT OUTER JOIN dbo.tblManager ON dbo.tblManager.postID = dbo.tblPost.postID
GO
/****** Object:  View [dbo].[vwParentList]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  view [dbo].[vwParentList]  AS

SELECT     grpID as ParentID,description,0 as Teamin 
FROM       dbo.tblGroup 

UNION

SELECT     WingID as ParentID,description,1 as Teamin 
FROM       dbo.tblWing 

union

SELECT     SqnID as ParentID,description,2 as Teamin 
FROM       dbo.tblSquadron 

union

SELECT     fltID as ParentID,description,3 as Teamin 
FROM       dbo.tblFlight

union

SELECT    TeamID as ParentID,description, 4 as Teamin 
FROM       dbo.tblTeam
             WHERE dbo.tblTeam.teamin = 3
union

SELECT    TeamID as ParentID,description, 5 as Teamin 
FROM       dbo.tblTeam
             WHERE dbo.tblTeam.teamin = 4
GO
/****** Object:  View [dbo].[vwListOfAllTasksByName]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwListOfAllTasksByName]
AS
SELECT DISTINCT 
                      TOP (100) PERCENT dbo.tblStaff.surname, dbo.tblStaff.firstname, dbo.tblStaff.serviceno, dbo.tblRank.shortDesc AS Rank, dbo.tbl_TaskStaff.startDate, 
                      dbo.tbl_TaskStaff.endDate, dbo.tbl_Task.description AS taskType
FROM         dbo.tblStaff INNER JOIN
                      dbo.tblStaffPost ON dbo.tblStaff.staffID = dbo.tblStaffPost.StaffID INNER JOIN
                      dbo.tblPost ON dbo.tblStaffPost.PostID = dbo.tblPost.postID INNER JOIN
                      dbo.tbl_TaskStaff ON dbo.tblStaff.staffID = dbo.tbl_TaskStaff.staffID INNER JOIN
                      dbo.tbl_Task ON dbo.tbl_TaskStaff.taskID = dbo.tbl_Task.taskID INNER JOIN
                      dbo.tblRank ON dbo.tblStaff.rankID = dbo.tblRank.rankID
WHERE     (dbo.tbl_TaskStaff.active = 1) AND (dbo.tbl_Task.ttID <> 27)
ORDER BY dbo.tblStaff.surname, dbo.tbl_TaskStaff.startDate
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblStaff"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 204
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblStaffPost"
            Begin Extent = 
               Top = 6
               Left = 242
               Bottom = 125
               Right = 402
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblPost"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tbl_TaskStaff"
            Begin Extent = 
               Top = 126
               Left = 236
               Bottom = 245
               Right = 396
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tbl_Task"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 365
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblRank"
            Begin Extent = 
               Top = 246
               Left = 236
               Bottom = 365
               Right = 396
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwListOfAllTasksByName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'       Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwListOfAllTasksByName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwListOfAllTasksByName'
GO
/****** Object:  View [dbo].[vwGetStaffForTasking]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGetStaffForTasking]

AS

SELECT tblStaff.staffID AS staffNo, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblStaff.dischargeDate, DATEADD([Year], - 1, 
tblStaff.dischargeDate) AS startReset, tblStaff.ddooa AS ooadays, tblStaff.ddssa AS ssadays, tblStaff.ddssb AS ssbdays, 
tblStaff.lastOOA, tblStaff.active, tblStaffPost.endDate, tblPost.teamID, tblTeam.description AS TeamName
FROM tblStaff
INNER JOIN tblStaffPost ON tblStaffPost.StaffID = tblStaff.staffID
INNER JOIN tblPost ON tblPost.postID = tblStaffPost.PostID
INNER JOIN tblTeam ON tblTeam.teamID = tblPost.teamID
WHERE (tblPost.Ghost = 0)
GO
/****** Object:  StoredProcedure [dbo].[spWingUpdate]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spWingUpdate]
(
	@WingID		INT,
	@GroupID	INT,
	@Description	VARCHAR(50),
	@blnExists	BIT OUTPUT
)

AS

SET NOCOUNT ON

UPDATE tblWing SET
grpID = @GroupID,
Description = @Description
WHERE WingID = @WingID

SET @blnExists = 0

IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spStaffTaskDetails]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[spStaffTaskDetails] 
@startDate varchar (30),
@endDate varchar (30),
@staffID int

as

SET dateformat dmy

select tbl_taskStaff.TaskStaffID,tbl_Task.Description,  tbl_Task.ttID as type, tbl_Task.TaskID as task, 
       tbl_taskStaff.startDate,tbl_taskStaff.endDate,taskNote, tblTaskType.taskcolor 
  from tbl_taskStaff
          inner join tbl_Task on tbl_Task.TaskID = tbl_taskStaff.TaskID
          inner join tblTaskType on tblTaskType.ttID = tbl_Task.ttID
where 
(
(tbl_taskStaff.startDate >= @startDate and tbl_taskStaff.startDate <= @endDate)
or
(tbl_taskStaff.endDate >= @startDate and tbl_taskStaff.endDate <= @endDate)
or 
((tbl_taskStaff.startDate >= @startDate and tbl_taskStaff.startDate <= @endDate)and tbl_taskStaff.endDate > @endDate )
or 
((tbl_taskStaff.endDate >= @startDate and tbl_taskStaff.endDate <= @endDate)and tbl_taskStaff.startDate < @startDate )
or
(tbl_taskStaff.endDate > @endDate and tbl_taskStaff.startDate < @startDate )
)
 
and staffId=@staffID and tbl_TaskStaff.active =1
order by tbl_taskStaff.startDate
GO
/****** Object:  StoredProcedure [dbo].[spStaffPostUpdate]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spStaffPostUpdate] 
(
	@PostID		INT,
	@StaffID	INT,
	@startdate	VARCHAR(12),
	@endDate	VARCHAR(12)
)

AS

SET DATEFORMAT DMY

DECLARE @nodeID INT

SET @nodeID=(SELECT ndeID FROM tblPost WHERE tblPost.postID=@postID)

-- if they are not already in this post
IF NOT EXISTS (SELECT staffPostId FROM tblStaffPost WHERE staffid = @staffid and postid = @postid and (endDate >= @startDate or endDate is null) and startDate < @startDate)
	BEGIN
		IF EXISTS (SELECT staffPostID FROM tblStaffPost WHERE (endDate >= @startDate OR endDate IS NULL) AND startDate < @startDate)
			BEGIN
				UPDATE tblStaffPost SET
				endDate = CONVERT(DATETIME,@startDate)-1 
				WHERE (endDate > @startDate OR endDate IS NULL) AND 
				startDate < @startDate AND postId = @postID
			END

			UPDATE tbl_taskStaff SET
			active = 0
			WHERE taskStaffID IN
			(SELECT taskStaffID FROM tbl_taskStaff AS outerTable
			WHERE staffID = @StaffID AND 
			(SELECT ttID FROM tbl_task INNER JOIN tbl_taskStaff ON tbl_taskStaff.taskID = tbl_task.taskID 
			WHERE tbl_taskStaff.staffID = @StaffID AND outerTable.taskstaffId = tbl_taskStaff.taskstaffId AND active = 1) = 27)

			INSERT INTO tblStaffPost (staffID,PostID,startDate,endDate,ndeID)
			VALUES (@StaffId,@PostID,@StartDate, @endDate,@nodeID)
                        
			-- now flag the staff record as active cos they are i post
			UPDATE tblstaff 
			   SET active = 1,
			       ndeID = @nodeID
			WHERE tblstaff.staffid = @staffid
	END
GO
/****** Object:  StoredProcedure [dbo].[spStaffPostRemove]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spStaffPostRemove]
@StaffID int 
as 

update tblstaff set PostID = null where tblstaff.StaffID=@staffID
GO
/****** Object:  StoredProcedure [dbo].[spStaffPostDetails]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create     PROCEDURE [dbo].[spStaffPostDetails]
@StaffPostID INT

AS


SELECT     dbo.tblStaffPost.StaffPostID, dbo.tblPost.description, dbo.tblPost.assignno, dbo.tblTeam.description AS TeamName, dbo.tblStaff.surname, 
                      dbo.tblStaff.firstname, dbo.tblStaffPost.startDate, dbo.tblStaffPost.endDate
FROM         dbo.tblPost INNER JOIN
                      dbo.tblStaffPost ON dbo.tblPost.postID = dbo.tblStaffPost.PostID INNER JOIN
                      dbo.tblStaff ON dbo.tblStaffPost.StaffID = dbo.tblStaff.staffID INNER JOIN
                      dbo.tblTeam ON dbo.tblPost.teamID = dbo.tblTeam.teamID

where StaffPostID=@StaffPostID
GO
/****** Object:  StoredProcedure [dbo].[spSSCUpdate]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spSSCUpdate]
@RecID int,
@SSC int,
@Description varchar (50),
@type int,
@notes VARCHAR(500)

as

update tblSSC 
  SET ssCode=@SSC,
      Description=@Description,
      ssType=@type,
      ssNotes=@notes      
    where tblSSC.sscid = @recid
GO
/****** Object:  StoredProcedure [dbo].[spSSCInsert]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[spSSCInsert]
@nodeID INT,
@SSC int,
@Description varchar (50),
@type int,
@notes VARCHAR(500)

AS

INSERT tblSSC (ndeID,ssCode,Description,ssType, ssNotes)
       VALUES (@nodeID, @SSC,@Description,@type, @notes)
GO
/****** Object:  StoredProcedure [dbo].[spSquadronUpdate]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spSquadronUpdate]
(
	@RecID		INT,
	@wingID		INT,
	@Description	VARCHAR(50),
	@blnExists	BIT OUTPUT
)

AS

SET NOCOUNT ON

UPDATE tblSquadron SET
wingID = @wingID,
Description = @Description
WHERE SqnID = @RecID

SET @blnExists = 0

IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spSquadronInsert]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spSquadronInsert]
(
	@wingID	INT,
	@Description	VARCHAR(50),
	@blnExists	BIT OUTPUT
)

AS

SET NOCOUNT ON

IF EXISTS (SELECT Description FROM tblSquadron WHERE Description = @Description)
	BEGIN
		SET @blnExists = 1
	END
ELSE
	BEGIN
		INSERT tblSquadron (Description, wingID)
		VALUES (@Description, @wingID)

		SET @blnExists = 0
	END

IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spSquadronDetail]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE       PROCEDURE [dbo].[spSquadronDetail]
@RecID int
as

select tblSquadron.SqnID, tblSquadron.wingID, tblSquadron.description, tblwing.description wing from tblSquadron
  inner join tblwing ON
     tblwing.wingID = tblSquadron.wingID
       where SqnID=@RecID
GO
/****** Object:  StoredProcedure [dbo].[spSquadronDel]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spSquadronDel]
@recID int,
@DelOK int OUTPUT
as

-- has it got a flight or a team assigned to it
IF (
    EXISTS (SELECT TOP 1 fltID from tblFlight WHERE tblFlight.sqnID = @recID) 
     OR
    EXISTS (SELECT TOP 1 teamID from tblTeam WHERE (tblTeam.parentID = @recID AND tblTeam.teamIn= '2'))
    ) 
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spResetPW]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spResetPW]

@staffID int,
@randomWord VARCHAR(9) OUT

AS

DECLARE @pw varchar(32)
DECLARE @charset varchar(300)
DECLARE @randCharsetPos int


-- get generic password

set @randomWord = ''
set @charset = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

--  Build a random word, 9 Chars long from the charset

while len(@randomWord) < 9
BEGIN
	set @randCharsetPos = (select CAST ((rand() * LEN(@charset)) AS INT))
	set @randomWord = @randomWord + (select substring(@charset, @randCharsetPos, 1))
END
	
SET @pw = (SELECT substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', @randomWord)),3,32))


UPDATE dbo.tblPassword
SET staffPW = @randomWord, pswd = @pw, dPswd = @pw, expires = (GETDATE()+60)
WHERE staffID = @staffID
GO
/****** Object:  StoredProcedure [dbo].[spPostStaffCurrent]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPostStaffCurrent]
(
	@StaffPostID	INT
)

AS

SELECT tblStaffPost.StaffPostID, tblPost.description, tblPost.assignno, tblStaff.surname AS postholder, tblStaff.firstname, tblStaffPost.startDate, 
       tblStaffPost.endDate, tblRank.shortdesc, tblHierarchy.hrcname
  FROM tblPost
   INNER JOIN tblStaffPost ON tblPost.postID = tblStaffPost.PostID  AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE())
   INNER JOIN tblStaff ON tblStaffPost.StaffID = tblStaff.staffID
   INNER JOIN tblHierarchy ON tblPost.hrcID = tblHierarchy.hrcID
   INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
     WHERE StaffPostID = @StaffPostID
GO
/****** Object:  StoredProcedure [dbo].[spSetGenPW]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spSetGenPW]
@nodeID INT,
@pwd VARCHAR(50),
@oldpwd VARCHAR(50),
@err VARCHAR(50) OUT
AS

SET @err= 'The Default Password Change Failed'

-- this MUST be a TRANSACTION cos if one fails we must backout
BEGIN TRANSACTION

  -- first change default password
  UPDATE dbo.tblGenericPW
    SET dbo.tblGenericPW.genericPW = @pwd 
      WHERE ndeID=@nodeID

  IF @@ERROR <> 0
   BEGIN   
     ROLLBACK TRAN
   END

  -- now update all existing staff default passwords to the new one
  UPDATE dbo.tblPassword
    SET dbo.tblPassword.staffPW=@pwd
        WHERE dbo.tblPassword.ndeID=@nodeID AND dbo.tblPassword.staffPW=@oldpwd

  IF @@ERROR <> 0
   BEGIN
     ROLLBACK TRAN
   END

-- if we get to here the change is good
SET @err=''
COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [dbo].[spTableInfo]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[spTableInfo]

AS

select 'tblQtypes' as tableName,* from tblQtypes

select 'tblTechQs' as tableName,* from tblTechQs

select 'tblOpsQs' as tableName,* from tblOpsQs

select 'tblMilitaryVacs' as tableName,* from tblMilitaryVacs

select 'tblMilitarySkills' as tableName,* from tblMilitarySkills

select 'tblGeneralQs' as tableName,* from tblGeneralQs

select 'tblFitness' as tableName,* from tblFitness

select 'tblDriverQs' as tableName,* from tblDriverQs

select 'tblDental' as tableName,* from tblDental
GO
/****** Object:  StoredProcedure [dbo].[spTaskPersonnelRemove]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        PROCEDURE [dbo].[spTaskPersonnelRemove]
@taskID INT,
@taskStaffID int
AS


declare @staffID int
declare @ooadays int
declare @ooa int
declare @start datetime
declare @end datetime
declare @ooa_error int, @del_error int

SET @staffID=(SELECT staffID from tbl_taskStaff where  taskStaffID = @taskStaffID)
SET @ooa=(SELECT ooa FROM tbl_Task WHERE tbl_Task.taskID=@taskID)
SET @start=(SELECT startdate from tbl_taskStaff where  taskStaffID = @taskStaffID)
SET @end=(SELECT enddate from tbl_taskStaff where  taskStaffID = @taskStaffID)

-- default to zero cos if its not OOA then it will undo Transaction otherwise
SET @ooa_error = 0

-- If its an Out of Area task ( OOA) then get the number of days
-- so we can reduce the OOA days for this person
BEGIN TRANSACTION
  /** NOT ANY MORE - ITS DONE DIFFERENTLY NOW
  IF @ooa=1
    BEGIN
     SET @ooadays=datediff(day, @start, @end)
     UPDATE tblStaffHarmony
       SET tblStaffHarmony.ooadays=(tblStaffHarmony.ooadays - @ooadays)
             WHERE tblStaffHarmony.staffID=@staffID
     SET @ooa_error = @@error 

    END
  **/
  delete tbl_taskStaff where  taskStaffID = @taskStaffID
  SET @del_error = @@error

  -- the transaction worked so commit it
  --IF @ooa_error = 0 AND @del_error = 0
  IF @ooa_error = 0 AND @del_error = 0
    COMMIT TRANSACTION
  ELSE
    ROLLBACK TRANSACTION
GO
/****** Object:  StoredProcedure [dbo].[spTaskPersonnelCheck]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spTaskPersonnelCheck]
(
	@taskID	INT,
	@currentUser	INT
)

AS

SELECT DISTINCT tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tbl_Task.description, tbl_TaskStaff.startDate, 
                tbl_TaskStaff.endDate, tbl_Task.taskID, tblStaff.staffID
    FROM tblStaff
        INNER JOIN tbl_TaskStaff ON tblStaff.staffID = tbl_TaskStaff.staffID
        INNER JOIN tblTaskClash ON tbl_TaskStaff.taskStaffID = tblTaskClash.taskStaffID
        INNER JOIN tbl_Task ON tbl_TaskStaff.taskID = tbl_Task.taskID
         WHERE userID = @currentUser
           ORDER BY surname,firstname

    DELETE tblTaskClash
      WHERE userid = @currentUser
GO
/****** Object:  StoredProcedure [dbo].[spTaskPersonnelAddAfterCheck]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spTaskPersonnelAddAfterCheck]
(
    @nodeID         INT,
	@taskID			INT,
	@staffID		INT,
	@currentUser	INT,
	@StartDate		VARCHAR(50),
	@EndDate		VARCHAR(50),
	@notes			VARCHAR(2000),
	@id				INT,
	@flag			INT
)

AS

SET DATEFORMAT dmy

--DECLARE @staffID			INT
DECLARE @newStartDate		DATETIME
DECLARE @newEndDate		DATETIME
DECLARE @taskStartDate		DATETIME
DECLARE @taskEndDate		DATETIME
DECLARE @cancellable			INT

DECLARE @TaskStaffID		INT
DECLARE @clashTaskID		INT
DECLARE @clashStartDate		DATETIME
DECLARE @clashEndDate		DATETIME
DECLARE @clashNotes			VARCHAR(2000)
DECLARE @TestWorked		VARCHAR(50)

DECLARE @check1TaskStaffID		INT
DECLARE @check2TaskStaffID		INT
DECLARE @check3TaskStaffID		INT
DECLARE @check4TaskStaffID		INT
DECLARE @check5TaskStaffID		INT
DECLARE @check6TaskStaffID		INT

--SET @staffID=CAST(@staff AS INT)

SET @check1TaskStaffID = 0
SET @check2TaskStaffID = 0
SET @check3TaskStaffID = 0
SET @check4TaskStaffID = 0
SET @check5TaskStaffID = 0
SET @check6TaskStaffID = 0

 
SET @TestWorked = 'Test1WORked'

SET @newStartDate = @Startdate/* (SELECT startDate FROM tbl_Task WHERE taskId= @taskID)*/
SET @newEndDate = @EndDate/* (SELECT ENDdate FROM tbl_Task WHERE taskId= @taskID)*/
SET @cancellable = (SELECT cancellable FROM tbl_task WHERE taskId = @taskID AND ndeID=@nodeID)


    /* This stored procedure ADDS a new task for the selected staffID. First we check to see if it clashes with any existing tasks and
       if it does we do one of two things:
         1. If the NEW task STARTS BEFORE and ENDS AFTER the existing task then DELETE the EXISTING task and replace it with the NEW one
            this is the checkANDUPDATE1 BLOCK NB: There maybe more than one existing task
         2. The NEW task clashes with PART of the existing task. We DELETE the AMNEND the Existing task dates and the ADD the new task. This means that
            the existing task may now show as a split task with the NEW task in the middle. 
            This is the checkANDUPDATE2 to checkANDUPDATE6 blocks
    */
	/*checkANDUPDATE1*/
	IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff
	WHERE active=1 AND staffId = @staffId AND @newStartDate < startDate AND @newEndDate > EndDate AND ndeID=@nodeID) OR 
	EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active =1 AND staffId = @staffId AND @newStartDate = startDate AND @newEndDate = EndDate AND ndeID=@nodeID) OR
	EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active =1 AND staffId = @staffId AND @newStartDate < startDate AND @newEndDate = EndDate AND ndeID=@nodeID) OR
	EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active =1 AND staffId = @staffId AND @newStartDate = startDate AND @newEndDate > EndDate AND ndeID=@nodeID)

	BEGIN
		UPDATE tbl_TaskStaff 
		SET	active = 0,
		    UPDATEdBy = @currentUser,
		    dateStamp = GETDATE()
		WHERE (active=1 AND staffId= @staffId AND @newStartDate < startDate AND @newEndDate > EndDate AND ndeID=@nodeID) OR
		(active=1 AND staffId= @staffId AND @newStartDate = startDate AND @newEndDate = EndDate AND ndeID=@nodeID) OR
		(active=1 AND staffId= @staffId AND @newStartDate < startDate AND @newEndDate = EndDate AND ndeID=@nodeID) OR
		(active=1 AND staffId= @staffId AND @newStartDate = startDate AND @newEndDate > EndDate AND ndeID=@nodeID)

		DELETE tbl_TaskStaff WHERE active = 0 AND staffid = @staffid AND ndeID=@nodeID
	END

    IF @flag = 1
	  BEGIN
		UPDATE tbl_TaskStaff SET active = 0	WHERE taskStaffId = @id AND ndeID=@nodeID

		DELETE tbl_TaskStaff WHERE active = 0 AND staffid = @staffid AND ndeID=@nodeID
	  END

/*checkANDUPDATE2*/
	IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate <= startDate AND @newEndDate < EndDate AND @newEndDate >= startDate AND ndeID=@nodeID)
		BEGIN
			SET @check2TaskStaffID = (SELECT taskStaffId FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate <= startDate AND @newEndDate < EndDate AND @newEndDate >= startDate AND ndeID=@nodeID)
		END

	/*checkANDUPDATE3*/
	IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate > startDate AND @newStartDate <= EndDate AND @newEndDate >= EndDate AND ndeID=@nodeID)
		BEGIN
			SET @check3TaskStaffID = (SELECT taskStaffId FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate > startDate AND @newStartDate <= EndDate AND @newEndDate >= EndDate AND ndeID=@nodeID)
		END
		
	/*checkANDUPDATE4*/
	IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate > startDate AND @newEndDate < EndDate AND ndeID=@nodeID)
		BEGIN
			SET @check4TaskStaffID = (SELECT taskStaffID FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate > startDate AND @newEndDate < EndDate AND ndeID=@nodeID)
		END
		
	/*checkANDUPDATE5*/
	IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate = startDate AND @newEndDate < EndDate AND ndeID=@nodeID)
		BEGIN
			SET @check5TaskStaffID = (SELECT taskStaffID FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate = startDate AND @newEndDate < EndDate AND ndeID=@nodeID)
		END
		
	/*checkANDUPDATE6*/

	IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate > startDate AND @newEndDate = EndDate AND ndeID=@nodeID)
		BEGIN
			SET @check6TaskStaffID = (SELECT taskStaffID FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate > startDate AND @newEndDate = EndDate AND ndeID=@nodeID)
		END

	IF @check2TaskStaffID >0
		BEGIN
			UPDATE tbl_TaskStaff
			SET startDate = @newEndDate + 1, UPDATEdBy = @currentUser WHERE taskStaffId = @check2TaskStaffID AND ndeID=@nodeID
		END

	IF @check3TaskStaffID > 0
		BEGIN
			UPDATE tbl_TaskStaff
			SET EndDate = @newStartDate - 1, UPDATEdBy = @currentUser WHERE taskStaffId = @check3TaskStaffID AND ndeID=@nodeID
		END

	IF @check4TaskStaffID > 0
		BEGIN
			SET @clashTaskID = (SELECT taskID FROM tbl_taskStaff WHERE taskStaffID = @check4TaskStaffID AND ndeID=@nodeID)
	 
			SET @clashStartDate = (SELECT startDate FROM tbl_taskStaff WHERE taskStaffID = @check4TaskStaffID AND ndeID=@nodeID)

			SET @clashEndDate = (SELECT EndDate FROM tbl_taskStaff WHERE taskStaffID = @check4TaskStaffID AND ndeID=@nodeID)
			
			SET @clashNotes = (SELECT taskNote FROM tbl_taskStaff WHERE taskStaffID = @check4TaskStaffID AND ndeID=@nodeID)

			INSERT tbl_TaskStaff (taskId, staffId, startDate, EndDate, taskNote, cancellable, active, UPDATEdBy, ndeID)
			VALUES (@clashTaskID, @staffID, @newEndDate + 1, @clashEndDate, @clashNotes, 0, 1, @currentUser, @nodeID)

			UPDATE tbl_TaskStaff
			SET EndDate = @newStartDate - 1, UPDATEdBy = @currentUser WHERE taskStaffID = @check4TaskStaffID AND ndeID=@nodeID
		END

	IF @check5TaskStaffID > 0
		BEGIN
			UPDATE tbl_TaskStaff
			SET startDate = @newEndDate + 1, UPDATEdBy = @currentUser WHERE taskStaffID = @check5TaskStaffID AND ndeID=@nodeID
		END

	IF @check6TaskStaffID > 0
	  BEGIN
		UPDATE tbl_TaskStaff
		SET EndDate = @newStartDate - 1, UPDATEdBy = @currentUser WHERE taskStaffID = @TaskStaffID AND ndeID=@nodeID
	  END
    
	/* Now add the taskstaff record we just created */
	INSERT tbl_TaskStaff (taskId, staffId, startDate, EndDate, taskNote, cancellable, active, UPDATEdBy, ndeID)
	VALUES (@taskId, @staffID, @Startdate, @EndDate, @notes, @cancellable, 1, @currentUser, @nodeID)
GO
/****** Object:  StoredProcedure [dbo].[spTaskPersonnelAdd]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spTaskPersonnelAdd]
(
    @nodeID INT,
	@taskID		INT,
	--@serviceNo		VARCHAR(50),
	@StaffID INT,
	@ooadays		INT,
	@currentUser		INT,
	@StartDate		VARCHAR(50),
	@ENDDate		VARCHAR(50),
	@notes			VARCHAR(2000),
	@id			INT,
	@Flag			INT
)

AS

SET DATEFORMAT dmy

DECLARE @clash		INT

--DECLARE @staffID		INT
DECLARE @newStartdate	DATETIME
DECLARE @newENDdate	DATETIME
DECLARE @taskStartDate	DATETIME
DECLARE @taskENDDate	DATETIME
DECLARE @cancellable		INT
DECLARE @currooadays	INT
DECLARE @TaskStaffID	INT
DECLARE @clashTaskID	INT
DECLARE @clashStartDate 	DATETIME
DECLARE @clashENDDate	DATETIME
DECLARE @TestWorked	VARCHAR(50)

SET @clash = 0 
SET @TestWorked = 'Test1Worked'

--SET @StaffID= (SELECT staffId FROM tblStaff WHERE serviceNo = @serviceNo)
SET @newStartdate = @Startdate/* (SELECT startDate FROM tbl_Task WHERE taskId= @taskID)*/
SET @newENDdate = @ENDdate/* (SELECT ENDdate FROM tbl_Task WHERE taskId= @taskID)*/

/*clashCheck1*/
IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active=1 AND staffId= @staffId AND @newStartDate <= startDate AND  @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate <= ENDDate AND taskStaffID <> @id)
	BEGIN
		SET @clash=1
		SET @staffID= (SELECT TOP 1 taskStaffId FROM tbl_taskStaff WHERE  (active=1 AND staffId= @staffId AND @newStartDate <= startDate AND @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate <= ENDDate))
	
		INSERT INTO tblTaskClash
		  SELECT @currentUser, @staffID, @nodeID

		
	END

/*clashCheck2*/
IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active=1 AND staffId= @staffId AND @newStartDate >= startDate AND  @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate >= ENDDate AND taskStaffID <> @id)
	BEGIN
		SET @clash=1	
		SET @staffID= (SELECT TOP 1  taskStaffId FROM tbl_taskStaff WHERE  active=1 AND staffId= @staffId AND @newStartDate >= startDate AND @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate >= ENDDate)

		INSERT INTO tblTaskClash
		  SELECT @currentUser, @staffID, @nodeID

	END

/*clashCheck3*/
IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active=1 AND staffId= @staffId AND @newStartDate >= startDate AND  @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate <= ENDDate AND taskStaffID <> @id)
	BEGIN
		SET @clash=1
		SET @staffID=(SELECT TOP 1  taskStaffId FROM tbl_taskStaff WHERE  active=1 AND staffId= @staffId AND @newStartDate >= startDate AND @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate <= ENDDate )
	
		INSERT INTO tblTaskClash
		  SELECT @currentUser, @staffID, @nodeID

	END

/*clashCheck4*/
IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active=1 AND staffId= @staffId AND @newStartDate <= startDate AND  @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate >= ENDDate AND taskStaffID <> @id)
	BEGIN
		SET @clash=1
		SET @staffID= (SELECT TOP 1  taskStaffId FROM tbl_taskStaff WHERE active=1 AND staffId= @staffId AND @newStartDate <= startDate AND @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate >= ENDDate)
	
		INSERT INTO tblTaskClash
		  SELECT @currentUser, @staffID, @nodeID

	END

IF @clash=0
	BEGIN
		SET @taskStartdate =(SELECT startdate FROM tbl_task WHERE taskId=@taskID)
		SET @taskENDDate =(SELECT ENDdate FROM tbl_task WHERE taskId=@taskID)
		SET @cancellable =(SELECT cancellable FROM tbl_task WHERE taskId=@taskID)
		
		INSERT  tbl_TaskStaff (taskId,staffId,startDate,ENDDate,taskNote,cancellable,active,updatedBy,ndeID)
		VALUES (@taskId,@staffID,@Startdate,@ENDDate,@notes,@cancellable,1,@currentUser, @nodeID)
	
	        DECLARE cs1 CURSOR FOR SELECT staffID FROM tblStaffHarmony WHERE tblStaffHarmony.staffID = @staffID
	
	        OPEN cs1
	        FETCH NEXT FROM cs1
	
	        IF @@FETCH_STATUS = 0
			  BEGIN
				UPDATE tblStaffHarmony SET
				tblStaffHarmony.ooadays=@ooadays
				WHERE tblStaffHarmony.staffID = @staffid AND ndeID=@nodeID
			  END
		    ELSE
			  BEGIN
				INSERT tblStaffHarmony (staffID, ooadays, ndeID)
				VALUES (@staffID, @ooadays, @nodeID)
			  END  
	
	        CLOSE cs1
	        DEALLOCATE cs1

		IF @Flag = 1
			BEGIN
				DELETE tbl_taskStaff WHERE taskStaffID = @id AND ndeID=@nodeID
			END
			
	END
GO
/****** Object:  StoredProcedure [dbo].[spTaskInsert]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTaskInsert]
@ttID int,
@Description varchar (50)


as

insert tbl_TaskCategory (Description, ttID)
values (@Description, @ttID)
GO
/****** Object:  StoredProcedure [dbo].[spTeamDel]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[spTeamDel]
@recID int,
@DelOK int OUTPUT
as

-- Check to see if team is assigned to another team
IF EXISTS (SELECT TOP 1 teamID from tblTeam WHERE (tblTeam.parentID = @recID AND tblTeam.teamIn= '4')) 
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'

-- has it got a post assigned to it
IF EXISTS (SELECT TOP 1 teamID FROM tblPost WHERE tblPost.teamID = @recID)    
	SET @DelOk = '1' 
ELSE
	SET @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spTeamCurrStage]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- This will iterate through the Stages attached to the current Team and
-- work out the Current stage then return its RecID to the Team page for didplay

CREATE   PROCEDURE [dbo].[spTeamCurrStage]
@RecID INT,
@currStage INT OUTPUT,
@Cycle     VARCHAR(20) OUTPUT,
@Stage     VARCHAR(20) OUTPUT,
@End       VARCHAR(20) OUTPUT



AS

DECLARE @tcyID     INT
DECLARE @cyDays    INT

DECLARE @today     INT
DECLARE @cyDate    INT
DECLARE @chkDate   INT
DECLARE @cyFirst   INT
DECLARE @step      INT

DECLARE @Date      datetime


--SET @today = (SELECT CONVERT (char(10), getdate(), 103))
SET @today = (SELECT CONVERT (INT, getdate(), 112))

-- first the cycleID from the Team table
SELECT @tcyID = (SELECT tblTeam.cycleID FROM tblTeam WHERE tblTeam.teamID = @RecID)
SELECT @cyFirst = (SELECT tblTeam.firstStage FROM tblTeam WHERE tblTeam.teamID = @RecID)

-- now get the date the cycle started - so we can work out from this what the current cycle is
--SELECT @cyDate = (SELECT CONVERT (CHAR(10), tblTeam.cycleStart, 103)FROM tblTeam WHERE tblTeam.teamID = '5')
SELECT @cyDate = (SELECT CONVERT (INT, tblTeam.cycleStart, 112)FROM tblTeam WHERE tblTeam.teamID = @RecID)

-- now get the number of days each stage of the cycle is operative for
SELECT @cyDays = (SELECT tblCycle.cyDays FROM tblCycle WHERE tblCycle.cyID = @tcyID)

-- now go through the stage steps till we find the current one for 
-- cycle allocated to the Team
DECLARE stage CURSOR SCROLL FOR
  SELECT 
       tblCycle.description, 
       tblCycleStage.description, 
       tblCycleSteps.cysID  
   FROM tblCycleSteps 
    INNER JOIN tblCycle ON
       tblCycle.cyID = tblCycleSteps.cyID
     INNER JOIN tblCycleStage ON
        tblCycleStage.cysID = tblCycleSteps.cysID
     WHERE tblCycleSteps.cyID = @tcyID
       ORDER by tblCycleSteps.cytStep
OPEN stage

-- now read through the steps until we hit the one for the current date
-- this means we will have to iterate round them adding the Cycle Days to the date 
-- until we hit a date > today
SELECT @chkDate = @cyDate + @cyDays,  @currstage = '0' 
SET @Date  = (SELECT CONVERT (datetime, @chkDate, 112))
SET @end = (SELECT CONVERT (VARCHAR(20), @date, 103))

FETCH FIRST FROM stage INTO @Cycle, @Stage, @currStage

-- Make sure we start at the current tblcyclesteps records
IF @@FETCH_STATUS = 0
 BEGIN
    WHILE (@@FETCH_STATUS = 0 AND @currStage <> @cyFirst)
       BEGIN
          FETCH NEXT FROM stage INTO @Cycle, @Stage, @currStage
       END
 END

-- Make sure we have actually got tblcyclesteps records
IF @@FETCH_STATUS = 0
 BEGIN
  WHILE @chkdate < @today
    BEGIN
      -- SELECT @chkdate, @today, @currstage

      IF @@FETCH_STATUS <> 0
       BEGIN
        FETCH FIRST FROM stage INTO @Cycle, @Stage, @currStage
       END 
      ELSE
       BEGIN
        FETCH NEXT FROM stage INTO @Cycle, @Stage, @currStage
       END  

     -- now add the cycle days on BUT only if we got a record
     IF @@FETCH_STATUS = 0
      BEGIN
        SELECT @chkDate = @chkDate + @cyDays 
        SET @Date  = (SELECT CONVERT (datetime, @chkDate, 112))
        SET @end = (SELECT CONVERT (VARCHAR(20), @date, 103))
      END
   
   END -- Loop through records to get current stage 

 END   -- If first FETCH was successful  
-- now lets see what we got
--SELECT @chkdate, @today, @currstage

CLOSE stage
DEALLOCATE stage

-- now get the Cycle and Stage description and Stage End Date

/**
SELECT @end AS endDate,
       @currstage AS stageID, 
       tblCycle.description AS curCycle, 
       tblCycleStage.description AS curStage
   FROM tblCycleSteps
     
     WHERE tblCycleSteps.cyID = @tcyID AND tblCycleSteps.cysID = @currstage
**/
GO
/****** Object:  StoredProcedure [dbo].[spTaskUpdate]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[spTaskUpdate]
@RecID int,
@ttID int,
@Description varchar (50)

as

update tbl_TaskCategory
  set ttID = @ttID, Description = @Description
  where taskCategoryID=@RecID
GO
/****** Object:  StoredProcedure [dbo].[spTaskUnitsRemove]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTaskUnitsRemove]
(
	@taskUnitID INT
)

AS

BEGIN TRANSACTION
	BEGIN
  		DELETE tbl_taskUnit WHERE taskUnitID = @taskUnitID
	END

IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END

COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [dbo].[spTaskUnitAdd]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTaskUnitAdd]
(
	@taskID	INT,
	@teamID	INT,
	@StartDate	DATETIME,
	@EndDate	DATETIME,
	@Notes		VARCHAR(2000),
	@CurrentUser	INT
)

AS

SET DATEFORMAT dmy

SET NOCOUNT ON

DECLARE @Cancellable		INT

SET @Cancellable = (SELECT cancellable FROM tbl_Task WHERE taskID = @taskID)

BEGIN TRANSACTION
	BEGIN
		INSERT INTO tbl_TaskUnit
		(
			taskID,
			teamID,
			startDate,
			endDate,
			taskNote,
			cancellable,
			active,
			updatedBy
		)
		VALUES
		(
			@taskID,
			@teamID,
			@StartDate,
			@EndDate,
			@Notes,
			@Cancellable,
			1,
			@CurrentUser
		)
	END

IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END

COMMIT TRANSACTION

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spTaskTypeUpdate]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTaskTypeUpdate]
@ttID int,
@Description varchar (50),
@color varchar (20)



as

UPDATE tblTaskType 
 SET Description=@Description, taskcolor=@color
   where ttID=@ttID
GO
/****** Object:  StoredProcedure [dbo].[spTaskTypeInsert]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTaskTypeInsert]
  @nodeID INT,
  @Description varchar (50),
  @color varchar (20)

AS

INSERT tblTaskType (ndeID, Description, taskcolor)
            VALUES (@nodeID, @Description, @color)
GO
/****** Object:  StoredProcedure [dbo].[spTeamPostAdd]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[spTeamPostAdd]
@TeamID INT,
@PostID INT
AS
declare @WeightValue int

set @WeightValue = (select RankWt from tblPost inner join tblRankWeight on tblRankWeight.RWID =tblPost.RWID where tblPost.postID=@PostID)
if @WeightValue is null
	Begin
		set @WeightValue=0
	End
update tblTeam set TeamSize=TeamSize-1 where teamID = (select TeamID from tblPost where postID=@postID)

update tblTeam set weight = weight - @WeightValue where teamID = (select TeamID from tblPost where postID=@postID)

update tblPost set TeamID =@TeamID where postID = @postID

update tblTeam set weight = weight + @WeightValue where teamID = @TeamID

update tblTeam set TeamSize=TeamSize+1 where teamID = @TeamID
GO
/****** Object:  StoredProcedure [dbo].[spTeamInsert]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spTeamInsert]
(
	@Description	VARCHAR(100),
	@TeamIn	INT,
	@ParentID	INT,
	@TeamSize	INT,
	@TeamCP	INT,
	@Weight	INT,
	@blnExists	BIT OUTPUT
)

AS

SET NOCOUNT ON

IF EXISTS (SELECT Description FROM tblTeam WHERE Description = @Description)
	BEGIN
		SET @blnExists = 1
	END
ELSE
	BEGIN
		DECLARE @teamID		INT
		DECLARE @ParentGroup	INT
		DECLARE @ParentWing	INT
		DECLARE @ParentSqn		INT
		DECLARE @ParentTeam	INT
		
		INSERT tblTeam (Description , TeamIn , ParentID , TeamSize , TeamCP, Weight )
		VALUES (@Description,  @TeamIn,  @ParentID,  @TeamSize,  @TeamCP, @Weight)
		
		SET @teamID = @@identity
		
		IF @teamIn= 1
			BEGIN
				SET @ParentGroup = (SELECT grpID FROM tblWing WHERE wingID = @ParentID)
				SET @parentTeam = (SELECT TeamID FROM tblTeam WHERE teamIn=0 AND parentID = @ParentGroup)
			END
		
		IF @teamIn= 2
			BEGIN
				SET @ParentWing = (SELECT wingID FROM tblSquadron WHERE sqnID = @ParentID)
				SET @parentTeam = (SELECT TeamID FROM tblTeam WHERE teamIn=1 AND parentID = @ParentWing)
			END
		
		IF @teamIn= 3
			BEGIN
				SET @ParentSqn = (SELECT sqnID FROM tblFlight WHERE fltID = @ParentID)
				SET @parentTeam = (SELECT TeamID FROM tblTeam WHERE teamIn=2 AND parentID = @ParentSqn)
			END
		
		IF @teamIn= 4 OR @teamIn=5
			BEGIN
				SET @ParentTeam = (SELECT teamID FROM tblTeam WHERE TeamID = @ParentID)
			END
		
		IF @parentTeam IS NULL
			BEGIN
				SET @parentTeam = 999
			END	
		
		INSERT tblTeamHierarchy SELECT @TeamID,@parentTeam,@TeamIn

		SET @blnExists = 0
	END

IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spTeamPosts]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- get all the posts for the teams in the current squadron (sqnID = @levelID  level = 2)
CREATE PROCEDURE [dbo].[spTeamPosts]
@posts    VARCHAR(8000) OUTPUT,
@parentID VARCHAR(50),
@level    VARCHAR(2)

AS

DECLARE @ID int
DECLARE @teamID INT
DECLARE @list VARCHAR (1000)

DECLARE team CURSOR SCROLL FOR
  SELECT tblpost.postID from tblteam 
    INNER JOIN tblpost ON
               tblpost.teamid = tblteam.teamid   
               WHERE  tblTeam.teamID = @parentID
                       AND
                       tblTeam.teamin = @level

OPEN team

-- now get the all the postid's
FETCH FIRST FROM team INTO @ID

WHILE @@FETCH_STATUS = 0
  BEGIN
     IF @posts IS NULL
          SET @posts = '''' + cast(@ID as char(3)) + ''''
     ELSE
     BEGIN
          SET @posts = @posts + ',' + '''' + cast(@ID as char(3)) + ''''
     END

     -- now get the next post
     FETCH NEXT FROM team INTO @ID

  END

CLOSE team
DEALLOCATE team

-- now we have all the flight posts so get the team posts ( level 4)
DECLARE team CURSOR SCROLL FOR
  SELECT tblTeam.TeamID from tblteam 
       WHERE  tblTeam.parentid = @parentID
              AND
              tblTeam.teamin = @level

OPEN team

FETCH FIRST FROM team INTO @ID
-- now go through all the sub-Teams for this Team  
-- this will give us all the posts for each Team at the next (lowest) level ( 5)
SET @level = @level + 1
WHILE @@FETCH_STATUS = 0
  BEGIN
    -- EXEC spTeamPosts @list OUTPUT, @parentID = @ID, @level = @level
    SET @list = NULL
    DECLARE subtm CURSOR SCROLL FOR
       SELECT tblpost.postID from tblteam 
         INNER JOIN tblpost ON
               tblpost.teamid = tblteam.teamid   
         WHERE  tblTeam.parentid = @ID
                AND
                tblTeam.teamin = @level

    OPEN subtm

    -- now get the first sub-team
    FETCH FIRST FROM subtm INTO @teamID
    WHILE @@FETCH_STATUS = 0
    BEGIN

       -- now add the posts for this sub-team to list
       IF @list IS NULL
          SET @list = '''' + cast(@teamID as char(3)) + ''''
       ELSE
        BEGIN
          SET @list = @list + ',' + '''' + cast(@teamID as char(3)) + ''''
        END

       -- now get the first sub-team
       FETCH NEXT FROM subtm INTO @teamID

    END
 
    CLOSE subtm
    DEALLOCATE subtm

    -- now add the posts for this flight to list
    IF @list IS NOT NULL
     BEGIN
       IF @posts IS NULL
          SET @posts = @list
       ELSE
        BEGIN
          SET @posts = @posts + ',' + @list
        END
     END

   -- now get the next flight for this squadron
   FETCH NEXT FROM team INTO @ID

  END

CLOSE team
DEALLOCATE team
GO
/****** Object:  StoredProcedure [dbo].[spTeamPostRemove]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE     PROCEDURE [dbo].[spTeamPostRemove]
@TeamID INT,
@PostID INT
AS
declare @WeightValue int

set @WeightValue = (select RankWt from tblPost inner join tblRankWeight on tblRankWeight.RWID =tblPost.RWID where tblPost.postID=@PostID)
if @WeightValue is null
	Begin
		set @WeightValue=0
	End

update tblPost set TeamID = null where postID = @postID

update tblTeam set weight = weight - @WeightValue where teamID = @TeamID

update tblTeam set TeamSize=TeamSize-1 where teamID = @TeamID

delete tblManager where postID = @postID
GO
/****** Object:  StoredProcedure [dbo].[spUpdateRemedial]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateRemedial]
(
	@staffID	INT,
	@remedial	INT,
	@exempt	INT,
	@expiryDate	DATETIME
)

AS

UPDATE tblstaff 
  SET remedial = @remedial,
      exempt = @exempt,
      expiryDate = @expiryDate
      WHERE staffID = @staffID

IF @remedial = 1
	BEGIN
		DELETE tblStaffFitness WHERE staffID = @staffID
	END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateExempt]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spUpdateExempt]
(
	@staffID	INT,
	@exempt	INT,
	@remedial	INT,
	@expiryDate	DATETIME
)

AS

UPDATE tblstaff 
  SET exempt = @exempt,
      remedial = @remedial,
      expiryDate = @expiryDate
      WHERE staffID = @staffID

IF @exempt = 1
	BEGIN
		DELETE tblStaffFitness WHERE staffID = @staffID
	END
GO
/****** Object:  StoredProcedure [dbo].[spUnitTaskDetails]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spUnitTaskDetails] 
(
	@startDate	VARCHAR(30),
	@endDate	VARCHAR(30),
	@teamID	INT
)

AS

SET DATEFORMAT dmy

SELECT tbl_TaskUnit.taskunitID, tbl_Task.description, tbl_Task.taskTypeID AS type, tbl_Task.taskID AS task, tbl_TaskUnit.startDate, tbl_TaskUnit.endDate, tbl_TaskUnit.taskNote, tblTaskType.taskcolor
FROM tbl_TaskUnit
INNER JOIN tbl_Task ON tbl_Task.taskID = tbl_TaskUnit.taskID
INNER JOIN tblTaskType ON tblTaskType.ttID = tbl_Task.taskTypeID
WHERE

((tbl_TaskUnit.startDate >= @startDate AND tbl_TaskUnit.startDate <= @endDate)
OR
(tbl_TaskUnit.endDate >= @startDate AND tbl_TaskUnit.endDate <= @endDate)
OR 
((tbl_TaskUnit.startDate >= @startDate AND tbl_TaskUnit.startDate <= @endDate) AND tbl_TaskUnit.endDate > @endDate)
OR 
((tbl_TaskUnit.endDate >= @startDate AND tbl_TaskUnit.endDate <= @endDate) AND tbl_TaskUnit.startDate < @startDate)
OR
(tbl_TaskUnit.endDate > @endDate AND tbl_TaskUnit.startDate < @startDate))

AND tbl_TaskUnit.teamID = @teamID AND tbl_TaskUnit.active = 1
ORDER BY tbl_TaskUnit.startDate
GO
/****** Object:  StoredProcedure [dbo].[spUnitHPUpdate]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spUnitHPUpdate]
@RecID int,
@ooagrnmin DEC( 5,2),
@ooagrnmax DEC( 5,2),

@ooayelmin DEC( 5,2),
@ooayelmax DEC( 5,2),

@ooaambmin DEC( 5,2),
@ooaambmax DEC( 5,2),
@ooared DEC( 5,2),

@bnagrnmin DEC( 5,2),
@bnagrnmax DEC( 5,2),

@bnayelmin DEC( 5,2),
@bnayelmax DEC( 5,2),

@bnaambmin DEC( 5,2),
@bnaambmax DEC( 5,2),
@bnared DEC( 5,2)

AS

update tblUnitHarmonyTarget 
  SET ooagrnmin= @ooagrnmin, 
      ooagrnmax= @ooagrnmax,
      ooayelmin= @ooayelmin, 
      ooayelmax= @ooayelmax, 
      ooaambmin= @ooaambmin, 
      ooaambmax= @ooaambmax, 
      ooared= @ooared, 
      bnagrnmin= @bnagrnmin, 
      bnagrnmax= @bnagrnmax, 
      bnayelmin= @bnayelmin, 
      bnayelmax= @bnayelmax, 
      bnaambmin= @bnaambmin, 
      bnaambmax= @bnaambmax, 
      bnared= @bnared 

    where tblUnitHarmonyTarget.uhpid = @recid
GO
/****** Object:  StoredProcedure [dbo].[spUnitHPInsert]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[spUnitHPInsert]
@nodeID INT,
@ooagrnmin DEC( 5,2),
@ooagrnmax DEC( 5,2),

@ooayelmin DEC( 5,2),
@ooayelmax DEC( 5,2),

@ooaambmin DEC( 5,2),
@ooaambmax DEC( 5,2),
@ooared DEC( 5,2),

@bnagrnmin DEC( 5,2),
@bnagrnmax DEC( 5,2),

@bnayelmin DEC( 5,2),
@bnayelmax DEC( 5,2),

@bnaambmin DEC( 5,2),
@bnaambmax DEC( 5,2),
@bnared DEC( 5,2)

AS

INSERT tblUnitHarmonyTarget 
       (ndeID, ooagrnmin,ooagrnmax,ooayelmin,ooayelmax,ooaambmin,ooaambmax,ooared,
        bnagrnmin,bnagrnmax,bnayelmin,bnayelmax,bnaambmin,bnaambmax,bnared)
VALUES (@nodeID, @ooagrnmin,@ooagrnmax,@ooayelmin,@ooayelmax,@ooaambmin,@ooaambmax,@ooared,
        @bnagrnmin,@bnagrnmax,@bnayelmin,@bnayelmax,@bnaambmin,@bnaambmax,@bnared)
GO
/****** Object:  StoredProcedure [dbo].[spTradeUpdate]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spTradeUpdate]
@RecID int,
@tgID int,
@Description varchar (50)

as

update tblTrade
  set tradeGroupID = @tgID, Description = @Description
  where TradeID=@RecID
GO
/****** Object:  StoredProcedure [dbo].[spTradeInsert]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spTradeInsert]
@nodeID INT,
@tgID INT,
@Description VARCHAR (50)

AS

INSERT tblTrade (ndeID, Description, tradeGroupID)
         VALUES (@nodeID, @Description, @tgID)
GO
/****** Object:  StoredProcedure [dbo].[spTradeGroupUpdate]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[spTradeGroupUpdate]
@RecID int,
@tg int,
@Description varchar (50)

as

update tblTradeGroup
  set tradeGroup = @tg, Description = @Description
  where TradeGroupID=@RecID
GO
/****** Object:  StoredProcedure [dbo].[spTradeGroupInsert]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[spTradeGroupInsert]
@nodeID INT,
@TradeGroup varchar (50),
@Description varchar (50)

AS

 INSERT  tblTradeGroup (ndeID, TradeGroup, Description)
 VALUES (@nodeID, @TradeGroup, @Description)
GO
/****** Object:  StoredProcedure [dbo].[spTradeGroupDetail]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE        PROCEDURE [dbo].[spTradeGroupDetail]
@RecID int
as

select tblTradeGroup.tradegroupID, tblTradeGroup.description, tblTradeGroup.tradegroup 
   from tblTradeGroup
     WHERE tblTradeGroup.tradegroupID = @RecID
GO
/****** Object:  StoredProcedure [dbo].[spTradeGroupDel]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[spTradeGroupDel]
@recID int,
@DelOK int OUTPUT
as

-- has it got staff assigned to it
IF EXISTS (SELECT TOP 1 tradeID from tblTrade WHERE tblTrade.tradegroupID = @recID)    
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spTradeDetail]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE       PROCEDURE [dbo].[spTradeDetail]
@RecID int
as

select tblTrade.tradeID, tblTrade.description, tblTradeGroup.tradegroup 
   from tblTrade

    left outer join tblTradeGroup ON
     tblTradeGroup.tradegroupID = tblTrade.tradegroupID
       where TradeID=@RecID
GO
/****** Object:  StoredProcedure [dbo].[spTradeDel]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE    PROCEDURE [dbo].[spTradeDel]
@recID int,
@DelOK int OUTPUT
as

-- has it got staff assigned to it
IF EXISTS (SELECT TOP 1 staffID from tblStaff WHERE tblStaff.tradeID = @recID)    
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spValPInsert]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[spValPInsert]
@nodeID INT,
@vpLength INT,
@Description VARCHAR (50),
@vpType INT

AS

DECLARE @vpdays INT
DECLARE @vpnum INT

IF @vptype = '1'   -- Period is DAYS
  SET @vpnum = '1'
ELSE IF @vptype = '2'   -- Period is Weeks
  SET @vpnum = '7'
ELSE               -- Period is MONTHS
  SET @vpnum = '30'

SET @vpdays = (@vplength * @vpnum)

INSERT tblValPeriod (ndeID, vplength,Description,vptype, vpdays)
             VALUES (@nodeID, @vplength,@Description,@vptype, @vpdays)
GO
/****** Object:  StoredProcedure [dbo].[spValPeriodAdd]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spValPeriodAdd]
@value datetime,
@vpID int,
@returnValue datetime output
as
declare @vpLength int
declare @vpType int

set @vpLength= (select vpLength from tblValPeriod where vpId =@vpID)
set @vpType= (select vpType from tblValPeriod where vpId =@vpID)


if @vpType = 1

	begin
		set @returnValue = dateAdd (day,@vpLength,@value)
	
	end

if @vpType = 2

	begin

		set @returnValue = dateAdd (week,@vpLength,@value)	

	end

if @vpType = 3

	begin
		set @returnValue = dateAdd (month,@vpLength,@value)
	
	end

if @vpType = 4

	begin
		set @returnValue = dateAdd (year,@vpLength,@value)
	
	end
select @returnValue
GO
/****** Object:  StoredProcedure [dbo].[spValDel]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spValDel]
(
	@recID		INT,
	@DelOK	INT OUTPUT
)

AS

SET @DelOK=0
-- has a Q got a validity period assigned to it
IF EXISTS (SELECT TOP 1 vpID FROM tblQs WHERE tblQs.vpID = @recID)    
	SET @DelOk = '1' 
-- has a Military Skill got a validity period  assigned to it
ELSE IF EXISTS (SELECT TOP 1 vpID FROM tblMilitarySkills WHERE tblMilitarySkills.vpID = @recID)    
	SET @DelOk = '1' 
-- has a Fitness type got a validity period  assigned to it
ELSE IF EXISTS (SELECT TOP 1 vpID FROM tblFitness WHERE tblFitness.VPID = @recID)    
	SET @DelOk = '1' 
-- has a Vaccination got a validity period  assigned to it
ELSE IF EXISTS (SELECT TOP 1 vpID FROM tblMilitaryVacs WHERE tblMilitaryVacs.vpID = @recID)    
	SET @DelOk = '1' 
-- has Dental got a validity period  assigned to it
ELSE IF EXISTS (SELECT TOP 1 vpID FROM tblDental WHERE tblDental.VPID = @recID)    
	SET @DelOk = '1'
GO
/****** Object:  StoredProcedure [dbo].[spVacsAvailable]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spVacsAvailable]
@nodeID INT,
@StaffID int

AS
  SELECT mvID, [description]  FROM tblMilitaryVacs
		WHERE NOT EXISTS(SELECT mvID FROM tblStaffMVs WHERE tblMilitaryVacs.mvID = tblStaffMVs.mvID and staffID =@StaffID)
		-- WHERE tblMilitaryVacs.ndeID = @nodeID AND NOT EXISTS(SELECT mvID FROM tblStaffMVs WHERE tblMilitaryVacs.mvID = tblStaffMVs.mvID and staffID =@StaffID)

		ORDER BY tblMilitaryVacs.[description]
GO
/****** Object:  StoredProcedure [dbo].[spVacDel]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE    PROCEDURE [dbo].[spVacDel]
@recID int,
@DelOK int OUTPUT
as

-- has it got staff assigned to it
IF EXISTS (SELECT TOP 1 staffID from tblStaffMVs WHERE tblStaffMVs.MVID = @recID)    
  set @DelOk = '1' 
ELSE
  set @DelOk = '0'
GO
/****** Object:  StoredProcedure [dbo].[spVaccinationUpdate]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spVaccinationUpdate]
@MVID		int,
@Description	varchar (100),
@MVRequired	int,
@VPID		int,
@Combat		bit

AS

UPDATE tblMilitaryVacs SET
	Description = @Description,
	MVRequired = @MVRequired,
	vpID = @VPID,
	Combat = @Combat
	WHERE MVID = @MVID
GO
/****** Object:  StoredProcedure [dbo].[spVaccinationInsert]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spVaccinationInsert]
@nodeID INT,
@Description	varchar (100),
@MVRequired	int,
@VPID		int,
@Combat		bit

AS

  INSERT tblMilitaryVacs (ndeID, Description, MVRequired, vpID, Combat)
                  VALUES (@nodeID, @Description, @MVRequired, @VPID, @Combat)
GO
/****** Object:  StoredProcedure [dbo].[spVaccinationDetail]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spVaccinationDetail]
@RecID	int

AS

SELECT dbo.tblMilitaryVacs.mvID, dbo.tblMilitaryVacs.description, dbo.tblMilitaryVacs.mvrequired, 
       dbo.tblValPeriod.vpID,dbo.tblValPeriod.description AS ValidityPeriod, dbo.tblMilitaryVacs.Combat
     FROM dbo.tblMilitaryVacs 
        INNER JOIN dbo.tblValPeriod ON dbo.tblMilitaryVacs.vpID = dbo.tblValPeriod.vpID
        WHERE mvid=@RecID
GO
/****** Object:  StoredProcedure [dbo].[spUpdateTeamManagersAfterMove]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[spUpdateTeamManagersAfterMove]
as
--this procedure is executed everytime a team is moved or a post is moved so that it's manager credentials are kept uptodate.

--First update tmLevel field
update tblManager

set tmLevel = 

(select 

case

when teamIn > 3 then 5

else TeamIn

end 

from tblTeam inner join tblPost on tblPost.teamID = tblTeam.TeamID where tblPost.postID = tblManager.postID )

where (select PostID from tblTeam left outer join tblPost on tblPost.teamID = tblTeam.TeamID where tblPost.postID = tblManager.postID) is not null


--then update teamLevelId which should equal the post's team if tmLevel is > 3 otherwise it will equal the parentID of the team 
update tblManager

set tmLevelID =

case

when tblManager.tmLevel >3 

then (select tblTeam.TeamID from tblTeam inner join tblPost on tblPost.teamID = tblTeam.TeamID where tblPost.postID = tblManager.postID )


else (select parentID from tblTeam inner join tblPost on tblPost.teamID = tblTeam.TeamID where tblPost.postID = tblManager.postID )

end

where (select PostID from tblTeam left outer join tblPost on tblPost.teamID = tblTeam.TeamID where tblPost.postID = tblManager.postID) is not null
GO
/****** Object:  StoredProcedure [dbo].[spUpdateStaffVaccination]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateStaffVaccination]
(
	@validFrom	VARCHAR(20),
	@competent	VARCHAR(5),
	@staffMVID	INT
)

AS

SET DATEFORMAT dmy

DECLARE @vpID	INT
DECLARE @validTo	DATETIME

SET @vpID = (SELECT tblMilitaryVacs.vpID FROM dbo.tblStaffMVs
                    INNER JOIN tblMilitaryVacs ON tblStaffMVs.MVID = tblMilitaryVacs.mvID
                    WHERE StaffMVID = @StaffMVID)

EXEC  spValPeriodAdd @validFrom,@vpID,@returnValue = @validTo OUTPUT

UPDATE tblStaffMVs 
  SET validfrom = @validFrom,
      validTo = @validTo,
      competent = @competent
      WHERE StaffMVID = @StaffMVID
GO
/****** Object:  StoredProcedure [dbo].[spTeamUpdate]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spTeamUpdate]
(
	@TeamID		INT,
	@Description		VARCHAR(100),
	@TeamIn		INT,
	@ParentID		INT,
	@TeamSize		INT,
	@TeamCP		INT,
	@Weight		INT,
	@blnExists		BIT OUTPUT
)

AS

SET NOCOUNT ON

DECLARE @ParentGroup	INT
DECLARE @ParentWing	INT
DECLARE @ParentSqn		INT
DECLARE @ParentTeam	INT

UPDATE tblTeam SET
Description = @Description, TeamIn = @TeamIn, ParentID = @ParentID, TeamSize = @TeamSize, TeamCP = @TeamCP, Weight=@Weight
WHERE TeamID = @TeamID

IF @teamIn = 1
	BEGIN
		SET @ParentGroup = (SELECT grpID FROM tblWing WHERE wingID = @ParentID)
		SET @parentTeam = (SELECT TeamID FROM tblTeam WHERE teamIn = 0 AND parentID = @ParentGroup)
	END

IF @teamIn = 2
	BEGIN
		SET @ParentWing = (SELECT wingID FROM tblSquadron WHERE sqnID = @ParentID)
		SET @parentTeam = (SELECT TeamID FROM tblTeam WHERE teamIn = 1 AND parentID = @ParentWing)
	END

IF @teamIn = 3
	BEGIN
		SET @ParentSqn = (SELECT sqnID FROM tblFlight WHERE fltID = @ParentID)
		SET @parentTeam = (SELECT TeamID FROM tblTeam WHERE teamIn = 2 AND parentID = @ParentSqn)
	END

IF @teamIn = 4 OR @teamIn = 5
	BEGIN
		SET @ParentTeam = (SELECT teamID FROM tblTeam WHERE TeamID = @ParentID)
	END

IF @parentTeam IS NULL
	BEGIN
		SET @parentTeam = 999
	END	

UPDATE tblTeamHierarchy SET
parentId = @ParentTeam, teamIn = @TeamIn WHERE teamID = @TeamID

EXEC spUPDATETeamManagersAfterMove
EXEC spCreatePopulateTblTeamHierarchy

IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[spTeamDetail]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTeamDetail]
(
	@RecID	INT
)

AS

SELECT * FROM vwTeamListForDetail
WHERE TeamID = @RecID
GO
/****** Object:  StoredProcedure [dbo].[spTaskIndividualAdd]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spTaskIndividualAdd]
(
	@serviceNo	VARCHAR(50),
	@currentUser	INT,
	@StartDate	VARCHAR(50),
	@EndDate	VARCHAR(50),
	@task		VARCHAR(200),
	@ttID	INT,
	@TaskID	INT OUTPUT
)

AS

DECLARE @id	INT
DECLARE @flag	INT

SET @id = 0
SET @flag = 0


INSERT tbl_Task (ttID, description, startDate, endDate)
VALUES (@ttID,@task,@startDate,@endDate)

SET @taskID = @@Identity

EXEC spTaskPersonnelAdd @taskID, @serviceNo, @currentUser, @StartDate, @EndDate, @id, @flag
GO
/****** Object:  StoredProcedure [dbo].[spStaffTaskNotes]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spStaffTaskNotes]

@taskStaffID int

AS

SELECT DISTINCT tbl_TaskStaff.taskStaffID, tblStaff.staffID, tblStaff.firstname, tblStaff.surname, tblStaff.serviceno, tblRank.shortDesc, updatedBy AS Rank, tbl_Task.description, tbl_TaskStaff.endDate, tbl_TaskStaff.startDate, tbl_TaskStaff.taskNote, updatedBy, RTRIM(taskCreator.shortDesc) + ' ' + taskCreator.surname + ', ' + taskCreator.firstname + ' (' + taskCreator.serviceNo + ')' AS updatedByFullname, tbl_TaskStaff.dateStamp
FROM tbl_TaskStaff
INNER JOIN tblStaff ON tbl_TaskStaff.staffID = tblStaff.staffID
INNER JOIN tbl_Task ON tbl_TaskStaff.taskID = tbl_Task.taskID
INNER JOIN tblRank ON  tblRank.rankID = tblStaff.rankID
LEFT OUTER JOIN vwPersonnelSummaryList AS taskCreator ON taskCreator.staffID = tbl_TaskStaff.updatedBy
WHERE taskStaffID = @taskStaffID
GO
/****** Object:  View [dbo].[vwAllChildren]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  view [dbo].[vwAllChildren]

AS

SELECT teamId AS ParentID,child1 AS childID FROM vwTeamHierachyChild1
UNION
SELECT teamId AS ParentID,child2 AS childID FROM vwTeamHierachyChild2
UNION
SELECT teamId AS ParentID,child3 AS childID FROM vwTeamHierachyChild3
UNION
SELECT teamId AS ParentID,child4 AS childID FROM vwTeamHierachyChild4
GO
/****** Object:  View [dbo].[vwTeamList]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   view [dbo].[vwTeamList]  AS
SELECT     dbo.tblTeam.teamID, ParentID, dbo.tblTeam.description, dbo.tblTeam.teamSize, 
           dbo.tblTeam.weight,teamIn, 'Group' as teamInName, dbo.tblGroup.description AS ParentDescription, 
           TeamCP
            from tblteam INNER JOIN
                      dbo.tblGroup ON dbo.tblTeam.ParentID = dbo.tblGroup.grpID
WHERE     (dbo.tblTeam.teamIn = 0)

union


SELECT     dbo.tblTeam.teamID, ParentID, dbo.tblTeam.description, dbo.tblTeam.teamSize, dbo.tblTeam.weight,teamIn, 'Wing' as teamInName, dbo.tblWing.description AS ParentDescription, TeamCP
FROM         dbo.tblTeam INNER JOIN
                      dbo.tblWing ON dbo.tblTeam.ParentID = dbo.tblWing.wingID
WHERE     (dbo.tblTeam.teamIn = 1)

union

SELECT     dbo.tblTeam.teamID, ParentID, dbo.tblTeam.description, dbo.tblTeam.teamSize, dbo.tblTeam.weight,teamIn, 'Wing' as teamInName, dbo.tblWing.description AS ParentDescription, TeamCP
FROM         dbo.tblTeam INNER JOIN
                      dbo.tblWing ON dbo.tblTeam.ParentID = dbo.tblWing.wingID
WHERE     (dbo.tblTeam.teamIn = 1)

union

SELECT	TopView.teamID, ParentID,TopView.description, TopView.teamSize, TopView.weight,teamIn,'Sqn' as teamInName,
	
	(select tblWing.Description from tblWing inner join tblSquadron on tblSquadron.WingID = tblWing.WingID
	where tblSquadron.SqnID = TopView.ParentId)
	+ ' > ' + dbo.tblSquadron.description AS ParentDescription, TeamCP

	FROM dbo.tblTeam as TopView INNER JOIN
        dbo.tblSquadron ON TopView.ParentID = dbo.tblSquadron.sqnID
	WHERE     (TopView.teamIn = 2)

union


SELECT	TopView.teamID, ParentID,TopView.description, TopView.teamSize, TopView.weight,teamIn,'Flight' as teamInName,
	(select tblWing.Description from tblWing inner join tblSquadron on tblSquadron.WingID = tblWing.WingID
	where tblSquadron.SqnID = (select tblSquadron.SqnID from tblSquadron inner join tblFlight on tblFlight.SqnID = tblSquadron.SqnID
	where tblFlight.FltID = TopView.ParentId))
	+ ' > ' + (select tblSquadron.Description from tblSquadron inner join tblFlight on tblFlight.SqnID = tblSquadron.SqnID
	where tblFlight.FltID = TopView.ParentId)
	+ ' > ' + dbo.tblFlight.description AS ParentDescription,
	TeamCP

	FROM dbo.tblTeam as TopView INNER JOIN
        dbo.tblFlight ON TopView.ParentID = dbo.tblFlight.fltID
	WHERE (TopView.teamIn = 3)

union

SELECT	TopView.teamID, TopView.ParentID,TopView.description, TopView.teamSize, TopView.weight,TopView.teamIn,'Team' as teamInName,
	
	--Case TopView.TeamIn 
	--when 3 then
	--(select tblSquadron.Description from tblSquadron inner join tblFlight on tblFlight.FltID = tblSquadron.SqnID
	--where tblFlight.fltID = (select tblFlight.fltID from tblflight inner join tblTeam on tblTeam.ParentID = tblFlight.FltID
	--where tblTeam.TeamID = TopView.ParentId))
	--+ ' > ' +
	


	--(select tblFlight.Description from tblFlight inner join tblTeam on tblTeam.ParentID = tblFlight.FltID
	--where tblTeam.TeamID = TopView.ParentId)
	--+ ' > ' + dbo.tblTeam.description
	--when 3 then

	--(select tblFlight.Description from tblFlight inner join tblTeam on tblTeam.ParentID = tblFlight.FltID
	--where tblTeam.TeamID = TopView.ParentId)
	--+ ' > ' + dbo.tblTeam.description



	--else
	(select vwTeamList2.ParentDescription from vwTeamList2 where vwTeamList2.TeamID = TopView.ParentID) + ' > ' + dbo.tblTeam.description
	--End
	
	AS ParentDescription,
	TopView.TeamCP
	FROM dbo.tblTeam as TopView INNER JOIN dbo.tblTeam ON TopView.ParentID = dbo.tblTeam.TeamID
	WHERE (TopView.teamIn >= 4)
GO
/****** Object:  StoredProcedure [dbo].[spUpdateStaffMS]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateStaffMS]
(
	@validFrom	VARCHAR(20),
	@competent	VARCHAR(5),
	@exempt	INT,
	@staffMSID	INT
)

AS

SET DATEFORMAT dmy

DECLARE @vpID	INT
DECLARE @validTo	DATETIME

SET @vpID = (SELECT tblMilitarySkills.vpID FROM tblStaffMilSkill
               INNER JOIN tblMilitarySkills ON tblStaffMilSkill.msID = tblMilitarySkills.msID
               WHERE StaffmsID = @StaffMSID)

EXEC spValPeriodAdd @validFrom,@vpID,@returnValue = @validTo OUTPUT

UPDATE tblStaffMilSkill 
  SET validfrom = @validFrom,
      validTo = @validTo,
      competent = @competent,
      exempt = @exempt
      WHERE StaffMSID = @StaffMSID
GO
/****** Object:  StoredProcedure [dbo].[spUpdateStaffFitness]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateStaffFitness]
(
	@validFrom	VARCHAR(20),
	@competent	VARCHAR(5),
	@staffFitnessID INT
)

AS

SET DATEFORMAT dmy

DECLARE @vpID	INT
DECLARE @validTo	DATETIME

SET @vpID = (SELECT tblfitness.vpID
FROM tblStaffFitness
INNER JOIN tblFitness ON tblStaffFitness.fitnessID = tblfitness.FitnessID
WHERE StaffFitnessID = @StaffFitnessID)

EXEC  spValPeriodAdd @validFrom,@vpID,@returnValue = @validTo OUTPUT

UPDATE tblStaffFitness 
  SET validfrom = @validFrom,
      validTo = @validTo,
      competent = @competent
WHERE StaffFitnessID = @StaffFitnessID
GO
/****** Object:  StoredProcedure [dbo].[spUpdateStaffDental]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateStaffDental]
(
	@validFrom	VARCHAR(20),
	@competent	VARCHAR(5),
	@staffDentalID	INT
)

AS

SET DATEFORMAT dmy

DECLARE @vpID	INT
DECLARE @validTo	DATETIME

SET @vpID = (SELECT tblDental.vpID  FROM tblStaffDental
              INNER JOIN tblDental ON tblStaffDental.dentalID = tbldental.dentalID
              WHERE StaffDentalID = @StaffDentalID)

EXEC  spValPeriodAdd @validFrom,@vpID,@returnValue = @validTo OUTPUT

UPDATE tblStaffDental 
  SET validfrom = @validFrom,
      validTo = @validTo,
      competent = @competent
      WHERE StaffDentalID = @StaffDentalID
GO
/****** Object:  StoredProcedure [dbo].[spGetHierarchyStaff]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetHierarchyStaff]

 @recID INT,
 @allTeams INT,
 @thisDate VARCHAR(12)

AS 

DECLARE @startofMonth	VARCHAR(16)

SET DATEFORMAT dmy

SET @startofMonth = RIGHT(@thisDate,8)
SET @startofMonth = '01 ' + @startofMonth

EXEC spGetHierarchyTrail @recid

IF @allTeams = 1
	BEGIN
		WITH tblChild AS
		(
		  SELECT * FROM tblHierarchy WHERE hrcID=@recid
		  UNION ALL
		  SELECT tblHierarchy.* FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
		)
		SELECT  tblPost.postID, tblPost.QTotal, assignno, weight, tblStaff.staffID AS staffid, 
		        SUBSTRING(tblRank.shortdesc, 1, LEN(shortdesc)) + ' ' +  SUBSTRING(firstname, 1,1) + ' ' + surname AS personnel, tblPost.manager
		FROM tblChild
		   INNER JOIN tblPost ON tblPost.hrcID=tblChild.hrcID
		   LEFT OUTER JOIN tblStaffPost ON
		     tblStaffPost.PostID = tblPost.postID AND  ((@thisDate >= startDate AND @startofMonth <= enddate AND endDate >= GETDATE()) OR enddate IS NULL)
		   LEFT OUTER JOIN tblStaff ON
		     tblStaff.staffID = tblStaffPost.StaffID
		   LEFT OUTER JOIN tblRank ON
		     tblRank.rankID=tblStaff.rankID
		WHERE tblPost.Status = 1 AND Ghost=0 
		ORDER BY tblChild.hrclevel, tblChild.hrcID, weight DESC, surname	
	END
ELSE

	BEGIN
		SELECT  tblPost.postID, tblPost.QTotal, assignno, weight, tblStaff.staffID AS staffid, 
		        SUBSTRING(tblRank.shortdesc, 1, LEN(shortdesc)) + ' ' +  SUBSTRING(firstname, 1,1) + ' ' + surname AS personnel, tblPost.manager,
		        startDate,endDate,CONVERT(DATETIME, @startofMonth)
		FROM tblPost
		   LEFT OUTER JOIN tblStaffPost ON
		     tblStaffPost.PostID = tblPost.postID AND ((@thisDate >= startDate AND @startofMonth <= enddate AND endDate >= GETDATE()) OR enddate IS NULL)
		   LEFT OUTER JOIN tblStaff ON
		     tblStaff.staffID = tblStaffPost.StaffID
		   LEFT OUTER JOIN tblRank ON
		     tblRank.rankID=tblStaff.rankID
		WHERE (tblPost.hrcID = @recID ) AND tblPost.Status = 1 AND Ghost=0 
		ORDER BY weight DESC, surname
		
	END
GO
/****** Object:  StoredProcedure [dbo].[spFlightPosts]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- get all the posts for the teams in the current squadron (sqnID = @levelID  level = 2)
CREATE     PROCEDURE [dbo].[spFlightPosts]
@posts    VARCHAR(8000) OUTPUT,
@parentID VARCHAR(50),
@level    VARCHAR(2)

AS

DECLARE @ID int
DECLARE @list VARCHAR (8000)

DECLARE team CURSOR SCROLL FOR
  SELECT tblpost.postID from tblteam 
    INNER JOIN tblpost ON
               tblpost.teamid = tblteam.teamid   
               WHERE  tblTeam.parentid = @parentID
                       AND
                       tblTeam.teamin = @level

OPEN team

-- now get the all the postid's
FETCH FIRST FROM team INTO @ID

WHILE @@FETCH_STATUS = 0
  BEGIN
     IF @posts IS NULL
          SET @posts = '''' + cast(@ID as char(3)) + ''''
     ELSE
     BEGIN
          SET @posts = @posts + ',' + '''' + cast(@ID as char(3)) + ''''
     END

     -- now get the next post
     FETCH NEXT FROM team INTO @ID

  END

CLOSE team
DEALLOCATE team


-- now we have all the flight posts so get the team posts ( level 4)
-- here we are dealing direct with TEAMS and NOT via wing/sqn/flight so
-- the level we want is the level for the flight ie: 3
DECLARE fltteam CURSOR SCROLL FOR
  SELECT tblTeam.TeamID from tblteam 
       WHERE  tblTeam.parentid = @parentID
              AND
              tblTeam.teamin = @level

OPEN fltteam

-- now go through all the flights for this squadron and run spFlightPosts for each one
-- this will give us all the posts for each flight and drill down to Teams in the Flight

FETCH FIRST FROM fltteam INTO @ID

-- now we add 1 to make the level a TEAM level  ie 4
SET @level = @level + 1
WHILE @@FETCH_STATUS = 0
  BEGIN
    EXEC spFltTeamPosts @list OUTPUT, @parentID = @ID, @level = @level

    -- now add the posts for this flight to list
    IF @list IS NOT NULL
     BEGIN
       IF @posts IS NULL
          SET @posts = @list
       ELSE
        BEGIN
          SET @posts = @posts + ',' + @list
        END
     END

   -- now get the next flight for this squadron
   FETCH NEXT FROM fltteam INTO @ID

  END

CLOSE fltteam
DEALLOCATE fltteam
GO
/****** Object:  StoredProcedure [dbo].[sp_ListTasks]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ListTasks]

as

select * from vw_Tasks
GO
/****** Object:  StoredProcedure [dbo].[spGetUnitTradeHarmony]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetUnitTradeHarmony]
(
	@hrcID	INT,
	@rpun	INT, 
	@rpby	INT
)

AS

/*
   This builds a temp table of the chosen unit plus its immediate subordinates
   in Trade Order and each one is then passed to GetHarmonyStatus to determine
   its Harmony
*/

--DECLARE @fltID INT
--DECLARE @sqnID INT
--DECLARE @wingID INT
--DECLARE @groupID INT
--DECLARE @teamIN INT
DECLARE @tradeID   INT
DECLARE @unit   VARCHAR(25)
DECLARE @trade   VARCHAR(25)
DECLARE @tradewt   INT

DECLARE @unstr DEC (5, 2)
DECLARE @unest DEC (5, 2)
DECLARE @unstrpcnt DEC (5, 2)
DECLARE @unestpcnt DEC (5, 2)

-- total unit staff who have broken OOA and BNA harmony
DECLARE @unooatot INT               -- TOTAL OOA Days of ALL personnel in Unit/Rank Trade
DECLARE @unbnatot INT               -- TOTAL BNA Days of ALL personnel in Unit/Rank Trade 
DECLARE @unooaredtot DEC(5, 2)      -- TOTAL number of Personnel who are RED for OOA Days n Unit/Rank Trade
DECLARE @unbnaredtot DEC(5, 2)      -- TOTAL number of Personnel who are RED for BNAA Days n Unit/Rank Trade

-- Unit OOA and BNA Harmony Days broken as a %age
-- These are the figures compared against the Unit Harmony Limits
DECLARE @unooapcnt DEC (5, 2)
DECLARE @unbnapcnt DEC (5, 2)

-- Average OOA/BNA days per Unit/Rank/Trade
DECLARE @unooaavg DEC (5, 2)     -- AVERAGE OOA Days per Unit/Rank/Trade
DECLARE @unbnaavg DEC (5, 2)     -- AVERAGE BNA Days per Unit/Rank/Trade

DECLARE @unooaredavg DEC (5, 2)  -- AVERAGE OOA Personnel per Unit/Rank/Trade
DECLARE @unbnaredavg DEC (5, 2)  -- AVERAGE BNA Personnel per Unit/Rank/Trade

-- The Harmony Status itself - the Holy Grail
-- 0 = Green, 1 = Yellow, 2 = Amber, 3 = Red
DECLARE @unStatus INT

DECLARE @first INT

--SET @teamIN = (SELECT teamIN from tblTeam WHERE tblTeam.teamID = @tmID)
SET @unit = (SELECT hrcname from tblHierarchy WHERE tblHierarchy.hrcID = @hrcID)

-- so we know its the first time through the cursor loop below
SET @first=0

-- temp table to hold list of units
WITH tblChild AS
		(
		  SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
		  UNION ALL
		  SELECT tblHierarchy.hrcID, tblHierarchy.hrcName FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
		)
     SELECT hrcID, hrcname INTO #tmtemp FROM tblChild 
     
CREATE TABLE #tmtrade
(
	#tmID		INT,
	#staffID	INT,
	#tradeID	INT,
	#tradedescr	VARCHAR(50),
	#tmDesc		VARCHAR(50)
)

-- temp table to hold harmony details for each unit in #tempunit
-- this table is populated in spGetHarmonyStatus
CREATE TABLE #unit
(
	#datastr	VARCHAR(25),
	#tradeID	INT,
	#establishment	DEC(5, 2), 
	#strength	DEC(5, 2),
	#ooatot		INT, 
	#bnatot		INT,
	#ooaavg		DEC(5, 2),
	#bnaavg		DEC(5, 2),
	#ooaredtot	DEC(5, 2),
	#bnaredtot	DEC(5, 2),
	#ooapcnt	DEC(5, 2),
	#bnapcnt	DEC(5, 2),
	#status		INT 
)

-- first get all the trades for the team posts
INSERT INTO #tmtrade
	SELECT #tmtemp.hrcID, 0, tblTrade.tradeID,tblTrade.description, #tmtemp.hrcname  
	FROM tblPost
	INNER JOIN tblTrade ON tblTrade.tradeID=tblPost.tradeID
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID  
	--INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
	WHERE tblPost.Ghost = 0 AND tblPost.Status = 1 AND tblTrade.tradeID <> 40

-- now get the ranks of all the people in each team
INSERT INTO #tmtrade
	SELECT #tmtemp.hrcID, tblStaff.staffID, tblStaff.tradeID,tblTrade.description, #tmtemp.hrcname  
	FROM tblStaff
	INNER JOIN tblTrade ON tblTrade.tradeID=tblStaff.tradeID
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID
	--INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
	WHERE tblPost.Ghost = 0 AND tblPost.Status = 1 AND tblStaffPost.endDate IS NULL AND tblTrade.tradeID <> 40

-- now get the harmony status for this unit
EXEC spGetHarmonyStatus @hrcID=@hrcID, @repunit=@rpun, @repby=@rpby, 
@establishment = @unest OUTPUT,
@strength = @unstr OUTPUT,
@ooaredtot = @unooaredtot  OUTPUT,
@bnaredtot = @unbnaredtot OUTPUT,     
@ooapcnt = @unooapcnt OUTPUT,     
@bnapcnt =@unbnapcnt  OUTPUT,      
@status = @unStatus OUTPUT

-- now add to the temptable
INSERT INTO #unit
	SELECT @unit, 999, @unest,@unstr,0.00, 0.00, 0.00, 0.00, @unooaredtot,@unbnaredtot,@unooapcnt,@unbnapcnt,@unStatus

-- Now we can go through the units and get the Harmony Status of each one
DECLARE un1 SCROLL CURSOR FOR
	SELECT #tradeID from #tmtrade
	GROUP BY #tradeID
             
OPEN un1

FETCH NEXT FROM un1 INTO @tradeID

-- now get the harmony status of each rank within the unit
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @trade = (SELECT tblTrade.description FROM tblTrade
		WHERE tblTrade.tradeID=@tradeID)

		-- now get the harmony status of the team ONLY - not any subordinates
		EXEC spGetTradeHarmonyStatus @hrcID=@hrcID, @tradeID=@tradeID,  @repby=@rpby, 
		@establishment = @unest OUTPUT,
		@strength = @unstr OUTPUT,
		@ooatot = @unooatot  OUTPUT,
		@bnatot = @unbnatot OUTPUT, 
		@ooaavg = @unooaavg  OUTPUT,
		@bnaavg = @unbnaavg OUTPUT,        
		@ooaredtot = @unooaredtot  OUTPUT,
		@bnaredtot = @unbnaredtot OUTPUT,  
		@ooaredavg = @unooaredavg  OUTPUT,
		@bnaredavg = @unbnaredavg OUTPUT,    
		@ooapcnt = @unooapcnt OUTPUT,     
		@bnapcnt =@unbnapcnt  OUTPUT,      
		@status = @unStatus OUTPUT

		-- now add to the temptable
		INSERT INTO #unit
			SELECT @trade,@tradeID, @unest,@unstr,@unooatot,@unbnatot,@unooaavg,@unbnaavg,@unooaredtot,@unbnaredtot,@unooapcnt,@unbnapcnt,@unStatus
          
		FETCH NEXT FROM un1 INTO @tradeID
	END

CLOSE un1
DEALLOCATE un1

SELECT #datastr AS dispdata,
--#unitname AS unit,
--#rank AS rank,
#establishment AS established,
#strength AS strength,
#ooaredtot AS ooaredtot,	-- Number of Personel breaking OOA harmony for Rank
#ooatot AS ooatot,		-- Total number of OOA days for Rank    
#ooaavg AS ooaavg,		-- Avg Number of OOA days for Rank
#bnaredtot AS bnaredtot,	-- Number of Personel breaking BNA harmony for Rank
#bnatot AS bnatot,		-- Total number of BNA days for Rank
#bnaavg AS bnaavg,		-- Avg Number of BNA days for Rank
#ooapcnt AS ooapcnt,
#bnapcnt AS bnapcnt,
#status AS harmony 
FROM #unit
ORDER BY #tradeID DESC

/*
SELECT COUNT(*) AS 'TG18 Logistics Supplier' FROM #tmtrade WHERE #tradedescr LIKE '%TG18 Logistics Supplier%'
SELECT COUNT(*) AS 'INT AN' FROM #tmtrade WHERE #tradedescr LIKE '%INT AN%'
SELECT COUNT(*) AS 'TG 12' FROM #tmtrade WHERE #tradedescr LIKE '%TG 12%'
SELECT COUNT(*) AS 'TG4 ICT (I) Tech' FROM #tmtrade WHERE #tradedescr LIKE '%TG4 ICT (I) Tech%'
SELECT COUNT(*) AS 'TG5 Gen Tech M' FROM #tmtrade WHERE #tradedescr LIKE '%TG5 Gen Tech M%'
SELECT COUNT(*) AS 'TG4 ICT Tech' FROM #tmtrade WHERE #tradedescr LIKE '%TG4 ICT Tech%'
SELECT COUNT(*) AS 'TG4 ICT (S) Tech' FROM #tmtrade WHERE #tradedescr LIKE '%TG4 ICT (S) Tech%'
SELECT COUNT(*) AS 'TG4 ICT Manager' FROM #tmtrade WHERE #tradedescr LIKE '%TG4 ICT Manager%'
SELECT COUNT(*) AS 'Officer' FROM #tmtrade WHERE #tradedescr LIKE '%Officer%'
SELECT COUNT(*) AS 'Change to be deleted' FROM #tmtrade WHERE #tradedescr LIKE '%Change to be delted%'
SELECT COUNT(*) AS 'TG17 Personnel Support' FROM #tmtrade WHERE #tradedescr LIKE '%TG17 Personnel Support%'
SELECT COUNT(*) AS 'TG8 Police' FROM #tmtrade WHERE #tradedescr LIKE '%TG8 Police%'
SELECT COUNT(*) AS 'TG8 Gnr' FROM #tmtrade WHERE #tradedescr LIKE '%TG8 Gnr%'
SELECT COUNT(*) AS 'TG4 CIS AE' FROM #tmtrade WHERE #tradedescr LIKE '%TG4 CIS AE%'
SELECT COUNT(*) AS 'TG4 Gen Tech GSE' FROM #tmtrade WHERE #tradedescr LIKE '%TG4 Gen Tech GSE%'
SELECT COUNT(*) AS 'TG4 Gen Tech E' FROM #tmtrade WHERE #tradedescr LIKE '%TG4 Gen Tech E%'
*/

DROP TABLE #tmtrade
DROP TABLE #tmtemp
DROP TABLE #unit
GO
/****** Object:  StoredProcedure [dbo].[spGetUnitRankHarmony]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetUnitRankHarmony]
(
	@hrcID	INT,
	@rpun	INT, 
	@rpby	INT
)

AS

/*
   This builds a temp table of the chosen unit plus its immediate subordinates
   in Rank Order and each one is then passed to GetHarmonyStatus to determine
   its Harmony
*/

--DECLARE @fltID INT
--DECLARE @sqnID INT
--DECLARE @wingID INT
--DECLARE @groupID INT
--DECLARE @teamIN INT
DECLARE @rankID   INT
DECLARE @unit   VARCHAR(25)
DECLARE @rank   VARCHAR(25)
DECLARE @rankwt   INT

DECLARE @unstr DEC (5, 2)
DECLARE @unest DEC (5, 2)
DECLARE @unstrpcnt DEC (5, 2)
DECLARE @unestpcnt DEC (5, 2)

-- total unit staff who have broken OOA and BNA harmony
DECLARE @unooatot INT
DECLARE @unbnatot INT
DECLARE @unooaredtot DEC(5, 2)
DECLARE @unbnaredtot DEC(5, 2)

-- Unit OOA and BNA Harmony Days broken as a %age
-- These are the figures compared against the Unit Harmony Limits
DECLARE @unooapcnt DEC (5, 2)
DECLARE @unbnapcnt DEC (5, 2)

-- Average OOA/BNA days per Unit/Rank/Trade
DECLARE @unooaavg DEC (5, 2)
DECLARE @unbnaavg DEC (5, 2)

DECLARE @unooaredavg DEC (5, 2)
DECLARE @unbnaredavg DEC (5, 2)

-- The Harmony Status itself - the Holy Grail
-- 0 = Green, 1 = Yellow, 2 = Amber, 3 = Red
DECLARE @unStatus INT

DECLARE @first INT

--SET @teamIN = (SELECT teamIN from tblTeam WHERE tblTeam.teamID = @tmID)
SET @unit = (SELECT hrcname from tblHierarchy WHERE tblHierarchy.hrcID = @hrcID)

-- so we know its the first time through the cursor loop below
SET @first=0

-- temp table to hold list of units
; WITH tblChild AS
		(
		  SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
		  UNION ALL
		  SELECT tblHierarchy.hrcID, tblHierarchy.hrcName FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
		)
     SELECT hrcID, hrcname INTO #tmtemp FROM tblChild 
     

-- temp table to hold all ranks within Unit Hierarchy
CREATE TABLE #tmrank
(
	#tmID		INT,
	#staffID	INT,
	#rankID		INT,
	#rankwt		INT,
	#rankdescr	VARCHAR(50),
	#tmDesc		VARCHAR(50)
)

-- temp table to hold harmony details for each unit in #tempunit
-- this table is populated in spGetHarmonyStatus
CREATE TABLE #unit
(
	#datastr	VARCHAR(25),
	#rankwt		INT,
	#establishment	DEC(5, 2), 
	#strength	DEC(5, 2),
	#ooatot		INT, 
	#bnatot		INT,
	#ooaavg		DEC(5, 2),
	#bnaavg		DEC(5, 2),
	#ooaredtot	DEC(5, 2),
	#bnaredtot	DEC(5, 2),
	#ooapcnt	DEC(5, 2),
	#bnapcnt	DEC(5, 2),
	#status		INT
)


-- first get the ranks of all the posts in each team
INSERT INTO #tmrank
	SELECT #tmtemp.hrcID, 0, tblPost.rankID,tblRank.weight, tblRank.description, #tmtemp.hrcname  
	FROM tblPost
	INNER JOIN tblRank ON tblRank.rankID=tblPost.rankID
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID 
	--INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
	WHERE tblPost.Ghost = 0 AND tblRank.weight <> 0

-- now get the ranks of all the people in each team
INSERT INTO #tmrank
	SELECT #tmtemp.hrcID, tblStaff.staffID, tblStaff.rankID,tblRank.weight, tblRank.description, #tmtemp.hrcname    
	FROM tblStaff
	INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
	INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
	INNER JOIN #tmtemp ON tblPost.hrcID = #tmtemp.hrcID 
	--INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
	WHERE tblPost.Ghost = 0 AND tblStaffPost.endDate IS NULL AND tblRank.weight <> 0

-- now get the harmony status for this unit
EXEC spGetHarmonyStatus @hrcID=@hrcID, @repunit=@rpun, @repby=@rpby, 
@establishment = @unest OUTPUT,
@strength = @unstr OUTPUT,
--@ooatot = @unooatot  OUTPUT,
--@bnatot = @unbnatot OUTPUT,     
@ooaredtot = @unooaredtot  OUTPUT,
@bnaredtot = @unbnaredtot OUTPUT,     
@ooapcnt = @unooapcnt OUTPUT,     
@bnapcnt =@unbnapcnt  OUTPUT,      
@status = @unStatus OUTPUT

INSERT INTO #unit
	SELECT @unit,999, @unest,@unstr,0.00, 0.00, 0.00, 0.00, @unooaredtot,@unbnaredtot, -- 0.00, 0.00, 
	@unooapcnt,@unbnapcnt,@unStatus

-- Now we can go through the units and get the Harmony Status of each one
DECLARE un1 SCROLL CURSOR FOR
	SELECT #rankID, #rankwt from #tmrank
	GROUP BY #rankID, #rankwt
             
OPEN un1

FETCH NEXT FROM un1 INTO @rankID, @rankwt

-- now get the harmony status of each rank within the unit
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @rank = (SELECT tblRank.description FROM tblRank
		WHERE tblRank.rankID=@rankID)
		SET @rankwt = (SELECT tblRank.weight FROM tblRank
		WHERE tblRank.rankID=@rankID)

		-- now get the harmony status of the team ONLY - not any subordinates
		EXEC spGetRankHarmonyStatus @hrcID=@hrcID, @rankID=@rankID,  @repby=@rpby, 
		@establishment = @unest OUTPUT,
		@strength = @unstr OUTPUT,
		@ooatot = @unooatot  OUTPUT,
		@bnatot = @unbnatot OUTPUT, 
		@ooaavg = @unooaavg  OUTPUT,
		@bnaavg = @unbnaavg OUTPUT,        
		@ooaredtot = @unooaredtot  OUTPUT,
		@bnaredtot = @unbnaredtot OUTPUT,  
		@ooaredavg = @unooaredavg  OUTPUT,
		@bnaredavg = @unbnaredavg OUTPUT,    
		@ooapcnt = @unooapcnt OUTPUT,     
		@bnapcnt =@unbnapcnt  OUTPUT,      
		@status = @unStatus OUTPUT

		-- now add to the temptable
		INSERT INTO #unit
			SELECT @rank,@rankwt, @unest,@unstr,@unooatot,@unbnatot,@unooaavg,@unbnaavg,@unooaredtot,@unbnaredtot,
			--@unooaredavg, @unbnaredavg,
			@unooapcnt,@unbnapcnt,@unStatus

		FETCH NEXT FROM un1 INTO @rankID, @rankwt
	END

CLOSE un1
DEALLOCATE un1

SELECT #datastr AS dispdata,
--#unitname      AS unit,
--#rank          AS rank,
#establishment AS established,
#strength      AS strength,
#ooaredtot     AS ooaredtot,
#ooatot        AS ooatot,
#ooaavg        AS ooaavg,
#bnaredtot     AS bnaredtot,
#bnatot        as bnatot ,      
#bnaavg        AS bnaavg,
#ooapcnt       AS ooapcnt,
#bnapcnt       AS bnapcnt,
#status        AS harmony 
FROM #unit
ORDER BY #rankwt DESC

DROP TABLE #tmrank
DROP TABLE #tmtemp
DROP TABLE #unit
GO
/****** Object:  StoredProcedure [dbo].[spGetUnitHarmony]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spGetUnitHarmony]
(
	@hrcID	INT,
	@rpun	INT, 
	@rpby   INT
)

AS

/*
   This builds a temp table of the chosen unit plus its immediate subordinates
   and each one is then passed to GetHarmonyStatus to determine its Harmony
*/
--DECLARE @fltID INT
--DECLARE @sqnID INT
--DECLARE @wingID INT
--DECLARE @groupID INT
DECLARE @childID INT
DECLARE @unit   VARCHAR(25)

DECLARE @unstr DEC (5, 2)
DECLARE @unest DEC (5, 2)
DECLARE @unstrpcnt DEC (5, 2)
DECLARE @unestpcnt DEC (5, 2)

-- total unit staff who have broken OOA and BNA harmony
DECLARE @unooatot INT
DECLARE @unbnatot INT

-- Unit OOA and BNA Harmony Days broken as a %age
-- These are the figures compared against the Unit Harmony Limits
DECLARE @unooapcnt DEC (5, 2)
DECLARE @unbnapcnt DEC (5, 2)

-- The Harmony Status itself - the Holy Grail
-- 0 = Green, 1 = Yellow, 2 = Amber, 3 = Red
DECLARE @unStatus INT

DECLARE @first INT

--SET @teamIN = (SELECT teamIN from tblTeam WHERE tblTeam.teamID = @tmID)

-- so we know its the first time through the cursor loop below
SET @first=0

; WITH tblChild AS
		(
		  SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
		  UNION ALL
		  SELECT tblHierarchy.hrcID, tblHierarchy.hrcName FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
		)
     SELECT hrcID, hrcname INTO #ttHRC FROM tblChild 

-- Now we can go through the units and get the Harmony Status of each one
DECLARE un1 SCROLL CURSOR FOR
	SELECT #ttHrc.hrcID, #ttHrc.hrcname
	FROM #ttHrc 
	ORDER BY #ttHrc.hrcID

OPEN un1

FETCH NEXT FROM un1 INTO @childID, @unit

CREATE TABLE #unit
(
	#datastr	VARCHAR(25),
	#rankwt		INT,
	#establishment	DEC(5, 2), 
	#strength	DEC(5, 2),
	#ooaredtot	DEC(5, 2), 
	#bnaredtot	DEC(5, 2),
	#ooapcnt	DEC(5, 2),
	#bnapcnt	DEC(5, 2),
	#status		INT 
  )

WHILE @@FETCH_STATUS = 0
	BEGIN
		-- now get the harmony status for thihs unit
		EXEC spGetHarmonyStatus @hrcID = @childID, @repunit = @rpun, @repby = @rpby, 
		@establishment = @unest OUTPUT,
		@strength = @unstr OUTPUT,
		@ooaredtot = @unooatot  OUTPUT,
		@bnaredtot = @unbnatot OUTPUT,     
		@ooapcnt = @unooapcnt OUTPUT,     
		@bnapcnt =@unbnapcnt  OUTPUT,      
		@status = @unStatus OUTPUT

		-- now add to the temptable
		INSERT INTO #unit
			SELECT @unit,0, @unest,@unstr,@unooatot,@unbnatot,@unooapcnt,@unbnapcnt,@unStatus

		-- if the first time in loop then we want to get the Harmony Status of the individual team
		-- we picked - but not any of its subordinates
		IF @first = 0
			BEGIN
				-- now get the harmony status of the team ONLY - not any subordinates
				EXEC spGetTeamHarmonyStatus @hrcID = @childID, @repunit = @rpun, @repby = @rpby, 
				@establishment = @unest OUTPUT,
				@strength = @unstr OUTPUT,
				@ooatot = @unooatot  OUTPUT,
				@bnatot = @unbnatot OUTPUT,     
				@ooapcnt = @unooapcnt OUTPUT,     
				@bnapcnt =@unbnapcnt  OUTPUT,      
				@status = @unStatus OUTPUT

				-- now add to the temptable
				INSERT INTO #unit
					SELECT @unit,0, @unest,@unstr,@unooatot,@unbnatot,@unooapcnt,@unbnapcnt,@unStatus
					SET @first=1
			END

		-- get the next unit on the list
		FETCH NEXT FROM un1 INTO @childID, @unit
	END

CLOSE un1
DEALLOCATE un1

SELECT #datastr AS dispdata,
#establishment AS established,
#strength AS strength,
#ooaredtot AS ooaredtot,
#bnaredtot AS bnaredtot,
#ooapcnt AS ooapcnt,
#bnapcnt AS bnapcnt,
#status AS harmony 
FROM #unit

DROP TABLE #unit

DROP TABLE #ttHRC
GO
/****** Object:  StoredProcedure [dbo].[spGetStaffQTotalOnly]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spGetStaffQTotalOnly]

@staffID INT,
@postID INT,
@thisDate varchar(30), 
@staffQTotal int  output
AS

--declare @PostID int
SET dateformat dmy

set @staffQTotal =(

select sum(total)as staffQTotal from (select  tempStaffQs.staffID,
--tempStaffQs.staffID,tempStaffQs.staffQID as QID,tempStaffQs.TypeID,Competent,tempStaffPostQs.postID,qwValue,tempStaffPostQs.startDate,tempStaffPostQs.endDate,tempStaffQs.ValidFrom,tempStaffQs.ValidEnd

case tempStaffQs.TypeID 

	when '2'then

		case when Competent <> 'N' then qwValue
			else  qwValue/2
		end
		
	else qwValue
end 

as total

from (select * from vwStaffQs where staffid=@staffId and ((validFrom <= @thisDate and validEnd >=@thisDate) or (validFrom <= @thisDate and validEnd is null))) as  tempStaffQs
inner  join 

(select postID,qwValue,startDate,EndDate,postQID from vwStaffpostQs where staffid=@staffId and postId = @postID and ((startDate <= @thisDate and endDate >=@thisDate) or (startDate <= @thisDate and endDate is null)))  as tempStaffPostQs
   on  tempStaffQs.staffQID = tempStaffPostQs.postQID) as newTable
group by staffID
)
GO
/****** Object:  StoredProcedure [dbo].[spGetStaffQTotal]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spGetStaffQTotal] 

@staffID INT,
@postID INT,
@thisDate varchar(30) 
AS

SET dateformat dmy

--declare @PostID int
DECLARE @qtot INT

SET @qtot=(select sum(total) from (select  tempStaffQs.staffID,

case tempStaffQs.TypeID 

	when '2'then

		case when Competent <> 'N' then qwValue
			else  qwValue/2
		end
		
	else qwValue
end 

as total

from (select * from vwStaffQs where staffid=@staffId and ((validFrom <= @thisDate and validEnd >=@thisDate) or (validFrom <= @thisDate and validEnd is null))) as  tempStaffQs
inner  join 

(select postID,qwValue,startDate,EndDate,postQID,typeID from vwStaffpostQs where staffid=@staffId and postId = @postID and ((startDate <= @thisDate and endDate >=@thisDate) or (startDate <= @thisDate and endDate is null)))  as tempStaffPostQs
   on  tempStaffQs.staffQID = tempStaffPostQs.postQID and tempStaffQs.typeID = tempStaffPostQs.typeID) as newTable
group by staffID)


IF @qtot IS NULL
  SET @qtot = 0
SELECT  @qtot as staffQTotal
GO
/****** Object:  StoredProcedure [dbo].[spGetStaffMSTotal]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spGetStaffMSTotal] 
@staffID INT,
@thisDate varchar(30) 
AS
declare @StaffMSTotal int
declare @PostMSTotal int

set @StaffMSTotal = (
select sum(total)as staffMSTotal from 
(select  tempStaffMS.staffID,qwValue as total
from (select * from vwStaffMS where staffid=@staffId and ((validFrom <= @thisDate and validEnd >=@thisDate) or (validFrom <= @thisDate and validEnd is null))) as  tempStaffMS

inner  join 

(select postID,qwValue,startDate,EndDate,postMSID from vwStaffpostMS where staffid=@staffId and ((startDate <= @thisDate and endDate >=@thisDate) or (startDate <= @thisDate and endDate is null)))  as tempStaffPostMS
   on  tempStaffMS.staffMSID = tempStaffPostMS.postMSID) as newTable
group by staffID)



set @PostMSTotal =(
select sum(total) as postMSTotal from
(select staffId,qwValue as total from vwStaffpostMS where 
staffid=@staffId and ((startDate <= @thisDate and endDate >=@thisDate) or (startDate <= @thisDate and endDate is null))) as tempPostMS
group by staffID)
--select @StaffMSTotal,@PostMSTotal
if @StaffMSTotal < @PostMSTotal
	begin
		select 0 as MSStatus
	end
else
	begin
		select 1 as MSStatus
	end
GO
/****** Object:  StoredProcedure [dbo].[spHarmonyCheck]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- This is run overnight everynight and will update each staff record with harmony days
-- for OOA and BNA for the periods specified in tblHarmonyPeriod

CREATE     PROCEDURE [dbo].[spHarmonyCheck]

AS

DECLARE @staffID INT
DECLARE @todate DATETIME
DECLARE @fromdate DATETIME
DECLARE @enddate DATETIME

DECLARE @type  INT
DECLARE @type1 INT
DECLARE @days  INT
DECLARE @ooa   INT
DECLARE @ssa   INT
DECLARE @ssb   INT

DECLARE @period    INT
DECLARE @ooamonths INT
DECLARE @ssamonths INT
DECLARE @ssbmonths INT

-- Get the Harmony periods 
SET @ooamonths = (SELECT TOP 1 ooaperiod FROM tblHarmonyPeriod)
SET @ssamonths = (SELECT TOP 1 ssaperiod FROM tblHarmonyPeriod)
SET @ssbmonths = (SELECT TOP 1 ssbperiod FROM tblHarmonyPeriod)


-- variables to calculate Harmony Status for each person
-- go back to start of each rolling Harmony period and calculate
-- Harmony Days for that Harmony Type ( OOA, SSCA or SSCB)
SET @todate=getdate()

-- Now we can go get the staff details AND the Harmony details
-- going back through time to the period start and calculate ooa days for each one
DECLARE tstaff CURSOR  FOR
  SELECT staffID FROM tblStaff
    
OPEN tstaff
FETCH NEXT FROM tstaff INTO @staffID

WHILE @@FETCH_STATUS = 0
 BEGIN

    SET @ooa=0    -- default to zero for each body
    SET @ssa=0
    SET @ssb=0
 
    -- first the get the start date of the OOA Period
    SET @type= 1
    SET @type1=1
    SET @period= @ooamonths      
    EXEC spGetFromDate @todate, @period, @fromdate = @fromdate OUTPUT

    -- Now run the stored procedure to calculate the OOA days 
    -- and last OOA Date for this person
    EXEC spGetHarmonyDays @staffID,@fromdate, @todate, @period,@type,@type1, @days = @days OUTPUT
    EXEC spGetLastOOADate @staffID, @enddate = @enddate OUTPUT
    SET @ooa = @days

    -- Now get the start date of the SSCA Period
    SET @type= 1
    SET @type1=2
    SET @period= @ssamonths      
    EXEC spGetFromDate @todate, @period, @fromdate = @fromdate OUTPUT

    -- Now run the stored procedure to calculate the SSC A days 
    EXEC spGetHarmonyDays @staffID,@fromdate, @todate, @period,@type,@type1, @days = @days OUTPUT
    SET @ssa = @days

    -- Now get the start date of the SSCB Period
    SET @type= 1
    SET @type1=2
    SET @period= @ssbmonths      
    EXEC spGetFromDate @todate, @period, @fromdate = @fromdate OUTPUT

    -- Now run the stored procedure to calculate the SSC A days 
    EXEC spGetHarmonyDays @staffID,@fromdate, @todate, @period,@type,@type1, @days = @days OUTPUT
    SET @ssb = @days

    -- Update staff table with ooa days/date
    -- BUT don't overwrite existing date with NULLS
    IF @enddate IS NOT NULL
      UPDATE tblStaff 
        SET ddOOA = @ooa,
            ddssa = @ssa,
            ddssb = @ssb,
            lastOOA= @enddate 
           WHERE tblStaff.staffID=@staffID
    ELSE
            UPDATE tblStaff 
        SET ddOOA = @ooa,
            ddssa = @ssa,
            ddssb = @ssb
           WHERE tblStaff.staffID=@staffID
   
    FETCH NEXT FROM tstaff INTO @staffID

 END     -- END of loop through staff temp table 

CLOSE tstaff
DEALLOCATE tstaff
GO
/****** Object:  StoredProcedure [dbo].[spInsertStaffVaccination]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spInsertStaffVaccination]
@staffID int,
@MVID int,
@validFrom varChar(20),
@competent varChar(5)

AS

SET dateformat DMY

DECLARE @nodeID INT
DECLARE @vpID INT
DECLARE @validTo DATETIME

SET @nodeID = (SELECT ndeID FROM tblStaff WHERE tblStaff.staffID=@staffID)
SET @vpID = (SELECT dbo.tblMilitaryVacs.vpID FROM dbo.tblMilitaryVacs WHERE MVID =@MVID)

EXEC  spValPeriodAdd @validFrom,@vpID,@returnValue = @validTo OUTPUT


INSERT INTO tblStaffMVs (StaffID,MVID,ValidFrom,validTo,Competent,ndeID) 
                 VALUES (@staffID , @MVID , @validFrom  , @validTo,@competent,@nodeID)
GO
/****** Object:  StoredProcedure [dbo].[spInsertStaffMilskill]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spInsertStaffMilskill]
@staffID	int,
@msID		int,
@validFrom	varChar(20),
@competent	varChar(5),
@exempt	int

AS

SET dateformat DMY

DECLARE @nodeID INT
DECLARE @vpID INT
DECLARE @validTo DATETIME

SET @nodeID = (SELECT ndeID FROM tblStaff WHERE tblStaff.staffID=@staffID)
SET @vpID = (SELECT dbo.tblMilitarySkills.vpID FROM dbo.tblMilitarySkills WHERE msID=@msID)

EXEC  spValPeriodAdd @validFrom,@vpID,@returnValue = @validTo OUTPUT


INSERT INTO tblStaffMilSkill (StaffID,MSID,ValidFrom,validTo,Competent, exempt, ndeID) 
                      VALUES (@staffID , @MSID , @validFrom  , @validTo,@competent, @exempt, @nodeID)
GO
/****** Object:  StoredProcedure [dbo].[spInsertStaffFitness]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spInsertStaffFitness]
@staffID int,
@fitnessID int,
@validFrom varChar(20),
@competent varChar(5)

AS

SET dateformat DMY

DECLARE @nodeID INT
DECLARE @vpID INT
DECLARE @validTo DATETIME

SET @nodeID = (SELECT ndeID FROM tblStaff WHERE tblStaff.staffID=@staffID)
SET @vpID = (SELECT dbo.tblFitness.vpID FROM dbo.tblFitness WHERE fitnessID =@fitnessID)

EXEC  spValPeriodAdd @validFrom,@vpID,@returnValue = @validTo OUTPUT

IF EXISTS(SELECT * FROM tblStaffFitness WHERE staffID = @staffID)
	BEGIN
		DELETE tblStaffFitness WHERE staffID = @staffID
	END

INSERT INTO tblStaffFitness (StaffID,fitnessID,ValidFrom,validTo,Competent,ndeID) 
VALUES (@staffID , @fitnessID , @validFrom  , @validTo,@competent,@nodeID)
GO
/****** Object:  StoredProcedure [dbo].[spInsertStaffDental]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spInsertStaffDental]
@staffID int,
@dentalID int,
@validFrom varChar(20),
@competent varChar(5)

AS

SET dateformat DMY

DECLARE @nodeID INT
DECLARE @vpID INT
DECLARE @validTo DATETIME

SET @nodeID = (SELECT ndeID FROM tblStaff WHERE tblStaff.staffID=@staffID)
SET @vpID = (SELECT dbo.tblDental.vpID FROM dbo.tblDental WHERE DentalID =@DentalID)

EXEC  spValPeriodAdd @validFrom,@vpID,@returnValue = @validTo OUTPUT


INSERT INTO tblStaffDental (StaffID,dentalID,ValidFrom,validTo,Competent,ndeID) 
VALUES (@staffID , @dentalID , @validFrom  , @validTo,@competent,@nodeID)
GO
/****** Object:  StoredProcedure [dbo].[sp_TaskUnitsSummary]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TaskUnitsSummary]
(
	@recID INT
)

AS

SET dateformat dmy

exec sp_TaskDetail @recID
exec sp_ListTaskUnitsWithDates @recID
GO
/****** Object:  StoredProcedure [dbo].[sp_TaskPersonnelSummary]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TaskPersonnelSummary]
(
@recID INT,
@startDate varchar(50),
@endDate varChar (50)
)

AS

SET dateformat dmy

exec sp_TaskDetail @recID
exec sp_ListTaskPersonnelWithDates @recID, @startDate,@endDate
GO
/****** Object:  StoredProcedure [dbo].[spPeRsDentalSummary]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPeRsDentalSummary] 
(
	@RecID INT,
	@thisDate varchar(20)
)

AS

SET DATEFORMAT dmy

EXEC spPeRsDetailSummary @RecID,@thisDate

SELECT tblStaff.staffID, tblStaffDental.StaffDentalID, tblDental.description, tblStaffDental.ValidFrom
       FROM tblStaff
           INNER JOIN tblStaffDental ON tblStaff.staffID = tblStaffDental.StaffID
           INNER JOIN tblDental ON tblStaffDental.DentalID = tblDental.DentalID
            WHERE tblStaff.staffID = @RecID
             ORDER BY tblDental.description
GO
/****** Object:  StoredProcedure [dbo].[spListTaskCategories]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        PROCEDURE [dbo].[spListTaskCategories] 

as

select * from vwTaskCategoryList
order by description
GO
/****** Object:  StoredProcedure [dbo].[spListParents]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListParents] 

as

select * from vwParentList
order by description
GO
/****** Object:  StoredProcedure [dbo].[spRealignValidityPeriods]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRealignValidityPeriods]
@VPIDpassed int
as

DECLARE @cursorID int
DECLARE @staffMSID int
Declare @VPID int
Declare @MSVPID int
Declare @staffMVID int
Declare @fromDate datetime
declare @validTo dateTime

DECLARE myCursor CURSOR SCROLL FOR
  SELECT staffMVID from tblStaffMVs inner join tblMilitaryVacs on tblMilitaryVacs.MVID = tblStaffMVs.MVID where vpID=@VPIDpassed
    
OPEN myCursor

-- now get the all the postid's
FETCH FIRST FROM myCursor INTO @staffMVID

WHILE @@FETCH_STATUS = 0
  BEGIN
	set @VPID = @VPIDpassed
	set @fromDate = (select validFrom from tblStaffMVs where staffMVID=@staffMVID)
		
	exec  spValPeriodAdd @fromDate,@VPID,@returnValue = @validTo output
	select @staffMVID as staffMVID,@fromDate as validFrom ,@validTo as validTo
	update tblStaffMVs set validTo = @validTo where staffMVID = @staffMVID
     -- now get the next post
     FETCH NEXT FROM myCursor INTO @staffMVID

  END

CLOSE myCursor
DEALLOCATE myCursor

DECLARE myCursor CURSOR SCROLL FOR
  SELECT staffDentalID from tblStaffDental inner join tblDental on tblDental.dentalID = tblStaffDental.dentalID where vpID = @VPIDpassed
    
OPEN myCursor

-- now get the all the postid's
FETCH FIRST FROM myCursor INTO @cursorID

WHILE @@FETCH_STATUS = 0
  BEGIN
	set @VPID = @VPIDpassed
	set @fromDate = (select validFrom from tblStaffDental where StaffDentalID=@cursorID)
		
	exec  spValPeriodAdd @fromDate,@VPID,@returnValue = @validTo output
	--select @cursorID as staffMVID,@fromDate as validFrom ,@validTo as validTo
	update tblStaffDental set validTo = @validTo where StaffDentalID = @cursorID
     -- now get the next post
     FETCH NEXT FROM myCursor INTO @cursorID

  END

CLOSE myCursor
DEALLOCATE myCursor

DECLARE myCursor CURSOR SCROLL FOR
  select stafffitnessID from tblStaffFitness inner join tblFitness on tblFitness.fitnessID = tblStaffFitness.fitnessID where vpID=@VPIDpassed
    
OPEN myCursor

-- now get the all the postid's
FETCH FIRST FROM myCursor INTO @cursorID

WHILE @@FETCH_STATUS = 0
  BEGIN
	set @VPID = @VPIDpassed
	set @fromDate = (select validFrom from tblStaffFitness where StaffFitnessID=@cursorID)
		
	exec  spValPeriodAdd @fromDate,@VPID,@returnValue = @validTo output
	--select @cursorID as staffMVID,@fromDate as validFrom ,@validTo as validTo
	update tblStaffFitness set validTo = @validTo where StaffFitnessID = @cursorID
     -- now get the next post
     FETCH NEXT FROM myCursor INTO @cursorID

  END

CLOSE myCursor
DEALLOCATE myCursor

DECLARE MilSkills CURSOR SCROLL FOR
  SELECT staffMSID from tblStaffMilSkill inner join tblMilitarySkills on tblMilitarySkills.MSID = tblStaffMilSkill.MSID where vpID=@VPIDpassed
    
OPEN MilSkills

-- now get the all the postid's
FETCH FIRST FROM MilSkills INTO @staffMSID

WHILE @@FETCH_STATUS = 0
  BEGIN
	set @MSVPID = @VPIDpassed
	set @fromDate = (select validFrom from tblStaffMilSkill where staffMSID=@staffMSID)
		
	exec  spValPeriodAdd @fromDate,@MSVPID,@returnValue = @validTo output
	--select @staffMSID as staffMSID,@fromDate as validFrom ,@validTo as validTo
	update tblStaffMilSkill set validTo = @validTo where staffMSID = @staffMSID
     -- now get the next post
     FETCH NEXT FROM MilSkills INTO @staffMSID

  END

CLOSE MilSkills
DEALLOCATE MilSkills
GO
/****** Object:  StoredProcedure [dbo].[spPostStaffSummary]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[spPostStaffSummary] 
@recID INT
AS
declare @staffID int
exec spPostDetailSummary @RecID

set @staffID=(select staffID from tblPost inner join tblStaff on tblStaff.PostID=tblPost.PostID  where tblPost.PostID = @recID)
exec  spPeRsDetailSummary @StaffID
GO
/****** Object:  StoredProcedure [dbo].[spPostStaffRemove]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spPostStaffRemove]
@postID int 
as 
declare @staffId int


set @staffID = (select staffId from tblStaff where postId=@PostID)
exec spStaffPostRemove @staffID
GO
/****** Object:  StoredProcedure [dbo].[spPostMilSkillsSummary]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[spPostMilSkillsSummary] 
@recID INT
AS
exec spPostDetailSummary @RecID

		SELECT     dbo.tblPost.postID, dbo.tblPostMilSkill.PostMSID, dbo.tblMilitarySkills.description,dbo.tblPostMilSkill.Status,dbo.tblPostMilSkill.Competent
		FROM         dbo.tblPost INNER JOIN
                dbo.tblPostMilSkill ON dbo.tblPost.PostID = dbo.tblPostMilSkill.postID INNER JOIN
                dbo.tblMilitarySkills ON dbo.tblPostMilSkill.MSID = dbo.tblMilitarySkills.msID
		where  dbo.tblPost.postID=@recid
GO
/****** Object:  StoredProcedure [dbo].[spPostMSSummary]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPostMSSummary]
(
	@RecID INT
)

AS

EXEC spPostDetailSummary @RecID

SELECT tblPost.postID, tblPostMilSkill.PostMSID, tblMilitarySkills.description, tblPostMilSkill.Status, tblPostMilSkill.Competent
FROM tblPost
INNER JOIN tblPostMilSkill ON tblPost.PostID = tblPostMilSkill.postID
INNER JOIN tblMilitarySkills ON tblPostMilSkill.MSID = tblMilitarySkills.msID
WHERE tblPost.postID = @RecID
GO
/****** Object:  StoredProcedure [dbo].[spPeRsPostMoveSummary]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[spPeRsPostMoveSummary]
@StaffID INT,
@thisDate varchar(20)

AS

SET dateformat DMY

exec spPeRsDetailSummary @StaffID,@thisDate

SELECT     *
FROM      vwPostMovements  

where StaffID=@StaffID

SELECT  TOP 50   *
FROM      vwTaskMovements  

where StaffID=@StaffID
  ORDER BY startDate DESC
GO
/****** Object:  StoredProcedure [dbo].[spPersPostHistory]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[spPersPostHistory] 
@recID INT

as

select staffPostID,postID,startdate,endDate,assignno,postDescription from vwStaffPostHistory where staffID = @recID order by startdate desc
GO
/****** Object:  StoredProcedure [dbo].[spPersonnelToTaskSearchResultsNew]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE        PROCEDURE [dbo].[spPersonnelToTaskSearchResultsNew]

@surname varchar(50),
@firstname varchar(50),
@serviceno varchar(50),
@TaskID int,
@teamID int

AS

DECLARE @str varchar(400)
DECLARE @staffID INT
DECLARE @todate DATETIME
DECLARE @fromdate DATETIME
DECLARE @ooa  INT
DECLARE @period INT
DECLARE @tname varchar(50)

DECLARE @Where VARCHAR(200)

/**
set @surname= @surname + '%'

set @firstname= @firstname + '%'

set @serviceno= @serviceno + '%'
**/

-- variables to calculate OOA for each person
SET @todate=getdate()
SET @period= 12       -- go back 12 months from today

-- build up the query - only use where parameters when we actually need them
SET @Where= 'WHERE Active = 1 '
IF @surname <> ''
   BEGIN
     SET @surname=@surname + '%'
     SET @Where=@Where + 'AND surname like '+ '''' + @surname + ''''
   END
IF @firstname <> ''
   BEGIN
     SET @firstname=@firstname + '%'
     SET @Where=@Where + 'AND firstname like '+ '''' + @firstname + ''''
   END
IF @serviceno <> ''
   BEGIN
     SET @serviceno=@serviceno + '%'
     SET @Where=@Where + 'AND serviceno like '+ '''' + @serviceno + ''''
   END

if @teamID<> 0 
  BEGIN
    SET @where=@where + ' AND teamID  = ' + convert(varchar(10),@teamID) + ' AND enddate is NULL '
  END

SET @str='INSERT INTO #tempOOA (staffid,surname,firstname,serviceno,dischargeDate, startReset,lastOOA ) '
SET @str=@str + 'SELECT DISTINCT TOP 100 PERCENT staffid,surname,firstname,serviceno,dischargeDate, startReset,lastOOA ' 
SET @str=@str + ' FROM vwStaffInPost '
SET @str = @str + @Where

-- first the get the start date of the period
EXEC spGetFromDate @todate, @period, @fromdate = @fromdate OUTPUT

-- first we create temp table of staff we want
CREATE TABLE #tempOOA (staffid INT PRIMARY KEY, surname VARCHAR(50), firstname VARCHAR(50),
                       serviceno VARCHAR(20), dischargeDate DATETIME, startReset DATETIME, lastOOA DATETIME,
                       ooaDays INT DEFAULT 0)
-- Now run the query set up in @str
EXEC(@str)
/**
INSERT INTO #tempOOA (staffid,surname,firstname,serviceno,dischargeDate, startReset,lastOOA )
       SELECT DISTINCT TOP 100 PERCENT staffid,surname,firstname,serviceno,dischargeDate, startReset,lastOOA 
             FROM vwStaffInPost 
                where Active = 1 AND
                      surname like   @surname   AND
                      firstname like @firstname AND
                      serviceno like @serviceno 
**/ 
-- Now we can go get the staff details AND the Harmony details
-- going back through time to the period start and calculate ooa days for each one
DECLARE tstaff CURSOR  FOR
  SELECT staffID FROM #tempOOA 
    
OPEN tstaff
FETCH NEXT FROM tstaff INTO @staffID

WHILE @@FETCH_STATUS = 0
 BEGIN

    SET @ooa=0    -- default to zero for each body

    -- Now run the stored procedure to calculate the OOA days for this person
    EXEC spGetHarmonyDays @staffID,@fromdate, @todate, @period, @ooa = @ooa OUTPUT

    -- store harmony days in temptable
    UPDATE #tempOOA 
      SET ooaDAYS = @ooa WHERE #tempOOA.staffID=@staffID
   
    FETCH NEXT FROM tstaff INTO @staffID

 END     -- END of loop through staff temp table 

CLOSE tstaff
DEALLOCATE tstaff

-- now we can return the data to the web page
SELECT * FROM #tempOOA ORDER BY surname 

drop table [dbo].[#tempOOA]
GO
/****** Object:  StoredProcedure [dbo].[spPeRsMilSkillsSummary]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[spPeRsMilSkillsSummary] 
@recID INT,
@thisDate varchar(20)
AS

SET dateformat DMY

exec spPeRsDetailSummary @RecID,@thisDate

		SELECT     dbo.tblStaff.staffID, dbo.tblStaffMilSkill.StaffMSID, dbo.tblMilitarySkills.description, ValidFrom, ValidTo, competent
		FROM         dbo.tblStaff INNER JOIN
                dbo.tblStaffMilSkill ON dbo.tblStaff.staffID = dbo.tblStaffMilSkill.StaffID INNER JOIN
                dbo.tblMilitarySkills ON dbo.tblStaffMilSkill.MSID = dbo.tblMilitarySkills.msID
		where  dbo.tblStaff.staffID=@recid
GO
/****** Object:  StoredProcedure [dbo].[spPeRsFitnessSummary]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPeRsFitnessSummary] 
(
	@RecID INT,
	@thisDate varchar(20)
)

AS

SET DATEFORMAT dmy

EXEC spPeRsDetailSummary @RecID,@thisDate

SELECT tblStaff.staffID, tblStaffFitness.StaffFitnessID, tblStaffFitness.ValidFrom, tblFitness.description
FROM tblStaff
INNER JOIN tblStaffFitness ON tblStaff.staffID = tblStaffFitness.StaffID
INNER JOIN tblFitness ON tblStaffFitness.FitnessID = tblFitness.FitnessID
WHERE tblStaff.staffID = @RecID
GO
/****** Object:  StoredProcedure [dbo].[spListTeamsDropDown]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListTeamsDropDown] AS
select TeamID,TeamIn,description, ParentDescription from vwTeamListForDetail
order by TeamIn,ParentDescription,description
GO
/****** Object:  StoredProcedure [dbo].[spPeRsVacsSummary]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPeRsVacsSummary] 
(
	@RecID INT,
	@thisDate varchar(20)
)

AS

SET DATEFORMAT dmy

EXEC spPeRsDetailSummary @RecID,@thisDate

SELECT tblStaff.staffID, tblStaffMVs.StaffMVID, tblMilitaryVacs.description, tblStaffMVs.ValidFrom
FROM tblStaff
INNER JOIN tblStaffMVs ON tblStaff.staffID = tblStaffMVs.StaffID
INNER JOIN tblMilitaryVacs ON tblStaffMVs.MVID = tblMilitaryVacs.mvID
WHERE tblStaff.staffID = @RecID
ORDER BY tblMilitaryVacs.description
GO
/****** Object:  StoredProcedure [dbo].[spPeRsTaskSummary]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spPeRsTaskSummary] 
@recID INT

AS

SET DATEFORMAT DMY

exec spPeRsDetailSummary @RecID

exec spPersTaskHistory @RecID
GO
/****** Object:  StoredProcedure [dbo].[spPeRsQsSummary]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spPeRsQsSummary] 
(
	@RecID	INT,
	@thisDate	VARCHAR(20)
)

AS

SET DATEFORMAT dmy

EXEC spPeRsDetailSummary @RecID, @thisDate

SELECT tblQs.QtypeID, tblQs.Description, tblStaff.staffID, tblValPeriod.vpdays, tblQs.Amber, tblStaffQs.ValidFrom
FROM tblStaff
INNER JOIN tblStaffQs ON tblStaff.staffID = tblStaffQs.StaffID
INNER JOIN tblQs ON tblStaffQs.QID = tblQs.QID
INNER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
WHERE tblStaff.staffID = @RecID
ORDER BY tblQs.Description
GO
/****** Object:  StoredProcedure [dbo].[spPeRsPostSummary]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE     PROCEDURE [dbo].[spPeRsPostSummary] 
@recID INT,
@PostID int
AS

exec spPeRsDetailSummary @RecID

exec spPersPostHistory @RecID

if @postID = 0

	Begin
		set @postId = (select top 1 postID from vwStaffPostHistory where staffID = @recID order by startDate desc)
	End

exec spPostDetail @PostID
GO
/****** Object:  StoredProcedure [dbo].[spListTeams]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListTeams] AS
select * from vwTeamList order by teamID
GO
/****** Object:  StoredProcedure [dbo].[spListSqnTeams]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListSqnTeams] AS
select * from vwTeamList where teamIn=2 order by description
GO
/****** Object:  StoredProcedure [dbo].[spListTeamStaff]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListTeamStaff]
(
	@recID		INT,
	@allTeams	INT,
	@thisDate	VARCHAR(16)
)

AS

DECLARE @startofMonth	VARCHAR(16)

SET DATEFORMAT dmy

SET @startofMonth = RIGHT(@thisDate,8)
SET @startofMonth = '01 ' + @startofMonth

IF @allTeams = 1
	BEGIN
		SELECT DISTINCT weight, staffID, surname, firstname, shortdesc
		FROM vwStaffInPost
		WHERE ghost = 0 AND (teamID = @recID OR teamID IN (SELECT childID FROM vwAllChildren WHERE parentID = @recID)) AND @thisDate >= startDate AND (CONVERT(DATETIME, @startofMonth)<= CONVERT(DATETIME, enddate) OR enddate IS NULL)
		ORDER BY weight DESC, surname
	END
ELSE
	BEGIN
		SELECT DISTINCT weight, staffID, surname, firstname, shortdesc
		FROM vwStaffInPost
		WHERE ghost = 0 AND (teamID = @recID) AND @thisDate >= startDate AND (CONVERT(DATETIME, @startofMonth) <= CONVERT(DATETIME, enddate) OR enddate IS NULL)
		ORDER BY weight DESC, surname
	END
GO
/****** Object:  StoredProcedure [dbo].[spValPUpdate]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spValPUpdate]
@RecID int,
@vpLength int,
@Description varchar (50),
@vpType int

as

declare @vpdays int
declare @vpnum int

if @vptype = '1'   -- Period is DAYS
  set @vpnum = '1'
ELSE if @vptype = '2'   -- Period is Weeks
  set @vpnum = '7'
else               -- Period is MONTHS
  set @vpnum = '30'

set @vpdays = (@vplength * @vpnum)

update tblValPeriod 
  set vplength = @vplength, vptype = @vptype, description = @description, vpdays = @vpdays
   where tblValPeriod.vpid = @recid


exec spRealignValidityPeriods @recid
GO
/****** Object:  StoredProcedure [dbo].[spReturnTeamStatus]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[spReturnTeamStatus]
@recID INT,--TeamID
@thisDate varChar (30),--StartOfWeek


@returnUnTasked int output,
@returnTasked int output,
@returnUnTrained int output,
@returnVacant int output
AS
/*
declare @recID int
declare @thisDate varChar (30)
declare @returnUnTasked int 
declare @returnTasked int 
declare @returnUnTrained int 
declare @returnVacant int
--constants
set @thisDate = '2 Jul 2007'
set @recID =15
*/
declare @staffPostID int
declare @PostID int
declare @StaffID int
declare @PostQTotal int
declare @QTotal int
declare @MilSkillStatus int
declare @milStatus int
declare @Percentage int
declare @startOfWeek dateTime
declare @endOfWeek dateTime
set @startOfWeek = convert(datetime,@thisDate,103)
set @endOfWeek = @startOfWeek+7



create table #MyTempTable (
	[staffPostID] [int],[PostID][int],[staffID][int],[weight][int],[weightScore] [int],[postQTotal] [int],[status][varchar](100)
	
)
	--select count(status)as StatusCount, status 

insert into #MyTempTable

	SELECT staffpostID, PostID,staffID,vwStaffInPost.weight,vwStaffInPost.weightScore, qualtotal as postQTotal, 'Tasked' as status
	from vwStaffInPost 
	where exists (select taskStaffID from tbl_taskStaff where 
	((startdate >= @startOfWeek and startDate < @endOfWeek) or (endDate >= @startOfWeek and endDate < @endOfWeek) or (startdate < @startOfWeek and endDate >= @endOfWeek))
	and tbl_taskStaff.staffId=vwStaffInPost.staffID and active=1) 
        and vwStaffInPost.description NOT LIKE 'Ghost%'   -- Ron 070808 - Exclude ghost posts
	and (teamID = @recID or teamID in (select childID from vwAllChildren where parentID = @recID))and 
	@thisDate>= startDate and (@thisDate<=enddate or endDate is null) 

	union

	select staffPostID,dbo.tblPost.postID,staffID,tempTable.weight,tempTable.weightScore,QTotal as PostQTotal,'UnTasked' as status
	from tblPost inner join dbo.tblTeam ON dbo.tblPost.teamID = dbo.tblTeam.teamID left outer join
	(SELECT * from vwStaffInPost where 
	@thisDate>= startDate and (@thisDate<=enddate or endDate is null)) 
	AS tempTable
	on tempTable.postId = tblPost.PostID
	 
	where not exists (select taskStaffID from tbl_taskStaff where 
	((startdate >= @startOfWeek and startDate < @endOfWeek) or (endDate >= @startOfWeek and endDate < @endOfWeek) or (startdate < @startOfWeek and endDate >= @endOfWeek)) 
	and tbl_taskStaff.staffId=tempTable.staffID and active=1)
        and tblPost.description NOT LIKE 'Ghost%'   -- Ron 070808 - Exclude ghost posts
	and (dbo.tblPost.teamID  = @recID or dbo.tblPost.teamID in (select childID from vwAllChildren where parentID = @recID)) and surname is not null
	
	union

	select *
	from (
	select staffPostID,dbo.tblPost.postID,staffID,tblRank.weight as Weight,tblRank.weightScore,QTotal as PostQTotal,'Vacant' as status
	from tblPost inner join dbo.tblTeam ON dbo.tblPost.teamID = dbo.tblTeam.teamID inner join tblRank on tblRank.rankID = dbo.tblPost.RankID left outer join
	(SELECT * from vwStaffInPost where  
	@thisDate>= startDate and (@thisDate<=enddate or endDate is null)) 
	AS tempTable
	on tempTable.postId = tblPost.PostID
	 
	where not exists (select taskStaffID from tbl_taskStaff where 
	((startdate >= @startOfWeek and startDate < @endOfWeek) or (endDate >= @startOfWeek and endDate < @endOfWeek) or (startdate < @startOfWeek and endDate >= @endOfWeek))
	and tbl_taskStaff.staffId=tempTable.staffID and active=1)
        and tblPost.description NOT LIKE 'Ghost%'   -- Ron 070808 - Exclude ghost posts
	and (dbo.tblPost.teamID  = @recID or dbo.tblPost.teamID in (select childID from vwAllChildren where parentID = @recID)) and surname is null

	

) as bigTable
--where status = 'tasked'
--group by status
order by weight desc


--Create cursor

DECLARE myCursor CURSOR SCROLL FOR
  SELECT staffPostID,PostID,StaffID,postQTotal from #MyTempTable
    
OPEN myCursor

-- now get the all the postid's
FETCH FIRST FROM myCursor INTO @staffPostID,@PostID,@StaffID,@PostQTotal

WHILE @@FETCH_STATUS = 0
  BEGIN
	if @staffPostID is not null

	begin
		exec spGetStaffQTotalOnly @StaffID,@PostID,@thisDate,@staffQtotal = @QTotal output
		if  @PostQTotal > 0
		Begin
			set @percentage=(convert(decimal,@QTotal)/convert(decimal,@PostQTotal)*100)
			if @Percentage < 76 or @percentage is null
			begin
				update #MyTempTable
				set status ='UnTrained' where staffPostId = @staffPostID
				--update #MyTempTable
				--set percentage = @Percentage where staffPostId = @staffPostID
			end
		End

		exec spGetMilStatusOnly @StaffID,@PostID,@thisDate,@MilStatus = @MilSkillStatus output
			--update #MyTempTable
			--set milstatus = @MilSkillStatus where staffPostId = @staffPostID
			
			if @MilSkillStatus=0
			begin
				update #MyTempTable
				set status ='UnTrained' where staffPostId = @staffPostID
			end


		--select @staffPostID
	end

	FETCH NEXT FROM myCursor INTO @staffPostID,@PostID,@StaffID,@PostQTotal
  END

CLOSE myCursor
DEALLOCATE myCursor

--Finished with Cursor


set @returnUnTasked = (select case when sum(weightScore)is null then '0' else sum(weightScore)end from #MyTempTable where status ='UnTasked')

set @returnTasked = (select case when sum(weightScore)is null then '0' else sum(weightScore)end as Tasked from #MyTempTable where status ='Tasked')

set @returnUnTrained = (select case when sum(weightScore)is null then '0' else sum(weightScore)end as UnTrained from #MyTempTable where status ='UnTrained')

set @returnVacant = (select case when sum(weightScore)is null then '0' else sum(weightScore)end as Vacant from #MyTempTable where status ='Vacant')


--select * from #MyTempTable
--group by Status 
drop table #MyTempTable
GO
/****** Object:  StoredProcedure [dbo].[spSqnPosts]    Script Date: 04/06/2016 15:22:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- get all the posts for the teams in the current squadron (sqnID = @levelID  level = 2)
CREATE     PROCEDURE [dbo].[spSqnPosts]
@posts    VARCHAR(8000) OUTPUT,
@parentID VARCHAR(50),
@level    VARCHAR(2)

AS

DECLARE @ID int
DECLARE @list VARCHAR (8000)

DECLARE team CURSOR SCROLL FOR
  SELECT tblpost.postID from tblteam 
    INNER JOIN tblpost ON
               tblpost.teamid = tblteam.teamid   
               WHERE  tblTeam.parentid = @parentID
                       AND
                       tblTeam.teamin = @level

OPEN team

-- now get the all the postid's
FETCH FIRST FROM team INTO @ID

WHILE @@FETCH_STATUS = 0
  BEGIN
     IF @posts IS NULL
          SET @posts = '''' + cast(@ID as char(3)) + ''''
     ELSE
     BEGIN
          SET @posts = @posts + ',' + '''' + cast(@ID as char(3)) + ''''
     END

     -- now get the next post
     FETCH NEXT FROM team INTO @ID

  END

CLOSE team
DEALLOCATE team

-- now we have all the squadron posts so get the flight posts ( level 3)
SET @level = @level + 1
DECLARE flt CURSOR SCROLL FOR
  SELECT tblflight.fltID from tblflight     
         WHERE  tblflight.sqnid = @parentID

OPEN flt

-- now go through all the flights for this squadron and run spFlightPosts for each one
-- this will give us all the posts for each flight and drill down to Teams in the Flight
FETCH FIRST FROM flt INTO @ID
WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @list = NULL
    EXEC spFlightPosts @list OUTPUT, @parentID = @ID, @level = @level

    -- now add the posts for this flight to list
    IF @list IS NOT NULL
     BEGIN
       IF @posts IS NULL
          SET @posts = @list
       ELSE
        BEGIN
          SET @posts = @posts + ',' + @list
        END
     END

   -- now get the next flight for this squadron
   FETCH NEXT FROM flt INTO @ID

  END

CLOSE flt
DEALLOCATE flt
GO
/****** Object:  StoredProcedure [dbo].[spTeamPostSummary]    Script Date: 04/06/2016 15:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
cREATE     PROCEDURE [dbo].[spTeamPostSummary] 
@recID INT
AS

exec spTeamDetail @recID

exec spListTeamPosts @recID
GO
/****** Object:  StoredProcedure [dbo].[spTeamPostsInAndOutStartEnd]    Script Date: 04/06/2016 15:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTeamPostsInAndOutStartEnd] 
(
	@recID		INT,
	@allTeams	INT,
	@startDate	VARCHAR(16),
	@endDate	VARCHAR(16),
	@sort		INT,
	@vacant	INT,
	@civi		INT
)

AS

SELECT teamID, teamIn, ParentID, description, ParentDescription
FROM vwTeamList
WHERE TeamId=@recID

EXEC spListTeamPostsInAndOutstartEnd @recID, @allTeams, @startDate, @endDate, @sort, @vacant, @civi
GO
/****** Object:  StoredProcedure [dbo].[spTeamPostsInAndOut]    Script Date: 04/06/2016 15:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTeamPostsInAndOut] 
(
	@recID		INT,
	@allTeams	INT,
	@thisDate	VARCHAR(16),
	@sort		INT
)

AS

SET DATEFORMAT dmy

SELECT teamID, teamIn, ParentID, description, ParentDescription
FROM vwTeamList
WHERE TeamId = @recID

EXEC spListTeamPostsInAndOut @recID,@allTeams,@thisDate,@sort
GO
/****** Object:  StoredProcedure [dbo].[spTeamPostAvailableToRemove]    Script Date: 04/06/2016 15:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[spTeamPostAvailableToRemove]
@recID INT,
@Description varchar(50),
@AssignNo varchar (50)
AS

exec spTeamDetail @recID

if @Description = '' 
	Begin
 		set @Description='%'
	End
if @AssignNo = '' 
	Begin
 		set @AssignNo='%'
	End


DECLARE @str varchar(600)

set @str = 'select postid,assignno,OuterTable.description,tblteam.description as Team FROM dbo.tblPost as OuterTable left outer join tblTeam  on tblTeam.TeamID = OuterTable.teamID where '

set @str=@str+' OuterTable.description like ' + '''' + @description +'%' + '''' + '  and assignno like' + '''' + @assignno +'%'+  ''''


set @str=@str +' and  1=1 and OuterTable.TeamID=' + CONVERT(varchar(20), @recID) + ' order by OuterTable.description'

EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spTeamPostAvailableToAdd]    Script Date: 04/06/2016 15:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE     PROCEDURE [dbo].[spTeamPostAvailableToAdd]
@recID INT,
@Description varchar(50),
@AssignNo varchar (50)
AS

exec spTeamDetail @recID

if @Description = '' 
	Begin
 		set @Description='%'
	End
if @AssignNo = '' 
	Begin
 		set @AssignNo='%'
	End


DECLARE @str varchar(600)

set @str = 'select postid,assignno,OuterTable.description,tblteam.description as Team FROM dbo.tblPost as OuterTable left outer join tblTeam  on tblTeam.TeamID = OuterTable.teamID where '

set @str=@str+' OuterTable.description like ' + '''' + @description +'%' + '''' + '  and assignno like' + '''' + @assignno +'%'+  ''''

set @str=@str +' and  1=1 and not exists(select postId from dbo.tblPost where OuterTable.TeamID=' + CONVERT(varchar(20), @recID) + ') order by OuterTable.description'
/*set @str=@str +' and  1=1 and not exists(select postId from dbo.vwVacantPosts where OuterTable.TeamID=' + CONVERT(varchar(20), @recID) + ') order by OuterTable.description'*/

EXEC(@str)
GO
/****** Object:  StoredProcedure [dbo].[spWingPosts]    Script Date: 04/06/2016 15:22:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- get all the posts for the teams in the current Wing (wingID = @levelID  level = 1)
CREATE     PROCEDURE [dbo].[spWingPosts]
@posts    VARCHAR(8000) OUTPUT,
@parentID VARCHAR(50),
@level    VARCHAR(2)

AS

DECLARE @ID int
DECLARE @list VARCHAR (8000)

DECLARE team CURSOR SCROLL FOR
  SELECT tblpost.postID from tblteam 
    INNER JOIN tblpost ON
               tblpost.teamid = tblteam.teamid   
               WHERE  tblTeam.parentid = @parentID
                       AND
                       tblTeam.teamin = @level

OPEN team

-- now get the all the wing teams postid's
FETCH FIRST FROM team INTO @ID

WHILE @@FETCH_STATUS = 0
  BEGIN
     IF @posts IS NULL
          SET @posts = '''' + cast(@ID as char(3)) + ''''
     ELSE
     BEGIN
          SET @posts = @posts + ',' + '''' + cast(@ID as char(3)) + ''''
     END

     -- now get the next post
     FETCH NEXT FROM team INTO @ID

  END

CLOSE team
DEALLOCATE team

-- now we have all the wing posts so get the squadron posts ( level 2)
SET @level = @level + 1
DECLARE sqn CURSOR SCROLL FOR
  SELECT tblsquadron.sqnID from tblsquadron     
         WHERE  tblsquadron.wingid = @parentID

OPEN sqn

-- now go through all the flights for this squadron and run spFlightPosts for each one
-- this will give us all the posts for each flight and drill down to Teams in the Flight
FETCH FIRST FROM sqn INTO @ID
WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @list = NULL
    EXEC spSqnPosts @list OUTPUT, @parentID = @ID, @level = @level

    -- now add the posts for this flight to list
    IF @list IS NOT NULL
     BEGIN
       IF @posts IS NULL
          SET @posts = @list
       ELSE
        BEGIN
          SET @posts = @posts + ',' + @list
        END
     END

   -- now get the next flight for this squadron
   FETCH NEXT FROM sqn INTO @ID

  END

CLOSE sqn
DEALLOCATE sqn
GO
/****** Object:  StoredProcedure [dbo].[spTeamStaff]    Script Date: 04/06/2016 15:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTeamStaff]

@recID INT,
@allTeams int,
@thisDate varchar (16)

AS

SET dateformat dmy

select teamID, teamIn, ParentID,description,ParentDescription from vwTeamList where TeamId = @recID

exec spListTeamStaff @recID,@allTeams,@thisDate
GO
/****** Object:  StoredProcedure [dbo].[spFltTeamCapability]    Script Date: 04/06/2016 15:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFltTeamCapability]
(
	@thisDate		VARCHAR(30),
	@SqnID		INT
)

AS

SET DATEFORMAT dmy

--This stored procedure currently calculates cabability for all flights in TCW. Once confirmed it is producing correct figure then add CP figures ie the flight's sqn personnel.
DECLARE @teamName		VARCHAR(30)
DECLARE @teamID		INT
DECLARE @Tasked		INT
DECLARE @UnTasked		INT
DECLARE @UnTrained		INT
DECLARE @Vacant		INT

--create temporary table for all Flight team details to be stored in
CREATE TABLE #MyOuterTempTable
(
	Flight			VARCHAR(100),
	UnTasked		INT,
	Tasked			INT,
	UnTrained		INT,
	Vacant			INT
)

DECLARE myOuterCursor CURSOR SCROLL FOR
	SELECT teamId FROM tblTeamHierarchy WHERE parentID = @SqnID

OPEN myOuterCursor

-- now get the all the postid's
FETCH FIRST FROM myOuterCursor INTO @TeamID

WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @teamName = (SELECT description FROM tblTeam WHERE teamId = @TeamID)
		EXEC spReturnTeamStatus @teamID,@thisDate,@returnUnTasked = @UnTasked output,@returnTasked = @Tasked output,@returnUnTrained = @UnTrained output,@returnVacant = @Vacant output

		INSERT #MyOuterTempTable VALUES(@teamName,@UnTasked,@Tasked,@UnTrained,@vacant)

		FETCH NEXT FROM myOuterCursor INTO @TeamID
	END

CLOSE myOuterCursor
DEALLOCATE myOuterCursor

SELECT	Flight,	---output details as percentages
CONVERT(VARCHAR(10),(CONVERT(DECIMAL(6,2),(CONVERT(DECIMAL(6,2),UnTasked)/126)*100)))+'%'+'('+CONVERT(VARCHAR(10),UnTasked)+')' as UnTasked,
CONVERT(VARCHAR(10),(CONVERT(DECIMAL(6,2),(CONVERT(DECIMAL(6,2),Tasked)/126)*100)))+'%'+'('+CONVERT(VARCHAR(10),Tasked)+')' as Tasked,
CONVERT(VARCHAR(10),(CONVERT(DECIMAL(6,2),(CONVERT(DECIMAL(6,2),UnTrained)/126)*100)))+'%'+'('+CONVERT(VARCHAR(10),UnTrained)+')' as UnTrained,
CONVERT(VARCHAR(10),(CONVERT(DECIMAL(6,2),(CONVERT(DECIMAL(6,2),Vacant)/126)*100)))+'%'+'('+CONVERT(VARCHAR(10),Vacant)+')' as Vacant,
CONVERT(VARCHAR(10),(CONVERT(DECIMAL(6,2),(CONVERT(DECIMAL(6,2),UnTasked+Tasked+UnTrained+vacant)/126)*100)))+'%'+'('+CONVERT(VARCHAR(10),UnTasked+Tasked+UnTrained+vacant)+')' as Total	
FROM #MyOuterTempTable

DROP TABLE #MyOuterTempTable	--drop temporary table
GO
/****** Object:  StoredProcedure [dbo].[spGroupPosts]    Script Date: 04/06/2016 15:22:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- get all the posts for the teams in the current Group (grpID = @levelID  level = 0)
CREATE     PROCEDURE [dbo].[spGroupPosts]
@posts    VARCHAR(8000) OUTPUT,
@parentID VARCHAR(50),
@level    VARCHAR(2)

AS

DECLARE @ID int
DECLARE @list VARCHAR (8000)

DECLARE team CURSOR SCROLL FOR
  SELECT tblpost.postID from tblteam 
    INNER JOIN tblpost ON
               tblpost.teamid = tblteam.teamid   
               WHERE  tblTeam.parentid = @parentID
                       AND
                       tblTeam.teamin = @level

OPEN team

-- now get the all the wing teams postid's
FETCH FIRST FROM team INTO @ID

WHILE @@FETCH_STATUS = 0
  BEGIN
     IF @posts IS NULL
          SET @posts = '''' + cast(@ID as char(3)) + ''''
     ELSE
     BEGIN
          SET @posts = @posts + ',' + '''' + cast(@ID as char(3)) + ''''
     END

     -- now get the next post
     FETCH NEXT FROM team INTO @ID

  END

CLOSE team
DEALLOCATE team

-- now we have all the group posts so get the wing posts ( level 1)
SET @level = @level + 1
DECLARE wing CURSOR SCROLL FOR
  SELECT tblwing.wingID from tblwing     
         WHERE  tblwing.grpid = @parentID

OPEN wing

-- now go through all the wings in this Group and run spWingPosts for each one
-- this will give us all the posts for each Wing and drill down to Teams in the 
-- Squadrons/Flights/Teams
FETCH FIRST FROM wing INTO @ID
WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @list = NULL
    EXEC spWingPosts @list OUTPUT, @parentID = @ID, @level = @level

    -- now add the posts for this wing to list
    IF @list IS NOT NULL
     BEGIN
       IF @posts IS NULL
          SET @posts = @list
       ELSE
        BEGIN
          SET @posts = @posts + ',' + @list
        END
     END

   -- now get the next wing for this group
   FETCH NEXT FROM wing INTO @ID

  END

CLOSE wing
DEALLOCATE wing
GO
/****** Object:  StoredProcedure [dbo].[spGetManagerPosts]    Script Date: 04/06/2016 15:22:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- get all the posts the current Manager is allowed to allocate personnel to
CREATE  PROCEDURE [dbo].[spGetManagerPosts]
@staffID  INT,
@descr    VARCHAR(255),
@assigno  VARCHAR(255)

AS

DECLARE @levelID INT
DECLARE @level INT
DECLARE @posts    VARCHAR(8000) 
DECLARE @parentID VARCHAR(50)
DECLARE @ID int
DECLARE @expr VARCHAR(8000)

-- first get the managers level so we know where we start from
SET @levelID = (SELECT tblmanager.tmlevelid from tblstaffpost 
       inner join tblmanager on tblmanager.postid = tblstaffpost.postid
          where tblstaffpost.staffid = @staffid)

SET @level = (SELECT tblmanager.tmlevel from tblstaffpost 
       inner join tblmanager on tblmanager.postid = tblstaffpost.postid
          where tblstaffpost.staffid = @staffid)

-- now we need to get the next the correct parentid so we can go through
-- the teams/post combination again
IF @level = '5'    -- sub team level - lowest possible level
   BEGIN
     -- here we get the current sub-team and get and get its posts
     EXEC spTeamPosts @posts OUTPUT, @parentID = @levelID, @level = @level
   END
ELSE
 IF @level = '4'   -- team level  - could have sub-teams below
   BEGIN
     -- here we get the current team and get
     -- the posts from the team/sub team structure
     EXEC spTeamPosts @posts OUTPUT, @parentID = @levelID, @level = @level
   END
ELSE
 IF @level = '3'  -- flight level  - will have teams at this level and below
   BEGIN
     -- here we go through all the flights in the current squadron and get the
     -- the posts from the flight/team/sub team structure
     EXEC spFlightPosts @posts OUTPUT, @parentID = @levelID, @level = @level
   END
ELSE 
 IF @level = '2' -- squadron level - will have teams at this level and below
   BEGIN
     -- here we go through all the sqns in the current wing and get the
     -- the posts from the sqn/flight/team/sub team structure
     EXEC spSqnPosts @posts OUTPUT, @parentID = @levelID, @level = @level
   END
ELSE
 IF @level = '1' -- wing level  - will have teams at this level and below
   BEGIN
     -- here we go through all the wings in the current group and get the
     -- the posts from the wing/sqn/flight/team/sub team structure
     EXEC spWingPosts @posts OUTPUT, @parentID = @levelID, @level = @level
   END
 ELSE
 IF @level = '0' -- wing level  - will have teams at this level and below
   BEGIN
     -- here we go through all the Groups  and get the
     -- the posts from the group/wing/sqn/flight/team/sub team structure
     EXEC spGroupPosts @posts OUTPUT, @parentID = @levelID, @level = @level
   END

set @expr = 'select postID, tblpost.description, assignno, tblteam.description as Team
            from tblpost INNER JOIN tblteam ON tblpost.teamID = tblteam.teamID
             where tblpost.postid IN (' + @posts + ')'
--set @expr = 'select count (*) from tblpost where tblpost.postid  IN (' + @posts + ')'
     
if @Descr <> ''
  set @expr=@expr+' AND tblpost.description like ' + '''' + @descr +'%' + ''''

if @assigno <> '' 
  set @expr=@expr+ ' AND tblpost.assignno like' + '''' + @assigno +'%'+  ''''

exec (@expr)
GO
/****** Object:  Default [DF__tblAudit__ndeID__7C6F7215]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblAudit] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tbl_TaskU__activ__536D5C82]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_TaskUnit] ADD  DEFAULT ((1)) FOR [active]
GO
/****** Object:  Default [DF__tbl_TaskU__dateS__546180BB]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_TaskUnit] ADD  DEFAULT (getdate()) FOR [dateStamp]
GO
/****** Object:  Default [DF__tbl_TaskU__updat__5555A4F4]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_TaskUnit] ADD  DEFAULT ((0)) FOR [updatedBy]
GO
/****** Object:  Default [DF__tbl_TaskU__pendi__5649C92D]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_TaskUnit] ADD  DEFAULT ((0)) FOR [pending]
GO
/****** Object:  Default [DF__tbl_TaskU__ndeID__7F4BDEC0]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_TaskUnit] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tbl_TaskU__hrcID__31D75E8D]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_TaskUnit] ADD  DEFAULT ((0)) FOR [hrcID]
GO
/****** Object:  Default [DF_tbl_TaskStaff_active]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_TaskStaff] ADD  CONSTRAINT [DF_tbl_TaskStaff_active]  DEFAULT ((1)) FOR [active]
GO
/****** Object:  Default [DF_tbl_TaskStaff_dateStamp]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_TaskStaff] ADD  CONSTRAINT [DF_tbl_TaskStaff_dateStamp]  DEFAULT (getdate()) FOR [dateStamp]
GO
/****** Object:  Default [DF_tbl_TaskStaff_updatedBy]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_TaskStaff] ADD  CONSTRAINT [DF_tbl_TaskStaff_updatedBy]  DEFAULT ((0)) FOR [updatedBy]
GO
/****** Object:  Default [DF__tbl_TaskS__pendi__5A1A5A11]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_TaskStaff] ADD  DEFAULT ((0)) FOR [pending]
GO
/****** Object:  Default [DF__tbl_TaskS__ndeID__02284B6B]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_TaskStaff] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tbl_TaskC__ndeID__041093DD]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_TaskCategory] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF_tbl_Task_Cancellable]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_Task] ADD  CONSTRAINT [DF_tbl_Task_Cancellable]  DEFAULT ((0)) FOR [Cancellable]
GO
/****** Object:  Default [DF__tbl_Task__hqtask__5C02A283]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_Task] ADD  DEFAULT ((0)) FOR [hqtask]
GO
/****** Object:  Default [DF__tbl_Task__sscID__5CF6C6BC]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_Task] ADD  DEFAULT ((0)) FOR [sscID]
GO
/****** Object:  Default [DF__tbl_Task__ndeID__05F8DC4F]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tbl_Task] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblWing__ndeID__658C0CBD]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblWing] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblValPer__ndeID__668030F6]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblValPeriod] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblUnitHa__ndeID__68687968]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblUnitHarmonyTarget] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblTraini__ndeID__6A50C1DA]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTrainingCourse] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblTradeG__ndeID__6C390A4C]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTradeGroup] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF_tblTrade_tradegroup]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTrade] ADD  CONSTRAINT [DF_tblTrade_tradegroup]  DEFAULT ((0)) FOR [tradeGroupID]
GO
/****** Object:  Default [DF__tblTrade__ndeID__6F1576F7]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTrade] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblTempHi__ndeID__70FDBF69]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTempHierarchy] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblTeamHi__ndeID__72E607DB]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTeamHierarchy] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblTeamHi__hrcID__2EFAF1E2]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTeamHierarchy] ADD  DEFAULT ((0)) FOR [hrcID]
GO
/****** Object:  Default [DF__tblTeam__ndeID__73DA2C14]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTeam] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [db_wl]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTaskType] ADD  CONSTRAINT [db_wl]  DEFAULT ((0)) FOR [WithList]
GO
/****** Object:  Default [db_ac]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTaskType] ADD  CONSTRAINT [db_ac]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [db_sc]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTaskType] ADD  CONSTRAINT [db_sc]  DEFAULT ((6)) FOR [Section]
GO
/****** Object:  Default [db_od]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTaskType] ADD  CONSTRAINT [db_od]  DEFAULT ((0)) FOR [Order]
GO
/****** Object:  Default [DF__tblTaskTy__ndeID__74CE504D]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTaskType] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblTaskSt__ndeID__76B698BF]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTaskStatus] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblTaskPe__ndeID__789EE131]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTaskPending] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblTaskNo__ndeID__7B7B4DDC]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTaskNotes] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblTasked__pendi__1B29035F]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTasked] ADD  DEFAULT ((0)) FOR [pending]
GO
/****** Object:  Default [DF__tblTasked__ndeID__7D63964E]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTasked] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblTaskCl__ndeID__7E57BA87]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTaskClash] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblTask__hqtask__1C1D2798]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTask] ADD  DEFAULT ((0)) FOR [hqtask]
GO
/****** Object:  Default [DF__tblTask__ooa__1D114BD1]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTask] ADD  DEFAULT ((0)) FOR [ooa]
GO
/****** Object:  Default [DF__tblTask__ndeID__004002F9]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblTask] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblStatus__ndeID__01342732]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStatus] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF_tblStaffQs_ValidFrom]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffQs] ADD  CONSTRAINT [DF_tblStaffQs_ValidFrom]  DEFAULT ('23 mar 72') FOR [ValidFrom]
GO
/****** Object:  Default [DF_tblStaffQs_Competent]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffQs] ADD  CONSTRAINT [DF_tblStaffQs_Competent]  DEFAULT ('N') FOR [Competent]
GO
/****** Object:  Default [DF__tblStaffQ__ndeID__031C6FA4]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffQs] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF_tblStaffPost_startDate]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffPost] ADD  CONSTRAINT [DF_tblStaffPost_startDate]  DEFAULT ('1 jan 2006') FOR [startDate]
GO
/****** Object:  Default [DF__tblStaffP__ndeID__0504B816]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffPost] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblStaffP__ndeID__06ED0088]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffPhoto] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF_tblStaffMVs_ValidFrom]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffMVs] ADD  CONSTRAINT [DF_tblStaffMVs_ValidFrom]  DEFAULT ('1 jan 2006') FOR [ValidFrom]
GO
/****** Object:  Default [DF_tblStaffMVs_ValidTo]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffMVs] ADD  CONSTRAINT [DF_tblStaffMVs_ValidTo]  DEFAULT ('31 dec 2006') FOR [ValidTo]
GO
/****** Object:  Default [DF_tblStaffMVs_Competent]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffMVs] ADD  CONSTRAINT [DF_tblStaffMVs_Competent]  DEFAULT ('N') FOR [Competent]
GO
/****** Object:  Default [DF__tblStaffM__ndeID__07E124C1]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffMVs] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF_tblStaffMilSkill_ValidFrom]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffMilSkill] ADD  CONSTRAINT [DF_tblStaffMilSkill_ValidFrom]  DEFAULT ('1 jan 2006') FOR [ValidFrom]
GO
/****** Object:  Default [DF_tblStaffMilSkill_ValidTo]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffMilSkill] ADD  CONSTRAINT [DF_tblStaffMilSkill_ValidTo]  DEFAULT ('31 dec 2006') FOR [ValidTo]
GO
/****** Object:  Default [DF_tblStaffMilSkill_Competent]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffMilSkill] ADD  CONSTRAINT [DF_tblStaffMilSkill_Competent]  DEFAULT ('N') FOR [Competent]
GO
/****** Object:  Default [DF__tblStaffM__Exemp__629A9179]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffMilSkill] ADD  CONSTRAINT [DF__tblStaffM__Exemp__629A9179]  DEFAULT ((0)) FOR [Exempt]
GO
/****** Object:  Default [DF__tblStaffM__ndeID__08D548FA]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffMilSkill] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblStaffH__ndeID__09C96D33]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffHarmony] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF_tblStaffFitness_ValidFrom]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffFitness] ADD  CONSTRAINT [DF_tblStaffFitness_ValidFrom]  DEFAULT ('1 jan 2006') FOR [ValidFrom]
GO
/****** Object:  Default [DF_tblStaffFitness_ValidTo]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffFitness] ADD  CONSTRAINT [DF_tblStaffFitness_ValidTo]  DEFAULT ('31 Dec 2006') FOR [ValidTo]
GO
/****** Object:  Default [DF_tblStaffFitness_Competent]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffFitness] ADD  CONSTRAINT [DF_tblStaffFitness_Competent]  DEFAULT ('N') FOR [Competent]
GO
/****** Object:  Default [DF__tblStaffF__ndeID__0ABD916C]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffFitness] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF_tblStaffDental_ValidFrom]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffDental] ADD  CONSTRAINT [DF_tblStaffDental_ValidFrom]  DEFAULT ('1 jan 2006') FOR [ValidFrom]
GO
/****** Object:  Default [DF_tblStaffDental_ValidTo]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffDental] ADD  CONSTRAINT [DF_tblStaffDental_ValidTo]  DEFAULT ('31 dec 2006') FOR [ValidTo]
GO
/****** Object:  Default [DF_tblStaffDental_Competent]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffDental] ADD  CONSTRAINT [DF_tblStaffDental_Competent]  DEFAULT ('N') FOR [Competent]
GO
/****** Object:  Default [DF__tblStaffD__ndeID__0BB1B5A5]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaffDental] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF_tblStaff_administrator]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaff] ADD  CONSTRAINT [DF_tblStaff_administrator]  DEFAULT ((0)) FOR [administrator]
GO
/****** Object:  Default [DF_tblStaff_remedial]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaff] ADD  CONSTRAINT [DF_tblStaff_remedial]  DEFAULT ((0)) FOR [remedial]
GO
/****** Object:  Default [DF__tblStaff__active__2F2FFC0C]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaff] ADD  CONSTRAINT [DF__tblStaff__active__2F2FFC0C]  DEFAULT ((0)) FOR [active]
GO
/****** Object:  Default [DF__tblStaff__ddssa__30242045]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaff] ADD  CONSTRAINT [DF__tblStaff__ddssa__30242045]  DEFAULT ((0)) FOR [ddssa]
GO
/****** Object:  Default [DF__tblStaff__ddssb__3118447E]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaff] ADD  CONSTRAINT [DF__tblStaff__ddssb__3118447E]  DEFAULT ((0)) FOR [ddssb]
GO
/****** Object:  Default [DF__tblStaff__taskOO__320C68B7]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaff] ADD  CONSTRAINT [DF__tblStaff__taskOO__320C68B7]  DEFAULT ((0)) FOR [taskOOA]
GO
/****** Object:  Default [DF__tblStaff__ddooa__33008CF0]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaff] ADD  CONSTRAINT [DF__tblStaff__ddooa__33008CF0]  DEFAULT ((0)) FOR [ddooa]
GO
/****** Object:  Default [DF__tblStaff__exempt__33F4B129]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaff] ADD  CONSTRAINT [DF__tblStaff__exempt__33F4B129]  DEFAULT ((0)) FOR [exempt]
GO
/****** Object:  Default [DF__tblStaff__susat__34E8D562]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaff] ADD  CONSTRAINT [DF__tblStaff__susat__34E8D562]  DEFAULT ((0)) FOR [susat]
GO
/****** Object:  Default [DF__tblStaff__ndeID__0CA5D9DE]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaff] ADD  CONSTRAINT [DF__tblStaff__ndeID__0CA5D9DE]  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF_tblStaff_CMSAdminstrator]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblStaff] ADD  CONSTRAINT [DF_tblStaff_CMSAdminstrator]  DEFAULT ((0)) FOR [CMSAdministrator]
GO
/****** Object:  Default [DF__tblSSC__ndeID__0D99FE17]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblSSC] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblSquadr__ndeID__0E8E2250]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblSquadron] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblReport__ndeID__0F824689]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblReports] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblRankWe__ndeID__10766AC2]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblRankWeight] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF_tblRank_status]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblRank] ADD  CONSTRAINT [DF_tblRank_status]  DEFAULT ((1)) FOR [status]
GO
/****** Object:  Default [DF_tblRank_RankWeight]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblRank] ADD  CONSTRAINT [DF_tblRank_RankWeight]  DEFAULT ((99)) FOR [Weight]
GO
/****** Object:  Default [DF__tblRank__ndeID__116A8EFB]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblRank] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblQWeigh__ndeID__125EB334]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblQWeight] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblQTypes__Auth__37C5420D]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblQTypes] ADD  DEFAULT ((0)) FOR [Auth]
GO
/****** Object:  Default [DF__tblQTypes__ndeID__1352D76D]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblQTypes] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblQs__Amber__38B96646]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblQs] ADD  DEFAULT ((0)) FOR [Amber]
GO
/****** Object:  Default [DF__tblQs__Enduring__39AD8A7F]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblQs] ADD  DEFAULT ((0)) FOR [Enduring]
GO
/****** Object:  Default [DF__tblQs__Contingen__3AA1AEB8]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblQs] ADD  DEFAULT ((0)) FOR [Contingent]
GO
/****** Object:  Default [DF__tblQs__ndeID__1446FBA6]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblQs] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblPostQS__ndeID__153B1FDF]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblPostQStatus] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF_tblPostQs_Status]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblPostQs] ADD  CONSTRAINT [DF_tblPostQs_Status]  DEFAULT ((1)) FOR [Status]
GO
/****** Object:  Default [DF_tblPostQs_Competent]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblPostQs] ADD  CONSTRAINT [DF_tblPostQs_Competent]  DEFAULT ((0)) FOR [Competent]
GO
/****** Object:  Default [DF__tblPostQs__ndeID__162F4418]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblPostQs] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblPostMi__ndeID__17236851]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblPostMilSkill] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF_tblPost_manager]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblPost] ADD  CONSTRAINT [DF_tblPost_manager]  DEFAULT ((0)) FOR [manager]
GO
/****** Object:  Default [DF__tblPost__QTotal__795DFB40]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblPost] ADD  CONSTRAINT [DF__tblPost__QTotal__795DFB40]  DEFAULT ('0') FOR [QTotal]
GO
/****** Object:  Default [DF__tblPost__Status__3F6663D5]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblPost] ADD  DEFAULT ((1)) FOR [Status]
GO
/****** Object:  Default [DF__tblPost__ndeID__18178C8A]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblPost] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblPost__hrcID__2FEF161B]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblPost] ADD  DEFAULT ((0)) FOR [hrcID]
GO
/****** Object:  Default [DF__tblPositi__ndeID__190BB0C3]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblPosition] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblPasswo__ndeID__19FFD4FC]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblPassword] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblOpTeam__ndeID__1AF3F935]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblOpTeam] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblOpTeam__hrcID__30E33A54]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblOpTeam] ADD  DEFAULT ((0)) FOR [hrcID]
GO
/****** Object:  Default [DF__tblOpTask__ndeID__1BE81D6E]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblOpTaskCategory] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblOpTask__ndeID__1CDC41A7]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblOpTask] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblOpEqpt__ndeID__1DD065E0]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblOpEqpt] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblOpActi__ndeID__1EC48A19]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblOpAction] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblOOADay__ndeID__1FB8AE52]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblOOADays] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblMSWeig__ndeID__20ACD28B]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblMSWeight] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblMilita__Comba__405A880E]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblMilitaryVacs] ADD  DEFAULT ((0)) FOR [Combat]
GO
/****** Object:  Default [DF__tblMilita__ndeID__21A0F6C4]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblMilitaryVacs] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblMilita__Comba__414EAC47]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblMilitarySkills] ADD  DEFAULT ((0)) FOR [Combat]
GO
/****** Object:  Default [DF__tblMilitar__Fear__4242D080]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblMilitarySkills] ADD  DEFAULT ((0)) FOR [Fear]
GO
/****** Object:  Default [DF__tblMilita__Amber__4336F4B9]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblMilitarySkills] ADD  DEFAULT ((0)) FOR [Amber]
GO
/****** Object:  Default [DF__tblMilita__ndeID__22951AFD]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblMilitarySkills] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblMES__ndeID__23893F36]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblMES] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblManage__ndeID__247D636F]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblManager] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblManage__hrcID__39788055]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblManager] ADD  DEFAULT ((0)) FOR [hrcID]
GO
/****** Object:  Default [DF__tblHarmon__ndeID__5DEAEAF5]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblHarmonyPeriod] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblHarmon__ndeID__5EDF0F2E]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblHarmonyOverride] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblGroup__hqTask__442B18F2]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblGroup] ADD  DEFAULT ((0)) FOR [hqTasking]
GO
/****** Object:  Default [DF__tblGroup__ndeID__5FD33367]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblGroup] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblGeneri__ndeID__60C757A0]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblGenericPW] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblFlight__ndeID__61BB7BD9]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblFlight] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblFitnes__Comba__451F3D2B]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblFitness] ADD  DEFAULT ((0)) FOR [Combat]
GO
/****** Object:  Default [DF__tblFitnes__Exemp__46136164]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblFitness] ADD  DEFAULT ((0)) FOR [Exempt]
GO
/****** Object:  Default [DF__tblFitnes__ndeID__62AFA012]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblFitness] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblEquipm__ndeID__63A3C44B]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblEquipmentTemp] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblDept__ndeID__6497E884]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblDept] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblDental__Comba__4707859D]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblDental] ADD  DEFAULT ((0)) FOR [Combat]
GO
/****** Object:  Default [DF__tblDental__ndeID__6774552F]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblDental] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblDefaul__ndeID__695C9DA1]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblDefaultPhoto] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblCycleS__ndeID__6B44E613]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblCycleSteps] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblCycleS__ndeID__6D2D2E85]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblCycleStage] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblCycle__ndeID__6E2152BE]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblCycle] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblContac__ndeID__70099B30]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblContact] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblConfig__pla__47FBA9D6]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblConfig] ADD  DEFAULT ((0)) FOR [pla]
GO
/****** Object:  Default [DF__tblConfig__tas__48EFCE0F]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblConfig] ADD  DEFAULT ((0)) FOR [tas]
GO
/****** Object:  Default [DF__tblConfig__man__49E3F248]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblConfig] ADD  DEFAULT ((0)) FOR [man]
GO
/****** Object:  Default [DF__tblConfig__per__4AD81681]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblConfig] ADD  DEFAULT ((0)) FOR [per]
GO
/****** Object:  Default [DF__tblConfig__uni__4BCC3ABA]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblConfig] ADD  DEFAULT ((0)) FOR [uni]
GO
/****** Object:  Default [DF__tblConfig__cap__4CC05EF3]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblConfig] ADD  DEFAULT ((0)) FOR [cap]
GO
/****** Object:  Default [DF__tblConfig__pre__4DB4832C]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblConfig] ADD  DEFAULT ((0)) FOR [pre]
GO
/****** Object:  Default [DF__tblConfig__fit__4EA8A765]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblConfig] ADD  DEFAULT ((0)) FOR [fit]
GO
/****** Object:  Default [DF__tblConfig__boa__4F9CCB9E]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblConfig] ADD  DEFAULT ((0)) FOR [boa]
GO
/****** Object:  Default [DF__tblConfig__sch__5090EFD7]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblConfig] ADD  DEFAULT ((0)) FOR [sch]
GO
/****** Object:  Default [DF__tblConfig__nom__51851410]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblConfig] ADD  DEFAULT ((0)) FOR [nom]
GO
/****** Object:  Default [DF__tblConfig__ran__52793849]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblConfig] ADD  DEFAULT ((0)) FOR [ran]
GO
/****** Object:  Default [DF__tblConfig__ndeID__71F1E3A2]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblConfig] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblCondFo__ndeID__75C27486]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblCondFormat] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblCapabi__ndeID__77AABCF8]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblCapabilityCategoryDetail] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblCapabi__ndeID__7993056A]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblCapabilityCategory] ADD  DEFAULT ((0)) FOR [ndeID]
GO
/****** Object:  Default [DF__tblCapabi__ndeID__7A8729A3]    Script Date: 04/06/2016 15:22:18 ******/
ALTER TABLE [dbo].[tblCapability] ADD  DEFAULT ((0)) FOR [ndeID]
GO
