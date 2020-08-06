<!DOCTYPE HTML >

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

fixedWidth="210"

'response.write(rsRecSet("serviceNo"))
'response.end()
%>

<form action="" method="post" name="frmDetails" id="frmDetails">
	<input name="staffID" id="staffID" type="hidden" value="<%= rsRecSet("staffID") %>">
    <table border="0" cellpadding="0" cellspacing="8" width="95%" align="center">
        <tr class="personalDetails">
            <td>Name:</td>
            <td class=itemfont><%=rsRecSet("surname")%>, <%=rsRecSet("firstname")%></td>
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
            <td width="73%"><input name="startDate" type="text" class="itemfont" style="width: 75px" id="startDate" value="<%=rsRecSet("startdate")%>"/>&nbsp;
            <img src="Images/cal.gif" alt="From Date" width="16" align="absmiddle" height="16" style="cursor:hand" onclick="calSet(startDate)"></td>
        </tr>
        
        <tr class="personalDetails">
            <td>End Date:</td>
            <td><input name="endDate" type="text" class="itemfont" style="width: 75px" id="endDate" value="<%=rsRecSet("endDate")%>"/>&nbsp;
            <img src="Images/cal.gif" alt="To Date" width="16" align="absmiddle" height="16" style="cursor:hand" onclick="calSet(endDate)"></td>
        </tr>
        
        <tr class="personalDetails">
            <td valign="top">Notes:</td>
            <td class=itemfont><textarea name="notes" rows="5" id="notes" style="background-color:#f4f4f4; width: 280px"; class="itemfont" onfocus="this.select();"><%=rsRecSet("taskNote")%></textarea></td>
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
    <table border="0" cellpadding="0" cellspacing="0" width="95%" align="center">
    	<tr>
        	<td colspan="2">&nbsp;</td>
        </tr>
        <tr>
        	<td width="399" align="right"><a onclick="UpdateIndividual('<%= request("ttID")%>','<%= request("RecID")%>','<%=rsRecSet("taskStaffID")%>')"><img src="Images/saveitem.gif" style="cursor:hand;"></a></td>
            <td width="561" class="toolbar">&nbsp;Save and Close</td>
        </tr>
        <tr>
        	<td colspan="2">&nbsp;</td>
        </tr>

    </table>
</form>