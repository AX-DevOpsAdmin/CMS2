<!DOCTYPE HTML>


<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  

<%

'response.write (" Tasking View " )
'response.End()
' this means we clicked the Search link on the top menu - probably should just go straight to the web page
' from cms_hierarchy3
 if int(request("persSearch"))=1 then response.redirect("HierarchyPersonnelSearch.asp")
 
 ' This means clicked Authorise on top menu
 if int(request("persSearch"))=2 then response.redirect("Authorise.asp")

squareSize=25
tab=2

session("pla") = 1

if request("allTeams") <> "" then
	allTeams = request("allTeams")
else
	allTeams = 0
end if

todayDate = formatdatetime(date(),2)
splitDate = split (todayDate,"/")

monthList = "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec"
splitMonth = split(monthList, ",")
'splitNum = int(splitDate(1) - 1)
'theMonth = splitMonth(splitNum)

newTodaydate = formatdatetime(date(),2)

if request ("thisDate") <> "" then
	thisDate = request ("thisDate")
else
	thisDate = newTodaydate
End if

if request("initialDate") <> "" then
	initialDate = request("initialDate")
else
	initialDate = newTodaydate
End if


previousMonth = DateAdd("m",-1,thisDate)
nextMonth = DateAdd("m",1,thisDate)

manipulateDate=formatdatetime(thisDate,2)

splitDate = split (manipulateDate,"/")
newMonthYear= splitDate(1)+ "/" + splitDate(2)
splitNum = int(splitDate(1) - 1)
theMonth=splitMonth(splitNum)
MonthYear= theMonth + " - " + splitDate(2)

startOfMonth = "01" & "/" & newMonthYear
startOfNextMonth = formatdatetime(dateAdd("m",1,startOfMonth))
startOfNextMonth = formatdatetime(startOfNextMonth,2)
daysCount= DateDiff("d",startOfMonth,startOfNextMonth)
endOfMonth= daysCount & "/" & newMonthYear

' now get default start/end date for current month to display
splitDate = split (thisDate,"/")
startdate = "01" & "/" & splitDate(1) & "/" & splitDate(2)
enddate=daysCount & "/" & splitDate(1) & "/" & splitDate(2)

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4		
objCmd.Activeconnection.cursorlocation = 3

'if request("hrcID")="" then
'  intHrc=session("hrcID")
'else
'  intHrc= int(request("hrcID"))
'end if
'
'' this holds the Hierarchy ID of the Unit Hierarchy element we just clicked on
'' and we will use this to check that the current user is a manager and authorised to view/edit
'' certain web pages
'session("thisHrcID") = intHrc

objCmd.CommandText = "spListTaskTypesForTasking"
set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
objCmd.Parameters.Append objPara
set rsTaskTypes = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

'response.write(intHrc&"<br>")
'response.write(allTeams&"<br>")
'response.write(thisDate)

'objCmd.CommandText = "spGetTeamID"
objCmd.CommandText = "spGetHierarchyStaff"

set objPara = objCmd.CreateParameter ("hrcID",3,1,5, intHrc)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("allTeams",3,1,5, int(allTeams))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("thisDate",200,1,16, thisDate)
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	
'teamID=objCmd.Parameters("@teamID")

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

%>
<html>
<head>
<!--#include file="Includes/IECompatability.inc"-->
<title>Team Hierarchy</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<style>
body {width:99%; margin:0; padding:0; border:0; line-height:1;} 

</style>

</head>
<body>
<%'=session.Timeout%>
<form action="" method="POST" name="frmTeamPlan" id="frmTeamPlan">
    <Input id="thisDate" name="thisDate" type="hidden" value="<%=thisDate%>">
     <Input id="initialDate" name="initialDate" type="hidden" value="<%=initialDate%>">
    <input id="recID" name="recID" type="hidden" value="<%=request("recID")%>">
    <input id="allTeams" name="allTeams" type="hidden" value="<%=request("allTeams")%>">
    <input id="HiddenDate" name="HiddenDate" type="hidden" >
    <Input name="staffID" id="staffID" type="hidden" >
    <Input name="ttID" id="ttID" type="hidden" >
    <Input name="description" id="description" type="hidden" >

</form>

<!-- This div contains the Planner menu and dates in a fixed position -->
 <!--include file="Includes/hierarchyTeamDetails.asp"-->	
<div id="plannerHeader">
    <!-- This div contains the team breadcrumb (without hyperlinks) and the export option-->

    <div class="plannerSubHeader">
         <font  class="youAreHere">You are here ...
            <%=rsRecSet("crumbtrail")%> &nbsp;&nbsp; </font>

            <a class="itemfontlink" href="javascript:launchReportWindowExcel ();">
                <img src="images/excel.gif" width="18" height="18" class="imagelink">
            </a>
            Export Calender To Excel
    </div>    
    <!-- This div contains the Calender month navigation -->
    <div class="plannerCal">
        <A href="javascript:gotoPreviousMonth(<%=intHRC%>);" class="itemfontlinksmall" ><font color="#0033FF">Previous Month</font></A> 
        &nbsp;|&nbsp;
        <b><font color="#000000" >&nbsp;<%=(MonthYear)%>&nbsp;</font></b>
        &nbsp;|&nbsp;
        <A href="javascript:gotoNextMonth(<%=intHRC%>);" class="itemfontlinksmall" ><font color="#0033FF">Next Month</font></A> 
    </div>

    <!-- This div contains the Calender Day header -->
    <div>
        <table class="tableCal" border="0" cellpadding="0" cellspacing="1" >
          <tr>
             <th></th> 

             
             <% counter=1 %>
                <% do while counter <= daysCount %> 
                    <% tempDate = counter & " " & newMonthYear %>
                    <% if formatdatetime(tempDate,2) = formatdatetime(initialDate,2) then %>
                        <% 'strBGC = "#000000" %>
                        <% strBGC = "#ff0000"%>
                        <% strColour = "#dddddd" %>
                    <% else %>
                        <% if weekday(tempDate)=1 or weekday(tempDate)=7 then %>
                            <% strBGC = "#888888" %>
                            <% strColour = "#000000" %>
                        <% else %>
                            <% strBGC = "#dddddd" %>
                            <% strColour = "#000000" %>
                        <% end if %>
                    <% end if %>                   	
                <td align="center" style="background-color:<%= strBGC %>; color:<%= strColour %>"><%=counter%></td>
                    <% counter=counter + 1 %>
                <% loop %> 
               
                <td>&nbsp;</td>
                      
           </tr>
        </table>
    </div>   
</div>
<!-- Close Planner Div-->        

<% counter = 0 %>

<!-- This div contains the Unit and Team Planner --> 
<div id="unitPlanner" class="unitPlanner">
<% set rsRecSet = rsRecSet.nextrecordset %>           
	<!-- This table contains the Team Planner -->
	<table class="tableCal" border="0" cellpadding="0" cellspacing="1" >
		<% 
		  do while not rsRecSet.eof 
		        ' Get auths status - only interested in Amber/Red 
				strAuths=""
				'if not isNull(rsRecSet("auths")) then
				    objCmd.CommandText = "spGetStaffAuthStatus"	
					
					set objPara = objCmd.CreateParameter ("staffID",3,1,5, rsRecSet("staffID"))
					objCmd.Parameters.Append objPara
					set rsStaffAuths = objCmd.Execute
					
					objCmd.parameters.delete(0)
					
					if 	rsStaffAuths("colour")= 1 then   'Red
					    strAuthcolour="#ff0000"
						strAuthTitle="One or More Eng Auths have expired - Click the circle and view the Auths"
				    elseif 	rsStaffAuths("colour")= 2 then    ' Amber
					    strAuthcolour="#F90"
						strAuthTitle="One or More Eng Auths will expire shortly - Click the circle and view the Auths"
					elseif 	rsStaffAuths("colour")= 3 then    ' Green
					    strAuthcolour="#00ff00"
						strAuthTitle="All Eng Auths are Current - Click the circle and view the Auths"

					else
					    strAuthcolour="#ffffff"  ' White - don't display
						strAuthTitle=" "
				    end if
			   ' end if
		        ' Get Qs and Mil Status Red/Green/Amber  - if there are any
				strQpcnt=""
				if rsRecSet("QTotal") > 0 then
					objCmd.CommandText = "spGetStaffQTotal"	
					'objCmd.CommandType = 4				
					
					set objPara = objCmd.CreateParameter ("staffID",3,1,5, rsRecSet("staffID"))
					objCmd.Parameters.Append objPara
					set objPara = objCmd.CreateParameter ("postID",3,1,5, rsRecSet("postID"))
					objCmd.Parameters.Append objPara
					set objPara = objCmd.CreateParameter ("thisDate",200,1,16, thisDate)
					objCmd.Parameters.Append objPara
					set rsStaffQTotal = objCmd.Execute	

                    if rsStaffQTotal("staffQTotal") > 0 then
					  percentage = round((rsStaffQTotal("staffQTotal")/rsRecSet("QTotal"))*100)
					else
					  percentage=0
					end if
					
					for x = 1 to objCmd.parameters.count
						objCmd.parameters.delete(0)
					next
                else
				    percentage=999
					strQpcnt= "No Qs against post - Click on the circle to view the Personnel Q Status"
      			    'strQcolour = "#9FF"
					 strQcolour = "#9AF"
				end if
				'response.write("<br>")
				'response.write ("Q %age is " & percentage & " * " & rsStaffQTotal("staffQTotal") & " * " &  rsRecSet("QTotal"))
				
				if percentage < 999 then 
				   strQpcnt= "Q's are " & percentage & "%" & " of Post Q's - Click the circle and view the Q's"
				   
				   if percentage >75 then
						strQcolour= "#00ff00"
				   else
				     if percentage > 50 then
			           strQcolour="#F90"
				     else
				       if percentage > 25 then
			             strQcolour="#ffcc00"
				       else
				         strQcolour="#ff0000"
				       end if
					 end if
				   end if
			    end if
				
				'strQpcnt= strQpcnt & " Click on the circle to view the Q Status"
				'response.write strQpcnt
				
				objCmd.CommandText = "spGetMilStatus"	
				'objCmd.CommandType = 4				
				
				set objPara = objCmd.CreateParameter ("postID",3,1,5, rsRecSet("postID"))
				objCmd.Parameters.Append objPara				
				set objPara = objCmd.CreateParameter ("staffID",3,1,5, rsRecSet("staffID"))
				objCmd.Parameters.Append objPara
				set objPara = objCmd.CreateParameter ("thisDate",200,1,16, thisDate)
				objCmd.Parameters.Append objPara
				set rsMilstatus = objCmd.Execute
		
		        if rsMilstatus("overallStatus") ="G" then
				   strMScolour= "#00ff00"
				end if
                if rsMilstatus ("overallStatus") ="A" then
   				   strMScolour="#F90"
				end if
				 if rsMilstatus ("overallStatus") ="R" then
				   strMScolour="#ff0000"
				end if
				
				for x = 1 to objCmd.parameters.count
					objCmd.parameters.delete(0)
				next   
		     'if isnull (rsRecset("tmID") ) then
			 if  (rsRecset("manager")=0 ) then
			   mgr=""
			 else
			   mgr="font-weight:bold;"    
			  end if
			        
			 objCmd.CommandText = "spStaffTaskDetails" 
			 objCmd.CommandType = 4 
			 set objPara = objCmd.CreateParameter ("startDate",200,1,30, startOfMonth) 
			 objCmd.Parameters.Append objPara 
			 set objPara = objCmd.CreateParameter ("endDate",200,1,30,endOfMonth) 
			 objCmd.Parameters.Append objPara 
			 set objPara = objCmd.CreateParameter ("staffID",3,1,0,rsRecSet("staffID")) 
			 objCmd.Parameters.Append objPara 
			
			 set rsBusyDates = objCmd.Execute 
			
			 for x = 1 to objCmd.parameters.count 
				 objCmd.parameters.delete(0) 
			 next 
			 
			 if rsBusyDates.recordcount < 1 then  %>
			  <tr>
              
              	<!-- Role th -->
                 
				<th style=""><% if strManager=1 then %><A class=itemfontlink href="javascript:gotoPostDetails(<%=rsRecSet("postID")%>,<%=intHRC%> );" ><% end if %><%=rsRecSet("assignno")%></th>
                
                <!-- Person th -->
                
				<% if not isNull(rsRecSet("personnel")) then '-- Theres a role and a person in that role %> 
                   <th style="<%=mgr%>"><img class="imagelink" src="images/info.gif" title="Click here for further details" onClick="javascript:ajaxFunction('manningGetPersonnelInfoAjax.asp','staffID=<%=rsRecSet("staffID")%>','Personnel Details',100,100,250,600)" > <%if strManager=1 or cint(rsRecSet("staffID")) = cint(session("StaffID")) then%><A class=itemfontlink href="javascript:gotoStaffDetails(<%=rsRecSet("staffID")%>,<%=rsRecSet("postID")%>);" ><%=rsRecSet("personnel")%></A><%else%>&nbsp;<%=rsRecSet("personnel")%><%end if %></th>
                <%else '-- Theres a role and no one in it %>
                   <th>&nbsp;</th>
                <%end if %>
                <!--<th style="height:15px; width:15px; background-image:url(images/statusRound.gif); background-color:<%'=strcolour%>"></th>-->
                <!--<th align="center" title="<%'=strQpcnt%>">  -->
                <% if not isNull(rsRecSet("personnel")) then %>
                    
                    <!-- Eng Auths th -->
                    <th align="center" title="<%=strAuthTitle%>" style="cursor:pointer; background-color:#FFFFFF;">         
                        <div class="statusIcon" style="background-color:<%=strAuthcolour%>"  onclick="javascript:ajaxFunction('HierarchyPersAuthsAjax.asp','staffID=<%=rsRecSet("staffID")%>&thisDate=<%=thisDate%>','Authorisations Summary',300,10,1000,1000)"> </div>
                    </th>

                
                	<!-- Q's th -->
                    <% 'response.write strQpcnt%>
                    <%' response.write "<br>"%>
                    <th align="center" title="<%=strQpcnt%>" style="cursor:pointer; background-color:#FFFFFF;">         
                        <div class="statusIcon" style="background-color:<%=strQcolour%>" onclick="javascript:ajaxFunction('HierarchyPersQualificationsAjax.asp','staffID=<%=rsRecSet("staffID")%>&postID=<%=rsRecSet("postID")%>&thisDate=<%=thisDate%>','Qualification Summary',100,10,642,678)"></div>
                    </th>
                    
                    <!-- Mill Skills th -->
                    
                    <th align="center" title="MS=<%=rsMilstatus ("milskillstatus")%>,Fitness=<%=rsMilstatus ("fitnessStatus")%>" style="background-color:#FFFFFF;">     
                        <div class="statusIcon" style="background-color:<%=strMScolour%>" ></div>
                    </th>
                    
                    <!--<th align="center" title="MS=<%'=rsMilstatus ("milskillstatus")%>,Vacs=<%'=rsMilstatus ("vacStatus")%>,Fitness=<%'=rsMilstatus ("fitnessStatus")%>,Dental=<%'=rsMilstatus ("dentalStatus")%>" style="background-color:#FFFFFF;">     
                        <div class="statusIcon" style="background-color:<%'=strMScolour%>" ></div>
                    </th>-->
                <% else %>
                
                    <!-- Eng Auths th -->
                     
                    <th style=" <%=mgr%> ">&nbsp;</th>

                
                	<!-- Q's th -->
                     
                    <th style=" <%=mgr%> ">&nbsp;</th>
                    
                    <!-- Mill Skills th -->
                    
                    <th style=" <%=mgr%> ">&nbsp;</th>
                <%end if %>
                
				<% counter=1 %>
                
                <!-- Each daily td -->
                
				<% do while counter<=daysCount %>
				<td width="497" class="calendar" >&nbsp;</td>
				<% counter = counter + 1 %>
				<% loop %>
                
                 <!-- Tasking Cal td -->
                 
                <% if strManager=1 and not isNull(rsRecSet("personnel")) then %>
                    <td width=35px align="center" style="cursor:pointer;"><img src="Images/itevent.gif" <%if rsRecSet("staffid")<>"" and strManager=1 then %>onclick="javascript:staffTask(<%=rsRecSet("staffid")%>);document.getElementById('light').style.display='block';"<%end if%>></td>				
			    <% else %>
                    <td width=35px align="center" ></td>
                <%end if%>
                
              </tr>
              
			<%else%>
            
			  <tr>
              	
                <!-- Role th -->
              
				<th style="text-align:left;"><% if strManager=1 then %><A class=itemfontlink href="javascript:gotoPostDetails(<%=rsRecSet("postID")%>,<%=intHRC%>);" ><% end if %><%=rsRecSet("Assignno")%></th>
                
                
                <!-- Person th -->
                
				<% if not isNull(rsRecSet("personnel")) then %>
                   <th style="<%=mgr%>"><img class="imagelink" src="images/info.gif" title="Click here for further details" onClick="javascript:ajaxFunction('manningGetPersonnelInfoAjax.asp','staffID=<%=rsRecSet("staffID")%>','Personnel Details',100,100,250,600)" ><%if strManager=1 or cint(rsRecSet("staffID")) = cint(session("StaffID")) then%><A class=itemfontlink href="javascript:gotoStaffDetails(<%=rsRecSet("staffID")%>,<%=rsRecSet("postID")%>);" ><%=rsRecSet("personnel")%></A><%else%>&nbsp;<%=rsRecSet("personnel")%><%end if %></th>
                <%else %>
                   <th style="<%=mgr%>">&nbsp;</th>
                <%end if %>
                							<!--<th align="center" title="<%'=strQpcnt%>">  -->
                                            
                    <!-- Eng Auths th -->
                    <th align="center" title="<%=strAuthTitle%>" style="cursor:pointer; background-color:#FFFFFF;">         
                        <div class="statusIcon" style="background-color:<%=strAuthcolour%>"  onclick="javascript:ajaxFunction('HierarchyPersAuthsAjax.asp','staffID=<%=rsRecSet("staffID")%>&thisDate=<%=thisDate%>','Authorisations Summary',300,10,1000,1000)"></div>
                    </th>
                
                <!-- Q's th -->
                
                <th align="center" title="<%= strQpcnt %>" style="cursor:pointer; background-color:#FFFFFF;;">     
                    <div class="statusIcon" style="background-color:<%=strQcolour%>"  onclick="javascript:ajaxFunction('HierarchyPersQualificationsAjax.asp','staffID=<%=rsRecSet("staffID")%>&postID=<%=rsRecSet("postID")%>&thisDate=<%=thisDate%>','Qualification Summary',100,10,642,678)"></div>
                </th>
                
                 <!-- Mill Skills th -->
                
                
                <th align="center" style=" background-color:#FFFFFF;" title="MS=<%=rsMilstatus ("milskillstatus")%>,Fitness=<%=rsMilstatus ("fitnessStatus")%>">     
                    <div class="statusIcon" style="background-color:<%=strMScolour%>" ></div>
                </th>
                
                 <!--<th align="center" style=" background-color:#FFFFFF;" title="MS=<%'=rsMilstatus ("milskillstatus")%>,Vacs=<%'=rsMilstatus ("vacStatus")%>,Fitness=<%'=rsMilstatus ("fitnessStatus")%>,Dental=<%'=rsMilstatus ("dentalStatus")%>">     
                    <div class="statusIcon" style="background-color:<%'=strMScolour%>" ></div>
                </th>-->
                
                
                <!-- Each daily td -->
                
				<% counter = 1
				datecount = 0    
				occurences = rsBusyDates.recordCount - 1
				do while counter <= daysCount                     
				tempDate = counter & " " & newMonthYear
				if cdate(formatdatetime(tempDate,2)) >= cdate(formatdatetime(rsBusyDates("startDate"),2)) and cdate(formatdatetime(tempDate,2)) <=  cdate(formatdatetime(rsBusyDates("endDate"),2)) then %>
				<td align="center" title="<%=rsBusyDates("Description")%>" bgcolor="<%=rsBusyDates("taskcolor")%>" style="cursor:pointer;"
				onclick="javascript:ajaxFunction('manningGetStaffTaskInfoAjax.asp','staffTaskID=<%=rsBusyDates("taskStaffID")%>&strManager=<%=strManager%>','Task Details',0,0,420,400, 'ttID=<%=rsBusyDates("type")%>','RecID=<%=rsBusyDates("task")%>')">&nbsp;</td> 
				<% else %> 
				<td width="301" class="calendar" >&nbsp; </td> 
				<% end if               
				if datecount < occurences then                                 
					if formatdatetime(tempDate,2) = formatdatetime(rsBusyDates("endDate"),2) then 
						rsBusyDates.movenext 
						datecount = datecount + 1 
					end if 
				end if 
				counter = counter + 1 
				loop %>
                
                 <!-- Tasking Cal td -->
                
                <% if strManager=1 then %>
                    <td  align="center" style="cursor:pointer;"><img src="Images/itevent.gif" <%if rsRecSet("staffid")<>"" and strManager=1 then %>onclick="javascript:staffTask(<%=rsRecSet("staffid")%>);"<%end if%>></td>
                <% else %>
                    <td width="35px" align="center" ></td>
                <%end if%>
                
                
			  </tr>
			<% end if %>  
		
	   <% rsRecSet.movenext %>
	   <% loop %>
	</table>
</div>




<!--<Div id="CalenderImage" class="CalenderImageAll" style="top:244px;left:462px;">
	<Div onclick="javascript:InsertCalenderDate(cal,document.all.sDate);CloseCalender(CalenderImage);">
		<object classid="CLSID:8e27c92b-1264-101c-8a2f-040224009c02" id="cal">
			<param name="BackColor" value="-2147483633">
			<param name="Year" value="2015">
			<param name="Month" value="4">
			<param name="Day" value="23">
			<param name="DayLength" value="1">
			<param name="MonthLength" value="1">
			<param name="DayFontColor" value="0">
			<param name="FirstDay" value="1">
			<param name="GridCellEffect" value="1">
			<param name="GridFontColor" value="10485760">
			<param name="GridLinesColor" value="-2147483632">
			<param name="ShowDateSelectors" value="-1">
			<param name="ShowDays" value="-1">
			<param name="ShowHorizontalGrid" value="-1">
			<param name="ShowTitle" value="-1">
			<param name="ShowVerticalGrid" value="-1">
			<param name="TitleFontColor" value="10485760">
			<param name="ValueIsNull" value="0">
		</object>
	</Div>
	<Div align="center"><Input class="StandardButton" Type="Button" Value="Cancel" onclick="javascript:CloseCalender(CalenderImage);"></Div>
</Div>

<Div id="CalenderImage2" class="CalenderImageAll" style="top:244px;left:572px;">
	<Div onclick="javascript:InsertCalenderDate(calEndDate,document.all.eDate);CloseCalender(CalenderImage2);">
		<object  classid="CLSID:8e27c92b-1264-101c-8a2f-040224009c02" id="calEndDate">
			<param name="BackColor" value="-2147483633">
			<param name="Year" value="2015">
			<param name="Month" value="4">
			<param name="Day" value="23">
			<param name="DayLength" value="1">
			<param name="MonthLength" value="1">
			<param name="DayFontColor" value="0">
			<param name="FirstDay" value="1">
			<param name="GridCellEffect" value="1">
			<param name="GridFontColor" value="10485760">
			<param name="GridLinesColor" value="-2147483632">
			<param name="ShowDateSelectors" value="-1">
			<param name="ShowDays" value="-1">
			<param name="ShowHorizontalGrid" value="-1">
			<param name="ShowTitle" value="-1">
			<param name="ShowVerticalGrid" value="-1">
			<param name="TitleFontColor" value="10485760">
			<param name="ValueIsNull" value="0">
		</object>
  </Div>
	<Div align="center"><Input class="StandardButton" Type="Button" Value="Cancel" onclick="javascript:CloseCalender(CalenderImage2);"></Div>
</Div>-->






<%
windowWidth=200
windowHeight=200%>

<Div id="detailWindow" style="background-color:#f4f4f4;visibility:hidden;">
    <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
        <tr class="SectionHeader">
            <td>
                <div id="detailWindowTitleBar" style="position:relative;left:7px;top:0px;width:100%;border-color:#7f9db9;"> 
                    <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
                        <tr> 
                            <td id="windowName" class="itemfont"></td>
                            <td align="right" ><img src="images/windowCloseIcon.png" style="cursor:pointer;" onClick="javascript:closeThisWindow('detailWindow');"></td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td class="titlearealine" height="1"><img height="1" src="Images/blank.gif"></td> 
        </tr>            
        <tr>
            <td align="left" class="itemfont">
                <div id="innerDetailWindow" style="Overflow:auto;background-color:#f4f4f4;color:#000000;position:relative;height:100%;width:100%"> 
                    <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
                        <tr class="itemfont"> 
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
</Div>

<Div id="TaskList" name="TaskList">
    <table style="width:280px;">			
        <tr class="SectionHeader">
            <td id="windowName" class="itemfont">Choose a Task Type:</td>
            <td align="right" style="padding-right:5px;" ><img src="images/windowCloseIcon.png" style="cursor:pointer;" onClick="document.getElementById('TaskList').style.visibility='hidden';"></td>
        </tr>
        <%tempSection = 0%>
        <%do while not rsTaskTypes.eof%>
		<%if tempSection <> rsTaskTypes("section") then%>
        <tr>
            <td class="titlearealine" colspan="2"  height="1"></td> 
        </tr>
        <%end if%>
        <%tempSection = rsTaskTypes("section")%>
        <tr style="cursor:pointer;" id="<%=rsTaskTypes("Description")%>" name=id="<%=rsTaskTypes("Description")%>" class="itemfont" height="25px" onMouseOver="taskItemOver(this);" onMouseOut="taskItemOut(this);">
           <td colspan="2" onclick="gotoTask('<%=rsTaskTypes("ttID")%>','<%=rsTaskTypes("Description")%>')"><%=rsTaskTypes("Description")%></td>
        </tr>
        <%rsTaskTypes.movenext
        loop%>
    </table>
</Div>


<!--<Div id="detailWindow" class="windowBorderArea" style="background-color:#f4f4f4;visibility:hidden;">
    <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
        <tr class="SectionHeader">
            <td>
                <DIV id="detailWindowTitleBar" style="position:relative;left:7px;top:0px;width:100%;border-color:#7f9db9;"> 
                    <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
                        <tr> 
                            <td id="windowName" class="itemfont"></td>
                            <td align="right" ><img src="images/windowCloseIcon.png" onClick="javascript:closeThisWindow('detailWindow');"></td>
                        </tr>
                    </table>
                </Div>
            </td>
        </tr>
        <tr>
            <td class="titlearealine" height="1"><img height="1" src="Images/blank.gif"></td> 
        </tr>            
        <tr>
            <td align="left" class="itemfont">
                <Div id="innerDetailWindow" style="Overflow:auto;background-color:#f4f4f4;color:#000000;position:relative;height:100%;width:100%"> 
                    <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
                        <tr class="itemfont"> 
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </Div>
            </td>
        </tr>
    </table>
</Div>-->

<!--<div id="light" class="popup">
	<Div id="TaskList" name="TaskList">
		<table style="width:280px;">			
			<tr>
            	<td align="center" colspan=2 id="postNameForTasking"><a href="javascript:void(0)" onclick="document.getElementById('light').style.display='none';">Close</a></td>
			</tr>
			
			<%'tempSection = 0%>
            
			<%'do while not rsTaskTypes.eof%>
				<%'if tempSection <> rsTaskTypes("section") then%>
                    <tr>
                        <td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
                <%'end if%>
                <%'tempSection = rsTaskTypes("section")%>
                <tr style="cursor:hand;" id="<%'=rsTaskTypes("Description")%>" name=id="<%'=rsTaskTypes("Description")%>" class=itemfont height=25px onMouseOver="taskItemOver(this);" onMouseOut="taskItemOut(this);">
                   <td onclick="gotoTask('<%'=rsTaskTypes("ttID")%>','<%'=rsTaskTypes("Description")%>')"><%'=rsTaskTypes("Description")%></td>
                </tr>
                <%'rsTaskTypes.movenext
			'loop%>
		</table>
	</Div>
</div>-->
<script language="JavaScript" type="text/javascript" src="calendar.js"></script>
<script language="JavaScript" type="text/javascript" src="jquery-1.10.2.js"></script>
<script language="JavaScript">
function calendarTable() {
    $("#caltable").delegate('td', 'mouseover mouseleave', function (e) {
        if (e.type == 'mouseover') {
            $(this).parent().addClass("rowhover");
            $("colgroup").eq($(this).index()).addClass("colhover");
        }
        else {
            $(this).parent().removeClass("rowhover");
            $("colgroup").eq($(this).index()).removeClass("colhover");
        }
    });
}
</script>


<script language="JavaScript" type="text/javascript">

window.onscroll = function(){
	var doc = document.documentElement;
	var leftScroll = (window.pageXOffset || doc.scrollLeft) - (doc.clientLeft || 0);
	document.getElementById('plannerHeader').style.left = 0 - leftScroll+'px';
};


var win = null;
var homeString ='javascript:refreshIframeAfterDateSelect("HierarchyTaskingView.asp");';

if(window.parent.frmDetails){
	var thisDate = window.parent.frmDetails.startDate.value;
	window.parent.frmDetails.thisIframe.value="HierarchyTaskingView.asp";
	window.parent.crumbTrail.innerHTML="<A href='index.asp' class=itemfontlinksmall >Home</A> > Personnel > <font class='youAreHere' >Unit Planner</font>";
}


var previousPostObject = new Object();
var tempObject = new Object();
var firstClick = 1;

var previousBGColor = '';
var previousFGColor = '';

function staffTask(staffID){
	document.frmTeamPlan.staffID.value = staffID;
	var TaskList = document.getElementById('TaskList');	
	TaskList.style.visibility="Visible";		
	TaskList.style.top = (document.body.parentNode.scrollTop+80)+'px';
	TaskList.style.left = (document.body.parentNode.scrollLeft)+'px';
}

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

function postItemOnclick(thisObject,postID,serviceNo)
{
	  //alert("Into Post Click " + thisObject + " * " + postID + " * " + serviceNo);
	  return;
	if(firstClick == 0)
	{
		previousPostObject.style.backgroundColor = previousBGColor;
		previousPostObject.style.color = previousFGColor;
	}
	var frmTeamPlan = document.getElementById('frmTeamPlan');
	frmTeamPlan.postID.value = postID;
	frmTeamPlan.serviceNo.value = serviceNo;
	firstClick = 0;
	previousBGColor = thisObject.style.backgroundColor;
	previousFGColor = thisObject.style.color;
	previousPostObject = thisObject;
	thisObject.style.backgroundColor = "#7a9ddc";
	thisObject.style.color = "#ffffff";
}

function checkDelete()
{
	var delOK = false ;
    
	var input_box = confirm("Are you sure you want to delete this Record?");
	if(input_box == true)
	{

		delOK = true;;
	}
	
	return delOK;
}

function showMenu(obj)
{
	var TaskList = document.getElementById('TaskList');	
	TaskList.style.visibility="Visible";		
	TaskList.style.top = (document.body.parentNode.scrollTop+80)+'px';
}

function MovetoPage(PageNo)
{
	document.forms["frmTeamPlan"].elements["Page"].value = PageNo;
	document.forms["frmTeamPlan"].submit();
}

function gotoTask(ttID,description)
{
	document.frmTeamPlan.ttID.value = ttID;
	document.frmTeamPlan.description.value = description;
	document.frmTeamPlan.action = "HierarchyTaskIndividual.asp";
	document.frmTeamPlan.submit();
	window.parent.startTimer()
}

function gotoNextMonth(hrcID)
{
	document.frmTeamPlan.thisDate.value = "<%=nextMonth%>"
	document.frmTeamPlan.action = "HierarchyTaskingView.asp?hrcID="+hrcID;
	document.frmTeamPlan.submit();
}

function gotoPreviousMonth(hrcID)
{
	document.frmTeamPlan.thisDate.value = "<%=previousMonth%>"
	document.frmTeamPlan.action = "HierarchyTaskingView.asp?hrcID="+hrcID;
	document.frmTeamPlan.submit();
}

function populateDetailsWindow(name,text,xPos,yPos,xHeight,xWidth)
{
	document.getElementById('windowName').innerHTML = name;
	document.getElementById('innerDetailWindow').innerHTML = text;
	
	
	var detailWindow = document.getElementById('detailWindow');
	detailWindow.style.visibility = "visible";
	detailWindow.style.width = xWidth + "px";

	//detailWindow.style.width = '400px';
	detailWindow.style.top = (document.body.parentNode.scrollTop+80)+'px';
	detailWindow.style.left = (document.body.parentNode.scrollLeft)+'px';
	//alert(document.getElementById('unitPlanner').scrollTop)
	
	//alert(document.body.parentNode.scrollTop)
	
	
	/*var detailWindow = document.getElementById('detailWindow');
	detailWindow.style.visibility = "visible";
	detailWindow.style.position = "absolute";
	detailWindow.style.left = xPos + "px";
	detailWindow.style.top = 0 + "px";
	detailWindow.style.height = xHeight + "px";
	detailWindow.style.width = xWidth + "px";
	detailWindow.style.zIndex = "100"*/
	//alert("Pos is " + xPos + " * " + yPos);
	
	document.getElementById('detailWindowTitleBar').style.width = xWidth - 16 + "px";
}

function closeThisWindow(thisWindow)
{
	document.getElementById(thisWindow).style.visibility = "hidden";
}

function ajaxFunction(ajaxFile,vars,name,xPos,yPos,xHeight,xWidth,type,task)
{
	//alert(ajaxFile + " * " + vars + " * " + type + " * " + task + " * "  + name + " * "  + " * " + xPos + " * " + yPos + " * " + xHeight + " * " + xWidth)
	var ajaxRequest;  // The variable that makes Ajax possible!
	vars = encodeURI(vars + '&' + type + '&' + task);   
	try
	{
        // Opera 8.0+, Firefox, Safari
        ajaxRequest = new XMLHttpRequest();
    }
	catch(e)
	{
    	// Internet Explorer Browsers
        try
		{
        	ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
        }
		catch(e)
		{
        	try
			{
            	ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
            }
			catch(e)
			{
            	// Something went wrong
            	alert("Your browser broke!");
            	return false;
            }
        }
    }
	
	xPos = (screen.width - xWidth) / 2 - 250
	yPos = (screen.height - xHeight) / 2 - 200 
	
    // Create a function that will receive data sent from the server
	ajaxRequest.onreadystatechange = function(){
	if(ajaxRequest.readyState == 4)
	{
		//alert("window is " + name + " * " + ajaxRequest.responseText + " * " + screen.height + " * " + xPos + " * " + yPos + " * " + xHeight + " * " + xWidth)
		populateDetailsWindow(name,ajaxRequest.responseText,xPos,yPos,xHeight,xWidth);
	}
}
    ajaxRequest.open("POST", ajaxFile, true);
    ajaxRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    ajaxRequest.send(vars); 
}

function launchReportWindowExcel(){
	//alert(1)
	if(win){
		win.close();
	}
		//alert(2)
	document.getElementById('frmTeamPlan').action = "HierarchyTeamTaskingOverviewtoExcel.asp?recId=<%=intHrc%>&thisDate=<%=request("thisDate")%>&allTeams=<%=request("allTeams")%>";
	//alert(3 + " " + <%=intHrc%>)
	
	document.frmTeamPlan.submit();
}


function showCounter(counter)
{
	alert(counter);
}

function CalenderScript(CalImg)
{
	CalImg.style.visibility = "Visible";	 
}
	 
function CloseCalender(CalImg)
{
	CalImg.style.visibility = "Hidden"; 
}

function InsertCalenderDate(Calender,SelectedDate)
{
	str = Calender.value
	document.forms["frmTeamPlan"].elements["HiddenDate"].value = str
	whole = document.forms["frmTeamPlan"].elements["HiddenDate"].value
	day = document.forms["frmTeamPlan"].elements["HiddenDate"].value.substring (8,10)
	day.replace (" ","")
	month = document.forms["frmTeamPlan"].elements["HiddenDate"].value.substring (4,7)
	strlength = document.forms["frmTeamPlan"].elements["HiddenDate"].value.length
	year = document.forms["frmTeamPlan"].elements["HiddenDate"].value.substring (strlength-4,strlength)
	SelectedDate.value = day + " " + month + " " + year;
}

function resetDates()
{
	document.frmTeamPlan.startDate.value='';
	document.frmTeamPlan.endDate.value='';
}

function Update(vars,type,task)

 // alert("Here we are " + vars + " * " + type + " * " + task);
{
	ajaxFunction('manningGetStaffTaskInfoAjaxUpdate.asp',vars,'Task Details',0,0,420,400,type,task);
}

/**
function Update(vars,type,task)
{
	ajaxFunction('manningGetStaffTaskInfoAjaxUpdate.asp',vars,type,task,'Task Details',0,0,420,400);
}
**/

function UpdateIndividual(type,task,id)
{
	//alert("Update Task " + type + " * " + task + " * " + serno + " * " + id)
	var sd = document.getElementById('startDate').value;
	var ed = document.getElementById('endDate').value;
	
	var sDate = parseInt(sd.split("/")[2] + sd.split("/")[1] + sd.split("/")[0])
	var eDate = parseInt(ed.split("/")[2] + ed.split("/")[1] + ed.split("/")[0])
	
	if(document.frmDetails.endDate.value =="" || document.frmDetails.startDate.value =="")
	{
		alert("Completed date fields");
		return
	}
	
	if(sDate > eDate)
	{
		alert("Start date can not be later than end date")
		document.getElementById('startDate').value = "";
		document.getElementById('endDate').value = "";
		return
	}
	
	//alert("Update Staff Task");
	
	document.frmDetails.action = "UpdateTaskIndividual.asp?ttID="+type+"&RecID="+task+"&id="+id+"&flag=1";
	document.frmDetails.submit();
}

function gotoPostDetails(postID, hrcID)
{
	//alert(staffID)
	document.frmTeamPlan.action="HierarchyPostDetail.asp?postID="+postID+"&hrcID="+hrcID;
	//document.frmTeamPlan.action="HierarchyTeamPostDetail.asp?postID="+postID;
	//document.frmDetails.postID.value=postID;
	//alert(document.frmDetails.action);
	document.frmTeamPlan.submit();
	//window.parent.startTimer()
}

function gotoStaffDetails(staffID,postID)
{
	document.frmTeamPlan.action="HierarchyPersDetail.asp?staffID="+staffID+"&postID="+postID;
	//document.frmTeamPlan.staffID.value=staffID;
	//document.frmTeamPlan.postID.value=postID;     //added 20070727 to make sure postID gets passed
	document.frmTeamPlan.submit();
	window.parent.startTimer()
}

function elemPosition(elem){
	
	var parentNodeObj = "";
	var elemLeft = 0;
	var elemTop = 0;
	var elemRight = 0;
	var elemBottom = 0;
	if(typeof(elem) == "object"){
		//This is an object
		parentNodeObj = elem;
		parentNodeObj2 = elem;		
	} 
	else if(typeof(elem) == "string"){
		//This is a string so assume id
		parentNodeObj = document.getElementById(elem);
		parentNodeObj2 = document.getElementById(elem);
	}
	while (parentNodeObj){
		elemLeft += parentNodeObj.offsetLeft;
		elemTop += parentNodeObj.offsetTop;
		parentNodeObj = parentNodeObj.offsetParent;
	}
	elemRight = elemLeft + parentNodeObj2.offsetWidth;
	elemBottom = elemTop + parentNodeObj2.offsetHeight;	
	return{
		top:elemTop,
		right:elemRight,
		bottom:elemBottom,
		left:elemLeft		
	};
}

</script>

<% if int (request("fromSearch"))>0 then %>
	<SCRIPT LANGUAGE="JavaScript" type="text/javascript">
		var passObject = new Object();
		//postItemOnclick(document.getElementById('<%'=temppostID%>'),'<%'=temppostID%>','<%'=tempstaffPostID%>','<%'=tempserviceno%>');
    </Script>
<% end if %>
<% 'if int(request("persSearch"))=1 then response.redirect("HierarchyPersonnelSearch.asp") %>
</body>
</html>