

DECLARE @hrcID			INT
DECLARE @List			VARCHAR(800)

DECLARE @Pos		INT
DECLARE @Len		INT

DECLARE @fltID		INT
DECLARE @sqnID		INT
DECLARE @wingID		INT
DECLARE @groupID		INT
DECLARE @teamIN		INT
DECLARE @rankID		INT
DECLARE @unit   		VARCHAR(25)
DECLARE @rank		VARCHAR(25)
DECLARE @rankWeight		INT

DECLARE @Establishment	INT
DECLARE @Strength		INT
DECLARE @Combat		INT

DECLARE @UN2_staffID	INT
DECLARE @CR_Count 		INT

DECLARE @FEAR		INT
DECLARE @CombatReady	INT

DECLARE @first 		INT

SET @List='6,5,3,'
SET @hrcID=20

SET @Len = LEN(@List)

--SET @teamIN = (SELECT teamIN from tblTeam WHERE tblTeam.teamID = @hrcID)
SET @unit = (SELECT hrcname from tblHierarchy WHERE tblHierarchy.hrcID = @hrcID)

; WITH tblChild AS
		(
		   SELECT T1.hrcID, T1.hrcName, T1.hrcparentID, CAST(T1.hrcID AS VARCHAR(255)) AS hrcPath -- , 0 AS depth
		     FROM tblHierarchy T1 WHERE T1.hrcID=@hrcID
		 UNION ALL
		   SELECT T2.hrcID, T2.hrcName,T2.hrcparentID, CAST(hrcPath + '.' + CAST(T2.hrcID AS VARCHAR(255)) AS VARCHAR(255))    --  depth + 1
		    FROM tblHierarchy T2
		      INNER JOIN tblChild ON T2.hrcparentID=tblChild.hrcID
		  )
		  SELECT * INTO #tempunit FROM tblChild ORDER BY hrcPath
		  
		  
-- so we know its the first time through the cursor loop below
SET @first=0

-- temp table to hold list of ranks
CREATE TABLE #temprank
(
	rankID			INT
)

-- temp table to hold all ranks within Unit Hierarchy
CREATE TABLE #templist
(
	tmID			INT,
	staffID			INT,
	rankID			INT,
	rankWeight		INT,
	rankDesc		VARCHAR(30),
	tmDesc			VARCHAR(30)
)

-- temp table to hold the records by chosen rank
CREATE TABLE #unit
(
	RankDesc		VARCHAR(25),
	RankWeight		INT,
	Establishment		INT,
	Strength		INT,
	CR			INT,
	FEAR			INT
)

SET @Pos = 0
WHILE (CHARINDEX(',',@List,@Pos)-@Pos) > 0
	BEGIN
		SET @RankID = SUBSTRING(@List,@Pos,(CHARINDEX(',',@List,@Pos)-@Pos))

		INSERT INTO #temprank(RankID)
		SELECT @RankID
		SET @Pos = CHARINDEX(',',@List,@Pos)+1
	END

-- Ranks of all the posts in each team
INSERT INTO #templist
	SELECT DISTINCT tblPost.hrcID, 0, tblPost.rankID, tblRank.weight, tblRank.description, #tempunit.hrcname
        FROM tblPost
	INNER JOIN tblRank ON tblRank.rankID = tblPost.rankID
        INNER JOIN #temprank ON tblRank.rankID = #temprank.rankID
        INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
        --INNER JOIN tblHierarchy ON tblPost.hrcID = tblHierarchy.hrcID
        WHERE tblPost.Ghost = 0 AND tblRank.weight <> 0

DECLARE un1 SCROLL CURSOR FOR
	SELECT rankID, rankWeight FROM #templist GROUP BY rankID, rankWeight
OPEN un1

FETCH NEXT FROM un1 INTO @rankID, @rankWeight

-- now get the harmony status of each rank within the unit
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Establishment = 0
		SET @Strength = 0
		SET @CombatReady = 0
		SET @FEAR = 0
		SET @rank = (SELECT tblRank.description FROM tblRank WHERE tblRank.rankID = @rankID)
		SET @rankWeight = (SELECT tblRank.weight FROM tblRank WHERE tblRank.rankID = @rankID)

		-- Retreives the Establishment.  Posts that exist within the team.
		SET @Establishment = (SELECT COUNT(*) FROM tblPost
			INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID 
			WHERE  tblPost.Ghost = 0 AND tblPost.rankID = @rankID)

		-- Retreives the Strength.  Posts that actually has a person in them.
		SET @Strength = (SELECT COUNT(*) FROM tblStaff
			INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID 
			INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
			INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
			INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
			WHERE tblPost.Ghost = 0 AND tblStaff.rankID = @rankID AND (tblStaffPost.endDate IS NULL OR dbo.tblStaffPost.endDate > GETDATE()) AND tblRank.weight <> 0)

			DECLARE un2 SCROLL CURSOR FOR
				SELECT tblstaff.staffId FROM tblStaff
					INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID 
					INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.staffID
					INNER JOIN tblPost ON tblStaffPost.postID=tblPost.postID     
					INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID 
					WHERE tblPost.Ghost = 0 AND tblStaff.rankID = @rankID AND (tblStaffPost.endDate IS NULL OR dbo.tblStaffPost.endDate > GETDATE()) AND tblRank.weight <> 0
			OPEN un2

			FETCH NEXT FROM UN2 INTO @UN2_staffID

			WHILE @@FETCH_STATUS = 0
				BEGIN
					
					SET @CR_Count = 0
						--check to see if the staff id is Combat Ready 
						IF (SELECT COUNT(*) AS Vacinations FROM dbo.tblMilitaryVacs WHERE combat = 1) = 
							(SELECT DISTINCT COUNT(*) AS Vacinations FROM tblStaff
							INNER JOIN tblStaffMVs ON tblStaff.staffID = tblStaffMVs.StaffID
							INNER JOIN tblMilitaryVacs on dbo.tblStaffMVs.MVID = dbo.tblMilitaryVacs.mvID
							WHERE tblMilitaryVacs.combat = 1 AND tblStaffMVs.validTo > GETDATE() AND tblstaff.staffId = @UN2_staffID)
						SET @CR_Count = 1

						IF (SELECT COUNT(*) AS Dentistry FROM tblStaff
							INNER JOIN dbo.tblStaffDental ON dbo.tblStaff.staffID = dbo.tblStaffDental.StaffID
							INNER JOIN dbo.tblDental ON dbo.tblStaffDental.DentalID = dbo.tblDental.DentalID
							WHERE tblDental.combat = 1 AND tblStaffDental.validTo > GETDATE() AND tblstaff.staffId = @UN2_staffID) > 0
						SET @CR_Count = @CR_Count + 1

						If (SELECT COUNT(*) AS Fitness FROM tblStaff
							INNER JOIN dbo.tblStaffFitness ON dbo.tblStaff.staffID = dbo.tblStaffFitness.StaffID
							INNER JOIN dbo.tblFitness ON dbo.tblStaffFitness.FitnessID = dbo.tblFitness.FitnessID
							WHERE tblFitness.Combat = 1 AND tblStaffFitness.ValidTo > GETDATE() AND tblstaff.staffId = @UN2_staffID) > 0
						SET @CR_Count = @CR_Count + 1

						IF (SELECT COUNT(*) AS CCS FROM tblStaff
							INNER JOIN dbo.tblStaffMilSkill ON dbo.tblStaff.staffID = dbo.tblStaffMilSkill.StaffID
							INNER JOIN dbo.tblMilitarySkills ON dbo.tblStaffMilSkill.MSID = dbo.tblMilitarySkills.msID
							WHERE tblMilitarySkills.Combat = 1 AND tblStaffMilSkill.validTo > GETDATE() AND tblstaff.staffId = @UN2_staffID) > 0
						SET @CR_Count = @CR_Count + 1
					
					
					 	--if staff id is combat ready now check to see if they are also fear
						--fear is CR plus any military skill that is check as fear ie tblMilitarySkills.Fear = 1
						if @CR_Count = 4 and  (SELECT COUNT(*) FROM tblStaff
							INNER JOIN dbo.tblStaffMilSkill ON dbo.tblStaff.staffID = dbo.tblStaffMilSkill.StaffID
							INNER JOIN dbo.tblMilitarySkills ON dbo.tblStaffMilSkill.MSID = dbo.tblMilitarySkills.msID
							AND tblstaff.staffId = @UN2_staffID AND tblStaffMilSkill.validTo > GETDATE() 
							AND tblMilitarySkills.msID in(SELECT msID FROM tblMilitarySkills WHERE tblMilitarySkills.Fear = 1)) > 0

							SET @FEAR = @FEAR + 1

						if @CR_Count = 4
							SET @CombatReady = @CombatReady + 1
					
					FETCH NEXT FROM UN2 INTO @UN2_staffID

				END

			CLOSE un2
			DEALLOCATE un2
			
		-- Now add to the temptable
		INSERT INTO #unit
			SELECT @rank,@rankWeight, @Establishment, @Strength, @CombatReady, @FEAR
			
		FETCH NEXT FROM un1 INTO @rankID, @rankWeight 
	END

CLOSE un1
DEALLOCATE un1

SELECT
	RankDesc AS Rank,
--	RankWeight AS Weight,
	Establishment AS Established,
	Strength AS Strength,
	CR AS CombatReady,
	FEAR AS FEAR
FROM #unit ORDER BY RankWeight DESC

SELECT * from #tempunit
DROP TABLE #tempunit
DROP TABLE #temprank
DROP TABLE #templist
DROP TABLE #unit
