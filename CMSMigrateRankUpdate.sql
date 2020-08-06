
-- CMSMigrateRankUpdate
-- Updates staff and post rankID's with equivalent from live database
-- this will avoid having duplicate rank tables
USE CMSMigrate

DECLARE @nodeID INT
DECLARE @staffID INT
DECLARE @postID INT
DECLARE @rankID INT
DECLARE @stRankID INT
DECLARE @shortDesc VARCHAR(50)

--SET @nodeID=3

-- sort out any duplicate ranks
-- 164 155
UPDATE tblStaff
   SET rankID = 277 WHERE rankID=286
   
-- get rid of the redundant ranks
SELECT * FROM tblRank 
   WHERE NOT EXISTS(SELECT staffID FROM tblStaff WHERE tblStaff.rankID=tblRank.rankID)

DELETE FROM tblRank 
   WHERE NOT EXISTS(SELECT staffID FROM tblStaff WHERE tblStaff.rankID=tblRank.rankID)
   
  -- 131, 136, 142, 145
   
-- check to see what is missing from existing tblRank
SELECT * FROM tblRank T1 
    WHERE  NOT EXISTS(SELECT rankID FROM CMS2.dbo.tblRank T2 WHERE T2.shortDesc=T1.shortDesc)

-- now add them 
INSERT INTO CMS2.dbo.tblRank (shortDesc, description, status,Weight, weightScore, ndeID)
    SELECT shortDesc, description, status,Weight,weightScore, 1 FROM tblRank T1 
    WHERE NOT EXISTS(SELECT rankID FROM CMS2.dbo.tblRank T2 WHERE T2.shortDesc=T1.shortDesc AND T2.ndeID=1)
  -- 164 155
UPDATE tblStaff
   SET rankID = (SELECT rankID FROM CMS2.dbo.tblRank T1 WHERE T1.shortDesc =(SELECT shortDesc FROM tblRank T2 WHERE T2.rankID=tblStaff.rankID ))
     -- WHERE tblStaff.ndeID=@nodeID
       
UPDATE tblPost
   SET rankID = (SELECT rankID FROM CMS2.dbo.tblRank T1 WHERE T1.shortDesc =(SELECT shortDesc FROM tblRank T2 WHERE T2.rankID=tblPost.rankID ))
   --  WHERE tblPost.ndeID=@nodeID

/*

SELECT * from tblPost where rankid > 35
-- now update the staff
DECLARE fld1 CURSOR SCROLL
   FOR SELECT staffID, tblStaff.rankID, shortDesc FROM tblStaff 
       INNER JOIN tblRank ON
           tblRank.rankID=tblStaff.rankID 
            WHERE tblStaff.ndeID=@nodeID
   
   OPEN fld1
   FETCH NEXT FROM fld1 INTO @staffID, @rankID, @shortDesc
       
   WHILE @@FETCH_STATUS = 0
     BEGIN
	   SET @stRankID = (SELECT rankID FROM tblRank T1 WHERE T1.ndeID=1 and T1.shortDesc=@shortDesc)
	   UPDATE tblStaff SET rankID=@stRankID WHERE staffID=@staffID
	   
	   FETCH NEXT FROM fld1 INTO @staffID, @rankID, @shortDesc
     END

CLOSE fld1
DEALLOCATE fld1

-- now update the post
DECLARE fld1 CURSOR SCROLL
   FOR SELECT postID, tblPost.rankID, shortDesc FROM tblPost 
       INNER JOIN tblRank ON
           tblRank.rankID=tblPost.rankID 
            WHERE tblPost.ndeID=@nodeID
   
   OPEN fld1
   FETCH NEXT FROM fld1 INTO @postID, @rankID, @shortDesc
       
   WHILE @@FETCH_STATUS = 0
     BEGIN
	   SET @stRankID = (SELECT rankID FROM tblRank T1 WHERE T1.ndeID=1 and T1.shortDesc=@shortDesc)
	   UPDATE tblPost SET rankID=@stRankID WHERE postID=@postID
	   --SELECT @stRankID,@shortDesc
	   FETCH NEXT FROM fld1 INTO @staffID, @rankID, @shortDesc
     END

CLOSE fld1
DEALLOCATE fld1
**/

--DELETE tblRank WHERE ndeID > 1

 

    
