<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%

u = Request.ServerVariables("LOGON_USER")
color1="#f4f4f4"
color2="#fafafa"
counter=0
' parameters for the Delete Option
strTable = "tblTeam"    ' tablename
strGoTo = "ManningTeamSearch.asp"   ' asp page to return to once record is deleted
strTabID = "teamID"              ' key field name for table  
strFrom="Manning"  

' ' Make sure session dates have been reset if we chose different ones in ManningTaskSearch(hiddenStartDate) or updated the task with different ones(startdate)
if request("StartDate") <> "" then 
	session("tSearchStartDate") = request("StartDate")
elseif request("HiddenStartDate") <> "" then 
	session("tSearchStartDate") = request("HiddenStartDate")
else
	session("tSearchStartDate") = date
end if

if request("EndDate") <> "" then 
	session("tSearchEndDate") = request("EndDate")
elseif request("HiddenEndDate") <> "" then 
	session("tSearchEndDate") = request("HiddenEndDate")
else
	session("tSearchEndDate") = "31/12/2050"
end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4				'Code for Stored Procedure

' first find out whether its an HQ Tasking Group - cos if it is then we display HQ Task details
strCommand = "spCheckHqTask"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("StaffID",3,1,0, session("StaffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("HQTasking",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	             'Execute CommandText when using "ADODB.Command" object
strHQTasking   = objCmd.Parameters("HQTasking") 
' Now Delete the parameters
objCmd.Parameters.delete ("StaffID")
objCmd.Parameters.delete ("HQTasking")

' now get the task personnel
set objPara = objCmd.CreateParameter ("TaskID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("startDate",200,1,50, session("tSearchStartDate"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("endDate",200,1,50, session("tSearchEndDate"))
objCmd.Parameters.Append objPara

objCmd.CommandText = "sp_TaskPersonnelSummary"	'Name of Stored Procedure'
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

' Now check if they are Administrators
if session("Administrator") = "1" then
  strAdmin = "1" 
end if

%>

<html>
<head> 

<!--#include file="Includes/IECompatability.inc"-->


<title><%=pageTitle%></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>

<script type="text/javascript" src="calendar.js"></script>

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
    <Input name="RecID" type="hidden" value=<%=request("RecID")%>>
    <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
    			<!--#include file="Includes/Header.inc"-->
                <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
    	                <td width=10px>&nbsp;</td>
	                    <td><A title="" href="index.asp" class=itemfontlinksmall >Home</A> > <A title="" href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=" class=itemfontlinksmall >Tasking</A> > <font class="youAreHere" >Task</font></td>
                    </tr>
                    <tr>
                    	<td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
                </table>
                <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
                    <tr valign=Top>
                        <td class="sidemenuwidth" background="Images/tableback.png">
                            <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
                                <tr height=22>
    	                            <td>&nbsp;</td>
	                                <td colspan=3 align=left height=20>Current Location</td>
                                </tr>
                                <tr height=22>
                                    <td width=10>&nbsp;</td>
                                    <td width=18 valign=top><img src="images/arrow.gif"></td>
                                    <td width=170 align=Left><A title="" href="index.asp">Home</A></td>
                                    <td width=50 align=Left>&nbsp;</td>
                                </tr>
                                <tr height=22>
                                    <td>&nbsp;</td>
                                    <td valign=top><img src="images/arrow.gif"></td>
                                    <td align=Left><A title="" href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=">Tasking</a></td>
                                    <td align=Left>&nbsp;</td>
                                </tr>
                                <tr height=22>
                                    <td>&nbsp;</td>
                                    <td valign=top><img src="images/arrow.gif"></td>
                                    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Task</Div></td>
                                    <td class=rightmenuspace align=Left ></td>
                                </tr>    
                                <tr height=22>
                                    <td>&nbsp;</td>
                                    <td valign=top><img src="images/vnavicon.gif"></td>
                                    <td align=Left><a href="ManningTaskPersonnel.asp?RecID=<%=request("RecID")%>">Task Personnel</a></td>
                                    <td class=rightmenuspace align=Left ></td>
                                </tr>    
                                <tr height=22>
                                    <td>&nbsp;</td>
                                    <td valign=top><% if session("tas") <> 0 then %><img src="images/vnavicon.gif"><% end if %></td>
                                    <td align=Left><% if session("tas") <> 0 then %><a href="UnitTasks.asp?RecID=<%=request("RecID")%>">Task Units</a><% end if %></td>
                                    <td class=rightmenuspace align=Left ></td>
                                </tr>    
	                        </table>
    					</td>
					    <td width=16>&nbsp;</td>
    					<td align=left>
                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                <tr height=16 class=SectionHeader>
                                    <td>
                                		<table border=0 cellpadding=0 cellspacing=0>
                                        	<tr>
                                				<td class=toolbar width=8>&nbsp;</td>    
                                				<td class=toolbar valign="middle"><a class=itemfontlink href="ManningTaskPersonnel.asp?RecID=<%=request("RecID")%>">Tasked Personnel</A></td>
                                				<td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                <% if session("tas") <> 0 then %>
                                                    <td class=toolbar valign="middle" ><a class=itemfontlink  href="UnitTasks.asp?RecID=<%=request("RecID")%>">Tasked Units</A></td>        
                                                    <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                <% end if %>
                                				<td class=toolbar valign="middle" ><A class=itemfontlink href="ManningTaskSearch.asp">Back To List</A></td>
                                            </tr>
			                            </table>
								    </td>
							    </tr>
                                <tr>
								    <td>
    									<table width=100% border=0 cellpadding=0 cellspacing=0>
    										<tr height=16>
    											<td>&nbsp;</td>
    										</tr>
    										<tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%></td>
                                                <td valign="middle" height="22px" width=13%>Task:</td>
                                                <td valign="middle" height="22px" width=85% class=itemfont><%=rsRecSet("Task")%></td>
                                            </tr>    
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px" width="13%">Task Type:</td>
                                                <td valign="middle" height="22px" width="85%" class=itemfont ><%=rsRecSet("Type")%></td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px" width="13%">Start Date:</td>
                                                <td valign="middle" height="22px" width="85%" class=itemfont ><%=session("tSearchStartDate")%></td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px" width="13%">End Date:</td>
                                                <td valign="middle" height="22px" width="85%" class=itemfont ><%=session("tSearchEndDate")%></td>
                                            </tr>    
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px" width="13%">Cancellable:</td>
                                                <td valign="middle" height="22px" width=85% class=itemfont>
                                                	<% if rsRecSet("cancellable") = true then %>
                                                		Yes
                                                	<% else %>
                                                		No									 
                                                	<% end if %>
                                                </td>
											</tr>	
											<% ooastr="No" %>
                                            <% bnastr="No" %>
                                            <% if rsRecSet("ooa") <> 0 then %>
                                            	<% bnastr="Yes" %>
                                            	<% if rsRecSet("ooa") = 1 then %>
                                            		<% ooastr="Yes" %>
                                            	<% end if %>
                                            <% end if %> 
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px" width="13%">Out of Area:</td>
                                                <td  valign="middle" height="22px" width=85% class=itemfont><%= ooastr %></td>
                                            </tr>	
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px" width="13%">Bed Night Away:</td>
                                                <td valign="middle" height="22px" width=85% class=itemfont><%=bnastr%></td>
                                            </tr>	
                                            <tr class=columnheading>
                                            	<td valign="middle" height="22px" width=2%>&nbsp;</td>
												<% if strHQTasking = 1 then %>
                                                    <td valign="middle" height="22px" width="13%">HQ Task:</td>
                                                    <td valign="middle" height="22px" width=85% class=itemfont>
                                                        <% if rsRecSet("hqTask")=true then%>
                                                            Yes
                                                        <% else %>
                                                            No
                                                        <% end if %> 
                                                    </td> 
                                                <% end if %>	
    										</tr>	        
                                            <tr>
                                            	<td colspan=5 class=titlearealine  height=1></td> 
                                            </tr>        
    										<% set rsRecSet = rsRecSet.nextrecordset %>
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
</body>
</html>
