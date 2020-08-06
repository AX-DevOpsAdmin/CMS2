<!DOCTYPE HTML >
<!--#include file="Connection/Connection.inc"-->
<%
dim strCommand
dim strGoTo
strCommand = "spStaffPostUpdate"
strGoTo = "ManningPostStaff.asp?recID=" & request("recID")


set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

set objPara = objCmd.CreateParameter ("PostID",3,1,0, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("StaffID",3,1,0, request("StaffID"))
objCmd.Parameters.Append objPara
objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
response.redirect(strGoTo)
%>
