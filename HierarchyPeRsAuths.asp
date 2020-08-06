<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--include file="Includes/manageradmin.inc"-->  
<%

'response.write ("Staff is " & request("staffID") & " * " & request("atpID"))
tab=8
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

objCmd.CommandText = "spPeRsDetail"
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("staffID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'objCmd.CommandText = "spAdminPersAuthsType"	
objCmd.CommandText = "spStaffAuths"	
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
<form action="" method="post" name="frmDetails">
	<input type=hidden name="staffID" id="staffID" value=<%=request("staffID")%>>
	<Input Type="Hidden" name="HiddenDate" id="HiddenDate">
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
    	<!--#include file="Includes/hierarchyStaffDetails.inc"-->
    	<tr>
    		<td class=titlearealine  height=1></td> 
    	</tr>    
    
    	<tr class=SectionHeader>
    		<td>
    			<table border=0 cellpadding=0 cellspacing=0>
                	<tr>
    					<td height="25" class=toolbar width=8>
    					<td height="25" width=20><a class=itemfontlink  href="HierarchyPersAuthAdd.asp?staffID=<%=request("staffID")%>&atpID=<%=request("atpID")%>&thisdate=<%=request("thisDate")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
    					<td height="25" class=toolbar valign="middle" >Request Authorisation</td>
                        <!--
    					<td height="25" class=titleseparator valign="middle" width=14 align="center">|</td>
    					<td height="25" width=20><a class=itemfontlink  href="HierarchyPersAuthsRemove.asp?staffID=<%'=request("staffID")%>&atpID=<%'=request("atpID")%>&thisdate=<%'=request("thisDate")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
    					<td height="25" class=toolbar valign="middle" >Remove Authorisations</td>
                        -->
    					<td height="25" class=titleseparator valign="middle" width=14 align="center">|</td>
    					<td height="25" class=toolbar valign="middle" ><A class=itemfontlink href="HierarchyPeRsAuthSelect.asp?staffID=<%=request("staffID")%>&thisdate=<%=request("thisDate")%>">Back</A></td>											
    				</tr>
    			</table>
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
                    <tr class=columnheading height=22px>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Service No:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("serviceno")%></td>
                        <td align="left" width="13%" height="22px">Known as:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("knownas")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22px>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Rank:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("rank")%></td>
                        <td align="left" width="13%" height="22px">Trade:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("trade")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22px>
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
                        <td colspan="6" class=titlearealine height=1></td> 
                    </tr>
					<tr class=SectionHeader>
						<td width="2%" align="left" height="22px">&nbsp;</td>
						<td width="50%" align="left" height="22px" colspan=5>
                                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                            				<tr class=SectionHeader>
                                                <!--<td width="2%" align="left" height="25px">&nbsp;</td>-->
                                                <td width="98%" align="left" height="25px" colspan=5>
                                                    <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                        <tr class="SectionHeader toolbar">
                                                            <td width="17%" align="left" height="25px">Summary of Authorisations</td>
                                                            <td width="10%" align="center" height="25px">Valid From</td>
                                                            <td width="12%" align="center" height="25px">Valid To</td>
                                                            <!--<td width="16%" align="center" height="25px">Authorisor</td>-->
                                                            <td width="7%" align="center" height="25px">Status</td>
                                                            <td width="38%" align="center" height="25px">&nbsp;</td>
                                                        </tr>
                                                        <!--
                                                        <tr>
                                                            <td colspan=8 height="22px">&nbsp;</td>
                                                        </tr>
                                                        -->
														<% if rsAuths.recordcount > 0 then %>
                                                            <% do while not rsAuths.eof %>
                                                               <tr>
                                                                <% strAuthCode = rsAuths("authCode") %>
                                                                <% strValidFrom = rsAuths("startdate") %>
                                                                <% strValidTo = rsAuths("enddate") %>
                                                                <%' strAuthorisor = rsAuths("Authorisor") %>
                                                                <% strAmberDate=strValidTo - 14 %>
                                                                
                                                                    <% if rsAuths("authID") <> "" then %>
                                                                        <td align="left" height="22px" class=toolbar><%=strAuthCode%></td>
                                                                        <td align="center" height="22px" class=toolbar><%=formatDateTime(strValidFrom,2) %></td>
                                                                        <td align="center" height="22px" class=toolbar><%=formatDateTime(strValidTo,2) %></td>
                                                                        <!--<td align="center" height="22px" class=toolbar><%'=strAuthorisor%></td>-->
                                                                        <td align="center" height="22px">
                                                                        
                                                                            <% if (rsAuths("assessed") = 0 or rsAuths("approved")=0)  then %>
                                                                                <img src="Images/black box.gif" alt="Not Yet Authorised" width="12" height="12">
                                                                            <% elseif date > strValidTo then %>
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
                        				</table>
    					</td>
    				</tr>
				</table>
			</td>
		</tr>
        <tr>
            <td height=22px>&nbsp;</td>
        </tr>
        <tr>
            <td class=titlearealine height=1></td> 
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
