
    USE CMSJPA
    
	DECLARE @start INT
	DECLARE @end INT
	DECLARE @len INT
	DECLARE @num INT
	DECLARE @str VARCHAR(50)

	DECLARE @fldname VARCHAR(100)
	DECLARE @flds VARCHAR(2000)
	
	DECLARE @staffID INT
	DECLARE @servno VARCHAR(50)

	DECLARE @sql VARCHAR(2000)
	DECLARE @sql1 VARCHAR(2000)

    SET @flds=''
    
    -- first the fitness
    DECLARE fld1 CURSOR SCROLL
		 FOR SELECT fitnesstype FROM jpaimportfitness
		   WHERE fitnesstype IS NOT NULL
	     
	OPEN fld1
	FETCH NEXT FROM fld1 INTO @fldname
    
   -- SET @fldname= SUBSTRING(@fldname, 5, LEN(@fldname))
    
	WHILE @@FETCH_STATUS = 0
	 BEGIN
	 --select @name
		 --SET @flds= @flds + ',' + @fldname
		 IF NOT EXISTS(SELECT fitnesstype FROM jpafitness WHERE fitnesstype=@fldname)
		   INSERT jpaFitness (fitnesstype) VALUES(@fldname)
		   
		-- SET @flds= @flds + @fldname + ',' 
		 FETCH NEXT FROM fld1 INTO @fldname
		 --SET @fldname= SUBSTRING(@fldname, 5, LEN(@fldname))
	 END

	CLOSE fld1
	DEALLOCATE fld1
	
	--SELECT @flds
	
    -- now do the vaccinations
	DECLARE fld1 CURSOR SCROLL
		 FOR SELECT column_name from information_schema.columns where table_name = 'jpaimportvaccs'
	     
	OPEN fld1
	-- ignore first field - its serviceno
	FETCH FIRST FROM fld1 INTO @fldname
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
	
	SET @len = (SELECT LEN(@flds))
    SET @start=1
    SET @num = 0
	WHILE @num < @len
	  BEGIN
	     SET @num = (SELECT CHARINDEX(',', @flds, @start))
		 SET @end = @num - @start
		 
		 -- get the next fieldname in the list
		 SET @fldname = SUBSTRING(@flds, @start, @end) 
		 
		 -- now update the jpavaccs table if neccessary
		 IF NOT EXISTS(SELECT vaccination FROM jpavaccinations WHERE vaccination=@fldname)
		   INSERT jpaVaccinations (vaccination) VALUES(@fldname)
		   
		 SET @start= @num+1
		 
		 --select @fldname, @num, @start, @end, @len
	  END
	  
		  