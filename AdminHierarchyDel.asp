<!DOCTYPE HTML >

<!--#include file="Connection/Connection.inc"-->

<%
dim strCommand
dim strAction
dim strGoTo
dim strDelOK
dim strRecId

strGoTo = request("GoTo") 
strRecID = request("RecID")

'response.write ("hrcID is " & strRecid & " Go To is " & strGoTo)
'response.End()

' set  object commands
strCommand = "spDeleteHierarchy"
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con  
objCmd.CommandText = strCommand
objCmd.CommandType = 4						

set objPara = objCmd.CreateParameter ("hrcID",3,1,0, strRecID)
objCmd.Parameters.Append objPara
objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
response.redirect(strGoTo)
%>
