<!DOCTYPE HTML >

<!--#include file="Connection/Connection.inc"-->

<%
dim strCommand
dim strAction
dim strGoTo

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one
strAction=request("strAction")
if strAction = "Update" then
	strCommand = "spGroupUpdate"
	strGoTo = "AdminGroupDetail.asp?Groupid=" & request("GroupID")
elseif strAction = "Add" then
	strCommand = "spGroupInsert"
	strGoTo = "AdminGroupAdd.asp"
end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
if strAction = "Update" then
	set objPara = objCmd.CreateParameter ("GroupID",3,1,0, request("GroupID"))
	objCmd.Parameters.Append objPara
end if

' Now set the common parameters
set objPara = objCmd.CreateParameter ("Description",200,1,100, request("txtDescription"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("HQTask",3,1,0, request("HQTask"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("blnExists",11,2,1)
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

strError = objCmd.Parameters("blnExists")

if strAction = "Add" then
	response.redirect(strGoTo & "?err=" & strError & "&description=" & request("txtdescription") & "&hqtask=" & request("HQTask"))
elseif strAction = "Update" then
	response.redirect(strGoTo)
end if

response.redirect(strGoTo)
%>
