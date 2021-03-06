USE [CMS2]
GO
/****** Object:  StoredProcedure [dbo].[spAuthTypeDel]    Script Date: 05/18/2016 08:54:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spAuthTypeDel]
(
	@recID		INT,
	@DelOK	INT OUTPUT
)

AS

-- has it got a Auth assigned to it
IF EXISTS (SELECT TOP 1 authID FROM tblAuths WHERE tblAuths.atpID = @recID)    
	SET @DelOk = '1' 
ELSE
	SET @DelOk = '0'
