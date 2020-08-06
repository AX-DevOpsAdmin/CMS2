<!DOCTYPE HTML >
<!--#include file="Connection/Connection.inc"-->
<%

dim strCommand
dim strAction
dim strGoTo

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one
strAction=request("strAction")
IF strAction = "Update" THEN
    strCommand = "spCapabilityUpdate"
    strGoTo = "ManningCapabilityDetail.asp?recID=" & request("recID")
ELSEIF  strAction = "Add" THEN
    strCommand = "spCapabilityInsert"
	strGoTo = "ManningCapabilityAdd.asp"
ELSE
	
END IF  

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
IF strAction = "Update" THEN
    set objPara = objCmd.CreateParameter ("cpID",3,1,0, request("recID"))
    objCmd.Parameters.Append objPara
END IF

' Now set the common parameters
set objPara = objCmd.CreateParameter ("cptitle",200,1,50, request("cptitle"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("description",200,1,50, request("description"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("cpTeam",200,1,50, request("cpTeam"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("cpAerial",200,1,50, request("cpAerial"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("cpOther",200,1,50, request("cpOther"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("cp5Sqn",200,1,50, request("cp5Sqn"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("cpGSE",200,1,50, request("cpGSE"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("cpmgt",200,1,50, request("cpmgt"))
objCmd.Parameters.Append objPara


objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
response.redirect(strGoTo)
%>
