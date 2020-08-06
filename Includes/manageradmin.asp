
<%
	
'If user is not valid manager for this Hierarchy structure then log them off
If strManager <> 1 then
	Response.redirect("noaccess.asp")
End If

%>
