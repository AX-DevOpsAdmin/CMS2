

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


set @fldname='taskStaffid'
set @tbl='tbl_TaskStaff'

--DECLARE fld1 CURSOR FOR SELECT [newID],staffID FROM tblStaff
 SET @sql=N'DECLARE fld1 CURSOR SCROLL FOR SELECT newRecID,'+ @fldname  + N' FROM ' + @tbl
        EXEC sp_executesql @sql
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @newRecID, @oldID
		SELECT @newRecID, @oldID

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
				     --SELECT @newRecID,@oldID
					 SET @sql=N'UPDATE ' + @nexttable + N' SET ' + @fldname + N' = @newRecID WHERE '+ @fldname + N' =  @oldID'
					 EXEC sp_executesql @sql,N'@newRecID INT, @oldID INT  ',@newRecID, @oldID 
					 -- SELECT @sql
					-- IF @nexttable ='tblTaskClash' AND @newRecID=0
					   

					 FETCH NEXT FROM nextrecid INTO  @nexttable
					END

				 CLOSE nextrecid
				 DEALLOCATE nextrecid
		     --SELECT @sql
			 --SELECT @newID, @oldID
			 FETCH NEXT FROM fld1 INTO @newRecID, @oldID
		    END
		CLOSE fld1
		DEALLOCATE fld1
		SELECT @newRecID, @oldID


		--select [newID], staffID from tblStaff