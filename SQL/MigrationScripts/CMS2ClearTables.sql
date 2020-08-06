
USE CMS2

GO

EXEC sp_MSforeachtable 'TRUNCATE TABLE ?'