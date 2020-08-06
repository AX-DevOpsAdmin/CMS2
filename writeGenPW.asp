<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->
<!--#include file="includes/md5.asp" -->

<%
' Run when Staff updates their details in StaffUpdate.asp
dim strSQL ' SQL string to run against database

adParamInput = 1

strnewpass = trim(request.form("txtpw"))
stroldpass = trim(request.form("txtoldpw")) 
'strnewpass = md5(trim(request.form("txtpw")))
'stroldpass = md5(trim(request.form("txtoldpw")))

' now for the password create
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")

objCmd.ActiveConnection = con
objCmd.CommandText = "spSetGenPW"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("newpwd",200,1,100, strnewpass)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("oldpwd",200,1,100, stroldpass)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("strerr",200,2,50)
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' if the update failed then tell them
strError=objCmd.CreateParameter ("strerr")
IF strError <> "" THEN
  Response.Redirect "DuffGenPW.asp?strError=" & strError
END IF  

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
  
' All OK now go to main screen
Response.Redirect "AdminDataMenu.asp"
		  
%>

<!DOCTYPE HTML >
<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->

<title>Verify Staff Log-On</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

</body>
</html>
