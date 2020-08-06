	
    <!--#include file="Includes/security.inc"--> 
    <!--include file="Includes/checkadmin.asp"-->
    <!--#include file="Connection/Connection.inc"-->

    <%

	'If user is not valid Authorisation Administrator OR Level K/J  then log them off
	If (session("authadmin") =0 AND  strAuth > 2 ) then
		Response.redirect("noaccess.asp")
	End If
  
	' here we're going to get list of staff audit records - we will search by searchType
	' 0 = Service Number,  1=Surname (forename )

	'response.Write(request("searchBy") & " * " & request("searchType"))
	'response.End()
	
	
    set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	objCmd.commandtype = 4	
	
	strCommand = "spGetStaffAudit"

	objCmd.CommandText = strCommand

	set objPara = objCmd.CreateParameter ("searchby",200,1,100, request("searchBy"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("searchType",3,1,0,request("searchType"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
	objCmd.Parameters.Append objPara
	
	set rsAuths = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

    'response.Write("Auth Count is  " & rsAuths.recordcount)
    'response.End()

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
	
	recordsPerPage = 20
	
	if recordsPerPage > rsAuths.recordcount then
	    recordsPerPage= rsAuths.recordcount
		endAtPage=recordsPerPage
    end if 
	
	'response.Write("auth levels")
	'response.End()
	
    %>
                                     
        <tr>
            <td>
                <table width=100% border=0 cellpadding=0 cellspacing=0>
                    <tr class=itemfont height=30>
                        <td valign="middle" width=0%>&nbsp;</td>
                        <td colspan=11 valign="middle">Search Results: <Font class=searchheading>records found: <%=rsAuths.recordcount%></Font></td>
                    </tr>
                
                    <tr>
                        <td colspan=12 class=titlearealine  height=1></td> 
                    </tr>
                    <tr class=columnheading height=30>
                      <td valign="middle" width=0%>&nbsp;</td>
                      <td valign="middle"  width=17% >Authorised</td>
                      <td valign="middle"  width=9% >Authorisation</td>
                      <td valign="middle"  width=5% >Action</td>
                      
                      <td valign="middle"  width=6%>Start</td>
                      <td valign="middle"  width=6%>End</td>
                      
                      <td valign="middle"  width=12% >Requested By</td>
                      <td valign="middle"  width=6% >Requested</td>
                      <td valign="middle"  width=12% >Assessor</td>
                      <td valign="middle"  width=7%>Assessed</td>
                      <td valign="middle"  width=14%>Approver</td>
                      <td valign="middle"  width=6% >Approved</td>
                    </tr>
                    <tr>
                      <td colspan=12 class=titlearealine  height=1></td> 
                    </tr>
      
                                            
                    <%if rsAuths.recordcount > 0 then%>
                    
						<%Row=1%>
                        
                         <%'  response.write( "row is ") & Row & " * " & recordsPerPage %>
                        <%'do while Row < recordsPerPage%>
                        <% lastauthed="z" %>
                        <% lastauthcode="z" %>
                        <% do while not rsAuths.eof %>
                            <% if rsAuths("authorised") <> lastauthed then %>
                               <% if lastauthed <> "z" then %>
                                 <tr>
                                  <td colspan=12 style="background-color:#E8FFFF"  height=1>&nbsp;</td> 
                                </tr>
                               <%end if %>
                                <% lastauthed=rsAuths("authorised") %>
                                <% lastauthcode =rsAuths("authcode") %>
                            <%end if%>
                            
                            <%if rsAuths("authcode") <> lastauthcode then %>
                                <% if lastauthcode <> "z" then %>
                                  <tr>
                                    <td colspan=12 style="background-color:#E8FFFF"  height=1>&nbsp;</td> 
                                  </tr>
                                <%end if %>
                                <% lastauthcode=rsAuths("authcode") %>
                                
                            <% end if %>
                        
                            <tr class=itemfont>
                              <td valign="middle" width=0%>&nbsp;</td>
                              <td valign="middle" width=17% ><%=rsAuths("authorised")%>
			           <%' if rsAuths("authorised") <> lastauthed then %>
                                      <%' lastauthed=rsAuths("authorised") %>
                                      <%'= response.Write(rsAuths("authorised"))%>
                                   <%' end if %>
							  </td>
                              <td valign="middle" width=9% ><%=rsAuths ("authcode")%></td>
                              <td valign="middle" width=5% ><%=rsAuths ("authtype")%></td>
                              
                              <td valign="middle" width=6%><%=rsAuths ("startdate")%></td>
                              <td valign="middle" width=6%><%=rsAuths ("enddate")%></td>
                              
                              <td valign="middle" width=12% ><%=rsAuths ("requestedby")%></td>
                              <td valign="middle" width=6% ><%=rsAuths ("requested")%></td>
                              <td valign="middle" width=12% ><%=rsAuths ("assessedby")%></td>
                              <td valign="middle" width=7%><%=rsAuths ("assessed")%></td>
                              <td valign="middle" width=14%><%=rsAuths ("approver")%></td>
                              <td valign="middle" width=6% ><%=rsAuths ("approved")%></td>
                            </tr>
                            <tr>
                                <td colspan=12 class=titlearealine  height=1></td> 
                            </tr>
                        <%
                        Row=Row+1
                        rsAuths.MoveNext
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
                            <td colspan=12>
                                <table  border=0 cellpadding=0 cellspacing=0>
                                    <tr>
                                    <!--	If we need PAGING at some point put it here -->
                                    </tr> 
                                </table>
                            </td>
                        </tr>
                        
                    <%else%>
                            <tr>
                                <td colspan="12" valign="middle">&nbsp;</td>
                            </tr>

                            <tr class=itemfont  height=20>
                                <td valign="middle"  width=0%></td>
                                <td class=itemfontlink valign="middle" colspan=4>Your search returned no results</td>
                            </tr>
                            <tr>
                                <td colspan=12 class=titlearealine  height=1></td> 
                            </tr>
                    <%end if%>
                </table>
            </td>
        </tr>
                                        
                                        
 