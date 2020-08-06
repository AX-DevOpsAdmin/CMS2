

-- CMS2CopyData
-- Migrates the current data from CMSMigrate dBase to the live CMS2 dBase

-- NB: ONLY ON THE VERY FIRST MIGRATE - NOT FOR SUBSEQUENT ONES
/*
USE CMS2
GO

-- Run each of the following lines  to make sure all tblValPer and tblTaskType relationships are correctly named
-- otherwise they will NOT be picked up in the relational table run in the main code
 EXEC sp_rename 'tblMilitarySkills.msvpID', 'vpID', 'COLUMN';
 GO
 EXEC sp_rename 'tblMilitaryVacs.mvvpID', 'vpID', 'COLUMN';
 GO
 EXEC sp_rename 'tblFitness.FitnessvpID', 'vpID', 'COLUMN';
 GO
 EXEC sp_rename 'tblDental.dentalvpID', 'vpID', 'COLUMN';
 GO
 EXEC sp_rename 'tbl_task.taskTypeID', 'ttID', 'COLUMN';
 GO
 EXEC sp_rename 'tbl_taskCategory.taskTypeID', 'ttID', 'COLUMN';
 GO

-- first make sure all tables are empty in TARGET Dbase
 EXEC sp_MSforeachtable 'TRUNCATE TABLE ?'
*/
-- Now switch to SOURCE Dbase - this is the one being MIGRATED
USE CMSMigrate
GO

/**
-- check if ddbna12/ddbna24 fields are in tblStaff and drop them if they are
ALTER TABLE tblStaff
  DROP COLUMN ddbna12
ALTER TABLE tblStaff
  DROP COLUMN ddbna24
**/

-- ADD CMSAdministrator

--ALTER TABLE tblStaff
 -- ADD CMSAdministrator BIT
      
--UPDATE tblStaff 
 --  SET CMSAdministrator = 0
 -- GO
   
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
     -- Check if the table exists in the new CMS2 database - cos we have removed some redundant ones
    IF EXISTS (SELECT * FROM CMS2.INFORMATION_SCHEMA.TABLES   
      WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = @name)
      BEGIN
        --SET @tbls= @tbls + ',' + @name
        SET @tbls= @tbls  + @name + ','
	  END
	 FETCH NEXT FROM tbl1 INTO @name
 END

CLOSE tbl1
DEALLOCATE tbl1

--SET @tbls = SUBSTRING(@tbls, 2, LEN(@tbls))
--SELECT @tbls

SET @len = (SELECT LEN(@tbls))
SET @start=1

SET @num = 0
WHILE @num < @len
 BEGIN
   SET @num = (SELECT CHARINDEX(',', @tbls, @start))
   IF @num =0
    BEGIN
       SET @num = @len + 1
       SET @tbl = SUBSTRING(@tbls, @start, @end ) 
    END
   ELSE
    BEGIN
      SET @end = @num - @start
      SET @tbl = SUBSTRING(@tbls, @start, @end) 
      --SELECT @tbl,@start,@end, @len,@num
       SET @start= @num+1
    END
    
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
			 SET @flds= @flds + ',' + @fldname
			 FETCH NEXT FROM fld1 INTO @fldname
			 SET @fldname = '['+@fldname +']'
		 END

		CLOSE fld1
		DEALLOCATE fld1
		SET @flds = SUBSTRING(@flds, 2, LEN(@flds))
        
		--select @flds
		IF @tbl='tblContact' OR @tbl='tblTeamHierarchy' OR @tbl='tblTempHierarchy'
          BEGIN
          	--SET @sql = 'SET IDENTITY_INSERT CMSMigrate.dbo.' + @tbl + ' ON'
			SET @sql = ' INSERT INTO CMS2.dbo.' + @tbl 
			SET @sql = @sql + '(' + @flds + ')'
			SET @sql = @sql + 'SELECT ' + @flds + ' FROM ' + @tbl 
			--SET @sql = @sql + ' SET IDENTITY_INSERT CMSMigrate.dbo.' + @tbl + ' OFF'
          END
          ELSE
          BEGIN
			SET @sql = 'SET IDENTITY_INSERT CMS2.dbo.' + @tbl + ' ON'
			SET @sql = @sql + ' INSERT INTO CMS2.dbo.' + @tbl 
			SET @sql = @sql + '(' + @flds + ')'
			SET @sql = @sql + 'SELECT ' + @flds + ' FROM ' + @tbl 
			SET @sql = @sql + ' SET IDENTITY_INSERT CMS2.dbo.' + @tbl + ' OFF'
		  END
        
		   --SELECT @sql
		
        --SELECT @tbls, @tbl
		EXEC(@sql)
    END
 END
 
 
 