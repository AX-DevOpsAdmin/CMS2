<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/authsecurity.inc"--> 

<%

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

strCommand = "spAdminPersAuthDetail"
objCmd.CommandText = strCommand

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("StaffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("asrID",3,1,5, request("asrID"))
objCmd.Parameters.Append objPara

set rsAuth = objCmd.Execute

set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
objCmd.Parameters.Append objPara

strCommand = "spGetAuthLimsCurrent"
objCmd.CommandText = strCommand

'response.write (request("StaffID") & " * " & request("asrID") & " * "  & nodeID)
'response.End()

set rslims = objCmd.Execute

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next
%>

<table border=0 cellpadding=0 cellspacing=0 width=97%>
	<tr>
		<td colspan=3>
			<table border=0 cellpadding=0 cellspacing=0 width=100%>
		  		<tr height=16>
					<td></td>
		  		</tr>
				<tr class="personalDetails" >
					<td  align="right">Authorisor:</td>
                    <td class=itemfont align="left">&nbsp;&nbsp;<%=rsAuth("name")%></td>
				</tr>
				<tr height=16>
					<td></td>
		  		</tr>
			</table>
	  	</td>
	</tr>
	<tr>
        <td width="48%" height="22px" valign="top">
           <div id="authlim">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td>
                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                            <tr class="personalDetails" >
                                <td height="25px" align="center">Current Limitations for <strong> <%=rsAuth("authlevel")%> </strong> From: <strong> <%=rsAuth("startDate")%> </strong> To: <strong><%=rsAuth("endDate")%></strong></td>
                                <td height="25px">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="3" height="20">&nbsp;</td>
                            </tr>
                            <tr>
                                <td class="ColorBackground" align="center">
                                   <select name="limsAdded" size="10" multiple class="" style="width:180px;" id="limsAdded" disabled=true > 
                                        <% do while not rslims.eof %>
                                            <option value="<%= rslims("almID") %>" ><%= rslims("authcode") %> </option>
                                            <% rslims.movenext %>
                                        <% loop %>
                                    </Select>
                                 
                                </td>
                                <td>&nbsp;</td>
                                
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            </div>
        </td>
	</tr>
	<tr>
		<td height="1px">&nbsp;</td>
	</tr>
</table>


