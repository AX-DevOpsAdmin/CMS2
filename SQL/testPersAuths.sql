


   DECLARE @nodeID INT
	DECLARE @staffID INT

    SET @nodeID=1
    SET @staffID=1375
    
    DECLARE @staID INT
	DECLARE @adminID  INT
	DECLARE @admindate DATETIME
	DECLARE @startdate DATETIME
	DECLARE @enddate DATETIME
	DECLARE @authID INT
	DECLARE @authorisor INT
	DECLARE @authOK BIT
	DECLARE @authdate DATETIME
	DECLARE @approver INT
	DECLARE @apprvOK BIT
	DECLARE @apprvdate DATETIME
	
	DECLARE @authtype INT    -- 0=No Auths, 1= Pending, 2= Current, 3=Historical
	DECLARE @authname VARCHAR(50)
	DECLARE @apprvname VARCHAR(50)
	DECLARE @authcode VARCHAR(50)
	
	DECLARE @date DATETIME
    SET DATEFORMAT dmy

    SET @date = GETDATE()
    
    CREATE TABLE #ttauths(
	  ttstaID INT,
	  ttadminID  INT,
	  ttadmindate DATETIME,
	  ttstartdate DATETIME,
	  ttenddate DATETIME,
	  ttauthCode VARCHAR(50),
	  ttauthorisor VARCHAR(50),
	  ttauthOK BIT,
	  ttauthdate DATETIME,
	  ttapprover VARCHAR(50),
	  ttapprvOK BIT,
	  ttapprvdate DATETIME,
	  ttauthtype INT
) 
    
    DECLARE staff1 CURSOR SCROLL
	
	 FOR SELECT staID,adminID,admindate,startdate,enddate,authID,authorisor,authOK,authdate,approver,apprvOK,apprvdate   
	        FROM tblStaffAuths WHERE staffID=@staffID
		     
	 OPEN staff1
	 --FETCH FIRST FROM staff1 INTO @staffID, @srvNo, @ndeID
	 FETCH FIRST FROM staff1 INTO 
	       @staID,@adminID,@admindate,@startdate,@enddate,@authID,@authorisor,@authOK,@authdate,@approver,@apprvOK,@apprvdate 

	 WHILE @@FETCH_STATUS = 0
	   BEGIN
	        
	       SELECT @authType=
	         CASE 
				 WHEN @authOK=0 OR @apprvOK=0 THEN 1
				 WHEN @authOK=1 AND @apprvOK=1 AND @enddate > @date THEN 2
				 WHEN @authOK=1 AND @apprvOK=1 AND @enddate < @date THEN 3
				 ELSE 0
		     END
		   SET @authCode=(SELECT authCode FROM tblAuths WHERE authID=@authID)
           SET @authname=(SELECT shortdesc + ' ' + SUBSTRING(firstname,1,1) + ' ' + surname 
                           FROM tblStaff INNER JOIN tblRank on tblRank.rankID = tblStaff.rankID
                           WHERE tblStaff.staffID=@authorisor)
	           
	       SET @apprvname=(SELECT shortdesc + ' ' + SUBSTRING(firstname,1,1) + ' ' + surname 
                           FROM tblStaff INNER JOIN tblRank on tblRank.rankID = tblStaff.rankID
                           WHERE tblStaff.staffID=@approver)
            
           INSERT INTO #ttauths
             SELECT @staID,@adminID,@admindate,@startdate,@enddate,@authcode,@authname,@authOK,@authdate,@apprvname,@apprvOK,@apprvdate,@authtype
             
           FETCH NEXT FROM staff1 INTO 
	           @staID,@adminID,@admindate,@startdate,@enddate,@authID,@authorisor,@authOK,@authdate,@approver,@apprvOK,@apprvdate
	   END

    CLOSE staff1
    DEALLOCATE staff1
    
    SELECT ttstaID AS staID, ttadminID AS adminID, ttadmindate AS admindate ,ttstartdate AS startdate,ttenddate AS enddate,
           ttauthCode AS authCode, ttauthorisor AS authorisor, ttauthOK AS authOK, ttauthdate AS authdate ,
           ttapprover AS approver, ttapprvOK AS apprvOK, ttapprvdate AS apprvdate, ttauthtype AS authtype
      FROM #ttauths 
    
    DROP TABLE #ttauths



