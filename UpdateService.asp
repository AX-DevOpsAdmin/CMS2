<!DOCTYPE HTML >
<!--#include file="Connection/Connection.inc"-->
<%
dim strCommand
dim strAction
dim strGoTo

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one
strAction=request("strAction")
IF strAction = "Update" THEN
    strCommand = "spServiceDetailUpdate"
    strGoTo = "AdminServiceDetail.asp?recID=" & request("recID")
ELSEIF  strAction = "Add" THEN
    strCommand = "spServiceDetailInsert"
	strGoTo = "AdminServiceAdd.asp"
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
IF strAction = "Update" THEN
    set objPara = objCmd.CreateParameter ("ServiceID",3,1,0, request("recID"))
    objCmd.Parameters.Append objPara
END IF

' Now set the common parameters
set objPara = objCmd.CreateParameter ("ShortDesc",200,1,50, request("txtService"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Description",200,1,100, request("txtDescription"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Status",3,1,0, request("Status"))
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
'response.redirect "AdminRankDetail.asp?recID=" + request("recID")
response.redirect(strGoTo)
%>