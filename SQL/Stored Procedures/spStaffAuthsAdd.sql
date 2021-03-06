USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spStaffAuthsAdd]    Script Date: 05/18/2016 09:01:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[spStaffAuthsAdd]
(
	@staffID  INT, 
	@adminID  INT, 
	@authID  INT, 
	@startdate  VARCHAR(50), 
	@enddate   VARCHAR(50),
	@authorisor  INT, 
	@ndeID INT
)

AS

SET DATEFORMAT dmy

INSERT INTO tblStaffAuths (adminID,admindate,staffID,startdate,enddate,authID,authorisor,authOK,authdate,approver,apprvOK,apprvdate,ndeID)
                 VALUES(@adminID,GETDATE(),@staffID,@startdate,@enddate,@authID,@authorisor,0,NULL,NULL,0,NULL,@ndeID)