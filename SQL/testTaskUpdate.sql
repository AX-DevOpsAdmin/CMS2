

DECLARE 	@taskID		INT
DECLARE @staffID		INT
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
SET @notes = 'Test Task Update'
SET @id= 297085
SET @Flag=1
SET @nodeID=1

DECLARE @clash		INT


DECLARE @newStartdate	DATETIME
DECLARE @newENDdate	DATETIME
DECLARE @taskStartDate	DATETIME
DECLARE @taskENDDate	DATETIME
DECLARE @cancellable		INT
DECLARE @currooadays	INT
DECLARE @TaskStaffID	INT
DECLARE @clashTaskID	INT
DECLARE @clashStartDate 	DATETIME
DECLARE @clashENDDate	DATETIME
DECLARE @TestWorked	VARCHAR(50)

--SELECT DISTINCT taskStaffId FROM tbl_taskStaff WHERE active=1 AND staffId= @staffId AND @newStartDate <= startDate AND @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate >= ENDDate
--		SET @staffID=(SELECT DISTINCT taskStaffId FROM tbl_taskStaff WHERE  active=1 AND staffId= @staffId AND @newStartDate >= startDate AND @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate <= ENDDate )


SET @clash = 0 
SET @TestWorked = 'Test1Worked'

--SET @StaffID= (SELECT staffId FROM tblStaff WHERE serviceNo = @serviceNo)
SET @newStartdate = @Startdate/* (SELECT startDate FROM tbl_Task WHERE taskId= @taskID)*/
SET @newENDdate = @ENDdate/* (SELECT ENDdate FROM tbl_Task WHERE taskId= @taskID)*/

/*clashCheck1*/
IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active=1 AND staffId= @staffId AND @newStartDate <= startDate AND  @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate <= ENDDate AND taskStaffID <> @id)
	BEGIN
		SET @clash=1
		SET @staffID= (SELECT DISTINCT taskStaffId FROM tbl_taskStaff WHERE  (active=1 AND staffId= @staffId AND @newStartDate <= startDate AND @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate <= ENDDate))
	
		--INSERT INTO tblTaskClash
		--  SELECT @currentUser, @staffID, @nodeID
        SELECT 'Clash 1 '
		
	END

/*clashCheck2*/
IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active=1 AND staffId= @staffId AND @newStartDate >= startDate AND  @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate >= ENDDate AND taskStaffID <> @id)
	BEGIN
		SET @clash=1	
		SET @staffID= (SELECT DISTINCT taskStaffId FROM tbl_taskStaff WHERE  active=1 AND staffId= @staffId AND @newStartDate >= startDate AND @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate >= ENDDate)

		--INSERT INTO tblTaskClash
		  --SELECT @currentUser, @staffID, @nodeID
         SELECT 'Clash 2 ' 
	END

/*clashCheck3*/
IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active=1 AND staffId= @staffId AND @newStartDate >= startDate AND  @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate <= ENDDate AND taskStaffID <> @id)
	BEGIN
		SET @clash=1
		SET @staffID=(SELECT DISTINCT taskStaffId FROM tbl_taskStaff WHERE  active=1 AND staffId= @staffId AND @newStartDate >= startDate AND @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate <= ENDDate )
	
		--INSERT INTO tblTaskClash
		 -- SELECT @currentUser, @staffID, @nodeID
         SELECT 'Clash 3 '
	END

/*clashCheck4*/
IF EXISTS (SELECT taskStaffId FROM tbl_taskStaff WHERE active=1 AND staffId= @staffId AND @newStartDate <= startDate AND  @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate >= ENDDate AND taskStaffID <> @id)
	BEGIN
		SET @clash=1
		SELECT TOP 10 taskStaffId FROM tbl_taskStaff WHERE active=1 AND staffId= @staffId AND @newStartDate <= startDate AND @newStartDate <= ENDDate AND @newENDDate >= startDate AND @newENDDate >= ENDDate
	
		--INSERT INTO tblTaskClash
		  --SELECT @currentUser, @staffID, @nodeID
          SELECT 'Clash 4 '
	END
	
	IF @clash=0
	BEGIN
		SET @taskStartdate =(SELECT startdate FROM tbl_task WHERE taskId=@taskID)
		SET @taskENDDate =(SELECT ENDdate FROM tbl_task WHERE taskId=@taskID)
		SET @cancellable =(SELECT cancellable FROM tbl_task WHERE taskId=@taskID)
		
		INSERT  tbl_TaskStaff (taskId,staffId,startDate,ENDDate,taskNote,cancellable,active,updatedBy,ndeID)
		VALUES (@taskId,@staffID,@Startdate,@ENDDate,@notes,@cancellable,1,@currentUser, @nodeID)
	
	        DECLARE cs1 CURSOR FOR SELECT staffID FROM tblStaffHarmony WHERE tblStaffHarmony.staffID = @staffID
	
	        OPEN cs1
	        FETCH NEXT FROM cs1
	
	        IF @@FETCH_STATUS = 0
			  BEGIN
				UPDATE tblStaffHarmony SET
				tblStaffHarmony.ooadays=@ooadays
				WHERE tblStaffHarmony.staffID = @staffid AND ndeID=@nodeID
			  END
		    ELSE
			  BEGIN
				INSERT tblStaffHarmony (staffID, ooadays, ndeID)
				VALUES (@staffID, @ooadays, @nodeID)
			  END  
	
	        CLOSE cs1
	        DEALLOCATE cs1
/*
		IF @Flag = 1
			BEGIN
				DELETE tbl_taskStaff WHERE taskStaffID = @id -- AND ndeID=@nodeID
			END
			*/
	END


