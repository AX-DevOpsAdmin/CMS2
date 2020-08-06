
<%
	
'If user is not valid administrator then log them off
If session("Administrator") <> 1 then
	Response.redirect("noaccess.asp")
End If

%>
