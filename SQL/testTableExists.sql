


DECLARE @table VARCHAR(100)

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
	     PRINT ' Exists'
	  END
	  ELSE
	     PRINT @table + ' Does not Exist'
	FETCH NEXT FROM tbl1 INTO  @table
  END
CLOSE tbl1
DEALLOCATE tbl1