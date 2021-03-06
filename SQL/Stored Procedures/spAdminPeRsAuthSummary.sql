USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spAdminPeRsAuthSummary]    Script Date: 05/18/2016 08:52:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spAdminPeRsAuthSummary]

@recID INT,
@atpID INT

AS

DECLARE @thisDate DATETIME

SET dateformat DMY

SET @thisDate=GETDATE()

EXEC spPeRsDetailSummary @RecID,@thisDate

SELECT  tblStaff.staffID, tblAuthorisor.asrID, tblAuths.authID, tblAuths.authCode, tblAuthorisor.startdate, tblAuthorisor.enddate
	FROM  tblStaff 
	   INNER JOIN tblAuthorisor ON tblAuthorisor.staffID=tblStaff.staffID
	   INNER JOIN tblAuths ON tblAuths.authID=tblAuthorisor.authID
	     WHERE tblAuths.atpID=@atpID AND tblStaff.staffID=@recid