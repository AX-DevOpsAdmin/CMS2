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
    strCommand = "spHPUpdate"
    strGoTo = "AdminHPDetail.asp?recID=" & request("recID")
ELSEIF  strAction = "Add" THEN
    strCommand = "spHPInsert"
	strGoTo = "AdminHPList.asp"
ELSE
	
END IF  

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure'

' Here its UPDATE so pass the Record ID'
if strAction = "Update" then
    set objPara = objCmd.CreateParameter ("HPID",3,1,0, request("recID"))
    objCmd.Parameters.Append objPara
else
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
    objCmd.Parameters.Append objPara
end if


set objPara = objCmd.CreateParameter ("OOAPeriod",3,1,0, request("ooaper"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("OOARed",3,1,0, request("ooared"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("OOAAmber",3,1,0, request("ooaamber"))
objCmd.Parameters.Append objPara

set objPara = objCmd.CreateParameter ("SSCAPeriod",3,1,0, request("ssaper"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("SSCARed",3,1,0, request("ssared"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("SSCAAmber",3,1,0, request("ssaamber"))
objCmd.Parameters.Append objPara

set objPara = objCmd.CreateParameter ("SSCBPeriod",3,1,0, request("ssbper"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("SSCBRed",3,1,0, request("ssbred"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("SSCBAmber",3,1,0, request("ssbamber"))
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

con.close
set con=Nothing
'response.redirect "AdminHPDetail.asp?recID=" + request("recID")'
response.redirect(strGoTo)
%>
