
-- CMSMigrateKeyUpdates
-- THIRD script - BUT only run for second and subsequent migrations
-- This is VERY VERY important - it resets ALL the primary keys AND their related tables
-- so when migrated there are no Primary Key conflicts with existing data

USE [CMSMigrate]

-- First add field newRecID to ALL tables - this will be used
-- as temp new primary key and will be dropped before migration
-- ONLY THE VERY FIRST TIME
exec sp_MSforeachtable 'ALTER TABLE ? ADD newRecID INT '

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


DECLARE @oldID INT
DECLARE @newRecID INT
DECLARE @name VARCHAR(100)
DECLARE @tbls VARCHAR(2000)
DECLARE @tbl VARCHAR(50)
DECLARE @start INT
DECLARE @end INT
DECLARE @len INT
DECLARE @num INT
--DECLARE @str VARCHAR(50)

DECLARE @fldname VARCHAR(100)
DECLARE @flds VARCHAR(2000)
DECLARE @nextID INT
DECLARE @nexttable VARCHAR(100)
DECLARE @sql NVARCHAR(MAX)

DECLARE @table VARCHAR(2000)
DECLARE @table2 VARCHAR(2000)

-- These are all the tables that have related tables - there are others but they are not used in CMS2
SET @tbls='tbl_TaskStaff,tblCapability,tblDental,tblStatus,tblTasked,tblFitness,tblTaskType,tblTeam,tblGroup,tblTrade,tblTradeGroup,tblValPeriod,tblMES,tblWing,tblMilitarySkills,'
SET @tbls=@tbls + 'tblMilitaryVacs,tblOrganisation,tblPost,tblQs,tblQTypes,tblRank,tblRankWeight,tblSquadron,tblSSC,tblStaff,tbl_Task,tbl_taskCategory'

-- these tables are releated to tabltasktype - but their key is ttID and NOT ttID
--SET @table2='tbl_task, tbl_taskCategory'

-- This will get the current highest primary key for each table in the TARGET database ( CMS2 )
-- and increment it by 100. This figure will then be stored in the newRecID field of the relevant table
-- which was added in the CMSMigrateDBUpdate script

DECLARE tbl1 CURSOR SCROLL
 FOR SELECT  t.name FROM sys.tables t 
		     
OPEN tbl1
FETCH FIRST FROM tbl1 INTO @table

WHILE @@FETCH_STATUS = 0
  BEGIN
    -- Check if the table exists in the new CMS2 database - cos we have removed some redundant ones
    IF EXISTS (SELECT * FROM CMS2.INFORMATION_SCHEMA.TABLES   
      WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = @table)
      BEGIN
	    -- now get the primary field name for the current table
	    -- Now go through all RELATED tables to the CURRENT table ( @tbl)
		-- we know they are related cos they have a field whose name is the same as the CURRENT @fldname
		DECLARE pr1 CURSOR SCROLL
		 FOR
		   SELECT  c.name 
             FROM sys.columns c
                INNER JOIN sys.tables t ON c.object_id = t.object_id
                  WHERE t.name = @table
		   OPEN pr1
		   FETCH FIRST FROM pr1 INTO  @fldname

			 -- Now get the LAST recid from the TARGET database (CMS2) for the current table
			 SET @sql= N' SELECT TOP 1 @oldID = ' + @fldname + N' FROM CMS2.dbo.' +  @table  + N' ORDER BY ' + @fldname + N' DESC'
			 EXEC sp_executesql @sql, N'@oldID INT OUT ', @oldID out
		 
			 -- Now increment @oldID by 100 - this will be ADDED to the existing PRIMARY keys in the current table
			 -- in the MIGRATION database (CMSMigrate). This will make them UNIQUE when they are imported into the
			 -- TARGET database (CMS2)
			 SET @oldID = @oldID + 100

		     -- Now go through all the RECORDS in this table ( @table)
		     -- and set the value of @newRecID to the primary key( @fldname ) + CMS2 recid value ( @oldID)
		     SET @sql=N'UPDATE ' + @table + N' SET [newRecID] = ' + @fldname + N' + @oldID' 
		     EXEC sp_executesql @sql, N'@oldID INT  ', @oldID 
		     --SELECT @sql
		     --SELECT @oldID, @fldname, @table
		
		 CLOSE pr1
		 DEALLOCATE pr1
	   END
	FETCH NEXT FROM tbl1 INTO  @table
  END
CLOSE tbl1
DEALLOCATE tbl1

-- Now have in ALL the tables a populated field newRecID and this will be the NEW primary and
-- is to be used to update all related tables eg: tblStaff - staffID=50 newRecID=2966
-- so all related tables - tblStaffPost, tblStaffQs etc whose staffID = 50 will be changed to staffID=2966
-- then tblStaff.staffID=50 will be changed to 2966 - So we still have all the relationships AND they will
-- be unique when migrated to CMS2

SET @len = (SELECT LEN(@tbls))
SET @start=1

SET @num = 0

-- here we are going through the related table list in @tbls
WHILE @num < @len
 BEGIN
   SET @num = (SELECT CHARINDEX(',', @tbls, @start))
   
   -- This gets the next table name eg: tblStaff
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
 
   
    BEGIN
		SET @flds=''

		-- now get the FIRST field in each table 
		-- this will ALWAYS be the PRIMARY KEY and thats the one we want 
		DECLARE fld1 CURSOR SCROLL
			 FOR SELECT column_name from information_schema.columns where table_name = @tbl
		     
		OPEN fld1
		FETCH FIRST FROM fld1 INTO @fldname

		    -- Now go through the current table ( @tbl) and update the related tables
			-- for each RECORD in the current table
			SET @sql=N'DECLARE rec1 CURSOR SCROLL FOR SELECT [newRecID],'+ @fldname  + N' FROM ' + @tbl
            EXEC sp_executesql @sql
            
           -- SELECT @sql,@fldname, @tbl
             
			OPEN rec1
		    FETCH NEXT FROM rec1 INTO @newRecID, @oldID

		    WHILE @@FETCH_STATUS = 0
		      BEGIN
				-- Now go through all RELATED tables to the CURRENT table ( @tbl)
				-- we know they are related cos they have a field whose name is the same as the CURRENT @fldname
				DECLARE nextrecid CURSOR SCROLL
				 FOR
				   SELECT  t.name 
					 FROM sys.columns c
						INNER JOIN sys.tables t ON c.object_id = t.object_id
						  WHERE c.name =@fldname AND t.name <> @tbl
				   OPEN nextrecid
				   FETCH FIRST FROM nextrecid INTO  @nexttable

				   -- Now go through all the RECORDS in this table ( @nexttable)
				   -- and UPDATE the value of the related fields ( @fldname ) with the table.newRecID newRecID value
				   WHILE @@FETCH_STATUS = 0
				   BEGIN
					 SET @sql=N'UPDATE ' + @nexttable + N' SET ' + @fldname + N' = @newRecID WHERE '+ @fldname + N' =  @oldID'
					 EXEC sp_executesql @sql,N'@newRecID INT, @oldID INT  ',@newRecID, @oldID 
					 -- SELECT @nexttable ,@fldname, @newRecID, @oldID 
					 FETCH NEXT FROM nextrecid INTO  @nexttable
					END

				 CLOSE nextrecid
				 DEALLOCATE nextrecid

		        FETCH NEXT FROM rec1 INTO @newRecID, @oldID
		      END
		    CLOSE rec1
		    DEALLOCATE rec1

		CLOSE fld1
		DEALLOCATE fld1
		 
    END
 END

 -- Now we MUST update tblTeam.parentID otherwise when we try to build the Hierarchy it will fail
 -- we MUST do this before we update the Primary Keys with the newrecID value
 -- and we must do it for Groups/Wings/Sqdns/Flights and Teams
 UPDATE tblTeam
    SET tblTeam.parentID = (SELECT newrecID FROM tblGroup  WHERE tblGroup.grpID = tblTeam.parentID)
	  WHERE tblTeam.teamIN=0
 UPDATE tblTeam
    SET tblTeam.parentID = (SELECT newrecID FROM tblWing  WHERE tblWing.wingID = tblTeam.parentID)
	  WHERE tblTeam.teamIN=1

UPDATE tblTeam
    SET tblTeam.parentID = (SELECT newrecID FROM tblSquadron WHERE tblSquadron.sqnID = tblTeam.parentID)
	WHERE tblTeam.teamIN=2

UPDATE tblTeam
    SET tblTeam.parentID = (SELECT newrecID FROM tblFlight WHERE tblFlight.fltID = tblTeam.parentID)
	WHERE tblTeam.teamIN=3

UPDATE tblTeam
    SET tblTeam.parentID = (SELECT newrecID FROM tblTeam AS t1 WHERE t1.teamID = tblTeam.parentID)
	WHERE tblTeam.teamIN=4

UPDATE tblTeam
    SET tblTeam.parentID = (SELECT newrecID FROM tblTeam AS t1 WHERE t1.teamID = tblTeam.parentID)
	WHERE tblTeam.teamIN=5



 -- Now go through every table and reset the primary key to the value of the newrecID
DECLARE tbl1 CURSOR SCROLL
 FOR SELECT  t.name FROM sys.tables t 
		     
OPEN tbl1
FETCH FIRST FROM tbl1 INTO @table

WHILE @@FETCH_STATUS = 0
  BEGIN
	-- now get the primary field name for the current table
	-- Now go through all RELATED tables to the CURRENT table ( @tbl)
		-- we know they are related cos they have a field whose name is the same as the CURRENT @fldname
		DECLARE pr1 CURSOR SCROLL
		 FOR
		   SELECT  c.name 
             FROM sys.columns c
                INNER JOIN sys.tables t ON c.object_id = t.object_id
                  WHERE t.name = @table
		   OPEN pr1
		   FETCH FIRST FROM pr1 INTO  @fldname
		     SET @sql=N'UPDATE ' + @table + N' SET ' + @fldname + N' = newRecID '
			 EXEC sp_executesql @sql
		 CLOSE pr1
		 DEALLOCATE pr1

	FETCH NEXT FROM tbl1 INTO  @table
  END
CLOSE tbl1
DEALLOCATE tbl1

GO

-- now drop the column newrecID
exec sp_MSforeachtable 'ALTER TABLE ? DROP COLUMN newRecID '
GO

-- If we get to here with no errors we should be OK to migraTE THE DATA !!!!!
