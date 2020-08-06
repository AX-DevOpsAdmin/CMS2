<!DOCTYPE HTML >

<!--#include file="Connection/Connection.inc"-->

<%
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = "spPostOutUpdate"
objCmd.CommandType = 4						'Code for Stored Procedure'

set objPara = objCmd.CreateParameter ("staffPostID",3,1,0, request("staffPostID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("endDate",200,1,12, request("endDate"))
objCmd.Parameters.Append objPara

objCmd.Execute	''Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing

'hrcID=request("hrcID")
'response.redirect("returnToTeamList.html")
%>
<script language="JavaScript">
  window.parent.refreshIframeAfterDateSelect("HierarchyTaskingView.asp")
</script>