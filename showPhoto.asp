<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!DOCTYPE HTML >
<!--#include file="Connection/Connection.inc"-->

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->

<title>Uploaded Database Files</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<%

strSQL = "select staffID from tblStaffPhoto where staffid = '" & 540 & "'"

'response.write strsql
'response.End()

'Set oConn = Server.CreateObject("ADODB.Connection")
'set objCmd = server.CreateObject("ADODB.Command")
'set objPara = server.CreateObject("ADODB.Parameter")
'objCmd.ActiveConnection = con
'objCmd.CommandText = strSQL
'objCmd.CommandType = 4		

'set rsPhoto = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
set rsPhoto = Server.CreateObject("ADODB.Recordset")
    rsPhoto.ActiveConnection = con 
    rsPhoto.Source = strSQL
    rsPhoto.CursorType = 3
    rsPhoto.CursorLocation = 2
    rsPhoto.LockType = 1
    rsPhoto.Open

' Sometimes I personally have errors with one method on different servers, but the other works.
'oConn.Open "DRIVER=Microsoft Access Driver (*.mdb);DBQ=" & Server.MapPath("Files.mdb")
'oConn.Open "PROVIDER=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath("Files.mdb")

'response.write "<img src=""getPhoto.asp?FileID="&oRs.Fields("FileID").Value&"""><br>"
response.write "<img src=""getPhoto.asp?staffID="&rsPhoto.Fields("staffID").Value&"""><br>"
%>

<%
'response.write "<A href=""getPhoto.asp?staffID="&rsPhoto.Fields("staffID").Value&""">"&rsPhoto.Fields("staffID").Value&"</A><br>"

%>

</body>
</html>
