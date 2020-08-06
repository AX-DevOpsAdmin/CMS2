	
    <!--#include file="Includes/security.inc"--> 
    <!--include file="Includes/checkadmin.asp"-->
    <!--#include file="Connection/Connection.inc"-->

    <%

	'If user is not valid Authorisation Administrator OR Level K/J  then log them off
	If (session("authadmin") =0 AND  strAuth > 2 ) then
		Response.redirect("noaccess.asp")
	End If


    set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	objCmd.commandtype = 4	
	
	strCommand = "spGetAuthTrail"

	objCmd.CommandText = strCommand

	set objPara = objCmd.CreateParameter ("authID",3,1,0, request("authID"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 0)
	objCmd.Parameters.Append objPara
	
	set rsAuths = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'


	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
	
	'response.Write("auth levels")
	'response.End()
	
    %>
	
                                     
        <tr>
            <td>
                <table width=100% border=0 cellpadding=0 cellspacing=0>
                    <tr colspan=6 class=itemfont height=30>
                        <td valign="middle" width=2%>&nbsp;</td>
                        <td colspan=4 valign="middle" width=98%>Search Results: <Font class=searchheading>records found: <%=rsRecSet.recordcount%></Font></td>
                    </tr>
                
                    <tr>
                        <td colspan=5 class=titlearealine  height=1></td> 
                    </tr>
                    <tr class=columnheading height=30>
                      <td valign="middle" width=2%>&nbsp;</td>
                      <td valign="middle" width=13% onclick="javascript:SortByCol1();" class="mouseHand">Service No<%if sort=5 then%><img src="images/searchUp.jpg"><%end if%><%if sort=6 then%><img src="images/searchDown.jpg"><%end if%></td>
                      <td valign="middle" width=20% onclick="javascript:SortByCol2();" class="mouseHand">First Name<%if sort=3 then%><img src="images/searchUp.jpg"><%end if%><%if sort=4 then%><img src="images/searchDown.jpg"><%end if%></td>
                      <td valign="middle" width=25% onclick="javascript:SortByCol3();" class="mouseHand">Surname<%if sort=1 then%><img src="images/searchUp.jpg"><%end if%><%if sort=2 then%><img src="images/searchDown.jpg"><%end if%></td>
                      <td valign="middle" width=40%>Rank</td>
                    </tr>
                    <tr>
                      <td colspan=5 class=titlearealine  height=1></td> 
                    </tr>
                    <%if rsRecSet.recordcount > 0 then%>
                    <%Row=0%>
                    <%do while Row < recordsPerPage%>
                    <tr class=itemfont ID="TableRow<%=rsRecSet ("staffID")%>" height=30 <%if counter=0 then%>style="background-color:<%=color1%>;"<%else%>style="background-color:<%=color2%>;"<%end if%>>
                        <td valign="middle" width=2%>&nbsp;</td>
                        <td valign="middle" width="13%"><A class=itemfontlink href="AdminPeRsAuthSelect.asp?staffID=<%=rsRecSet("staffID")%>"><%=rsRecSet("serviceno")%></A></td>
                        <td valign="middle" width="20%"><%=rsRecSet("firstname")%></td>
                        <td valign="middle" width="25%"><%=rsRecSet("surname")%></td>
                        <td valign="middle" width="40%"><%=rsRecSet("rank")%></td>
                    </tr>
                    <tr>
                        <td colspan=5 class=titlearealine  height=1></td> 
                    </tr>
                    <%
                    Row=Row+1
                    rsRecSet.MoveNext
                    if counter=0 then
                        counter=1
                    else
                        if counter=1 then counter=0
                    end if
                    Loop%>
                    <tr height=22px>
                        <td colspan=6></td>
                    </tr>											
                    <tr align="center">
                        <td colspan=6>
                            <table  border=0 cellpadding=0 cellspacing=0>
                                <tr>
                                    <td class=itemfont>Results Pages:&nbsp;</td>
                                    <td class=ItemLink>
                                        <% if int(page) > 1 then %>
                                            <a href="javascript:MovetoPage(<%=page-1%>);" class=ItemLink><< Previous</a>
                                        <% else %>
                                            << Previous
                                        <% end if %>
                                    </td>
                                    <td class=itemfont>&nbsp;&nbsp;</td>
                                    <% pagenumber = beginAtPage %>
                                        <td>
                                    <% do while pagenumber <= endAtPage %>
                                        <% if page <> pagenumber then %>
                                            <a class=ItemLink href="javascript:MovetoPage(<%=pagenumber%>);"><%=Pagenumber%></a><% if pagenumber < (endAtPage) then %><font class=itemfont>,</font><% end if %>
                                        <% else %>
                                            <a class="itemfontbold"><%=Pagenumber%></a><% if pagenumber < (endAtPage) then %><font class=itemfont>,</font><% end if %>
                                        <% end if %>                                                                                                                                                                                                                
                                        <% pageNumber = pageNumber + 1 %>
                                    <% loop %>
                                        </td>
                                    <td class=itemfont>&nbsp;&nbsp;</td>
                                    <td class=ItemLink>
                                        <% if int(page) < int(endAtPage) then %>
                                            <a href="javascript:MovetoPage(<%=page+1%>);" class=ItemLink>Next >></a>
                                        <% else %>
                                            Next >>
                                        <% end if %>
                                    </td>
                                        </table>
                                    </td>
                                </tr>
                        <%else%>
                            <tr class=itemfont  height=20>
                                <td valign="middle"  width=2%></td>
                                <td class=itemfontlink valign="middle" colspan=4 width=2%>Your search returned no results</td>
                            </tr>
                            <tr>
                                <td colspan=5 class=titlearealine  height=1></td> 
                            </tr>
                        <%end if%>
                </table>
            </td>
        </tr>
                                        
                                        
 