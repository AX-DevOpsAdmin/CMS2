
DECLARE @hrcID			INT
DECLARE @Enduring		VARCHAR(800)

DECLARE @Pos			INT
DECLARE @Len			INT

DECLARE @fltID			INT
DECLARE @sqnID			INT
DECLARE @wingID			INT
DECLARE @groupID			INT
DECLARE @teamIN			INT
DECLARE @qID			VARCHAR(25)
DECLARE @unit   			VARCHAR(25)
DECLARE @qs				VARCHAR(25)

DECLARE @tempstaffID			INT
DECLARE @tempquals			INT
DECLARE @tempqualstypeid		INT
DECLARE @StaffQualCount 		INT

DECLARE @QualCount 			DEC(5,2)
DECLARE @FirstQuartile 		DEC(5,2)
DECLARE @SecondQuartile 		DEC(5,2)
DECLARE @ThirdQuartile 		DEC(5,2)

DECLARE @FirstCount 			INT
DECLARE @SecondCount 		INT
DECLARE @ThirdCount 			INT
DECLARE @FourthCount		INT


DECLARE @Description			VARCHAR(50)
DECLARE @Current			INT
DECLARE @Required			INT

DECLARE @first			INT

SET @Enduring='497,616,'
SET @hrcID=20

SET @Len = LEN(@Enduring)

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
SET @first = 0

-- temp table to hold list of types and qs
CREATE TABLE #temptypeQ
(
	qID		INT
)

-- temp table to hold the records by chosen rank
CREATE TABLE #unit
(
	#Description	VARCHAR(50),
	#Current	INT,
	#Required	INT
)

CREATE TABLE #tempcount
(
	firstquater	INT,
	secondquater	INT,
	thirdquater	INT,
	fourthquater	INT	
)

SET @Pos = 0
WHILE (CHARINDEX(',',@Enduring,@Pos)-@Pos) > 0
	BEGIN
		SET @qID = SUBSTRING(@Enduring,@Pos,(CHARINDEX(',',@Enduring,@Pos)-@Pos))

		INSERT INTO #temptypeQ(qID)
		SELECT @qID
		SET @Pos = CHARINDEX(',',@Enduring,@Pos)+1
	END

DECLARE un1 SCROLL CURSOR FOR
	SELECT qID FROM #temptypeQ
OPEN un1

FETCH NEXT FROM un1 INTO @qID

-- now get the harmony status of each rank within the unit
WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN
			SET @Description = (SELECT description FROM tblQs WHERE qID = @qID)
		END
		
		-- Retreives the Establishment.  Posts that exist within the team.
		SET @Required = (SELECT COUNT(*) FROM tblPost
			INNER JOIN tblRank ON tblRank.rankID = tblPost.rankID
			INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
			--INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
			INNER JOIN tblPostQs ON tblPost.postID = tblPostQs.PostID
			WHERE (tblPost.Ghost = 0) AND (tblRank.Weight <> 0) AND (tblPostQs.QID = @qID))

 
		-- Retreives the Strength.  Posts that actually has a person in them.
		SET @Current = (SELECT COUNT(*) FROM tblPost
			INNER JOIN tblStaffPost ON tblPost.postID = tblStaffPost.PostID
			--INNER JOIN tblTeam ON tblPost.teamID = tblTeam.teamID
			INNER JOIN tblRank ON tblPost.rankID = tblRank.rankID
			INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
			INNER JOIN tblStaffQs ON tblStaffPost.StaffID = tblStaffQs.StaffID
			WHERE (tblPost.Ghost = 0) AND (tblRank.Weight <> 0) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) AND (tblStaffQs.QID = @qID))

		-- Now add to the temptable
		INSERT INTO #unit
			SELECT @Description, @Current, @Required

		FETCH NEXT FROM un1 INTO @qID
	END

CLOSE un1
DEALLOCATE un1

-------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE staff SCROLL CURSOR FOR
	SELECT tblStaff.staffID
	FROM tblStaff
	INNER JOIN tblStaffPost ON tblStaffPost.StaffID = tblStaff.staffID
	INNER JOIN tblPost On tblStaffPost.PostID = tblPost.PostID
	INNER JOIN tblRank ON tblPost.rankID = tblRank.rankID
	INNER JOIN #tempunit ON tblPost.hrcID = #tempunit.hrcID
	WHERE (tblPost.Ghost = 0) AND (tblRank.Weight <> 0) AND tblStaffpost.enddate IS NULL OR tblStaffpost.enddate > GETDATE()

OPEN staff


SET @QualCount = (SELECT COUNT(*) FROM #temptypeQ)

SET @FirstQuartile = (@QualCount / 100) * 25
SET @SecondQuartile = (@QualCount / 100) * 50
SET @ThirdQuartile = (@QualCount / 100) * 75

SET @StaffQualCount = 0
SET @FirstCount = 0
SET @SecondCount = 0 	
SET @ThirdCount = 0 	
SET @FourthCount = 0

FETCH NEXT FROM staff INTO @tempstaffID

	WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE quals SCROLL CURSOR FOR
				Select qID from #temptypeQ
			OPEN quals

			FETCH NEXT FROM quals INTO @tempquals

				WHILE @@FETCH_STATUS = 0
					BEGIN
						IF (SELECT COUNT(*) FROM tblStaffQs WHERE (tblStaffQs.StaffID = @tempstaffID) AND (tblStaffQs.QID = @tempquals)) != 0
							
								SET @StaffQualCount = @StaffQualCount + 1
							
						FETCH NEXT FROM quals INTO @tempquals
					END

					If @StaffQualCount > 0 AND @StaffQualCount <= @FirstQuartile
						SET @FirstCount = @FirstCount + 1

					If @StaffQualCount > @FirstQuartile And @StaffQualCount <= @SecondQuartile
					 	SET @SecondCount = @SecondCount + 1

					If @StaffQualCount > @SecondQuartile And @StaffQualCount <= @ThirdQuartile
						SET @ThirdCount = @ThirdCount + 1

					If @StaffQualCount > @ThirdQuartile
						SET @FourthCount = @FourthCount + 1

					SET @StaffQualCount = 0

			DEALLOCATE quals
			FETCH NEXT FROM staff INTO @tempstaffID
		END

DEALLOCATE staff

INSERT INTO #tempcount(firstquater, secondquater, thirdquater, fourthquater)VALUES(@FirstCount, @SecondCount, @ThirdCount, @FourthCount)

SELECT
	firstquater AS firstquater,
	secondquater AS secondquater,
	thirdquater AS thirdquater,
	fourthquater AS fourthquater
FROM #tempcount

SELECT
	#Description AS hrcname,
	#Current AS [Current],
	#Required AS Requirement
FROM #unit

DROP TABLE #tempunit
DROP TABLE #temptypeQ
DROP TABLE #unit
DROP TABLE #tempcount
