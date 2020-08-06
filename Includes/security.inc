<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>

<%
pageTitle="CMS"
'Stops the page retrieving data from cache
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
	Response.Expires = -1
	
'If user is not valid they are directed to accessdenied.asp, otherwise they are granted access
If session("CMS2CMSLogIn") <> "TRUE" then
	Response.redirect("noaccess.asp")
End If

setlocale(2057)

dim strLogPage
dim strAdmin
dim CMSAdmin

' strAdmin=local administrator for Hierarchy only
' CMSAdmin = FULL admin - should only be IMIX staff
 'strAuth=Authorisor   ' so can assign authorisations to staff and add authorisors
strAdmin = session("Administrator") 
CMSAdmin = session("CMSAdministrator") 
strAuth=session("authorisor")
loginID=session("StaffID")

' make sure the multi user element is looking at the correct data
nodeID=session("nodeID")

%>
