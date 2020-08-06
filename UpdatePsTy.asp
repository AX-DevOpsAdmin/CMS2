<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%
dim strCommand
dim strAction
dim strGoTo

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one
' We can ADD here from either the Admin or Manning modules - so we pass where we want to go back to
' in strGoTo 
strAction=request("strAction")
if strAction = "Update" then
    strCommand = "spTaskTypeUpdate"
    strGoTo = "AdminPsTyDetail.asp?RecID=" & request("RecID")
else  
    strCommand = "spTaskTypeInsert"
	strGoTo = request("strGoTo")
end if

'response.write strAction & " * " & strCommand & " * " & strGoTo
'response.End()

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
'objCmd.CommandText = "spRankDetailUpdate"	'Name of Stored Procedure
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID'
if strAction = "Update" then
    set objPara = objCmd.CreateParameter ("recID",3,1,0, request("recID"))
    objCmd.Parameters.Append objPara
else
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
    objCmd.Parameters.Append objPara
end if

' Now set the common parameters
set objPara = objCmd.CreateParameter ("Description",200,1,100, request("Description"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Colour",200,1,100, request("txtcolor"))
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
'response.redirect "AdminRankDetail.asp?rankid=" + request("rankid")
response.redirect(strGoTo)
%>
