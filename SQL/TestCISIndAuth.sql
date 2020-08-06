

DECLARE	@staffID			INT

SET DATEFORMAT dmy

DECLARE @qtID INT

SET @staffID=1375

CREATE TABLE #tempqt
(
	qtID		INT
)

CREATE TABLE #tempq
(
	staffID		INT,
	expiry		DATETIME,
	days		INT,
	qdesc		VARCHAR(50),
	longdesc	VARCHAR(300),
	authname	VARCHAR(50)
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
--	vpdays		INT,
	expiry		DATETIME,
	description	VARCHAR(50),
	longdesc	VARCHAR(300),
	authname	VARCHAR(20)
)

----------------------------------------------------------------------------------------------------

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
			
			FROM tblStaff
			INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID --AND tblRank.Weight <> 0
			INNER JOIN tblStaffQs ON tblStaffQs.TypeID = @qtID AND tblStaff.staffID = tblStaffQs.StaffID
			INNER JOIN tblQs ON tblStaffQs.QID = tblQs.QID
			INNER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
			WHERE tblStaff.staffID=@staffID
			/**
			FROM tblPost
			INNER JOIN tblStaffPost ON tblStaffPost.PostID=tblPost.postID AND tblStaffPost.endDate IS NULL
			INNER JOIN tblStaff ON tblStaff.staffID=tblStaffPost.StaffID
			INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID AND tblRank.Weight <> 0
			INNER JOIN tblStaffQs ON tblStaffQs.TypeID = @qtID AND tblStaff.staffID = tblStaffQs.StaffID
			INNER JOIN tblQs ON tblStaffQs.QID = tblQs.QID
			INNER JOIN tblValPeriod ON tblQs.vpID = tblValPeriod.vpID
			**/
			
			ORDER BY tblStaff.staffID
		
		FETCH NEXT FROM un1 INTO @qtID		
		
	END

CLOSE un1
DEALLOCATE un1

----------------------------------------------------------------------------------------------------
INSERT INTO #tempstaff
	SELECT tblStaff.staffID, tblPost.assignno, tblStaff.serviceno, tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblPost.description
	FROM tblStaff
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	WHERE (tblStaff.staffID = @staffID) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE())
	ORDER BY tblStaff.staffID

----------------------------------------------------------------------------------------------------
INSERT INTO #temparea
SELECT sp.staffID, u.hrcname AS unit, p.hrcname AS parent
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblHierarchy u ON u.hrcID = p1.hrcID
	LEFT JOIN tblHierarchy p ON p.hrcID = u.hrcparentID
	WHERE (sp.enddate IS NULL OR sp.enddAte >= GETDATE())
---------------------------------------------------------------------------------

INSERT INTO #templist
	SELECT #tempstaff.staffID, #tempstaff.assignno, #tempstaff.serviceno, #tempstaff.rank, #tempstaff.surname, #tempstaff.firstname, #temparea.hrcparent, #temparea.hrcname, 
	       #tempstaff.post, dateadd(d, #tempq.days, #tempq.expiry) as expiry, #tempq.qdesc, #tempq.longdesc, #tempq.authname
	FROM #tempstaff
	INNER JOIN #temparea ON #tempstaff.staffID = #temparea.staffID
	LEFT JOIN #tempq ON #tempstaff.staffID = #tempq.staffID

----------------------------------------------------------------------------------------------------
SELECT * FROM #tempq
SELECT * FROM #templist

DROP TABLE #tempqt
DROP TABLE #tempq
DROP TABLE #tempstaff
DROP TABLE #temparea
DROP TABLE #templist
