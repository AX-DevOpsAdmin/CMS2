
DECLARE @nodeID INT
DECLARE @recID INT
DECLARE @childID INT
DECLARE @hrcID INT
DECLARE @parentID INT
DECLARE @level INT
DECLARE @name VARCHAR(100)
DECLARE @path VARCHAR(255)

/**
DECLARE @chID INT
DECLARE @chprnt INT
DECLARE @chlevel INT
DECLARE @chname VARCHAR(100)
**/

--DECLARE @ttorder INT
DECLARE @error INT
DECLARE @lastlevel INT
DECLARE @children BIT
DECLARE @open BIT

SET @nodeID=1
SET @recID=597

; WITH tblChild AS
		(
		   SELECT T1.hrcID, T1.hrcName, T1.hrcparentID, T1.hrclevel, T1.hrcchildren, CAST(T1.hrcID AS VARCHAR(255)) AS hrcPath -- , 0 AS depth
		     FROM tblHierarchy T1 WHERE T1.hrcparentID = 0 AND T1.ndeID=@nodeID
		  UNION ALL
		   SELECT T2.hrcID, T2.hrcName,T2.hrcparentID, T2.hrclevel, T2.hrcchildren, CAST(hrcPath + '.' + CAST(T2.hrcID AS VARCHAR(255)) AS VARCHAR(255))    --  depth + 1
		     FROM tblHierarchy T2
		        INNER JOIN tblChild ON T2.hrcparentID=tblChild.hrcID
		  )
		  --SELECT *  FROM tblChild ORDER BY hrcPath
		  SELECT * INTO #ttTemp FROM tblChild ORDER BY hrcPath
		  
CREATE TABLE #ttopen(
    ttopenID INT
)

CREATE TABLE #tthrc(
   tthrcID INT,
   ttparentID INT,
   ttlevel INT,
   ttlastlevel INT,
   ttname VARCHAR (100),
   ttchildren BIT,
   ttpath VARCHAR(255),
   ttopen BIT
)
  

SET @childID=@recID  
SET @parentID= (SELECT hrcparentID FROM tblHierarchy WHERE hrcID=@recid) 
SET @error = 1    -- make sure we don't try and do stuff if there is no records   

-- SET @level = (SELECT hrclevel FROM tblhierarchy WHERE hrcID = @childID)

--SET @ttorder=1
SET @open=0

-- first we get all the elements on the same level as the one we need ( @recid) 
-- cos if we don't then the web page does not display properly
SET @lastlevel = (SELECT hrclevel FROM tblhierarchy WHERE hrcID = @recid)

DECLARE hrc1 CURSOR SCROLL
FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren FROM tblhierarchy WHERE hrcparentID = @parentID
OPEN hrc1
FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children

WHILE @@FETCH_STATUS = 0
 BEGIN
  INSERT INTO #ttopen
	 	SELECT @hrcID	         
  SET @error = @@ERROR
  
  FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children
  
 END

CLOSE hrc1
DEALLOCATE hrc1

SELECT * FROM #ttopen
-- now we go up one level	
SET @level = (SELECT hrclevel FROM tblhierarchy WHERE hrcID = @recid) - 1 
SET @childID=@parentID
-- Now we work our way up to the top of the hierarchy
-- but make sure we include all other branches of this part of the tree
WHILE @level >=0        -- @error will be based on the hierarchy level
	  BEGIN             -- we are going from bottom to top of selected Child branch
	     
		 DECLARE hrc1 CURSOR SCROLL
		 FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren FROM tblhierarchy WHERE hrcID = @childID
	     
		 OPEN hrc1
		 FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children


		 IF @@FETCH_STATUS = 0
		  BEGIN
		    --SET @lastlevel = @level   -- so we now how deep the levels go
		    -- update the last child entry
			--  INSERT INTO #tthrc
			--	 SELECT 0, @hrcID, @parentID,@level, @name, @children, @open
			  INSERT INTO #ttopen
				 	SELECT @hrcID	         
			  SET @error = @@ERROR
		  END
		 
		 CLOSE hrc1
		 DEALLOCATE hrc1

		SET @error = 1   -- make sure we don't try and do stuff if there is no records   
		-- now move evrything up a level
		SET @childID=@parentID
		SET @level = @level - 1		
  END

  DECLARE hrc1 CURSOR SCROLL
         FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren, hrcPath FROM #ttTemp 
     
		OPEN hrc1
		FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children, @path
				
		WHILE @@FETCH_STATUS = 0
		 BEGIN
		   -- update the last child entry
		   IF EXISTS (SELECT #ttopen.ttopenID FROM #ttopen WHERE #ttopen.ttopenID = @hrcID)
		     SET @open = 1
		   ELSE
		     SET @open=0
			  
		    INSERT INTO #tthrc
				 SELECT @hrcID, @parentID,@level,@lastlevel, @name, @children, @path, @open
			  FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children, @path			  
		 END
CLOSE hrc1
DEALLOCATE hrc1

  SELECT tthrcID AS hrcID,ttparentID AS hrcParentID, ttlevel AS hrcLevel,ttlastlevel AS lastLevel,
         ttname AS hrcName, ttchildren AS hrcChildren, ttopen AS hrcOpen
         FROM #tthrc ORDER BY #tthrc.ttpath
         
  DROP TABLE #tthrc 
  DROP TABLE #ttTemp
  DROP TABLE #ttopen  
