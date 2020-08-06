<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
%>
	<script language="JScript">
		var myHeight = document.documentElement.clientHeight - 138; //(screen.availHeight) ;
		window.location = "reportsStaffAuthLimitsList.asp?myHeight1="+myHeight;
	</script>
<%
else
   'session.timeout = 60
   session("heightIs") = request("myHeight1") 
end if 

itemsListed=6
location="Reports"
subLocation="18"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4	

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara

objCmd.CommandText = "spListHierarchyDropDown"
set rsHrcList = objCmd.Execute

'response.write nodeID
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
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
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>    		
			<td> 
				<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10px>&nbsp;</td>
                        <td><a title="" href="index.asp" class=itemfontlinksmall>Home</a> > <A href='reportsHome.asp' class=itemfontlinksmall >Reports</A> > <font class='youAreHere'>Staff Auth Limits</font></td>
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
                            <form action="reportsProcessMultipleSubmit.asp" method="POST" name="frmDetails" target="Report">
                                <input type=hidden name="FitnessStatus" id="FitnessStatus" value="1"%>
                                <table border=0 cellpadding=0 cellspacing=0 width=100%>	
                                    <tr class=SectionHeader>							
                                        <td>
                                            <table border=0 cellpadding=0 cellspacing=0 width="250px">
                                                <tr height=28px>
                                                    <!--<td width="25px"><a class=itemfontlink href="javascript:launchReportWindow();"><img class="imagelink" src="images/report.gif"></a></td>
                                                    <td width="90px" class=toolbar valign="middle" >Create Report</td>-->
                                                    <td width="10px" class=titleseparator valign="middle" align="center"></td>
                                                    <td width="25px"><a class=itemfontlink href="javascript:launchReportWindowExcel();"><img class="imagelink" src="images/excel.gif"></a></td>
                                                    <td width="100px" class=toolbar valign="middle" >Create In Excel </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr >
                                        <td align=left valign=top >
                                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                <tr height="16">
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="320px" border="0" cellpadding="0" cellspacing="0">
                                                            <tr class="columnheading">
                                                                <td width="100" align="left" class="subheading">Select Unit:</td>
                                                                <td width="220" valign="middle">
                                                                    <select name="cboHrc" id="cboHrc" class="pickbox" style="width:180px;">
                                                                        <%do while not rsHrcList.eof%>
                                                                            <option value=<%=rsHrcList("hrcID")%>><%=rsHrcList("hrcname")%></option>
                                                                            <%rsHrcList.movenext%>
                                                                        <%loop%>
                                                                    </select>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="5">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="5" class=titlearealine  height=1></td> 
                                                </tr>
                                                <tr>
                                                    <td colspan="5">&nbsp;</td>
                                                </tr>
                                            </table>
                                        </td>	
                                    <tr>
                                        <td></td>
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
	
	if(document.frmDetails.cboHrc.value == 0)
	{
		alert( "Please select a Unit");
		return;
	}

	var x = (screen.width-200);
	var y = (screen.height-200);
	
	document.frmDetails.action="reportsStaffAuthLimitsSubmit.asp";
	win = window.open("","Report","top=10,left=10,width="+x+",height="+y+",toolbar=0,menubar=1,scrollbars=1,resizable=1");
	window.setTimeout("document.frmDetails.submit();",500);	
}

function launchReportWindowExcel()
{
	if (win){
	win.close();
	}
		
	document.frmDetails.action="reportsStaffAuthLimitsSubmitExcel.asp";
	document.frmDetails.submit();
}

</script>