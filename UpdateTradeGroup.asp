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
    strCommand = "spTradeGroupUpdate"
    strGoTo = "AdminTradeGroupDetail.asp?tradegroupid=" & request("tradegroupid")
ELSEIF  strAction = "Add" THEN
    strCommand = "spTradeGroupInsert"
	strGoTo = "AdminTradeGroupAdd.asp"
ELSE
	
END IF  
'response.write strAction & " * " & strCommand & " * " & strGoTo & " * " & request("txtTG")
'response.End()

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						

' Here its UPDATE so pass the Record ID
if strAction = "Update" then
    set objPara = objCmd.CreateParameter ("TradeGroupID",3,1,0, request("TradeGroupID"))
    objCmd.Parameters.Append objPara
else  
' We're ADDING a new one so make sure the nodeID is set
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
    objCmd.Parameters.Append objPara
end if

' Now set the common parameters
set objPara = objCmd.CreateParameter ("TrGroup",200,1,50, request("txtTG"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Trade",200,1,50, request("txtdescription"))
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
response.redirect(strGoTo)
%>
