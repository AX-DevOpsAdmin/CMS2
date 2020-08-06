<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="Connection/Connection.inc"-->
<%

' COMMAND Variables
dim adCmdText
dim adCmdStoredProc
dim adVarChar
dim adInteger
dim adParamInput 
dim setParm

' set COMMAND variable defaults
adCmdText = 1
adCmdStoredProc = 4
adVarChar = 200
adInteger = 3
adParamInput = 1

strStaffID=cint(session("StaffID"))

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4				'Code for Stored Procedure

strCommand = "spLogOff"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("StaffNo",3,1,5, strStaffID)
objCmd.Parameters.Append objPara
objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
 
session.Abandon
session.Contents.RemoveAll()

' Now go to main screen
Response.Redirect "logon.asp"

%>
