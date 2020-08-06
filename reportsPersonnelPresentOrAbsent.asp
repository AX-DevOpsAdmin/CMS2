<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->
	
<%
itemsListed=6
location="Reports"
subLocation="4"

if request("vacant") = 1 then
	vacant = request("vacant")
else
	vacant = 0
end if

if request("civi") = 1 then
	civi = request("civi")
else
	civi = 0
end if

if request("cboTeam") <> "" then
	teamID = request("cboTeam")
else
	teamID = 1
end if

if request("allTeams") <> "" then
	allTeams = request("allTeams")
else
	allTeams = 0
end if

if request("vacant") <> "" then
	vacant = request("vacant")
else
	vacant = 0
end if

if request("civi") <> "" then
	civi = request("civi")
else
	civi = 0
end if

if request("startDate") <> "" then
	startDate = request("startDate")
else
	startDate = date
end if

if request("endDate") <> "" then
	endDate = request("endDate")
else
	endDate = date
end if

startEndDiff = datediff ("d",startDate,endDate)
if startEndDiff < 0 then endDate = startDate

sortID = request("sortID")

if sortID = "" then 
	if session("sortID")="" then
		sortID = 2 
	else
		sortID= session("sortID")
	end if
end if

session("sortID") = sortID

strTable = "tblTeam"    
strGoTo = request("fromPage")    
strTabID = "teamID"                      

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

objCmd.CommandText = "spTeamPostsInAndOutStartEnd"	
objCmd.CommandType = 4				
set objPara = objCmd.CreateParameter ("tmID",3,1,5,cint(teamID))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("allTeams",3,1,5, int(allTeams))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("startDate",200,1,16, startDate)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("endDate",200,1,16, endDate)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("sort",3,1,0, sortID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("vacant",3,1,0, vacant)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("civi",3,1,0, civi)
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.CommandText = "spListTeams"
objCmd.CommandType = 4		
set rsTeamList = objCmd.Execute
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
	
	.ellipsis {
	overflow:hidden;
	text-overflow:ellipsis;
	white-space:nowrap;
	}
    -->
</style>
    
</head>
<body onLoad="Disable()">
	<table height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>    		
			<td> 
				<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10px>&nbsp;</td>
                        <td><a title="" href="index.asp" class=itemfontlinksmall>Home</a> > <A href='reportsHome.asp' class=itemfontlinksmall >Reports</A> > <font class='youAreHere'>Present/Absent</font></td>
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
                                <Input name="ttID" type="hidden" >
                                <Input name="description" type="hidden" >
                                <input name="serviceNo" type="hidden">
                                <input name="postID" type="hidden" value="1234">
                                <input name="staffPostID" type="hidden" value="">
                                <input name="staffID" type="hidden">
                                <input name="sortID" type="hidden" value="<%=sortID%>">
                                <input name="PresentAbsentFlag" type="hidden" value="1">
            
                                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                	<tr>
                                    	<td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table width="977" border=0 cellpadding="0" cellspacing="0">
                                                <tr class="subheading">
                                                    <td width="100">&nbsp;</td>
                                                    <td width="220">&nbsp;</td>
                                                    <td width="94">Sub Team(s):</td>
                                                    <td width="34"><input type="checkbox" name ="allTeams" value=1 onClick="javascript:displayReport();" <% if request("allteams") = 1 then %> checked <% end if %>></td>
                                                    <td width="" colspan="4">&nbsp;</td>
                                                </tr>
                                          		<tr class="subheading">
                                                    <td align=left>Select Unit:</td>
                                            		<td>
                                  						<select name="cboTeam" class="pickbox" style="width:180px;" onChange="javascript:displayReport();">
                                                            <% do while not rsTeamList.eof %>
                                                                <option value="<%= rsTeamList("teamID") %>" <% if cint(teamID) = rsTeamList("teamID") then %> selected <% end if %>><%= rsTeamList("description") %></option>
                                                                <% rsTeamList.movenext %>
                                                            <% loop %>
                                                        </select>
                                                    </td>      
                                                    <td>Vacant Posts:</td>
                                                    <td><input type="checkbox" name ="vacant" value=1 onClick="javascript:displayReport(); Disable();" <% if request("vacant") = 1 then %> checked <% end if %> onChange="Disable();"></td> 
                                                    <td width="89">Start Date:</td>
                                                    <td valign=top width=126>
                                                    	<input id="startDate" class="pickbox"  style="Width:75px;"  name="startDate" value="<%=startDate%>" readonly onChange="javascript:displayReport();">
                                                    	&nbsp;<img src="images/cal.gif" align="middle" onClick="calSet(startDate)" style="cursor:hand;">
                                    				</td>
                                                    <td width="78">End Date:</td>
                                                    <td valign=top width=236>
                                                    	<input id="endDate" class="pickbox"  style="Width:75px;"  name="endDate" value="<%=endDate%>" readonly onChange="javascript:displayReport();">
                                                    	&nbsp;<img src="images/cal.gif" align="middle" onClick="calSet(endDate)" style="cursor:hand;">
													</td>
                                                </tr>
                                                <tr class="subheading">
                                                    <td>&nbsp;</td>
                                                    <td>&nbsp;</td>
                                                    <td>Civilian Posts:</td>
                                                    <td><input type="checkbox" name ="civi" value=1 onClick="javascript:displayReport(); Disable();" <% if request("civi") = 1 then %> checked <% end if %> onChange="Disable();"></td>
                                                    <td colspan="4">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                	<td colspan="8">&nbsp;</td>
                                                </tr>
                                                <tr class=columnheading >
                                                    <td colspan=8 class=itemfontTip><u>(Tip: Columns "Rank", "Surname" and "Team" can be sorted by clicking on the column heading.)</U></td>
                                                </tr>		
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                    	<td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan=2 class=titlearealine  height=1></td> 
                                    </tr>
                                    
                                    <!-- Begin listing search criteria -->
                                    
                                    <tr>
                                        <td>
                                            <table width=100% height=400px border=0 cellpadding=0 cellspacing=0>
                                                <tr>
                                                    <td>
                                                        <table border=0 cellpadding=0 cellspacing=0>
                                                            <tr height=20>
                                                                <td valign="middle" width=80px class="subheading">Unit:</td>
                                                                <td valign="middle" width=400px class=itemfont >
																	<% Do While Not(rsRecSet.EOF) %>
                                                                        <%=rsRecSet("ParentDescription")%> > <font  class="youAreHere"><%=rsRecSet("Description")%></font> 
                                                                        <%rsRecSet.MoveNext
                                                                    Loop%>
                                                                </td>
                                                                <td valign="middle" ></td>
                                                            </tr>
                                                            <tr height=20>
                                                                <td valign="middle" width=80px class="subheading">Team Size:</td>
                                                                <td  valign="middle" class=itemfont><font id=totalCount></td>
                                                                <td valign="middle" ></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan=20 class=titlearealine  height=1></td> 
                                                </tr>
        
                                                <%color1="#f4f4f4"
                                                color2="#fafafa"
                                                counter=0%>
        
                                                <%
                                                set rsRecSet=rsRecSet.nextrecordset
                                                presentCount=rsRecSet.recordCount
                                                totalPosts=rsRecSet.recordCount
                                                %>
                                        
                                                <tr height=16 class=SectionHeaderPlain>
                                                    <td>
                                                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                            <tr>
                                                                <td class=toolbar width=8></td>
                                                                <td class=toolbar valign="middle" width=80%>Personnel Present (<font id=presentCount>&nbsp;</font>): <%=thisDate%>&nbsp;</td>                            <td width=20 align=right><a class=itemfontlink href="javascript:frmDetails.PresentAbsentFlag.value=1;launchReportWindow ();"><img class="imagelink" src="images/print.gif"></a></td>
                                                                <td class=toolbar valign="middle" >Print Persons Present</td>
                                                            </tr>  
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr height=10>
                                                    <td></td>
                                                </tr>
                                                <tr height=35%>
                                                    <td valign=top>
                                                        <table width=965px border=0 cellpadding=0 cellspacing=0 style="table-layout:fixed;">
                                                            <tr class="SectionHeaderGreen columnheading"   height=20>
                                                                <td width=8px class=toolbar>&nbsp;</td>
                                                                <td width=70px>Assign No</td>
                                                                <td width=70px>Service No</td>
                                                                <td width=45px align="center">Mgr</td>
                                                                <td width=55px onClick = "javascript:sortColumn(1)" style="cursor:hand;">Rank</td>
                                                                <td width=140px>Firstname</td>
                                                                <td width=160px onClick = "javascript:sortColumn(2)" style="cursor:hand;">Surname</td>
                                                                <td width=161px>Trade</td>
                                                                <td width=160px onClick = "javascript:sortColumn(3)" style="cursor:hand;">Team</td>
                                                                <td width="96px">Location</td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan=10 class=titlearealine  height=1></td> 
                                                            </tr>
                                                        </table>
                                                        <div class="ScrollingAreaTeamsReport">
                                                            <table width=965px border=0 cellpadding=0 cellspacing=0 style="table-layout:fixed;">
                                                                <% do while not rsRecSet.eof %>
                                                                    <tr id="<%= rsRecSet("postID") %>" class=itemfont height=20 <% if counter = 0 then %>style="background-color:<%= color1 %>;"<% else %>style="background-color:<%= color2 %><% end if %>">
                                                                        <td width=8px>&nbsp;</td>
                                                                        <td width=70px title="Description: <%=rsRecSet("Description")%>"><%=rsRecSet("Assignno")%></td>
                                                                        <% if rsRecSet("serviceno") <> "" then %>
                                                                            <td width=70px><%= rsRecSet("serviceno") %></td>
                                                                            <td width=45px align="center"><% if rsRecSet("mgr") <> "" then %>Y<% else %>N<% end if %></td>
                                                                            <td width=55px><%= rsRecSet("shortDesc") %></td>
                                                                            <td width=140px><div class="ellipsis" style="width:135px;"><%= rsRecSet("firstName") %></div></td>
                                                                            <td width=160px><div class="ellipsis" style="width:155px;"><%= rsRecSet("surname") %></div></td>
                                                                            <td width=161px><div class="ellipsis" style="width:141px;"><%= rsRecSet("trade") %></div></td>
                                                                            <td width=160px><div class="ellipsis" style="width:140px;"><%= rsRecSet("teamName") %></div></td>
                                                                            <td width="96px">In Office</td>
                                                                        <% else %>
                                                                            <td colspan=6 align="center" style="color:#ff0000;">Post is vacant at this time</td>
                                                                            <td width=160px><div class="ellipsis" style="width:140px;"><%= rsRecSet("teamName") %></div></td>
                                                                            <td width="96px">&nbsp;</td>
                                                                        <% end if %>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan=10 class=titlearealine  height=1></td> 
                                                                    </tr>
                                                                    <%rsRecSet.movenext
                                                                    if counter=0 then
                                                                        counter=1
                                                                    else
                                                                        if counter=1 then counter=0
                                                                    end if
                                                                loop%>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <script language="Javascript">
                                                    presentCount.innerHTML = "<%=presentCount%>"
                                                </script>
                                                <tr height=10>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td colspan=20 class=titlearealine  height=1></td> 
                                                </tr>
                                                <%color1="#f4f4f4"
                                                color2="#fafafa"
                                                counter=0%>
                                                <%set rsRecSet=rsRecSet.nextrecordset%>
                                                <%totalPosts=totalPosts + rsRecSet.recordCount%>
                                                <script language="Javascript">
                                                    totalCount.innerHTML="<%=totalPosts%>"
                                                </script>
                                                <tr height=16 class=SectionHeaderPlain>
                                                    <td>
                                                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                            <tr>
                                                                <td class=toolbar width=8></td>
                                                                <td class=toolbar valign="middle" width=80%>Personnel Absent (<%=rsRecSet.recordCount%>): <%=thisDate%></td>
                                                                <td width=20><a class=itemfontlink href="javascript:javascript:frmDetails.PresentAbsentFlag.value=0;launchReportWindow ();"><img class="imagelink" src="images/print.gif"></a></td>
                                                                <td class=toolbar valign="middle" >Print Persons Absent</td>
                                                            </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr height=10>
                                                <td></td>
                                            </tr>
                                            <tr height=35%>
                                                <td valign=top>
                                                    <table width=965px border=0 cellpadding=0 cellspacing=0 style="table-layout:fixed;">
                                                        <tr class="SectionHeaderRed columnheading"   height=20>
                                                            <td width=8px class=toolbar>&nbsp;</td>
                                                            <td width=70px>Assign No</td>
                                                            <td width=70px>Service No</td>
                                                            <td width=45px align="center">Mgr</td>
                                                            <td width=55px onClick = "javascript:sortColumn(1)" style="cursor:hand;">Rank</td>
                                                            <td width=140px>Firstname</td>
                                                            <td width=160px onClick = "javascript:sortColumn(2)" style="cursor:hand;">Surname</td>
                                                            <td width=161px>Trade</td>
                                                            <td width=160px onClick = "javascript:sortColumn(3)" style="cursor:hand;">Team</td>
                                                            <td width="96px">Location</td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan=10 class=titlearealine  height=1></td> 
                                                        </tr>
                                                    </table>
                                                    <div class="ScrollingAreaTeamsReport">
                                                        <table width=965px border=0 cellpadding=0 cellspacing=0 style="table-layout:fixed;">
                                                            <%do while not rsRecSet.eof%>
                                                                <tr id="<%=rsRecSet("postID")%>" class=itemfont height=20 <% if counter = 0 then %>style="background-color:<%= color1 %>;"<% else %>style="background-color:<%= color2 %>;"<% end if %>>
                                                                    <td width=8px>&nbsp;</td>
                                                                    <td width=70px title="Description: <%=rsRecSet("Description")%>"><%=rsRecSet("Assignno")%></td>
                                                                    <td width=70px><%=rsRecSet("serviceno")%></td>
                                                                    <td width=45px align="center"><%if rsRecSet("mgr")<>"" then%>Y<%else%>N<%end if%></td>
                                                                    <td width=55px><%=rsRecSet("shortDesc")%></td>
                                                                    <td width=140px><div class="ellipsis" style="width:135px;"><%=rsRecSet("firstName")%></div></td>
                                                                    <td width=160px><div class="ellipsis" style="width:155px;"><%=rsRecSet("surname")%></div></td>
                                                                    <td width=161px><div class="ellipsis" style="width:141px;"><%=rsRecSet("trade")%></div></td>
                                                                    <td width=160px><div class="ellipsis" style="width:140px;"><%=rsRecSet("teamName")%></div></td>
                                                                    <td width=96px><div class="ellipsis" style="width:90px;"><%if rsRecSet("Location")<>"" then%><%=rsRecSet("Location")%><%else%>various<%end if%></div></td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan=10 class=titlearealine  height=1></td> 
                                                                </tr>
                                                                <%rsRecSet.movenext
                                                                if counter=0 then
                                                                    counter=1
                                                                else
                                                                    if counter=1 then counter=0
                                                                end if
                                                            loop%>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                        </td>
                                    </tr>
                                    
                                    <!-- End of search criteria -->
                                    
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


<script type="text/javascript" src="calendar.js"></script>

<script language="JavaScript">

    var obj = new Object;
    var obj2 = new Object;
    var obj = new Object;
    var win = null;
    
    function hideObject(obj)
    {
        obj.style.display = 'none';
    }

</Script>
<script language="javascript">

function sortColumn(column)
{
	document.frmDetails.action="reportsPersonnelPresentOrAbsent.asp";
	document.frmDetails.target="";
	sortID = document.frmDetails.sortID.value
	
	if(sortID == (column * 2))
	{
		document.frmDetails.sortID.value = ((column * 2) -1)
	}
	else
	{
		document.frmDetails.sortID.value = (column * 2)
	}
	
	document.getElementById('busyMessage').style.visibility="visible";
	document.frmDetails.submit()
}

function displayReport()
{
	document.frmDetails.action="reportsPersonnelPresentOrAbsent.asp";
	document.getElementById('busyMessage').style.visibility="visible";
	document.getElementById('busyMessage').innerHTML = '<img src="images/loading...gif">'
	document.frmDetails.submit();
}

function launchReportWindow()
{
	if(win)
	{
		win.close();
	}
	
	document.frmDetails.action="reportsPersonnelPresentOrAbsentPrinter.asp";
	win = window.open("","Report","top=0,left=100,width=1000,height=800,toolbar=0,menubar=0,scrollbars=1");
	window.setTimeout("document.frmDetails.submit();",500);
}

function Disable()
{
	if(document.getElementById('vacant').checked == true)
	{
		document.getElementById('civi').disabled = true;
	}
	
	if(document.getElementById('civi').checked == true)
	{
		document.getElementById('vacant').disabled = true;
	}
}

</script>