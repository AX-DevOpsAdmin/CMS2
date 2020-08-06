/*
This will insert all staff serviceno/nodeid details from selected database
into 90SUCMS tblStaffNode . This will then be used at logon to identify the
node the user belongs to eg; Leeming and then get the DSN from 90SU tblNode
so we know which database to connect to
*/
 -- Set this to the database you want to pull Staff details from eg; 90SUCMS, RAFPCMS etc
  USE [CMS]
 
  DECLARE @ndeID INT
  DECLARE @srvNo VARCHAR(50)

  --active staff only
  DECLARE staff1 CURSOR SCROLL
	 FOR SELECT serviceNo, ndeID FROM tblStaff WHERE active= 1
		     
	 OPEN staff1
	 --FETCH FIRST FROM staff1 INTO @staffID, @srvNo, @ndeID
	 FETCH FIRST FROM staff1 INTO @srvNo, @ndeID

     WHILE @@FETCH_STATUS = 0
	   BEGIN
	     
	     INSERT INTO [90SUCMS].dbo.tblStaffNode SELECT @srvNo, @ndeID
	   
	     FETCH NEXT FROM staff1 INTO @srvNo, @ndeID
	   END

  CLOSE staff1
  DEALLOCATE staff1