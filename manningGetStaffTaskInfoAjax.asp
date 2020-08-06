
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
strCommand = "spStaffTaskNotes"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("staffTaskID",3,1,5, request("staffTaskID"))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strManager=request("strManager")

fixedWidth="210"
%>
    <table border="0" cellpadding="0" cellspacing="8" width="95%" align="center">
        <tr class="personalDetails">
            <td>Name:</td>
            <td class=itemfont><%=rsRecSet("surname")%>, <%=rsRecSet("firstname") %></td>
        </tr>
        <tr class="personalDetails">
            <td>Rank:</td>
            <td class=itemfont><%=rsRecSet("shortDesc")%></td>
        </tr>        
        <tr class="personalDetails">
            <td>serviceNo:</td>
            <td class=itemfont><%=rsRecSet("serviceNo")%></td>
        </tr>
        <tr class="personalDetails">
            <td>Task:</td>
            <td class=itemfont><%=rsRecSet("Description")%></td>
        </tr>
        <tr class="personalDetails">
            <td>Start Date:</td>
            <td class=itemfont><%=rsRecSet("startdate")%></td>
        </tr>        
        <tr class="personalDetails">
            <td>End Date:</td>
            <td class=itemfont><%=rsRecSet("endDate")%></td>
        </tr>        
        <tr class="personalDetails">
            <td valign="top">Notes:</td>
            <td class=itemfont><textarea rows="5" style="background-color:#f4f4f4; width: 280px"; class="itemfont" readonly><%=rsRecSet("taskNote")%></textarea></td>
        </tr>        
        <tr class="personalDetails">
            <td>Updated by:</td>
            <td class=itemfont><%if rsRecSet ("updatedBy") <> 0 then response.write rsRecSet("updatedByFullName") else response.write "Unknown"%></td>
        </tr>
        <tr class="personalDetails">
            <td>Date:</td>
            <td class=itemfont><%= formatdatetime(rsRecSet("dateStamp"), 2) %></td>
        </tr>
    </table>
    <table border="0" cellpadding="0" cellspacing="1" width="95%" align="center">
    	<tr>
        	<td colspan="2">&nbsp;</td>
        </tr>
    	<tr>
        	<td colspan="2" align="center">
			   <%' if cint(session("Administrator")) = 1 or session("Manager") = 1 then %>
               <% if strManager = 1 then %><a class="toolbar" onclick="Update('staffTaskID=<%= request("staffTaskID") %>','ttID=<%= request("ttID") %>','RecID=<%= request("RecID") %>')" style="cursor:hand;">Update</a><% else %>&nbsp;<% end if %></td>
        </tr>
        <tr>
        	<td colspan="2">&nbsp;</td>
        </tr>
	</table>