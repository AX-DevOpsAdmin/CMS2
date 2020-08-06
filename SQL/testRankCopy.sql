

DECLARE @nodeID INT
DECLARE @staffID INT
DECLARE @postID INT
DECLARE @rankID INT
DECLARE @stRankID INT
DECLARE @shortDesc VARCHAR(50)

SET @nodeID=3

-- get rid of the redundant ranks

DELETE FROM tblRank 
   WHERE NOT EXISTS(SELECT staffID FROM tblStaff WHERE tblStaff.rankID=tblRank.rankID)

-- check to see what is missing from existing tblRank
SELECT * FROM tblRank T1 
    WHERE T1.ndeID=@nodeID AND NOT EXISTS(SELECT rankID FROM tblRank T2 WHERE T2.shortDesc=T1.shortDesc AND T2.ndeID=1)

-- now add them 
INSERT INTO tblRank (shortDesc, description, status,Weight, weightScore, ndeID)
    SELECT shortDesc, description, status,Weight,weightScore, 1 FROM tblRank T1 
    WHERE T1.ndeID=@nodeID AND NOT EXISTS(SELECT rankID FROM tblRank T2 WHERE T2.shortDesc=T1.shortDesc AND T2.ndeID=1)
  
UPDATE tblStaff
   SET rankID = (SELECT rankID FROM tblRank T1 WHERE t1.ndeID=1 AND T1.shortDesc =(SELECT shortDesc FROM tblRank T2 WHERE T2.rankID=tblStaff.rankID ))
     WHERE tblStaff.ndeID=@nodeID
       
UPDATE tblPost
   SET rankID = (SELECT rankID FROM tblRank T1 WHERE t1.ndeID=1 AND T1.shortDesc =(SELECT shortDesc FROM tblRank T2 WHERE T2.rankID=tblPost.rankID ))
     WHERE tblPost.ndeID=@nodeID

/*
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

 

    
