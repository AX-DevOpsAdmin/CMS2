
	DECLARE @start INT
	DECLARE @end INT
	DECLARE @len INT
	DECLARE @num INT
	DECLARE @str VARCHAR(50)

	DECLARE @fldname VARCHAR(100)
	DECLARE @flds VARCHAR(2000)
	
	DECLARE @staffID INT
	DECLARE @servno VARCHAR(50)

	DECLARE @sql NVARCHAR(MAX)
	DECLARE @sql1 VARCHAR(2000)
	
	DECLARE @fitID INT
	DECLARE @vacID INT
	DECLARE @startdate DATETIME
	DECLARE @enddate VARCHAR(20)
	DECLARE @fitype VARCHAR(100)

    SET @flds=''
    
    -- first we update the staff fitness
    DECLARE fld1 CURSOR SCROLL
		 FOR SELECT serviceno,startdate, enddate, fitnesstype FROM jpaimportfitness
	     
	OPEN fld1
	FETCH NEXT FROM fld1 INTO @servno, @startdate, @enddate, @fitype
    --SET @fldname = '['+@fldname +']'
    --select @fldname
	WHILE @@FETCH_STATUS = 0
	 BEGIN
	     -- select @servno, @startdate, @enddate, @fitype
	     IF EXISTS(SELECT staffID FROM tblStaff WHERE serviceno= @servno)
	       BEGIN
			 SET @staffID=(SELECT staffID FROM tblStaff WHERE serviceno= @servno)
			 IF EXISTS (SELECT jpafitID FROM jpaFitness WHERE fitnesstype=@fitype)
			   BEGIN
				
				 SET @fitID=(SELECT jpafitID FROM jpaFitness WHERE fitnesstype=@fitype)
				 
				 -- NB: THERE WILL ONLY BE ONE STAFF FITNESS RECORD	     
				 IF NOT EXISTS(SELECT staffID FROM jpaStaffFitness WHERE staffID=@staffID) -- AND jpafitID = @fitID)
					BEGIN
					  INSERT jpaStaffFitness (staffID,jpafitID,startdate,enddate) VALUES(@staffID,@fitID,@startdate, @enddate)
					  --SELECT @fldname, @staffID,@startdate,@vacID
					END
				 ELSE
					BEGIN
					   UPDATE jpaStaffFitness
						 SET startdate=@startdate, enddate=@enddate, jpafitID=@fitID 
						   WHERE jpaStaffFitness.staffID=@staffID -- AND jpaStaffFitness.jpafitID=@fitID
					END
			   END
		    END
		 FETCH NEXT FROM fld1 INTO @servno, @startdate, @enddate, @fitype
		
	 END

	CLOSE fld1
	DEALLOCATE fld1

	-- now the staff dental
	DECLARE fld1 CURSOR SCROLL
		 FOR SELECT serviceno,startdate, enddate FROM jpaimportdental
	     
	OPEN fld1
	FETCH NEXT FROM fld1 INTO @servno, @startdate, @enddate
    --SET @fldname = '['+@fldname +']'
    --select @fldname
	WHILE @@FETCH_STATUS = 0
	 BEGIN
	     -- select @servno, @startdate, @enddate, @fitype
	     IF EXISTS(SELECT staffID FROM tblStaff WHERE serviceno= @servno)
	       BEGIN
			 SET @staffID=(SELECT staffID FROM tblStaff WHERE serviceno= @servno)
			   
			 -- NB: THERE WILL ONLY BE ONE STAFF DENTAL RECORD	          
			 IF NOT EXISTS(SELECT staffID FROM jpaStaffDental WHERE staffID=@staffID )
				BEGIN
				  INSERT jpaStaffDental (staffID,startdate,enddate) VALUES(@staffID,@startdate, @enddate)
				  --SELECT @fldname, @staffID,@startdate,@vacID
				END
			 ELSE
				BEGIN
				   UPDATE jpaStaffDental
					 SET startdate=@startdate, enddate=@enddate 
					   WHERE jpaStaffDental.staffID=@staffID 
				END
		    END
		 FETCH NEXT FROM fld1 INTO @servno, @startdate, @enddate
		
	 END

	CLOSE fld1
	DEALLOCATE fld1

    -- Now we update the Staff Vaccinations
	DECLARE fld1 CURSOR SCROLL
		 FOR SELECT column_name from information_schema.columns where table_name = 'jpaimportvaccs'
	     
	OPEN fld1
	FETCH FIRST FROM fld1 INTO @fldname -- don't need thhis its service no
	FETCH NEXT FROM fld1 INTO @fldname
    --SET @fldname = '['+@fldname +']'
    --select @fldname
	WHILE @@FETCH_STATUS = 0
	 BEGIN
	     --select @name
		 SET @flds= @flds + @fldname + ',' 
		 FETCH NEXT FROM fld1 INTO @fldname	
		
	 END

	CLOSE fld1
	DEALLOCATE fld1
	--SET @flds = SUBSTRING(@flds, 2, LEN(@flds))
	SELECT @flds
	
	
	DECLARE st1 CURSOR SCROLL
		 FOR SELECT serviceno FROM jpaimportvaccs
	     
	OPEN st1
	FETCH NEXT FROM st1 INTO @servno
	WHILE @@FETCH_STATUS = 0
	 BEGIN
	     
	    IF EXISTS(SELECT staffID FROM tblStaff WHERE serviceno= @servno)
	      BEGIN
			SET @staffID=(SELECT staffID FROM tblStaff WHERE serviceno= @servno)
			SET @len = (SELECT LEN(@flds))
			SET @start=1

			SET @num = 0
			WHILE @num < @len
			  BEGIN
			     SET @num = (SELECT CHARINDEX(',', @flds, @start))
				 SET @end = @num - @start
				 
				 -- get the next fieldname in the list
				 SET @fldname = SUBSTRING(@flds, @start, @end) 
				 
				 -- now get vacID
				 IF EXISTS (SELECT jpavacID FROM jpaVaccinations WHERE vaccination=@fldname)
				   BEGIN
				     
				     SET @vacID=(SELECT jpavacID FROM jpaVaccinations WHERE vaccination=@fldname)
				     SET @sql= N'SET @startdate = (SELECT ' + @fldname + N' FROM jpaimportvaccs WHERE serviceno=' + N'''' + @servno + N'''' + N' )'
				     --SELECT @sql
				     EXEC sp_executesql @sql, N'@startdate DATETIME OUT', @startdate out
				     
					  -- now update the jpavaccs table as neccessary
					  -- NB: THERE WILL BE ONE STAFF VACCINATION RECORD FOR EACH VACCINATION TYPE
					  IF NOT EXISTS(SELECT staffID FROM jpaStaffVaccinations WHERE staffID=@staffID AND jpavacID = @vacID)
					    BEGIN
					      INSERT jpaStaffVaccinations (staffID,jpavacID,vacdate) VALUES(@staffID,@vacID,@startdate)
					      --SELECT @fldname, @staffID,@startdate,@vacID
					    END
					  ELSE
					    BEGIN
					       UPDATE jpaStaffVaccinations
					         SET vacdate=@startdate 
					           WHERE jpaStaffVaccinations.staffID=@staffID AND jpaStaffVaccinations.jpavacID=@vacID
					    END
					   
					 SET @start= @num+1
		           END
		          -- select @fldname, @num, @start, @end, @len
			  END
		    END
		  FETCH NEXT FROM st1 INTO @servno
	 END
	
	CLOSE st1
	DEALLOCATE st1
	