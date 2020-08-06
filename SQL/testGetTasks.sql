

-- DECLARE @task varchar(50)
DECLARE @ttID int
DECLARE @startDate varchar(50)
DECLARE @endDate varchar(50)
--DECLARE @sort int
DECLARE @showOOA int

SET dateformat dmy

DECLARE @str varchar(500)

DECLARE @noshow VARCHAR(50)
SET @noshow='Z-DO'

set @str = 'select * FROM dbo.vw_Tasks where '

--set @str=@str+' task like ' + '''' + @task +'%' + '''' 

set @str=@str+' task NOT like ' + '''' + @noshow +'%' + '''' 


if @ttID <> 0
	Begin
	  set @str=@str + '  and ttID = ' + convert ( varchar(3),@ttID )

	End

-- if we are tasking from Hierarchy DO NOT allow Out of Area ( OOA) tasking
-- this MUST be done via the Tasking module
if @showOOA = 0
   begin
    --set @str=@str + '  and ooa = ' +'''' + '0' + ''''
    set @str=@str + ' and ooa = 0 ' 
   end

if @startDate <>'' and @endDate <>''
  Begin
   --set @str=@str + ' and startDate >= ' + '''' + @startDate + ''''
   --set @str=@str + ' and endDate <= ' + '''' + @endDate + ''''
   set @str=@str + ' and ((startDate >= ' + '''' + @startDate + ''' and startDate <= ' + '''' + @endDate + ''')'
   set @str=@str + ' or (enddate >= ' + '''' + @startDate + ''' and endDate <= ' + '''' + @endDate + ''')'

   set @str=@str + ' or (startDate <= ' + '''' + @startDate + ''' and endDate >= ' + '''' + @endDate + ''')) '
  End 

-- EXEC(@str)
