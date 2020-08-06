 
<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
itemsListed=6
location="Reports"
subLocation="2"

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

objCmd.CommandText = "spListTaskTypes"
objCmd.CommandType = 4				
set rsTaskTypes = objCmd.Execute	

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
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" />

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
    <form action="reportsPersonnelPresentOrAbsentPrinter.asp" method="POST" name="frmDetails" >
        <Input name="HiddenDate" type="hidden" >
        <Input name="ttID" type="hidden" >
        <Input name="description" type="hidden" >
        <input name="serviceNo" type="hidden">
        <input name="postID" type="hidden" value="1234">
        <input name="staffPostID" type="hidden" value="">
        <input name="thisDate" type="hidden" value="<%=thisDate%>">
        <input name="staffID" type="hidden">
        <input name="teamID" type="hidden" value="<%=request("teamID")%>">
        <input name="sortID" type="hidden" value="<%=sortID%>">
        <input name="PresentAbsentFlag" type="hidden" value="1">
        <input name="AllTeams" type="hidden" value="<%=request("allTeams")%>">
    
		<table border=0 cellpadding=0 cellspacing=0 align="center" width=800px>
        	<tr>
            	<td colspan="2">&nbsp;</td>
            </tr>
			<tr>
				<td>
					<table width=800px border=0 cellpadding=0 cellspacing=0>
						<tr>
							<td>
                                <table width="800px" border=0 cellpadding=0 cellspacing=0>
                                    <tr  height=20>
                                        <td valign="middle" width=72 class=columnheading >Unit:</td>
                                        <td valign="middle" width=878 class=itemfont ><%=rsRecSet("ParentDescription")%> > <font  class="youAreHere"><%=rsRecSet("Description")%></font> </td>
                                    </tr>
                                    <tr height=20>
                                        <td valign="middle" width=72 class=columnheading >Team Size:</td>
                                        <td valign="middle" class=itemfont><font id=totalCount></td>
                                    </tr>
                                </table>
							</td>
						</tr>
                        
						<%
						color1="#f4f4f4"
                        color2="#fafafa"
                        counter=0
                        
                        set rsRecSet=rsRecSet.nextrecordset
                        presentCount=rsRecSet.recordCount
                        totalPosts=rsRecSet.recordCount
                        %>
                        
						<% if request("PresentAbsentFlag") = 1 then  %>
							<tr height=16 class=SectionHeaderPlain>
								<td>
                                    <table width="800px" border=0 cellpadding=0 cellspacing=0 >
                                        <tr>
                                           <td class=toolbar width=8>&nbsp;</td>
                                           <td class=toolbar valign="middle" >Personnel Present (<font id=presentCount></font>): <%=startDate%><% if datediff ("d",startDate,endDate)<>0 then%> to <%=endDate%><%end if%></td>
                                        </tr>  
                                    </table>
								</td>
							</tr>
							<tr height=10>
								<td></td>
							</tr>
							<tr height=35>
								<td valign=top>
                                    <table width=800px border=0 cellpadding=0 cellspacing=0>
                                        <tr>
                                            <td>
                                                <div class=borderAreaTableRow>
                                                    <table border=0 cellpadding=0 cellspacing=0 width=800px>
                                                            <tr class="columnheading" height=20>
                                                                <td width="8px" class=toolbar>&nbsp;</td>
                                                                <td width="60px">Assign No</td>
                                                                <td width="70px">Service No</td>
                                                                <td width="50px" align="center">Mgr</td>
                                                                <td width="50px" onClick="javascript:sortColumn(1)" style="cursor:hand;">Rank</td>
                                                                <td width="113px">Firstname</td>
                                                                <td width="113px" onClick="javascript:sortColumn(2)" style="cursor:hand;">Surname</td>
                                                                <td width="112px">Trade</td>
                                                                <td width="112px" onClick="javascript:sortColumn(3)" style="cursor:hand;">Team</td>
                                                                <td width="112px">Location</td>
                                                            </tr>
                                                    </table>
                                                 </Div>
                                            </td>          
                                        </tr>
                                    </table>
									<table width=800px border=0 cellpadding=0 cellspacing=0>
										<% do while not rsRecSet.eof %>
											<tr class="columnheading">
												<td>
													<div class=borderAreaTableRow>
														<table border=0 cellpadding=0 cellspacing=0 width=800px>
															<tr class=itemfont id="<%=rsRecSet("postID")%>" height=20>
																<td width="8px">&nbsp;</td>
																<td width="60px" title="Description: <%=rsRecSet("Description")%>"><%=rsRecSet("Assignno")%></td>
																<% if rsRecSet("serviceno") <> "" then %>
																	<td width="70px"><%=rsRecSet("serviceno") %></td>
																	<td width="50px" align="center"><%if rsRecSet("mgr")<>"" then%>Y<%else%>N<%end if%></td>
																	<td width="50px"><%=rsRecSet("shortDesc")%></td>
																	<td width="113px"><%=rsRecSet("firstName")%></td>
																	<td width="113px"><%=rsRecSet("surname")%></td>
																	<td width="112px"><%=rsRecSet("trade")%></td>
																	<td width="112px"><%=rsRecSet("teamName")%></td>
																	<td width="112px">In Office</td>
																<% else %>
																	<td width="508px" colspan=6 align="center" style="color:#ff0000;">This post is Vacant at this time</td>
																	<td width="112px"><%=rsRecSet("teamName")%></td>
                                                                    <td width="112px">&nbsp;</td>
																<% end if %>
															</tr>
														</table>
													</Div>
												</td>
											</tr>
											<%rsRecSet.movenext
                                            	if counter=0 then
                                            	counter=1
                                            else
                                            	if counter=1 then counter=0
                                            end if
										loop%>
									</table>
								</td>
							</tr>
							<script language="Javascript">presentCount.innerHTML = "<%=presentCount%>"</script>
                            <tr height=10>
                                <td></td>
                            </tr>
							<% set rsRecSet = rsRecSet.nextrecordset %>
							<% totalPosts = totalPosts + rsRecSet.recordCount %>
							<script language="Javascript">totalCount.innerHTML = "<%=totalPosts%>"</script>
						<% else %>
							<% set rsRecSet = rsRecSet.nextrecordset %>
							<% totalPosts = totalPosts + rsRecSet.recordCount %>
							<script language="Javascript">totalCount.innerHTML = "<%=totalPosts%>"</script>
                            <tr height=16 class=SectionHeaderPlain>
                                <td>
                                    <table border=0 cellpadding=0 cellspacing=0 >
                                        <tr>
                                           <td class=toolbar width=8></td>
                                           <td class=toolbar valign="middle" >Personnel Absent (<%=rsRecSet.recordCount%>): <%=startDate%><% if datediff ("d",startDate,endDate)<>0 then%> to <%=endDate%><%end if%></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr height=10>
                                <td></td>
                            </tr>
							<tr height=35%>
                            	<td>
                                    <table width=800px border=0 cellpadding=0 cellspacing=0>
                                        <tr>
                                            <td>
                                            <div class=borderAreaTableRow>
                                                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                        <tr class=" columnheading"   height=20>
                                                            <td width=8px class=toolbar>&nbsp;</td>
                                                            <td width=60px>Assign No</td>
                                                            <td width=70px>Service No</td>
                                                            <td width=50px align="center">Mgr</td>
                                                            <td width=50px onClick="javascript:sortColumn(1)" style="cursor:hand;">Rank</td>
                                                            <td width=113px>Firstname</td>
                                                            <td width=113px onClick="javascript:sortColumn(2)" style="cursor:hand;">Surname</td>
                                                            <td width=112px>Trade</td>
                                                            <td width=112px onClick="javascript:sortColumn(3)" style="cursor:hand;">Team</td>
                                                            <td width=112px>Location</td>
                                                        </tr>
                                                </table>
                                             </Div>
                                            </td>          
                                        </tr>
                                    </table>
                                    <table width=800 border=0 cellpadding=0 cellspacing=0>
                                        <% do while not rsRecSet.eof %>
                                            <tr class=" columnheading">
                                                <td>
                                                    <div class=borderAreaTableRow>
                                                        <table border=0 cellpadding=0 cellspacing=0 width=800px>	
                                                            <tr id="<%=rsRecSet("postID")%>" class=itemfont height=20>
                                                                <td width=8px>&nbsp;</td>
                                                                <td width=60px title="Description: <%=rsRecSet("Description")%>"><%=rsRecSet("Assignno")%></td>
                                                                <td width=70px><%=rsRecSet("serviceno")%></td>
                                                                <td width=50px align="center"><%if rsRecSet("mgr")<>"" then%>Y<%else%>N<%end if%></td>
                                                                <td width=50px><%=rsRecSet("shortDesc")%></td>
                                                                <td width=113px ><%=rsRecSet("firstName")%></td>
                                                                <td width=113px ><%=rsRecSet("surname")%></td>
                                                                <td width=112px><%=rsRecSet("trade")%></td>
                                                                <td width=112px><%=rsRecSet("teamName")%></td>
                                                                <td width="112px"><%if rsRecSet("Location")<>"" then%><%=rsRecSet("Location")%><%else%>various<%end if%></td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <%rsRecSet.movenext
                                            if counter=0 then
                                                counter=1
                                            else
                                                if counter=1 then counter=0
                                            end if
                                        loop%>
									</table>
								</td>
							</tr>
							<tr></tr>
						<% end if %>
					</table>
				</td>
			</tr>
		</table>
	</Form>

</body>
</html>

<script language="JavaScript">

function sortColumn(column)
{
	sortID = document.frmDetails.sortID.value
	
	if(sortID == (column * 2))
	{
		document.frmDetails.sortID.value = ((column*2)-1)
	}
	else
	{
		document.frmDetails.sortID.value = (column * 2)
	}
	document.frmDetails.submit()	
}

</script>