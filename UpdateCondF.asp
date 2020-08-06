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
    strCommand = "spCondFUpdate"
    strGoTo = "AdminCondFDetail.asp?RecID=" & request("RecID")
else
    strCommand = "spCondFInsert"
	strGoTo = "AdminCondFAdd.asp"
end if
	  
'response.write strAction & " * " & strCommand & " * " & strGoTo
'response.End()

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
if strAction = "Update" then
    set objPara = objCmd.CreateParameter ("RecID",3,1,0, request("RecID"))
    objCmd.Parameters.Append objPara
else  
' We're ADDING a new one so make sure the nodeID is set
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
    objCmd.Parameters.Append objPara
end if

' Now set the common parameters
set objPara = objCmd.CreateParameter ("MinVal",3,1,0, cInt(request("txtmin")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("MaxVal",3,1,0, cInt(request("txtmax")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Description",200,1,100, request("txtDescription"))
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
'response.redirect "AdminRankDetail.asp?rankid=" + request("rankid")
response.redirect(strGoTo)
%>
