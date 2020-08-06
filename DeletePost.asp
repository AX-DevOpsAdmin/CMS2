<!DOCTYPE HTML >

<!--#include file="Connection/Connection.inc"-->

<%
dim strCommand
dim strAction
dim strGoTo
dim strDelOK
dim strRecId

strGoTo = request("GoTo") 
strDelOk = request("delOK")
strRecID = request("RecID")

' set  object commands
strCommand = "spDeletePost"
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con  
objCmd.CommandText = strCommand
objCmd.CommandType = 4						

set objPara = objCmd.CreateParameter ("TeamID",3,1,0, strRecID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("DelOK",200,1,3, strDelOk)
objCmd.Parameters.Append objPara	
objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
response.redirect(strGoTo)
%>
