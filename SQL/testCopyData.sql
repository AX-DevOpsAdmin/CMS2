/***
USE CMS2
GO
-- first make sure all tables are empty in TARGET Dbase
EXEC sp_MSforeachtable 'TRUNCATE TABLE ?'
**/

-- Now switch to SOURCE Dbase - this is the one being MIGRATED
USE CMSMigrate
GO

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

set @tbls=''
DECLARE tbl1 CURSOR SCROLL
    FOR SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
     
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

SET @len = (SELECT LEN(@tbls))
SET @start=1

-- tbl_TaskUnit,tblAudit,tblCapability,tblCapabilityCategory,tblCapabilityCategoryDetail,tblCondFormat,tblConfig,tblContact,tblCycle,tblCycleStage,tblCycleSteps,
-- tblDefaultPhoto,tblDental,tblDept,tblEquipmentTemp,tblFitness,tblFlight,tblGenericPW,tblGroup,tblHierarchy,tblGuidePageCoords,tblGuidePageDetails,tblHarmonyOverride,
-- tblHarmonyPeriod,tblManager,tblMES,tblMilitarySkills,tblMilitaryVacs,tblMSWeight,tblOOADays,tblOpAction,tblOpEqpt,tblOpTask,tblOpTaskCategory,tblOpTeam,tblPassword,
-- tblPosition,tblPost,tblPostMilSkill,tblPostQs,tblPostQStatus,tblQs,tblQTypes,tblQWeight,tblRank,tblRankWeight,tblReports,tblSquadron,tblSSC,tblStaff,tblStaffDental,
-- tblStaffFitness,tblStaffHarmony,tblStaffMilSkill,tblStaffMVs,tblStaffPhoto,tblStaffPost,tblStaffQs,tblStatus,tblTask,tblTaskClash,tblTasked,tblTaskNotes,tblTaskPending,
-- tblTaskStatus,tblTaskType,tblTeam,tblTeamHierarchy,tblTempHierarchy,tblTrade,tblTradeGroup,tblTrainingCourse,tblUnitHarmonyTarget,tblValPeriod,tblWing,
-- tempQsRequiredByPost,tbl_Task,tbl_TaskCategory,tbl_TaskStaff

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
        --SELECT @tbl
		SET @flds = SUBSTRING(@flds, 2, LEN(@flds))

		--select @flds

		SET @sql = 'SET IDENTITY_INSERT CMS2.dbo.' + @tbl + ' ON'
		SET @sql = @sql + ' INSERT INTO CMS2.dbo.' + @tbl 
		SET @sql = @sql + '(' + @flds + ')'
		SET @sql = @sql + 'SELECT ' + @flds + ' FROM ' + @tbl 
		SET @sql = @sql + ' SET IDENTITY_INSERT CMS2.dbo.' + @tbl + ' OFF'

		--SELECT @sql

		EXEC(@sql)
    END
 END
 