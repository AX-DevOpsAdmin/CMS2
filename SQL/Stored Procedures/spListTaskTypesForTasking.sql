USE [CMS2]
GO
/****** Object:  StoredProcedure [dbo].[spListTaskTypesForTasking]    Script Date: 05/18/2016 11:08:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [dbo].[spListTaskTypesForTasking]
  @nodeID INT
as
/** Ron 25/07/08 - this doesnt appear to be used - so use it now
    for getting list of tasktypes for tasking but only if they have Tasks attached
    that do not affect Harmony Status ie: ooa=0

select * from tblTaskType where Active=1 and ttid not in (12,13,14,15,16,21,24,26)
order by [section],[order] ,description
**/
select ttID, tblTaskTYpe.description, withlist,active,[section],[order] 
from tblTaskType
  where exists(select taskID from tbl_task 
                where tbl_task.ttID = tbltasktype.ttID AND ndeID=@nodeID AND
                      tbl_task.ooa=0)   
   and Active=1
     order by [section],[order] ,tblTaskTYpe.description
