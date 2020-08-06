<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->
<%
dim strCommand
dim strAction
dim strGoTo

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one'
strCommand = "spUpdateAcceptStaffAuths"
strGoTo = "<script language='javascript'>self.parent.location='cms_Hierarchy3.asp';</script>"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = strCommand
objCmd.CommandType = 4
						'Code for Stored Procedure'
set objPara = objCmd.CreateParameter ("@list",200,1,500, request("authlist"))
objCmd.Parameters.Append objPara
objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

con.close
set con=Nothing
'response.redirect "AdminSSCDetail.asp?recID=" + request("recID")'
response.write(strGoTo)
%>
