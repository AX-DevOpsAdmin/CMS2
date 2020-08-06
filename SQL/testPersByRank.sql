

DECLARE	@hrcID		INT
DECLARE	@sub		INT
DECLARE	@rankID	INT

DECLARE @unit	VARCHAR(25)
DECLARE @rank	VARCHAR(25)
DECLARE @rankwt	INT
DECLARE @first	INT
DECLARE @str VARCHAR(2000)
DECLARE @str1 VARCHAR(2000)

-- so we know its the first time through the cursor loop below
SET @first=0
SET @hrcID=32
SET @rankID = 3
SET @sub = 0
-- temp table to hold list of units
SET @str1 = ' '
WITH tblChild AS ( SELECT hrcID, hrcName FROM tblHierarchy WHERE hrcID=@hrcID 
 --UNION ALL 
   -- SELECT tblHierarchy.hrcID, tblHierarchy.hrcName FROM tblHierarchy JOIN tblChild ON tblHierarchy.hrcparentID=tblChild.hrcID
   )
SELECT hrcID, hrcname INTO #tempunit FROM tblChild 

-- temp table to hold all ranks within Unit Hierarchy
CREATE TABLE #temprank
(
	serviceNo varchar(50),
	rank varchar(50),
	firstname varchar(50),
	surname varchar(50),
	postDesc varchar(50)
)

-- now get the ranks of all the people in each team
INSERT INTO #temprank
	SELECT tblStaff.serviceno, tblRank.shortDesc, tblStaff.firstname, tblStaff.surname, tblPost.description
	FROM #tempunit
	INNER JOIN tblPost ON tblPost.hrcID = #tempunit.hrcID
	INNER JOIN tblStaffPost ON tblStaffPost.postID=tblPost.postID
	INNER JOIN tblStaff ON tblStaff.staffID = tblStaffPost.StaffID AND tblStaff.rankID=@rankID
	INNER JOIN tblRank ON tblStaff.rankID = tblRank.rankID	
	WHERE (tblStaffPost.endDate IS NULL OR tblStaffPost.endDate >= GETDATE()) AND (tblPost.Ghost = 0) 
	ORDER BY tblPost.Description
		
SELECT * FROM #tempunit

SELECT * FROM #temprank

DROP TABLE #tempunit
DROP TABLE #temprank
