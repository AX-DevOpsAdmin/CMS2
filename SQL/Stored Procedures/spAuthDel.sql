USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spAuthDel]    Script Date: 05/18/2016 08:52:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spAuthDel]
(
	@recID		INT,
	@DelOK	INT OUTPUT
)

AS

-- has auth got a child
IF EXISTS (SELECT TOP 1 apprvID FROM tblAuths WHERE tblAuths.apprvID = @recID)    
	SET @DelOk = 1
ELSE
	SET @DelOk = 0

-- has a Q been assigned to personnel
IF @DelOK=0
  BEGIN
	IF EXISTS (SELECT TOP 1 authID FROM tblStaffAuths WHERE tblStaffAuths.authID = @recID)    
		SET @DelOk =1
  END
