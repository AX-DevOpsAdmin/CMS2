

SELECT * FROM tblTeam AS t1 WHERE NOT EXISTS(SELECT t2.wingID FROM tblWing AS t2 WHERE t2.wingID = t1.parentid)
            AND t1.teamin=1

SELECT * FROM tblTeam AS t1 WHERE NOT EXISTS(SELECT t2.sqnID FROM tblSquadron AS t2 WHERE t2.sqnID = t1.parentid)
            AND t1.teamin=2
            
 SELECT * FROM tblTeam AS t1 WHERE NOT EXISTS(SELECT t2.fltID FROM tblFlight AS t2 WHERE t2.fltID = t1.parentid)
            AND t1.teamin=3
            
SELECT  * FROM tblTeam AS t1 WHERE NOT EXISTS(SELECT t2.teamID FROM tblTeam AS t2 WHERE t2.teamID = t1.parentid)
            AND t1.teamin=4
            
SELECT  * FROM tblTeam AS t1 WHERE NOT EXISTS(SELECT t2.teamID FROM tblTeam AS t2 WHERE t2.teamID = t1.parentid)
            AND t1.teamin=5
            
SELECT  *  FROM tblPost WHERE NOT EXISTS (SELECT teamID FROM tblTeam WHERE tblTeam.teamID=tblPost.teamID)

SELECT * FROM tblStaffPost WHERE NOT EXISTS (SELECT postID FROM tblPost WHERE tblPost.postID =tblStaffPost.postID)

SELECT * FROM tblStaffPost WHERE NOT EXISTS (SELECT staffID FROM tblStaff WHERE tblStaff.staffID =tblStaffPost.staffID)