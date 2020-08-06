
USE CMSMigrate
GO

-- first get rid of redundant teams ie: they have no posts
DELETE tblTeam 
  WHERE NOT EXISTS(SELECT postID FROM tblPost WHERE tblPost.teamID=tblTeam.teamID)
  
TRUNCATE TABLE tblhierarchy

DECLARE @hrcID INT
DECLARE @recID INT
DECLARE @teamID INT
DECLARE @tblID INT
DECLARE @pntID INT
DECLARE @name VARCHAR(50)

DECLARE @grpID INT
DECLARE @grpName VARCHAR(50)
DECLARE @wngID INT
DECLARE @wngName VARCHAR(50)
DECLARE @sqnID INT
DECLARE @sqnName VARCHAR(50)
DECLARE @fltID INT
DECLARE @fltName VARCHAR(50)
DECLARE @tm4ID INT
DECLARE @tm5ID INT

DECLARE @teamName VARCHAR(50)


DECLARE grp1 CURSOR SCROLL
     FOR SELECT grpID, description FROM tblGroup 
     
OPEN grp1
FETCH NEXT FROM grp1 INTO @grpID, @grpName
WHILE @@FETCH_STATUS = 0
  BEGIN
  
      /* now insert the group data */
      SET @teamID = (SELECT teamID FROM tblTeam WHERE parentID = @grpID AND teamIn = 0)
      INSERT INTO tblhierarchy
        SELECT @teamID, @grpID, 0, 0, 0, @grpName, 0 
   
      
      
      UPDATE tblhierarchy
         SET teamID = @teamID WHERE hrcID = @recID
         
      /** Now all the WING data for current Group **/
		DECLARE wng1 CURSOR SCROLL
			  FOR SELECT wingID, description FROM tblWing WHERE grpID=@grpID
		     
		OPEN wng1
		FETCH NEXT FROM wng1 INTO @wngID, @wngName
		WHILE @@FETCH_STATUS = 0
		  BEGIN
              
		       SET @teamID = (SELECT teamID FROM tblTeam WHERE parentID = @wngID AND teamIn = 1)
		       SET @pntID = (SELECT hrcID FROM tblhierarchy WHERE tblID = @grpID AND hrclevel = 0)
		       -- Now the wing data
		       INSERT INTO tblhierarchy
		           SELECT @teamID, @wngID, 0, @pntID, 1, @wngName, 0 
		           
		       /*  Now for the Sqn data for current Wing */      	   
			   DECLARE sqn1 CURSOR SCROLL
			       FOR SELECT sqnID, description FROM tblSquadron WHERE wingID=@wngID
				     
			   OPEN sqn1
			   FETCH NEXT FROM sqn1 INTO @sqnID, @sqnName
			   WHILE @@FETCH_STATUS = 0
				  BEGIN
					  SET @pntID = (SELECT hrcID FROM tblhierarchy WHERE tblID = @wngID AND hrclevel = 1)
					  SET @teamID = (SELECT teamID FROM tblTeam WHERE parentID = @sqnID AND teamIn = 2)
				      
				      -- Now the squadron data
			          INSERT INTO tblhierarchy
				         SELECT @teamID, @sqnID, 0, @pntID, 2, @sqnName, 0 
					  
					  /** now insert flights for current Squadron ***/
						DECLARE flt1 CURSOR SCROLL
							  FOR SELECT fltID, description FROM tblFlight WHERE sqnID = @sqnID
						     
						OPEN flt1
						FETCH NEXT FROM flt1 INTO @fltID, @fltName
						WHILE @@FETCH_STATUS = 0
						  BEGIN
							  SET @pntID = (SELECT hrcID FROM tblhierarchy WHERE tblID = @sqnID AND hrclevel = 2)
							  SET @teamID = (SELECT teamID FROM tblTeam WHERE parentID = @fltID AND teamIn = 3)
						      
							   -- Now the flight data
			                  INSERT INTO tblhierarchy
				                   SELECT @teamID, @fltID, 0, @pntID, 3, @fltName, 0 
				                
				                -- SELECT @fltID, @fltname   
				                /** now the team level 4 for current flight **/  
								DECLARE tm1 CURSOR SCROLL
									  FOR SELECT teamID, description FROM tblTeam WHERE teamIn = 4 AND parentID=@teamID
								     
								OPEN tm1
								FETCH NEXT FROM tm1 INTO @tm4ID, @teamName
								WHILE @@FETCH_STATUS = 0
								  BEGIN
									 SET @pntID = (SELECT hrcID FROM tblhierarchy WHERE tblID=@fltID AND hrclevel = 3 )
								      
									 INSERT INTO tblhierarchy
				                        SELECT @tm4ID, @tm4ID, 0, @pntID, 4, @teamName, 0 
								
								    
								     /*** now any team level 5 for current team level 4 **/   
									  DECLARE tm2 CURSOR 
										  FOR SELECT teamID, description FROM tblTeam WHERE teamIn = 5 AND parentID=@tm4ID
									     
									  OPEN tm2
									  FETCH NEXT FROM tm2 INTO @tm5ID, @teamname
									  WHILE @@FETCH_STATUS = 0
									    BEGIN
									      
										   SET @pntID = (SELECT hrcID FROM tblhierarchy WHERE tblID=@tm4ID AND hrclevel = 4  )
								      
									       INSERT INTO tblhierarchy
				                              SELECT @tm5ID, @tm5ID, 0, @pntID, 5, @teamName, 0 
										  FETCH NEXT FROM tm2 INTO @tm5ID, @teamname
									    END
									   
									  CLOSE tm2
									  DEALLOCATE tm2
								      /********************/
									  FETCH NEXT FROM tm1 INTO @tm4ID, @teamName
								  END
								   
								CLOSE tm1
								DEALLOCATE tm1
				              /****************/
						      
							  FETCH NEXT FROM flt1 INTO @fltID, @fltName
						  END
							   
					   CLOSE flt1
					   DEALLOCATE flt1
					  /******************************/
				      
					  FETCH NEXT FROM sqn1 INTO @sqnID, @sqnName
			   END
				   
			   CLOSE sqn1
			   DEALLOCATE sqn1
              /********************************************/
      
			  FETCH NEXT FROM wng1 INTO @wngID, @wngName
		  END
		   
		CLOSE wng1
		DEALLOCATE wng1
		
      FETCH NEXT FROM grp1 INTO  @grpID, @grpName
  END
   
CLOSE grp1
DEALLOCATE grp1

DELETE FROM tblhierarchy WHERE hrcparentID IS NULL

/** Now update the child flag - set to 1 if this record has children **/
DECLARE hrc1 CURSOR SCROLL
     FOR SELECT hrcID, hrcname FROM tblhierarchy 
     
OPEN hrc1
FETCH NEXT FROM hrc1 INTO @hrcID, @name


WHILE @@FETCH_STATUS = 0
 BEGIN
   IF EXISTS(SELECT TOP 1 hrcID FROM tblHierarchy WHERE tblHierarchy.hrcparentID = @hrcID)
     BEGIN
        UPDATE tblHierarchy
           SET hrcchildren = 1 WHERE hrcID = @hrcID
        --SELECT @hrcID, @name
     END
    
   FETCH NEXT FROM hrc1 INTO @hrcID, @name     
   
 END
 
CLOSE hrc1
DEALLOCATE hrc1

-- now update the tblHierarchy.ndeID to the ID of the current tblNode - set in CMSMigrateDBUpdate
DECLARE @ndeID INT

SET @ndeID = (SELECT TOP 1 ndeID FROM tblStaff)
UPDATE tblHierarchy SET ndeID=@ndeID

GO

-- Now update hrcID in relevant related tables so we can link them to tblHierarchy and NOT tblTeam
UPDATE tblPost
   SET tblPost.hrcID =  (SELECT tblHierarchy.hrcID FROM tblHierarchy WHERE tblHierarchy.teamID = tblPost.teamID )
         WHERE EXISTS(SELECT tblHierarchy.teamID FROM tblHierarchy WHERE tblHierarchy.teamID = tblPost.teamID )
  
  GO


  UPDATE tblTeamHierarchy
   SET tblTeamHierarchy.hrcID = (SELECT tblHierarchy.hrcID FROM tblHierarchy WHERE tblHierarchy.teamID = tblTeamHierarchy.teamID)
        WHERE EXISTS(SELECT tblHierarchy.teamID FROM tblHierarchy WHERE tblHierarchy.teamID = tblTeamHierarchy.teamID )

  --SELECT teamID, hrcID FROM tblTeamHierarchy ORDER BY hrcID
   GO

   UPDATE tblOpTeam
   SET tblOpTeam.hrcID = (SELECT tblHierarchy.hrcID FROM tblHierarchy WHERE tblHierarchy.teamID = tblOpTeam.teamID)
        WHERE EXISTS(SELECT tblHierarchy.teamID FROM tblHierarchy WHERE tblHierarchy.teamID = tblOpTeam.teamID )
  -- SELECT teamID, hrcID FROM tblOpTeam

   GO

   UPDATE tbl_TaskUnit
   SET tbl_TaskUnit.hrcID = (SELECT tblHierarchy.hrcID FROM tblHierarchy WHERE tblHierarchy.teamID = tbl_TaskUnit.teamID)
         WHERE EXISTS(SELECT tblHierarchy.teamID FROM tblHierarchy WHERE tblHierarchy.teamID = tbl_TaskUnit.teamID )
