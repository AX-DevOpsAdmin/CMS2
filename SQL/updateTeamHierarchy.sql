USE CMS2
GO

/**
SELECT postID, tblPost.teamID, tblPost.hrcID, tblHierarchy.teamID
   FROM tblPost
      INNER JOIN tblHierarchy ON tblHierarchy.teamID = tblPost.teamID
	    ORDER BY tblPost.teamID
**/

-- Update hrcID in relevant related tables so we can link them to tblHierarchy and NOT tblTeam
UPDATE tblPost
   SET tblPost.hrcID =  (SELECT tblHierarchy.hrcID FROM tblHierarchy WHERE tblHierarchy.teamID = tblPost.teamID )
         WHERE EXISTS(SELECT tblHierarchy.teamID FROM tblHierarchy WHERE tblHierarchy.teamID = tblPost.teamID )
  
  GO

  UPDATE tblTeamHierarchy
   SET tblTeamHierarchy.hrcID = (SELECT tblHierarchy.hrcID FROM tblHierarchy WHERE tblHierarchy.teamID = tblTeamHierarchy.teamID)
        WHERE EXISTS(SELECT tblHierarchy.teamID FROM tblHierarchy WHERE tblHierarchy.teamID = tblTeamHierarchy.teamID )

  --SELECT teamID, hrcID FROM tblTeamHierarchy ORDER BY hrcID
   GO

   UPDATE tblOpTeam
   SET tblOpTeam.hrcID = (SELECT tblHierarchy.hrcID FROM tblHierarchy WHERE tblHierarchy.teamID = tblOpTeam.teamID)
        WHERE EXISTS(SELECT tblHierarchy.teamID FROM tblHierarchy WHERE tblHierarchy.teamID = tblOpTeam.teamID )
  -- SELECT teamID, hrcID FROM tblOpTeam

   GO

   UPDATE tbl_TaskUnit
   SET tbl_TaskUnit.hrcID = (SELECT tblHierarchy.hrcID FROM tblHierarchy WHERE tblHierarchy.teamID = tbl_TaskUnit.teamID)
         WHERE EXISTS(SELECT tblHierarchy.teamID FROM tblHierarchy WHERE tblHierarchy.teamID = tbl_TaskUnit.teamID )
  -- SELECT teamID, hrcID FROM tbl_TaskUnit