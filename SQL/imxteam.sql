

DECLARE @recID INT
DECLARE @allTeams int
DECLARE @thisDate varchar (16)



SET dateformat dmy

SET @allTeams=0
SET @recID=355
SET @thisDate='08/05/2015'

select teamID, teamIn, ParentID,description,ParentDescription from vwTeamList where TeamId = @recID

exec spListTeamStaff @recID,@allTeams,@thisDate


/** stuf which might be usefull 

turn ID Incemental OFF/ON for data migration
SET IDENTITY_INSERT tablename ON
SET IDENTITY_INSERT tablename OFF


**/