
USE CMS

GO
-- exec sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT DF__tblTask__ndeID__1EC55570'
-- exec sp_MSforeachtable 'ALTER TABLE ? DROP COLUMN ndeID '

ALTER TABLE tblPassword
  ADD pswd VARCHAR(32)
ALTER TABLE tblPassword
  ADD dPswd VARCHAR(32)
ALTER TABLE tblPassword
  ADD expires DATETIME

GO

SET DATEFORMAT DMY

DECLARE @pswdExpDate DATETIME
DECLARE @pswdExp INT
--SET @error = 0
SET @pswdExp = 90 -- Days till expiry / 

SET @pswdExpDate =  convert(DATETIME,(convert(VARCHAR(10),getDate()+ @pswdExp,3)))

BEGIN
	UPDATE tblPassword
	SET pswd = (SELECT substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', staffpw)),3,32)), expires = @pswdExpDate, dPswd = ''

END


