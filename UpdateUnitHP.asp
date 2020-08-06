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
    strCommand = "spUnitHPUpdate"
    strGoTo = "AdminUnitHPDetail.asp?recID=" & request("recID")
ELSEIF  strAction = "Add" THEN
    strCommand = "spUnitHPInsert"
	strGoTo = "AdminUnitHPList.asp"
ELSE
	
END IF  

'response.write request("ooagrnmin") & " * " & request("ooagrnmax") & " * " & request("ooagrnmax")
'response.End()

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

' Now set the common parameters - OOA first
set objPara = objCmd.CreateParameter ("OOAGreenMin",14,1,6, request("ooagrnmin"))
objCmd.Parameters.Append objPara
objCmd.Parameters("OOAGreenMin").Precision=5
objCmd.Parameters("OOAGreenMin").NumericScale=2
set objPara = objCmd.CreateParameter ("OOAGreenMax",14,1,6, request("ooagrnmax"))
objCmd.Parameters.Append objPara
objCmd.Parameters("OOAGreenMax").Precision=5
objCmd.Parameters("OOAGreenMax").NumericScale=2
set objPara = objCmd.CreateParameter ("OOAYellowMin",14,1,6, request("ooayelmin"))
objCmd.Parameters.Append objPara
objCmd.Parameters("OOAYellowMin").Precision=5
objCmd.Parameters("OOAYellowMin").NumericScale=2

set objPara = objCmd.CreateParameter ("OOAYellowMax",14,1,6, request("ooayelmax"))
objCmd.Parameters.Append objPara
objCmd.Parameters("OOAYellowMax").Precision=5
objCmd.Parameters("OOAYellowMax").NumericScale=2

set objPara = objCmd.CreateParameter ("OOAAmberMin",14,1,6, request("ooaambmin"))
objCmd.Parameters.Append objPara
objCmd.Parameters("OOAAmberMin").Precision=5
objCmd.Parameters("OOAAmberMin").NumericScale=2

set objPara = objCmd.CreateParameter ("OOAAmberMax",14,1,6, request("ooaambmax"))
objCmd.Parameters.Append objPara
objCmd.Parameters("OOAAmberMax").Precision=5
objCmd.Parameters("OOAAmberMax").NumericScale=2

set objPara = objCmd.CreateParameter ("OOARed",14,1,6, request("ooared"))
objCmd.Parameters.Append objPara
objCmd.Parameters("OOARed").Precision=5
objCmd.Parameters("OOARed").NumericScale=2

' now BNA
set objPara = objCmd.CreateParameter ("BNAGreenMin",14,1,6, request("bnagrnmin"))
objCmd.Parameters.Append objPara
objCmd.Parameters("BNAGreenMin").Precision=5
objCmd.Parameters("BNAGreenMin").NumericScale=2

set objPara = objCmd.CreateParameter ("BNAGreenMax",14,1,6, request("bnagrnmax"))
objCmd.Parameters.Append objPara
objCmd.Parameters("BNAGreenMax").Precision=5
objCmd.Parameters("BNAGreenMax").NumericScale=2

set objPara = objCmd.CreateParameter ("BNAYellowMin",14,1,6, request("bnayelmin"))
objCmd.Parameters.Append objPara
objCmd.Parameters("BNAYellowMin").Precision=5
objCmd.Parameters("BNAYellowMin").NumericScale=2

set objPara = objCmd.CreateParameter ("BNAYellowMax",14,1,6, request("bnayelmax"))
objCmd.Parameters.Append objPara
objCmd.Parameters("BNAYellowMax").Precision=5
objCmd.Parameters("BNAYellowMax").NumericScale=2

set objPara = objCmd.CreateParameter ("BNAAmberMin",14,1,6, request("bnaambmin"))
objCmd.Parameters.Append objPara
objCmd.Parameters("BNAAmberMin").Precision=5
objCmd.Parameters("BNAAmberMin").NumericScale=2

set objPara = objCmd.CreateParameter ("BNAAmberMax",14,1,6, request("bnaambmax"))
objCmd.Parameters.Append objPara
objCmd.Parameters("BNAAmberMax").Precision=5
objCmd.Parameters("BNAAmberMax").NumericScale=2

set objPara = objCmd.CreateParameter ("BNARed",14,1,6, request("bnared"))
objCmd.Parameters.Append objPara
objCmd.Parameters("BNARed").Precision=5
objCmd.Parameters("BNARed").NumericScale=2



objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

con.close
set con=Nothing
'response.redirect "AdminHPDetail.asp?recID=" + request("recID")'
response.redirect(strGoTo)
%>
