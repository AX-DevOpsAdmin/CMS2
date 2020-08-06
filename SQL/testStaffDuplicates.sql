
 DECLARE @srvNo VARCHAR(50)
 DECLARE @count INT
 
 DECLARE @staffID INT
 DECLARE @enddate DATETIME
 
 CREATE TABLE #ttstaff(
   ttstaffID INT,
   ttfname VARCHAR(50),
   ttsname VARCHAR(50),
   ttsrvno VARCHAR (50),
   ttactive INT,
   ttenddate DATETIME
) 

 DECLARE staff1 CURSOR SCROLL FOR
	 SELECT COUNT(serviceNo), serviceno FROM tblStaff
     GROUP BY serviceno HAVING COUNT(serviceNo) > 1
		     
	 OPEN staff1
	 FETCH FIRST FROM staff1 INTO @count, @srvNo

     WHILE @@FETCH_STATUS = 0
	   BEGIN
	      
	      INSERT INTO #ttstaff 
				   SELECT staffID, firstname, surname, serviceNo, active, NULL 
				       FROM tblStaff WHERE serviceno=@srvNo
	      
	      FETCH NEXT FROM staff1 INTO @count, @srvNo
	      
	   END

  CLOSE staff1
  DEALLOCATE staff1

  DECLARE tt1 CURSOR SCROLL FOR
	 SELECT ttstaffid from #ttstaff WHERE ttactive=0
   
	 OPEN tt1
	 FETCH FIRST FROM tt1 INTO @staffID

     WHILE @@FETCH_STATUS = 0
	   BEGIN
	      
	      SET @enddate = (SELECT TOP 1 enddate FROM tblStaffPost 
	          WHERE tblstaffPost.StaffID = @staffID
	             ORDER BY startDate DESC)
	             
	      UPDATE #ttStaff  SET ttenddate = @enddate WHERE ttstaffid=@staffID
	      --select @enddate
				   
	      
	      FETCH NEXT FROM tt1 INTO @staffID
	      
	   END

  CLOSE tt1
  DEALLOCATE tt1
  
  SELECT * FROM #ttstaff -- WHERE ttend < GETDATE() - 720
  DROP TABLE #ttstaff