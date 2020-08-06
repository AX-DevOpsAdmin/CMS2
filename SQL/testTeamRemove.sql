
USE CMSMigrate

select * from tblTeam AS t1 where not exists(select t2.teamid from tblTeam AS t2 where t2.teamID = t1.parentid)
  and t1.teamin=5
  
select * from tblTeam AS t1 where not exists(select t2.teamid from tblTeam AS t2 where t2.teamID = t1.parentid)
  and t1.teamin=4
  
select * from tblTeam AS t1 where not exists(select t2.fltID from tblFlight AS t2 where t2.fltID = t1.parentid)
  and t1.teamin=3
  
 select * from tblTeam AS t1 where not exists(select t2.sqnID from tblSquadron AS t2 where t2.sqnID = t1.parentid)
  and t1.teamin=2
   
  select * from tblTeam AS t1 where not exists(select t2.wingID from tblWing AS t2 where t2.wingID = t1.parentid)
  and t1.teamin=1
   
   
  select * from tblPost where not exists(select teamID FROM tblTeam WHERE tblTeam.teamID=tblPost.teamID)
  
  SELECT * FROM tblStaffPost WHERE NOT EXISTS (SELECT postID FROM tblPost WHERE tblPost.postID =tblStaffPost.postID)
    ORDER BY postID , endDate DESC
  
