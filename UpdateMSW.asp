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
    strCommand = "spMSWUpdate"
    strGoTo = "AdminMSWDetail.asp?recID=" & request("recID")
else  
    strCommand = "spMSWInsert"
	strGoTo = "AdminMSWAdd.asp"
end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
if strAction = "Update" then
    set objPara = objCmd.CreateParameter ("MSWID",3,1,0, request("recID"))
    objCmd.Parameters.Append objPara
else
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
    objCmd.Parameters.Append objPara
end if

' Now set the common parameters
set objPara = objCmd.CreateParameter ("MSWType",200,1,1, request("MSWType"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Description",200,1,50, request("Description"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("MSWValue",3,1,0, request("MSWValue"))
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
'response.redirect "AdminRankDetail.asp?recID=" + request("recID")
response.redirect(strGoTo)
%>
