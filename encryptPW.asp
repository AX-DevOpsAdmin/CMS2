<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>

<!--#include file="Connection/Connection.inc"-->
<!--#include file="includes/md5.asp" -->

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

'--------------------------------------------------------------------------------------------------------------------------------------
'Passwords from tblPassword
'--------------------------------------------------------------------------------------------------------------------------------------

' now get the user details
SET rsPW = Server.CreateObject("ADODB.Recordset")
SET rsPW.ActiveConnection = con 
rsPW.Source = "SELECT pwID, staffPW FROM tblPassword"
rsPW.CursorType = 3
rsPW.CursorLocation = 2
rsPW.LockType = 1
rsPW.Open
 
 ' now for the password create
set objPW = server.CreateObject("ADODB.Command")
objPW.ActiveConnection = con
objPW.CommandType = 1

objPW.prepared = false
rsPW.movefirst()
do while not rsPW.eof
	strpassword = md5(trim(rsPW("staffPW")))
	strPW = "UPDATE tblPassWord SET tblPassWord.staffPW = '" & strpassword & "' WHERE tblPassWord.pwID = '"  & rsPW("pwID") & "'"
	objPW.CommandText= strPW
	objPW.Execute
	rsPW.movenext()
loop


'--------------------------------------------------------------------------------------------------------------------------------------
'Password from tblGenericPW  
'--------------------------------------------------------------------------------------------------------------------------------------

' now get the user details
SET rsGPW = Server.CreateObject("ADODB.Recordset")
SET rsGPW.ActiveConnection = con 
rsGPW.Source = "SELECT gpwID, genericPW FROM tblGenericPW"
rsGPW.CursorType = 3
rsGPW.CursorLocation = 2
rsGPW.LockType = 1
rsGPW.Open
 
 ' now for the password create
set objGPW = server.CreateObject("ADODB.Command")
objGPW.ActiveConnection = con
objGPW.CommandType = 1

objGPW.prepared = false
rsGPW.movefirst()
do while not rsGPW.eof
	strgpassword = md5(trim(rsGPW("genericPW")))
	strGPW = "UPDATE tblGenericPW SET tblGenericPW.genericPW = '" & strgpassword & "' WHERE tblGenericPW.gpwID = '"  & rsGPW("gpwID") & "'"
	objGPW.CommandText= strGPW
	objGPW.Execute 
	rsGPW.movenext()
loop
  
response.redirect "AdminDataMenu.asp"

%>

