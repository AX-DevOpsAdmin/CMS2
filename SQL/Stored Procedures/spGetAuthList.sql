USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spGetAuthList]    Script Date: 05/18/2016 08:57:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spGetAuthList] 
 @atpID INT,
 @nodeID INT
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT T1.authID, T1.authCode, T1.apprvID, t2.authcode AS parent , T2.authID AS parentID
        FROM tblAuths AS T1
        LEFT OUTER JOIN tblAuths AS T2 ON T2.authID=T1.apprvID
        WHERE T1.atpID=@atpID
        ORDER BY T1.apprvID
END
