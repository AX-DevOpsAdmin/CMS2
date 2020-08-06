<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
%>
	<script language="JScript">
		var myHeight = document.documentElement.clientHeight - 138; //(screen.availHeight) ;
		window.location = "reportsPersonnelbyRank.asp?myHeight1="+myHeight;
	</script>
<%
else
   'session.timeout = 60
   session("heightIs") = request("myHeight1") 
end if 

itemsListed=6
location="Reports"
subLocation="11"
		
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'List all ranks
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
strCommand = "spListRanks"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara

set rsRankList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

objCmd.CommandText = "spListHierarchyDropDown"
set rsHrcList = objCmd.Execute

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

</head>
<body>
	<table height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>    		
			<td> 
				<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10px>&nbsp;</td>
                        <td><a title="" href="index.asp" class=itemfontlinksmall>Home</a> > <A href='reportsHome.asp' class=itemfontlinksmall >Reports</A> > <font class='youAreHere'>Personnel by Rank</font></td>
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
                            <form  action="reportsPersonnelbyRankSubmit.asp" method="POST" name="frmDetails" target="Report">
                                <input type=hidden name="RankStatus" id="RankStatus" value="0"%>
	
                                <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">			
                                    <tr class="SectionHeader">
                                        <td>
                                            <table width="235px" border="0" cellpadding="0" cellspacing="0">
                                                <tr height="25px">
                                                    <td width="25px" align="center"><a class="itemfontlink" href="javascript:launchReportWindow ();"><img class="imagelink" src="images/report.gif"></a></td>
                                                    <td width="85px" class="toolbar" align="center">Create Report</td>
                                                    <td class="titleseparator" valign="middle" width="10px" align="center">|</td>
                                                    <td width="25px"><a class="itemfontlink" href="javascript:launchReportWindowExcel ();"><img class="imagelink" src="images/excel.gif"></a></td>
                                                    <td width="90px" class="toolbar" align="center">Create In Excel</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top">
                                            <table border="0" cellpadding="0" cellspacing="0" width="625">
                                                <tr>
                                                    <td width="82" align="left" class="subheading">Select Unit:</td>
                                                    <td width="203" valign="middle">
                                                        <select name="cboHrc" id="cboHrc" class="pickbox" style="width:180px;">
                                                            <% do while not rsHrcList.eof %>
                                                                <option value=<%= rsHrcList("hrcID") %>><%= rsHrcList("hrcname") %></option>
                                                                <% rsHrcList.movenext %>
                                                            <% loop %>
                                                        </select>
                                                    </td>
													<td width="86" class="subheading">Sub Unit(s):</td>
													<td width="36"><input name="chkSub" type="checkbox" id="chkSub" value="1"></td>
                                                    <td width="46" align="left" class="subheading">Rank:</td>
                                                    <td width="172" valign="middle">
                                                        <select name="cboRank" id="cboRank" class="pickbox" style="width:70px;"> 
                                                            <% do while not rsRankList.eof %>
                                                                <option value="<%= rsRankList("RankID") %>"><%= rsRankList("shortdesc") %></option>
                                                                <% rsRankList.movenext() %>
                                                            <% loop %>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td class="titlearealine"  height="1px"><img height="1px" alt="" src="Images/blank.gif"></td> 
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

function launchReportWindow()
{
	if(win)
	{
		win.close();
	}
	
	if(document.frmDetails.cboHrc.value==0)
	{
		alert( "Please select a Unit");
		document.frmDetails.cboHrc.focus()
		return;
	}
	  
	if(document.frmDetails.cboRank.value == 0) 
	{
		alert("Select a Rank");
		return;
	}
	
	var x = (screen.width);
	var y = (screen.height);

	document.frmDetails.action="reportsPersonnelbyRankSubmit.asp";
	win = window.open("","Report","top=0,left=0,width="+x+",height="+y+",toolbar=0,menubar=1,scrollbars=1");
	window.setTimeout("document.frmDetails.submit();",500);
}

function launchReportWindowExcel()
{
	if(win)
	{
		win.close();
	}
	
    if(document.frmDetails.cboHrc.value==0)
	{
		alert( "Please select a Team");
		return;
	}
	  
	if(document.frmDetails.cboRank.value == 0) 
	{
		alert("Select a Rank");
		return;
	}
	
	document.frmDetails.action="reportsPersonnelbyRankExcel.asp";
	document.frmDetails.submit();
}

</script>