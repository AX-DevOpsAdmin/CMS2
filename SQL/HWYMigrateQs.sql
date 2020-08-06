

DECLARE @q VARCHAR(50)
DECLARE @qt VARCHAR(50)
DECLARE @vp  VARCHAR(50)
DECLARE @recID INT
DECLARE @qtID INT
DECLARE @vpID INT

TRUNCATE TABLE tblQs

SET @recID=1

        DECLARE cur1 CURSOR SCROLL
		 FOR
		   SELECT [description], [q type], [validity period] FROM Qs$
              
		   OPEN cur1
		   FETCH FIRST FROM cur1 INTO  @q, @qt, @vp
           
           WHILE @@FETCH_STATUS=0
            BEGIN
             
             IF NOT EXISTS (SELECT description FROM tblQs WHERE description=@q)
               BEGIN
				   SET @qtID=(SELECT QTypeID FROM tblQTypes WHERE description=@qt)
				   SET @vpID=(SELECT vpID FROM tblValPeriod WHERE description=@vp)
					 INSERT INTO tblQs ([QID],[Description],[QTypeID],[vpID],[Amber],[Enduring],[Contingent],[LongDesc],  ndeID)
								   SELECT @recID, @q, @qtID, @vpID,0,0,0,@q,0
				   SET @recID=@recID + 1
               END
                   
             FETCH NEXT FROM cur1 INTO  @q, @qt, @vp
            END
			 
		 CLOSE cur1
		 DEALLOCATE cur1