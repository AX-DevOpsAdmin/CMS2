USE [CMS2]
GO
/****** Object:  StoredProcedure [dbo].[spGetCISIndividualAuth]    Script Date: 07/05/2016 13:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spGetAuthIndividuals]
(
    @nodeID INT,
	@surname	VARCHAR(50),
	@firstname	VARCHAR(50),
	@serviceno	VARCHAR(50),
	@hrcID	INT
)

AS

DECLARE @search INT

SET @search=0

IF @hrcID<> 0 OR @surname <> '' OR @firstname <> '' OR @serviceno <> ''
  SET @search=1
  
SET @surname = @surname + '%'
SET @firstname = @firstname + '%'
SET @serviceno = @serviceno + '%'

/*
IF @surname =''
	BEGIN
		SET @surname = '%'
	END

IF @firstname  ='' 
	BEGIN
		SET @firstname = '%'
	END

IF @serviceno  ='' 
	BEGIN
		SET @serviceno = '%'
	END
*/
-- Here we get the list of staff - BUT - we ONLY want people who have Q's that have
-- been Authorised - otherwise we are just going to see a blank certificate

IF @hrcID<> 0 
	BEGIN
	SELECT DISTINCT tblStaff.staffID, tblStaff.serviceno, tblRank.shortDesc, tblStaff.firstname, tblStaff.surname 
		  FROM tblPost
		   INNER JOIN tblStaffPost ON tblStaffPost.postID = tblPost.postID AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) 
		   INNER JOIN tblStaff ON tblStaff.staffID=tblStaffPost.StaffID AND tblStaff.active=1
		   INNER JOIN tblStaffAuths ON tblStaffAuths.staffID=tblstaff.staffID 
		   INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID 
			WHERE tblPost.hrcID=@hrcID AND 
				  tblStaffAuths.startdate < GETDATE() AND tblStaffAuths.enddate > GETDATE() AND
				  tblStaffAuths.authOK=1 AND tblStaffAuths.apprvOK=1 AND
				   surname LIKE @surname  AND firstname LIKE @firstname AND serviceno LIKE @serviceno 
	END
ELSE
    BEGIN
		SELECT DISTINCT tblStaff.staffID, tblStaff.serviceno, tblRank.shortDesc, tblStaff.firstname, tblStaff.surname 
		  FROM tblStaff
		  INNER JOIN tblStaffAuths ON tblStaffAuths.staffID=tblstaff.staffID 
		  INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID 
		    WHERE tblStaff.ndeID=@nodeID AND tblStaff.active=1 AND
		          tblStaffAuths.startdate < GETDATE() AND tblStaffAuths.enddate > GETDATE() AND
		          tblStaffAuths.authOK=1 AND tblStaffAuths.apprvOK=1 AND
				  surname LIKE @surname  AND firstname LIKE @firstname AND serviceno LIKE @serviceno 
    END
