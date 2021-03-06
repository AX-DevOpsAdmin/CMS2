USE [CMS2]
GO
/****** Object:  StoredProcedure [dbo].[spStaffAuthSummary]    Script Date: 05/18/2016 09:02:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spStaffAuthSummary]

@recID INT,
@atpID INT

AS

DECLARE @thisDate DATETIME

SET dateformat DMY

SET @thisDate=GETDATE()

EXEC spPeRsDetailSummary @RecID,@thisDate

SELECT tblStaffAuths.staID, tblStaffAuths.staffID, tblAuths.authID, tblAuths.authCode, tblStaffAuths.startdate, tblStaffAuths.enddate
	FROM  tblStaffAuths 
	   INNER JOIN tblAuths ON tblAuths.authID=tblStaffAuths.authID 
	     WHERE tblAuths.atpID=@atpID AND tblStaffAuths.staffID=@recid