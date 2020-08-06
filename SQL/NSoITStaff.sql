
USE CMS2

TRUNCATE TABLE nsoitStaff

 DECLARE @recID INT
 DECLARE @allTeams INT
 DECLARE @thisDate VARCHAR(12)

DECLARE @startofMonth	VARCHAR(16)

SET DATEFORMAT dmy

SET @startofMonth = RIGHT(@thisDate,8)
SET @startofMonth = '01 ' + @startofMonth

SET @thisDate=CAST(getdate() AS VARCHAR(12))

SET @recID = 3
--SELECT  teamID, teamIn, ParentID,description,ParentDescription from vwTeamList where TeamId = @recID

BEGIN
        INSERT INTO nsoitStaff
		SELECT DISTINCT TeamName, surname, firstname, shortdesc, serviceno, weight 
		FROM vwStaffInPost
		WHERE ghost = 0 AND (teamID = @recID OR teamID IN (SELECT childID FROM vwAllChildren WHERE parentID = @recID)) AND @thisDate >= startDate AND 
		(CONVERT(DATETIME, @startofMonth)<= CONVERT(DATETIME, enddate) OR enddate IS NULL)
END
	