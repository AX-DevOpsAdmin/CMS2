<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strCommand
dim strAction
dim strGoTo

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one
strAction=request("strAction")
IF strAction = "Update" THEN
    strCommand = "spHmGiUpdate"
    strGoTo = "AdminHmGlDetail.asp?RecID=" & request("RecID")
ELSEIF  strAction = "Add" THEN
    strCommand = "spHmGiInsert"
	strGoTo = "AdminHmGlAdd.asp"
END IF  

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
'objCmd.CommandText = "spRankDetailUpdate"	'Name of Stored Procedure
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
if strAction = "Update" then
    set objPara = objCmd.CreateParameter ("RecID",3,1,0, request("RecID"))
    objCmd.Parameters.Append objPara
else
	set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
    objCmd.Parameters.Append objPara
end if

' Now set the common parameters
set objPara = objCmd.CreateParameter ("Description",200,1,100, request("Description"))
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

response.redirect(strGoTo)
%>
