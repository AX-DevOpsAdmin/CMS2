USE [CMS2]
GO
/****** Object:  StoredProcedure [dbo].[spGetStaffAuths]    Script Date: 05/24/2016 09:03:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spGetAuthsWaiting]  --
(
    @nodeID INT,
	@staffID INT
)

AS

    DECLARE @staID INT
    DECLARE @staffAuthID INT
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
	
	DECLARE @authtype INT    -- 0=No Auths, 1= Authorisations, 2= Approvals, 3=Historical
	DECLARE @staffname VARCHAR(50)
	DECLARE @authname VARCHAR(50)
	DECLARE @apprvname VARCHAR(50)
	DECLARE @authcode VARCHAR(50)
	
	DECLARE @date DATETIME
    SET DATEFORMAT dmy

    SET @date = GETDATE()
    
    CREATE TABLE #ttauths(
      ttstaID INT,
	  ttauthID INT,
	  ttstaffname VARCHAR(50),
	  ttadminID  INT,
	  ttadmindate DATETIME,
	  ttstartdate DATETIME,
	  ttenddate DATETIME,
	  ttauthCode VARCHAR(50),
	  ttauthorisor VARCHAR(50),
	  ttauthOK BIT,
	  ttauthdate VARCHAR(50),
	  ttapprover VARCHAR(50),
	  ttapprvOK BIT,
	  ttapprvdate VARCHAR(50),
	  ttauthtype INT
) 
    
    -- First get the ones waiting Authorisation
    DECLARE staff1 CURSOR SCROLL
	
	 FOR SELECT staID,staffID, adminID,admindate,startdate,enddate,authID,authorisor,authOK,authdate,approver,apprvOK,apprvdate   
	        FROM tblStaffAuths WHERE authorisor=@staffID AND authOK = 0
		     
	 OPEN staff1
	 FETCH FIRST FROM staff1 INTO 
	       @staID,@staffAuthID, @adminID,@admindate,@startdate,@enddate,@authID,@authorisor,@authOK,@authdate,@approver,@apprvOK,@apprvdate 

	 WHILE @@FETCH_STATUS = 0
	   BEGIN
	      
		   SET @authtype=1
		   SET @authCode=(SELECT authCode FROM tblAuths WHERE authID=@authID)
           SET @staffname=(SELECT shortdesc + ' ' + SUBSTRING(firstname,1,1) + ' ' + surname 
                           FROM tblStaff INNER JOIN tblRank on tblRank.rankID = tblStaff.rankID
                           WHERE tblStaff.staffID=@staffAuthID)
	                      
           INSERT INTO #ttauths
             SELECT @staID, @authID,@staffname, @adminID,@admindate,@startdate,@enddate,@authcode,@authname,@authOK,
                    CONVERT(VARCHAR(12),@authdate , 103), @apprvname,0,CONVERT(VARCHAR(12),@apprvdate , 103),@authtype
             
           FETCH NEXT FROM staff1 INTO 
	           @staID,@staffAuthID,@adminID,@admindate,@startdate,@enddate,@authID,@authorisor,@authOK,@authdate,@approver,@apprvOK,@apprvdate
	   END

    CLOSE staff1
    DEALLOCATE staff1
    
    -- Now get the ones waiting Approval
    DECLARE staff1 CURSOR SCROLL
	
	 FOR SELECT staID,staffID, adminID,admindate,startdate,enddate,authID,authorisor,authOK,authdate,approver,apprvOK,apprvdate   
	        FROM tblStaffAuths WHERE approver=@staffID AND apprvOK = 0
		     
	 OPEN staff1
	 FETCH FIRST FROM staff1 INTO 
	       @staID,@staffAuthID, @adminID,@admindate,@startdate,@enddate,@authID,@authorisor,@authOK,@authdate,@approver,@apprvOK,@apprvdate 

	 WHILE @@FETCH_STATUS = 0
	   BEGIN
	      
		   SET @authtype=2
		   SET @authCode=(SELECT authCode FROM tblAuths WHERE authID=@authID)
           SET @staffname=(SELECT shortdesc + ' ' + SUBSTRING(firstname,1,1) + ' ' + surname 
                           FROM tblStaff INNER JOIN tblRank on tblRank.rankID = tblStaff.rankID
                           WHERE tblStaff.staffID=@staffAuthID)
           SET @authname=(SELECT shortdesc + ' ' + SUBSTRING(firstname,1,1) + ' ' + surname 
                           FROM tblStaff INNER JOIN tblRank on tblRank.rankID = tblStaff.rankID
                           WHERE tblStaff.staffID=@authorisor)
            
           INSERT INTO #ttauths
                 SELECT @staID, @authID,@staffname, @adminID,@admindate,@startdate,@enddate,@authcode,@authname,@authOK,
                      CONVERT(VARCHAR(12),@authdate , 103), @apprvname,0,CONVERT(VARCHAR(12),@apprvdate , 103),@authtype             
           FETCH NEXT FROM staff1 INTO 
	           @staID,@staffAuthID,@adminID,@admindate,@startdate,@enddate,@authID,@authorisor,@authOK,@authdate,@approver,@apprvOK,@apprvdate
	   END

    CLOSE staff1
    DEALLOCATE staff1
    
    -- Now get the ones for the history - either Authorised or Approved
    DECLARE staff1 CURSOR SCROLL
	
	 FOR SELECT staID,staffID, adminID,admindate,startdate,enddate,authID,authorisor,authOK,authdate,approver,apprvOK,apprvdate   
	        FROM tblStaffAuths WHERE (authorisor=@staffID AND authOK = 1 OR approver=@staffID AND apprvOK = 1)
		     
	 OPEN staff1
	 FETCH FIRST FROM staff1 INTO 
	       @staID,@staffAuthID, @adminID,@admindate,@startdate,@enddate,@authID,@authorisor,@authOK,@authdate,@approver,@apprvOK,@apprvdate 

	 WHILE @@FETCH_STATUS = 0
	   BEGIN
	      
		   SET @authtype=3
		   SET @authCode=(SELECT authCode FROM tblAuths WHERE authID=@authID)
           SET @staffname=(SELECT shortdesc + ' ' + SUBSTRING(firstname,1,1) + ' ' + surname 
                           FROM tblStaff INNER JOIN tblRank on tblRank.rankID = tblStaff.rankID
                           WHERE tblStaff.staffID=@staffAuthID)
                           
           SET @authname=(SELECT shortdesc + ' ' + SUBSTRING(firstname,1,1) + ' ' + surname 
                           FROM tblStaff INNER JOIN tblRank on tblRank.rankID = tblStaff.rankID
                           WHERE tblStaff.staffID=@authorisor)
                           
           SET @apprvname=(SELECT shortdesc + ' ' + SUBSTRING(firstname,1,1) + ' ' + surname 
                           FROM tblStaff INNER JOIN tblRank on tblRank.rankID = tblStaff.rankID
                           WHERE tblStaff.staffID=@approver)
            
           INSERT INTO #ttauths
                SELECT @staID, @authID,@staffname, @adminID,@admindate,@startdate,@enddate,@authcode,@authname,@authOK,
                    CONVERT(VARCHAR(12),@authdate , 103), @apprvname,@apprvOK,CONVERT(VARCHAR(12),@apprvdate , 103),@authtype             
           FETCH NEXT FROM staff1 INTO 
	           @staID,@staffAuthID,@adminID,@admindate,@startdate,@enddate,@authID,@authorisor,@authOK,@authdate,@approver,@apprvOK,@apprvdate
	   END

    CLOSE staff1
    DEALLOCATE staff1
    
    SELECT ttstaID AS staID, ttauthID AS authID, ttstaffname AS staffname, ttadminID AS adminID, ttadmindate AS admindate ,ttstartdate AS startdate,ttenddate AS enddate,
           ttauthCode AS authCode, ttauthorisor AS authorisor, ttauthOK AS authOK, ttauthdate AS authdate ,
           ttapprover AS approver, ttapprvOK AS apprvOK, ttapprvdate AS apprvdate, ttauthtype AS authtype
      FROM #ttauths  
    
    DROP TABLE #ttauths
