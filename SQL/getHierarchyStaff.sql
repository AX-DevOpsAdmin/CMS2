



DECLARE @recID INT
DECLARE @allTeams int
DECLARE @thisDate varchar (16)
DECLARE @crumbtrail VARCHAR(200)

SET DATEFORMAT  DMY
SET @recID=30
SET @allTeams=0
SET @thisDate = '08/03/2016'
SET dateformat dmy

DECLARE @startofMonth	VARCHAR(16)

SET DATEFORMAT dmy

SET @startofMonth = RIGHT(@thisDate,8)
SET @startofMonth = '01 ' + @startofMonth

--EXEC spGetHierarchyTrail @recid

-- select @startofMonth

	BEGIN
		SELECT  tblPost.postID, tblPost.QTotal, assignno, weight, tblStaff.staffID AS staffid, 
		        SUBSTRING(tblRank.shortdesc, 1, LEN(shortdesc)) + ' ' +  SUBSTRING(firstname, 1,1) + ' ' + surname AS personnel, tblPost.manager,
		        startDate,endDate,CONVERT(DATETIME, @startofMonth)
		FROM tblPost
		   LEFT OUTER JOIN tblStaffPost ON
		     tblStaffPost.PostID = tblPost.postID AND ((@thisDate >= startDate AND @startofMonth <= enddate AND endDate >= GETDATE()) OR enddate IS NULL)
		   LEFT OUTER JOIN tblStaff ON
		     tblStaff.staffID = tblStaffPost.StaffID
		   LEFT OUTER JOIN tblRank ON
		     tblRank.rankID=tblStaff.rankID
		   --  LEFT OUTER JOIN tblManager ON tblManager.postID=tblPost.postID
		--WHERE ghost = 0 AND (teamID = @recID) AND @thisDate >= startDate AND (CONVERT(DATETIME, @startofMonth) <= CONVERT(DATETIME, enddate) OR enddate IS NULL)
		WHERE (tblPost.hrcID = @recID ) AND tblPost.Status = 1 AND Ghost=0 
		ORDER BY weight DESC, surname
		
	END
