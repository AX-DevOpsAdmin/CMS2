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
    strCommand = "spRankDetailUpdate"
    strGoTo = "AdminRankDetail.asp?recID=" & request("recID")
ELSEIF  strAction = "Add" THEN
    strCommand = "spRankDetailInsert"
	strGoTo = "AdminRankAdd.asp"
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
if strAction = "Update" then
    set objPara = objCmd.CreateParameter ("RankID",3,1,0, request("recID"))
    objCmd.Parameters.Append objPara
else
    ' default to generic 90SU Rank structure
	set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 1)
	objCmd.Parameters.Append objPara
end if

' Now set the common parameters
set objPara = objCmd.CreateParameter ("ShortDesc",200,1,50, request("txtRank"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Description",200,1,100, request("txtDescription"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Status",3,1,0, request("Status"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Weight",3,1,0, request("Weight"))
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
'response.redirect "AdminRankDetail.asp?recID=" + request("recID")
response.redirect(strGoTo)
%>
