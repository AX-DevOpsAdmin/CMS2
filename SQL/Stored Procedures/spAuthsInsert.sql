USE [CMS2]
GO
/****** Object:  StoredProcedure [dbo].[spAuthsInsert]    Script Date: 05/18/2016 08:53:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spAuthsInsert]
(
    @nodeID INT,
	@authCode VARCHAR(50),
	@atpID	INT,
	@apprvID	INT,
	@task		VARCHAR(2000),
	@reqs		VARCHAR(2000),
	@ref		VARCHAR(2000),
	@Exists		BIT OUTPUT

)

AS

BEGIN TRANSACTION
	IF NOT EXISTS(SELECT authCode FROM tblAuths WHERE authCode = @authCode)
		BEGIN
			INSERT INTO tblAuths (authCode,atpID,apprvID,authTask,authReqs,authRef,ndeID)
     			VALUES (@authCode,@atpID,@apprvID,@task,@reqs,@ref,@nodeID)
			
			SET @Exists = '0'
		END
	ELSE
		BEGIN
			SET @Exists = '1'
		END

	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

COMMIT TRANSACTION

