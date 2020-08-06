<!--#INCLUDE file= "AttachClsUpload.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%
'Const Hidden = 2

Dim objUpload
Dim strFileName
Dim strPath

Set oFSO = Server.CreateObject("Scripting.FileSystemObject")

' Instantiate Upload Class
Set objUpload = New clsUpload
strPage = objUpload.Fields("txtPage").value
strRecID = objUpload.Fields("RecID").value
strGoTo = objUpload.Fields("ReturnTo").value & "?RecID=" & strRecid

'Grab the file name
strOriginalName = objUpload.Fields("File1").FileName
'Grab the user specified file name
'strSpecifiedName = objUpload.Fields("txtSpecifiedName").value
'Get file extension
strFileExt = oFSO.GetExtensionName(strOriginalName)
'Get file name minus extension
strFileName = oFSO.GetBaseName(strOriginalName)

'response.write "File is " & intQORPartAID & " Name is " & strOriginalName
'response.End()

'Rebuild file name
'If strSpecifiedName <> "" Then
'	strSpecifiedName = strSpecifiedName & "." & strFileExt
'	strPathTemp = Server.MapPath("Upload/" & strOriginalName)
'	objUpload("File1").SaveAs strPathTemp
'	strPath = Server.MapPath("Upload/" & intQORPartAID  & "-@~" & getDTG(Now) & "-@~" & strSpecifiedName) '& "-@~" & strFriendlyName)
'	oFSO.MoveFile  strPathTemp, strPath
'Else
	'Response.Write strOriginalName & "<BR>"
	strPath = Server.MapPath("Upload/"  & strPage & "-@~" & strRecid & "-@~" & getDTG(Now) & "-@~" & strOriginalName) '& "-@~" & strOriginalName)
' Save the binary data to the file system
'response.write strPath
'response.End()
	objUpload("File1").SaveAs strPath
'End If	
' Release upload object from memory and redirect, no errors
	Set objUpload = Nothing
	Set oFSO = Nothing
	
' Now we update QOR791A record so we know documents are atached
'strSQL = "UPDATE tblQOR791PartA set QORPartAFolderID = " & 1 & " WHERE tblQOR791PartA.QORPartAID = " & intQORPartAID
'response.write strsql
'response.End()

'set comcommand=server.createobject("ADODB.command")
'    comcommand.Activeconnection = con
'	comcommand.CommandText = strSQL
'    comcommand.Execute
'    Set comcommand = Nothing

response.Redirect strGoTo

Function getDTG(cDTG)
	If UCase(Mid(cDTG, 7, 1)) = "Z" Then
		getDTG = cDTG
		Exit Function
	Else
		strDay = Day(cDTG)
		If strDay <= 9 Then
			strDay = "0" & strDay
		End If
		strMonth = UCase(Left(MonthName(Month(cDTG)), 3))
		strYear = Right(Year(cDTG), 2)
		strHour = Hour(cDTG)
		If strHour <= 9 Then
			strHour = "0" & strHour
		End If
		strMin = Minute(cDTG)
		If strMin <= 9 Then
			strMin = "0" & strMin
		End If
		getDTG = strDay & strHour & strMin & "Z" & strMonth & strYear
	End If
End Function

%>