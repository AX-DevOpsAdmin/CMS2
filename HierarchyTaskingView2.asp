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
' now check to see if they have manager rights for this team. 1 = Manager   0 = User
	if session("Administrator") = "1" then
		strManager = "1"
		session("Manager") = 1 
	elseif session("UserStatus")  = "1" then
		set objPara = objCmd.CreateParameter ("hrcID",3,1,5,intHrc)
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

<title>Team Hierarchy</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
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

<form action="" method="POST" name="frmTeamPlan" id="frmTeamPlan">
    <Input id="thisDate" name="thisDate" type="hidden" value="<%=thisDate%>">
    <input id="recID" name="recID" type="hidden" value="<%=request("recID")%>">
    <input id="allTeams" name="allTeams" type="hidden" value="<%=request("allTeams")%>">
    <input id="HiddenDate" name="HiddenDate" type="hidden" >
</form>

<!-- This div contains the Planner menu and dates in a fixed position -->
<div id="plannerHeader">
    <!-- This div contains the team breadcrumb (without hyperlinks) and the export option-->
    <div class="plannerSubHeader">	
        <!--#include file="Includes/optMenu.inc"-->
        <!--#include file="Includes/hierarchyTeamDetails.asp"-->
        <p style="padding:5px;">You are here ...
            <%=rsRecSet("crumbtrail")%> <font  class="youAreHere">&nbsp;&nbsp; </font>
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
        <table class="tableCal" border="0" cellpadding="0" cellspacing="1" width="100%">
          <tr>
             <th style="width:auto;" ></th>
             <th style="width:auto;"></th>
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
<% set rsRecSet = rsRecSet.nextrecordset %>           
	<!-- This table contains the Team Planner -->
	<table class="tableCal" border="0" cellpadding="0" cellspacing="1" >
		<% 
		  do while not rsRecSet.eof 
		        ' Get Qs and Mil Status Red/Green/Amber  - if there are any
				if rsRecSet("QTotal") > 0 then
					objCmd.CommandText = "spGetStaffQTotal"	
					objCmd.CommandType = 4				
					
					set objPara = objCmd.CreateParameter ("staffID",3,1,5, rsRecSet("staffID"))
					objCmd.Parameters.Append objPara
					set objPara = objCmd.CreateParameter ("postID",3,1,5, rsRecSet("postID"))
					objCmd.Parameters.Append objPara
					set objPara = objCmd.CreateParameter ("thisDate",200,1,16, thisDate)
					objCmd.Parameters.Append objPara
					set rsStaffQTotal = objCmd.Execute	

					percentage = (rsStaffQTotal("staffQTotal")/rsRecSet("QTotal"))*100
					
					for x = 1 to objCmd.parameters.count
						objCmd.parameters.delete(0)
					next
                else
				    percentage=999
					strQpcnt= "No Qs against post"
      			    strQcolour = "#FFF"
				end if
				
				if percentage <> 999 then 
				   strQpcnt= "Q's are " & cint(percentage)&"%" & " of Post Q's"
				   
				   if percentage >75 then
						strQcolour= "#00ff00"
				   else
				     if percentage > 50 then
			           strQcolour="#ffff00"
				     else
				       if percentage > 25 then
			             strQcolour="#ffcc00"
				       else
				         strQcolour="#ff0000"
				       end if
					 end if
				   end if
			    end if
				
				'response.write percentage & " * " & strQcolour & " * " & rsRecSet("personnel")
				
				objCmd.CommandText = "spGetMilStatus"	
				objCmd.CommandType = 4				
				
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
   				   strMScolour="#ffcc00"
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
				<th style="width:auto;" <% if strManager=1 then %> onmouseover="selected(this.firstChild);" onmouseout="deselected(this.firstChild);"<% end if %>>
                  
				   <% if strManager=1 then %>
                      <div id="post-<%=rsRecset("postID")%>" style="border:none;" onmouseout="deselected(this);" >
                         <a onclick="document.getElementById('optMenu').style.display = 'none'; showOptMenu(this.parentNode);" style="float:left; padding-left:3px; white-space:nowrap; overflow:hidden">
                          <%=rsRecSet("assignno")%>
                         </a>
                         <div onclick="showOptMenu(this.parentNode);">
                            <img src="images/dropdown.gif" style="display:none;float:right; width:13px;cursor:hand; margin-right:-2px;"/>
                         </div>
                      </div>
                   <%else
				     rsRecSet("assignno")
				   end if  %>
                </th>
				<th style="width:auto;<%=mgr%>"><img class="imagelink" src="images/info.gif" title="Click here for further details" onClick="javascript:ajaxFunction('manningGetPersonnelInfoAjax.asp','staffID=<%=rsRecSet("staffID")%>','Personnel Details',100,100,250,600)" >&nbsp;<%=rsRecSet("personnel")%></th>
                <!--<th style="height:15px; width:15px; background-image:url(images/statusRound.gif); background-color:<%'=strcolour%>"></th>-->
                 <th align="center" title="<%=strQpcnt%>">     
                    <div class="statusIcon" style="background-color:<%=strQcolour%>" ></div>
                </th>
                <th align="center" title="MS=<%=rsMilstatus ("milskillstatus")%>,Vacs=<%=rsMilstatus ("vacStatus")%>,Fitness=<%=rsMilstatus ("fitnessStatus")%>,Dental=<%=rsMilstatus ("dentalStatus")%>">     
                    <div class="statusIcon" style="background-color:<%=strMScolour%>" ></div>
                </th>
                                
				<% counter=1 %>
				<% do while counter<=daysCount %>
				<td width="497" class="calendar" >&nbsp;</td>
				<% counter = counter + 1 %>
				<% loop %>
			  </tr>
			<%else%>
			  <tr>
				<th style="width:auto;"><% if strManager=1 then %><A class=itemfontlink href="javascript:gotoPostDetails(<%=rsRecSet("postID")%>);" ><% end if %><%=rsRecSet("Assignno")%></th>
				<th style="width:auto;<%=mgr%>"><img class="imagelink" src="images/info.gif" title="Click here for further details" onClick="javascript:ajaxFunction('manningGetPersonnelInfoAjax.asp','staffID=<%=rsRecSet("staffID")%>','Personnel Details',100,100,250,600)" >&nbsp;<%=rsRecSet("personnel")%></th>
                <th align="center" title="<%=strQpcnt%>">     
                    <div class="statusIcon" style="background-color:<%=strQcolour%>"></div>
                </th>
                <th align="center" title="MS=<%=rsMilstatus ("milskillstatus")%>,Vacs=<%=rsMilstatus ("vacStatus")%>,Fitness=<%=rsMilstatus ("fitnessStatus")%>,Dental=<%=rsMilstatus ("dentalStatus")%>">     
                    <div class="statusIcon" style="background-color:<%=strMScolour%>" ></div>
                </th>
				<% counter = 1
				datecount = 0    
				occurences = rsBusyDates.recordCount - 1
				do while counter <= daysCount                     
				tempDate = counter & " " & newMonthYear
				if cdate(formatdatetime(tempDate,2)) >= cdate(formatdatetime(rsBusyDates("startDate"),2)) and cdate(formatdatetime(tempDate,2)) <=  cdate(formatdatetime(rsBusyDates("endDate"),2)) then %>
				<td align="center" title="<%=rsBusyDates("Description")%>" bgcolor="<%=rsBusyDates("taskcolor")%>"
				onclick="javascript:ajaxFunction('manningGetStaffTaskInfoAjax.asp','staffTaskID=<%=rsBusyDates("taskStaffID")%>','ttID=<%=rsBusyDates("type")%>','RecID=<%=rsBusyDates("task")%>','Task Details',0,0,420,400)">&nbsp;</td> 
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

//----------------Gets the Option drop down box for items and does the row over and out colour change----------------
function selected(div){
	
	
	if (document.getElementById("optMenu").style.display == 'none'){
		
		//alert("into selected 1");
		div.style.border = 'solid 1px;';
		div.style.borderColor = '#CCC';
		div.parentNode.style.paddingTop = '2px';
		div.parentNode.style.paddingBottom = '2px';
		div.parentNode.getElementsByTagName("IMG")[0].style.display = 'inline';	
	};
}

function deselected(div){
	if (document.getElementById("optMenu").style.display == 'none'){
		div.style.border = 'none';
		div.parentNode.style.paddingTop = '4px';
		div.parentNode.style.paddingBottom = '3px';
		div.parentNode.getElementsByTagName("IMG")[0].style.display = 'none';	
	};
}

function showOptMenu(div,sostat, cetstat){
	
	//alert("into optmenushow");
	
	var type = div.id.split("-")[0]
	if(div.parentNode.style.paddingTop == '2px'){
		
		//alert("div is " + div.id + " * " +  div.parentNode.id + " * " + div.style.width);
		
		document.getElementById("optMenu").style.left = elemPosition(div).left;
		document.getElementById("optMenu").style.top = elemPosition(div).top+18;
		
		document.getElementById("optMenu").style.width = div.style.width;
		tr = document.getElementById("optMenu").getElementsByTagName("DIV")
		
		//alert("Menu is " + tr[0] + " * " + tr[1] + tr[2] + " * " + tr[3] );
		
		//-----Sets up the functions for each button with the Unique ID from the selected item
		function view(){
			eval(type+"view(tr[0].id.split(',')[0],'filter',this.id.split(',')[1]);");
			deselected(div)
		};
		
		tr[0].onclick = view;
		
		function edit(){
			
		    //alert("edit this " + type +"edit" + tr[0].id.split(',')[0] + ", filter");
			
			eval(type+"edit(tr[0].id.split(',')[0],'filter');");
			deselected(div)
		};
		tr[3].onclick = edit;
		
		function copy(){
			
		    //alert("copy this " + type +"copy" + " * " + tr[0].id.split(',')[0] + ", filter");
			
			eval(type+"copy(tr[0].id.split(',')[0],'filter');");
			deselected(div)
		};
		tr[6].onclick = copy;

		function deleted(){
			eval("delete"+type+"(this.id.split(',')[0],this.id.split(',')[1]);");
			deselected(div)
		};
		tr[9].onclick = deleted;
		
		function cancel(){
			deselected(div)
		};
		tr[12].onclick = cancel;

		for (var x=0; x < tr.length;x++){
			tr[x].id = div.id+','+div.firstChild.innerHTML;
				// alert("ID is " + tr[x].id);
			
		};
		
		//if(type == 'user' || type == 'dept' || type == 'usrdept' || type == 'contype' || type == 'fundby'){
	    if(type != 'course' && type != 'company' && type != 'annxb' && type!= 'contract' && type != 'student' && type != 'sotrdetl'){
			tr[0].style.display = 'none';
		}
		
		// only allow Course to be copied
	    if(type != 'course' && type != 'sotrdetl'){
			tr[6].style.display = 'none';
		}

        //alert("SOTR Stat is " + test1);
		
        // SOTR has been submitted so don't allow Edit or Delete
        if (sostat==2 && cetstat != 1) {
			 tr[3].style.display = 'none';
			 tr[9].style.display = 'none';
		}
		else{
			tr[3].style.display = 'block';
			tr[9].style.display = 'block';
		}
		
		
		document.getElementById("optMenu").style.display = 'block';
		//-----Sets up the onClick event Handler to hide the box clicking anywhere on the page
		document.attachEvent("onmouseup",tester);
		
		function tester(){	
			if (document.getElementById("optMenu").style.display == 'block'){
				document.getElementById("optMenu").style.display = 'none';	
				deselected(div)
				document.detachEvent("onmouseup",tester);
			};
		};
	};
}

//-----------------This function will return the top and left positions of an element on a page. elem can by id or object

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

function gotoPostDetails(postID)
{
//alert(staffID)
document.frmTeamPlan.action="HierarchyPostDetail.asp?postID="+postID;
//document.frmTeamPlan.action="HierarchyTeamPostDetail.asp?postID="+postID;
//document.frmDetails.postID.value=postID;
//alert(document.frmDetails.action);
document.frmTeamPlan.submit();
window.parent.startTimer()
}


</script>

</body>
</html>

