USE [CMS2]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateAuthorised]    Script Date: 05/24/2016 11:21:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[spUpdateAuthorised]
(
    @staffID INT,   
	@authList VARCHAR(200),
	@apprvList VARCHAR(200)
)

AS

DECLARE @start INT
DECLARE @end INT
DECLARE @len INT
DECLARE @num INT
DECLARE @len1 INT
DECLARE @num1 INT
DECLARE @str VARCHAR(50)

DECLARE @staID INT
DECLARE @apprvID INT

-- NB: We change the adminID of the tblStaffAuths to the staffID of whoever is updating the record
-- so that we can create a proper audit trail of who made the changes. In reality this should be
-- either authorisor or approver because when the record was either created - set authorisor - or authorised - set approver
-- therefore whoever triggered this stored procedure MUST be either the authorisor or approver cos
-- otherwise they couldn't see the details on the web page

-- first do any authorisations
SET @len = (SELECT LEN(@authList))
SET @start=1

SET @num = 0
WHILE @num < @len
 BEGIN
   SET @num = (SELECT CHARINDEX(',', @authList, @start))
 
   IF @num =0
    BEGIN
       SET @num = @len + 1
       SET @str = SUBSTRING(@authList, @start, @end ) 
    END
   ELSE
    BEGIN
      SET @end = @num - @start
      SET @str = SUBSTRING(@authList, @start, @end) 
       SET @start= @num+1
    END
    
    SET @len1 = (SELECT LEN(@str))
    SET @num1 = (SELECT CHARINDEX('|', @str, 1))
    
    -- the first number is the recid of tblStaffAuths record we are updating
    SET @staID = SUBSTRING(@str, 1, (@num1 -1) ) 
    
    -- the second number is the staffID of the person who will Approve the Authorisation
    SET @apprvID = SUBSTRING(@str, @num1 +1,(@len1 - @num1) ) 
    --SELECT @str, @staID,@apprvID
    
    -- now we can update the tblStaffAuths record
    UPDATE tblStaffAuths
       SET adminID=@staffID,
           authOK=1,
           authdate=GETDATE(),
           approver=@apprvID
           WHERE tblStaffAuths.staID=@staID 
 END
 
 
 -- now do any approvals
SET @len = (SELECT LEN(@apprvList))
SET @start=1

SET @num = 0
WHILE @num < @len
 BEGIN
   SET @num = (SELECT CHARINDEX(',', @apprvList, @start))
   
   IF @num =0
    BEGIN
       SET @num = @len + 1
       SET @staID = @apprvList
    END
   ELSE
    BEGIN
      SET @end = @num - @start
      SET @staID = SUBSTRING(@apprvList, @start, @end) 
       SET @start= @num+1
    END
    
    SET @len1 = (SELECT LEN(@str))
    
    -- now we can update the tblStaffAuths record
    UPDATE tblStaffAuths
       SET adminID=@staffID,
           apprvOK=1,
           apprvdate=GETDATE()
           WHERE tblStaffAuths.staID=@staID 
 END