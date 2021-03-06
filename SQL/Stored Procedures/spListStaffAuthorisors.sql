USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spListStaffAuthorisors]    Script Date: 05/24/2016 11:21:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[spListStaffAuthorisors]
(
	@authID INT
)

AS

-- get all personnel authorised to approve the Auth Code that is currently being authorised
SELECT tblAuthorisor.staffID AS authID, shortDesc + ' ' + SUBSTRING(firstname,1,1) + ' ' + surname AS authname
   FROM tblAuthorisor
      INNER JOIN tblStaff ON tblStaff.staffID=tblAuthorisor.staffID
      INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID
      WHERE tblAuthorisor.authID=@authID