<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%
squareSize=18
tab=2
hrcID = request("hrcID")

todayDate = formatdatetime(date(),2)
splitDate = split (todayDate,"/")

monthList = "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec"
splitMonth = split(monthList, ",")
splitNum = int(splitDate(1) - 1)
theMonth = splitMonth(splitNum)

newTodaydate = formatdatetime(date(),2)

if Session("openfield") = "" or request("openfield") <> "" then
	Session("openfield") = request("openfield")
end if

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

'response.write(thisDate)
'response.end()

strTable = "tblTeam"    
strGoTo = request("fromPage")    
strTabID = "hrcID"                      

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4		
objCmd.Activeconnection.cursorlocation = 3

strCommand = "spListTaskTypes"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara

set rsTType = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.CommandText = "spUnitTaskDetails"

set objPara = objCmd.CreateParameter ("startDate",200,1,30, startOfMonth)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("endDate",200,1,30,endOfMonth)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("hrcID",3,1,0, request("hrcID"))
objCmd.Parameters.Append objPara
set rsBusyDates = objCmd.Execute

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

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
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

<form  action="" method="GET" name="frmTeamPlan">
    <Input name="thisDate" id="thisDate" type="hidden" value="<%=thisDate%>">
    <input name="hrcID" id="hrcID" type="hidden" value="<%=request("hrcID")%>">
    <input name="HiddenDate" id="HiddenDate" type="hidden" >
    
<table width=100% border=0 cellpadding=0 cellspacing=0>
	<tr height=16 class=SectionHeaderPlain>
        <td colspan=1>
            <table align="center" border=0 cellpadding=0 cellspacing=0 >
                <tr class=toolbar>
                    <td class=toolbar width=8>&nbsp;</td>        
                    <td align="center" class=toolbar valign="middle" ><A href="javascript:gotoPreviousMonth();" class=itemfontlinksmall >Previous Month</A> |<b><u><font style=""class="youAreHere">&nbsp;<%=(newMonthYear)%>&nbsp;</font></u></b>| <A href="javascript:gotoNextMonth();" class=itemfontlinksmall >Next Month</A> </td>
                </tr>  
            </table>
        </td>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr height=10>
		<td colspan="3">&nbsp;</td>
	</tr>

	<% color1="#f4f4f4" %>
	<% color2="#fafafa" %>
	<% counter=0		%>
	
	<tr height=40%>
		<td valign=top>
			<table width=750px border=0 cellpadding=0 cellspacing=1>
				<tr class="columnheading" height="<%=squareSize%>px">
					<td width=150px valign="middle">&nbsp;</td>
					<% counter=1 %>
					<% do while counter <= daysCount %>
						<td width="<%=squareSize%>px" align="center"
						<% tempDate = counter & " " & newMonthYear %>
						<% if formatdatetime(tempDate,2) = formatdatetime(thisDate,2) then %>
                        	style="background-color:#000000;color:#dddddd"
						<% else %>
							<% if weekday(tempDate)=1 or weekday(tempDate)=7 then %>
                            	style="background-color:#888888;color:#000000"
							<% else %>
                            	style="background-color:#dddddd;color:#000000"
							<% end if %>
						<% end if %>><%=counter%></td>
                        <% counter=counter + 1 %>
	    			<% loop %>
					<td style="FONT-SIZE: 1pt;">&nbsp;</td>
				</tr>
			</table>
			<Div class="ScrollingAreaTasking">
                <table width=750px border=0 cellpadding=0 cellspacing=1>
                	<% if rsBusyDates.eof then %>
                        <tr class="teamPlanner" height=<%=squareSize%>px>
                            <td width=150px>&nbsp;&nbsp;</td>
                            <% counter=1 %>
                            <% do while counter<=daysCount %>
                                <td width="<%=squareSize%>px" align="center" class="SectionHeaderGreen" >&nbsp;</td>
                                <% counter = counter + 1 %>
                            <% loop %>
                            <td style="FONT-SIZE: 1pt;">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan=<%=daysCount+1%> class=titlearealine  height=1></td> 
                        </tr>
                    <% else %>
						<% do while not rsBusyDates.eof %>
                            <tr class="teamPlanner" height="<%=squareSize%>px">
                                <td width=150px>&nbsp;&nbsp;<%= rsBusyDates("Description") %></td>
                                <% counter = 1 %>
                                <% datecount = 0 %>     
                                <% occurences = rsBusyDates.recordCount %>
                                <% do while counter <= daysCount %>                        
                                    <td width="<%=squareSize%>px" align="center"
                                        <% tempDate = counter & "/" & newMonthYear %>                                   
                                        <% if cdate(formatdatetime(tempDate,2)) >= cdate(formatdatetime(rsBusyDates("startDate"),2)) and cdate(formatdatetime(tempDate,2)) <= cdate(formatdatetime(rsBusyDates("endDate"),2)) then %>
                                            bgcolor="<%=rsBusyDates("taskcolor")%>"
                                        <% else %>
                                        	class="SectionHeaderGreen"
                                        <% end if %>>
                                        <% if counter = 31 then %><% end if %>
                                    </td>
                                    <% counter = counter + 1 %>
                                <% loop %>
                                <td style="FONT-SIZE: 1pt;">&nbsp;</td>					
                            </tr>
                            <tr>
                                <td colspan=<%=daysCount+1%> class=titlearealine  height=1></td> 
                            </tr>
                        <% rsBusyDates.movenext %>
                        <% loop %>
                    <% end if %>
                </table>
			</Div>
            <table border=0 cellpadding=0 cellspacing=1>
                <tr class="columnheading" height="<%=squareSize%>px">
                    <td width=150px>&nbsp;</td>
                    <% counter = 1 %>
                    <% do while counter <= daysCount %>
                        <td width="<%=squareSize%>px" align="center" <% tempDate = counter & " " & newMonthYear %> <% if formatdatetime(tempDate,2) = formatdatetime(thisDate,2) then %> style="background-color:#000000;color:#dddddd" <% else %> <% if weekday(tempDate)=1 or weekday(tempDate)=7 then %> style="background-color:#888888;color:#000000" <% else %> style="background-color:#dddddd;color:#000000" <% end if %> <% end if %>><%=counter%></td>
                        <% counter = counter + 1 %>
                <% loop %>
                    <td style="FONT-SIZE: 1pt;">&nbsp;</td>
                </tr>
            </table>
		</td>
		<td valign=top style="background-color:#fafafa">
			<div>
                <table border=0 cellpadding=0 cellspacing=2 width=100%>
                    <tr>
                        <td class=itemfont colspan=20 align="center"><u>Key:</u></td>
                    </tr>			
                    <tr height=8px>
                        <td >&nbsp;</td>
                    </tr>			
                    <% do while not rsTType.eof %>
                        <tr class="columnheading" ID="TableRow<%=rsTType ("ttID")%>" height="<%=squareSize%>px">
                            <td>&nbsp;</td>
                            <td bgcolor="<%=rsTType("taskcolor")%>" width="<%=squareSize%>px">&nbsp;</td>
                            <td>&nbsp;</td>
                            <td><%=rsTType("description")%></td>
                        </tr>
                        <% rsTType.MoveNext %>
                <% loop %>
                    <tr class="columnheading" height="<%=squareSize%>px">                               
                        <td width="<%=squareSize%>px">&nbsp;</td>
                        <td>
                            <div class="borderArea">
                                <table border=0 cellpadding=0 cellspacing=0>
                                    <tr class="columnheading" height="<%=squareSize%>px">					
                                        <td class="calenderBrown" width="<%=squareSize%>px">&nbsp;</td>
                                    </tr>
                                </table>
                            </div>
                        </td>                
                        <td>&nbsp;</td>
                        <td>Posted</td>                
                    </tr>                           
				</table>
			</div>
		</td>		                
	</tr>
</table>

</form>
<Div id="CalenderImage" class="CalenderImageAll" style="top:244px;left:462px;">
	<Div  onclick="javascript:InsertCalenderDate(cal,document.all.sDate);CloseCalender(CalenderImage);">
		<object  classid="CLSID:8e27c92b-1264-101c-8a2f-040224009c02" id="cal"></object>
	</Div>
	<Div align="center"><Input CLASS="StandardButton" Type=Button Value=Cancel onclick="javascript:CloseCalender(CalenderImage);"></Div>
</Div>
<Div id="CalenderImage2" class="CalenderImageAll" style="top:244px;left:572px;">
	<Div  onclick="javascript:InsertCalenderDate(calEndDate,document.all.eDate);CloseCalender(CalenderImage2);">
		<object  classid="CLSID:8e27c92b-1264-101c-8a2f-040224009c02" id="calEndDate"></object>
  </Div>
	<Div align="center"><Input CLASS="StandardButton" Type=Button Value=Cancel onclick="javascript:CloseCalender(CalenderImage2);"></Div>
</Div>

<%
windowWidth=200
windowHeight=200%>
    <Div id=detailWindow class="windowBorderArea" style="background-color:#f4f4f4;visibility:hidden;">
        <table border=0 cellpadding=0 cellspacing=0 align=right width=100%>
            <tr class=SectionHeader>
                <td>
                    <DIV id=detailWindowTitleBar style="position:relative;left:7px;top:0px;width:100%;border-color:#7f9db9;"> 
                        <table border=0 cellpadding=0 cellspacing=0 align=right width=100%>
                            <tr> 
                                <td id="windowName" class=itemfont></td>
                                <td ALIGN=RIGHT><img src="images/windowCloseIcon.png" onClick="javascript:closeThisWindow(detailWindow);"></td>
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
                    <Div id=innerDetailWindow style="Overflow:auto;background-color:#f4f4f4;color:#000000;position:relative;height:100%;width:100%"> 
                        <table border=0 cellpadding=0 cellspacing=0 align=right width=100%>
                            <tr class=itemfont> 
                            	<td>&nbsp;</td>
                            </tr>
                        </table>
                    </Div>
                </td>
            </tr>
        </table>
</Div>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
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

function postItemOnclick(thisObject,postID,serviceNo)
{
	if(firstClick==0)
	{
		previousPostObject.style.backgroundColor = previousBGColor;
		previousPostObject.style.color = previousFGColor;
	}
	
	document.frmTeamPlan.postID.value=postID
	document.frmTeamPlan.serviceNo.value=serviceNo
	firstClick=0;
	previousBGColor = thisObject.style.backgroundColor;
	previousFGColor = thisObject.style.color;
	previousPostObject = thisObject;
	thisObject.style.backgroundColor = "#7a9ddc";
	thisObject.style.color = "#ffffff";
}

function checkPage()
{
	taskListState= document.getElementById('TaskList').style.visibility
	if(taskListState=="visible" && justOpened==0 )
	{
		 document.getElementById('TaskList').style.visibility="Hidden";
	}
	
	justOpened=0;
}

function checkDelete()
{
	var delOK = false 
    
	input_box = confirm("Are you sure you want to delete this Record ?")
	
	if(input_box==true)
	{
		delOK = true;
	}
	
    return delOK;
}

function MovetoPage (PageNo)
{
	document.forms["frmTeamPlan"].elements["Page"].value = PageNo;
	document.forms["frmTeamPlan"].submit();
}

function gotoTask(ttID,description)
{
	document.frmTeamPlan.ttID.value=ttID;
	document.frmTeamPlan.description.value=description;
	document.frmTeamPlan.action="HierarchyTaskIndividual.asp";
	document.frmTeamPlan.submit();
	window.parent.startTimer()
}

function gotoNextMonth()
{
	document.frmTeamPlan.thisDate.value="<%=nextMonth%>"
	document.frmTeamPlan.action="reportsUnitTaskingOverview.asp";
	document.frmTeamPlan.submit();
}

function gotoPreviousMonth()
{
	document.frmTeamPlan.thisDate.value="<%=previousMonth%>"
	document.frmTeamPlan.action="reportsUnitTaskingOverview.asp";
	document.frmTeamPlan.submit();
}

function populateDetailsWindow(name,text,xPos,yPos,xHeight,xWidth)
{
	document.getElementById('windowName').innerHTML=name;
	document.getElementById('innerDetailWindow').innerHTML=text;
	var detailWindow = document.getElementById('detailWindow');
	detailWindow.style.visibility = "visible";
	detailWindow.style.position = "absolute";
	detailWindow.style.left = xPos;
	detailWindow.style.top = yPos;
	detailWindow.style.height = xHeight + "px";
	detailWindow.style.width = xWidth + "px";
	document.getElementById('detailWindowTitleBar').style.width = xWidth - 16 + "px";
}

function closeThisWindow (thisWindow)
{
	thisWindow.style.visibility="hidden";
}

function ajaxFunction(ajaxFile,vars,type,task,name,xPos,yPos,xHeight,xWidth)
{
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


function launchReportWindowExcel()
{
	if(win)
	{
		win.close();
	}
	
	document.frmTeamPlan.target = "Team Planner - Excel";
	document.frmTeamPlan.action="HierarchyOpenTeamTaskingOverviewToExcel.asp";
	document.frmTeamPlan.submit();
	document.frmTeamPlan.target = "";
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
	str=Calender.value
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
	ajaxFunction('manningGetStaffTaskInfoAjaxUpdate.asp',vars,type,task,'Task Details',0,0,380,400);
}

function UpdateIndividual(type,task,serno,id)
{
	var sd = document.getElementById('startDate').value;
	var ed = document.getElementById('endDate').value;
	
	var sDate = parseInt(sd.split("/")[2] + sd.split("/")[1] + sd.split("/")[0])
	var eDate = parseInt(ed.split("/")[2] + ed.split("/")[1] + ed.split("/")[0])
	
	if(document.frmDetails.endDate.value =="" || document.frmDetails.startDate.value =="")
	{
		alert("Completed Date Fields");
		return
	}
	
	if(sDate > eDate)
	{
		alert("Start date can not be later than end date")
		document.getElementById('startDate').value = "";
		document.getElementById('endDate').value = "";
		return
	}
	
	document.frmDetails.action = "UpdateTaskIndividual.asp?ttID="+type+"&RecID="+task+"&serviceNo="+serno+"&id="+id;
	document.frmDetails.submit();
}

</Script>
