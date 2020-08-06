

DECLARE @qt VARCHAR(50)
DECLARE @desc  VARCHAR(50)
DECLARE @recID INT

TRUNCATE TABLE tblQTypes

SET @recID=1

        DECLARE cur1 CURSOR SCROLL
		 FOR
		   SELECT [Q Type] FROM Qs$
              
		   OPEN cur1
		   FETCH FIRST FROM cur1 INTO  @qt
           
           WHILE @@FETCH_STATUS=0
            BEGIN
             
             IF NOT EXISTS (SELECT description FROM tblQTypes WHERE description=@qt)
              BEGIN
               INSERT INTO tblQTypes (QtypeID, description,auth,ndeID)
                   SELECT @recID, @qt,0,0
                   
               SET @recID=@recID+1
              END
              
             FETCH NEXT FROM cur1 INTO  @qt
            END
			 
		 CLOSE cur1
		 DEALLOCATE cur1