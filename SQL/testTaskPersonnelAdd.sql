

/***
	@taskID			INT,
	@serviceNo			VARCHAR(50),
	@currentUser			INT,
	@StartDate			VARCHAR(50),
	@EndDate			VARCHAR(50),
	@notes				VARCHAR(2000),
	@id				INT,
	@flag				INT

**/
DECLARE 	@taskID		INT
DECLARE     @staffID		INT
DECLARE 	@ooadays		INT
DECLARE 	@currentUser		INT
DECLARE 	@StartDate		VARCHAR(50)
DECLARE 	@ENDDate		VARCHAR(50)
DECLARE 	@notes			VARCHAR(2000)
DECLARE 	@id			INT
DECLARE 	@Flag			INT
DECLARE 	@nodeID INT


SET DATEFORMAT dmy

--Update Task 21 ** 154 * 526049J * 0 * 1375 * 06/10/2015 * 07/10/2015 * * 297088 * 1
SET @taskID=154
SET @staffID=1375
SET @ooadays=0
SET @currentUser=1375
SET @StartDate='06/10/2015'
SET @endDate=' 06/10/2015'
--SET @notes = 'Test Task Update'
SET @id= 297085
SET @Flag=1
SET @nodeID=1

DECLARE @newStartDate		DATETIME
DECLARE @newEndDate		DATETIME
DECLARE @taskStartDate		DATETIME
DECLARE @taskEndDate		DATETIME
DECLARE @cancellable			INT

DECLARE @TaskStaffID		INT
DECLARE @clashTaskID		INT
DECLARE @clashStartDate		DATETIME
DECLARE @clashEndDate		DATETIME
DECLARE @clashNotes			VARCHAR(2000)
DECLARE @TestWorked		VARCHAR(50)

DECLARE @check1TaskStaffID		INT
DECLARE @check2TaskStaffID		INT
DECLARE @check3TaskStaffID		INT
DECLARE @check4TaskStaffID		INT
DECLARE @check5TaskStaffID		INT
DECLARE @check6TaskStaffID		INT

SET @check1TaskStaffID = 0
SET @check2TaskStaffID = 0
SET @check3TaskStaffID = 0
SET @check4TaskStaffID = 0
SET @check5TaskStaffID = 0
SET @check6TaskStaffID = 0

 
SET @TestWorked = 'Test1WORked'

SET @newStartDate = @Startdate/* (SELECT startDate FROM tbl_Task WHERE taskId= @taskID)*/
SET @newEndDate = @EndDate/* (SELECT ENDdate FROM tbl_Task WHERE taskId= @taskID)*/


	/*checkANDUPDATE1*/
	IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff
	WHERE active=1 AND staffId = @staffId AND @newStartDate < startDate AND @newEndDate > EndDate) OR 
	EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active =1 AND staffId = @staffId AND @newStartDate = startDate AND @newEndDate = EndDate) OR
	EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active =1 AND staffId = @staffId AND @newStartDate < startDate AND @newEndDate = EndDate) OR
	EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active =1 AND staffId = @staffId AND @newStartDate = startDate AND @newEndDate > EndDate)

	BEGIN
		UPDATE tbl_TaskStaff SET
		active = 0,
		UPDATEdBy = @currentUser,
		dateStamp = GETDATE()
		WHERE (active=1 AND staffId= @staffId AND @newStartDate < startDate AND @newEndDate > EndDate) OR
		(active=1 AND staffId= @staffId AND @newStartDate = startDate AND @newEndDate = EndDate) OR
		(active=1 AND staffId= @staffId AND @newStartDate < startDate AND @newEndDate = EndDate) OR
		(active=1 AND staffId= @staffId AND @newStartDate = startDate AND @newEndDate > EndDate)

		DELETE tbl_TaskStaff WHERE active = 0 AND staffid = @staffid
	END

IF @flag = 1
	BEGIN
		UPDATE tbl_TaskStaff SET
		active = 0
		WHERE taskStaffId = @id

		DELETE tbl_TaskStaff WHERE active = 0 AND staffid = @staffid
--		DELETE tblTaskClash WHERE userid = @currentUser
	END

/*checkANDUPDATE2*/
IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate <= startDate AND @newEndDate < EndDate AND @newEndDate >= startDate)
	BEGIN
		SET @check2TaskStaffID = (SELECT taskStaffId FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate <= startDate AND @newEndDate < EndDate AND @newEndDate >= startDate)
	END

/*checkANDUPDATE3*/
IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate > startDate AND @newStartDate <= EndDate AND @newEndDate >= EndDate)
	BEGIN
		SET @check3TaskStaffID = (SELECT taskStaffId FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate > startDate AND @newStartDate <= EndDate AND @newEndDate >= EndDate)
	END
	
/*checkANDUPDATE4*/
IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate > startDate AND @newEndDate < EndDate)
	BEGIN
		SET @check4TaskStaffID = (SELECT taskStaffID FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate > startDate AND @newEndDate < EndDate)
	END
	
/*checkANDUPDATE5*/
IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate = startDate AND @newEndDate < EndDate)
	BEGIN
		SET @check5TaskStaffID = (SELECT taskStaffID FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate = startDate AND @newEndDate < EndDate)
	END
	/*checkANDUPDATE6*/
IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate > startDate AND @newEndDate = EndDate)
	BEGIN
		SET @check6TaskStaffID = (SELECT taskStaffID FROM tbl_taskStaff WHERE active = 1 AND staffId = @staffId AND @newStartDate > startDate AND @newEndDate = EndDate)
	END

IF @check2TaskStaffID >0
	BEGIN
		UPDATE tbl_TaskStaff
		SET startDate = @newEndDate + 1, UPDATEdBy = @currentUser WHERE taskStaffId = @check2TaskStaffID
	END

IF @check3TaskStaffID > 0
	BEGIN
		UPDATE tbl_TaskStaff
		SET EndDate = @newStartDate - 1, UPDATEdBy = @currentUser WHERE taskStaffId = @check3TaskStaffID
	END

IF @check4TaskStaffID > 0
	BEGIN
		SET @clashTaskID = (SELECT taskID FROM tbl_taskStaff WHERE taskStaffID = @check4TaskStaffID)
 
		SET @clashStartDate = (SELECT startDate FROM tbl_taskStaff WHERE taskStaffID = @check4TaskStaffID)

		SET @clashEndDate = (SELECT EndDate FROM tbl_taskStaff WHERE taskStaffID = @check4TaskStaffID)
		
		SET @clashNotes = (SELECT taskNote FROM tbl_taskStaff WHERE taskStaffID = @check4TaskStaffID)

		INSERT tbl_TaskStaff (taskId, staffId, startDate, EndDate, taskNote, cancellable, active, UPDATEdBy)
		VALUES (@clashTaskID, @staffID, @newEndDate + 1, @clashEndDate, @clashNotes, 0, 1, @currentUser)

		UPDATE tbl_TaskStaff
		SET EndDate = @newStartDate - 1, UPDATEdBy = @currentUser WHERE taskStaffID = @check4TaskStaffID
	END

IF @check5TaskStaffID > 0
	BEGIN
		UPDATE tbl_TaskStaff
		SET startDate = @newEndDate + 1, UPDATEdBy = @currentUser WHERE taskStaffID = @check5TaskStaffID
	END

IF @check6TaskStaffID > 0
	BEGIN
		UPDATE tbl_TaskStaff
		SET EndDate = @newStartDate - 1, UPDATEdBy = @currentUser WHERE taskStaffID = @TaskStaffID
	END

	SET @taskStartdate = (SELECT startdate FROM tbl_task WHERE taskId = @taskID)
	SET @taskEndDate = (SELECT ENDdate FROM tbl_task WHERE taskId = @taskID)
	SET @cancellable = (SELECT cancellable FROM tbl_task WHERE taskId = @taskID)
	
	INSERT tbl_TaskStaff (taskId, staffId, startDate, EndDate, taskNote, cancellable, active, UPDATEdBy)
	VALUES (@taskId, @staffID, @Startdate, @EndDate, @notes, @cancellable, 1, @currentUser)
