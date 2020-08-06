<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!DOCTYPE HTML >
<%
pageTitle="CMS"
'Stops the page retrieving data from cache
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
	Response.Expires = -1
	
'If user is not valid they are directed to accessdenied.asp, otherwise they are granted access
If session("LoggedOK") <> "TRUE" then
	Response.redirect("noaccess.asp")
End If

setlocale(2057)

dim strLogPage
dim strAdmin

strAdmin = session("Administrator") 

%>
