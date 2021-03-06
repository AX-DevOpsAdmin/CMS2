
-- CMSMigrateAddTables
-- FIRST script to run
-- Builds the CMS Migration database ready for the Target data to be imported
-- we can work on the data in the CMSMigrate data ready for migration to the CMS2 Live Dbase

USE [CMSMigrate]
GO

EXEC sp_MSforeachtable 'DROP TABLE ?'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblWing](
	[wingID] [int] NULL,
	[grpID] [int] NULL,
	[description] [varchar](50) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblValPeriod](
	[vpID] [int] NULL,
	[description] [varchar](50) NULL,
	[vplength] [smallint] NULL,
	[vptype] [smallint] NULL,
	[vpdays] [int] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblUnitHarmonyTarget](
	[uhpID] [int] NULL,
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
	[ooared] [decimal](10, 2) NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblTrainingCourse](
	[tcID] [int] NULL,
	[tctype] [smallint] NOT NULL,
	[msqID] [int] NOT NULL,
	[description] [char](10) NULL,
	[startdate] [smalldatetime] NULL,
	[enddate] [smalldatetime] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblTradeGroup](
	[TradeGroupID] [int]  NULL,
	[TradeGroup] [int] NOT NULL,
	[description] [varchar](50) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblTrade](
	[tradeID] [int] NULL,
	[description] [varchar](50) NULL,
	[tradeGroupID] [int] NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblTempHierarchy](
	[teamID] [int] NOT NULL,
	[ParentID] [int] NOT NULL,
	[Teamin] [int] NOT NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblTeamHierarchy](
	[teamID] [int] NOT NULL,
	[ParentID] [int] NOT NULL,
	[Teamin] [int] NOT NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblTeam](
	[teamID] [int] NULL,
	[parentID] [int] NULL,
	[teamIn] [int] NULL,
	[teamCP] [bit] NULL,
	[teamSize] [int] NULL,
	[description] [varchar](50) NULL,
	[weight] [int] NULL,
	[cycleID] [int] NULL,
	[firstStage] [int] NULL,
	[cycleStart] [datetime] NULL,
	[belongsto] [int] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblTaskType](
	[ttID] [int] NULL,
	[description] [varchar](50) NOT NULL,
	[WithList] [int] NOT NULL,
	[Active] [int] NOT NULL,
	[Section] [int] NOT NULL,
	[Order] [int] NOT NULL,
	[taskcolor] [varchar](10) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblTaskStatus](
	[otsID] [int] NULL,
	[description] [varchar](50) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblTaskPending](
	[tpID] [smallint] NULL,
	[tskID] [int] NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblTaskNotes](
	[taskNoteID] [int] NULL,
	[taskNote] [varchar](3000) NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [tblTasked](
	[tskID] [int] NULL,
	[ttID] [int] NOT NULL,
	[staffID] [int] NOT NULL,
	[description] [varchar](100) NOT NULL,
	[trainingID] [int] NULL,
	[accepted] [bit] NULL,
	[startdate] [datetime] NOT NULL,
	[enddate] [datetime] NOT NULL,
	[priority] [smallint] NULL,
	[cancelable] [bit] NOT NULL,
	[pending] [bit] NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [tblTaskClash](
	[ClashID] [int] NULL,
	[userID] [int] NOT NULL,
	[taskStaffID] [int] NOT NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
/**
CREATE TABLE [tblTask](
	[taskID] [int] NULL,
	[ttID] [int] NULL,
	[description] [varchar](50) NULL,
	[hqtask] [bit] NOT NULL,
	[ooa] [bit] NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
**/
CREATE TABLE [tblStatus](
	[statusID] [int] NULL,
	[description] [varchar](50) NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblStaffQs](
	[StaffQID] [int] NULL,
	[StaffID] [int] NOT NULL,
	[TypeID] [int] NOT NULL,
	[ValidFrom] [datetime] NOT NULL,
	[ValidEnd] [datetime] NULL,
	[Competent] [char](1) NOT NULL,
	[QID] [int] NULL,
	[AuthName] [varchar](20) NULL,
	[UpBy] [int] NULL,
	[UpDated] [datetime] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblStaffPost](
	[StaffPostID] [int] NULL,
	[StaffID] [int] NOT NULL,
	[PostID] [int] NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblStaffPhoto](
	[stphID] [int] NULL,
	[staffID] [int] NOT NULL,
	[staffphoto] [image] NULL,
	[photoPath] [varchar](200) NULL,
	[fileSize] [int] NULL,
	[contentType] [varchar](50) NULL
) TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblStaffMVs](
	[StaffMVID] [int] NULL,
	[StaffID] [int] NOT NULL,
	[MVID] [int] NOT NULL,
	[ValidFrom] [datetime] NOT NULL,
	[ValidTo] [datetime] NOT NULL,
	[Competent] [char](1) NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblStaffMilSkill](
	[StaffMSID] [int] NULL,
	[StaffID] [int] NOT NULL,
	[MSID] [int] NOT NULL,
	[ValidFrom] [datetime] NOT NULL,
	[ValidTo] [datetime] NOT NULL,
	[Competent] [char](1) NOT NULL,
	[Exempt] [int] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblStaffHarmony](
	[sthmID] [smallint] NULL,
	[staffID] [int] NULL,
	[ooadays] [int] NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblStaffFitness](
	[StaffFitnessID] [int] NULL,
	[StaffID] [int] NOT NULL,
	[FitnessID] [int] NOT NULL,
	[ValidFrom] [datetime] NOT NULL,
	[ValidTo] [datetime] NOT NULL,
	[Competent] [char](1) NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblStaffDental](
	[StaffDentalID] [int] NULL,
	[StaffID] [int] NOT NULL,
	[DentalID] [int] NOT NULL,
	[ValidFrom] [datetime] NOT NULL,
	[ValidTo] [datetime] NOT NULL,
	[Competent] [char](1) NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblStaff](
	[staffID] [int] NULL,
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
	[expiryDate] [datetime] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblSSC](
	[sscID] [smallint] NULL,
	[ssCode] [int] NULL,
	[ssType] [int] NULL,
	[description] [varchar](50) NULL,
	[ssNotes] [varchar](500) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblSquadron](
	[sqnID] [int] NULL,
	[wingID] [int] NULL,
	[description] [varchar](50) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblReports](
	[rptID] [int] NULL,
	[Name] [varchar](20) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblRankWeight](
	[rwID] [int] NULL,
	[description] [varchar](50) NULL,
	[rankWt] [smallint] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblRank](
	[rankID] [int]  NOT NULL,
	[shortDesc] [varchar](15) NOT NULL,
	[description] [varchar](50) NULL,
	[status] [bit] NOT NULL,
	[Weight] [int] NOT NULL,
	[weightScore] [int] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblQWeight](
	[qwID] [int] NULL,
	[qwtype] [char](2) NULL,
	[description] [varchar](50) NULL,
	[qwvalue] [int] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblQTypes](
	[QtypeID] [int] NULL,
	[Description] [varchar](50) NOT NULL,
	[Auth] [bit] NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblQs](
	[QID] [int] NULL,
	[Description] [varchar](50) NOT NULL,
	[QTypeID] [int] NOT NULL,
	[vpID] [int] NULL,
	[Amber] [int] NULL,
	[Enduring] [bit] NULL,
	[Contingent] [bit] NULL,
	[LongDesc] [varchar](300) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblPostQStatus](
	[PostQStatus] [int] NULL,
	[Description] [varchar](50) NULL,
	[QWType] [char](2) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblPostQs](
	[PostQID] [int] NULL,
	[PostID] [int] NOT NULL,
	[TypeID] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[Competent] [bit] NOT NULL,
	[QID] [int] NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblPostMilSkill](
	[postMSID] [int] NULL,
	[postID] [int] NOT NULL,
	[MSID] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[Competent] [bit] NOT NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblPost](
	[postID] [int] NULL,
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
	[Status] [bit] NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblPosition](
	[positionID] [int] NULL,
	[description] [varchar](50) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblPassword](
	[pwID] [int] NULL,
	[staffID] [int] NOT NULL,
	[staffpw] [varchar](100) NOT NULL,
	[pswd] [varchar](32) NULL,
	[dPswd] [varchar](32) NULL,
	[expires] [datetime] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblOpTeam](
	[optID] [int] NULL,
	[teamID] [int] NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblOpTaskCategory](
	[otcID] [int] NULL,
	[description] [varchar](50) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblOpTask](
	[optID] [int]   NULL,
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
	[documents] [varchar](200) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblOpEqpt](
	[opeID] [int] NULL,
	[eqptID] [int] NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblOpAction](
	[opaID] [int] NULL,
	[taskID] [int] NULL,
	[opadate] [datetime] NULL,
	[opaction] [varchar](50) NULL,
	[documents] [varchar](200) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblOOADays](
	[ooaID] [smallint] NULL,
	[ooamaxdays] [int] NULL,
	[amberdays] [int] NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblMSWeight](
	[mswID] [int] NULL,
	[mswtype] [char](1) NULL,
	[description] [varchar](50) NULL,
	[mswvalue] [smallint] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblMilitaryVacs](
	[mvID] [int] NULL,
	[description] [varchar](50) NULL,
	[mvvpID] [int] NULL,
	[mvrequired] [bit] NULL,
	[Combat] [bit] NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblMilitarySkills](
	[msID] [int] NULL,
	[description] [varchar](50) NULL,
	[msvpID] [int] NULL,
	[exempt] [int] NULL,
	[Combat] [bit] NULL,
	[Fear] [bit] NULL,
	[Amber] [int] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblMES](
	[mesID] [smallint] NULL,
	[description] [varchar](50) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblManager](
	[tmID] [int] NULL,
	[postID] [int] NOT NULL,
	[tmlevelID] [int] NOT NULL,
	[tmLevel] [int] NOT NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblHarmonyPeriod](
	[hpID] [smallint] NULL,
	[ooaperiod] [int] NULL,
	[ooared] [int] NULL,
	[ooaamber] [int] NULL,
	[ssaperiod] [int] NULL,
	[ssared] [int] NULL,
	[ssaamber] [int] NULL,
	[ssbperiod] [int] NULL,
	[ssbred] [int] NULL,
	[ssbamber] [int] NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblHarmonyOverride](
	[hmovID] [smallint] NULL,
	[description] [varchar](50) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblGuidePageDetails](
	[ID] [int] NULL,
	[guidePageID] [int] NOT NULL,
	[SectionHead] [int] NOT NULL,
	[title] [varchar](100) NOT NULL,
	[nextPage] [int] NOT NULL,
	[previousPage] [int] NOT NULL,
	[gifImage] [varchar](100) NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblGuidePageCoords](
	[ID] [int] NULL,
	[guidePageID] [int] NOT NULL,
	[XCoord] [int] NOT NULL,
	[YCoord] [int] NOT NULL,
	[height] [int] NULL,
	[width] [int] NULL,
	[Comments] [varchar](400) NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblGroup](
	[grpID] [int] NULL,
	[description] [varchar](50) NULL,
	[hqTasking] [bit] NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblGenericPW](
	[gpwID] [smallint] NULL,
	[genericPW] [varchar](100) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblFlight](
	[fltID] [int] NULL,
	[sqnID] [int] NULL,
	[description] [varchar](50) NULL,
	[cycleID] [int] NULL,
	[cycleStart] [datetime] NULL,
	[cycleEnd] [datetime] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblFitness](
	[FitnessID] [int] NULL,
	[Description] [nvarchar](50) NOT NULL,
	[FitnessVPID] [int] NOT NULL,
	[Combat] [bit] NULL,
	[Exempt] [int] NOT NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblEquipmentTemp](
	[EquipmentID] [int] NULL,
	[Description] [varchar](50) NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblDept](
	[deptID] [int] NULL,
	[name] [varchar](20) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblDental](
	[DentalID] [int] NULL,
	[Description] [varchar](50) NOT NULL,
	[DentalVPID] [int] NOT NULL,
	[Combat] [bit] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblDefaultPhoto](
	[defaultPhotoID] [int] NULL,
	[staffID] [int] NULL,
	[staffPhoto] [image] NULL,
	[photoPath] [varchar](200) NULL,
	[fileSize] [varchar](50) NULL,
	[contentType] [varchar](50) NULL
) TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblCycleSteps](
	[cytID] [int] NULL,
	[cytStep] [int] NULL,
	[cyID] [int] NULL,
	[cysID] [char](10) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblCycleStage](
	[cysID] [int] NULL,
	[description] [varchar](50) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblCycle](
	[cyID] [int] NULL,
	[description] [varchar](50) NULL,
	[cydays] [int] NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblContact](
	[ContactID] [int] NOT NULL,
	[EmailName] [varchar](30) NULL,
	[Email] [varchar](30) NULL,
	[MilPhone] [varchar](10) NULL,
	[Ext] [varchar](6) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblConfig](
	[configID] [int] NULL,
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
	[paq] [bit] NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblCondFormat](
	[cfID] [int]  NULL,
	[description] [varchar](50) NULL,
	[cfminval] [decimal](10, 2) NULL,
	[cfmaxval] [decimal](10, 2) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblCapabilityCategoryDetail](
	[CpCategoryDetalID] [int] NULL,
	[CpID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
	[DetailID] [int] NOT NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblCapabilityCategory](
	[CpCatID] [int] NULL,
	[ShortDesc] [varchar](50) NOT NULL,
	[Description] [varchar](50) NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tblCapability](
	[cpID] [int] NULL,
	[cptitle] [varchar](30) NULL,
	[description] [varchar](50) NULL,
	[cpteam] [varchar](50) NULL,
	[cpaerial] [varchar](50) NULL,
	[cpother] [varchar](50) NULL,
	[cp5sqn] [varchar](50) NULL,
	[cpgse] [varchar](50) NULL,
	[cpmgt] [varchar](50) NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tblAudit](
	[audID] [smallint] NULL,
	[staffID] [int] NULL,
	[logOn] [datetime] NULL,
	[logOff] [datetime] NULL
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tbl_TaskUnit](
	[taskunitID] [int] NULL,
	[taskID] [int] NOT NULL,
	[teamID] [int] NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NOT NULL,
	[taskNote] [varchar](2000) NULL,
	[cancellable] [bit] NOT NULL,
	[active] [int] NOT NULL,
	[dateStamp] [datetime] NOT NULL,
	[updatedBy] [int] NOT NULL,
	[pending] [bit] NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tbl_TaskStaff](
	[taskStaffID] [int] NULL,
	[taskID] [int] NOT NULL,
	[staffID] [int] NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NOT NULL,
	[taskNote] [varchar](2000) NULL,
	[cancellable] [bit] NOT NULL,
	[active] [int] NOT NULL,
	[dateStamp] [datetime] NOT NULL,
	[updatedBy] [int] NOT NULL,
	[pending] [bit] NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tbl_TaskCategory](
	[taskCategoryID] [int] NULL,
	[taskTypeID] [int] NOT NULL,
	[description] [varchar](200) NOT NULL
)
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [tbl_Task](
	[taskID] [int] NULL,
	 [taskTypeID] [int] NOT NULL,
	[description] [varchar](1000) NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NOT NULL,
	[Cancellable] [bit] NOT NULL,
	[hqtask] [bit] NOT NULL,
	[ooa] [smallint] NULL,
	[sscID] [int] NULL
)
GO
SET ANSI_PADDING OFF
GO
