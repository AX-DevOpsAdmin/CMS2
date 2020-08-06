


	DECLARE @hrcID	INT
	DECLARE @rpun	INT 
	DECLARE @rpby   INT

SET @hrcID=30
SET @rpun=0
SET @rpby=0
/*
   This builds a temp table of the chosen unit plus its immediate subordinates
   and each one is then passed to GetHarmonyStatus to determine its Harmony
*/
DECLARE @childID INT
DECLARE @unit   VARCHAR(25)

DECLARE @unstr DEC (5, 2)
DECLARE @unest DEC (5, 2)
DECLARE @unstrpcnt DEC (5, 2)
DECLARE @unestpcnt DEC (5, 2)

-- total unit staff who have broken OOA and BNA harmony
DECLARE @unooatot INT
DECLARE @unbnatot INT

-- Unit OOA and BNA Harmony Days broken as a %age
-- These are the figures compared against the Unit Harmony Limits
DECLARE @unooapcnt DEC (5, 2)
DECLARE @unbnapcnt DEC (5, 2)

-- The Harmony Status itself - the Holy Grail
-- 0 = Green, 1 = Yellow, 2 = Amber, 3 = Red
DECLARE @unStatus INT

DECLARE @first INT

--SET @teamIN = (SELECT teamIN from tblTeam WHERE tblTeam.teamID = @tmID)

-- so we know its the first time through the cursor loop below
SET @first=0

WITH tblChild AS
		(
		  SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
		  UNION ALL
		  SELECT tblHierarchy.hrcID, tblHierarchy.hrcName FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
		)
     SELECT hrcID, hrcname INTO #ttHRC FROM tblChild 

-- Now we can go through the units and get the Harmony Status of each one
DECLARE un1 SCROLL CURSOR FOR
	SELECT #ttHrc.hrcID, #ttHrc.hrcname
	FROM #ttHrc 
	ORDER BY #ttHrc.hrcID

OPEN un1

FETCH NEXT FROM un1 INTO @childID, @unit

CREATE TABLE #unit
(
	#datastr	VARCHAR(25),
	#rankwt		INT,
	#establishment	DEC(5, 2), 
	#strength	DEC(5, 2),
	#ooaredtot	DEC(5, 2), 
	#bnaredtot	DEC(5, 2),
	#ooapcnt	DEC(5, 2),
	#bnapcnt	DEC(5, 2),
	#status		INT 
  )

WHILE @@FETCH_STATUS = 0
	BEGIN
		-- now get the harmony status for thihs unit
		EXEC spGetHarmonyStatus @hrcID = @childID, @repunit = @rpun, @repby = @rpby, 
		@establishment = @unest OUTPUT,
		@strength = @unstr OUTPUT,
		@ooaredtot = @unooatot  OUTPUT,
		@bnaredtot = @unbnatot OUTPUT,     
		@ooapcnt = @unooapcnt OUTPUT,     
		@bnapcnt =@unbnapcnt  OUTPUT,      
		@status = @unStatus OUTPUT

		-- now add to the temptable
		INSERT INTO #unit
			SELECT @unit,0, @unest,@unstr,@unooatot,@unbnatot,@unooapcnt,@unbnapcnt,@unStatus

		-- if the first time in loop then we want to get the Harmony Status of the individual team
		-- we picked - but not any of its subordinates
		IF @first = 0
			BEGIN
				-- now get the harmony status of the team ONLY - not any subordinates
				EXEC spGetTeamHarmonyStatus @hrcID = @childID, @repunit = @rpun, @repby = @rpby, 
				@establishment = @unest OUTPUT,
				@strength = @unstr OUTPUT,
				@ooatot = @unooatot  OUTPUT,
				@bnatot = @unbnatot OUTPUT,     
				@ooapcnt = @unooapcnt OUTPUT,     
				@bnapcnt =@unbnapcnt  OUTPUT,      
				@status = @unStatus OUTPUT

				-- now add to the temptable
				INSERT INTO #unit
					SELECT @unit,0, @unest,@unstr,@unooatot,@unbnatot,@unooapcnt,@unbnapcnt,@unStatus
					SET @first=1
			END

		-- get the next unit on the list
		FETCH NEXT FROM un1 INTO @childID, @unit
	END

CLOSE un1
DEALLOCATE un1

SELECT #datastr AS dispdata,
#establishment AS established,
#strength AS strength,
#ooaredtot AS ooaredtot,
#bnaredtot AS bnaredtot,
#ooapcnt AS ooapcnt,
#bnapcnt AS bnapcnt,
#status AS harmony 
FROM #unit

DROP TABLE #unit

DROP TABLE #ttHRC
