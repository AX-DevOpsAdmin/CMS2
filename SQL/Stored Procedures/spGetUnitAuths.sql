USE [CMS2]
GO
/****** Object:  StoredProcedure [dbo].[spGetCISAuth]    Script Date: 07/06/2016 15:03:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spGetUnitAuths]
(
	@hrcID			INT
)

AS

DECLARE @qtID		INT
DECLARE @staffID	INT

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
	auth		VARCHAR(50),
	task        VARCHAR(300),
	expiry		DATETIME,
	authorisor	VARCHAR(50),
	approver    VARCHAR(50),
	authOK      BIT,
	apprvOK BIT
)

CREATE TABLE #templist
(
	staffID		INT,
	assignno	VARCHAR(50),
	serviceno	VARCHAR(10),
	rank		VARCHAR(15),
	surname		VARCHAR(50),
	firstname	VARCHAR(25),
	hrcparent	VARCHAR(50),
	hrcname		VARCHAR(50),
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
/********
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
****/
INSERT INTO #tempq
SELECT tblStaff.staffID, tblAuths.authCode,tblAuths.authTask, tblStaffAuths.enddate,RTRIM(tr2.shortdesc) + ' ' + ts2.firstname + ' ' + ts2.surname AS authorisor,
            RTRIM(tr3.shortdesc) + ' ' + ts3.firstname + ' ' + ts3.surname AS approver, 
            tblStaffAuths.authOK, tblStaffAuths.apprvOK  
			FROM tblPost
			INNER JOIN tblStaffPost ON tblStaffPost.PostID=tblPost.postID AND tblStaffPost.endDate IS NULL
			INNER JOIN tblStaff ON tblStaff.staffID=tblStaffPost.StaffID
			INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID AND tblRank.Weight <> 0
			INNER JOIN tblStaffAuths ON tblStaffAuths.staffID=tblStaff.staffID  AND
			       tblStaffAuths.enddate > GETDATE() AND 
			       tblStaffAuths.authOK=1 AND tblStaffAuths.apprvOK=1
			INNER JOIN tblStaff ts2 ON ts2.staffID=tblStaffAuths.authorisor
			INNER JOIN tblRank tr2 ON ts2.rankID = tr2.rankID
			INNER JOIN tblStaff ts3 ON ts3.staffID=tblStaffAuths.approver
			INNER JOIN tblRank tr3 ON ts3.rankID = tr3.rankID
			INNER JOIN tblAuths ON tblauths.authID=tblStaffAuths.authID
			WHERE tblPost.hrcID=@hrcID
----------------------------------------------------------------------------------------------------

INSERT INTO #tempstaff
	SELECT tblStaff.staffID, tblPost.assignno, tblStaff.serviceno, tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblPost.description
	FROM #tempunit
	INNER JOIN tblPost ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblStaffPost ON tblStaffPost.postID=tblPost.postID
	INNER JOIN tblStaff ON tblStaff.staffID = tblStaffPost.StaffID --AND tblStaff.rankID=tblRank.rankID
	INNER JOIN tblRank ON tblRank.rankID =tblStaff.rankID --AND tblRank.Weight <> 0
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

----------------------------------------------------------------------------------------------------

INSERT INTO #templist
	SELECT #tempstaff.staffID, #tempstaff.assignno, #tempstaff.serviceno, #tempstaff.rank, #tempstaff.surname, #tempstaff.firstname, #temparea.hrcparent, 
	       #temparea.hrcname, #tempstaff.post, dateadd(d, 0, #tempq.expiry) AS expiry, #tempq.auth, #tempq.task, #tempq.authorisor
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
