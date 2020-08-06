<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
%>
	<script language="JScript">
		var myHeight = document.documentElement.clientHeight - 138; //(screen.availHeight) ;
		window.location = "reportsTaskingSchedule.asp?myHeight1="+myHeight;
	</script>
<%
else
   'session.timeout = 60
   session("heightIs") = request("myHeight1") 
end if 

itemsListed=6
location="Reports"
subLocation="9"
	
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'List all teams
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
objCmd.CommandText = "spListTeams"
objCmd.CommandType = 4		
set rsTeamList = objCmd.Execute

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>

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

<script type="text/javascript" src="calendar.js"></script>

</head>
<body>
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>    		
			<td> 
				<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10px>&nbsp;</td>
                        <td><a title="" href="index.asp" class=itemfontlinksmall>Home</a> > <A href='reportsHome.asp' class=itemfontlinksmall >Reports</A> > <font class='youAreHere'>Tasking Schedule</font></td>
                    </tr>
                    <tr>
                        <td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
				</table>
                <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
                    <tr valign=Top>
                        <td class="sidemenuwidth" background="Images/tableback.png">
							<!--#include file="Includes/reportsSideMenu.inc"-->
                        </td>
                        <td width=16></td>
                        <td align=left>
                            <form method="POST" name="frmDetails">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr class="SectionHeader">
                                        <td>
                                            <table width="235px" border="0" cellpadding="0" cellspacing="0">
                                                <tr height="28px">
                                                    <td width="25px" align="center"><a class="itemfontlink" href="javascript:ViewUnitSchedule();"><img class="imagelink" src="images/report.gif"></a></td>
                                                    <td width="85px" class="toolbar" align="center">View Schedule</td>
                                                    <td class="titleseparator" valign="middle" width="10px" align="center"><!--|--></td>
                                                    <td width="25px"><!--<a class="itemfontlink" href="javascript:launchReportWindowExcel();"><img class="imagelink" src="images/excel.gif"></a>--></td>
                                                    <td width="90px" class="toolbar" align="center"><!--Create In Excel--></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                        
                                    <tr>
                                        <td align="left" valign="top">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr height="16">
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="345" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td width="135" align="left" class="subheading">Select Unit:</td>
                                                                <td width="210" valign="middle">
                                                                    <select name="cboTeam" class="pickbox" style="width:180px;">
                                                                        <%do while not rsTeamList.eof%>
                                                                            <option value=<%=rsTeamList("teamID")%> <%if cint(request("cboTeam")) = cint(rsTeamList("teamID")) then response.write (" Selected")%>><%=rsTeamList("description")%></option>
                                                                            <%rsTeamList.movenext%>
                                                                        <%loop%>
                                                                    </select>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" class="titlearealine"  height="1px"><img height="1px" alt="" src="Images/blank.gif"></td> 
                                                </tr>
                                                <% if request("cboTeam") <> "" then %>
                                                    <tr>
                                                        <td><iframe scrolling=no frameBorder=0 width=100% height=860px src="reportsUnitTaskingOverview.asp?teamID=<%= request("cboTeam") %>"></iframe></td>
                                                    </tr>
                                                <% end if %>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
							</form>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>

<script language="javascript">

var win = null;

function ViewUnitSchedule()
{
	if(win)
	{
		win.close();
	}
	
	if(document.frmDetails.cboTeam.value==0)
	{
		alert( "Please select a Team");
		document.frmDetails.cboTeam.focus()
		return;
	}
	  
	document.frmDetails.submit()
}

function launchReportWindowExcel()
{
	if(win)
	{
		win.close();
	}
	
    if(document.frmDetails.cboTeam.value==0)
	{
		alert( "Please select a Team");
		return;
	}
}

</script>