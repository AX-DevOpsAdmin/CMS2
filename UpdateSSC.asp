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
    strCommand = "spSSCUpdate"
    strGoTo = "AdminSSCDetail.asp?recID=" & request("recID")
ELSEIF  strAction = "Add" THEN
    strCommand = "spSSCInsert"
	strGoTo = "AdminSSCAdd.asp"
ELSE
	
END IF  
'response.write strAction & " * " & strCommand & " * " & strGoTo'
'response.write "type is " & request("sscType")
'response.End()'

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure'

' Here its UPDATE so pass the Record ID'
if strAction = "Update" then
    set objPara = objCmd.CreateParameter ("SSCID",3,1,0, request("recID"))
    objCmd.Parameters.Append objPara
else
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
    objCmd.Parameters.Append objPara
end if

' Now set the common parameters'
' Now set the common parameters'
set objPara = objCmd.CreateParameter ("SSCode",3,1,0, request("SSCode"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Description",200,1,100, request("Description"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("sscType",3,1,0, request("sscType"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("notes",200,1,500, request("txtnotes"))
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

con.close
set con=Nothing
'response.redirect "AdminSSCDetail.asp?recID=" + request("recID")'
response.redirect(strGoTo)
%>
