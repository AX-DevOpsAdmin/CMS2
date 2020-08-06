
  USE CMSMigrate

  DECLARE @staffID INT
  DECLARE @srvNo VARCHAR(50)
  DECLARE @ndeID INT
  
  DECLARE @delete INT

  DECLARE @enddate DATETIME
  DECLARE @startdate DATETIME

  CREATE TABLE #ttstaff(
   ttstaffID INT,
   ttsrvno VARCHAR (50)
) 

  -- Inactive staff - but NO StaffPosts so check for any other movements
  --  ie: Tasks, Q's, MS, Fitness, Dental and Vacs that STARTED less than 27 months ( 750 days ) ago
  -- if there are none then delete the staff details
  DECLARE staff1 CURSOR SCROLL
	-- FOR SELECT staffID, serviceNo, ndeID FROM tblStaff WHERE active= 0 
	 FOR SELECT staffID, serviceNo 
	     FROM tblStaff WHERE active= 0 AND 
            NOT EXISTS (SELECT TOP 1 staffPostID FROM tblStaffPost WHERE tblStaffPost.StaffID = tblStaff.staffID)
		     
	 OPEN staff1
	 --FETCH FIRST FROM staff1 INTO @staffID, @srvNo, @ndeID
	 FETCH FIRST FROM staff1 INTO @staffID, @srvNo

     SET @delete=0
     
	 WHILE @@FETCH_STATUS = 0
	   BEGIN
            
		  IF (NOT EXISTS (SELECT TOP 1 staffID FROM tbl_taskStaff WHERE StaffID=@staffid and startDate > (GETDATE()-750))
		     AND
		     NOT EXISTS (SELECT TOP 1 staffID FROM tblStaffQs WHERE StaffID=@staffid and ValidFrom > (GETDATE()-750))
		     AND
		     NOT EXISTS (SELECT TOP 1 staffID FROM tblStaffFitness WHERE StaffID=@staffid and ValidFrom > (GETDATE()-750))
		     AND
		     NOT EXISTS (SELECT TOP 1 staffID FROM tblStaffDental WHERE StaffID=@staffid and ValidFrom > (GETDATE()-750))
		     AND
		     NOT EXISTS (SELECT TOP 1 staffID FROM tblStaffMVs WHERE StaffID=@staffid and ValidFrom > (GETDATE()-750))
		     AND
		     NOT EXISTS (SELECT TOP 1 staffID FROM tblStaffMilSkill WHERE StaffID=@staffid and ValidFrom > (GETDATE()-750) ))
		    AND
		     EXISTS (SELECT TOP 1 staffID FROM CMS2.dbo.tblStaff WHERE serviceNo=@srvno)
		     
           BEGIN
			   INSERT INTO #ttstaff 
				   SELECT @staffID, @srvno
		   END		  		    
	     FETCH NEXT FROM staff1 INTO @staffID, @srvNo
	   END

  CLOSE staff1
  DEALLOCATE staff1

  SELECT * FROM #ttstaff order by ttstaffID
/*
  -- Inactive staff - over 2 years
  DECLARE tt1 CURSOR SCROLL
	 FOR SELECT ttstaffid FROM #ttStaff 
		     
	 OPEN tt1
	 FETCH FIRST FROM tt1 INTO @staffID

	 WHILE @@FETCH_STATUS = 0
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
			
			FETCH NEXT FROM tt1 INTO @staffID
	   END
	   
	 CLOSE tt1
	 DEALLOCATE tt1
	*/	  
 DROP TABLE #ttstaff
