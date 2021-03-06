USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spAuthsUpdate]    Script Date: 05/18/2016 08:53:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spAuthsUpdate]
(
	@authID		INT,
	@authCode VARCHAR(50),
	@atpID	INT,
	@apprvID	INT,
	@task		VARCHAR(2000),
	@reqs		VARCHAR(2000),
	@ref		VARCHAR(2000)
)

AS

BEGIN TRANSACTION
	BEGIN
		UPDATE tblAuths SET
		  authCode=@authCode,
		  atpID=@atpID,
		  apprvID=@apprvID,
		  authTask=@task,
		  authReqs=@reqs,
		  authRef=@ref
		WHERE authID = @authID
	END

IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END

COMMIT TRANSACTION
