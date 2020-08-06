USE[BOULMERCMS]

ALTER TABLE dbo.tblPassword ADD
	pswd varchar(32) NULL,
	dPswd varchar(32) NULL,
	expires datetime NULL
GO

DECLARE CURSORNAME CURSOR
FOR 

--SELECT statement to loop through goes here

SELECT staffID, staffpw FROM tblPassword 

OPEN CURSORNAME 

-- Declare your variables to host the selected firelds from the select statement

DECLARE @staffID INT
DECLARE @staffpw VARCHAR(100)

FETCH NEXT FROM CURSORNAME INTO @staffID, @staffpw
WHILE @@FETCH_STATUS = 0

BEGIN
	--This is where you can test, manipulate and store results of the data 
	--for each row in the select statement as it loops through.
	
	UPDATE tblPassword
	SET pswd = (select substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', @staffpw)),3,32)), 
	--dPswd = (select substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', @staffpw)),3,32)),
	dPswd = '',
	expires = GETDATE()+180
	WHERE tblPassword.staffID = @staffID

	FETCH NEXT FROM CURSORNAME INTO @staffID, @staffpw
END

CLOSE CURSORNAME 
DEALLOCATE CURSORNAME 