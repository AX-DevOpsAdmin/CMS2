<!DOCTYPE HTML >

<!--#include file="Connection/Connection.inc"-->

<%
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
	Response.Expires = -1
%>
<html>
<body >
Please wait while Excel is formatting your page............
</body>
</html>
<script language="javascript">
//setTimeout (alert("please Wait....."),100);
window.location = "HierarchyTeamTaskingOverviewtoExcel.asp?recId=<%=request("recID")%>&thisDate=<%=request("thisDate")%>&allTeams=<%=request("allTeams")%>"

//window.location = "HierarchyTeamTaskingOverviewtoExcel.asp?recId=<%=request("recID")%>&thisDate=<%=request("thisDate")%>&allTeams=<%=request("allTeams")%>&startDate=<%=request("sDate")%>&endDate=<%=request("eDate")%>"
</script>
<%
	'response.redirect ("HierarchyTeamTaskingOverviewtoExcel.asp?recId=" & request("recID") & "&thisDate=" & request("thisDate") )

%>
