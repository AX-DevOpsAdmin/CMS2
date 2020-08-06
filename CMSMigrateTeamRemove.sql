
-- CMSMigrateTeamRemoval
-- Gets rid of redundant Teams before migration

USE CMSMigrate

GO 
-- first check the Wing teams
IF EXISTS ( SELECT TOP 1 t1.teamID FROM tblTeam AS t1 WHERE NOT EXISTS(SELECT t2.wingID FROM tblWing AS t2 WHERE t2.wingID = t1.parentid)
            AND t1.teamin=1)
  BEGIN
     DELETE FROM tblTeam WHERE NOT EXISTS(SELECT wingID FROM tblWing WHERE wingID = tblTeam.parentid)
              AND tblTeam.teamin=1
  END

  
-- Next the Squadron teams
IF EXISTS ( SELECT TOP 1 t1.teamID FROM tblTeam AS t1 WHERE NOT EXISTS(SELECT t2.sqnID FROM tblSquadron AS t2 WHERE t2.sqnID = t1.parentid)
            AND t1.teamin=2)
  BEGIN
     DELETE FROM tblTeam WHERE NOT EXISTS(SELECT sqnID FROM tblSquadron WHERE sqnID = tblTeam.parentid)
       AND tblTeam.teamin=2
  END
  
-- next the Flight teams
IF EXISTS ( SELECT TOP 1 t1.teamID FROM tblTeam AS t1 WHERE NOT EXISTS(SELECT t2.fltID FROM tblFlight AS t2 WHERE t2.fltID = t1.parentid)
            AND t1.teamin=3)
  BEGIN 
    DELETE FROM tblTeam WHERE NOT EXISTS(SELECT fltID FROM tblFlight WHERE fltID = tblTeam.parentid)
      AND tblTeam.teamin=3
  END
 
-- next the Teams
IF EXISTS ( SELECT TOP 1 t1.teamID FROM tblTeam AS t1 WHERE NOT EXISTS(SELECT t2.teamID FROM tblTeam AS t2 WHERE t2.teamID = t1.parentid)
            AND t1.teamin=4)
  BEGIN
       DELETE FROM tblTeam WHERE NOT EXISTS(SELECT t2.teamid FROM tblTeam AS t2 WHERE t2.teamID = tblTeam.parentid)
          AND tblTeam.teamin=4
  END

-- Now the sub Teams
IF EXISTS ( SELECT TOP 1 t1.teamID FROM tblTeam AS t1 WHERE NOT EXISTS(SELECT t2.teamID FROM tblTeam AS t2 WHERE t2.teamID = t1.parentid)
            AND t1.teamin=5)
  BEGIN
    DELETE FROM tblTeam WHERE NOT EXISTS(SELECT t2.teamid FROM tblTeam AS t2 WHERE t2.teamID = tblTeam.parentid)
          AND tblTeam.teamin=5
  END  
 
   
GO

-- now clear the orphaned tblPost enrtries
DELETE FROM tblPost WHERE NOT EXISTS (SELECT teamID FROM tblTeam WHERE tblTeam.teamID=tblPost.teamID)
   
GO
   
-- now clear the orphaned tblStaffPost enrtries
DELETE FROM tblStaffPost WHERE NOT EXISTS (SELECT postID FROM tblPost WHERE tblPost.postID =tblStaffPost.postID)

DELETE FROM tblStaffPost WHERE NOT EXISTS (SELECT staffID FROM tblStaff WHERE tblStaff.staffID =tblStaffPost.staffID)