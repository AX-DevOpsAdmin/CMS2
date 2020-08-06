

USE RONCMS2
GO


/**  THIS GETS US ALL THE TABLE NAMES IN THE DATA BASE WE ARE MIGRATING
     NB: WE WOULD EXPECT TO RUN THIS ONLY ONCE PER DATABASE


DECLARE @name VARCHAR(100)
DECLARE @sql VARCHAR(2000)

set @sql=''
DECLARE tbl1 CURSOR SCROLL
    FOR SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
     
OPEN tbl1
FETCH NEXT FROM tbl1 INTO @name

WHILE @@FETCH_STATUS = 0
 BEGIN
 --select @name
     SET @sql= @sql + ',' + @name
	 FETCH NEXT FROM tbl1 INTO @name
 END

CLOSE tbl1
DEALLOCATE tbl1

SELECT @sql

**/

/** this is the list of table names - supplied from the cursor tbl1 above - so we go through these one by one to migrate the data 
 BUT - make sure we have set the recID's to the correct numbers BEFORE we migrate 

tbl_Task,
tbl_TaskCategory,
tbl_TaskStaff,
tbl_TaskUnit,
tblAudit,
tblCapability,
tblCapabilityCategory,tblCapabilityCategoryDetail,tblCondFormat,tblConfig,tblContact,tblCycle,tblCycleStage,
tblCycleSteps,tblDefaultPhoto,tblDental,tblDept,tblEquipmentTemp,tblFitness,tblFlight,tblGenericPW,tblGroup,tblGuidePageCoords,tblGuidePageDetails,tblHarmonyOverride,tblHarmonyPeriod,
tblHierarchy,tblManager,tblMES,tblMilitarySkills,tblMilitaryVacs,tblMSWeight,tblOOADays,tblOpAction,tblOpEqpt,tblOpTask,tblOpTaskCategory,tblOpTeam,tblPassword,tblPosition,tblPost,
tblPostMilSkill,tblPostQs,tblPostQStatus,tblQs,tblQTypes,tblQWeight,tblRank,tblRankWeight,tblReports,tblSquadron,tblSSC,tblStaff,tblStaffDental,tblStaffFitness,tblStaffHarmony,
tblStaffMilSkill,tblStaffMVs,tblStaffPhoto,tblStaffPost,tblStaffQs,tblStatus,tblTask,tblTaskClash,tblTasked,tblTaskNotes,tblTaskPending,tblTaskStatus,tblTaskType,tblTeam,tblTeamHierarchy,
tblTempHierarchy,tblTrade,tblTradeGroup,tblTrainingCourse,tblUnitHarmonyTarget,tblValPeriod,tblWing,tempQsRequiredByPost
DECLARE @name VARCHAR(100)
DECLARE @sql VARCHAR(2000)

*/


/** NOW - we get a string of field names for the table we are working on and using this we import the data
    NB: We would expect to run this for EVERY table identified in the table cursor above


DECLARE @name VARCHAR(100)
DECLARE @sql VARCHAR(2000)

set @sql=''
DECLARE fld1 CURSOR SCROLL
     FOR SELECT column_name from information_schema.columns where table_name = 'tbl_TaskStaff'
     
OPEN fld1
FETCH NEXT FROM fld1 INTO @name

WHILE @@FETCH_STATUS = 0
 BEGIN
 --select @name
     SET @sql= @sql + ',' + @name
	 FETCH NEXT FROM fld1 INTO @name
 END

CLOSE fld1
DEALLOCATE fld1

select @sql

-- THIS IS THE FIELD LIST WE WILL USE IN DATA IMPORT - WE HAVE TO CUT AND PASTE HERE
staffID,surname,firstname,serviceno,knownas,rankID,tradeID,statusID,administrator,homephone,mobileno,arrivaldate,postingduedate,passportno,passportexpiry,issueoffice,pob,poc,handbookissued,welfarewishes,postID,postoveride,ponotes,capoveride,capnotes,notes,picture,sex,dob,remedial,workPhone,dischargeDate,active,ddssa,ddssb,taskOOA,lastOOA,mesID,ddooa,exempt,weaponNo,susat,expiryDate,ndeID

**/


-- THIS IS THE BIT THAT MIGRATES THE DATA
-- NB: WE MUST USE IDENTITY_INSERT COS THIS ALLOWS US TO TO INSERT IDENTITY ID's WITHOUT TURNING THEM OFF IN THE DATA DESIGN

SET IDENTITY_INSERT tbl_TaskStaff ON

INSERT INTO tbl_TaskStaff 
  (taskStaffID,taskID,staffID,startDate,endDate,taskNote,cancellable,active,dateStamp,updatedBy,pending,ndeID)
  SELECT taskStaffID,taskID,staffID,startDate,endDate,taskNote,cancellable,active,dateStamp,updatedBy,pending,ndeID FROM  [RONCMS2Copy].[dbo].tbl_TaskStaff

SET IDENTITY_INSERT tbl_TaskStaff OFF


