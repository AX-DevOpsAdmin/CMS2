<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strCommand
dim strAction
dim strGoTo

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one
strAction=request("strAction")
if strAction = "Update" then
	strCommand = "spMSUpdate"
	strGoTo = "AdminMSDetail.asp?recID=" & request("recID")
elseif strAction = "Add" then
	strCommand = "spMSInsert"
	strGoTo = "AdminMSAdd.asp"	
end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
if strAction = "Update" then
	set objPara = objCmd.CreateParameter ("MSID",3,1,0, request("recID"))
	objCmd.Parameters.Append objPara
else
	set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
	objCmd.Parameters.Append objPara
end if

if request("chkExempt") = 1 then
	intExempt = 1
else
	intExempt = 0
end if

if request("chkCombat") = 1 then
	blnCombat = 1
else
	blnCombat = 0
end if

if request("chkFear") = 1 then
	blnFear = 1
else
	blnFear = 0
end if

' Now set the common parameters
set objPara = objCmd.CreateParameter ("Description",200,1,100, request("MSDescription"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("MSVPID",3,1,4, request("VPID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Amber",3,1,4, request("txtAmberDays"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Exempt",3,1,4, intExempt)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Combat",11,1,1, blnCombat)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Fear",11,1,1, blnFear)
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
'response.redirect "AdminRankDetail.asp?recID=" + request("recID")
response.redirect(strGoTo)
%>
