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
    strCommand = "spAuthTypeUpdate"
    strGoTo = "AdminAuthTypeDetail.asp?atpID=" & request("RecID")
elseif  strAction = "Add" then
    strCommand = "spAuthTypeInsert"
	strGoTo = "AdminAuthTypeAdd.asp"	
end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
if strAction = "Update" then
    set objPara = objCmd.createparameter("RecID",3,1,0, request("RecID"))
    objCmd.parameters.append objPara
else  
' We're ADDING a new one so make sure the nodeID is set
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 0)
    objCmd.Parameters.Append objPara
end if

' Now set the common parameters
set objPara = objCmd.createparameter("@Description",200,1,100, request("txtDescription"))
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@blnExists",11,2,1, blnExists)
objCmd.parameters.append objPara
objCmd.execute	'Execute CommandText when using "ADODB.Command" object

strError = objCmd.Parameters("@blnExists")

if strAction = "Add" then
	response.redirect(strGoTo & "?err=" & strError & "&description=" & request("txtDescription"))
else
	response.redirect(strGoTo)
end if
%>
