<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		


strCommand = "spPeRsDetail"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("StaffID"))
objCmd.Parameters.Append objPara

set rsPersonalDetails = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strCommand = "spGetStaffAuths"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID", 200,1,50, nodeID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("RecID",3,1,0, request("staffID"))
objCmd.Parameters.Append objPara

set rsAuths = objCmd.Execute

'response.write ("Count is " & rsAuths.recordcount)

%>

<table border=0 cellpadding=0 cellspacing=0 width=97%>
	<tr>
		<td colspan=3>
			<table border=0 cellpadding=0 cellspacing=0 width=100%>
		  		<tr height=16>
					<td></td>
		  		</tr>
				<tr class="personalDetails">
					<td width="70px">First Name:</td>
                    <td width="150px">
                    	<Div class=borderArea style="background-color:#FFFFFF;" >
                        	<table border=0 cellpadding=0 cellspacing=1>
                            	<tr>
                                	<td class=itemfont ><%=rsPersonalDetails("firstname")%>&nbsp;</td>
								<tr>
							</table>
						</Div>
					</td>
					<td width=10px></td>
					<td width="70px">Surname:</td>
                    <td width="150px">
                    	<Div class=borderArea style="background-color:#FFFFFF;">
                        	<table border=0 cellpadding=0 cellspacing=1>
                            	<tr>
                                	<td class=itemfont><%=rsPersonalDetails("surname")%>&nbsp;</td>
								<tr>
							</table>
						</Div>
					</td>
				</tr>
				<tr height=16>
					<td></td>
		  		</tr>
			</table>
	  	</td>
	</tr>
     <div id="containerDiv">
     
         <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td>
                   
                    <div id="A1" style="display:block; border:0; margin:0; padding:0;">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr class="toolbar">
                                <td width="2%" align="left" height="25px">&nbsp;</td>
                                <td width="15%" align="left" height="25px">Authorisation</td>
                                <td width="10%" align="center" height="25px">From</td>
                                <td width="10%" align="center" height="25px">To</td>
                                <td width="4%" align="center" height="25px">Status</td>
                                
                                <td width="20%" align="center" height="25px">Assessor</td>
                                <td width="4%" align="center" height="25px">Assessed</td>
                                <td width="10%" align="center" height="25px">Date</td>
                                <td width="20%" align="center" height="25px">Approver</td>
                                <td width="4%" align="center" height="25px">Approved</td>
                                <td width="10%" align="center" height="25px">Date</td>
                               
    
                            </tr>
                            <tr>
                                <td width="2%" class=titlearealine height=1></td>
                                <td colspan=10 class=titlearealine height=1></td> 
                            </tr>
                            <% do while not rsAuths.eof %>
                               <%
                                 strValidTo = rsAuths("enddate") 
                                 strAmberDate=strValidTo - 14 

                                 if rsAuths("authType") = 1 then 
							           strStatus="Images/black box.gif"
							     elseif rsAuths("authType") = 2 then 
									   if date >= strAmberDate and date <= strValidTo then 
								         strStatus="Images/yellow box.gif" 
									   else
									     strStatus="Images/green box.gif" 
									   end if
								 else 
								      strStatus="Images/red box.gif" 
								 end if
								   
								   'response.Write("Auth Type is " & rsAuths("authType") & " status is " & strStatus)
								%>
                              
                                <tr class="toolbar">
                                    <td width="2%" align="left" height="25px">&nbsp;</td>
                                    <td width="15%" align="left" height="25px"><%=rsAuths("authCode")%></td>
                                    <td width="8%" align="center" height="25px"><%=rsAuths("startdate")%></td>
                                    <td width="8%" align="center" height="25px"><%=rsAuths("enddate")%></td>
                                    <td width="2%" align="center" height="25px"><img src="<%=strStatus%>" alt="In Date" width="12" height="12"></td>
                                   
                                    <td width="20%" align="center" height="25px"><%=rsAuths("assessor")%></td>
                                    <td width="2%" align="center" height="25px">
                                      <% if rsAuths("assessed") = true then %>
                                        <img src="images/yes.gif">
                                      <% else %>
                                        <img src="images/no.gif">
                                      <%end if %>
                                        
                                    </td>
                                    <td width="8%" align="center" height="25px"><%=rsAuths("assessdate")%></td>
                                    <td width="20%" align="center" height="25px"><%=rsAuths("approver")%></td>
                                    <td width="2%" align="center" height="25px">
                                      <% if rsAuths("approved") = true then %>
                                        <img src="images/yes.gif">
                                      <% else %>
                                        <img src="images/no.gif">
                                      <%end if %>
                                    </td>
                                    <td width="8%" align="center" height="25px"><%=rsAuths("apprvdate")%></td>
                                    <td>&nbsp;</td>
    
                                </tr>
                               <%'end if %>
                            <% rsAuths.movenext %>
                            <% loop %>
                            <tr>
                                <td colspan="10">&nbsp;</td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
    </table>

     </div>
	<tr>
		<td height="1px">&nbsp;</td>
	</tr>
</table>
