

DECLARE @short VARCHAR(50)
DECLARE @desc  VARCHAR(50)
DECLARE @rnkID INT

TRUNCATE TABLE tblRank

SET @rnkID=1

        DECLARE rank1 CURSOR SCROLL
		 FOR
		   SELECT shortDesc, description
             FROM Ranks$
              
		   OPEN rank1
		   FETCH FIRST FROM rank1 INTO  @short, @desc
           
           WHILE @@FETCH_STATUS=0
            BEGIN
             SELECT @short, @desc
             IF NOT EXISTS (SELECT shortDesc FROM tblRank WHERE shortDesc=@short)
               BEGIN
                 INSERT INTO tblRank (rankID, shortDesc, description,status, Weight, weightScore,ndeID)
                               SELECT @rnkID, @short,@desc,1,0,0,0
                 SET @rnkID=@rnkID + 1
               END
                   
              
             FETCH NEXT FROM rank1 INTO  @short, @desc
            END
			 
		 CLOSE rank1
		 DEALLOCATE rank1