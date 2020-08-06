


--SELECT * from tblstaff where surname = 'butterfield'

declare @staffid INT

set @staffid = 540

select * from tblStaff where StaffID=@staffid
select * from tblStaffPost where StaffID=@staffid
select * from tbl_taskStaff where StaffID=@staffid
select * from tblStaffQs where StaffID=@staffid
select * from tblStaffFitness where StaffID=@staffid
select * from tblStaffDental where StaffID=@staffid
select * from tblStaffMVs where StaffID=@staffid
select * from tblStaffMilSkill where StaffID=@staffid
select * from tblStaffPhoto where StaffID=@staffid
select * from tblPassword where staffID =@staffID
select * from tblStaffHarmony where StaffID=@staffid


DELETE tblStaffPost where StaffID=@staffid
DELETE tbl_taskStaff where StaffID=@staffid
DELETE tblStaffQs where StaffID=@staffid
DELETE tblStaffFitness where StaffID=@staffid
DELETE tblStaffDental where StaffID=@staffid
DELETE tblStaffMVs where StaffID=@staffid
DELETE tblStaffMilSkill where StaffID=@staffid
DELETE tblStaffPhoto where StaffID=@staffid
DELETE tblPassword where StaffID=@staffid
DELETE tblStaffHarmony where StaffID=@staffid
DELETE tblStaff where StaffID=@staffid


