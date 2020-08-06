

--[hrcID],[teamID],[tblID],[ndeID],[hrcparentID],[hrclevel],[hrcname],[hrcchildren]

SET IDENTITY_INSERT CMS2.dbo.tblHierarchy ON
	INSERT INTO CMS2.dbo.tblHierarchy
			([hrcID],[teamID],[tblID],[ndeID],[hrcparentID],[hrclevel],[hrcname],[hrcchildren])
	SELECT [hrcID],[teamID],[tblID],[ndeID],[hrcparentID],[hrclevel],[hrcname],[hrcchildren] FROM tblHierarchy
SET IDENTITY_INSERT CMS2.dbo.tblHierarchy OFF