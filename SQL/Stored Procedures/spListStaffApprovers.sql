USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spListStaffAuthorisors]    Script Date: 05/24/2016 11:21:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spListStaffApprovers]
(
	@authID INT
)

AS
DECLARE @apprvID INT

-- Get the approver for this authorisation - ie: it's parent in the tblAuths hierarchy
SET @apprvID= (SELECT apprvID FROM tblAuths WHERE authID = @authID)

-- get all personnel authorised to approve the Auth Code that is currently being authorised
SELECT tblAuthorisor.staffID AS apprvID, shortDesc + ' ' + SUBSTRING(firstname,1,1) + ' ' + surname AS apprvname
   FROM tblAuthorisor
      INNER JOIN tblStaff ON tblStaff.staffID=tblAuthorisor.staffID
      INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID
      WHERE tblAuthorisor.authID=@apprvID