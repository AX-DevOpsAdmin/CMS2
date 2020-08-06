

DECLARE @tg VARCHAR(50)
DECLARE @trade VARCHAR(50)
DECLARE @srvNo  VARCHAR(50)
DECLARE @recID INT
DECLARE @tgID INT

TRUNCATE TABLE tblTrade

SET @recID=1

        DECLARE cur1 CURSOR SCROLL
		 FOR
		   SELECT Trade, [Trade Group], [Service No] FROM Personnel$
		     WHERE [Service No] IS NOT NULL
              
		   OPEN cur1
		   FETCH FIRST FROM cur1 INTO  @trade, @tg, @srvNo
           
           WHILE @@FETCH_STATUS=0
            BEGIN
             
             IF NOT EXISTS (SELECT description FROM tblTrade WHERE description=@trade)
               BEGIN
               SET @tgID=(SELECT tradeGroupID FROM tblTradeGroup WHERE tblTradeGroup.description=@tg)
                 INSERT INTO tblTrade (tradeID,description, tradeGroupID,ndeID)
                               SELECT @recID, @trade,@tgID,0
                 SET @recID=@recID + 1
               END
                   
             FETCH NEXT FROM cur1 INTO  @trade, @tg, @srvNo
            END
			 
		 CLOSE cur1
		 DEALLOCATE cur1