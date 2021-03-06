USE [CMS2]
GO
/****** Object:  StoredProcedure [dbo].[spStaffAuthsAdd]    Script Date: 05/18/2016 09:01:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spStaffAuthsDelete]
(
	@staffID  INT, 
	@staID  INT
)

AS

SET DATEFORMAT dmy

-- first we update the tblStaffAuths record with name/date of whoever is deleteing it
-- we MUST do this otherwise the audit record created in the DELETE trigger will hold duff info
BEGIN TRANSACTION
    UPDATE tblStaffAuths
       SET adminID=@staffID,
           admindate=GETDATE()
           WHERE tblStaffAuths.staID=@staID 
           
    -- now delete the record
    DELETE tblStaffAuths WHERE tblStaffAuths.staID=@staID 
    
COMMIT
