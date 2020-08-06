<%
dim objFSO
dim objUpload
dim strFileName
dim strPath
dim strFiles
dim strList

strList = request("newattached")
strFiles = split(strList, ",")

set objFSO = server.createobject("Scripting.FileSystemObject")

for intCount = 1 to (ubound(strFiles))
   strPath = server.mappath("Documents" & "\" & strFiles(intcount))
   objFSO.DeleteFile(strPath)
next

' Release upload object from memory and redirect, no errors
set objFSO = nothing

response.Redirect("UploadExcel.asp")
%>