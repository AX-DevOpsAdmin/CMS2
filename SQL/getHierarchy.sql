
DECLARE @teamID INT

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


CREATE TABLE #tthrc(
   ttOrder INT,
   tthrcID INT,
   ttparentID INT,
   ttlevel INT,
   ttname VARCHAR (100),
   ttchildren BIT,
   ttopen BIT
)

SET @teamID = 353   -- IMX Dev
     
SET @error = 1    -- make sure we don't try and do stuff if there is no records   

SET @childID=(SELECT hrcID FROM tblHierarchy WHERE teamID=@teamID)
/**
DECLARE hrc1 CURSOR SCROLL
     FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren FROM tblhierarchy WHERE hrcID = @childID
     
OPEN hrc1
FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children


IF @@FETCH_STATUS = 0
 BEGIN
   SET @lastlevel = @level   -- so we now how deep the levels go
   -- update the last child entry
      INSERT INTO #tthrc
         SELECT 0, @hrcID, @parentID,@level, @name, @children
         
      SET @error = @@ERROR
 END
 
CLOSE hrc1
DEALLOCATE hrc1

**/

SET @level = (SELECT hrclevel FROM tblhierarchy WHERE hrcID = @childID)

SET @ttorder=1
SET @open=0
-- Now we work our way up to the top of the hierarchy
-- but make sure we include all other branches of this part of the tree
-- 
--WHILE @error = 0
WHILE @level >=0    -- @error will be based on the hierarchy level
	  BEGIN             -- we are going from bottom to top of selected Child branch
	     
		 DECLARE hrc1 CURSOR SCROLL
		 FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren FROM tblhierarchy WHERE hrcID = @childID
	     
		 OPEN hrc1
		 FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children


		 IF @@FETCH_STATUS = 0
		  BEGIN
		    SET @lastlevel = @level   -- so we now how deep the levels go
		    
		     
		    
		   --   IF EXISTS (SELECT hrcID FROM tblhierarchy WHERE hrcparentid = @hrcID)
		     --    SELECT @open=1
		    -- update the last child entry
			  INSERT INTO #tthrc
				 SELECT 0, @hrcID, @parentID,@level, @name, @children, @open
				 		         
			  SET @error = @@ERROR
		  END
		 
		 CLOSE hrc1
		 DEALLOCATE hrc1

		SET @error = 1   -- make sure we don't try and do stuff if there is no records   
      
      --SELECT @parentID AS PARENT,@level AS LEVEL
      
      DECLARE hrc1 CURSOR SCROLL
         FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren FROM tblhierarchy WHERE hrcparentid = @parentID
     
		OPEN hrc1
		FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children
		
		--SELECT @hrcID AS HRCID, @parentID AS PARENT,@level AS LEVEL, @name AS NAME, @children AS CHILDREN
		
		WHILE @@FETCH_STATUS = 0
		 BEGIN
		   --SELECT @hrcID AS HRCID, @parentID AS PARENT,@level AS LEVEL, @name AS NAME, @children AS CHILDREN
		   -- update the last child entry
		   IF NOT EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.tthrcID = @hrcID)
			  INSERT INTO #tthrc
				 SELECT 0, @hrcID, @parentID,@level, @name, @children, @open
				-- SELECT @ttorder, @hrcID, @parentID,@level, @name, @children
		        
			  SET @error = @@ERROR
			  SET @ttorder= @ttorder + 1
			  
			  --SELECT @hrcID AS HRCID, @parentID AS PARENT,@level AS LEVEL, @name AS NAME, @children AS KIDS

			  FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children			  
			  
		 END
		 
		CLOSE hrc1
		DEALLOCATE hrc1
		
		
		-- now move evrything up a level
		--SET @parentID = (SELECT hrcparentID FROM tblhierarchy WHERE hrcID = @parentID)
		SET @childID=@parentID
		--select @level
		SET @level = @level - 1
		
		--SELECT @parentID AS PARENT,@level AS LEVEL
  END


  DECLARE hrc2 CURSOR SCROLL
     FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren FROM tblhierarchy WHERE hrclevel = 0
     
   OPEN hrc2
   FETCH NEXT FROM hrc2 INTO @hrcID, @parentID,@level, @name, @children

   WHILE @@FETCH_STATUS = 0
	 BEGIN
	   -- make sure we don't add duplicates
	   IF NOT EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.tthrcID = @hrcID)
		  INSERT INTO #tthrc
			 SELECT 0, @hrcID, @parentID,@level, @name, @children,@open   
       
        -- now add the ist level children
		DECLARE hrc1 CURSOR SCROLL
		 FOR SELECT hrcID, hrcparentID, hrclevel, hrcname, hrcchildren FROM tblhierarchy WHERE hrcparentID = @hrcID
	     
		OPEN hrc1
		FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children
        
		WHILE @@FETCH_STATUS = 0
		 BEGIN
		   -- make sure we don't add duplicates
		   IF NOT EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.tthrcID = @hrcID)
			  INSERT INTO #tthrc
				 SELECT 0, @hrcID, @parentID,@level, @name, @children,@open        
		
		   FETCH NEXT FROM hrc1 INTO @hrcID, @parentID,@level, @name, @children
		 END
		 
		CLOSE hrc1
		DEALLOCATE hrc1
		
		 FETCH NEXT FROM hrc2 INTO @hrcID, @parentID,@level, @name, @children
      END
  
  CLOSE hrc2
  DEALLOCATE hrc2

  -- now order the table so we read it in Hierarchical order
  SET @ttorder = 1
  DECLARE hrc2 CURSOR SCROLL
     FOR SELECT tthrcID, ttparentID FROM #tthrc WHERE ttlevel = 0
  
   OPEN hrc2
   FETCH NEXT FROM hrc2 INTO @hrcID, @parentID

   WHILE @@FETCH_STATUS = 0
	 BEGIN
	 
	   UPDATE #tthrc SET ttOrder = @ttorder WHERE #tthrc.tthrcID= @hrcID AND ttOrder = 0
	   SET @ttorder=@ttorder+1
	   
	   -- now 1st level children
	   DECLARE hrc1 CURSOR SCROLL
		 --FOR SELECT hrcID, hrcparentID, hrclevel FROM tblhierarchy WHERE hrcparentID = @hrcID
	     FOR SELECT tthrcID, ttparentID, ttname FROM #tthrc WHERE ttparentID = @hrcID AND ttorder = 0
	     
		OPEN hrc1
		FETCH NEXT FROM hrc1 INTO @hrcID, @parentID, @name
       
        -- SELECT @hrcID AS HRCID, @parentID AS PARENT, @name AS NAME
		WHILE @@FETCH_STATUS = 0
		 BEGIN
		  UPDATE #tthrc SET ttOrder = @ttorder WHERE #tthrc.tthrcID= @hrcID
	      SET @ttorder=@ttorder+1 
	      
	      -- SELECT @hrcID, @parentID, @name
	      IF EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.ttparentID = @hrcID)
	      BEGIN
	        --SELECT ' Parent  is ', @hrcID, @name
	           UPDATE #tthrc SET ttOrder = @ttorder WHERE #tthrc.tthrcID= @hrcID
	           SET @ttorder=@ttorder+1
	          
	         --SET @chlevel = @level + 1
		     SET @parentID = @hrcID
	         -- now loop down through the branch for all the childrren if there are any  
	         SET @error = 0
	         WHILE @error=0
	           BEGIN
		      
				   IF EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.ttparentID = @hrcID AND ttOrder=0)
					 BEGIN
							SET @chID = (select top 1 tthrcID FROM #tthrc WHERE #tthrc.ttparentID = @hrcID AND ttorder = 0)
							SET @name = (select top 1 ttname FROM #tthrc WHERE #tthrc.ttparentID = @hrcID AND ttorder = 0)
							
							--SELECT ' Child is ', @chID, @name
							UPDATE #tthrc SET ttOrder = @ttorder WHERE #tthrc.tthrcID= @chID
							SET @ttorder=@ttorder+1	 
							
							-- check to see if child has children
							 IF EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.ttparentID = @chID AND ttOrder=0) 
							   SET @hrcID = @chID  
							 ELSE
							 SET @hrcID = (SELECT ttparentID FROM #tthrc WHERE #tthrc.tthrcID =@chID AND ttOrder> 0)                 
							--SET @chlevel=@chlevel + 1
							
							--SELECT ' Child is ',@hrcID, @chID, @name
					END
					
					ELSE IF EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.tthrcID = (SELECT ttparentID FROM #tthrc WHERE #tthrc.tthrcID =@hrcID) AND ttOrder>0)
					BEGIN
					    -- SELECT @hrcID, @parentID, @name
						SET @hrcID = (SELECT ttparentID FROM #tthrc WHERE #tthrc.tthrcID =@hrcID)
					END
					
					ELSE IF EXISTS (SELECT #tthrc.tthrcID FROM #tthrc WHERE #tthrc.ttparentID = @parentID AND ttOrder=0)
					 BEGIN
					   -- SELECT @hrcID, @parentID, @name
						SET @hrcID = @parentID
					 END
					ELSE
					  SET @error = 1
	         END
	      END	
	       FETCH NEXT FROM hrc1 INTO @hrcID, @parentID, @name	    
		  
		   --SELECT ' Parent now is ', @hrcID, @name
		  
		 END
		 
		CLOSE hrc1
		DEALLOCATE hrc1
	   --SELECT @ttorder
	   FETCH NEXT FROM hrc2 INTO @hrcID, @parentID
	 END

   
    CLOSE hrc2
	DEALLOCATE hrc2

 
  SET @ttorder = 1
  DECLARE hrc2 CURSOR SCROLL
     FOR SELECT tthrcID FROM #tthrc WHERE ttchildren=1
  
   OPEN hrc2
   FETCH NEXT FROM hrc2 INTO @hrcID

   WHILE @@FETCH_STATUS = 0
	 BEGIN
	 
	     IF EXISTS (SELECT TOP 1 #tthrc.ttparentID FROM #tthrc WHERE #tthrc.ttparentID =@hrcID)
	      UPDATE #tthrc SET ttOpen = 1 WHERE #tthrc.tthrcID= @hrcID 
	     
	     FETCH NEXT FROM hrc2 INTO @hrcID
	     
	 END
	 
	 CLOSE hrc2
	 DEALLOCATE hrc2
 SELECT ttOrder AS hrcOrder, tthrcID AS hrcID,ttparentID AS hrcParentID, ttlevel AS hrcLevel,
         ttname AS hrcName, ttchildren AS hrcChildren, ttopen AS hrcOpen
         FROM #tthrc ORDER BY #tthrc.ttOrder
  DROP TABLE #tthrc   