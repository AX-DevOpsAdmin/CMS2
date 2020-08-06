<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  

<%
    strStaffID=session("staffID")
	
	set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	objCmd.CommandType = 4		

	objCmd.CommandText = "spPeRsDetail"
	set objPara = objCmd.CreateParameter ("RecID",3,1,0, strStaffID)
	objCmd.Parameters.Append objPara
	set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
	
	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
	
	
	strCommand = "spGetStaffAuthNeeded"
	objCmd.CommandText = strCommand
	set objPara = objCmd.CreateParameter ("nodeID", 3,1,0, nodeID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("RecID",3,1,0, strStaffID)
	objCmd.Parameters.Append objPara
	
	set rsAuths = objCmd.Execute
	
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

<form action="" method="POST" name="frmDetails">
	<input type=hidden name="staffID" id="staffID" value="<%=request("staffID")%>">
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--include file="Includes/hierarchyStaffDetails.inc"--> 
        <tr>
        	<td class=titlearealine  height=1></td> 
        </tr>
        <!--
        <tr class=SectionHeader>
            <td>
				<%' if strManager = 1 then %>
                    <table width="100%" border=0 cellpadding=0 cellspacing=0 >
                        <tr>
                            <td height="25px" class=toolbar width=8>&nbsp;</td>
                            <td height="25px" width=20><a class=itemfontlink href="javascript:window.parent.refreshIframeAfterDateSelect("HierarchyTaskingView.asp")"><img class="imagelink" src="images/backIcon.gif"></a></td>
                            <td height="25px" class=toolbar valign="middle">Back</td>
                        </tr>
                    </table>
                <% 'end if %>
    		</td>
    	</tr>
        -->
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
                        <td width="100%" align="left" height="25px">Authorisations and Approvals </td>
					</tr>
                    <tr>
                    	<td colspan="2">&nbsp;</td>
                    </tr>
    			</table>
                <div id="containerDiv">

					<%' do while not rsAuths.eof %>
						<%' intFlag = 0 %>
                        <table border="0" cellpadding="0" cellspacing="0" width="90%">
                            <tr class="toolbar">
                                <td height="25px" id="A1Img" align=left onclick="toggle('A1', 'A1Img','containerDiv');">
                                    <img src="images/plus.gif" width="18" id="A1Icon"> 
                                  <b>Pending Authorisation</b>
                            	</td>
                            </tr>
                            <tr>
                                <td>
                                   
                                    <div id="A1" style="display:none; border:0; margin:0; padding:0;">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="toolbar">
                                                <td width="2%" align="left" height="25px">&nbsp;</td>
                                                <td width="10%" align="left" height="25px">Requested By</td>
                                                <td width="9%" align="left" height="25px">Authorisation</td>
                                                <td width="8%" align="center" height="25px">Valid From</td>
                                                <td width="8%" align="center" height="25px">Valid To</td>
                                                <td width="4%" align="center" height="25px">Status</td>
                                                <td>&nbsp;</td>
                                                
                                                <td width="5%" align="center" height="25px">Authorised</td>
                                                <td width="8%" align="center" height="25px">Date</td>
                                                <td width="11%" align="center" height="25px">Approver</td>
                                                <td width="5%" align="center" height="25px">Approved</td>
                                                <td width="8%" align="center" height="25px">Date</td>
                                                <td>&nbsp;</td>

                                            </tr>
                                            <tr>
                                                <td width="2%" class=titlearealine height=1></td>
                                                <td colspan=10 class=titlearealine height=1></td> 
                                            </tr>
                                            <% do while not rsAuths.eof %>
                                              <% if rsAuths("authType") = 1 then %>
											    <% intFlag = 1 %>
             <!--                                  
           ttstaID AS staID, ttadminID AS adminID, ttadmindate AS admindate ,ttstartdate AS startdate,ttenddate AS enddate,
           ttauthCode AS authCode, ttauthorisor AS authorisor, ttauthOK AS authOK, ttauthdate AS authdate ,
           ttapprover AS approver, ttapprvOK AS apprvOK, ttapprvdate AS apprvdate, ttauthtype AS authtype
           -->
                                                <tr class="toolbar">
                                                    <td width="2%" align="left" height="25px">&nbsp;</td>
                                                     <td width="10%" align="left" height="25px"><%=rsAuths("staffname")%></td>
                                                    <td width="9%" align="left" height="25px"><%=rsAuths("authCode")%></td>
                                                    <td width="8%" align="center" height="25px"><%=rsAuths("startdate")%></td>
                                                    <td width="8%" align="center" height="25px"><%=rsAuths("enddate")%></td>
                                                    <td width="4%" align="center" height="25px"><img src="Images/black box.gif" alt="In Date" width="12" height="12"></td>
                                                    <td>&nbsp;</td>
                                                   
                                                    <td width="5%" align="center" height="25px">
                                                      <% if authOK = 1 then %>
                                                        <img src="images/yes.gif">
                                                      <% else %>
                                                        <img src="images/no.gif">
                                                      <%end if %>
                                                        
                                                    </td>
                                                    <td width="8%" align="center" height="25px"><%=rsAuths("authdate")%></td>
                                                    <td width="11%" align="center" height="25px"><%=rsAuths("approver")%></td>
                                                    <td width="5%" align="center" height="25px">
                                                      <% if apprvOK = 1 then %>
                                                        <img src="images/yes.gif">
                                                      <% else %>
                                                        <img src="images/no.gif">
                                                      <%end if %>
                                                    </td>
                                                    <td width="8%" align="center" height="25px"><%=rsAuths("apprvdate")%></td>
                                                    <td>&nbsp;</td>
    
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
                                                    <td colspan="9" align="left" height="22px" class="toolbar">No Pending Authorisations</td>
                                                </tr>
                                            <%end if%>

                                            <tr>
                                                <td colspan="10">&nbsp;</td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        
                        <table border="0" cellpadding="0" cellspacing="0" width="90%">
                            <tr class="toolbar">
                                <td height="25px" id="A2Img" align=left onclick="toggle('A2', 'A2Img','containerDiv');">
                                    <img src="images/plus.gif" width="18" id="A2Icon"> 
                                  <b>Pending Approval</b>
                            	</td>
                                
                            </tr>
                            <tr>
                                <td>
                                    <div id="A2" style="display:none; border:0; margin:0; padding:0;">
                                                                             <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="toolbar">
                                                <td width="2%" align="left" height="25px">&nbsp;</td>
                                                <td width="9%" align="left" height="25px">Authorisation</td>
                                                <td width="8%" align="center" height="25px">Valid From</td>
                                                <td width="8%" align="center" height="25px">Valid To</td>
                                                <td width="4%" align="center" height="25px">Status</td>
                                                <td>&nbsp;</td>
                                                <td width="10%" align="left" height="25px">Authorisor</td>
                                                <td width="5%" align="center" height="25px">Authorised</td>
                                                <td width="8%" align="center" height="25px">Date</td>
                                                <td width="11%" align="center" height="25px">Approver</td>
                                                <td width="5%" align="center" height="25px">Approved</td>
                                                <td width="8%" align="center" height="25px">Date</td>
                                                <td>&nbsp;</td>

                                            </tr>
                                            <tr>
                                                <td width="2%" class=titlearealine height=1></td>
                                                <td colspan=10 class=titlearealine height=1></td> 
                                            </tr>
                                            <% do while not rsAuths.eof %>
                                              <% if rsAuths("authType") = 2 then %>
											    <% intFlag = 1 %>
                                                <tr class="toolbar">
                                                    <td width="2%" align="left" height="25px">&nbsp;</td>
                                                    <td width="9%" align="left" height="25px">rsAuths("authCode")</td>
                                                    <td width="8%" align="center" height="25px">rsAuths("startdate")</td>
                                                    <td width="8%" align="center" height="25px">rsAuths("enddate")</td>
                                                    <td width="4%" align="center" height="25px"><img src="Images/green box.gif" alt="In Date" width="12" height="12"></td>
                                                    <td>&nbsp;</td>
                                                    <td width="10%" align="left" height="25px">rsAuths("staffname")</td>
                                                    <td width="5%" align="center" height="25px">
                                                      <% if authOK = 1 then %>
                                                        <img src="images/yes.gif">
                                                      <% else %>
                                                        <img src="images/no.gif">
                                                      <%end if %>
                                                        
                                                    </td>
                                                    <td width="8%" align="center" height="25px">rsAuths("authdate")</td>
                                                    <td width="11%" align="center" height="25px">rsAuths("approver")</td>
                                                    <td width="5%" align="center" height="25px">
                                                      <% if apprvOK = 1 then %>
                                                        <img src="images/yes.gif">
                                                      <% else %>
                                                        <img src="images/no.gif">
                                                      <%end if %>
                                                    </td>
                                                    <td width="8%" align="center" height="25px">rsAuths("apprvdate")</td>
                                                    <td>&nbsp;</td>
    
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
                                                    <td colspan="9" align="left" height="22px" class="toolbar">No Current Authorisations</td>
                                                </tr>
                                            <%end if%>

                                            <tr>
                                                <td colspan="10">&nbsp;</td>
                                            </tr>
                                        </table>

                                    </div>
                                </td>
                            </tr>
                        </table>
                        
                        <table border="0" cellpadding="0" cellspacing="0" width="90%">
                            <tr class="toolbar">
                                <td height="25px" id="A3Img" align=left onclick="toggle('A3', 'A3Img','containerDiv');">
                                    <img src="images/plus.gif" width="18" id="A3Icon"> 
                                  <b>Authorisation History</b>
                            	</td>
                                
                            </tr>
                            <tr>
                                <td>
                                    <div id="A3" style="display:none; border:0; margin:0; padding:0;">
                                    	<table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="toolbar">
                                                <td width="2%" align="left" height="25px">&nbsp;</td>
                                                <td width="9%" align="left" height="25px">Authorisation</td>
                                                <td width="8%" align="center" height="25px">Valid From</td>
                                                <td width="8%" align="center" height="25px">Valid To</td>
                                                <td width="4%" align="center" height="25px">Status</td>
                                                <td>&nbsp;</td>
                                                <td width="10%" align="left" height="25px">Authorisor</td>
                                                <td width="5%" align="center" height="25px">Authorised</td>
                                                <td width="8%" align="center" height="25px">Date</td>
                                                <td width="11%" align="center" height="25px">Approver</td>
                                                <td width="5%" align="center" height="25px">Approved</td>
                                                <td width="8%" align="center" height="25px">Date</td>
                                                <td>&nbsp;</td>

                                            </tr>
                                            <tr>
                                                <td width="2%" class=titlearealine height=1></td>
                                                <td colspan=10 class=titlearealine height=1></td> 
                                            </tr>
                                            <% do while not rsAuths.eof %>
                                              <% if rsAuths("authType") = 3 then %>
											    <% intFlag = 1 %>
                                                <tr class="toolbar">
                                                    <td width="2%" align="left" height="25px">&nbsp;</td>
                                                    <td width="9%" align="left" height="25px">rsAuths("authCode")</td>
                                                    <td width="8%" align="center" height="25px">rsAuths("startdate")</td>
                                                    <td width="8%" align="center" height="25px">rsAuths("enddate")</td>
                                                    <td width="4%" align="center" height="25px"><img src="Images/red box.gif" alt="In Date" width="12" height="12"></td>
                                                    <td>&nbsp;</td>
                                                    <td width="10%" align="left" height="25px">rsAuths("staffname")</td>
                                                    <td width="5%" align="center" height="25px">
                                                      <% if authOK = 1 then %>
                                                        <img src="images/yes.gif">
                                                      <% else %>
                                                        <img src="images/no.gif">
                                                      <%end if %>
                                                        
                                                    </td>
                                                    <td width="8%" align="center" height="25px">rsAuths("authdate")</td>
                                                    <td width="11%" align="center" height="25px">rsAuths("approver")</td>
                                                    <td width="5%" align="center" height="25px">
                                                      <% if apprvOK = 1 then %>
                                                        <img src="images/yes.gif">
                                                      <% else %>
                                                        <img src="images/no.gif">
                                                      <%end if %>
                                                    </td>
                                                    <td width="8%" align="center" height="25px">rsAuths("apprvdate")</td>
                                                    <td>&nbsp;</td>
    
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
                                                    <td colspan="9" align="left" height="22px" class="toolbar">No Authorisation History</td>
                                                </tr>
                                            <%end if%>

                                            <tr>
                                                <td colspan="10">&nbsp;</td>
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

</body>
</html>

<script language="javascript">

function checkDelete()
{
	var delOK = false 
    
	var input_box = confirm("Are you sure you want to delete this Record ?")
	if(input_box==true)
	{
		delOK = true;
	}
	return delOK;
}


</Script>