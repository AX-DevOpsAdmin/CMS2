<!DOCTYPE HTML >
<!--#include file="Connection/Connection.inc"-->
<%
dim strCommand
dim strAction
dim strGoTo
dim strTaskType

strTaskType = cInt(request("cmbTTY"))

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one
strAction=request("strAction")
IF strAction = "Update" THEN
    strCommand = "spTaskUpdate"
    strGoTo = "AdminPsTaDetail.asp?recid=" & request("recid")
ELSEIF  strAction = "Add" THEN
    strCommand = "spTaskInsert"
	strGoTo = "AdminPsTaAdd.asp"
ELSE
	
END IF  
'response.write strAction & " * " & strCommand & " * " & strGoTo & " * " & request("cmbTTY") &  " * " & request("description")  
'response.End()

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
IF strAction = "Update" THEN
    set objPara = objCmd.CreateParameter ("recID",3,1,0, request("recID"))
    objCmd.Parameters.Append objPara
END IF

' Now set the common parameters
set objPara = objCmd.CreateParameter ("ttID",3,1,0, strTaskType)
objCmd.Parameters.Append objPara
'strparam = objpara

set objPara = objCmd.CreateParameter ("Task",200,1,100, request("description"))
objCmd.Parameters.Append objPara

'strParam = strparam & " ** " & objpara
'response.write strparam

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
'response.redirect "AdminRankDetail.asp?rankid=" + request("rankid")
response.redirect(strGoTo)
%>
