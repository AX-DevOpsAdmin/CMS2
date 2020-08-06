
DECLARE @sql NVARCHAR(2000)
DECLARE @table NVARCHAR(100)

DECLARE tbl1 CURSOR SCROLL
 FOR SELECT  t.name FROM sys.tables t 
		     
OPEN tbl1
FETCH FIRST FROM tbl1 INTO @table

WHILE @@FETCH_STATUS = 0
  BEGIN
	-- now get the primary field name for the current table
	-- Now go through all RELATED tables to the CURRENT table ( @tbl)
		-- we know they are related cos they have a field whose name is the same as the CURRENT @fldname
		
		     SET @sql=N'UPDATE ' + @table + N' SET ndeID=2' 
			 EXEC sp_executesql @sql
		     --SELECT @sql
	FETCH NEXT FROM tbl1 INTO  @table
  END
CLOSE tbl1
DEALLOCATE tbl1