


DECLARE @ServiceNo VARCHAR(20)
DECLARE @password VARCHAR(32)

DECLARE @StaffID INT 
DECLARE @Status INT 
DECLARE @Active INT 
DECLARE @SqnMgr INT 
DECLARE @Admin INT 
DECLARE @HQTask INT 
DECLARE @hrcID	INT 
DECLARE @hrcIDStr VARCHAR(200) 
DECLARE @pswdExp INT 
DECLARE @error INT 
DECLARE @nodeID INT


DECLARE @teamIN INT
DECLARE @mgr INT
SET @teamIN = 0
SET @Status  = 0
SET @SqnMgr  = 0 
SET @error = 0

SET @ServiceNo=''
set @password=''

IF EXISTS (SELECT staffID FROM tblStaff WHERE tblStaff.serviceNo = @serviceNo)
BEGIN
	
	SELECT @StaffID = staffID, @Admin = administrator, @Active = active, @nodeID = ndeID FROM tblStaff WHERE tblStaff.serviceNo = @serviceNo
	
	-- work out how many days left until the password expires.
	SET @pswdExp =  datediff(dd,getDate(),(SELECT expires FROM tblPassword WHERE staffID = @StaffID))

	IF (SELECT substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', @password)),3,32)) = (SELECT pswd FROM tblPassword WHERE staffID = @StaffID)
	BEGIN
		/*Check if the user is part of HQTask (Redundant now but left in to prevent breakage)*/
		--EXEC spCheckHQTask @staffID, @HQTask OUTPUT
		
		/*Set which Team the user belongs  and whether or not they are a manager*/
		--SELECT @mgr = tblPost.manager, @teamID = tblPost.teamID, @hrcID=hrcID, @teamIN = tblTeam.teamIN 
		SELECT @Status = tblPost.manager, @hrcID=hrcID
			FROM tblStaffPost 
			   INNER JOIN tblPost ON tblPost.postID = tblStaffPost.postID 
			   --INNER JOIN tblTeam ON tblTeam.teamID=tblPost.teamID
			   WHERE tblStaffPost.staffid = @staffID AND 
			         startdate < getdate() AND 
			         (enddate is NULL OR enddate > getdate()) 
			        -- AND  tblPost.manager = '1'
			
	    -- Now get the Hierarchy element his individual belongs to
		/* Add successful login to the Audit log 
		IF EXISTS (SELECT dbo.tblAudit.audID FROM dbo.tblAudit WHERE dbo.tblAudit.staffID = @staffID)
        BEGIN
            UPDATE dbo.tblAudit 
            SET dbo.tblAudit.staffID = @staffID, dbo.tblAudit.logOn = getDate(), dbo.tblAudit.logOff=NULL
            WHERE dbo.tblAudit.staffID = @staffID
        END
        ELSE
        BEGIN
            INSERT dbo.tblAudit (staffid,logOn)
            VALUES (@staffID, getDate())
        END
		*/
		--IF (SELECT substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', @password)),3,32)) <> (SELECT dPswd FROM tblPassword WHERE staffID = @StaffID)
		IF ((SELECT substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', @password)),3,32)) <> (SELECT dPswd FROM tblPassword WHERE staffID = @StaffID))
		     OR (SELECT dPswd FROM tblPassword WHERE staffID = @StaffID) IS NULL
		BEGIN
			IF (SELECT expires FROM tblPassword WHERE staffID = @StaffID) > getDate()
			BEGIN	
				
				IF @pswdExp < 6 	
				BEGIN
					SET @error = 4 /* Password will expire within 5 days*/
				END
			END
			ELSE
			BEGIN
				SET @error = 3 /* Password has expired*/
			END	
		END
		ELSE
		BEGIN
			SET @error = 2 /* Default Password - change password page*/
		END
	END
	ELSE
	BEGIN
		SET @error = 1 /* Password Not Matching */
	END
END
ELSE
BEGIN
	SET @error = 1 /* Role not matching*/
END
--print (@error)


select @StaffID, @Status,@Active, @hrcID, @pswdExp, @error 

--SELECT substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', @password)),3,32)
--SELECT pswd FROM tblPassword WHERE staffID = @StaffID