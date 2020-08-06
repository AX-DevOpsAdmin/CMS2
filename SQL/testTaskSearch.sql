


DECLARE @task varchar(50)
DECLARE @ttID int
DECLARE @startDate varchar(50)
DECLARE @endDate varchar(50)
DECLARE @sort int
DECLARE @showOOA int

SET dateformat dmy

DECLARE @str varchar(2000)

DECLARE @noshow VARCHAR(50)
SET @noshow='Z-DO'

SET @task='Prom'
SET @ttID=21

SET @startDate=CAST(getdate() AS VARCHAR(12))
SET @endDate=CAST((getdate()+ 360) AS VARCHAR(12))
SET @showOOA=0

set @str = 'SELECT  tbl_Task.taskID, tbl_Task.ttID, tbl_Task.description AS task, tbl_Task.startDate, tbl_Task.endDate,'
set @str=@str+'tbl_Task.Cancellable, tbl_Task.ooa, tbl_Task.hqtask, tblTaskType.description AS Type '
set @str=@str+ 'FROM tbl_Task  INNER JOIN tblTaskType ON tbl_Task.ttID = tblTaskType.ttID '
set @str=@str+ '  WHERE tbl_Task.ttID <> 27 '

IF @task<>''
  set @str=@str+' AND tbl_Task.description like ' + '''' + @task +'%' + '''' 
ELSE
  set @str=@str+' AND tbl_Task.description NOT like ' + '''' + @noshow +'%' + '''' 


if @ttID <> 0
	Begin
	  set @str=@str + '  AND ttID = ' + convert ( varchar(3),@ttID )

	End

-- if we are tasking from Hierarchy DO NOT allow Out of Area ( OOA) tasking
-- this MUST be done via the Tasking module
if @showOOA = 0
   begin
    --set @str=@str + '  and ooa = ' +'''' + '0' + ''''
    set @str=@str + ' AND ooa = 0 ' 
   end

set @str=@str + ' ORDER BY tbl_Task.description '

/**
if @startDate <>'' and @endDate <>''
  Begin
   --set @str=@str + ' and startDate >= ' + '''' + @startDate + ''''
   --set @str=@str + ' and endDate <= ' + '''' + @endDate + ''''
   set @str=@str + ' and ((startDate >= ' + '''' + @startDate + ''' and startDate <= ' + '''' + @endDate + ''')'
   set @str=@str + ' or (enddate >= ' + '''' + @startDate + ''' and endDate <= ' + '''' + @endDate + ''')'

   set @str=@str + ' or (startDate <= ' + '''' + @startDate + ''' and endDate >= ' + '''' + @endDate + ''')) '
  End 
**/
--EXEC(@str)

SELECT @str
