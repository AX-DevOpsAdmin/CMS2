<%@ Language=VBScript %>
<%Option Explicit%>
<!--#include file="Connection/Connection.inc"-->
<!-- #include file="upload.asp" -->
<%

'NOTE - YOU MUST HAVE VBSCRIPT v5.0 INSTALLED ON YOUR WEB SERVER
'	   FOR THIS LIBRARY TO FUNCTION CORRECTLY. YOU CAN OBTAIN IT
'	   FREE FROM MICROSOFT WHEN YOU INSTALL INTERNET EXPLORER 5.0
'	   OR LATER.


' Create the FileUploader
Dim Uploader, File
Dim RS
Dim photoPath
photoPath = "c:\Inetpub\wwwroot\TCW\Asps\UploadedImages\"
Set Uploader = New FileUploader

' This starts the upload process
Uploader.Upload()

'******************************************
' Use [FileUploader object].Form to access 
' additional form variables submitted with
' the file upload(s). (used below)
'******************************************

' Check if any files were uploaded
If Uploader.Files.Count = 0 Then
	Response.Write "File(s) not uploaded."
Else
	' Loop through the uploaded files
	For Each File In Uploader.Files.Items
		'File.SaveToDisk photoPath	
		' Check where the user wants to save the file
		
			' Open the table you are saving the file to
			Set RS = Server.CreateObject("ADODB.Recordset")
			RS.ActiveConnection = con
			RS.locktype = 2
			RS.source = "select * from tblStaffPhoto where staffID=" & Uploader.Form("staffID")
			
			'response.write RS.source
			'response.End()
			
			RS.Open '"tblTasks", con, 2, 2
			'RS.Filter ="taskID = 53"
			'RS.AddNew ' create a new record
			
			RS("photoPath")    = photoPath & File.FileName
			RS("fileSize")	  = File.FileSize
			RS("contentType") = File.ContentType
		
			' Save the file to the database
			File.SaveToDatabase RS("staffPhoto")
			
			' Commit the changes and close
			RS.Update
			RS.Close
		
		' Output the file details to the browser
		Response.Write "File Uploaded: " & File.FileName & "<br>"
		Response.Write "Size: " & File.FileSize & " bytes<br>"
		Response.Write "Type: " & File.ContentType & "<br><br>"
		response.write "taskId=" & Uploader.Form("taskID") & "<br><br>"
	Next
End If
%>
<script language="javascript">
window.close()
</script>