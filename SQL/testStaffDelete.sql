

DECLARE @staffID INT

DECLARE @servno VARCHAR(50)

--SET @staffID=131

SET @servno='30084588'

select * from tblStaff where serviceno= @servno

SET @staffID=(select staffID from tblStaff where serviceno= @servno)

select * from tblStaffPost where StaffID= @staffID

--select * from tblPost where postID= @staffID

--select *  from tbl_TaskStaff where StaffID= @staffID


/*
DELETE from tblStaffDental where StaffID= @staffID
DELETE from tblStaffFitness where StaffID= @staffID
DELETE from tblStaffHarmony where StaffID= @staffID
DELETE from tblStaffMilSkill where StaffID= @staffID
DELETE from tblStaffPhoto where StaffID= @staffID

DELETE from tblStaffQs where StaffID= @staffID
DELETE from tblStaffMVs where StaffID= @staffID
DELETE from tbl_TaskStaff where StaffID= @staffID
DELETE from tblStaffPost where StaffID= @staffID

DELETE from tblStaff where StaffID= @staffID
*/