USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spAdminAuthsAvailable]    Script Date: 05/18/2016 08:51:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spAdminAuthsAvailable]

--@nodeID INT,
@StaffID INT,
@atpID INT

AS

 SELECT authID, apprvID, authCode 
   FROM tblAuths
	  WHERE tblAuths.atpID=@atpID AND NOT EXISTS (SELECT asrID FROM tblAuthorisor WHERE tblAuthorisor.authID = tblAuths.authID AND staffID =@StaffID)
		ORDER BY tblAuths.authCode