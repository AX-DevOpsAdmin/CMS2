<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
%>
	<script language="JScript">
		var myHeight = document.documentElement.clientHeight - 138; //(screen.availHeight) ;
		window.location = "reportsNominalRole.asp?myHeight1="+myHeight+"&cboTeam=<%= request("cboTeam") %>";
	</script>
<%
else
   'session.timeout = 60
   session("heightIs") = request("myHeight1") 
end if 

location="Reports"
subLocation="10"
counter=0

dim tmID

if request("cboTeam") <> "" then
	tmID = request("cboTeam")
else
	tmID = 0
end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = "spNominalRoleList"
objCmd.CommandType = 4	

set objPara = objCmd.CreateParameter ("tmID", 3, 1, 0, tmID)
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'

intRecords = rsRecSet.recordcount

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

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

</head>
<body>
	<table height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>    		
			<td> 
				<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10px>&nbsp;</td>
                        <td><a title="" href="index.asp" class=itemfontlinksmall>Home</a> > <A href='reportsHome.asp' class=itemfontlinksmall >Reports</A> > <font class='youAreHere'>Nominal Role</font></td>
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
                                <Input name="HiddenDate" id="HiddenDate"  type="hidden" >    
								<table border=0 cellpadding=0 cellspacing=0 width=100% height=100% >			
                                    <tr class=SectionHeader>			
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr height="28px">
                                                    <td width="25px"><a class="itemfontlink" href="javascript:launchReportWindowExcel ();"><img class="imagelink" src="images/excel.gif"></a></td>
                                                    <td width="90px" class="toolbar" align="center">Create In Excel</td>
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
                                                    <td >
                                                        <table width="345" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td width="135" align="left" class="subheading">Select Unit:</td>
                                                                <td width="210" valign="middle">
                                                                    <select name="cboTeam" class="pickbox" style="width:180px;" onChange="launchReportWindow()">
                                                                        <option value="0">All</option>
                                                                        <%do while not rsTeamList.eof%>
                                                                            <option value="<%=rsTeamList("teamID")%>" <%if cint(tmID) = cint(rsTeamList("teamID")) then %> selected <% end if %>><%=rsTeamList("description")%></option>
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
                                                    <td colspan=6 class=titlearealine  height=1></td> 
                                                </tr>
                                                <tr height=16px>
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                            <tr class="itemfont">
                                                                <td width="100%">Records Found:&nbsp;<%= intRecords %></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr height=16px>
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                            <tr class="columnheading">
                                                                <td width="8%">Service No</td>
                                                                <td width="25%">Name</td>
                                                                <td width="25%">Post</td>
                                                                <td width="20%">Private Address</td>
                                                                <td width="16%">POC</td>
                                                                <td width="16%">Contact No's</td>
                                                                <!--<td width="16%"></td> -->
                                                            </tr>
                                                            <tr>
                                                                <td colspan=6 class=titlearealine  height=1></td> 
                                                            </tr>
                                                        
                                                            <%do while not rsRecSet.eof%>
                                                                <% strServiceNo = rsRecSet("ServiceNo") %>
                                                                <% if rsRecSet("firstname") <> "" then %> 
                                                                    <% strName = rsRecSet("Rank") & " " & rsRecSet("surname") & ", " & rsRecSet("firstname") %>
                                                                <% else %>
                                                                    <% strName = rsRecSet("Rank") & " " & rsRecSet("surname") %>
                                                                <% end if %>
                                                                <% strNotes = rsRecSet("Notes") %>
                                                                <% strHomePhone = rsRecSet("homephone") %>
                                                                <% strMobile = rsRecSet("mobileno") %>
                                                                <% strPOC = rsRecSet("poc") %>
                                                                <% strWishes = rsRecSet("welfarewishes") %>
                                                                
                                                                <tr class=itemfont height=40px>
                                                                    <td width="10%"><%= strServiceNo %></td>
                                                                    <td width="25%"><%= strName %></td>
                                                                     <td width="25%"><%= rsRecSet("post") %></td>
                                                                    <td width="20%">
                                                                    	<div class="borderArea" style="height:35px; width:190px; overflow:auto;">
                                                                        	<table border="0" cellpadding="2" cellspacing="0">
                                                                            	<tr>
                                                                                    <td><%= strNotes %></td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    <td width="16%">
                                                                    	<div class="borderArea" style="height:35px; width:150px;">
                                                                        	<table border="0" cellpadding="2" cellspacing="0">
                                                                            	<tr>
																					<td><%= strPOC %></td>
                                                                                </tr>
                                                                    		</table>
                                                                    	</div>
                                                                    </td>
                                                                    <td width="16%">
                                                                    	<div class="borderArea" style="height:35px; width:190px;">
                                                                        	<table border="0" cellpadding="2" cellspacing="0">
                                                                            	<tr>
                                                                                	<td>Home:</td>
                                                                                    <td><%= strHomePhone %></td>
                                                                                </tr>
                                                                                <tr>
                                                                                	<td>Mobile:</td>
                                                                                    <td><%= strMobile %></td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                    <!--<td width="16%"><%'= strWishes %></td>-->
                                                                </tr>
                                                                <tr>
                                                                  <td colspan=6 class=titlearealine  height=1></td> 
                                                                </tr>								
                                                                <% rsRecSet.movenext %>
                                                            <% loop %>
                                                            <tr height=16px>
                                                              <td colspan=6  align="center">&nbsp;</td> 
                                                            </tr>																
                                                        </table>							
                                                    </td>
                                                </tr>
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

</BODY>
</HTML>

<script language="javascript">

function launchReportWindow()
{
	document.frmDetails.action="reportsNominalRole.asp";
	document.frmDetails.submit();
}

function launchReportWindowExcel()
{
	document.frmDetails.action="reportsNominalRoleExcel.asp";
	document.frmDetails.submit();

}

</script>