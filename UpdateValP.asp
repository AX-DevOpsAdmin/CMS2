<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%
dim strCommand
dim strAction
dim strGoTo

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one'
strAction=request("strAction")
IF strAction = "Update" THEN
    strCommand = "spValPUpdate"
    strGoTo = "AdminValPDetail.asp?recID=" & request("recID")
ELSEIF  strAction = "Add" THEN
    strCommand = "spValPInsert"
	strGoTo = "AdminValPAdd.asp"
ELSE
	
END IF  
'response.write strAction & " * " & strCommand & " * " & strGoTo'
'response.End()'

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure'

' Here its UPDATE so pass the Record ID'
if strAction = "Update" then
    set objPara = objCmd.CreateParameter ("ValPID",3,1,0, request("recID"))
    objCmd.Parameters.Append objPara
else
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
    objCmd.Parameters.Append objPara
end if

' Now set the common parameters'
set objPara = objCmd.CreateParameter ("ValPLength",3,1,0, request("vpLength"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Description",200,1,100, request("Description"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("ValPType",3,1,0, request("vpType"))
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

con.close
set con=Nothing
'response.redirect "AdminValPDetail.asp?recID=" + request("recID")'
response.redirect(strGoTo)
%>
