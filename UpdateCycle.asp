<!DOCTYPE HTML >
<!--#include file="Connection/Connection.inc"-->
<%
dim strCommand
dim strAction
dim strGoTo

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one
strAction=request("strAction")
IF strAction = "Update" THEN
    strCommand = "spCycleUpdate"
    strGoTo = "AdminCycleDetail.asp?RecID=" & request("RecID")
ELSEIF  strAction = "Add" THEN
    strCommand = "spCycleInsert"
	strGoTo = "AdminCycleAdd.asp"
ELSE
	
END IF  
'response.write strAction & " * " & strCommand & " * " & strGoTo
'response.End()

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
IF strAction = "Update" THEN
    set objPara = objCmd.CreateParameter ("RecID",3,1,0, request("RecID"))
    objCmd.Parameters.Append objPara
END IF

' Now set the common parameters
set objPara = objCmd.CreateParameter ("CycleERA",3,1,0, cInt(request("txtdays")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Description",200,1,100, request("Description"))
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
'response.redirect "AdminRankDetail.asp?rankid=" + request("rankid")
response.redirect(strGoTo)
%>
