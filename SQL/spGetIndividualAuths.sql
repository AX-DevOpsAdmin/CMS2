USE [90SUCMS]
GO
/****** Object:  StoredProcedure [dbo].[spGetIndividualAuths]    Script Date: 03/15/2017 11:39:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spGetIndividualAuths]
(
	@staffID			INT
)

AS

DECLARE @date DATETIME
DECLARE @d1 VARCHAR(50)
SET DATEFORMAT dmy

--SET @date = GETDATE()
SET @d1 = CONVERT ( VARCHAR(10) , GETDATE() ,120 )
SET @date = CONVERT ( datetime, @d1 ,120 )
    
DECLARE @qtID INT

CREATE TABLE #tempqt
(
	qtID		INT
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
	authname	VARCHAR(50)
)

----------------------------------------------------------------------------------------------------
/**
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
		
		FETCH NEXT FROM un1 INTO @qtID		
		
	END

CLOSE un1
DEALLOCATE un1
**/
INSERT INTO #tempq
     SELECT tblStaff.staffID, tblAuths.authCode,tblAuths.authTask, tblStaffAuths.enddate,  
            RTRIM(tr2.shortdesc) + ' ' + ts2.firstname + ' ' + ts2.surname AS authorisor,
            RTRIM(tr3.shortdesc) + ' ' + ts3.firstname + ' ' + ts3.surname AS approver, 
            tblStaffAuths.authOK, tblStaffAuths.apprvOK
	   FROM tblStaff
			INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID --AND tblRank.Weight <> 0
			INNER JOIN tblStaffAuths ON tblStaffAuths.staffID=tblStaff.staffID
			INNER JOIN tblStaff ts2 ON ts2.staffID=tblStaffAuths.authorisor
			INNER JOIN tblRank tr2 ON ts2.rankID = tr2.rankID
			INNER JOIN tblStaff ts3 ON ts3.staffID=tblStaffAuths.approver
			INNER JOIN tblRank tr3 ON ts3.rankID = tr3.rankID
			INNER JOIN tblAuths ON tblauths.authID=tblStaffAuths.authID
			WHERE  tblStaff.staffID=@staffID AND
			       tblStaffAuths.enddate >= @date AND 
			       tblStaffAuths.authOK=1 AND tblStaffAuths.apprvOK=1
			
----------------------------------------------------------------------------------------------------
INSERT INTO #tempstaff
	SELECT tblStaff.staffID, tblPost.assignno, tblStaff.serviceno, tblRank.shortDesc, tblStaff.surname, tblStaff.firstname, tblPost.description
	FROM tblStaff
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID
	INNER JOIN tblStaffPost ON tblStaff.staffID = tblStaffPost.StaffID
	INNER JOIN tblPost ON tblStaffPost.PostID = tblPost.postID
	WHERE (tblStaff.staffID = @staffID) AND (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= @date)
	ORDER BY tblStaff.staffID

----------------------------------------------------------------------------------------------------
INSERT INTO #temparea
SELECT sp.staffID, u.hrcname AS unit, p.hrcname AS parent
	FROM tblPost p1
	LEFT JOIN tblStaffPost sp ON p1.postID = sp.postID
	LEFT JOIN tblHierarchy u ON u.hrcID = p1.hrcID
	LEFT JOIN tblHierarchy p ON p.hrcID = u.hrcparentID
	WHERE (sp.enddate IS NULL OR sp.enddAte >= @date)
---------------------------------------------------------------------------------

INSERT INTO #templist
	SELECT #tempstaff.staffID, #tempstaff.assignno, #tempstaff.serviceno, #tempstaff.rank, #tempstaff.surname, #tempstaff.firstname, #temparea.hrcparent, #temparea.hrcname, 
	       #tempstaff.post, dateadd(d, 0, #tempq.expiry) as expiry, #tempq.auth, #tempq.task, #tempq.authorisor
	FROM #tempstaff
	INNER JOIN #temparea ON #tempstaff.staffID = #temparea.staffID
	LEFT JOIN #tempq ON #tempstaff.staffID = #tempq.staffID

----------------------------------------------------------------------------------------------------

SELECT * FROM #templist

DROP TABLE #tempqt
DROP TABLE #tempq
DROP TABLE #tempstaff
DROP TABLE #temparea
DROP TABLE #templist
