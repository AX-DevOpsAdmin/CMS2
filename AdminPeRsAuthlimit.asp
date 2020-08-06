<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--include file="Includes/manageradmin.inc"-->  
<%

	'If user is not valid Authorisation Administrator then log them off
	If (session("authadmin") =0 AND  strAuth > 2 ) then
		Response.redirect("noaccess.asp")
	End If

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

objCmd.CommandText = "spPeRsDetail"
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("staffID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

objCmd.CommandText = "spAdminPersAuthsType"	
set objPara = objCmd.CreateParameter ("atpID",3,1,0, request("atpID"))
objCmd.Parameters.Append objPara
set rsAuths = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

%>

<script type="text/javascript" src="calendar.js"></script>

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
	<input type=hidden name="staffID" id="staffID" value=<%=request("staffID")%>>
	
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
      	<tr>
        	<td>
				<!--#include file="Includes/Header.inc"--> 
                <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Authorisations</strong></font></td>
                    </tr>
                    <tr>
                    	<td colspan=2 class=titlearealine  height=1></td>
                    </tr>
                </table>
          
  		    	<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		   		<tr valign=Top>
        	      		<td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
                    	<td width=16></td>
				  		<td align=left >
                        	<table border=0 cellpadding=0 cellspacing=0 width=100%>
                                <tr class=SectionHeader>
                                    <td>
                                        <% if strManager = "1" then %>
                                            <table border=0 cellpadding=0 cellspacing=0 >
                                                <tr>
                                                    <td height="25px" class=toolbar width=8></td><td width=20><a class=itemfontlink  href="AdminPersAuthLimitAdd.asp?staffID=<%=request("staffID")%>&atpID=<%=request("atpID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
                                                    <td width="69" height="25px" valign="middle" class=toolbar >Add Limit</td>
                                                    <td height="25px" class=titleseparator valign="middle" width=13 align="center">|</td>
                                                    
                                                    <td height="25px" width=25><a class=itemfontlink  href="AdminPersAuthLimitDel.asp?staffID=<%=request("staffID")%>&atpID=<%=request("atpID")%>"><img class="imagelink" src="images/delitem.gif"></A></td>
                                                    <td width="106" height="25px" valign="middle" class=toolbar >Remove Limit</td>
                                                    
                                                    <td height="25px" class=titleseparator valign="middle" width=12 align="center">|</td>
                                                    <td width="86" height="25px" valign="middle" class=toolbar><A class=itemfontlink href="AdminPersAuths.asp?staffID=<%=request("staffID")%>&atpID=<%=cint(request("atpID"))%>">Back</A></td>											
                                                   
                                                </tr>
                                            </table>
                                        <% end if %>
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
                                                <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("surname")%></td>
                                                <td align="left" width="22%" height="22px">&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td align="left" width="2%" height="22px">&nbsp;</td>
                                                <td align="left" width="13%" height="22px">Service No:</td>
                                                <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("serviceno")%></td>
                                                <td align="left" width="13%" height="22px">Known as:</td>
                                                <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("knownas")%></td>
                                                <td align="left" width="22%" height="22px">&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td align="left" width="2%" height="22px">&nbsp;</td>
                                                <td align="left" width="13%" height="22px">Rank:</td>
                                                <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("rank")%></td>
                                                <td align="left" width="13%" height="22px">Trade:</td>
                                                <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("trade")%></td>
                                                <td align="left" width="22%" height="22px">&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td align="left" width="2%" height="22px">&nbsp;</td>
                                                <td align="left" width="13%" height="22px">Post:</td>
                                                <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("post")%></td>
                                                <td align="left" width="13%" height="22px">Unit:</td>
                                                <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("unit")%></td>
                                                <td align="left" width="22%" height="22px">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan=6 height="22px">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan=6 class=titlearealine height=1></td> 
                                            </tr>
                                        </table>
                                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                            				<tr class=SectionHeader>
                                                <td width="2%" align="left" height="25px">&nbsp;</td>
                                                <td width="98%" align="left" height="25px" colspan=5>
                                                    <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                        <tr class="SectionHeader toolbar">
                                                            <td width="17%" align="left" height="25px">Summary of Authorisations</td>
                                                            <td width="10%" align="center" height="25px">Valid From</td>
                                                            <td width="12%" align="center" height="25px">Valid To</td>
                                                            <td width="16%" align="center" height="25px">Authorisor</td>
                                                            <td width="7%" align="center" height="25px">Status</td>
                                                            <td width="38%" align="center" height="25px">&nbsp;</td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan=8 height="22px">&nbsp;</td>
                                                        </tr>
														<% if rsAuths.recordcount > 0 then %>
                                                            <% do while not rsAuths.eof %>
                                                               <tr>
                                                                <% strAuthCode = rsAuths("authCode") %>
                                                                <% strValidFrom = rsAuths("startdate") %>
                                                                <% strValidTo = rsAuths("enddate") %>
                                                                <% strAuthorisor = rsAuths("Authorisor") %>
                                                                <%strAmberDate=strValidTo - 14 %>
                                                                
                                                                
                                                                    <% if rsAuths("authID") <> "" then %>
                                                                        <td align="left" height="22px" class=toolbar><%=strAuthCode%></td>
                                                                        <td align="center" height="22px" class=toolbar><%=formatDateTime(strValidFrom,2) %></td>
                                                                        <td align="center" height="22px" class=toolbar><%=formatDateTime(strValidTo,2) %></td>
                                                                        <td align="center" height="22px" class=toolbar><%=strAuthorisor%></td>
                                                                        <td align="center" height="22px">
                                                                            <% if date > strValidTo then %>
                                                                                <img src="Images/red box.gif" alt="Out of Date" width="12" height="12">
                                                                            <% elseif date >= strAmberDate and date <= strValidTo then %>
                                                                                <img src="Images/yellow box.gif" alt="Almost out of Date" width="12" height="12">
                                                                            <% elseif date >= strValidFrom and date < strAmberDate then %>
                                                                                <img src="Images/green box.gif" alt="In Date" width="12" height="12">
                                                                            <% else %>
                                                                                &nbsp;
                                                                            <% end if %>
                                                                        </td>
                                                                    <%end if %>
                                                                    <% rsAuths.movenext %>
                                                                </tr>
                                                            <% loop %>
                                                        <% else %>
                                                            <tr>
                                                                <td colspan="8" height="22px" class=toolbar>None Held</td>
                                                            </tr>
                                                        <% end if %>
                                                        <tr>
                                                            <td colspan="8" height="22px">&nbsp;</td>
                                                        </tr>
                                                    </table>
                                				</td>
                            				</tr>
                            				<tr>
                                				<td colspan=7 class=titlearealine  height=1></td> 
                            				</tr>
                        				</table>
                					</td>
                                </tr>
							</table>
                        </td>
                	</tr>
                </table>
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

/**
function DisplayForm(ValidDate,Competent,staffMSID,Description,QExempt,Exempt)
{
	document.popupDetails.StaffMSID.value = staffMSID;
	var months = new Array('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
	var datestr_array = ValidDate.split("/");
	var monthInt=datestr_array[1]
	var newMonth=months[monthInt-1];
	document.popupDetails.DateAttained.value = ValidDate; //datestr_array[0] + " " + newMonth + " " + datestr_array[2];
	
	if(QExempt == 1)
	{
		document.getElementById('exempt').style.display = 'block';
	}
	else
	{
		document.getElementById('exempt').style.display = 'none';
	}
	
	if(Exempt == 1)
	{
		document.getElementById('chkExempt').checked = true
	}
	else
	{
		document.getElementById('chkExempt').checked = false
	}

	document.getElementById('QName').innerHTML=Description;
	document.getElementById('PopUpwindow1').style.visibility = "Visible";
}
**/
</Script>
