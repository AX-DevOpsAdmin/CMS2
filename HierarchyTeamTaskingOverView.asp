<!DOCTYPE HTML>
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%
squareSize=25
tab=2


'teamID=request("recID")

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
splitNum = int(splitDate(1) - 1)
theMonth = splitMonth(splitNum)

newTodaydate = formatdatetime(date(),2)

'if Session("openfield") = "" or request("openfield") <> "" then
'	Session("openfield") = request("openfield")
'end if

if request ("thisDate") <>"" then
	thisDate = request ("thisDate")
else
	thisDate = newTodaydate
End if

previousMonth = DateAdd("m",-1,thisDate)
nextMonth = DateAdd("m",1,thisDate)

manipulateDate=formatdatetime(thisDate,2)

splitDate = split (manipulateDate,"/")
newMonthYear= splitDate(1)+ "/" + splitDate(2)

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

strTable = "tblTeam"    
'strGoTo = request("fromPage")    
strTabID = "teamID"                      

strCommand = "spListTaskTypes"
objCmd.CommandText = strCommand
set rsTType = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

objCmd.CommandText = "spTeamStaff"	
set objPara = objCmd.CreateParameter ("TeamID",3,1,5, teamID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("allTeams",3,1,5, int(allTeams))
objCmd.Parameters.Append objPara

set objPara = objCmd.CreateParameter ("thisDate",200,1,16, thisDate)
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

'response.Write(teamID & " * " & intHrc)

' make sure we set the levelID to EITHER the parent if its Wing/Sqn/Flt or if its a TEAM then the actual teamID
tmLevel = rsRecSet("teamIn")
IF tmLevel < 4 THEN
  tmLevelID = rsRecSet("ParentID")
ELSE
  tmLevelID = teamID
END IF

objCmd.CommandText = "spUnitTaskDetails"
objCmd.CommandType = 4

set objPara = objCmd.CreateParameter ("startDate",200,1,30, startOfMonth)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("endDate",200,1,30,endOfMonth)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("teamID",3,1,0,teamID)
objCmd.Parameters.Append objPara
set rsBusyDates = objCmd.Execute

intCount = rsBusyDates.recordcount

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next
  
function convertDate (oldDate)
	todayDate = formatdatetime(oldDate,2)
	splitDate = split (todayDate,"/")
	
	splitNum = int(splitDate(1) - 1)
	theMonth = splitMonth(splitNum)
	
	newDate= splitDate(0) + " " + theMonth + " " + splitDate(2) 
	response.write newDate
end function

%>
<html>
<head>

<title>Team Hierarchy</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<!--[if IE 8]><link rel="stylesheet" type="text/css" href="Includes/IE.css" media="Screen"/><![endif]-->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/javascript" src="calendar.js"></script>
<script type="text/javascript" src="jquery-1.10.2.js"></script>
<style>
body {width:99%; margin:0; padding:0; border:0; line-height:1;} 

</style>
<script>
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
</head>
<body >

<form action="" method="GET" name="frmTeamPlan" id="frmTeamPlan">
    <Input id="thisDate" name="thisDate" type="hidden" value="<%=thisDate%>">
    <input id="recID" name="recID" type="hidden" value="<%=request("recID")%>">
    <input id="allTeams" name="allTeams" type="hidden" value="<%=request("allTeams")%>">
    <input id="HiddenDate" name="HiddenDate" type="hidden" >
</form>

<!-- This div contains the Planner menu and dates in a fixed position -->
<div id="plannerHeader">
    <!-- This div contains the team breadcrumb (without hyperlinks) and the export option-->
    <div class="plannerSubHeader">	
        <!--#include file="Includes/hierarchyTeamDetails.asp"-->
        <p style="padding:5px;">Unit:
            <%=rsRecSet("ParentDescription")%> > <font  class="youAreHere"><%=rsRecSet("Description")%></font>
            <a class=itemfontlink href="javascript:launchReportWindowExcel ();">
                <img src="images/excel.gif" width="18" height="18" class="imagelink">
            </a>
            <a class=itemfontlink href="javascript:launchReportWindowExcel ();">
                Export Calender To Excel
            </a>
        </p>			 	
    </div>    
    
    <!-- This div contains the Calender month navigation -->
    <div class="plannerCal">
        <A href="javascript:gotoPreviousMonth();" class=itemfontlinksmall >Previous Month</A> 
        &nbsp;|&nbsp;
        <b><font class="youAreHere">&nbsp;<%=(newMonthYear)%>&nbsp;</font></b>
        &nbsp;|&nbsp;
        <A href="javascript:gotoNextMonth();" class=itemfontlinksmall >Next Month</A> 
    </div>
    
<!-- This div contains the Calender Day header -->
<div>
        <table class="tableCal" border="0" cellpadding="0" cellspacing="1">
         <th></th> 	        
            <% counter=1 %>
                <% do while counter <= daysCount %> 
                    <% tempDate = counter & " " & newMonthYear %>
                    <% if formatdatetime(tempDate,2) = formatdatetime(thisDate,2) then %>
                        <% strBGC = "#000000" %>
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
            </tr>
        </table>
    </div>   
</div> 
<!-- Close Planner Div-->        

<% counter = 0 %>

<!-- This div contains the Unit and Team Planner --> 
<div class="unitPlanner">
<% if session("pla") <> 1 then %>	
   <!-- This table contains the Unit Planner -->
	<table class="tableCal" border="0" cellpadding="0" cellspacing="1">
    <colgroup>
    	<col span="2" class="firstcolspan">
    </colgroup>
		<% if rsBusyDates.eof then %>
		<tr>
       		<th>UNIT PLANNER</th>
			<% counter=1 %>
			<% do while counter<=daysCount %>
			<td class="calendar" >&nbsp;</td>
				<% counter = counter + 1  %>
			<% loop %>
			
		</tr>
		
		<% else 
		do while not rsBusyDates.eof %>
		<tr>
			<th><%=rsBusyDates("Description")%></th>
			<% counter = 1 %>
			<% datecount = 0 %>     
			<% occurences = rsBusyDates.recordCount %>
			<% do while counter <= daysCount %>                        
			<td align="center"
				<% tempDate = counter & "/" & newMonthYear                                    
				if cdate(formatdatetime(tempDate,2)) >= cdate(formatdatetime(rsBusyDates("startDate"),2)) and cdate(formatdatetime(tempDate,2)) <= cdate(formatdatetime(rsBusyDates("endDate"),2)) then %>
					bgcolor="<%=rsBusyDates("taskcolor")%>"
				<% else %>
					class="calendar"
				<% end if %>>
   
			</td>
				<% counter = counter + 1 %>
			<% loop %>
							
		</tr>
		<% rsBusyDates.movenext %>
		<% loop %>
		<% end if %>
	</table>
<%end if 
set rsRecSet = rsRecSet.nextrecordset%>           
	<!-- This table contains the Team Planner -->
	<table class="tableCal" border="0" cellpadding="0" cellspacing="1" >
		<% do while not rsRecSet.eof %>                
		<% objCmd.CommandText = "spStaffTaskDetails" %>
		<% objCmd.CommandType = 4 %>
		<% set objPara = objCmd.CreateParameter ("startDate",200,1,30, startOfMonth) %>
		<% objCmd.Parameters.Append objPara %>
		<% set objPara = objCmd.CreateParameter ("endDate",200,1,30,endOfMonth) %>
		<% objCmd.Parameters.Append objPara %>
		<% set objPara = objCmd.CreateParameter ("staffID",3,1,0,rsRecSet("staffID")) %>
		<% objCmd.Parameters.Append objPara %>
		
		<% set rsBusyDates = objCmd.Execute %>
		
		<% for x = 1 to objCmd.parameters.count %>
			<% objCmd.parameters.delete(0) %>
		<% next %>
	
		<% if rsBusyDates.recordcount < 1 then %>
		<tr>
			<th><%=rsRecSet("Surname")%>,&nbsp;<%=rsRecSet("shortdesc")%></th>
			<% counter=1 %>
			<% do while counter<=daysCount %>
			<td class="calendar" >&nbsp;</td>
			<% counter = counter + 1 %>
			<% loop %>
		</tr>
		<%else%>
		<tr>
			<th><%=rsRecSet("Surname")%>,&nbsp;<%=rsRecSet("shortdesc")%></th>
			<% counter = 1
			datecount = 0    
			occurences = rsBusyDates.recordCount - 1
			do while counter <= daysCount                     
			tempDate = counter & " " & newMonthYear
			if cdate(formatdatetime(tempDate,2)) >= cdate(formatdatetime(rsBusyDates("startDate"),2)) and cdate(formatdatetime(tempDate,2)) <=  cdate(formatdatetime(rsBusyDates("endDate"),2)) then %>
			<td align="center" title="<%=rsBusyDates("Description")%>" bgcolor="<%=rsBusyDates("taskcolor")%>"
            onclick="javascript:ajaxFunction('manningGetStaffTaskInfoAjax.asp','staffTaskID=<%=rsBusyDates("taskStaffID")%>','ttID=<%=rsBusyDates("type")%>','RecID=<%=rsBusyDates("task")%>','Task Details',0,0,420,400)">&nbsp;</td> 
			<% else %> 
			<td class="calendar" >&nbsp; </td> 
			<% end if               
			if datecount < occurences then                                 
				if formatdatetime(tempDate,2) = formatdatetime(rsBusyDates("endDate"),2) then 
					rsBusyDates.movenext 
					datecount = datecount + 1 
				end if 
			end if 
			counter = counter + 1 
			loop %>
							
		</tr>
		<% end if %>  
		
	<% rsRecSet.movenext %>
	<% loop %>
	</table>
</div>
	  
<Div id="CalenderImage" class="CalenderImageAll" style="top:244px;left:462px;">
	<Div onclick="javascript:InsertCalenderDate(cal,document.all.sDate);CloseCalender(CalenderImage);">
		<object  classid="CLSID:8e27c92b-1264-101c-8a2f-040224009c02" id="cal">
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
</Div>

<%
windowWidth=200
windowHeight=200%>
<Div id="detailWindow" class="windowBorderArea" style="background-color:#f4f4f4;visibility:hidden;">
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
</Div>

<!--<script src="jquery-1.10.2.js"></script>-->

<script type="text/javascript">

window.onscroll = function(){
	var doc = document.documentElement;
	var leftScroll = (window.pageXOffset || doc.scrollLeft) - (doc.clientLeft || 0);
	document.getElementById('plannerHeader').style.left = 0 - leftScroll+'px';
};



// Vanilla Javascript scroll fixed div on y axis not x.
/*window.onscroll = function(){
	var doc = document.documentElement;
	var leftScroll = (window.pageXOffset || doc.scrollLeft) - (doc.clientLeft || 0);
	document.getElementById('plannerHeader').style.left = 0 - leftScroll+'px';
};*/

// JQuery scroll fixed div on y axis not x.
/*$(window).scroll(function(){
	alert()
	var leftScroll = $(document).scrollLeft();
		alert(leftScroll)
	$('#plannerHeader').css({'left':-leftScroll});
});*/

var win = null;
var homeString ='javascript:refreshIframeAfterDateSelect("ManningTeamPersonnel.asp");';

if(window.parent.frmDetails){
	var thisDate = window.parent.frmDetails.startDate.value;
	window.parent.frmDetails.thisIframe.value="HierarchyTeamTaskingOverView.asp";
	window.parent.crumbTrail.innerHTML="<A href='index.asp' class=itemfontlinksmall >Home</A> > Personnel > <font class='youAreHere' >Team Planner</font>";
}




/*function showMenu(postName){
	document.getElementById('postNameForTasking').innerHTML = postName;
	var taskListState = document.getElementById('TaskList').style.visibility;
	document.getElementById('TaskList').style.visibility = "Visible";
	var justOpened = 1;
	return false;
}*/

var previousPostObject = new Object();
var tempObject = new Object();
var firstClick = 1;

var previousBGColor = '';
var previousFGColor = '';

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

/*function checkPage()
{
	var taskList = document.getElementById('TaskList');
	taskListState = TaskList.style.visibility
	if(taskListState == "visible" && justOpened == 0)
	{
		TaskList.style.visibility = "Hidden";
	}
	
	justOpened = 0;
}
*/
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

function gotoNextMonth()
{
	document.frmTeamPlan.thisDate.value = "<%=nextMonth%>"
	document.frmTeamPlan.action = "HierarchyTeamTaskingOverView.asp";
	document.frmTeamPlan.submit();
}

function gotoPreviousMonth()
{
	document.frmTeamPlan.thisDate.value = "<%=previousMonth%>"
	document.frmTeamPlan.action = "HierarchyTeamTaskingOverView.asp";
	document.frmTeamPlan.submit();
}

function populateDetailsWindow(name,text,xPos,yPos,xHeight,xWidth)
{
	document.getElementById('windowName').innerHTML = name;
	document.getElementById('innerDetailWindow').innerHTML = text;
	var detailWindow = document.getElementById('detailWindow');
	detailWindow.style.visibility = "visible";
	detailWindow.style.position = "absolute";
	detailWindow.style.left = xPos;
	detailWindow.style.top = yPos;
	detailWindow.style.height = xHeight + "px";
	detailWindow.style.width = xWidth + "px";
	document.getElementById('detailWindowTitleBar').style.width = xWidth - 16 + "px";
}

function closeThisWindow(thisWindow)
{
	document.getElementById(thisWindow).style.visibility = "hidden";
}

function ajaxFunction(ajaxFile,vars,type,task,name,xPos,yPos,xHeight,xWidth){
	var ajaxRequest;  // The variable that makes Ajax possible!
	vars = encodeURI(vars + '&' + type + '&' + task);   
	try{
        // Opera 8.0+, Firefox, Safari
        ajaxRequest = new XMLHttpRequest();
    }
	catch(e){
    	// Internet Explorer Browsers
        try{
        	ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
        }
		catch(e){
        	try{
            	ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
            }
			catch(e){
            	// Something went wrong
            	alert("Your browser broke!");
            	return false;
            }
        }
    }
	
    // Create a function that will receive data sent from the server
	ajaxRequest.onreadystatechange = function(){
		if(ajaxRequest.readyState == 4){
			populateDetailsWindow(name,ajaxRequest.responseText,xPos,yPos,xHeight,xWidth);
		}
	}
    ajaxRequest.open("POST", ajaxFile, true);
    ajaxRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    ajaxRequest.send(vars); 
}

function launchReportWindowExcel(){
	if(win){
		win.close();
	}
	
	document.getElementById('frmTeamPlan').action = "HierarchyTeamTaskingOverviewtoExcel.asp?recId=<%=request("recID")%>&thisDate=<%=request("thisDate")%>&allTeams=<%=request("allTeams")%>";
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
{
	ajaxFunction('manningGetStaffTaskInfoAjaxUpdate.asp',vars,type,task,'Task Details',0,0,420,400);
}

function UpdateIndividual(type,task,serno,id)
{
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
	
	document.frmDetails.action = "UpdateTaskIndividual.asp?ttID="+type+"&RecID="+task+"&serviceNo="+serno+"&id="+id+"&flag=1";
	document.frmDetails.submit();
}


</script>

</body>
</html>

