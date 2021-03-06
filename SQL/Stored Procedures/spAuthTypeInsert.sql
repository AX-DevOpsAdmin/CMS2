USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spAuthTypeInsert]    Script Date: 05/18/2016 08:54:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spAuthTypeInsert]
(
    @nodeID INT,
	@Description	VARCHAR(50),
	@blnExists	BIT OUTPUT
)

AS

IF EXISTS (SELECT authType FROM tblAuthsType WHERE authType = @Description)
	BEGIN
		SET @blnExists = 1
	END
ELSE
	BEGIN
		INSERT INTO tblAuthsType (authType,ndeID)
		               VALUES (@Description, @nodeID)

		SET @blnExists = 0
	END
