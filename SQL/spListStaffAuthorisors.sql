USE [90SUCMS]
GO
/****** Object:  StoredProcedure [dbo].[spListStaffAuthorisors]    Script Date: 03/15/2017 11:42:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[spListStaffAuthorisors]
(
	@authID INT
)

AS

DECLARE @date DATETIME
DECLARE @d1 VARCHAR(50)
SET DATEFORMAT dmy

--SET @date = GETDATE()
SET @d1 = CONVERT ( VARCHAR(10) , GETDATE() ,120 )
SET @date = CONVERT ( datetime, @d1 ,120 )

-- get all personnel authorised to approve the Auth Code AND they are still in date that is currently being authorised
SELECT tblAuthorisor.staffID AS authID, shortDesc + ' ' + SUBSTRING(firstname,1,1) + ' ' + surname AS authname
   FROM tblAuthorisor
      INNER JOIN tblStaff ON tblStaff.staffID=tblAuthorisor.staffID
      INNER JOIN tblRank ON tblRank.rankID=tblStaff.rankID
      WHERE tblAuthorisor.authID=@authID AND tblAuthorisor.enddate>= @date