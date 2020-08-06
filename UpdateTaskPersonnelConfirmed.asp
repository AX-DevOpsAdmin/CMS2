<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%
color1="#f4f4f4"
color2="#fafafa"
counter=0 
row=0

'response.write ("Staff List is " & Request("newattached"))
'response.End()

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

		
Const Hidden = 2

Dim objUpload
Dim strFileName
Dim strPath
dim strFiles
dim strList

strRecID = request("RecID")
strGoTo = request("ReturnTo") & "?RecID=" & strRecid & "&StartDate=" & request("startDate") & "&EndDate=" & request("endDate")

IF Request("newattached") <> "" THEN
	strList = Request("newAttached")
	strNewStations = split(strList, ",")
	
	FOR intCount = 1 TO (UBound(strNewStations))

		'set comcommand=server.createobject("ADODB.command")
		'comcommand.CommandText = "declare @StaffID int set @StaffID= (select staffId from tblStaff where serviceNo = '"& strNewStations(intCount) &"') INSERT  into tbl_TaskStaff select taskID, @StaffID  , startDate,endDate,cancellable from tbl_Task where taskID= '"& strRecID &"'"
		'comcommand.Activeconnection = con
		'comcommand.Execute
		
		objCmd.CommandText = "spTaskPersonnelAddAfterCheck"	
		objCmd.CommandType = 4
	    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
		objCmd.Parameters.Append objPara					
		set objPara = objCmd.CreateParameter ("TaskID",3,1,0, request("RecID"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("staffID",3,1,0, strNewStations(intCount))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("currentUser",3,1,0, session("staffID"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("StartDate",200,1,16, request("startDate"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("EndDate",200,1,16, request("endDate"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("notes",200,1,2000, request("notes"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("id",3,1,0, 0)
		objCmd.Parameters.Append objPara		
		set objPara = objCmd.CreateParameter ("flag",3,1,0, 0)
		objCmd.Parameters.Append objPara
		objCmd.Execute			
		
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
	NEXT 
END IF

response.Redirect strGoTo%>
