USE [CMS]
GO
/****** Object:  Trigger [dbo].[staffAuthAudit]    Script Date: 05/18/2016 09:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[staffAuthAudit] ON [dbo].[tblStaffAuths]
AFTER INSERT, UPDATE,DELETE
AS

BEGIN
      DECLARE @adminID  INT;
	  DECLARE @admindate DATETIME;
	  
	  DECLARE @staID INT;
	  DECLARE @staffID INT;  
	  DECLARE @authID INT;
	  
	  DECLARE @authorisor INT;
      DECLARE @authOK BIT;
      DECLARE @authdate DATETIME;
 
 	  DECLARE @approver INT
	  DECLARE @apprvOK BIT
	  DECLARE @apprvdate DATETIME
     
      DECLARE @authType INT;
      DECLARE @action INT;
      
      DECLARE @start DATETIME;
      DECLARE @end DATETIME;
      DECLARE @nodeID INT;
      
      -- now set the action 1=Insert, 2=Update,3=Delete
      SET @action=1;
      IF EXISTS(SELECT * FROM DELETED)
      BEGIN
          SET @action=
            CASE 
               WHEN EXISTS(SELECT * FROM INSERTED) THEN 2
               ELSE 3
            END
      END
      ELSE
        IF NOT EXISTS(SELECT * FROM inserted) RETURN; --no record was changed so don't create a NULL entry in the audit trail
        
      SET @admindate = GETDATE();   -- The audit timestamp
      SET @authType=1;  -- Audit Staff being given authorisation
      IF @action=3 -- we are DELETING the record
       BEGIN  
		  SELECT @adminID= i.adminID FROM deleted i         -- who changing the tblStaffAuth record
		  SELECT @staID= i.staID FROM deleted i             -- recID of tblStaffAuth record being changed
		  SELECT @staffID= i.staffID FROM deleted i         -- who is requesting/being granted authorisation
		  SELECT @authID= i.authID FROM deleted i           -- what authorisation is being requested/granted 
		  SELECT @start= i.startdate FROM deleted i         -- from when
		  SELECT @end= i.enddate FROM deleted i             -- to when

          SELECT @authorisor= i.authorisor FROM deleted i   -- who authorising the tblStaffAuth record
		  SELECT @authOK= i.authOK FROM deleted i           -- 1= Authorised , 0=Waiting Authorisation 
		  SELECT @authdate= i.authdate FROM deleted i       -- date authorised	
		  
          SELECT @approver= i.approver FROM deleted i        -- who approved the tblStaffAuth record
		  SELECT @apprvOK= i.apprvOK FROM deleted i           -- 1= Approved , 0=Waiting Approval 
		  SELECT @apprvdate= i.apprvdate FROM deleted i       -- date approved	  
  
		  SELECT @nodeID = i.ndeID FROM deleted i           -- Which CMS Hierarchy
	   END
	  ELSE
	   BEGIN
	      SELECT @adminID= i.adminID FROM inserted i         -- who changing the tblStaffAuth record
		  SELECT @staID= i.staID FROM inserted i             -- recID of tblStaffAuth record being changed
		  SELECT @staffID= i.staffID FROM inserted i         -- who is requesting/being granted authorisation
		  SELECT @authID= i.authID FROM inserted i           -- what authorisation is being requested/granted 
		  SELECT @start= i.startdate FROM inserted i         -- from when
		  SELECT @end= i.enddate FROM inserted i             -- to when

          SELECT @authorisor= i.authorisor FROM inserted i   -- who authorising the tblStaffAuth record
		  SELECT @authOK= i.authOK FROM inserted i           -- 1= Authorised , 0=Waiting Authorisation 
		  SELECT @authdate= i.authdate FROM inserted i       -- date authorised	
		  
          SELECT @approver= i.approver FROM inserted i        -- who approved the tblStaffAuth record
		  SELECT @apprvOK= i.apprvOK FROM inserted i           -- 1= Approved , 0=Waiting Approval 
		  SELECT @apprvdate= i.apprvdate FROM inserted i       -- date approved	  
  
		  SELECT @nodeID = i.ndeID FROM inserted i           -- Which CMS Hierarchy

	   END
      
      INSERT INTO tblStaffAuthsAudit (authType, adminID,admindate,staID,staffID,startdate,enddate,authID,authorisor,authOK,authdate,approver,apprvOK,apprvdate,ndeID)
                               VALUES(@action,@adminID,@admindate,@staID,@staffID,@start,@end,@authID,@authorisor,@authOK,@authdate,@approver,@apprvOK,@apprvdate ,@nodeID)
      
       
   
END
