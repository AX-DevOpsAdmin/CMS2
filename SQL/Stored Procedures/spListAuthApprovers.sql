USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[spListAuthApprovers]    Script Date: 05/18/2016 08:59:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[spListAuthApprovers]
(
	@RecID INT,
	@atpID INT
)

AS
IF @RecID=0   -- we're ADDING so get ALL auths for this type
  BEGIN
     SELECT authID, authcode 
       FROM tblAuths 
         WHERE atpID = @atpID
  END
ELSE   -- we're EDITING do get ALL auths for this type EXCEPT the one we're editing
  BEGIN 
     SELECT authID, authcode 
       FROM tblAuths 
         WHERE atpID=@atpID AND authID <> @recID
  END