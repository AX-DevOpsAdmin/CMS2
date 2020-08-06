	
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
	
	strCommand = "spGetAuthCodeAudit"

	objCmd.CommandText = strCommand

	set objPara = objCmd.CreateParameter ("authcode",200,1,100, request("authcode"))
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
                        
                        <td colspan=11 valign="middle">Authorisation Code: <Font class=searchheading><%=request("authcode")%></Font></td>
                    </tr>
                
                    <tr class=itemfont height=30>
                        
                        <td colspan=11 valign="middle">Search Results: <Font class=searchheading>records found: <%=rsAuths.recordcount%></Font></td>
                    </tr>
                
                    <tr>
                        <td colspan=11 class=titlearealine  height=1></td> 
                    </tr>
                    <tr class=columnheading height=30>
                      
                      <td valign="middle"  width=16% >Authorised</td>
                      <td valign="middle"  width=5% >Action</td>
                      <td valign="middle"  width=6%>Start</td>
                      <td valign="middle"  width=6%>End</td>
                      
                      <td valign="middle"  width=15% >Requested By</td>
                      <td valign="middle"  width=6% >Requested</td>
                      <td valign="middle"  width=13% >Assessor</td>
                      <td valign="middle"  width=6%>Assessed</td>
                      <td valign="middle"  width=19%>Approver</td>
                      <td valign="middle"  width=7% >Approved</td>
                    </tr>
                    <tr>
                      <td colspan=11 class=titlearealine  height=1></td> 
                    </tr>
      
                                            
                    <%if rsAuths.recordcount > 0 then%>
                    
						<%Row=1%>
                        
                         <%'  response.write( "row is ") & Row & " * " & recordsPerPage %>
                        <%'do while Row < recordsPerPage%>
                        <% lastauthed="z" %>
                        <% do while not rsAuths.eof %>
                            <% if rsAuths("authorised") <> lastauthed then %>
                               <% if lastauthed <> "z" then %>
                                 <tr>
                                    <td colspan=12 style="background-color:#E8FFFF"  height=1>&nbsp;</td> 
                                </tr>
                                <tr>
                                    <td colspan=11 class=titlearealine  height=1></td> 
                                </tr>

                               <%end if %>
                                <% lastauthed=rsAuths("authorised") %>
                            <%end if%>
                            
                        
                            <tr class=itemfont>
                              
                              <td valign="middle" width=16% ><%=rsAuths("authorised")%></td>
                              <td valign="middle" width=5% ><%=rsAuths ("authtype")%></td>
                              <td valign="middle" width=6%><%=rsAuths ("startdate")%></td>
                              <td valign="middle" width=6%><%=rsAuths ("enddate")%></td>
                              
                              <td valign="middle" width=15% ><%=rsAuths ("requestedby")%></td>
                              <td valign="middle" width=6% ><%=rsAuths ("requested")%></td>
                              <td valign="middle" width=13% ><%=rsAuths ("assessedby")%></td>
                              <td valign="middle" width=6%><%=rsAuths ("assessed")%></td>
                              <td valign="middle" width=19%><%=rsAuths ("approver")%></td>
                              <td valign="middle" width=7% ><%=rsAuths ("approved")%></td>
                            </tr>
                            <tr>
                                <td colspan=11 class=titlearealine  height=1></td> 
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
                            <td colspan=11>
                                <table  border=0 cellpadding=0 cellspacing=0>
                                    <tr>
                                    <!--	If we need PAGING at some point put it here -->
                                    </tr> 
                                </table>
                            </td>
                        </tr>
                        
                    <%else%>
                            <tr>
                                <td colspan="11" valign="middle">&nbsp;</td>
                            </tr>

                            <tr class=itemfont  height=20>
                                <td valign="middle"  width=2%></td>
                                <td class=itemfontlink valign="middle" colspan=4>Your search returned no results</td>
                            </tr>
                            <tr>
                                <td colspan=11 class=titlearealine  height=1></td> 
                            </tr>
                    <%end if%>
                </table>
            </td>
        </tr>
                                        
                                        
 