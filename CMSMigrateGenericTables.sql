USE CMS2
GO
-- The following tables MUST be generic to ALL users 
-- otherwise when we post a user from one Hierarchy to another
-- we will lose Q's, Fitness, Dental, Vaccs
-- We must check the table primary key recID's against each table BEFORE we run this and make the neccessary
-- changes

-- tblQStatus  
   DELETE FROM tblPostQStatus WHERE ndeID > 1

GO

-- Dental
-- First set all duplicates to Node 1
   -- Do this for EACH migration - probably have to change the key
   -- but this allows for only ONE set of tblDental records ie: ndeID=1
   UPDATE tblStaffDental
     SET DentalID = 6 WHERE DentalID=108
    
   DELETE tblStaffDental WHERE  DentalID=109
	  
   -- now get rid of tblDental
   DELETE tblDental WHERE ndeID > 1

GO

-- Fitness
-- First set all duplicates to Node 1
UPDATE tblStaffFitness
     SET FitnessID = 7 WHERE FitnessID=116

UPDATE tblStaffFitness
     SET FitnessID = 15 WHERE FitnessID=117

 DELETE tblStaffFitness WHERE  FitnessID=118
GO

/*
DECLARE @staffID INT
DECLARE @expdate DATETIME

   DECLARE st1 SCROLL CURSOR FOR
	SELECT tblStaff.staffID, tblStaffFitness.ValidTo FROM tblStaff
	   INNER JOIN tblstafffitness ON tblstaffFitness.staffid=tblStaff.staffID and fitnessid= 118
   OPEN st1

    FETCH NEXT FROM st1 INTO @staffID, @expdate

	WHILE @@FETCH_STATUS=0
	 BEGIN
	  UPDATE tblStaff 
	    SET exempt= 1,
		    expiryDate=@expdate
			WHERE tblStaff.staffID=@staffID
	  FETCH NEXT FROM st1 INTO @staffID,@expdate
	END
  CLOSE st1
  DEALLOCATE st1
GO
*/

 -- now get rid of Fitness
   DELETE tblFitness WHERE ndeID > 1

-- Vaccinations
-- First set all duplicates to Node 1
--Typhoid
  UPDATE tblStaffMVs SET mvID=8 where mvID=129

--Yellow Fever
  UPDATE tblStaffMVs SET mvID=9 where mvID=128

--Polio
  UPDATE tblStaffMVs SET mvID=10 where mvID=125

--Dipheria
  UPDATE tblStaffMVs SET mvID=11 where mvID=127

--Tetanus
  UPDATE tblStaffMVs SET mvID=12 where mvID=126

--Hep A
  UPDATE tblStaffMVs SET mvID=13 where mvID=124

--Hep B
  UPDATE tblStaffMVs SET mvID=20 where mvID=123

-- Now set the ones node 1 does NOT have to node 1
-- Anthrax
UPDATE tblMilitaryVacs 
   SET ndeID=1 WHERE mvID=122

-- Rabies
UPDATE tblMilitaryVacs 
   SET ndeID=1 WHERE mvID=130

-- Now delete all non node 1's
DELETE tblMilitaryVacs WHERE ndeID>1

