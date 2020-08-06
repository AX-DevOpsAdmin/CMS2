

DECLARE @nodeID INT
DECLARE @surname	VARCHAR(50)
DECLARE @firstname	VARCHAR(50)
DECLARE @serviceno	VARCHAR(50)
--DECLARE @TaskID	INT
DECLARE @hrcID	INT
DECLARE @pQ1		INT
DECLARE @pQ2		INT
DECLARE @pQ3		INT

SET @nodeID=1
--SET @TaskID=2222
SET @hrcID=0

IF @surname IS NULL
	BEGIN
 		SET @surname = '%'
	END

IF @firstname IS NULL
	BEGIN
 		SET @firstname = '%'
	END

IF @serviceno IS NULL
	BEGIN
 		SET @serviceno = '%'
	END

DECLARE @exist VARCHAR(2000)
DECLARE @str VARCHAR(2000)

SET @str = 'SELECT tblStaff.staffID, surname, firstname, serviceno,'
SET @str = @str + 'tblStaff.dischargeDate AS startReset, tblStaff.ddooa AS ooadays,'
SET @str = @str + ' tblStaff.ddssa AS ssadays,tblStaff.ddssb AS ssbdays, tblStaff.lastOOA FROM tblStaff '
SET @str = @str + 'INNER JOIN tblStaffPost ON tblStaffPost.StaffID = tblStaff.staffID  '
SET @str = @str + 'INNER JOIN tblPost ON tblPost.postID = tblStaffPost.PostID  '
SET @str = @str + 'INNER JOIN tblHierarchy ON tblHierarchy.hrcID = tblPost.hrcID '
SET @str = @str + 'WHERE  tblStaff.ndeID=' + CONVERT(VARCHAR(10),@nodeID) + ' AND tblPost.Ghost =0  AND '
SET @str = @str + '((Active = 1 AND endDate IS NULL) OR enddate > GETDATE()) AND '
SET @str = @str + ' surname LIKE ' + '''' + @surname +'%' + '''' + ' AND firstname LIKE ' + '''' + @firstname +'%'+  '''' + ' AND serviceno LIKE ' + '''' + @serviceno +'%'+  ''''

SELECT @str
IF @hrcID <> 0 
	BEGIN
		SET @str = @str + ' AND tblHierarchy.hrcID= ' + CONVERT(VARCHAR(10),@hrcID) + ' AND enddate IS NULL '
	END
-- build up the query to searcg for Qs
SET @exist = ' '

IF @pQ1 <> 0
	BEGIN 
		SET @exist = @exist + ' AND EXISTS (SELECT staffQID FROM tblStaffQs WHERE tblStaffQs.staffID = staffNo' 
		SET @exist = @exist + ' AND tblStaffQs.qID= ' +  CONVERT(VARCHAR(10),@pQ1) + ' AND tblStaffQs.typeID = 1  '
		SET @exist = @exist + ' AND tblStaffQs.validfrom < ' + '''' + CONVERT(VARCHAR(12),GETDATE())  + ''''
		SET @exist = @exist + ' AND (validend is NULL OR tblStaffQs.validend > ' + '''' + CONVERT(VARCHAR(12),GETDATE()) + '''' + ')' 
		SET @exist = @exist + ')' 
	END

IF @pQ2 <> 0 
	BEGIN 
		SET @exist = @exist + ' AND EXISTS (SELECT staffQID FROM tblStaffQs WHERE tblStaffQs.staffID = staffNo' 
		SET @exist = @exist + ' AND tblStaffQs.qID= ' + CONVERT(VARCHAR(10),@pQ2) + ' AND tblStaffQs.typeID = 1  '
		SET @exist = @exist + ' AND tblStaffQs.validfrom < ' + '''' + CONVERT(VARCHAR(12),GETDATE()) + ''''
		SET @exist = @exist + ' AND (validend is NULL OR tblStaffQs.validend > ' + '''' + CONVERT(VARCHAR(12),GETDATE()) + '''' + ')' 
		SET @exist = @exist + ')' 
  END

IF @pQ3 <> 0 
	BEGIN 
		SET @exist = @exist + ' AND EXISTS (SELECT staffQID FROM tblStaffQs WHERE tblStaffQs.staffID = staffNo' 
		SET @exist = @exist + ' AND tblStaffQs.qID= ' + CONVERT(VARCHAR(10),@pQ3) + ' AND tblStaffQs.typeID = 1  '
		SET @exist = @exist + ' AND tblStaffQs.validfrom < ' + '''' + CONVERT(VARCHAR(12),GETDATE()) + ''''
		SET @exist = @exist + ' AND (validend is NULL OR tblStaffQs.validend > ' + '''' + CONVERT(VARCHAR(12),GETDATE()) + '''' + ')' 
		SET @exist  =@exist + ')' 
	END

-- now add on the EXISTS clause
IF @exist <> ' '
  SET @str = @str + @exist

SET @str = @str + ' ORDER BY lastooa, surname'

--EXEC(@str)

SELECT @str
