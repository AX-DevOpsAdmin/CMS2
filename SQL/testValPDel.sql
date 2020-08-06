

    declare @recID		INT
	declare @DelOK	INT 
set @recID=29
set @DelOK=0
-- has a Q got a validity period assigned to it
IF EXISTS (SELECT TOP 1 vpID FROM tblQs WHERE tblQs.vpID = @recID)    
	SET @DelOk = '1' 
-- has a Military Skill got a validity period  assigned to it
ELSE IF EXISTS (SELECT TOP 1 msvpID FROM tblMilitarySkills WHERE tblMilitarySkills.msvpID = @recID)    
	SET @DelOk = '1' 
-- has a Fitness type got a validity period  assigned to it
ELSE IF EXISTS (SELECT TOP 1 FitnessVPID FROM tblFitness WHERE tblFitness.FitnessVPID = @recID)    
	SET @DelOk = '1' 
-- has a Vaccination got a validity period  assigned to it
ELSE IF EXISTS (SELECT TOP 1 mvvpID FROM tblMilitaryVacs WHERE tblMilitaryVacs.mvvpID = @recID)    
	SET @DelOk = '1' 
-- has Dental got a validity period  assigned to it
ELSE IF EXISTS (SELECT TOP 1 DentalVPID FROM tblDental WHERE tblDental.DentalVPID = @recID)    
	SET @DelOk = '1'

select @DelOK