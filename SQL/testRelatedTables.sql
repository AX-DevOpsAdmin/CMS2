
/**
select * from tblstaff  WHERE staffID= 53

select * from tblstaffQs WHERE staffID= 53

select * from tblstaffPost WHERE staffID= 53

select * from tbl_TaskStaff WHERE staffID= 53

select * from tblStaffFitness WHERE staffID= 53

select * from tblStaffDental WHERE staffID= 53

select * from tblStaffMilSkill WHERE staffID= 53

select * from tblStaffMVs WHERE staffID= 53


select * from tblPost where postid= 8

SELECT * from tblteam where teamID=211
**/

select * from tblwing   
   inner join tblgroup ON tblgroup.grpid=tblwing.grpid

select * from tblSquadron   
   inner join tblwing ON tblSquadron.wingID=tblwing.wingID

select * from tblflight where sqnID = 152

select * from tblteam where teamin = 3 and parentid=39

select * from tblPost where teamID= 67

