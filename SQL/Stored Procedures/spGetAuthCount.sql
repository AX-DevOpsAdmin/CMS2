USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spGetAuthCount]    Script Date: 05/18/2016 08:56:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spGetAuthCount]

@StaffID INT,
@retn INT OUT,
@hist INT OUT

AS

-- this gets the count of any Authorisations this staff member has waiting to process
SET @retn=(SELECT COUNT(staID) FROM tblStaffAuths 
    WHERE (tblStaffAuths.authorisor=@StaffID AND authOK = 0) OR (tblStaffAuths.approver=@StaffID AND apprvOK=0))

-- this gets the count of any Authorisations this staff member has processed ie: Auth History   
SET @hist=(SELECT COUNT(staID) FROM tblStaffAuths 
    WHERE (tblStaffAuths.authorisor=@StaffID AND authOK = 1) OR (tblStaffAuths.approver=@StaffID AND apprvOK=1))
