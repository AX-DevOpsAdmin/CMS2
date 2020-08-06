

DECLARE @StaffID	INT
DECLARE @PostID	INT

SET DATEFORMAT dmy

SET @StaffID=1375
SET @PostID=1181

SELECT tblQs.QID, tblQs.Description, tblStaff.staffID, tblStaffQs.StaffQID, tblValPeriod.vpdays, tblQs.Amber, 
       tblStaffQs.ValidFrom, tblStaffQs.Competent, tblPostQs.QID AS req
  FROM tblStaff  
     INNER JOIN tblStaffQs ON tblStaffQs.StaffID=tblStaff.staffID
     INNER JOIN tblQs ON tblQs.QID=tblStaffQs.qID
     INNER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
     LEFT OUTER JOIN tblPostQs ON TblPostQs.PostID=@PostID AND TblPostQs.QID=tblStaffQs.QID  
  WHERE tblStaff.staffID=@staffID
 /** 
UNION

SELECT tblQs.QID, tblQs.Description, tblStaff.staffID, tblStaffQs.StaffQID, tblValPeriod.vpdays, tblQs.Amber, 
       tblStaffQs.ValidFrom, tblStaffQs.Competent,0 AS reqd
  FROM tblStaff  
     INNER JOIN tblStaffQs ON tblStaffQs.StaffID=tblStaff.staffID
     INNER JOIN tblQs ON tblQs.QID=tblStaffQs.qID
     INNER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
     LEFT OUTER JOIN tblPostQs ON TblPostQs.PostID=@PostID AND TblPostQs.QID=tblStaffQs.QID  
  WHERE tblStaff.staffID=@staffID 
        AND NOT EXISTS (SELECT QID FROM tblPostQs WHERE TblPostQs.QID=tblStaffQs.QID )
    **/
    
    IF EXISTS 