
  USE CMSMigrate

  DECLARE @staffID INT
  DECLARE @srvNo VARCHAR(50)
  DECLARE @active INT
  DECLARE @staffID1 INT
  DECLARE @srvNo1 VARCHAR(50)
  DECLARE @active1 INT
  DECLARE @ndeID INT
  
  DECLARE @mactive INT
  DECLARE @cactive INT
  

  DECLARE @enddate DATETIME
  DECLARE @startdate DATETIME

  CREATE TABLE #ttstaff(
   ttmstaffID INT,
   ttmsrvno VARCHAR (50),
   ttmactive INT,
   ttcstaffID INT,
   ttcsrvno VARCHAR (50),
   ttcactive INT,
   ttnodeID INT
) 
  -- Inactive staff - over 2 years
  DECLARE staff1 CURSOR SCROLL
	-- FOR SELECT staffID, serviceNo, ndeID FROM tblStaff WHERE active= 0 
	 FOR SELECT staffID, serviceNo, active FROM tblStaff -- WHERE active= 0 
		     
	 OPEN staff1
	 --FETCH FIRST FROM staff1 INTO @staffID, @srvNo, @ndeID
	 FETCH FIRST FROM staff1 INTO @staffID, @srvNo, @active

	 WHILE @@FETCH_STATUS = 0
	   BEGIN
          IF EXISTS (SELECT staffID FROM CMS2.dbo.tblStaff WHERE CMS2.dbo.tblStaff.serviceno = @srvNo)
			 BEGIN 
			   INSERT INTO #ttstaff 
				   SELECT @staffID,@srvno,@active,
				           (SELECT staffID FROM CMS2.dbo.tblStaff WHERE CMS2.dbo.tblStaff.serviceno = @srvNo),
				           (SELECT serviceNo FROM CMS2.dbo.tblStaff WHERE CMS2.dbo.tblStaff.serviceno = @srvNo),
				           (SELECT active FROM CMS2.dbo.tblStaff WHERE CMS2.dbo.tblStaff.serviceno = @srvNo),
				           (SELECT ndeID FROM CMS2.dbo.tblStaff WHERE CMS2.dbo.tblStaff.serviceno = @srvNo)			 
			 END
			
	     --FETCH NEXT FROM staff1 INTO @staffID, @srvNo, @ndeID
	     FETCH NEXT FROM staff1 INTO @staffID, @srvNo,@active
	   END

  CLOSE staff1
  DEALLOCATE staff1

  SELECT * FROM #ttstaff  where ttmactive=1 and ttcactive=0 order by ttmstaffID


  -- Inactive staff - over 2 years
  DECLARE tt1 CURSOR SCROLL
	 FOR SELECT ttmstaffID,ttcstaffID, ttmactive, ttcactive FROM #ttStaff 
		     
	 OPEN tt1
	 FETCH FIRST FROM tt1 INTO @staffID, @staffID1, @mactive, @cactive

	 WHILE @@FETCH_STATUS = 0
	   BEGIN
	     IF @mactive=1 and @cactive = 0
	      -- IF @cactive=1 and @mactive = 0 
	      --IF NOT EXISTS(SELECT TOP 1 staffID FROM  CMS2.dbo.tblStaffPost WHERE CMS2.dbo.tblStaffPost.StaffID = @staffID)
	     -- IF NOT EXISTS(SELECT TOP 1 staffID FROM  tblStaffPost WHERE tblStaffPost.StaffID = @staffID)
	     /*
	       BEGIN
	        DELETE tblStaffPost where StaffID=@staffid
			DELETE tbl_taskStaff where StaffID=@staffid
			DELETE tblStaffQs where StaffID=@staffid
			DELETE tblStaffFitness where StaffID=@staffid
			DELETE tblStaffDental where StaffID=@staffid
			DELETE tblStaffMVs where StaffID=@staffid
			DELETE tblStaffMilSkill where StaffID=@staffid
			DELETE tblStaffPhoto where StaffID=@staffid
			DELETE tblStaffHarmony where StaffID=@staffid
			DELETE tblPassword where staffID =@staffID
			DELETE tblStaff where StaffID=@staffid
		   END
		   */
		BEGIN
	        DELETE CMS2.dbo.tblStaffPost where staffID =@staffID1
			DELETE CMS2.dbo.tbl_taskStaff where staffID =@staffID1
			DELETE CMS2.dbo.tblStaffQs where staffID =@staffID1
			DELETE CMS2.dbo.tblStaffFitness where staffID =@staffID1
			DELETE CMS2.dbo.tblStaffDental where staffID =@staffID1
			DELETE CMS2.dbo.tblStaffMVs where staffID =@staffID1
			DELETE CMS2.dbo.tblStaffMilSkill where staffID =@staffID1
			DELETE CMS2.dbo.tblStaffPhoto where staffID =@staffID1
			DELETE CMS2.dbo.tblStaffHarmony where staffID =@staffID1
			DELETE CMS2.dbo.tblPassword where staffID =@staffID1
			DELETE CMS2.dbo.tblStaff where staffID =@staffID1
		   END
			FETCH NEXT FROM tt1 INTO @staffID,@staffID1, @mactive, @cactive
	   END
	   
	 CLOSE tt1
	 DEALLOCATE tt1
	 
 DROP TABLE #ttstaff
