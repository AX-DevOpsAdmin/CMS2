<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
session("postID")=""
Tab=1
teamID=request("recID")
sortID = request("sortID")

if sortID = "" then 
	if session("sortID")="" then
		sortID = 2 
	else
		sortID = session("sortID")
	end if
end if

session("sortID") = sortID
allTeams = request ("allTeams")

todayDate = formatdatetime(date(),2)
splitDate = split (todayDate,"/")
if splitdate(1)="01" then theMonth="Jan"
if splitdate(1)="02" then theMonth="Feb"
if splitdate(1)="03" then theMonth="Mar"
if splitdate(1)="04" then theMonth="Apr"
if splitdate(1)="05" then theMonth="May"
if splitdate(1)="06" then theMonth="Jun"
if splitdate(1)="07" then theMonth="Jul"
if splitdate(1)="08" then theMonth="Aug"
if splitdate(1)="09" then theMonth="Sep"
if splitdate(1)="10" then theMonth="Oct"
if splitdate(1)="11" then theMonth="Nov"
if splitdate(1)="12" then theMonth="Dec"

newTodaydate = formatdatetime(date(),2)
if Session("openfield") = "" or request("openfield") <> "" then
	Session("openfield") = request("openfield")
end if

if request ("thisDate") <>"" then
	thisDate = request ("thisDate")
else
	thisDate = newTodaydate
end if

strTable = "tblTeam"    
strGoTo = request("fromPage")    
strTabID = "teamID"                      

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

' temp till we get rid of teams
if request("hrcID")="" then
  intHrc=1
else
  intHrc= int(request("hrcID"))
end if

objCmd.CommandText = "spGetTeamID"

set objPara = objCmd.CreateParameter ("hrcID",3,1,5, intHrc)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("@teamID",3,2,4)
objCmd.Parameters.Append objPara
objCmd.Execute	
teamID=objCmd.Parameters("@teamID")

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next




objCmd.CommandText = "spListTaskTypesForTasking"
objCmd.CommandType = 4				
set rsTaskTypes = objCmd.Execute	

objCmd.CommandText = "spTeamPostsInAndOut"	
objCmd.CommandType = 4				
set objPara = objCmd.CreateParameter ("TeamID",3,1,5, teamID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("allTeams",3,1,5, int(allTeams))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("thisDate",200,1,16, thisDate)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("sort",200,1,16, sortID)
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

'If the recordset is NOT empty then ...
if not (rsRecSet.bof and rsRecSet.eof) then
	' make sure we set the levelID to EITHER the parent if its Wing/Sqn/Flt or if its a TEAM then the actual teamID
	tmLevel = rsRecSet("teamIn")
	if tmLevel < 4 then
		tmLevelID = rsRecSet("ParentID")
	else
		tmLevelID = request("RecID")
		tmLevel=5
	end if 

	' now check to see if they have manager rights for this team. 1 = Manager   0 = User
	if session("Administrator") = "1" then
		strManager = "1"
		session("Manager") = 1 
	elseif session("UserStatus")  = "1" then
		set objPara = objCmd.CreateParameter ("TeamID",3,1,5,teamID)
		objCmd.Parameters.Append objPara  
		set objPara = objCmd.CreateParameter ("staffID",3,1,5, session("StaffID") )
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("Manager",3,2)
		objCmd.Parameters.Append objPara
  
		objCmd.CommandText = "spCheckManager"	'Name of Stored Procedure'
		objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
		strManager = objCmd.Parameters("Manager")  
		session("Manager") = objCmd.Parameters("Manager")
		
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
end if
%>

<html>
<head>
<!--#include file="Includes/IECompatability.inc"-->
<title>Team Hierarchy</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body onClick="checkPage();">
<form action="" method="POST" name="frmDetails">
    <Input name="ttID" type="hidden" >
    <Input name="description" type="hidden" >
    <input name="serviceNo" type="hidden">
    <input name="postID" type="hidden" value="1234">
    <input name="staffPostID" type="hidden" value="">
    <input name="recID" type="hidden" value="<%=request("recID")%>">
    <input name="thisDate" type="hidden" value="<%=thisDate%>">
    <input name="staffID" type="hidden">
    <input name="teamID" type="hidden" value="<%=request("recID")%>">
    <input name="sortID" type="hidden" value="<%=sortID%>">
    <input name="ghost" type="hidden" value="">

    <table width="99%" height="670" border="0" cellpadding="0" cellspacing="0" style="margin-left:5px;">
    <!--#include file="Includes/hierarchyTeamDetails.inc"--> 
        <tr>
            <td>
                <table width="100%" border=0 cellpadding=0 cellspacing=0>
					<tr height=8>
                        <td colspan="4">&nbsp;</td>
                    </tr>
                    <tr height=20>
                    	<td width=1%>&nbsp;</td>
                        <td width=8% valign="middle" class=columnheading>Unit:</td>
                        <td width=91% valign="middle" class=itemfont><%=rsRecSet("ParentDescription")%> > <font  class="youAreHere"><%=rsRecSet("Description")%></font> </td>
                    </tr>
                    <tr height=20>
                    	<td width=1%>&nbsp;</td>
                        <td width=8% valign="middle" class=columnheading>Team Size:</td>
                        <td width=91% valign="middle" class=itemfont><font id='totalCount'>&nbsp;</font>&nbsp;Posts - <strong>Tip: </strong>Columns "Rank", "Surname" and "Team" can be ordered by clicking on the column heading.</td>
                    </tr>
                    <tr height=20>
                    	<td colspan="3">&nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>
      
        
        <%color1="#f4f4f4"
        color2="#fafafa"
        counter=0%>

		<%set rsRecSet=rsRecSet.nextrecordset%>
        <%presentCount=rsRecSet.recordCount%>
        <%totalPosts=rsRecSet.recordCount%>

        <tr height=30 class=SectionHeaderPlain>
            <td>
                <table border=0 cellpadding=0 cellspacing=0 >
                    <tr>
                       <td class=toolbar width=8></td>                       
                       <td class=toolbar valign="middle" >Personnel Present (<font id='presentCount'><%=presentCount%></font>): <%=thisDate%></td>
                    </tr>  
                </table>
            </td>
        </tr>
		<tr height=35%>
			<td valign=top>
                <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                        <td colspan=15 class=titlearealine  height=1></td> 
                    </tr>
                    <tr class="SectionHeaderGreen columnheading" height=30>
                        <td width=8px class="toolbar">&nbsp;</td>
						<td width=85px>Assign No</td>
						<td width=70px>Service No</td>
						<td width=45px align="center">Mgr</td>
						<td width=55px onClick="javascript:sortColumn(1)" style="cursor:hand;">Rank</td>
						<td width=140px>Firstname</td>
                        <td width=160px onClick="javascript:sortColumn(2)" style="cursor:hand;">Surname</td>
						<td width=30px>&nbsp;</td>
						<td width=125px onClick="javascript:sortColumn(3)" style="cursor:hand;">Team</td>
						<td width=96px>Work Phone</td>
						<td width=65px align="center">Q Status</td>
						<td width=1px>&nbsp;</td>
						<td width=65px align="center">Mil Status</td>
						<td width=35px align="center">Task</td>
                        <td width=5px>&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan=15 class=titlearealine  height=1></td> 
                    </tr>
                </table>
				<Div class="ScrollingAreaTeams">
					<table width=100% border=0 cellpadding=0 cellspacing=0 style="table-layout:fixed;">
						<%do while not rsRecSet.eof%>
							<% objCmd.CommandText = "spGetStaffQTotal"	
                            objCmd.CommandType = 4				
                            
                            set objPara = objCmd.CreateParameter ("staffID",3,1,5, rsRecSet("staffID"))
                            objCmd.Parameters.Append objPara
                            set objPara = objCmd.CreateParameter ("postID",3,1,5, rsRecSet("postID"))
                            objCmd.Parameters.Append objPara
                            set objPara = objCmd.CreateParameter ("thisDate",200,1,16, thisDate)
                            objCmd.Parameters.Append objPara
                            set rsStaffQTotal = objCmd.Execute	
                            
                            for x = 1 to objCmd.parameters.count
                                objCmd.parameters.delete(0)
                            next
            
                            objCmd.CommandText = "spGetMilStatus"	
                            objCmd.CommandType = 4				
                            
                            set objPara = objCmd.CreateParameter ("postID",3,1,5, rsRecSet("postID"))
                            objCmd.Parameters.Append objPara				
                            set objPara = objCmd.CreateParameter ("staffID",3,1,5, rsRecSet("staffID"))
                            objCmd.Parameters.Append objPara
                            set objPara = objCmd.CreateParameter ("thisDate",200,1,16, thisDate)
                            objCmd.Parameters.Append objPara
                            set rsMilstatus = objCmd.Execute
                    
                            for x = 1 to objCmd.parameters.count
                                objCmd.parameters.delete(0)
                            next %>

                            <tr id="<%=rsRecSet("postID")%>" <%if int(rsRecSet("postID"))=int(request("fromSearch")) then%><% tempPostID = rsRecSet("postID") %><% tempstaffPostID=rsRecSet("staffPostID") %><% tempServiceno=rsRecSet("serviceno") %><%end if%> class=itemfont height=30 style="<%if counter=0 then%>background-color:<%=color1%>;<%if strManager=1 or cint(session("Administrator"))=1 then%>cursor:hand;<%end if%><%else%>background-color:<%=color2%>;<%if strManager=1 or cint(session("Administrator"))=1 then%>cursor:hand;<%end if%><%end if%>" <%if strManager=1 or cint(session("Administrator"))=1 then%>onClick="postItemOnclick(document.getElementById('<%=rsRecSet("postID")%>'),'<%=rsRecSet("postID")%>','<%=rsRecSet("staffPostID")%>','<%=rsRecSet("serviceno")%>','<%=rsRecSet("Ghost")%>');"<%end if%>>
                                <td width=8px>&nbsp;</td>
                                <td width=85px title="Description: <%=rsRecSet("Description")%>"><% if rsRecSet("assignno") <> "Ghost" then %><A class=itemfontlink href="javascript:gotoPostDetails(<%=rsRecSet("postID")%>);" ><%=rsRecSet("Assignno")%></A><% else %><%=rsRecSet("Assignno")%><% end if %></td>
                                <%if rsRecSet("serviceno") <> "" then%>
                                    <td width=70px><%=rsRecSet("serviceno") %></td>
                                    <td width=45px align="center"><% if rsRecSet("Ghost") = 0 then %><%if cint(session("Administrator"))=1 then%><A class=itemfontlink href="javascript:gotoManagerDetails(<%=rsRecSet("postID")%>);" ><%if rsRecSet("mgr")<>"" then%>Y<%else%>N<%end if%></A><%else%><%if rsRecSet("mgr")<>"" then%>Y<%else%>N<%end if%><%end if%><% else %><%if rsRecSet("mgr") <> "" then%>Y<% else %>N<% end if %><% end if %></td>
                                    <td width=55px><%=rsRecSet("shortDesc")%></td>
                                    <td width=140px title="<%=rsRecSet("firstName")%>"><div class="ellipsis" style="width:135px;"><%=rsRecSet("firstName")%></div></td>
                                    <td width=160px title="<%=rsRecSet("surname")%>"><div class="ellipsis" style="width:155px;"><% if rsRecSet("Ghost") = 0 then %><%if strManager=1 or cint(session("Administrator"))=1 or cint(rsRecSet("staffID")) = cint(session("StaffID")) then%><A class=itemfontlink href="javascript:gotoStaffDetails(<%=rsRecSet("staffID")%>,<%=rsRecSet("postID")%>);" ><%=rsRecSet("surname")%></A><%else%><%=rsRecSet("surname")%><%end if%><% else %><%=rsRecSet("surname")%><% end if %></div></td>
                                    <td width=30px><img class="imagelink" src="images/info.gif" title="Click here for further details" onClick="javascript:ajaxFunction('manningGetPersonnelInfoAjax.asp','staffID=<%=rsRecSet("staffID")%>','Personnel Details',100,100,250,600)"></td>
                                    <td width=125px title="<%=rsRecSet("teamName")%>"><div class="ellipsis" style="width:115px;"><%=rsRecSet("teamName")%></div></td>
                                    <td width=96px title="<%=rsRecSet("workphone")%>"><div class="ellipsis" style="width:90px;"><%=rsRecSet("workphone")%></div></td>
                                <%else%>
                                    <%presentCount=presentCount-1%>
                                    <td colspan=8 width=721px align="center" style="color:#ff0000;">Post is vacant at this time</td>
                                <%end if%>
                                <%if rsStaffQTotal.recordcount > 0 then
									if rsRecSet("QTotal") > 0 then
										percentage = (rsStaffQTotal("staffQTotal")/rsRecSet("QTotal"))*100
									else
										percentage = 0
									end if
									staffQTotal = rsStaffQTotal("staffQTotal")
                                else
                                    percentage=0
                                    staffQTotal=0
                                end if%>
                                <%if rsRecSet("QTotal")=0 then percentage=999%>
                                <td <%if rsRecSet("serviceno")<>"" then%><% if rsRecSet("Ghost") = 0 then %> onclick="javascript:ajaxFunction('HierarchyPersQualificationsAjax.asp','staffID=<%=rsRecSet("staffID")%>&postID=<%=rsRecSet("postID")%>&thisDate=<%=thisDate%>','Qualification Summary',100,10,642,678)"<% end if %><% end if %> align="center" width=65px <% if rsRecSet("Ghost") = 0 then %>title="<%if percentage <> 999 then response.write cint(percentage)&"%" else response.write "No Qs against post"%>"<% end if %> style="background-color:<% if rsRecSet("Ghost") = 0 then %><%if percentage>75 then%>#00ff00<%elseif percentage>50 then%>#ffff00<%elseif percentage>25 then%>#ffcc00<%else%>#ff0000<%end if%><% else %>#CCC<% end if %>">
									<%if percentage=999 then%>
                                        No Qs...
                                    <%else%>
                                        <%if percentage>75 then%>
                                            Green
                                        <%else%>
                                            <%if percentage>50 then%>
                                                Yellow
                                            <%else%>
                                                <%if percentage>25 then%>
                                                    Amber
                                                <%else%>
                                                    Red
                                                <%end if%>
                                            <%end if%>
                                        <%end if%>
                                    <%end if%>
                                </td>
                                <td width=1px style=""></td>
                                <td <% if rsRecSet("Ghost") = 0 then %>title="MS=<%=rsMilstatus ("milskillstatus")%>,Vacs=<%=rsMilstatus ("vacStatus")%>,Fitness=<%=rsMilstatus ("fitnessStatus")%>,Dental=<%=rsMilstatus ("dentalStatus")%>"<% end if %> align="center" width=65px style="background-color:<% if rsRecSet("Ghost") = 0 then %><%if rsMilstatus ("overallStatus") ="G" then%>#00ff00<%end if%><%if rsMilstatus ("overallStatus") ="A" then%>#ffcc00<%end if%><%if rsMilstatus ("overallStatus") ="R" then%>#ff0000<%end if%><% else %>#CCC<% end if %>">
                                    <%if rsMilstatus ("overallStatus") ="G" then%>Green<%end if%>
                                    <%if rsMilstatus ("overallStatus") ="A" then%>Amber<%end if%>
                                    <%if rsMilstatus ("overallStatus") ="R" then%>Red<%end if%>
                                </td>
                                <td width=35px align="center" <% if rsRecSet("Ghost") = 0 then %><%if rsRecSet("serviceno")<>"" then%><%if strManager=1 then%>onclick="document.getElementById('light').style.display='block';document.getElementById('fade').style.display='block'('<%=rsRecSet("description")%>',this);"<%end if%><%end if%><% end if %>><img src="<% if rsRecSet("Ghost") = 0 then %>Images/itevent.gif<% else %>Images/itevent_gray.gif<% end if %>"></td>
                            </tr>
                            <tr>
                                <td colspan=14 class="titlearealine"  height=1></td> 
                            </tr>
                            <%rsRecSet.movenext
                            if counter=0 then
                                counter=1
                            else
                                if counter=1 then counter=0
                            end if%>
						<% loop %>
                        
					</table>
				</div>
			</td>
        </tr>
        
		<script language="Javascript">document.getElementById('presentCount').innerHTML="<%=presentCount%>"</script>
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
        <script language="Javascript">document.getElementById('totalCount').innerHTML="<%=totalPosts%>"</script>
        <tr  height=30 class=SectionHeaderPlain>
            <td>
                <table border=0 cellpadding=0 cellspacing=0>
                    <tr>
                       <td class=toolbar width=8></td>                       
                       <td class=toolbar valign="middle">Personnel Absent (<%=rsRecSet.recordCount%>): <%=thisDate%></td>
                    </tr>  
                </table>
            </td>
        </tr>
        <tr>
        <td colspan=15 class=titlearealine  height=1></td> 
                    </tr>
        <tr height=35%>
            <td valign=top>
               
                <table width=100% border=0 cellpadding=0 cellspacing=0>
                    <tr class="SectionHeaderRed columnheading" height=30>
                        <td width=8px class="toolbar">&nbsp;</td>
						<td width=85px>Assign No</td>
						<td width=70px>Service No</td>
						<td width=45px align="center">Mgr</td>
						<td width=55px onClick="javascript:sortColumn(1)" style="cursor:hand;">Rank</td>
						<td width=140px>Firstname</td>
                        <td width=160px onClick="javascript:sortColumn(2)" style="cursor:hand;">Surname</td>
						<td width=30px>&nbsp;</td>
						<td width=125px onClick="javascript:sortColumn(3)" style="cursor:hand;"30146844>Team</td>
						<td width=96px>Work Phone</td>
						<td width=65px align="center">Q Status</td>
						<td width=1px>&nbsp;</td>
						<td width=65px align="center">Mil Status</td>
						<td width=35px align="center">Task</td>
                        <td width=5px>&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan=15 class=titlearealine  height=1></td> 
                    </tr>
                </table>
                
				<div class="ScrollingAreaTeams">
                    <table width=100% border=0 cellpadding=0 cellspacing=0 style="table-layout:fixed;">
                        <%do while not rsRecSet.eof%>
                            <%objCmd.CommandText = "spGetStaffQTotal"	
                            objCmd.CommandType = 4
                                            
                            set objPara = objCmd.CreateParameter ("staffID",3,1,5, rsRecSet("staffID"))
                            objCmd.Parameters.Append objPara
                            set objPara = objCmd.CreateParameter ("postID",3,1,5, rsRecSet("postID"))
                            objCmd.Parameters.Append objPara
                            set objPara = objCmd.CreateParameter ("thisDate",200,1,16, thisDate)
                            objCmd.Parameters.Append objPara
                            set rsStaffQTotal = objCmd.Execute	
                            
                            for x = 1 to objCmd.parameters.count
                                objCmd.parameters.delete(0)
                            next
            
                            objCmd.CommandText = "spGetMilStatus"	
                            objCmd.CommandType = 4				
                            
                            set objPara = objCmd.CreateParameter ("postID",3,1,5, rsRecSet("postID"))
                            objCmd.Parameters.Append objPara				
                            set objPara = objCmd.CreateParameter ("staffID",3,1,5, rsRecSet("staffID"))
                            objCmd.Parameters.Append objPara
                            set objPara = objCmd.CreateParameter ("thisDate",200,1,16, thisDate)
                            objCmd.Parameters.Append objPara
                            set rsMilstatus = objCmd.Execute	
                            
                            for x = 1 to objCmd.parameters.count
                                objCmd.parameters.delete(0)
                            next %>
        
                            <tr id="<%=rsRecSet("postID")%>" <%if int(rsRecSet("postID"))=int(request("fromSearch")) then%><% tempPostID = rsRecSet("postID") %><% tempstaffPostID=rsRecSet("staffPostID") %><% tempServiceno=rsRecSet("serviceno") %><%end if%> class=itemfont height=30 style="<%if counter=0 then%>background-color:<%=color1%>;<%if strManager=1 or cint(session("Administrator"))=1 then%>cursor:hand;<%end if%><%else%>background-color:<%=color2%>;<%if strManager=1 or cint(session("Administrator"))=1 then%>cursor:hand;<%end if%><%end if%>" <%if strManager=1 or cint(session("Administrator"))=1 then%>onClick="postItemOnclick(this,'<%=rsRecSet("postID")%>','<%=rsRecSet("staffPostID")%>','<%=rsRecSet("serviceno")%>','1');"<%end if%>>
                                
                                <td width=8px></td>
                                
                                <td width=70px title="Description: <%=rsRecSet("Description")%>"><% if rsRecSet("assignno") <> "Ghost" then %><A class=itemfontlink href="javascript:gotoPostDetails(<%=rsRecSet("postID")%>);" ><%=rsRecSet("Assignno")%></A><% else %><%=rsRecSet("Assignno")%><% end if %></td>
                                
                                <td width=70px><%=rsRecSet("serviceno")%></td>
                                
                                <td width=45px align="center"><% if rsRecSet("Ghost") = 0 then %><%if cint(session("Administrator"))=1 then%><A class=itemfontlink href="javascript:gotoManagerDetails(<%=rsRecSet("postID")%>);" ><%if rsRecSet("mgr")<>"" then%>Y<%else%>N<%end if%></A><%else%><%if rsRecSet("mgr")<>"" then%>Y<%else%>N<%end if%><%end if%><% else %><%if rsRecSet("mgr") <> "" then%>Y<% else %>N<% end if %><% end if %></td>
                                <td width=55px><%=rsRecSet("shortDesc")%></td>
                                
                                <td width=140px title="<%=rsRecSet("firstName")%>"><div class="ellipsis" style="width:135px;"><%=rsRecSet("firstName")%></div></td>
                                
                                <td width=160px title="<%=rsRecSet("surname")%>"><div class="ellipsis" style="width:155px;"><% if rsRecSet("Ghost") = 0 then %><%if strManager=1 or cint(session("Administrator"))=1 or cint(rsRecSet("staffID")) = cint(session("StaffID")) then%><A class=itemfontlink href="javascript:gotoStaffDetails(<%=rsRecSet("staffID")%>,<%=rsRecSet("postID")%>);" ><%=rsRecSet("surname")%></A><%else%><%=rsRecSet("surname")%><%end if%><% else %><%=rsRecSet("surname")%><% end if %></div></td>
                                
                                <td width=30px><img class="imagelink" src="images/info.gif" title="Click here for further details" onClick="javascript:ajaxFunction('manningGetPersonnelInfoAjax.asp','staffID=<%=rsRecSet("staffID")%>','Personnel Details',100,200,250,600)"></td>
                               
                                <td width=125px title="<%=rsRecSet("teamName")%>"><div class="ellipsis" style="width:115px;"><%=rsRecSet("teamName")%></div></td>
                                <td width=96px title="<%=rsRecSet("Location")%>"><div class="ellipsis" style="width:90px;"><%=rsRecSet("Location")%></div></td>
                                <%if rsStaffQTotal.recordcount>0 then 
									if rsRecSet("QTotal") > 0 then
										percentage = (rsStaffQTotal("staffQTotal")/rsRecSet("QTotal"))*100
									else
										percentage = 0
									end if
                                else
                                    percentage=0
                                end if%>
                                <%if rsRecSet("QTotal")=0 then percentage=999%>
                                <td <%if rsRecSet("serviceno")<>"" then%><% if rsRecSet("Ghost") = 0 then %> onclick="javascript:ajaxFunction('HierarchyPersQualificationsAjax.asp','staffID=<%=rsRecSet("staffID")%>&postID=<%=rsRecSet("postID")%>&thisDate=<%=thisDate%>','Qualification Summary',100,10,642,678)"<% end if %><% end if %> align="center" width=65px <% if rsRecSet("Ghost") = 0 then %>title="<%if percentage <> 999 then response.write cint(percentage)&"%" else response.write "No Qs against post"%>"<% end if %> style="background-color:<% if rsRecSet("Ghost") = 0 then %><%if percentage>75 then%>#00ff00<%elseif percentage>50 then%>#ffff00<%elseif percentage>25 then%>#ffcc00<%else%>#ff0000<%end if%><% else %>#CCC<% end if %>">
                                    <%if percentage=999 then%>
                                        No Qs...						
                                    <%else%>
                                        <%if percentage>75 then%>
                                            Green
                                        <%else%>
                                            <%if percentage>50 then%>
                                                Yellow
                                            <%else%>
                                                <%if percentage>25 then%>
                                                    Amber
                                                <%else%>
                                                    Red
                                                <%end if%>
                                            <%end if%>
                                        <%end if%>
                                    <%end if%>
                                </td>
                                <td width=1px style="background-color:#000000;"></td>
                                <td <% if rsRecSet("Ghost") = 0 then %>title="MS=<%=rsMilstatus ("milskillstatus")%>,Vacs=<%=rsMilstatus ("vacStatus")%>,Fitness=<%=rsMilstatus ("fitnessStatus")%>,Dental=<%=rsMilstatus ("dentalStatus")%>"<% end if %> align="center" width=65px style="background-color:<% if rsRecSet("Ghost") = 0 then %><%if rsMilstatus ("overallStatus") ="G" then%>#00ff00<%end if%><%if rsMilstatus ("overallStatus") ="A" then%>#ffcc00<%end if%><%if rsMilstatus ("overallStatus") ="R" then%>#ff0000<%end if%><% else %>#CCC<% end if %>">
                                    <%if rsMilstatus ("overallStatus") ="G" then%>Green<%end if%>
                                    <%if rsMilstatus ("overallStatus") ="A" then%>Amber<%end if%>
                                    <%if rsMilstatus ("overallStatus") ="R" then%>Red<%end if%>
                                </td>
                                
                                <td width=35px align="center" <% if rsRecSet("Ghost") = 0 then %><%if rsRecSet("serviceno")<>"" then%><%if strManager=1 then%>onclick="('<%=rsRecSet("description")%>');"<%end if%><%end if%><% end if %>><img src="<% if rsRecSet("Ghost") = 0 then %>Images/itevent.gif<% else %>Images/itevent_gray.gif<% end if %>"></td>
                            </tr>
                            <tr>
                                <td colspan=14 class=titlearealine  height=1></td> 
                            </tr>
                            <%rsRecSet.movenext
                            if counter=0 then
                                counter=1
                            else
                                if counter=1 then counter=0
                            end if
                        loop%>
                    </table>
                </Div >
            </td>
        </tr>
       
    </table>
</form>

<div id="light" class="popup">
	<Div id="TaskList" name="TaskList">
		<table style="width:280px;">			
			<tr>
            	<td align="center" colspan=2 id="postNameForTasking"><a href="javascript:void(0)" onclick="document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'">Close</a></td>
			</tr>
			
			
			<%tempSection = 0%>
            
			<%do while not rsTaskTypes.eof%>
				<%if tempSection <> rsTaskTypes("section") then%>
                    <tr>
                        <td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
                <%end if%>
                <%tempSection = rsTaskTypes("section")%>
                <tr style="cursor:hand;" id="<%=rsTaskTypes("Description")%>" name=id="<%=rsTaskTypes("Description")%>" class=itemfont height=25px onMouseOver="taskItemOver(this);" onMouseOut="taskItemOut(this);">
                   <td onclick="gotoTask('<%=rsTaskTypes("ttID")%>','<%=rsTaskTypes("Description")%>')"><%=rsTaskTypes("Description")%></td>
                </tr>
                <%rsTaskTypes.movenext
			loop%>
		</table>
	</Div></div>




<script>
function showMenu(postName, obj)
{
	document.getElementById('postNameForTasking').innerHTML=postName;
	var TaskList = document.getElementById('TaskList');
	var taskListState=TaskList.style.visibility
	TaskList.style.visibility="Visible";
	TaskList.style.left = elemPosition(obj).left-150; 
	TaskList.style.top = elemPosition(obj).top-180; 
	justOpened=1
	return false;
}
</script>
<%
windowWidth=210
windowHeight=210%>


<div id="detailWindow" class="windowBorderArea" style="background-color:#f4f4f4;position:absolute;left:200px;top:200px;height:<%=windowHeight%>px;width:<%=windowWidth%>px;visibility:hidden;">
	<table border=0 cellpadding=0 cellspacing=0 align=right width=100%>
		<tr class=SectionHeader>
			<td>
				<DIV id=detailWindowTitleBar style="position:relative;left:7px;top:0px; overflow:none;width:<%=windowWidth-16%>px;border-color:#7f9db9;">
                    <table border=0 cellpadding=0 cellspacing=0 align=right width=100%>
                        <tr>
                            <td id="windowName" class=itemfont></td><td ALIGN=RIGHT><img src="images/windowCloseIcon.png" onClick="javascript:closeThisWindow(detailWindow);"></td>
                        </tr>
                    </table>
				</Div>
			</td>
		</tr>
		<tr>
			<td  class=titlearealine  height=1></td> 
		</tr>
		<tr>
			<td align=left class=itemfont>
				<div id=innerDetailWindow class="innerWindowBorderArea" style="Overflow:auto;background-color:#f4f4f4;color:#000000;position:relative; overflow:none; height:<%=windowHeight-40%>px;width:<%=windowWidth-16%>px">
                    <table border=0 cellpadding=0 cellspacing=0 align=right width=100%>
                        <tr class=itemfont>
                            <td  >
                            </td>
                        </tr>
                    </table>
				</div>
			</td>
		</tr>
	</table>
</div>


</body>
</html>
<% end if %>
<script language="javascript">
var previousPostObject = new Object();
var tempObject = new Object();
firstClick=1;

function taskItemOver(thisObject)
{
	previousBGColor = thisObject.style.backgroundColor;
	previousFGColor = thisObject.style.color;
	thisObject.style.backgroundColor = "#7a9ddc";
	thisObject.style.color = "#ffffff";
}

function taskItemOut(thisObject)
{
	thisObject.style.backgroundColor = previousBGColor;
	thisObject.style.color = previousFGColor;
}

function postItemOnclick(thisObject,postID,staffPostID,serviceNo,ghost)
{
	if(firstClick==0)
	{
		previousPostObject.style.backgroundColor = previousBGColor;
		previousPostObject.style.color = previousFGColor;
	}

	var frmDetails = document.frmDetails;
	frmDetails.postID.value=postID
	frmDetails.staffPostID.value=staffPostID
	frmDetails.serviceNo.value=serviceNo
	frmDetails.ghost.value=ghost
	firstClick=0;
	previousBGColor = thisObject.style.backgroundColor;
	previousFGColor = thisObject.style.color;
	previousPostObject = thisObject;
	thisObject.style.backgroundColor = "#7a9ddc";
	thisObject.style.color = "#ffffff";
}

function checkPage()
{
	TaskList = document.getElementById('TaskList');
	taskListState=TaskList.style.visibility
	
	if(taskListState=="visible" && justOpened==0)
	{
		TaskList.style.visibility="Hidden";
	}
	
	justOpened=0;
}

function checkDelete()
{
	var delOK = false 

	var input_box = confirm("Are you sure you want to delete this Record ?")
	if(input_box==true)
	{
		delOK = true;
	}
	
    return delOK;
}

function MovetoPage (PageNo)
{
	document.forms["frmDetails"].elements["Page"].value = PageNo;
	document.forms["frmDetails"].submit();
}

function gotoTask(ttID,description)
{
	document.frmDetails.ttID.value=ttID;
	document.frmDetails.description.value=description;
	document.frmDetails.action="HierarchyTaskIndividual.asp";
	document.frmDetails.submit();
	window.parent.startTimer()
}

function gotoStaffDetails(staffID,postID)
{
	document.frmDetails.action="HierarchyPersDetail.asp";
	document.frmDetails.staffID.value=staffID;
	document.frmDetails.postID.value=postID;//added 20070727 to make sure postID gets passed
	document.frmDetails.submit();
	window.parent.startTimer()
}

function gotoPostDetails(postID)
{
//alert(staffID)
document.frmDetails.action="HierarchyPostDetail.asp";
document.frmDetails.postID.value=postID;
//alert(document.frmDetails.action);
document.frmDetails.submit();
window.parent.startTimer()
}

function gotoPostIn()
{
	document.frmDetails.action="HierarchyPostStaff.asp";
	document.frmDetails.submit();
}

function gotoManagerDetails(postID)
{
	document.frmDetails.action="HierarchyTeamPostDetail.asp";
	document.frmDetails.recID.value=postID;
	document.frmDetails.submit();
	window.parent.startTimer()
}

function populateDetailsWindow(name,text,xPos,yPos,xHeight,xWidth)
{
	document.getElementById('windowName').innerHTML=name;

	var innerDetailWindow = document.getElementById('innerDetailWindow');
	innerDetailWindow.innerHTML=text;
	var detailWindow = document.getElementById('detailWindow');
	detailWindow.style.visibility="visible";
	detailWindow.style.left=xPos;
	detailWindow.style.top=yPos;
	detailWindow.style.height=xHeight + "px";
	detailWindow.style.width=xWidth + "px";
	innerDetailWindow.style.height=xHeight - 40 + "px";
	innerDetailWindow.style.width=xWidth - 16 + "px";
	document.getElementById('detailWindowTitleBar').style.width=xWidth - 16 + "px";
}

function closeThisWindow (thisWindow)
{
	thisWindow.style.visibility="hidden";
}

function ajaxFunction(ajaxFile,vars,name,xPos,yPos,xHeight,xWidth)
{
    var ajaxRequest;  // The variable that makes Ajax possible!
 	vars = encodeURI(vars);   
    try{
        // Opera 8.0+, Firefox, Safari
        ajaxRequest = new XMLHttpRequest();
    } catch (e){
        // Internet Explorer Browsers
        try{
            ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try{
                ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e){
                // Something went wrong
                alert("Your browser broke!");
                return false;
            }
        }
    }
    // Create a function that will receive data sent from the server
    ajaxRequest.onreadystatechange = function()
	{
    	if(ajaxRequest.readyState == 4)
		{
			populateDetailsWindow(name,ajaxRequest.responseText,xPos,yPos,xHeight,xWidth);
        }
 	}
	//alert("into ajax here " + ajaxFile + " * " + vars + " * " + name);
    ajaxRequest.open("POST", ajaxFile, true);
    ajaxRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    ajaxRequest.send(vars); 
}

function sortColumn(column)
{
	sortID = document.frmDetails.sortID.value
	
	if(sortID==(column*2)){
		document.frmDetails.sortID.value = ((column*2)-1)
	}else{
		document.frmDetails.sortID.value = (column*2)
	}
	
	document.frmDetails.submit()
	window.parent.startTimer()
}

</script>

<% if int (request("fromSearch"))>0 then %>
	<SCRIPT LANGUAGE="JavaScript">
		var passObject = new Object();
		postItemOnclick(document.getElementById('<%=temppostID%>'),'<%=temppostID%>','<%=tempstaffPostID%>','<%=tempserviceno%>');
    </Script>
<% end if %>
<% if int(request("persSearch"))=1 then response.redirect("HierarchyPersonnelSearch.asp") %>