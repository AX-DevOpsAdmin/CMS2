
/* go through database and find all tables with related column */

USE [CMSMigrate]

/**
This updates all the Primary Keys and Related keys in CMSMigrate to ensure they are unique
when the data is migrated to the TARGET database (CMS2)
**/
DECLARE @oldID INT
DECLARE @newID INT
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

		   IF EXISTS ( SELECT c.name 
		                FROM sys.columns c
                           INNER JOIN sys.tables t ON c.object_id = t.object_id
                          WHERE c.name =@fldname AND t.name <> @table)
              BEGIN
			        IF @sql IS NULL
					  SET @sql=@table + ','
					ELSE
					  SET @sql=@sql + @table + ','
			  END

		
		 CLOSE pr1
		 DEALLOCATE pr1

	FETCH NEXT FROM tbl1 INTO  @table
  END
CLOSE tbl1
DEALLOCATE tbl1

SELECT LEN(@sql)
SELECT @sql
/**
-- Staff
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='staffID'
      
-- Team
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='teamID'
  
-- Post
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='postID'
          
-- Task
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='taskID'

-- Q Types     
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='QTypeID'
      
-- Q's     
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='QID'
      
-- Military Skills     
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='msID'
 
-- Military Vaccinations     
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='mvID'
           
-- Fitness    
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='fitnessID'
      
-- Dental    
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='dentalID'

-- TaskType    
--NB  tbl_task and tbl_taskCategory related fields are called ttID 
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='ttID'
       
-- Task    SEE taskType ABOVE  
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='taskID'
 

 -- Task Category  SEE taskType ABOVE 
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='ttID'
  

 -- Status
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='statusID'
      
 -- Trade Group
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='tradeGroupID'
 
-- Trade 
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='tradeID'
      
-- Validity Period 
SELECT c.name AS colName, t.name AS tableName
  FROM sys.columns c
    INNER JOIN sys.tables t ON c.object_id = t.object_id
      WHERE c.name ='vpID'     
       
 */
  
 -- Redundant Tables  -  these can be deleted BUT - keep them for now
 -- Also check out tblTask, tblTasked, tblTaskNotes, tblTaskPending, tblTaskType
 -- as these are original CMS tables but were superceded by tbl_Task  tables
 /**
 TRUNCATE TABLE tblCapabilityCategoryDetail
 DROP TABLE tblCapabilityCategoryDetail
 GO
 TRUNCATE TABLE tblCapabilityCategory
 DROP TABLE tblCapabilityCategory
 GO
 TRUNCATE TABLE tblCapability
 DROP TABLE tblCapability
 GO
 
 TRUNCATE TABLE tblCycleSteps
 DROP TABLE tblCycleSteps
 GO
 TRUNCATE TABLE tblCycleStage
 DROP TABLE tblCycleStage
 GO
 TRUNCATE TABLE tblCycle
 DROP TABLE tblCycle
 GO
 
 TRUNCATE TABLE tblEquipmentTemp
 DROP TABLE tblEquipmentTemp
 GO
 
 TRUNCATE TABLE tblOpTaskCategory
 DROP TABLE tblOpTaskCategory
 GO
 
 TRUNCATE TABLE tblOpTask
 DROP TABLE tblOpTask
 GO
 TRUNCATE TABLE tblOpAction
 DROP TABLE tblOpAction
 GO
 TRUNCATE TABLE tblOpEqpt
 DROP TABLE tblOpEqpt
 GO
 TRUNCATE TABLE tblOpTeam
 DROP TABLE tblOpTeam
 GO
 
 TRUNCATE TABLE tblPosition
 DROP TABLE tblPosition
 GO
 **/