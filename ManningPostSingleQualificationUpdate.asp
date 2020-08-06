<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
Const Hidden = 2
competent = 0
Dim objUpload
Dim strFileName
Dim strPath
dim strFiles
dim strList

if request("competent") = "True" then competent = 1
strQTypeID = request ("QTypeID")

if request("postID") <> "" then
	strRecID = request("PostID")
	strGoTo = request("ReturnTo") & "?PostID=" & strRecid & "&QTypeID=" & strQTypeID
else
	strRecID = request("RecID")
	strGoTo = request("ReturnTo") & "?RecID=" & strRecid & "&QTypeID=" & strQTypeID
end if

      'Update a new record 
	   set comcommand=server.createobject("ADODB.command")
	   testText= "declare @currentStatus int declare @postID int "&_
	   " set @postId=(select postId from dbo.tblPostQs where tblPostQs.PostQID=" & request("PostQID") & ") "&_

	   " set @currentStatus = (SELECT dbo.tblQWeight.qwvalue FROM dbo.tblPostQs INNER JOIN dbo.tblPostQStatus ON dbo.tblPostQs.Status = dbo.tblPostQStatus.PostQStatus INNER JOIN "&_
       " dbo.tblQWeight ON dbo.tblPostQStatus.QWType = dbo.tblQWeight.qwtype where tblPostQs.PostQID=" & request("PostQID") & ") "&_
	   " update tblPost set qtotal=qtotal-@currentStatus where postID=@postID "&_
	   " update tblPost set qtotal=qtotal+ " & request("status") & "where postID=@postID "&_
	   " update tblPostQs set status ='"& request("status") &"', competent= '" & competent &"' where PostQID = '" & request("PostQID") &"'"

	   comcommand.CommandText = "declare @currentStatus int declare @postID int declare @status int "&_
	   " set @postId=(select postId from dbo.tblPostQs where tblPostQs.PostQID=" & request("PostQID") & ") "&_

	   " set @currentStatus = (SELECT dbo.tblQWeight.qwvalue FROM dbo.tblPostQs INNER JOIN dbo.tblPostQStatus ON dbo.tblPostQs.Status = dbo.tblPostQStatus.PostQStatus INNER JOIN "&_
       " dbo.tblQWeight ON dbo.tblPostQStatus.QWType = dbo.tblQWeight.qwtype where tblPostQs.PostQID=" & request("PostQID") & ") "&_
	   " set @status = (SELECT  dbo.tblQWeight.qwvalue FROM tblPostQStatus INNER JOIN dbo.tblQWeight ON dbo.tblPostQStatus.QWType = dbo.tblQWeight.qwtype where tblPostQStatus.PostQStatus ='" & request("status") & "'" & ") "&_
	   " update tblPost set qtotal=qtotal - @currentStatus where postID=@postID "&_
	   " update tblPost set qtotal=qtotal + @status where postID=@postID "&_
	   " update tblPostQs set status ='"& request("status") &"', competent= '" & competent &"' where PostQID = '" & request("PostQID") &"'"
	   comcommand.Activeconnection = con
	   comcommand.Execute
	   'response.write comcommand.CommandText'
	   Set comcommand = Nothing
	
	'response.end'
'response.write testText'
response.Redirect strGoTo
%>
