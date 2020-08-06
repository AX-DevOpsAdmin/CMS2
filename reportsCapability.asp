<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
	%>
		<script language="JScript">
			var myHeight = document.documentElement.clientHeight - 138;
			window.location = "reportsCapability.asp?myHeight1="+myHeight;
		</script>
	<%
else
   'session.timeout = 60
   session("heightIs") = request("myHeight1") 
end if 

location="Reports"
subLocation="3"

color1="#f4f4f4"
color2="#fafafa"
counter=0

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara

if request("cboHrc") <> "" then

	objCmd.CommandText = "spFltTeamCapability"
	objCmd.CommandType = 4		
	
	thisDate = request("thisDate")
	sqnID = request("cboHrc")
	
	set objPara = objCmd.CreateParameter ("thisDate",200,1,30, thisDate)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("SqnID",3,1,0,sqnID)
	objCmd.Parameters.Append objPara
	
	set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
end if

objCmd.CommandText = "spListTeams" '"spListSqnTeams"
objCmd.CommandType = 4		
set rsTeamList = objCmd.Execute
%>

<script type="text/javascript" src="calendar.js"></script>

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
	<table cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>    		
			<td> 
				<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10px>&nbsp;</td>
                        <td><a title="" href="index.asp" class=itemfontlinksmall>Home</a> > <A href='reportsHome.asp' class=itemfontlinksmall >Reports</A> > <font class='youAreHere'>Capability</font></td>
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
								<Input name="HiddenDate" type="hidden" >
                                
                                <table border=0 cellpadding=0 cellspacing=0 width=100% height=100% >			
                                    <tr class=SectionHeader>			
                                        <td>
                                            <table border=0 cellpadding=0 cellspacing=0>
                                                <tr height=28px>
                                                    <td width="25px" align="center"><a class="itemfontlink" href="#" onClick="btnCreate_onClick()"><img class="imagelink" src="images/report.gif"></a></td>
                                                    <td width="85px" align="center" class="toolbar">Create Report</td>
                                                    <td>
                                                        <div id="advancedLink" style="display:none;">
                                                            <table border=0 cellpadding=0 cellspacing=0>
                                                                <tr>
                                                                    <td width=20><a class=itemfontlink href="javascript:advancedReporting ();"><img class="imagelink" src="images/tbfilter.gif"></a></td>
                                                                    <td class=toolbar valign="middle">Advanced Reporting</td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                        <div id="standardLink" style="display:none;">
                                                            <table border=0 cellpadding=0 cellspacing=0>
                                                                <tr>
                                                                    <td width=20><a class=itemfontlink href="javascript:standardReporting ();"><img class="imagelink" src="images/540.gif"></a></td>
                                                                    <td class=toolbar valign="middle">Standard Reporting</td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr >
                                        <td align=left valign=top >
                                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                <tr height=16 >
                                                    <td ></td>
                                                </tr>
                                                <tr >
                                                    <td>
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <table width="320" border=0 cellpadding="0" cellspacing="0">
                                                                    <tr class=columnheading>
                                                                        <td width="100" align=left class="subheading">Select Unit:</td>
                                                                        <td width="300">
                                                                            <select name="cboHrc" class="pickbox" style="width:180px;">
                                                                                <% do while not rsTeamList.eof %>
                                                                                    <option value="<%= rsTeamList("teamID") %>" <% if cint(request("cboHrc")) = cint(rsTeamList("teamID")) then %> selected <% end if %>><%= rsTeamList("description") %></option>
                                                                                    <% rsTeamList.movenext %>
                                                                                <% loop %>
                                                                            </select>
                                                                        </td>										
                                                                    </tr>
                                                                    <tr class=columnheading >
                                                                        <td class="subheading" width="135">This Date:</td>										
                                                                        <td valign=top width="210">
                                                                            <INPUT id="thisDate" class="pickbox" style="Width:75px;"  name="thisDate" value = "<%=request("thisDate")%>" readonly>										
                                                                            <img src="images/cal.gif" align="absmiddle" onClick="calSet(thisDate)" style="cursor:hand;">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2">&nbsp;</td>
                                                                    </tr>
                                                                </table>
                                                            </tr>
                                                            <tr>
                                                                <td colspan=2 class=titlearealine  height=1></td> 
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                        
                                                <%if request("cboHrc") <> "" then%>
                                                    <tr class=SectionHeader>
                                                        <td>
                                                            <table border=0 cellpadding=0 cellspacing=0 width=99%>
                                                                <tr height=30px >
                                                                    <td colspan=7 class=toolbar>These figures are for week (mon - Sun) <% if thisDate <> "" then %>including the <%=thisDate%><% end if %></td>
                                                                </tr>
                                                                <tr class="SectionHeaderGreen columnheading">
                                                                <td height=30 width=5></td>
                                                                    <td height=30>Flight</td>
                                                                    <td height=30>UnTasked</td>
                                                                    <td height=30>Tasked</td>
                                                                    <td height=30>UnTrained</td>
                                                                    <td height=30>Vacant</td>
                                                                    <td height=30>Total</td>								
                                                                </tr>
                                                                <tr>
                                                                    <td colspan=12 class=titlearealine  height=1></td> 
                                                                </tr>
                                                            
                                                                <%do while not rsRecSet.eof%>
                                                                    <tr class=itemfont <% if counter = 0 then %> style="background-color:<%= color1 %>;cursor:hand;"<% else %>style="background-color:<%= color2 %>;cursor:hand;"<% end if %>>
                                                                        <td height=30></td>
                                                                        <td height=30><%=rsRecSet("Flight")%></td>
                                                                        <td height=30><%=rsRecSet("UnTasked")%></td>
                                                                        <td height=30><%=rsRecSet("Tasked")%></td>
                                                                        <td height=30><%=rsRecSet("UnTrained")%></td>
                                                                        <td height=30><%=rsRecSet("Vacant")%></td>
                                                                        <td height=30><%=rsRecSet("total")%></td>
                                                                    </tr>
                                                                    <tr>
                                                                      <td  colspan=7 class=titlearealine  height=1></td> 
                                                                    </tr>								
                                                                    <% rsRecSet.movenext %>
                                                                    <% if counter = 0 then %>
                                                                        <% counter = 1 %>
                                                                    <% else %>
                                                                        <% if counter = 1 then counter = 0 %>
                                                                    <% end if %>
                                                                <% loop %>
                                                                <tr height=16px>
                                                                  <td colspan=6  align="center">&nbsp;</td> 
                                                                </tr>																
                                                            </table>							
                                                        </td>
                                                    </tr>
                                                <%end if%>
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
    
	<div id="busyMessage" name="TaskList" style="visibility:hidden;position:absolute;top:424px;left:700px;background-color:#FFF;"></div>

</body>
</html>

<script language="javascript">

function btnCreate_onClick()
{
	if(document.frmDetails.cboHrc.value == 0)	
	{
		alert("Please select a Team");
		document.frmDetails.cboHrc.focus()
		return;
	}

	document.getElementById('busyMessage').style.visibility="visible";
	document.getElementById('busyMessage').innerHTML = '<img src="images/loading...gif">'
	document.frmDetails.submit();
}

</script>