USE CMS2Auths
GO
/**
TRUNCATE TABLE tblAuths
GO

INSERT INTO tblAuths
        (authCode,authTask,authAddReqs,authRef,apprvcode,ndeID)
        SELECT authid, authtask, authreq, authref, authapp, 0 FROM tempAuths
GO

UPDATE tblAuths  SET apprvID= (SELECT authID FROM tblAuths AS t1 WHERE t1.authCode=tblAuths.apprvcode)                     
GO
        
**/      
USE [CMS2]
GO

/**
SET IDENTITY_INSERT CMSMigrate.dbo.' + @tbl + ' ON'
SET IDENTITY_INSERT CMSMigrate.dbo.' + @tbl + ' OFF'
CREATE TABLE [dbo].[tblAuths](
	[authID] [int],
	[apprvID] [int],
	[authCode] [varchar](50),
	[authTask] [varchar](max) NULL,
	[authReqs] [varchar](max) NULL,
	[authRef] [varchar](500) NULL,
	[apprvcode] [varchar](50) NULL,
	[ndeID] [int] NULL,
 )
 
 GO
**/
 SET IDENTITY_INSERT CMS2.dbo.tblAuths ON
 INSERT INTO tblAuths
         (authID,apprvID,atpID, authCode,authTask,authReqs, authRef,ndeID)
 SELECT  authID, apprvID, 1, authCode, authTask, authAddReqs, authRef, ndeID FROM CMS2Auths.dbo.tblAuths
 SET IDENTITY_INSERT CMS2.dbo.tblAuths OFF
         
         
         /***************
         [authID]      ,[apprvID]      ,[atpID]      ,[authCode]      ,[authTask]      ,[authReqs]      ,[authRef]      ,[ndeID]
         *****************/
 

