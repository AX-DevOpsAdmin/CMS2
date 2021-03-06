USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spGetAuthDetail]    Script Date: 05/18/2016 08:56:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[spGetAuthDetail]
(
	@RecID	VARCHAR(50)
)

AS
   SELECT T1.authID,T1.authCode,T1.atpID, T1.apprvID, T2.authCode AS apprvCode, T1.authTask,T1.authReqs,T1.authRef, T1.ndeID, tblAuthsType.authType 
      FROM tblAuths T1
        INNER JOIN tblAuthsType ON
           tblAuthsType.atpID=T1.atpID
        LEFT OUTER JOIN tblAuths T2 ON
           T2.authID=T1.apprvID
         WHERE T1.authID=@RecID  
         