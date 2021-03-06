USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spStaffAuths]    Script Date: 05/18/2016 09:00:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spStaffAuths]

--@nodeID INT,
@StaffID INT,
@atpID INT

AS

-- this gets all Auth Codes for Auth Type so Staff can request one for Authorisation
-- BUT - only get those that the staff have not already been authorised for
-- AND that have got authorisors allocated ( this should be done by Auth Admin in Authorisations module)
SELECT tblStaffAuths.staffID, startdate,enddate, authOK, apprvOK,  tblAuths.authID, tblAuths.authCode 
   FROM tblStaffAuths
      INNER JOIN tblAuths ON tblAuths.authID=tblStaffAuths.authID
		  WHERE tblStaffAuths.staffID=@StaffID AND tblAuths.atpID=@atpID
            ORDER BY tblAuths.authCode