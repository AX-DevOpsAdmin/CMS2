<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
%>
	<script language="JScript">
		var myHeight = document.documentElement.clientHeight - 138; //(screen.availHeight) ;
		window.location = "reportsWorkingAtHeight.asp?myHeight1="+myHeight;
	</script>
<%
else
   'session.timeout = 60
   session("heightIs") = request("myHeight1") 
end if 

itemsListed=6
location="Reports"
subLocation="17"

'set objCmd = server.CreateObject("ADODB.Command")
'set objPara = server.CreateObject("ADODB.Parameter")
'objCmd.ActiveConnection = con
'objCmd.Activeconnection.cursorlocation = 3
'
'objCmd.CommandText = "spListTeams"
'objCmd.CommandType = 4		
'set rsTeamList = objCmd.Execute
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
                        <td><a title="" href="index.asp" class=itemfontlinksmall>Home</a> > <A href='reportsHome.asp' class=itemfontlinksmall >Reports</A> > <font class='youAreHere'>RAF Fitness</font></td>
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
                            <table border=0 cellpadding=0 cellspacing=0 width=100%>	
                                <tr class=SectionHeader>							
                                    <td>
                                        <table border=0 cellpadding=0 cellspacing=0 width="150px">
                                            <tr height=28px>
                                                <td width="25px"><a class=itemfontlink href="javascript:createReport();"><img class="imagelink" src="images/report.gif"></a></td>
                                                <td width="90px" class=toolbar valign="middle" >Create Report</td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td align=left valign=top >
                                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                            <tr height="16">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="370px" border="0" cellpadding="0" cellspacing="0">
                                                        <tr class="columnheading">
                                                            <td width="150" align="left" class="subheading">Enter Service Number:</td>
                                                            <td width="220" valign="middle">
                                                                <input name="servNo" id="servNo" />
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
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>

<script language="javascript">


function createReport()
{

	
	if(document.getElementById("servNo").value == "")
	{
		alert( "Please enter a Service Number");
		return;
	}

	//prompt("","reportWorkingAtHeight.asp?servNo="+document.getElementById("servNo").value)
	window.open("reportWorkingAtHeight.asp?servNo="+document.getElementById("servNo").value);

}

</script>