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
    strCommand = "spOOADaysUpdate"
    strGoTo = "AdminOoAdDetail.asp?RecID=" & request("RecID")
ELSEIF  strAction = "Add" THEN
    strCommand = "spOOADaysInsert"
	strGoTo = "AdminOoAdList.asp"
ELSE
	
END IF  
'response.write strAction & " * " & strCommand & " * " & strGoTo
'response.End()

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
set objPara = objCmd.CreateParameter ("OOADays",3,1,0, request("ooadays"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("AMBDays",3,1,0, request("ambdays"))
objCmd.Parameters.Append objPara


objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
'response.redirect "AdminRankDetail.asp?rankid=" + request("rankid")
response.redirect(strGoTo)
%>
