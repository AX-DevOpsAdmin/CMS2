


/**

 This will delete ALL the data relating to RAF Leeming
 From the 607CMS database - leaving a 607CMS application ready to go
 NB: ABSOLUTELY MUST do the following FIRST
 
 1. Backup the LeemingCMS Dbase
 2. Restore the LeemingCMS backup into the 607CMS Dbase
 3. Run this script
 4. Test the 607CMS App and make sure LogOn works
  
 5. DO THIS BEFORE RUNNING THE 607RemoveData script
 
**/

USE [607CMS]
GO
-- First remove all Hierarchy that is not 607
SELECT * FROM  tblHierarchy  WHERE hrcID<31 

DELETE FROM tblHierarchy  WHERE hrcID<31

GO
-- Now get rid of all posts that do not have a Hierarchy 
SELECT * FROM tblpost
   WHERE NOT EXISTS (SELECT hrcID FROM tblHierarchy WHERE tblHierarchy.hrcID=tblPost.hrcID)
     ORDER by tblpost.hrcID DESC
  -- WHERE  tblPOst.hrcID>31
  
DELETE FROM tblpost
   WHERE NOT EXISTS (SELECT hrcID FROM tblHierarchy WHERE tblHierarchy.hrcID=tblPost.hrcID)
GO
   
-- Post Military Skills
SELECT * FROM tblPostMilSkill
    WHERE NOT EXISTS (SELECT postID FROM tblPost WHERE tblPost.postID=tblPostMilSkill.postID)
 
DELETE FROM tblPostMilSkill
    WHERE NOT EXISTS (SELECT postID FROM tblPost WHERE tblPost.postID=tblPostMilSkill.postID)
GO
         
-- Post Q's
SELECT * FROM tblPostQs
    WHERE NOT EXISTS (SELECT postID FROM tblPost WHERE tblPost.postID=tblPostQs.postID)
 
DELETE FROM tblPostQs
    WHERE NOT EXISTS (SELECT postID FROM tblPost WHERE tblPost.postID=tblPostQs.postID)
GO
         
-- NOW get rid of the StaffPosts
SELECT * FROM tblStaffPost
    WHERE NOT EXISTS (SELECT postID FROM tblPost WHERE tblPost.postID=tblStaffPost.postID)
 
DELETE FROM tblStaffPost
    WHERE NOT EXISTS (SELECT postID FROM tblPost WHERE tblPost.postID=tblStaffPost.postID)
GO         
        
-- tblStaff currently in post  
SELECT  *  FROM tblStaff
     WHERE  NOT EXISTS (SELECT TOP 1 staffPostID FROM tblStaffPost WHERE tblStaffPost.StaffID=tblStaff.staffID)
     ORDER BY staffID DESC

DELETE FROM tblStaff
     WHERE  NOT EXISTS (SELECT TOP 1 staffPostID FROM tblStaffPost WHERE tblStaffPost.StaffID=tblStaff.staffID)
GO
   
-- Passwords
SELECT * FROM tblPassword
      WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblPassword.staffID)
     ORDER BY tblPassword.staffID
  
DELETE FROM tblPassword
      WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblPassword.staffID)   
GO
    
-- Dental     
SELECT * FROM tblStaffDental
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblStaffDental.staffID)   
     ORDER BY tblStaffDental.staffID
 
DELETE FROM tblStaffDental
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblStaffDental.staffID)   
GO

 ---- Fitness    
 SELECT * FROM tblStaffFitness
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblStaffFitness.staffID)   
     ORDER BY tblStaffFitness.staffID
 
DELETE FROM tblStaffFitness
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblStaffFitness.staffID)   
GO
  
-- Harmony 
SELECT * FROM tblStaffHarmony
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblStaffHarmony.staffID)   
     ORDER BY tblStaffHarmony.staffID
 
DELETE FROM tblStaffHarmony
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblStaffHarmony.staffID)   
GO
     
-- Military Skills
SELECT * FROM tblStaffMilSkill
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblStaffMilSkill.staffID)   
     ORDER BY tblStaffMilSkill.staffID
 
DELETE FROM tblStaffMilSkill
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblStaffMilSkill.staffID)   
GO

-- Vaccinations 
SELECT * FROM tblStaffMVs
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblStaffMVs.staffID)   
     ORDER BY tblStaffMVs.staffID
 
DELETE FROM tblStaffMVs
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblStaffMVs.staffID)   
GO
    
-- Staff Photo
SELECT * FROM tblStaffPhoto
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblStaffPhoto.staffID)   
     ORDER BY tblStaffPhoto.staffID
 
DELETE FROM tblStaffPhoto
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblStaffPhoto.staffID)   
GO
    
-- Staff Qs
SELECT * FROM tblStaffQs
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblStaffQs.staffID)   
     ORDER BY tblStaffQs.staffID
 
DELETE FROM tblStaffQs
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tblStaffQs.staffID)   
GO
  
-- Staff Tasks 
SELECT * FROM tbl_TaskStaff
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tbl_TaskStaff.staffID)   
     ORDER BY tbl_TaskStaff.staffID
 
DELETE FROM tbl_TaskStaff
    WHERE  NOT EXISTS (SELECT TOP 1 staffID FROM tblStaff WHERE tblStaff.StaffID=tbl_TaskStaff.staffID)
GO
   
--  Tasks 
SELECT * FROM tbl_Task
    WHERE  NOT EXISTS (SELECT TOP 1 taskID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)       
 
DELETE FROM tbl_Task
    WHERE  NOT EXISTS (SELECT TOP 1 taskID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
GO

-- now reset the ndeID field in all the tables and add the details to tblNode
-- in 90SU Dbase - then add 607 staff data to tblStaffNode in 90SU Dbase using CMSMigrateStaffNode script


-- make sure the ndeID is set to correct integer it will depend on the ndeID set in 90SU tblNode on the day
-- tblNode ndeID MUST be set manually via design
exec sp_MSforeachtable 'UPDATE ? SET ndeID = 6' 
 UPDATE tblNode SET ndename='607CMS'

-- Now set up the 607CMS Administrator
UPDATE tblStaff  SET administrator=1 WHERE staffID=245

-- Now run CMS2MigrateStaffNode to add live staff to 90SU Dbase tblStaffNode
-- so they can logon

    
   


