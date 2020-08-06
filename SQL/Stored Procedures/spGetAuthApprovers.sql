USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spGetAuthApprovers]    Script Date: 05/18/2016 08:55:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[spGetAuthApprovers]
(
	@RecID INT,
	@atpID INT
)

AS
   SELECT authID, authcode 
     FROM tblAuths 
       WHERE atpID=@atpID AND authID <> @recID
         