USE [CMS2]
GO
/****** Object:  StoredProcedure [dbo].[spStaffAuthsAvailable]    Script Date: 05/18/2016 09:01:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spStaffAuthsAvailable]

@nodeID INT,
@StaffID INT,
@atpID INT

AS

-- this gets all Auth Codes for Auth Type so Staff can request one for Authorisation
-- BUT - only get those that the staff have not already been authorised for
-- AND that have got authorisors allocated ( this should be done by Auth Admin in Authorisations module)
SELECT authID, apprvID, authCode 
   FROM tblAuths
	  WHERE tblAuths.atpID=@atpID AND 
	    EXISTS (SELECT asrID FROM tblAuthorisor WHERE tblAuthorisor.authID=tblAuths.authID AND tblAuthorisor.ndeID=@nodeID)AND
	    NOT EXISTS (SELECT staID FROM tblStaffAuths WHERE tblStaffAuths.authID = tblAuths.authID AND staffID =@StaffID)
		ORDER BY tblAuths.authCode