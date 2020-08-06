
<!--#include file="Connection/Connection.inc"-->

<%
Dim oConn
Dim oRs
Dim sSQL
Dim nFileID
	

nFileID = Request.QueryString("staffID")


strSQL = "SELECT * FROM tblStaffPhoto WHERE staffID = " & Request("staffID")
strCheckSQL = "SELECT * FROM tblDefaultPhoto"

set rsDefaultPhoto = Server.CreateObject("ADODB.Recordset")
rsDefaultPhoto.Open strCheckSQL, Con, 3, 3

set rsPhoto = Server.CreateObject("ADODB.Recordset")
rsPhoto.Open strSQL, Con, 3, 3

if rsPhoto("contentType") <> "" then
	Response.ContentType = rsPhoto("contentType")
	response.BinaryWrite rsPhoto("staffPhoto")
else
	Response.ContentType = rsDefaultPhoto("contentType")
	response.BinaryWrite rsDefaultPhoto("staffPhoto")
end if
	'Else
	'	Response.Write("File could not be found")
	'End If

	rsPhoto.Close
	Set rsPhoto = Nothing
	rsDefaultPhoto.Close
	Set rsDefaultPhoto = Nothing

	'Set oConn = Nothing
'Else
'	Response.Write("File could not be found")

%>

