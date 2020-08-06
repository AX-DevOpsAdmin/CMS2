
/**
This allows us to ADD a new top level Hierarchy to CMS so when we
receive a request for CMS we run this to create the VERY BASIC requirements to allow
the new user to logon - fom there they can add their own Hierarchy/Post/Staff etc
**/
DECLARE @hrcID INT
DECLARE @staffID INT
DECLARE @nodeID INT
DECLARE @tgID INT
DECLARE @trID INT
DECLARE @postID INT
DECLARE @rankID INT
DECLARE @pw VARCHAR(32)
DECLARE @pw1 VARCHAR(32)

DECLARE @unit VARCHAR(100)
DECLARE @surname VARCHAR(100)
DECLARE @firstname VARCHAR(100)
DECLARE @serviceno VARCHAR(100)

SET @unit='Rons Air Force'
SET @surname='IXTAdmin'
SET @firstname='IXT'
set @serviceno='123456RR'

-- First ADD the node - We MUST assign this to the correct Organisation
-- ie: Navy,Army,Air Force, MoD so check the tblOrganisation for the orgID
INSERT INTO tblNode (orgID, ndename)
              VALUES (3, @unit)   -- THESE MUST BE CHANGED AS NECCESSARY
SET @nodeID=@@IDENTITY

-- Now we create the Hierarchy 
INSERT INTO tblHierarchy (teamID,tblID,ndeID,hrcparentID,hrclevel,hrcname,hrcchildren)
                  VALUES (0,0,@nodeID,0,0,@unit,1)
SET @hrcID=@@IDENTITY

-- now insert a TradeGroup
INSERT INTO tblTradeGroup(TradeGroup, description,ndeID)
                  VALUES (1,'TG1',@nodeID)
SET @tgID=@@IDENTITY
-- now the Trade
INSERT INTO tblTrade(description,tradeGroupID,ndeID)
              VALUES('Trade 1',@tgID,@nodeID)
SET @trID=@@IDENTITY

-- Now the rank
INSERT  tblRank --(shortDesc,description,status,weightScore,weightScore,ndeID)
    SELECT shortDesc,[description],[status],[weight],[weightScore], @nodeID FROM tblRank WHERE ndeID=1
-- default to Sgt - they can change it on log-on
SET @rankID=(SELECT TOP 1 rankID FROM tblRank WHERE ndeID=@nodeID AND shortDesc='Sgt')

-- Now the rankweight
INSERT tblRankWeight --(shortDesc,description,status,weightScore,weightScore,ndeID)
    SELECT [description],[weight],@nodeID FROM tblRank WHERE ndeID=1

-- Now the tblConfig - logon won't work without this
INSERT INTO tblConfig (deptID,pla,tas,man,per,uni,cap,pre,fit,boa,sch,nom,ran,aut,ind,pos,rod,paq,ndeID)
              VALUES(0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,@nodeID)
              
--Now add a Post and assign to the Hierarchy we just added
INSERT INTO tblPost(assignno,description,teamID,positionDesc,rankID,tradeID,RWID,notes,qoveride,msoveride,overborne,manager,QTotal,Ghost,Status,ndeID,hrcID )
    VALUES ( '111111','ADMIN',0,'ADMIN',5,@trID,0,'',0,0,0,1,0,0,1,@nodeID,@hrcID)  
SET @postID=@@IDENTITY

-- Now add a Staff Record
INSERT INTO tblStaff (surname,firstname,serviceno,rankID,tradeID,administrator,arrivaldate,sex,dob,active, remedial,taskooa,ndeID)
               VALUES(@surname,@firstname,@serviceno,@rankID,@trID,1,GETDATE()-10,'M',GETDATE()-20000,1,0,0,@nodeID)
SET @staffID=@@IDENTITY

-- Now add the password

-- Now post them in
INSERT INTO tblStaffPost (StaffID,PostID,startDate,endDate)
                  VALUES (@staffID,@postID,GETDATE() - 7,NULL)
                  
SET @pw='password'
SET @pw1 = (select substring(master.dbo.fn_varbintohexstr(HashBytes('MD5', @pw)),3,32))
INSERT INTO tblPassword (staffID,staffpw,pswd,dPswd,expires,ndeID)
                 VALUES (@staffID,@pw,@pw1,@pw1, GETDATE() + 180, @nodeID)
                 
                  

