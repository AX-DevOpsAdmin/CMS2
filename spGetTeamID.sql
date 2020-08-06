

USE [CMS2]
GO
/****** Object:  StoredProcedure [dbo].[spLogOn]    Script Date: 09/09/2015 10:52:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.spGetTeamID

@hrcID INT,
@teamID INT OUT

AS

BEGIN
   SET @teamID=(SELECT teamID FROM tblHierarchy WHERE hrcID=@hrcID)
END