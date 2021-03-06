USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spAdminPersAuthsType]    Script Date: 05/18/2016 08:51:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spAdminPersAuthsType] 

@recID INT,
@atpID INT

AS

-- This gets the all the Auth Codes that the staffid is Authorised to asses
-- ie: they can allocate authorisations to Staff ONLY for the Auths that are children to 
-- any Auths they hold
SELECT tblAuthorisor.staffID, startdate,enddate, T1.authID, T1.authCode, tblstaff.firstname + ' ' + tblStaff.Surname AS authorisor
    FROM tblAuthorisor
      INNER JOIN tblAuths T1 ON T1.authID = tblAuthorisor.authID
      LEFT OUTER JOIN tblAuths T2 ON T2.authID=T1.apprvID
      INNER JOIN tblStaff ON tblStaff.staffID=tblAuthorisor.authorisor 
        WHERE T1.atpID=@atpID AND tblAuthorisor.staffID = @recID
