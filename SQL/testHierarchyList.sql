
DECLARE @recID INT
DECLARE @childID INT
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

SET @hrcID = 20

-- This will create a temp table for the Hierarchy BUT
-- it will not be in the Hierarchical order ( Parent/child tree )we want
WITH tblChild AS
		(
		   SELECT T1.hrcID, T1.hrcName, T1.hrcparentID, T1.hrclevel, T1.hrcchildren, 0 AS depth
		     FROM tblHierarchy T1 WHERE hrcID=@hrcID
		  UNION ALL
		   SELECT T2.hrcID, T2.hrcName,T2.hrcparentID, T2.hrclevel, T2.hrcchildren, depth + 1
		     FROM tblHierarchy T2
		        JOIN tblChild ON T2.hrcparentID=tblChild.hrcID
		        
		)
     SELECT hrcID, hrcname, hrcparentID, hrclevel, hrcchildren, depth INTO #ttTemp FROM tblChild 
     
     SELECT * FROM #ttTemp
   
   -- This will be populated from the #temp table BUT
   -- it WILL be built in the order we want so we can then return it
   -- to the web page  
   CREATE TABLE #tthrc(
   tthrcID INT,
   ttparentID INT,
   ttlevel INT,
   ttname VARCHAR (100),
   ttchildren BIT,
   ttopen BIT
)


      DECLARE hrc1 CURSOR SCROLL
		 FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren FROM #ttTemp
	     
		 OPEN hrc1
		 
		 FETCH FIRST FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children
		 IF @@FETCH_STATUS = 0
		  BEGIN
		     INSERT INTO #tthrc
				   SELECT @hrcID, @parentID,@level, @name, @children, 0
				   
		     FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children


		     WHILE @@FETCH_STATUS = 0
		      BEGIN
		         INSERT INTO #tthrc
				   SELECT @hrcID, @parentID,@level, @name, @children, 0
				 
			     FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children
		      END
		  END
		  
		 CLOSE hrc1
		 DEALLOCATE hrc1

 --SELECT * FROM #tthrc
 
 DROP TABLE #ttTemp
 DROP TABLE #tthrc