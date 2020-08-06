<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%
dim strCommand
dim strAction
dim strGoTo

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one
strAction=request("strAction")
if strAction = "Update" then
    strCommand = "spFitnessUpdate"
    strGoTo = "AdminFitnessDetail.asp?recID=" & request("recID")
ELSE
    strCommand = "spFitnessInsert"
	strGoTo = "AdminFitnessAdd.asp"
END IF  

if request("chkCombat") = 1 then
	blnCombat = 1
else
	blnCombat = 0
end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
IF strAction = "Update" THEN
    set objPara = objCmd.CreateParameter ("fitnessID",3,1,0, request("recID"))
    objCmd.Parameters.Append objPara
else
    ' default to generic 90SU Fitness structure
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 1)
    objCmd.Parameters.Append objPara
END IF

' Now set the common parameters
set objPara = objCmd.CreateParameter ("Description",200,1,50, request("description"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("VPID",3,1,0, request("VPID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Combat",11,1,0, blnCombat)
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
'response.redirect "AdminRankDetail.asp?recID=" + request("recID")
response.redirect(strGoTo)
%>
