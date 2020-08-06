

DECLARE @hrcID				INT
DECLARE @QStatus			INT
DECLARE @QCount				INT
DECLARE @MSStatus			INT
DECLARE @MSCount			INT
DECLARE @VacStatus			INT
DECLARE @VacCount			INT
DECLARE @FitnessStatus			INT
DECLARE @fitnessCount			INT
DECLARE @DentalStatus			INT
DECLARE @dentalCount			INT
DECLARE @withWithout			INT
DECLARE @WHEREClause			VARCHAR(8000)
DECLARE @qualification			VARCHAR(1000)
DECLARE @milskill			VARCHAR(1000)
DECLARE @vacs				VARCHAR(1000)
DECLARE @fitness			VARCHAR(1000)
DECLARE @dental				VARCHAR(1000)
DECLARE @thisDate			VARCHAR(30)
DECLARE @civi				INT
DECLARE @ENDDate			VARCHAR(30)
DECLARE @Gender				INT

/**
Q Stats 1 / 1 Mil Stats 0 / 0 Vacs Stats 0 / 0 Fit Stats 0 / 0 Dental Stats 0 / 0 With Stats 1 
WhereClause AND 64 IN (SELECT QID FROM tblStaffQs WHERE staffID = tblStaff.staffID) qualification 64 milskill vacs fitness dental teamID thisdate 05/11/2015 civi 1 endDate 05/11/2015 gender 1
**/

SET @hrcID=30
SET @QStatus=1
SET @QCount=1
SET @MSCount=0
SET @MSStatus=0
SET @VacStatus=0
SET @VacCount=0
SET @fitnessCount=0
SET @FitnessStatus=0
SET @dentalCount=0
SET @DentalStatus=0
SET @withWithout=0
SET @WHEREClause= 'AND 64 IN (SELECT QID FROM tblStaffQs WHERE staffID = tblStaff.staffID)'
SET @qualification ='64'
SET @thisDate='05/11/2015'
SET @ENDDate='05/11/2015'
SET @civi=1
SET @Gender=1


SET DATEFORMAT dmy
DECLARE @rankID			INT
DECLARE @unit   		VARCHAR(25)

DECLARE @MyCounter		INT

SET @MyCounter = 0
DECLARE @Str			VARCHAR(8000)
DECLARE @searched		VARCHAR(8000)
declare @strDescriptions	VARCHAR(400)

SET @unit = (SELECT hrcname from tblHierarchy WHERE tblHierarchy.hrcID = @hrcID)

WITH tblChild AS
		(
		  SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
		  UNION ALL
		  SELECT tblHierarchy.hrcID, tblHierarchy.hrcName FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
		)
     SELECT hrcID, hrcname INTO #ttHRC FROM tblChild 
     


  
SET @Str = 'SELECT DISTINCT TOP 100 PERCENT #tthrc.hrcid, tblStaff.staffID, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblStaff.sex, tblStaff.lastOOA, tblStaff.arrivaldate,'  
SET @Str = @Str + 'tblStaff.postingduedate, tblStaff.dischargeDate, tblRank.shortDesc, #ttHRC.hrcname AS Team, tblMES.description AS MES '
SET @Str = @Str + 'FROM #ttHRC INNER JOIN tblPost ON tblPost.hrcID = #ttHRC.hrcID '
SET @Str = @Str + 'INNER JOIN tblStaffPost ON tblStaffPost.postID = tblPost.postID '
SET @Str = @Str + 'INNER JOIN tblStaff ON tblStaff.staffID=tblStaffPost.staffID '
SET @Str = @Str + 'INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID '
--SET @Str = @Str + 'INNER JOIN #tempunit ON tblPost.teamID = #tempunit.tmID '
SET @Str = @Str + 'LEFT OUTER JOIN tblMES ON tblMES.mesID = tblStaff.mesID '

IF @withWithout = 1
	BEGIN
		IF @QStatus = 0
			BEGIN
				/*WHILE @MyCounter <= @QCount
					BEGIN*/
						SET @Str = @Str + 'LEFT OUTER JOIN  (SELECT * FROM dbo.tblStaffQs) AS Q' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = Q' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						/*SET @MyCounter = @MyCounter + 1
					END*/
			END
	
		IF @MSStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @MSCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffMilSkill WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''' ) AS milSkill' + CONVERT(VARCHAR(3),@MyCounter ) + ' ON dbo.tblStaff.staffID = milSkill' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
	
		IF @VacStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @VacCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffMVs WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS MVs' + CONVERT(VARCHAR(3),@MyCounter ) + ' ON dbo.tblStaff.staffID = MVs' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID  '
						SET @MyCounter = @MyCounter + 1
					END
			END
	
		IF @FitnessStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @fitnessCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffFitness WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS fitness' +  CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = fitness' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
	
		IF @DentalStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @dentalCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffDental WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS dental' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = dental' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END

	        SET @Str = @Str + 'WHERE tblPost.Ghost = 0 '

		IF @civi = 0
			BEGIN
				SET @Str = @Str + 'AND tblRank.Weight <> 0'
			END
	
	        IF @Gender = '2'
			BEGIN
	        		SET @Str = @Str + ' AND dbo.tblStaff.sex =' + '''' + 'M' + '''' 
			END
	
		IF @Gender = '3'
			BEGIN
				SET @Str = @Str + ' AND dbo.tblStaff.sex =' + '''' + 'F' + '''' 
			END
	
		SET @Str = @Str + ' AND ((' + '''' + @thisDate + '''' + '>= tblStaffPost.startDate AND (' + '''' + @thisDate + '''' + '<= tblStaffPost.ENDdate OR tblStaffPost.ENDDate IS NULL)) OR (tblStaffPost.startDate IS NULL AND tblStaffPost.ENDDate IS NULL)) '
		SET @Str = @Str + @WHEREClause
	END
ELSE
	BEGIN
		SET @Str = @Str + ' WHERE NOT EXISTS ('
		
		SET @Str = @Str + 'SELECT DISTINCT TOP 100 PERCENT tblStaff.staffID, tblStaff.surname, tblStaff.firstname, tblStaff.serviceno, tblRank.shortDesc, #ttHRC.hrcname AS Team
		FROM dbo.tblStaff AS innertblStaff
		INNER JOIN dbo.tblRank ON dbo.tblStaff.rankID = dbo.tblRank.rankID
		INNER JOIN tblStaffPost ON dbo.tblStaff.staffID = tblStaffPost.staffID
		INNER JOIN tblPost ON tblPost.postId = tblStaffPost.PostID
		INNER JOIN #ttHRC ON tblPost.hrcID = #ttHRC.hrcID '
	
		IF @QStatus = 1	
			BEGIN
				/*WHILE @MyCounter < @QCount
					BEGIN*/
						SET @Str = @Str + 'LEFT OUTER JOIN  (SELECT * FROM dbo.tblStaffQs) AS Q' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = Q' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						/*SET @MyCounter = @MyCounter + 1
					END*/
			END
		
		IF @MSStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @MSCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffMilSkill WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS milSkill' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = milSkill' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
		
		IF @VacStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @VacCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffMVs WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS MVs' + CONVERT(VARCHAR(3),@MyCounter ) + ' ON dbo.tblStaff.staffID = MVs' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID  '
						SET @MyCounter = @MyCounter + 1
					END
			END
		
		IF @FitnessStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @fitnessCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffFitness WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS fitness' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = fitness' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
		
		IF @DentalStatus = 1
			BEGIN
				SET @MyCounter = 0	
				WHILE @MyCounter < @dentalCount	
					BEGIN
						SET @Str = @Str + 'LEFT OUTER JOIN (SELECT * FROM dbo.tblStaffDental WHERE validFrom <= ''' + @thisDate + ''' AND validTo >= ''' + @ENDDate + ''') AS dental' + CONVERT(VARCHAR(3),@MyCounter) + ' ON dbo.tblStaff.staffID = dental' + CONVERT(VARCHAR(3),@MyCounter) + '.StaffID '
						SET @MyCounter = @MyCounter + 1
					END
			END
			
		SET @Str = @Str + ' WHERE tblPost.Ghost = 0 AND tblstaff.staffID = innerTblStaff.StaffID '

		SET @Str = @Str + @WHEREClause

		SET @Str = @Str + ')'
	END

	IF @civi = 0
		BEGIN
			SET @Str = @Str + 'AND tblRank.Weight <> 0'
		END

	SET @Str = @Str + ' AND ((' + '''' + @thisDate + '''' + '>= tblStaffPost.startDate AND (' + '''' + @thisDate + '''' + '<= tblStaffPost.ENDdate OR tblStaffPost.ENDDate IS NULL)) OR (tblStaffPost.startDate IS NULL AND tblStaffPost.ENDDate IS NULL)) '
	SET @Str = @Str + 'ORDER BY #ttHRC.hrcID, surname'

	IF @qualification <> ''
		BEGIN
			SET @strDescriptions =  'SELECT QTypeID, description FROM tblQs WHERE qid IN (' + @qualification + ')'
			EXEC (@strDescriptions)
		END
	
	IF @milskill <> ''
		BEGIN
			SET @strDescriptions =  'SELECT description FROM tblMilitarySkills WHERE msID IN (' + @milskill  + ')'
			EXEC (@strDescriptions)
		END
	
	IF @vacs <> ''
		BEGIN
			SET @strDescriptions =  'SELECT description FROM tblMilitaryVacs WHERE mvID IN (' + @vacs  + ')'
			EXEC (@strDescriptions)
		END
	
	IF @fitness <> ''
		BEGIN
			SET @strDescriptions =  'SELECT description FROM tblFitness WHERE fitnessID IN (' + @fitness  + ')'
			EXEC (@strDescriptions)
		END
	
	IF @dental <> ''
		BEGIN
			SET @strDescriptions =  'SELECT description FROM tblDental WHERE dentalID IN (' + @dental  + ')'
			EXEC (@strDescriptions)
		END
	
EXEC(@Str)

 --SELECT @Str

--SELECT * from #ttHRC

DROP TABLE #ttHRC