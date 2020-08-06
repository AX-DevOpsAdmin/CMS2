USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spAuthTypeUpdate]    Script Date: 05/18/2016 08:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spAuthTypeUpdate]
(
	@atpID	INT,
	@Description	VARCHAR(50),
	@blnExists	BIT OUTPUT
)

AS

UPDATE tblAuthsType 
   SET authType = @Description
      WHERE atpID = @atpID

SET @blnExists = 0
