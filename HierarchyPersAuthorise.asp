<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  

<%
	set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	objCmd.CommandType = 4		

    tab=8
	strPage="AuthType"
	strTable = "tblAuthsType"
	strCommand = "spListTable"
	
	if request("atpID") <> "" then
	  strAuthType = request("atpID")
	end if
	
	
	objCmd.CommandText = strCommand
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 0)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
	objCmd.Parameters.Append objPara
	set rsAuthTypes = objCmd.Execute	''Execute CommandText when using "ADODB.Command" object

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
	
	strCommand = "spPeRsDetailSummary"
	objCmd.CommandText = strCommand
	
	set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("StaffID"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("startDate",200,1,20, request("thisDate"))
	objCmd.Parameters.Append objPara
	set rsRecSet = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
	
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
	
	 ' use this to determine if any auths exist and open relevant div in the order of
	 ' Pending/Current/History
	authflag=0 
	
	if not isnull(request("authflag")) then
		authflag = request("authflag")
	end if
%>

<script type="text/javascript" src="toggle.js"></script>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>Personnel Details</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<style type="text/css">
<!--
body {
	background-image: url();
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}

.style1 {color: #0000FF}
-->
</style>

</head>
<body>

<form action="editstaffauths.asp" method="POST" name="frmDetails">
        <input type="hidden" name="staffID" id="staffID" value="<%=request("staffID")%>">
        <input name="authID2" id="authID2" type="hidden" value="">
        <input name="apprvID2" id="apprvID2" type="hidden" value="">
        <input name="staID2" id="staID2" type="hidden" value="">
        <input name="fromdate" id="fromdate" type="hidden" value="">
        <input name="todate" id="todate" type="hidden" value="">
        <input type="hidden" name="ReturnTo" value="HierarchyPersAuthorise.asp">
        <input type="hidden" name="auhlist" id="authlist" value="">
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyStaffDetails.inc"--> 
        <tr>
        	<td class=titlearealine  height=1></td> 
        </tr>
        <tr class=SectionHeader>
            <td>
				<%' if strManager = 1 then %>
                    <table width="100%" border=0 cellpadding=0 cellspacing=0 >
                        <tr>
                            <td height="25px" class=toolbar width=6>&nbsp;</td>
                            <td height="25px" width="17px"><img class="imagelink" onClick="saveAccept();" src="images/saveitem.gif"></td>
                            <td width="30px" height="25px" valign="middle" class=toolbar>Save</td>
      					    <td height="25px" class=titleseparator valign="middle" width=27 align="center">|</td>
                            <td height="25px" width="17px"><a class=itemfontlink href="HierarchyPeRsAuthSelect.asp?staffID=<%=request("staffID")%>&thisdate=<%=request("thisDate")%>&goTo=Add"><img class="imagelink" src="images/editgrid.gif"></a></td>
                            <td width="155px" height="25px" valign="middle" class=toolbar>Request Authorisation</td>
      					    <td height="25px" class=titleseparator valign="middle" width=27 align="center">|</td>
    					    <td height="25px" width="16px"><a class=itemfontlink  href="HierarchyPeRsAuthSelect.asp?staffID=<%=request("staffID")%>&thisdate=<%=request("thisDate")%>&goTo=Remove"><img class="imagelink" src="images/editgrid.gif"></A></td>
    					    <td width="1313px" height="25px" valign="middle" class=toolbar >Remove Authorisations</td>

                        </tr>
                    </table>
                <% 'end if %>
    		</td>
    	</tr>
        <tr>
            <td>
                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr>
                    	<td height="22px" colspan=6>&nbsp;</td>
                    </tr>
                    <tr class=columnheading>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">First Name:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("firstname")%></td>
                        <td align="left" width="13%" height="22px">Surname:</td>
                        <td align="left" width="47%" height="22px" class=itemfont><%=rsRecSet("surname")%></td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Service No:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("serviceno")%></td>
                        <td align="left" width="13%" height="22px">Known as:</td>
                        <td align="left" width="47%" height="22px" class=itemfont><%=rsRecSet("knownas")%></td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Rank:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("rank")%></td>
                        <td align="left" width="13%" height="22px">Trade:</td>
                        <td align="left" width="47%" height="22px" class=itemfont><%=rsRecSet("trade")%></td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Post:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("post")%></td>
                        <td align="left" width="13%" height="22px">Unit:</td>
                        <td align="left" width="47%" height="22px" class=itemfont><%=rsRecSet("unit")%></td>
                    </tr>
                    <tr>
                    	<td colspan=5 height="22px">&nbsp;</td>
                    </tr>
                    <tr>
                    	<!--<td colspan=5 height=1 ></td> -->
                        <td colspan=5 class="titlearealine" height=1 ></td>
                    </tr>
				</table>
				<table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr class="SectionHeader toolbar">
                        <td width="2%" align="left" height="25px">&nbsp;</td>
                        <td width="100%" align="left" height="25px">Summary of Authorisations</td>
					</tr>
                    <tr>
                    	<td colspan="2">&nbsp;</td>
                    </tr>
    			</table>
                <div id="containerDiv">

					<%' do while not rsAuths.eof %>
						<%' intFlag = 0 %>
                        <table border="0" cellpadding="0" cellspacing="0" width="98%">
                            <tr class="toolbar">
                                <td height="25px" id="A1Img" align=left onclick="toggle('A1', 'A1Img','containerDiv');">
                                	<img src="images/plus.gif" width="18" id="A1Icon"> 
                                	<b>Pending</b>
                            	</td>
                            </tr>
                            <tr>
                                <td>
                                    <div id="A1" style="display:none; border:0; margin:0; padding:0;">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="toolbar">
                                                <td width="2%" align="left" height="25px">&nbsp;</td>
                                                <td width="10%" align="left" height="25px">Authorisation</td>
                                                <td width="7%" align="center" height="25px">Valid From</td>
                                                <td width="7%" align="center" height="25px">Valid To</td>
                                                <td width="6%" align="center" height="25px">Status</td>
                                                <td width="15%" align="left" height="25px">Assessor</td>
                                                <td width="6%" align="center" height="25px">Assessed</td>
                                                <td width="7%" align="center" height="25px">Date</td>
                                                <td width="15%" align="left" height="25px">Approver</td>
                                                <td width="6%" align="center" height="25px">Approved</td>
                                                <td width="7%" align="center" height="25px">Date</td>
                                                <td width="6%" align="center" height="25px">Limitation Notes</td>
												<td width="6%" align="center" height="25px">Accept</td>
                                            </tr>
                                            <tr>
                                                <td width="2%" class=titlearealine height=1></td>
                                                <td colspan=12 class=titlearealine height=1></td> 
                                            </tr>
                                            <% do while not rsAuths.eof %>
                                              <% if rsAuths("authType") = 1 then %>
											    <% intFlag = 1 %>
                                                <%
													'authflag = 1
													if authflag = 0 or authflag = "" then authflag=1
												%>   
           
                                                <tr class="toolbar">
                                                    <td width="2%" align="center" height="25px">
                                                      <img class="imagelink" src="images/info.gif" title="Click here for further details" onClick="javascript:ajaxFunction('GetAuthDetailsAjax.asp','authID=<%=rsAuths("authID")%>','Authorisation Details:<%=rsAuths("authCode")%>',100,100,250,600)" >
                                                    </td>
                                                    <%= strDescription %></A>
                                                    <% if rsAuths("assessed") = true then %>
                                                        <td width="10%" align="left" height="25px"><%=rsAuths("authCode")%></td>
                                                    <% else %>
                                                        <td width="10%" align="left" height="25px"><a href="javascript:editauth(<%=rsAuths("authID")%>,'<%=rsAuths("authCode")%>','<%=rsAuths("startdate")%>','<%=rsAuths("enddate")%>');"</a><%=rsAuths("authCode")%></td>
                                                    <% end if %>
                                                    <td width="7%" align="center" height="25px"><%=rsAuths("startdate")%></td>
                                                    <td width="7%" align="center" height="25px"><%=rsAuths("enddate")%></td>
                                                    <td width="6%" align="center" height="25px"><img src="Images/black box.gif" alt="In Date" width="12" height="12"></td>
                                                   
                                                    <td width="15%" align="left" height="25px"><%=rsAuths("assessor")%></td>
                                                    <td width="6%" align="center" height="25px">
                                                      <% if rsAuths("assessed") = true then %>
                                                        <img src="images/yes.gif">
                                                      <% else %>
                                                        <img src="images/no.gif">
                                                      <%end if %>
                                                    </td>
                                                    <td width="7%" align="center" height="25px"><%=rsAuths("assessdate")%></td>
                                                    <td width="15%" align="left" height="25px"><%=rsAuths("approver")%></td>
                                                   <td width="6%" align="center" height="25px">
                                                      <% if rsAuths("approved") = true then %>
                                                        <img src="images/yes.gif">
                                                      <% else %>
                                                        <img src="images/no.gif">
                                                      <%end if %>
                                                    </td>
                                                    <td width="7%" align="center" height="25px"><%=rsAuths("apprvdate")%></td>
                                                    <td width="6%" height="40px" align="center">
                                                    	<%if isnull(rsAuths("notes")) then%>
                                                        	-
                                                        <%else%>
                                                        	<img src="images/info.gif">
                                                        <%end if%>
                                                    </td>
                                                    <td width="6%" height="40px" align="center">
                                                    	<img src="images/no.gif">
                                                    </td>
                                                </tr>
                                               <%end if %>
                                               <% rsAuths.movenext %>
                                            <% loop %>
                                            <% if rsAuths.recordcount > 0 then %> 
                                                 <% rsAuths.movefirst %>
                                            <%end if%>
                                            <% if intFlag = 0 then %>
                                                <tr>
                                                    <td width="2%">&nbsp;</td>
                                                    <td colspan="12" align="left" height="22px" class="toolbar">No Pending Authorisations</td>
                                                </tr>
                                            <%end if%>
                                            <tr>
                                                <td colspan="13">&nbsp;</td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        
                        <table border="0" cellpadding="0" cellspacing="0" width="98%">
                            <tr class="toolbar">
                                <td height="25px" id="A2Img" align=left onclick="toggle('A2', 'A2Img','containerDiv');">
                                	<img src="images/plus.gif" width="18" id="A2Icon"> 
                                	<b>Current</b>
                            	</td>
                            </tr>
                            <tr>
                                <td>
                                    <div id="A2" style="display:none; border:0; margin:0; padding:0;">
                                    	<table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="toolbar">
                                                <td width="2%" align="left" height="25px">&nbsp;</td>
                                                <td width="10%" align="left" height="25px">Authorisation</td>
                                                <td width="7%" align="center" height="25px">Valid From</td>
                                                <td width="7%" align="center" height="25px">Valid To</td>
                                                <td width="6%" align="center" height="25px">Status</td>
                                                <td width="15%" align="left" height="25px">Assessor</td>
                                                <td width="6%" align="center" height="25px">Assessed</td>
                                                <td width="7%" align="center" height="25px">Date</td>
                                                <td width="15%" align="left" height="25px">Approver</td>
                                                <td width="6%" align="center" height="25px">Approved</td>
                                                <td width="7%" align="center" height="25px">Date</td>
                                                <td width="6%" align="center" height="25px">Limitation Notes</td>
                                                <td width="6%" align="center" height="25px">Accept</td>
                                            </tr>
                                            <tr>
                                                <td width="2%" class=titlearealine height=1></td>
                                                <td colspan=12 class=titlearealine height=1></td> 
                                            </tr>
                                            <% strRows=0%>
                                            <% do while not rsAuths.eof %>
                                              <% if rsAuths("authType") = 2 then %>
											    <% intFlag = 1 %>
                                                <% strRows=strRows + 1 %>
                                                <% if authflag=0 then authflag=2 %>
                                                <% strValidTo = rsAuths("enddate") %>
                                                <% strAmberDate=strValidTo - 14 %>
                                                <tr class="toolbar">
                                                    <td width="2%" align="center" height="25px">
                                                    	<img class="imagelink" src="images/info.gif" title="Click here for further details" onClick="javascript:ajaxFunction('GetAuthDetailsAjax.asp','authID=<%=rsAuths("authID")%>','Authorisation Details:<%=rsAuths("authCode")%>',100,100,250,600)">
                                                    </td>
                                                    <td width="10%" align="left" height="25px"><%=rsAuths("authCode")%></td>
                                                    <td width="7%" align="center" height="25px"><%=rsAuths("startdate")%></td>
                                                    <td width="7%" align="center" height="25px"><%=rsAuths("enddate")%></td>
														<% if date >= strAmberDate and date <= strValidTo then %>
                                                            <td width="6%" align="center" height="25px"><img src="Images/yellow box.gif" alt="In Date" width="12" height="12"></td>
                                                        <%else%>
                                                            <td width="6%" align="center" height="25px"><img src="Images/green box.gif" alt="In Date" width="12" height="12"></td>
                                                        <%end if %>
                                                    <td width="15%" align="left" height="25px"><%=rsAuths("assessor")%></td>
                                                    <td width="6%" align="center" height="25px">
														<% if rsAuths("assessed") = true then %>
                                                            <img src="images/yes.gif">
                                                        <% else %>
                                                            <img src="images/no.gif">
                                                        <%end if %>
                                                    </td>
                                                    <td width="7%" align="center" height="25px"><%=rsAuths("assessdate")%></td>
                                                    <td width="15%" align="left" height="25px"><%=rsAuths("approver")%></td>
													<td width="6%" align="center" height="25px">
														<% if rsAuths("approved") = true then %>
                                                        	<img src="images/yes.gif">
                                                        <% else %>
                                                        	<img src="images/no.gif">
                                                        <%end if %>
                                                    </td>
                                                    <td width="7%" align="center" height="25px"><%=rsAuths("apprvdate")%></td>
                                                    <td width="6%" height="40px" align="center">
                                                    	<%if isnull(rsAuths("notes")) then%>
                                                        	-
                                                        <%else%>
                                                        	<img src="images/info.gif" onClick="javascript:showLimitations('<%=rsAuths("notes")%>')" style="cursor:hand;">
                                                        <%end if%>
                                                    </td>
                                                    <td width="6%" height="40px" align="center">
                                                    	<% if rsAuths("accepted") = 0 then %>
                                                    		<input name="chkAccept" id="chkAccept" type="checkbox" value="<%=strRows%>-<%=rsAuths("staID")%>">
                                                        <% else %>
                                                        	<img src="images/yes.gif">
                                                        <% end if %>
                                                    </td>
                                                </tr>
                                               <%end if %>
                                               <% rsAuths.movenext %>
                                            <% loop %>
                                            <% if rsAuths.recordcount > 0 then %> 
                                                 <% rsAuths.movefirst %>
                                            <%end if%>
                                            <% if intFlag = 0 then %>
                                                <tr>
                                                    <td width="2%">&nbsp;</td>
                                                    <td colspan="12" align="left" height="22px" class="toolbar">No Current Authorisations</td>
                                                </tr>
                                            <%end if%>
                                            <tr>
                                                <td colspan="13">&nbsp;</td>
                                            </tr>
                                        </table>

                                    </div>
                                </td>
                            </tr>
                        </table>
                        
                        <table border="0" cellpadding="0" cellspacing="0" width="98%">
                            <tr class="toolbar">
                                <td height="25px" id="A3Img" align=left onclick="toggle('A3', 'A3Img','containerDiv');">
                                    <img src="images/plus.gif" width="18" id="A3Icon"> 
                                  <b>History</b>
                            	</td>
                                
                            </tr>
                            <tr>
                                <td>
                                    <div id="A3" style="display:none; border:0; margin:0; padding:0;">
                                    	<table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="toolbar">
                                                <td width="2%" align="left" height="25px">&nbsp;</td>
                                                <td width="10%" align="left" height="25px">Authorisation</td>
                                                <td width="7%" align="center" height="25px">Valid From</td>
                                                <td width="7%" align="center" height="25px">Valid To</td>
                                                <td width="6%" align="center" height="25px">Status</td>
                                                <td width="15%" align="left" height="25px">Assessor</td>
                                                <td width="6%" align="center" height="25px">Assessed</td>
                                                <td width="7%" align="center" height="25px">Date</td>
                                                <td width="15%" align="left" height="25px">Approver</td>
                                                <td width="6%" align="center" height="25px">Approved</td>
                                                <td width="7%" align="center" height="25px">Date</td>
                                                <td width="6%" align="center" height="25px">Limitation Notes</td>
                                                <td width="6%" align="center" height="25px">Accept</td>
                                            </tr>
                                            <tr>
                                                <td width="2%" class=titlearealine height=1></td>
                                                <td colspan=12 class=titlearealine height=1></td> 
                                            </tr>
                                            <% do while not rsAuths.eof %>
                                              <% if rsAuths("authType") = 3 then %>
											    <% intFlag = 1 %>
                                                <% if authflag=0 then authflag=3 %>
                                                <tr class="toolbar">
                                                    <td width="2%" align="left" height="25px">&nbsp;
                                                    	<img class="imagelink" src="images/info.gif" title="Click here for further details" onClick="javascript:ajaxFunction('GetAuthDetailsAjax.asp','authID=<%=rsAuths("authID")%>','Authorisation Details:<%=rsAuths("authCode")%>',100,100,250,600)">
                                                    </td>
                                                    <td width="10%" align="left" height="25px"><%=rsAuths("authCode")%></td>
                                                    <td width="7%" align="center" height="25px"><%=rsAuths("startdate")%></td>
                                                    <td width="7%" align="center" height="25px"><%=rsAuths("enddate")%></td>
                                                    <td width="6%" align="center" height="25px"><img src="Images/red box.gif" alt="In Date" width="12" height="12"></td>
                                                    <td width="15%" align="left" height="25px"><%=rsAuths("assessor")%></td>
                                                    <td width="6%" align="center" height="25px">
                                                      <% if rsAuths("assessed") = true then %>
                                                        <img src="images/yes.gif">
                                                      <% else %>
                                                        <img src="images/no.gif">
                                                      <%end if %>
                                                    </td>
                                                    <td width="7%" align="center" height="25px"><%=rsAuths("assessdate")%></td>
                                                    <td width="15%" align="left" height="25px"><%=rsAuths("approver")%></td>
                                                    <td width="6%" align="center" height="25px">
                                                      <% if rsAuths("approved") = true then %>
                                                        <img src="images/yes.gif">
                                                      <% else %>
                                                        <img src="images/no.gif">
                                                      <%end if %>
                                                    </td>
                                                    <td width="7%" align="center" height="25px"><%=rsAuths("apprvdate")%></td>
                                                    <td width="6%" height="40px" align="center">
                                                    	<%if isnull(rsAuths("notes")) then%>
                                                        	-
                                                        <%else%>
                                                        	<img src="images/info.gif" onClick="javascript:showLimitations('<%=rsAuths("notes")%>')" style="cursor:hand;">
                                                        <%end if%>
                                                    </td>
                                                    <td width="6%" height="40px" align="center">
                                                    	<img src="images/no.gif">
                                                    </td>
                                                </tr>
                                               <%end if %>
                                               <% rsAuths.movenext %>
                                            <% loop %>
                                            <% if rsAuths.recordcount > 0 then %> 
                                                 <% rsAuths.movefirst %>
                                            <%end if%>
                                            <% if intFlag = 0 then %>
                                                <tr>
                                                    <td width="2%">&nbsp;</td>
                                                    <td colspan="12" align="left" height="22px" class="toolbar">No Authorisation History</td>
                                                </tr>
                                            <%end if%>
                                            <tr>
                                                <td colspan="13">&nbsp;</td>
                                            </tr>
                                        </table>

                                    </div>
                                </td>
                            </tr>
                        </table>


                        <%' rsAuthTypes.movenext %>
                    <%' loop %>
                </div>
			</td>
		</tr>
	</table>
</form>

        <form name="frmRon">
        <input type=hidden name="authID" id="authID" value="">
        
        <div id="PopUpwindow1" class="AuthPopUpWindow">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr height="22">
                    <td colspan="3" class="MenuStyleParent" align="Center"><u>Confirm Authorisation Details</u></td>
                </tr>
                <tr>
                    <td colspan="3" height="22px">&nbsp;</td>
                </tr>
                <tr class="columnheading">
                    <td valign="middle" height="22" width="1%"></td>
                    <td valign="middle" height="22" width="46%">Authorisation Code:</td>
                    <td valign="middle" height="22" width="53%" class="toolbar"><DIV  id="QName"></DIV></td>
                </tr>
                <tr class="columnheading">
                    <td valign="middle" height="22" width="1%"></td>
                    <td valign="middle" height="22" width="46%">Valid From:</td>
                    <td valign="middle" height="22" align="left" width="53%" class="itemfont">
                        <input name="DateAttained" type="text" id="DateAttained" class=" itemfontEdit inputboxEdit"  style="Width:85px;"  value ="" readonly onclick="calSet(this)">&nbsp;
                        <img src="images/cal.gif" alt="Calender" onclick="calSet(DateAttained)" align="middle" style="cursor:hand;">
                    </td>
      
                </tr>
                <tr class="columnheading">
                    <td valign="middle" height="22" width="1%"></td>
                    <td valign="middle" height="22" align="left" width="46%">Valid To:</td>
                    <td valign="middle" height="22" align="left" width="53%" class="itemfont">
                        <input name="DateTo" type="text" id="DateTo" class=" itemfontEdit inputboxEdit"  style="Width:85px;"  value ="" readonly onclick="calSet(this)">&nbsp;
                        <img src="images/cal.gif" alt="Calender" onclick="calSet(DateTo)" align="middle" style="cursor:hand;">
                    </td>
                </tr>
                <tr class="columnheading">
                    <td width="1%" align="left" height="22px">&nbsp;</td>
                    <td width="46%" align="left" height="22px">Assessor:</td>
                    <td width="53%" align="left" height="22px">
                         <div id="apprvr"> 
                            <select name="apprvID" id="apprvID" class="itemfont" style="width: 100px">
                                <option value="0">None</option>
                            </Select>
                         </div>
                     </td>
                </tr>
                <tr>
                    <td colspan="3" height="22px">&nbsp;</td>
                </tr>

                <tr>
                    <td height="22px">&nbsp;</td>
                    <td align="right" height="22"><Input CLASS="StandardButton" Type=Button  Value=OK onclick="javascript:saveAuth('DateAttained','DateTo','apprvID');"></td>
                     <td  align="center"  height="22"><Input CLASS="StandardButton" Type=Button  Value=Cancel onclick="cancelpopup()"></td>
                </tr>
                <tr>
                    <td colspan="3" height="22px">&nbsp;</td>
                </tr>
            </table>
        </div>
    </form>

	<%
    windowWidth=200
    windowHeight=200%>
    
    <Div id="detailWindow" style="background-color:#f4f4f4;visibility:hidden;">
        <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
            <tr class="SectionHeader">
                <td>
                    <div id="detailWindowTitleBar" style="position:relative;left:7px;top:0px;width:100%;border-color:#7f9db9;"> 
                        <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
                            <tr> 
                                <td id="windowName" class="itemfont"></td>
                                <td align="right" ><img src="images/windowCloseIcon.png" style="cursor:pointer;" onClick="javascript:closeThisWindow('detailWindow');"></td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="titlearealine" height="1"><img height="1" src="Images/blank.gif"></td> 
            </tr>            
            <tr>
                <td align="left" class="itemfont">
                    <div id="innerDetailWindow" style="Overflow:auto;background-color:#f4f4f4;color:#000000;position:relative;height:100%;width:100%"> 
                        <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
                            <tr class="itemfont"> 
                                <td>&nbsp;</td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </Div>
    
</body>
</html>

<script type="text/javascript" src="calendar.js"></script>

<script language="javascript">
var dispdiv=<%=authflag%>;
//alert(dispdiv);
checkauthdiv(dispdiv);

function checkauthdiv(dispdiv){
	//alert(dispdiv);
	if(dispdiv==1){
		document.getElementById("A1").style.display = 'block';
	}
	else if(dispdiv==2){
		document.getElementById("A2").style.display = 'block';
	}
	else if(dispdiv==3){
		document.getElementById("A3").style.display = 'block';
	}
	
}

// Just clicked on the authcode so open form for update of details ( To/From date and assessor )
function editauth(authID, authcode, dstart, dend)
{
	//alert( "auth is  " + authID + " * " + authcode + " * " +  dstart + " * " + dend);
		
	document.getElementById("authID").value = authID;
   
    getAssessors(authID);
	document.frmRon.DateAttained.value = dstart;
	document.frmRon.DateTo.value = dend;
	document.getElementById('PopUpwindow1').style.visibility = "Visible";
	document.getElementById('QName').innerHTML=authcode;
	
}

// get data for assessors drop down list
function getAssessors(authID)
{
	var staffID=document.getElementById("staffID").value;
	var str = 'authID='+authID+'&staffID='+staffID
	ajax('ddStaffAuthorisors.asp',str,'apprvr');
	
}

//----------------standard ajax function with option for secondary function----------------
function ajax(url,strMessage,div,func,loading){
     //prompt('',url+'?'+strMessage + '?'+div+'?'+func+'?'+loading)
  
    //var str = 'pagesize='+pagesize+'&filSearch='+crsenum+' &orderBy='+orderBy+'&dir='+dir + ' &searchby=number ';
	//prompt("",'userlist.asp?'+str)
	//ajax('courselist.asp',str,'List');
  
  
	if(loading){
		//document.getElementById(div).innerHTML = '<div align="center" style="width:100%; margin-top:250px;"><img src="images/loading1.gif"/><div style="margin-bottom:10px; color:#999;">Loading</div> <div>'
		//document.getElementById("loading").style.display = 'block';
		loadingImg(loading);
	}
	var timeoutcounter = 0;	//Count ajax call as being active, reset the countdown counter.
	var xhr;  
	if (typeof XMLHttpRequest !== 'undefined') {
		xhr = new XMLHttpRequest(); 
	}
	else{  
		var versions = ["MSXML2.XmlHttp.6.0",
						"MSXML2.XmlHttp.5.0",
						"MSXML2.XmlHttp.4.0",
						"MSXML2.XmlHttp.3.0",
						"MSXML2.XmlHttp.2.0",
						"Microsoft.XmlHttp"];
		for(var i = 0; i < versions.length; i++){  
			try{  
				xhr = new ActiveXObject(versions[i]);
				break;  
			}  
			catch(e){}  
		} 
	}  
	xhr.onreadystatechange = function(){ 
		if ((xhr.readyState === 4) && (xhr.status === 200)){
			
			  // alert(xhr.responseText);
				//if there is a div specified then place the response text inside.
				if (div !== ''){
					document.getElementById(div).innerHTML = xhr.responseText;
				
				}
				//alert(document.getElementById(div).innerHTML)
				//If there is a function (func) specified then run it.
				if (func){
					//alert("into func " + xhr.responseText);
					eval(func);
				}
				if(loading){
					document.getElementById("loading").style.display = 'none';
				}
				//alert("Yep")
		}
		else if ((xhr.readyState === 4) && (xhr.status !== 200)){
			window.open("error.asp?code="+xhr.responseText)
			//prompt("",xhr.responseText)
		}
		else{
			return;
		}
	}  
	xhr.open("post",url,true);
	xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	
	//alert("out of ajax");
	xhr.send(strMessage);
	//xhr.send(encodeURI(strMessage)); 
}

function cancelpopup() 
{
	document.getElementById('PopUpwindow1').style.visibility = 'Hidden';
}

// We have just amended an existing Auth so save the changes
function saveAuth(DateAttained,DateTo, apprvID)
{
	var errMsg = "";
	
	var authID=document.getElementById("authID").value;
	document.getElementById("authID2").value = authID;
	
	var staID=document.getElementById("staID").value;
	document.getElementById("staID2").value = staID;
	
	var dateStr=document.all[DateAttained].value;
	var datetoStr=document.all[DateTo].value;
	var apprvID=document.all[apprvID].value;
	
	document.getElementById("fromdate").value = dateStr
	document.getElementById("todate").value = datetoStr
	document.getElementById("apprvID2").value = apprvID;
	if(dateStr == "")
		{
			errMsg += "Enter the Date From\n";
		}
	
    if(datetoStr == "")
		{
			errMsg += "Enter the Date To\n";
		}
	
    if(apprvID == 0)
		{
			errMsg += "Choose an Authorisor\n";
		}

    if(dateStr != "" && datetoStr != "")
	 {
		var intSDate = parseInt(dateStr.split("/")[2] + dateStr.split("/")[1] + dateStr.split("/")[0])
		var intEDate = parseInt(datetoStr.split("/")[2] + datetoStr.split("/")[1] + datetoStr.split("/")[0])
		
		if(intEDate < intSDate)
		{
			errMsg += "End date can not be earlier than start date\n"
		}
	 }
	 
    if(!errMsg=="")
		{
			alert(errMsg)
			return;	  		
		} 
	
	cancelpopup();
	
	//alert("Auth is " + staID + " * " + document.getElementById("staID2").value)
	
	document.frmDetails.submit();  
}

function acceptAuth() {
	alert('hello here!');	
}

function CalenderScript(CalImg)
{
	CalImg.style.visibility = "Visible";
}

function CloseCalender(CalImg)
{
	CalImg.style.visibility = "Hidden";	 
}


function InsertCalenderDate(Calender,SelectedDate)
{
	var str=Calender.value;
	document.forms["frmDetails"].elements["HiddenDate"].value = str;
	var whole = document.forms["frmDetails"].elements["HiddenDate"].value;
	var day = document.forms["frmDetails"].elements["HiddenDate"].value.substring (8,10);
	day.replace (" ","");
	var month = document.forms["frmDetails"].elements["HiddenDate"].value.substring (4,7);
	var strlength = document.forms["frmDetails"].elements["HiddenDate"].value.length;
	var year = document.forms["frmDetails"].elements["HiddenDate"].value.substring (strlength-4,strlength);
	document.all.DateAttained.value = day + " " + month + " " + year;
}

function ajaxFunction(ajaxFile,vars,name,xPos,yPos,xHeight,xWidth,type,task)
{
	//alert(ajaxFile + " * " + vars + " * " + type + " * " + task + " * "  + name + " * "  + " * " + xPos + " * " + yPos + " * " + xHeight + " * " + xWidth)
	var ajaxRequest;  // The variable that makes Ajax possible!
	vars = encodeURI(vars + '&' + type + '&' + task);   
	try
	{
        // Opera 8.0+, Firefox, Safari
        ajaxRequest = new XMLHttpRequest();
    }
	catch(e)
	{
    	// Internet Explorer Browsers
        try
		{
        	ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
        }
		catch(e)
		{
        	try
			{
            	ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
            }
			catch(e)
			{
            	// Something went wrong
            	alert("Your browser broke!");
            	return false;
            }
        }
    }
	
	xPos = (screen.width - xWidth) / 2 - 250
	yPos = (screen.height - xHeight) / 2 - 200 
	
    // Create a function that will receive data sent from the server
	ajaxRequest.onreadystatechange = function(){
	if(ajaxRequest.readyState == 4)
	{
		//alert("window is " + name + " * " + ajaxRequest.responseText + " * " + screen.height + " * " + xPos + " * " + yPos + " * " + xHeight + " * " + xWidth)
		populateDetailsWindow(name,ajaxRequest.responseText,xPos,yPos,xHeight,xWidth);
	}
}
    ajaxRequest.open("POST", ajaxFile, true);
    ajaxRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    ajaxRequest.send(vars); 
}



function populateDetailsWindow(name,text,xPos,yPos,xHeight,xWidth)
{
	document.getElementById('windowName').innerHTML = name;
	document.getElementById('innerDetailWindow').innerHTML = text;
	
	var detailWindow = document.getElementById('detailWindow');
	detailWindow.style.visibility = "visible";
	detailWindow.style.width = xWidth + "px";

	//detailWindow.style.width = '400px';
	detailWindow.style.top = (document.body.parentNode.scrollTop+80)+'px';
	detailWindow.style.left = (document.body.parentNode.scrollLeft)+'px';
	//alert(document.getElementById('unitPlanner').scrollTop)
	
	//alert(document.body.parentNode.scrollTop)
	
	document.getElementById('detailWindowTitleBar').style.width = xWidth - 16 + "px";
}

function closeThisWindow(thisWindow)
{
	document.getElementById(thisWindow).style.visibility = "hidden";
}

function showLimitations(notes)
{
	window.parent.document.getElementById('limits').innerHTML = '';
	window.parent.document.getElementById("fade").style.display = "block";
	window.parent.document.getElementById("light-lims").style.display = "block";
	window.parent.document.getElementById('limits').innerHTML = notes;
}

function saveAccept()
{
	    var strauths="";
		var authid;
		var authval;
				
	    var endt;
		var staid;
		var errMsg = "";
				
		// now get any Approved
		var a2 = document.getElementById("A2");
		var trarr2=a2.getElementsByTagName("tr");
		
		for(var x = 2; x < trarr2.length - 1; x++) {
			var img = trarr2[x].getElementsByTagName("img")[5];
			if(!img) {
				if(trarr2[x].getElementsByTagName("input")[0].checked==true){
					 authval = trarr2[x].getElementsByTagName("input")[0].value.split("-");
					 staid=(authval[1]);
					 
					 strauths=strauths + staid + "," ;
				}
			}
			// input is the checkbox and 
			// input is the ACCEPT checkbox so set up string to show this 
		} 
		
		/* not picked any so ignore submit */		
		if (strauths== "")
		{
			errMsg += "No Authorisations have been Accepted";
		}
	
		if(!errMsg=="")
		{
			alert(errMsg)
			return;	  		
		} 
	
	    //strnotes=document.frmlimits.authlimits.value; 
		document.frmDetails.action = 'UpdateAcceptStaffAuths.asp?authlist='+strauths;
		document.frmDetails.submit();
}

</Script>