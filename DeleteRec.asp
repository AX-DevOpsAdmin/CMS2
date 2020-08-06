<!DOCTYPE HTML >

<!--#include file="Connection/Connection.inc"-->

<%
dim strCommand
dim strAction
dim strGoTo

strGoTo = request("GoTo") 

strCommand = "spDeleteRec"
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						

'response.write ("Staff is " & request("RecID") & " * " &  request("TabID") & " * " & request("TableName"))
'response.End()

set objPara = objCmd.CreateParameter ("TeamID",3,1,0, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TableId",200,1,50, request("TabID"))
objCmd.Parameters.Append objPara	
set objPara = objCmd.CreateParameter ("TableName",200,1,50, request("TableName"))
objCmd.Parameters.Append objPara	

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
response.redirect(strGoTo)
%>
