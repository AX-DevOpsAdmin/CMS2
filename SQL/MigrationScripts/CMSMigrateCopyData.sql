
-- CMSMigrateCopyData
-- SECOND script to run
-- Migrates data from TARGET data base into CMSMigrate
-- where we can prepare it for migration to CMS2 live dbase

USE CMSMigrate
GO
-- first make sure all tables are empty in TARGET Dbase
EXEC sp_MSforeachtable 'TRUNCATE TABLE ?'

-- Now switch to SOURCE Dbase - this is the one being MIGRATED
-- MAKE SURE THE USE DB BELOW IS SET TO THE CORRECT CMS SOURCE
-- IE: THE ONE BEING MIGRATED FROM

USE [CMS]

DECLARE @name VARCHAR(100)
DECLARE @tbls VARCHAR(2000)
DECLARE @tbl VARCHAR(50)
DECLARE @start INT
DECLARE @end INT
DECLARE @len INT
DECLARE @num INT
DECLARE @str VARCHAR(50)

DECLARE @fldname VARCHAR(100)
DECLARE @flds VARCHAR(2000)

DECLARE @sql VARCHAR(2000)
DECLARE @sql1 VARCHAR(2000)


set @tbls=''
/**
DECLARE tbl1 CURSOR SCROLL
    FOR SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'
     
OPEN tbl1
FETCH NEXT FROM tbl1 INTO @name

WHILE @@FETCH_STATUS = 0
 BEGIN
 --select @name
     SET @tbls= @tbls + ',' + @name
	 FETCH NEXT FROM tbl1 INTO @name
 END

CLOSE tbl1
DEALLOCATE tbl1

SET @tbls = SUBSTRING(@tbls, 2, LEN(@tbls))
--SELECT @tbls
**/
--Don't take tblConfig or tblDept
--SET @tbls='tbl_TaskUnit,tblAudit,tblCapability,tblCapabilityCategory,tblCapabilityCategoryDetail,tblCondFormat,tblContact,tblConfig,tblCycle,tblCycleStage,tblCycleSteps,tblDept,'
SET @tbls='tbl_TaskUnit,tblAudit,tblCapability,tblCapabilityCategory,tblCapabilityCategoryDetail,tblCondFormat,tblContact,tblConfig,tblCycle,tblCycleStage,tblCycleSteps,'
SET @tbls = @tbls + 'tblDefaultPhoto,tblDental,tblEquipmentTemp,tblFitness,tblFlight,tblGenericPW,tblGroup,tblHarmonyOverride,'
SET @tbls = @tbls + 'tblHarmonyPeriod,tblManager,tblMES,tblMilitarySkills,tblMilitaryVacs,tblMSWeight,tblOOADays,tblOpAction,tblOpEqpt,tblOpTask,tblOpTaskCategory,tblOpTeam,tblPassword,'
SET @tbls = @tbls + 'tblPosition,tblPost,tblPostMilSkill,tblPostQs,tblPostQStatus,tblQs,tblQTypes,tblQWeight,tblRank,tblRankWeight,tblReports,tblSquadron,tblSSC,tblStaff,tblStaffDental,'
SET @tbls = @tbls + 'tblStaffFitness,tblStaffHarmony,tblStaffMilSkill,tblStaffMVs,tblStaffPhoto,tblStaffPost,tblStaffQs,tblStatus,tblTaskClash,tblTasked,tblTaskNotes,tblTaskPending,'
SET @tbls = @tbls + 'tblTaskStatus,tblTaskType,tblTeam,tblTrade,tblTradeGroup,tblTeamHierarchy,tblTrainingCourse,tblUnitHarmonyTarget,tblValPeriod,tblWing,'
SET @tbls = @tbls + 'tbl_Task,tbl_TaskCategory,tbl_TaskStaff'

SET @len = (SELECT LEN(@tbls))
SET @start=1

SET @num = 0
WHILE @num < @len
 BEGIN
   SET @num = (SELECT CHARINDEX(',', @tbls, @start))
   
   --SELECT @num
   IF @num =0
    BEGIN
       SET @num = @len + 1
       SET @tbl = SUBSTRING(@tbls, @start, @end ) 
    END
   ELSE
    BEGIN
      SET @end = @num - @start
      SET @tbl = SUBSTRING(@tbls, @start, @end) 
       SET @start= @num+1
    END
 
    --SELECT @str, @num, @len
    BEGIN
		SET @flds=''
		DECLARE fld1 CURSOR SCROLL
			 --FOR SELECT column_name from information_schema.columns where table_name = 'tbl_TaskStaff'
			 FOR SELECT column_name from information_schema.columns where table_name = @tbl
		     
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @fldname
        SET @fldname = '['+@fldname +']'
		WHILE @@FETCH_STATUS = 0
		 BEGIN
		 --select @name
			 SET @flds= @flds + ',' + @fldname
			 FETCH NEXT FROM fld1 INTO @fldname
			 SET @fldname = '['+@fldname +']'
		 END

		CLOSE fld1
		DEALLOCATE fld1
		
		SET @flds = SUBSTRING(@flds, 2, LEN(@flds))

		--select @flds
        IF @tbl='tblContact' OR @tbl='tblTeamHierarchy'
          BEGIN
          	--SET @sql = 'SET IDENTITY_INSERT CMSMigrate.dbo.' + @tbl + ' ON'
			SET @sql = ' INSERT INTO CMSMigrate.dbo.' + @tbl 
			SET @sql = @sql + '(' + @flds + ')'
			SET @sql = @sql + 'SELECT ' + @flds + ' FROM ' + @tbl 
			--SET @sql = @sql + ' SET IDENTITY_INSERT CMSMigrate.dbo.' + @tbl + ' OFF'
          END
          ELSE
          BEGIN
			--SET @sql = 'SET IDENTITY_INSERT CMSMigrate.dbo.' + @tbl + ' ON'
			SET @sql = ' INSERT INTO CMSMigrate.dbo.' + @tbl 
			SET @sql = @sql + '(' + @flds + ')'
			SET @sql = @sql + 'SELECT ' + @flds + ' FROM ' + @tbl 
			--SET @sql = @sql + ' SET IDENTITY_INSERT CMSMigrate.dbo.' + @tbl + ' OFF'
		  END
		  --SELECT @sql

		  EXEC(@sql)

		 --SET @sql1='SELECT ' +  @tbl + ', ' + ' COUNT(*)' +  @tbl
		 -- EXEC(@sql1)
    END
 END
 