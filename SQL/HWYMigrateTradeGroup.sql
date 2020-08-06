

DECLARE @short VARCHAR(50)
DECLARE @srvNo  VARCHAR(50)
DECLARE @recID INT

TRUNCATE TABLE tblTradeGroup

SET @recID=1

        DECLARE cur1 CURSOR SCROLL
		 FOR
		   SELECT [Trade Group], [Service No] FROM Personnel$
		     WHERE [Service No] IS NOT NULL
              
		   OPEN cur1
		   FETCH FIRST FROM cur1 INTO  @short, @srvNo
           
           WHILE @@FETCH_STATUS=0
            BEGIN
             
             IF NOT EXISTS (SELECT tradeGroup FROM tblTradeGroup WHERE description=@short)
               BEGIN
                 INSERT INTO tblTradeGroup (tradeGroupID, tradeGroup, description,ndeID)
                               SELECT @recID, @recID,@short,0
                 SET @recID=@recID + 1
               END
                   
              
             FETCH NEXT FROM cur1 INTO  @short, @srvNo
            END
			 
		 CLOSE cur1
		 DEALLOCATE cur1