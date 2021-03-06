USE [90SUCMS]
GO
/****** Object:  StoredProcedure [dbo].[spStaffAuthsAvailable]    Script Date: 03/15/2017 11:23:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spStaffAuthsAvailable]

@nodeID INT,
@StaffID INT,
@atpID INT

AS

DECLARE @date DATETIME
DECLARE @d1 VARCHAR(50)
SET DATEFORMAT dmy

--SET @date = GETDATE()
SET @d1 = CONVERT ( VARCHAR(10) , GETDATE() ,120 )
SET @date = CONVERT ( datetime, @d1 ,120 )
    
-- this gets all Auth Codes for Auth Type so Staff can request one for Authorisation
-- BUT - only get those that the staff have not already been authorised for
-- AND that have got authorisors allocated AND they are in date( this should be done by Auth Admin in Authorisations module)
SELECT authID, apprvID, authCode 
   FROM tblAuths
	  WHERE tblAuths.atpID=@atpID AND 
	    EXISTS (SELECT asrID FROM tblAuthorisor WHERE tblAuthorisor.authID=tblAuths.authID AND tblAuthorisor.enddate>= @date AND tblAuthorisor.ndeID=@nodeID)AND
	    NOT EXISTS (SELECT staID FROM tblStaffAuths WHERE tblStaffAuths.authID = tblAuths.authID AND staffID =@StaffID)
		ORDER BY tblAuths.authCode