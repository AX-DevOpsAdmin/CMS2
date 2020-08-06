<!DOCTYPE HTML >

<!--#include file="Connection/Connection.inc"-->

<%
dim strCommand
dim strAction
dim strGoTo

strGoTo = request("goTo") 
strFrom = request("fromPage")

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one
strAction=request("strAction")
if strAction = "Update" then
	strCommand = "spTeamUpdate"
	strGoTo = strGoTo  & "?recID=" & request("recID")
elseif strAction = "Add" then
	strCommand = "spTeamInsert"
	strGoTo = "AdminTeamAdd.asp"
end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4					'Code for Stored Procedure

' Here its UPDATE/Delete so pass the Record ID
if strAction = "Update" then
	set objPara = objCmd.CreateParameter ("TeamID",3,1,0, request("recID"))
	objCmd.Parameters.Append objPara
end if

' Now set the common parameters
set objPara = objCmd.CreateParameter ("Description",200,1,50, request("txtDescription"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TeamIn",3,1,0, request("cmbTeamIn"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("ParentID",3,1,0, request("cmbParentID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TeamSize",3,1,0, request("TeamSize"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TeamCP",3,1,0, "0")
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Weight",3,1,0, request("Weight"))
objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("blnExists",3,1,0,0)
'objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

strError = objCmd.Parameters("blnExists")

if strAction = "Add" then
	response.redirect(strGoTo & "?err=" & strError & "&description=" & request("txtDescription") & "&tm=" & request("cmbTeamIn") & "&ty=" & request("cmbParentID") & "&ts=" & request("TeamSize") & "&wt=" & request("Weight"))
elseif strAction = "Update" then
	response.redirect(strGoTo)
end if

%>
