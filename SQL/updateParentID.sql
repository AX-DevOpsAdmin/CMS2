
DECLARE @teamID	INT
DECLARE @level INT
DECLARE @recID  INT
DECLARE @tblID INT
DECLARE @parentID INT		
	
   
DECLARE tm1 CURSOR SCROLL
      FOR SELECT ttID, ttparentid, ttlevel FROM tblTempTeam 
     
OPEN tm1
FETCH NEXT FROM tm1 INTO @teamID, @recID, @level
WHILE @@FETCH_STATUS = 0
  BEGIN
       IF @level = 0 
         BEGIN
            SET @tblID = (SELECT grpID FROM tblGroup WHERE grpID = @recid)
			SET @parentID  = (SELECT ttID FROM tblTempTeam WHERE ttlevel=0 AND ttparentID = @tblID)
          END
        IF @level = 1 
         BEGIN
            SET @tblID = (SELECT grpID FROM tblWing WHERE wingID = @recID)
			SET @parentID  = (SELECT ttID FROM tblTempTeam WHERE ttlevel=1 AND ttparentID = @tblID)
          END
          
      UPDATE tblTempTeam
        SET ttparentID = @parentID WHERE ttID = @teamID
     -- select @teamid, @recID, @pntid
      FETCH NEXT FROM tm1 INTO @teamID, @recID, @level
  END
   
CLOSE tm1
DEALLOCATE tm1
/**
IF @teamIn= 1
			BEGIN
				SET @ParentGroup = (SELECT grpID FROM tblWing WHERE wingID = @ParentID)
				SET @parentTeam = (SELECT TeamID FROM tblTeam WHERE teamIn=0 AND parentID = @ParentGroup)
			END
		
		IF @teamIn= 2
			BEGIN
				SET @ParentWing = (SELECT wingID FROM tblSquadron WHERE sqnID = @ParentID)
				SET @parentTeam = (SELECT TeamID FROM tblTeam WHERE teamIn=1 AND parentID = @ParentWing)
			END
		
		IF @teamIn= 3
			BEGIN
				SET @ParentSqn = (SELECT sqnID FROM tblFlight WHERE fltID = @ParentID)
				SET @parentTeam = (SELECT TeamID FROM tblTeam WHERE teamIn=2 AND parentID = @ParentSqn)
			END
		
		IF @teamIn= 4 OR @teamIn=5
			BEGIN
				SET @ParentTeam = (SELECT teamID FROM tblTeam WHERE TeamID = @ParentID)
			END
		
		IF @parentTeam IS NULL
			BEGIN
				SET @parentTeam = 999
			END	
		
		INSERT tblTeamHierarchy SELECT @TeamID,@parentTeam,@TeamIn
		**/
