

DECLARE @tg VARCHAR(50)
DECLARE @trade VARCHAR(50)
DECLARE @srvNo  VARCHAR(50)
DECLARE @fname  VARCHAR(50)
DECLARE @sname  VARCHAR(50)
DECLARE @rank  VARCHAR(50)
DECLARE @gender  VARCHAR(50)
DECLARE @date DATETIME
DECLARE @recID INT
DECLARE @tradeID INT
DECLARE @rankID INT
DECLARE @genID INT

TRUNCATE TABLE tblStaff

SET @recID=1

        --INSERT INTO tblStaff (serviceNo, firstname,surname)
         --    SELECT [service no], [first name], surname FROM Personnel$

        DECLARE cur1 CURSOR SCROLL
		 FOR
		   SELECT [service no], [first name], surname,[rank], Trade, [Trade Group], [arrival date] FROM Personnel$
		     WHERE [Service No] IS NOT NULL
              
		   OPEN cur1
		   FETCH FIRST FROM cur1 INTO @srvNo, @fname,@sname,@rank,@trade,@tg, @date
           
           WHILE @@FETCH_STATUS=0
            BEGIN
             
             SET @tradeID = (SELECT tradeID FROM tblTrade WHERE description=@trade)
             SET @rankID = (SELECT rankID FROM tblRank WHERE shortDesc=@rank)
             SET @genID=1
             IF @gender <>'Male' SET @genID=0  
               
             INSERT INTO tblStaff (serviceNo, firstname,surname,rankID,tradeID,sex, arrivaldate, administrator,remedial,active,taskOOA, CMSAdministrator, ndeID)
                               SELECT @srvNo, @fname, @sname, @rankID, @tradeID, @genID, @date , 0, 0, 0, 0, 0, 0
                 SET @recID=@recID + 1
              
                   
             FETCH NEXT FROM cur1 INTO  @srvNo, @fname,@sname,@rank,@trade,@tg, @date
            END
			 
		 CLOSE cur1
		 DEALLOCATE cur1