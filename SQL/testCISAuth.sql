

declare	@hrcID			INT

DECLARE @qtID		INT
DECLARE @staffID	INT

set @hrcID=85
--DECLARE @fltID		INT
--DECLARE @sqnID		INT
--DECLARE @wingID		INT
--DECLARE @groupID	INT

-- temp table to hold list of units
WITH tblChild AS 
  (
     SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID
  )
  SELECT hrcID, hrcname INTO #tempunit FROM tblChild 

CREATE TABLE #tempqt
(
	qtID		INT
)

CREATE TABLE #tempstaff
(
	staffID		INT,
	assignno	VARCHAR(50),
	serviceno	VARCHAR(10),
	rank		VARCHAR(15),
	surname		VARCHAR(50),
	firstname	VARCHAR(25),
	post		VARCHAR(50)
)

CREATE TABLE #temparea
(
	staffID		INT,
	hrcname		VARCHAR(500),
	hrcparent	VARCHAR(500)
)

CREATE TABLE #tempq
(
	staffID		INT,
	expiry		DATETIME,
	days		INT,
	qdesc		VARCHAR(500),
	longdesc	VARCHAR(500),
	authname	VARCHAR(500)
)

CREATE TABLE #templist
(
	staffID		INT,
	assignno	VARCHAR(50),
	serviceno	VARCHAR(10),
	rank		VARCHAR(15),
	surname		VARCHAR(50),
	firstname	VARCHAR(25),
	wg		VARCHAR(50),
	sqn		VARCHAR(50),
	post		VARCHAR(50),
	expiry		DATETIME,
--	vpdays		INT,
	description	VARCHAR(50),
	longdesc	VARCHAR(300),
	authname	VARCHAR(20)
)

INSERT INTO #tempqt
	SELECT QTypeID
	FROM tblQTypes
	WHERE Auth = 1
	

----------------------------------------------------------------------------------------------------

DECLARE un1 SCROLL CURSOR FOR
	SELECT qtID FROM #tempqt

OPEN un1

FETCH NEXT FROM un1 INTO @qtID

WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO #tempq
			SELECT tblStaff.staffID, tblStaffQs.ValidFrom, tblValPeriod.vpdays, tblQs.Description, tblQs.LongDesc, tblStaffQs.AuthName
			FROM tblPost
			--FROM tblStaff
			INNER JOIN tblStaffPost ON tblStaffPost.PostID=tblPost.postID AND tblStaffPost.endDate IS NULL
			INNER JOIN tblStaff ON tblStaff.staffID=tblStaffPost.StaffID
			INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID AND tblRank.Weight <> 0
			INNER JOIN tblStaffQs ON tblStaffQs.TypeID = @qtID AND tblStaff.staffID = tblStaffQs.StaffID
			INNER JOIN tblQs ON tblStaffQs.QID = tblQs.QID
			INNER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
			WHERE tblPost.hrcID=@hrcID
	
			ORDER BY tblStaff.staffID
		
		FETCH NEXT FROM un1 INTO @qtID		
		
	END

CLOSE un1
DEALLOCATE un1

----------------------------------------------------------------------------------------------------

INSERT INTO #tempstaff
	SELECT tblStaff.staffID, tblPost.assignno, tblStaff.serviceno, tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblPost.description
	FROM #tempunit
	INNER JOIN tblPost ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblRank ON tblRank.rankID =tblPost.rankID AND tblRank.Weight <> 0
	INNER JOIN tblStaffPost ON tblStaffPost.postID=tblPost.postID
	INNER JOIN tblStaff ON tblStaff.staffID = tblStaffPost.StaffID AND tblStaff.rankID=tblRank.rankID
	WHERE (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) AND (tblPost.Ghost = 0)
	ORDER BY tblRank.Weight

----------------------------------------------------------------------------------------------------

INSERT INTO #temparea
SELECT sp.staffID, u.hrcname AS unit, p.hrcname AS parent
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblHierarchy u ON u.hrcID = p1.hrcID
	LEFT JOIN tblHierarchy p ON p.hrcID = u.hrcparentID
	WHERE (sp.enddate IS NULL OR sp.enddAte >= GETDATE())
/*****************
	SELECT sp.staffID, s.description as squadron, w.description as wing, g.description as group1
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblTeam t1 ON p1.teamID = t1.teamID
	LEFT JOIN tblTeam t2 ON t1.parentID = t2.teamID
	LEFT JOIN tblTeam t3 ON t2.parentID = t3.teamID
	LEFT JOIN tblFlight f ON t3.parentID = f.fltID
	LEFT JOIN tblSquadron s ON f.sqnID = s.sqnID
	LEFT JOIN tblWing w ON s.wingId = w.wingID
	LEFT JOIN tblGroup g ON w.grpID = g.grpID
	WHERE (t1.teamIn = 5) AND (sp.enddate IS NULL) OR (sp.enddAte >= GETDATE())
	
	
	UNION
	
	
	SELECT sp.staffID, s.description, w.description, g.description
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblTeam t1 ON p1.teamID = t1.teamID
	LEFT JOIN tblTeam t2 ON t1.parentID = t2.teamID
	LEFT JOIN tblFlight f ON t2.parentID = f.fltID
	LEFT JOIN tblSquadron s ON f.sqnID = s.sqnID
	LEFT JOIN tblWing w ON s.wingId = w.wingID
	LEFT JOIN tblGroup g ON w.grpID = g.grpID
	WHERE (t1.teamIn = 4) AND (sp.enddate IS NULL) OR (sp.enddAte >= GETDATE())
	
	
	UNION
	
	
	SELECT sp.staffID, s.description, w.description, g.description
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblTeam t1 ON p1.teamID = t1.teamID
	LEFT JOIN tblFlight f ON t1.parentID = f.fltID
	LEFT JOIN tblSquadron s ON f.sqnID = s.sqnID
	LEFT JOIN tblWing w ON s.wingId = w.wingID
	LEFT JOIN tblGroup g ON w.grpID = g.grpID
	WHERE (t1.teamIn = 3) AND (sp.enddate IS NULL) OR (sp.enddAte >= GETDATE())
	
	
	UNION
	
	
	SELECT  sp.staffID, NULL, w.description, g.description
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblTeam t1 ON p1.teamID = t1.teamID
	LEFT JOIN tblSquadron s ON t1.parentID = s.sqnID
	LEFT JOIN tblWing w ON s.wingID = w.wingID
	LEFT JOIN tblGroup g ON w.grpID = g.grpID
	WHERE (t1.teamIn = 2) AND (sp.enddate IS NULL) OR (sp.enddAte >= GETDATE())
	
	
	UNION
	
	
	SELECT  sp.staffID, NULL, NULL, g.description
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblTeam t1 ON p1.teamID = t1.teamID
--	INNER JOIN #tempunit ON p1.teamID = #tempunit.tmID
	LEFT JOIN tblWing w ON t1.parentID = w.wingID
	LEFT JOIN tblGroup g ON w.grpID = g.grpID
	WHERE (t1.teamIn = 1) AND (sp.enddate IS NULL) OR (sp.enddAte >= GETDATE())
*******/
----------------------------------------------------------------------------------------------------

INSERT INTO #templist
	SELECT #tempstaff.staffID, #tempstaff.assignno, #tempstaff.serviceno, #tempstaff.rank, #tempstaff.surname, #tempstaff.firstname, #temparea.hrcparent, 
	       #temparea.hrcname, #tempstaff.post, dateadd(d, #tempq.days, #tempq.expiry) AS expiry, #tempq.qdesc, #tempq.longdesc, #tempq.authname
	FROM #tempstaff
	INNER JOIN #tempq ON #tempstaff.staffID = #tempq.staffID
	INNER JOIN #temparea ON #tempstaff.staffID = #temparea.staffID

----------------------------------------------------------------------------------------------------

SELECT * FROM #templist

DROP TABLE #tempunit
DROP TABLE #tempqt
DROP TABLE #tempstaff
DROP TABLE #temparea
DROP TABLE #tempq
DROP TABLE #templist
