<!--#includeINCLUDE file= "Includes/clsUpload.asp"-->

<%
const Hidden = 2

dim objFSO
dim objFolder
dim objUpload
dim strFileName
dim strFileExtension

set objFSO = Server.CreateObject("Scripting.FileSystemObject")
set objFolder = objFSO.GetFolder(server.mappath("Documents/"))

Set objUpload = New clsUpload
	
strFileName = objUpload.Fields("file1").FileName
strFileExtension = objFSO.GetExtensionName(strFileName)
	
if strFileExtension = "xls" or strFileExtension = "XLS" then
	strFullPath = server.mappath("Documents") & "\" & strFileName	
	objUpload("file1").SaveAs strFullPath
end if	
	
' Release upload object from memory and redirect, no errors
set objUpload = nothing
set objFSO = nothing

response.Redirect("UploadExcel.asp")
%>