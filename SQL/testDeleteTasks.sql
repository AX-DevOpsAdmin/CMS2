
USE [90SUCMS]

-- First get rid of redundant Tasks
DELETE from tbl_Task
         WHERE taskTypeID=1 AND NOT EXISTS(SELECT TOP 1 taskStaffID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
         
DELETE from tbl_Task
         WHERE taskTypeID=4 AND NOT EXISTS(SELECT TOP 1 taskStaffID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
         
DELETE from tbl_Task
         WHERE taskTypeID=12 AND NOT EXISTS(SELECT TOP 1 taskStaffID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
         
DELETE from tbl_Task
         WHERE taskTypeID=13 AND NOT EXISTS(SELECT TOP 1 taskStaffID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
         
DELETE from tbl_Task
         WHERE taskTypeID=15 AND NOT EXISTS(SELECT TOP 1 taskStaffID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
         
DELETE from tbl_Task
         WHERE taskTypeID=16 AND NOT EXISTS(SELECT TOP 1 taskStaffID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
         
DELETE from tbl_Task
         WHERE taskTypeID=17 AND NOT EXISTS(SELECT TOP 1 taskStaffID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
         
DELETE from tbl_Task
         WHERE taskTypeID=20 AND NOT EXISTS(SELECT TOP 1 taskStaffID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
         
DELETE from tbl_Task
         WHERE taskTypeID=21 AND NOT EXISTS(SELECT TOP 1 taskStaffID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
         
DELETE from tbl_Task
         WHERE taskTypeID=25 AND NOT EXISTS(SELECT TOP 1 taskStaffID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
         
DELETE from tbl_Task
         WHERE taskTypeID=38 AND NOT EXISTS(SELECT TOP 1 taskStaffID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
         
DELETE from tbl_Task
         WHERE taskTypeID=37 AND NOT EXISTS(SELECT TOP 1 taskStaffID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
         
DELETE from tbl_Task
         WHERE taskTypeID=28 AND NOT EXISTS(SELECT TOP 1 taskStaffID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
         
DELETE from tbl_Task
         WHERE taskTypeID=29 AND NOT EXISTS(SELECT TOP 1 taskStaffID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
         
-- Now clean up redundant Task Types
 DELETE FROM tblTaskType 
      WHERE NOT EXISTS (SELECT ttID FROM tbl_Task WHERE tbl_task.taskTypeID=tblTaskType.ttID)