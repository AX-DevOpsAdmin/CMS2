
  USE CMSMigrate

  DECLARE @staffID INT
  DECLARE @srvNo VARCHAR(50)
  DECLARE @ndeID INT

  DECLARE @enddate DATETIME
  DECLARE @startdate DATETIME

  DECLARE @count INT
  DECLARE @stpID INT
  
  CREATE TABLE #ttstaff(
   ttstaffID INT,
   ttnodeID INT,
   ttsrvno VARCHAR (50),
   ttstart DATETIME,
   ttend DATETIME
) 

CREATE TABLE #ttstpost(
   ttstaffID INT,
   ttstpid INT,
   ttstart DATETIME,
   ttend DATETIME
) 
  -- Inactive staff - over 2 years
  DECLARE staff1 CURSOR SCROLL
	-- FOR SELECT staffID, serviceNo, ndeID FROM tblStaff WHERE active= 0 
	 FOR SELECT staffID, serviceNo FROM tblStaff WHERE active= 1
		     
	 OPEN staff1
	 --FETCH FIRST FROM staff1 INTO @staffID, @srvNo, @ndeID
	 FETCH FIRST FROM staff1 INTO @staffID, @srvNo

	 WHILE @@FETCH_STATUS = 0
	   BEGIN
           DECLARE stPost1 CURSOR SCROLL
	           FOR SELECT TOP 1 COUNT(staffID) FROM tblStaffPost 
	                WHERE staffID= @staffID  --AND 
	                     -- enddate IS NOT NULL --AND enddate < (GETDATE() - 750)
	                     --  ORDER BY enddate DESC
	       
		   OPEN stPost1
		   FETCH FIRST FROM stPost1 INTO @count
		   
		   WHILE @@FETCH_STATUS=0
	     
			 BEGIN 
		       IF @count = 1
			   INSERT INTO #ttstaff 
				   SELECT @staffID, 0 ,@srvno, @startdate,@enddate
				  
			   FETCH NEXT FROM stPost1 INTO @count
			 
			 END
			 CLOSE stPost1
             DEALLOCATE stPost1
		    
	     --FETCH NEXT FROM staff1 INTO @staffID, @srvNo, @ndeID
	     FETCH NEXT FROM staff1 INTO @staffID, @srvNo
	   END

  CLOSE staff1
  DEALLOCATE staff1

  --SELECT * FROM #ttstaff order by ttstaffID
  
   DECLARE tt1 CURSOR SCROLL
	 FOR SELECT ttstaffid FROM #ttStaff 
		     
	 OPEN tt1
	 FETCH FIRST FROM tt1 INTO @staffID

	 WHILE @@FETCH_STATUS = 0
	   BEGIN
	      SET @stpID=(SELECT staffPostID FROM tblStaffPost WHERE StaffID=@staffID)
	      SET @startdate=(SELECT startDate FROM tblStaffPost WHERE StaffID=@staffID)
	      SET @enddate=(SELECT endDate FROM tblStaffPost WHERE StaffID=@staffID)
	      
	      IF @enddate IS NOT NULL AND @enddate < (GETDATE() - 750)
	        BEGIN
	           INSERT INTO #ttstpost
	             SELECT @staffID, @stpID,@startdate, @enddate
	        END
	        
	      FETCH NEXT FROM tt1 INTO @staffID
	   END
    	
    CLOSE tt1
    DEALLOCATE tt1
    
    SELECT * FROM #ttstpost
/*
  -- Inactive staff - over 2 years
  DECLARE tt1 CURSOR SCROLL
	 FOR SELECT ttstaffid FROM #ttstpost 
		     
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
 DROP TABLE #ttstpost
