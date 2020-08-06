<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%
squareSize=18
tab=2
teamID=request("recID")
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

newTodaydate= splitDate(0) + " " + theMonth + " " + splitDate(2) 


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

manipulateDate=formatdatetime(thisDate,1)
splitDate = split (manipulateDate," ")
newMonthYear= splitDate(1)+ " " + splitDate(2)

startOfMonth = "1" & " " & newMonthYear
startOfNextMonth = formatdatetime(dateAdd("m",1,startOfMonth))
startOfNextMonth = formatdatetime(startOfNextMonth,2)
daysCount= DateDiff("d",startOfMonth,startOfNextMonth)
endOfMonth= daysCount & " " & newMonthYear
strTable = "tblTeam"    
strGoTo = request("fromPage")    
strTabID = "teamID"                      

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

objCmd.CommandText = "spTeamStaff"	
objCmd.CommandType = 4				
set objPara = objCmd.CreateParameter ("TeamID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("allTeams",3,1,5, int(allTeams))
objCmd.Parameters.Append objPara

set objPara = objCmd.CreateParameter ("thisDate",200,1,16, thisDate)
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	
for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next
' make sure we set the levelID to EITHER the parent if its Wing/Sqn/Flt
' OR if its a TEAM then the actual teamID
tmLevel = rsRecSet("teamIn")
IF tmLevel < 4 THEN
  tmLevelID = rsRecSet("ParentID")
ELSE
  tmLevelID = request("RecID")
END IF  

function convertDate (oldDate)
todayDate = formatdatetime(oldDate,2)
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

newDate= splitDate(0) + " " + theMonth + " " + splitDate(2) 
response.write newDate
end function

%>
<SCRIPT LANGUAGE="JavaScript">
window.parent.frmDetails.thisIframe.value="HierarchyTeamTaskingOverView.asp"
thisDate = window.parent.frmDetails.startDate.value
homeString ='javascript:refreshIframeAfterDateSelect("ManningTeamPersonnel.asp");'
window.parent.crumbTrail.innerHTML="<A href='index.asp' class=itemfontlinksmall >Home</A> > <A title='' href='" + homeString + "' class=itemfontlinksmall >Personnel</A> > <font class='youAreHere' >Team Planner</font>"

//alert("<%=thisDate%>")


function showMenu(postName){
//alert(postName);
postNameForTasking.innerHTML=postName;

taskListState=TaskList.style.visibility
	TaskList.style.visibility="Visible";
	justOpened=1
	
return false;

}
//document.onmousedown=showMenu;
</Script>
<html>

<head> 

<!--#include file="Includes/IECompatability.inc"-->
<title>Team Hierarchy</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
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
<body >
<form  action="" method="POST" name="frmDetails">
<Input name="ttID" id="ttID" type="hidden" >
<Input name="description" id="description" type="hidden" >
<input name="serviceNo" id="serviceNo"type="hidden" >
<input name="postID"  id="postID" type="hidden" value="1234">
<Input name="thisDate" id="thisDate" type="hidden" value="<%=thisDate%>">
<input name="recID" id="recID" type="hidden" value="<%=request("recID")%>">
<input name="allTeams" id="allTeams" type="hidden" value="<%=request("allTeams")%>">


<table width=100% border=0 cellpadding=0 cellspacing=0>
<!--#include file="Includes/hierarchyTeamDetails.inc"-->
	<tr>
		<td >
			<table border=0 cellpadding=0 cellspacing=0>
				<tr height=16>
					<td></td>
				</tr>
				<tr  height=22>
					<td valign="middle" width=50px class=columnheading >Unit:</td>
					<td valign="middle" width=350px class=itemfont ><%=rsRecSet("ParentDescription")%> > <font  class="youAreHere"><%=rsRecSet("Description")%></font></td>
					<td valign="middle" ></td>
				</tr>
				<tr height=10>
					<td></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan=20 class=titlearealine  height=1></td> 
	</tr>

	<tr  height=16 class=SectionHeaderPlain>
		<td colspan=1>
			<table align="center" border=0 cellpadding=0 cellspacing=0 >

				<tr class=toolbar>
				   <td class=toolbar width=8></td>
				   
				   <td align="center" class=toolbar valign="middle" ><A href="javascript:gotoPreviousMonth();" class=itemfontlinksmall >Previous Month</A> |<u><b><font style=""class="youAreHere">&nbsp;<%=(newMonthYear)%>&nbsp;</font></u></b>| <A href="javascript:gotoNextMonth();" class=itemfontlinksmall >Next Month</A> </td>
				</tr>  
			</table>
		</td>
		<td colspan=1>
		</td>

	</tr>
	<tr height=10>
		<td></td>
	</tr>

	<%color1="#f4f4f4"
	color2="#fafafa"
	counter=0%>


	<%set rsRecSet=rsRecSet.nextrecordset%>
	<tr height=40%>
		<td valign=top>
			<table width=750px border=0 cellpadding=0 cellspacing=1>

				<tr class="columnheading"   height=<%=squareSize%>px>
					<td width=150px>&nbsp;</td>
					<%
					counter=1
					do while counter<=daysCount%>
					<td  width=<%=squareSize%>px  align="center" 
					<%tempDate=counter & " " & newMonthYear%>
					
					<%if formatdatetime(tempDate,2) = formatdatetime(thisDate,2) then%>
					style="background-color:#000000;color:#dddddd" 
					<%else%>
					<%if weekday(tempDate)=1 or weekday(tempDate)=7 then%>
						style="background-color:#888888;color:#000000"
					<%else%>
						style="background-color:#dddddd;color:#000000"
					<%end if%>
					<%end if%>
					
					><%=counter%></td>
					<%counter=counter+1
					loop%>
					<td style="FONT-SIZE: 1pt;">&nbsp;</td>
				</tr>


				<!--<tr>
					<td colspan=<%=daysCount+1%> class=titlearealine  height=1></td> 
				</tr>-->
			</table>
			<Div class="ScrollingAreaTasking ">
			<table width=750px border=0 cellpadding=0 cellspacing=1>

<%do while not rsRecSet.eof%>

				<%objCmd.CommandText = "spStaffTaskDetails"	
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
				''response.write (startOfMonth & "-" & endOfMonth & " " & rsBusyDates.recordcount)
				%>
				
				<%if rsBusyDates.recordcount<1 then%>
				<tr class="teamPlanner"   height=<%=squareSize%>px>
					<td width=150px><%=rsRecSet("Surname")%>&nbsp;,&nbsp;<%=rsRecSet("firstname")%></td>
					<%
					counter=1
					do while counter<=daysCount%>
					<td width=<%=squareSize%>px align="center" class="SectionHeaderGreen" ></td>
					<%counter=counter+1
					loop%>
					<td style="FONT-SIZE: 1pt;">&nbsp;</td>
				</tr>
				<%else%>
				<tr class="teamPlanner"   height=<%=squareSize%>px>
					<td width=150px><%=rsRecSet("Surname")%>&nbsp;,&nbsp;<%=rsRecSet("firstname")%></td>
					<%
					counter=1
					datecount=0
					
					occurences=rsBusyDates.recordCount-1
					do while counter<=daysCount %>
					
					<td width=<%=squareSize%>px align="center" 
					<%tempDate=counter & " " & newMonthYear%>
					
					<%if cdate(formatdatetime(tempDate,2)) >=  cdate(formatdatetime(rsBusyDates("startDate"),2)) and cdate(formatdatetime(tempDate,2)) <=  cdate(formatdatetime(rsBusyDates("endDate"),2)) then%>
						 title="<%=rsBusyDates("Description")%>" style="cursor:hand;" onclick="javascript:ajaxFunction('manningGetStaffTaskInfoAjax.asp','staffTaskID=<%=rsBusyDates("taskStaffID")%>','Task Details',100,100,320,380)"

						<%if rsBusyDates("type") = 20 then%>
						class="calenderCyan" 
						<%else%>
							<%if rsBusyDates("type") = 4 then%>
							class="calenderYellow" 
							<%else%>
								<%if rsBusyDates("type") = 17 then%>
								class="calenderBlue" 
								<%else%>
									<%if rsBusyDates("type") = 1 or  rsBusyDates("type")=28  or  rsBusyDates("type")=29 then%>
									class="calenderOrange" 
									<%else%>
										<%if rsBusyDates("type") = 26 then%>
										class="calenderPurple" 
										<%else%>
											<%if rsBusyDates("type") = 14 then%>
											class="calenderRed" 
											<%else%>
												<%if rsBusyDates("type") = 16 then%>
												class="calenderGreen" 
												<%else%>
													<%if rsBusyDates("type") = 12 or rsBusyDates("type") = 13 then%>
													class="calenderBYellow" 
													<%else%>
														<%if rsBusyDates("type") = 18  then%>
														class="calenderBlueTwo" 
														<%else%>
															<%if rsBusyDates("type") = 15 then%>
															class="calenderPeaGreen" 
															<%else%>
																<%if rsBusyDates("type") = 19  then%>
																class="calenderOffGreen" 
																<%else%>
																	<%if rsBusyDates("type") = 25  then%>
																	class="calenderTerra" 
																	<%else%>
																		<%if rsBusyDates("type") = 27  then%>
																		class="calenderBrown" 
																		<%else%>

												
																									class="SectionHeaderRed" 
																		<%end if%>
																	<%end if%>
																<%end if%>
															<%end if%>
														<%end if%>
													<%end if%>
												<%end if%>
											<%end if%>	
										<%end if%>
									<%end if%>
								<%end if%>
							<%end if%>
						<%end if%>
											
					
					<%else%> class="SectionHeaderGreen" <%end if%> >
					<%if counter=31 then%>
					
					<%end if%>
					</td>

					<%if datecount < occurences then%>
					
						<%if formatdatetime(tempDate,2) = formatdatetime(rsBusyDates("endDate"),2) then
						rsBusyDates.movenext
						datecount=datecount+1
						end if
						%>
					<%end if%>
					<%counter=counter+1%>
					<%loop%>
<td style="FONT-SIZE: 1pt;">&nbsp;</td>					
				</tr>
				<%end if%>

				<tr>
					<td colspan=<%=daysCount+1%> class=titlearealine  height=1></td> 
				</tr>
<%rsRecSet.movenext%>
<%loop%>
</table>
</Div>
<table  border=0 cellpadding=0 cellspacing=1>
				<tr class="columnheading"   height=<%=squareSize%>px>
					<td width=150px></td>
					<%
					counter=1
					do while counter<=daysCount%>
					<td  width=<%=squareSize%>px align="center" 
					<%tempDate=counter & " " & newMonthYear%>
					
					<%if formatdatetime(tempDate,2) = formatdatetime(thisDate,2) then%>
					style="background-color:#000000;color:#dddddd" 
					<%else%>
					<%if weekday(tempDate)=1 or weekday(tempDate)=7 then%>
						style="background-color:#888888;color:#000000"
					<%else%>
						style="background-color:#dddddd;color:#000000"
					<%end if%>
					<%end if%>
					
					><%=counter%></td>
					<%counter=counter+1
					loop%>
					<td style="FONT-SIZE: 1pt;">&nbsp;</td>
				</tr>
			</table>
		</td>
		<td valign=top style="background-color:#fafafa">
<div style="visibility:">
			<table border=0 cellpadding=0 cellspacing=2 width=100%>
				<tr>
					<td class=itemfont colspan=20 align="center">
						<u>Key:</u>
					</td>
				</tr>			
				<tr height=8px>
					<td >&nbsp;
						
					</td>
				</tr>			

				<tr class="columnheading"   height=<%=squareSize%>px>
					<td>&nbsp;</td>
					<td  class="calenderCyan" width=<%=squareSize%>px></td>
					<td>&nbsp;</td>
					<td>Training</td>
					<td width=<%=squareSize%>px>&nbsp;</td>
				</tr>

				<tr  class="columnheading"   height=<%=squareSize%>px>
					<td>&nbsp;</td>
					<td  class="calenderBlue" width=<%=squareSize%>px></td>
					<td></td>
					<td>Course</td>
				</tr>
				<tr class="columnheading"   height=<%=squareSize%>px>

					<td width=<%=squareSize%>px>&nbsp;</td>
					<td  class="calenderPeaGreen" width=<%=squareSize%>px></td>
					<td></td>
					<td>Guard</td>

				</tr>
				<tr class="columnheading"   height=<%=squareSize%>px>
					<td width=<%=squareSize%>px>&nbsp;</td>
					<td  class="calenderYellow" width=<%=squareSize%>px></td>
					<td></td>
					<td>Leave</td>
				</tr>
				<tr class="columnheading"   height=<%=squareSize%>px>


					<td width=<%=squareSize%>px>&nbsp;</td>
					<td  class="calenderPurple" width=<%=squareSize%>px></td>
					<td></td>
					<td>Sick</td>
				</tr>
				<tr class="columnheading"   height=<%=squareSize%>px>

					<td width=<%=squareSize%>px>&nbsp;</td>
					<td  class="calenderGreen" width=<%=squareSize%>px></td>
					<td></td>
					<td>FP Training</td>
				</tr>
				<tr class="columnheading"   height=<%=squareSize%>px>
				<td width=<%=squareSize%>px>&nbsp;</td>
					<td  class="calenderOrange" width=<%=squareSize%>px></td>
					<td></td>
					<td>Operations/Exercise</td>
				</tr>
				<tr class="columnheading"   height=<%=squareSize%>px>

					<td width=<%=squareSize%>px>&nbsp;</td>
					<td  class="calenderTerra" width=<%=squareSize%>px></td>
					<td></td>
					<td>Sport</td>

				</tr>
				<tr class="columnheading"   height=<%=squareSize%>px>

					<td width=<%=squareSize%>px>&nbsp;</td>
					<td  class="calenderBYellow" width=<%=squareSize%>px></td>
					<td></td>
					<td >Station Duty, Unit Duty</td>
				</tr>
				<tr class="columnheading"   height=<%=squareSize%>px>

					<td width=<%=squareSize%>px>&nbsp;</td>
					<td  class="SectionHeaderRed" width=<%=squareSize%>px></td>
					<td></td>
					<td>Other</td>

				</tr>
				<tr class="columnheading"   height=<%=squareSize%>px>
					
					
							<td width=<%=squareSize%>px>&nbsp;</td>
							
							
							<td>
								<div class="borderArea">
								<table border=0 cellpadding=0 cellspacing=0>
									 <tr class="columnheading" height=<%=squareSize%>px>					
										<td  class="calenderBrown" width=<%=squareSize%>px></td>

									</tr>
								</table>
								</div>
							</td>
							
							<td></td>
							<td>Posted</td>

				</tr>


			</table>
</div>
		</td>		

	</tr>
</table>

</form>

<%
windowWidth=200
windowHeight=200%>
<Div id=detailWindow class="windowBorderArea" style="background-color:#f4f4f4;position:absolute;left:200px;top:200px;height:<%=windowHeight%>px;width:<%=windowWidth%>px;visibility:hidden;">
	<table border=0 cellpadding=0 cellspacing=0 align=right width=100%>
		<tr  class=SectionHeader>
			<td>
<DIV id=detailWindowTitleBar style="position:relative;left:7px;top:0px;width:<%=windowWidth-16%>px;border-color:#7f9db9;">
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

		<tr  >
			<td align=left class=itemfont>
<Div id=innerDetailWindow class="innerWindowBorderArea" style="Overflow:auto;background-color:#f4f4f4;color:#000000;position:relative;height:<%=windowHeight-40%>px;width:<%=windowWidth-16%>px">
				<table border=0 cellpadding=0 cellspacing=0 align=right width=100%>
					<tr class=itemfont>
						<td  >
						</td>
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
function taskItemOver(thisObject){
previousBGColor = thisObject.style.backgroundColor;
previousFGColor = thisObject.style.color;
thisObject.style.backgroundColor = "#7a9ddc";
thisObject.style.color = "#ffffff";
}

function taskItemOut(thisObject){
thisObject.style.backgroundColor = previousBGColor;
thisObject.style.color = previousFGColor;
}

function postItemOnclick(thisObject,postID,serviceNo){
if (firstClick==0) {
previousPostObject.style.backgroundColor = previousBGColor;
previousPostObject.style.color = previousFGColor;


//alert(previousBGColor + "," + previousFGColor)
}
//alert (postID + "," + serviceNo)
frmDetails.postID.value=postID
frmDetails.serviceNo.value=serviceNo
firstClick=0;
previousBGColor = thisObject.style.backgroundColor;
previousFGColor = thisObject.style.color;
previousPostObject = thisObject;
thisObject.style.backgroundColor = "#7a9ddc";
thisObject.style.color = "#ffffff";
}

function checkPage(){
taskListState=TaskList.style.visibility
	if (taskListState=="visible" && justOpened==0 ){
		TaskList.style.visibility="Hidden";
		//alert(taskListState)
	}
justOpened=0;
}



function checkDelete(){
     var delOK = false 
    
	  input_box = confirm("Are you sure you want to delete this Record ?")
	  if(input_box==true) {
		    delOK = true;
	    }
    return delOK;
}
function MovetoPage (PageNo) {
	document.forms["frmDetails"].elements["Page"].value = PageNo;
	document.forms["frmDetails"].submit();
}

function gotoTask(ttID,description){
//alert (ttID + "," + description)
document.frmDetails.ttID.value=ttID;
document.frmDetails.description.value=description;

document.frmDetails.action="HierarchyTaskIndividual.asp";
//alert(document.frmDetails.action);
document.frmDetails.submit();
window.parent.startTimer()
}
function gotoNextMonth(){

document.frmDetails.thisDate.value="<%convertDate(nextMonth)%>"
document.frmDetails.action="HierarchyTeamTaskingOverView.asp";
//alert(document.frmDetails.action);
document.frmDetails.submit();

}
function gotoPreviousMonth(){
document.frmDetails.thisDate.value="<%convertDate(previousMonth)%>"
document.frmDetails.action="HierarchyTeamTaskingOverView.asp";
//alert(document.frmDetails.action);
document.frmDetails.submit();

}

function populateDetailsWindow(name,text,xPos,yPos,xHeight,xWidth){
//alert (name);
<!--Create Div Window with Parameters sent to function-->
windowName.innerHTML=name;
innerDetailWindow.innerHTML=text;
detailWindow.style.visibility="visible";
detailWindow.style.left=xPos;
detailWindow.style.top=yPos;
detailWindow.style.height=xHeight+ "px";
detailWindow.style.width=xWidth + "px";
innerDetailWindow.style.height=xHeight-40 + "px";
innerDetailWindow.style.width=xWidth - 16 + "px";
detailWindowTitleBar.style.width=xWidth - 16 + "px";
}
<!--Close Open Div Window-->

function closeThisWindow (thisWindow){
thisWindow.style.visibility="hidden";
}

function ajaxFunction(ajaxFile,vars,name,xPos,yPos,xHeight,xWidth){
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
    ajaxRequest.onreadystatechange = function(){
        if(ajaxRequest.readyState == 4){
			populateDetailsWindow(name,ajaxRequest.responseText,xPos,yPos,xHeight,xWidth);
        }
 	}
    ajaxRequest.open("POST", ajaxFile, true);
    ajaxRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    //xmlHttp.send(strMessage);
    ajaxRequest.send(vars); 
}

function showCounter(counter) {
alert(counter);
}

/**
function OverBackgroundChange(itemID){
    itemID.className='testTabHover';
}

function OutBackgroundChange(itemID){
    itemID.className='testTabUnselected';
}
RowColor=1
function ChangeRowColor(RowID){
	if (RowColor == 1) {
		document.all[RowID].style.backgroundColor= '#eeeeee'
		RowColor=2
	} else {
		document.all[RowID].style.backgroundColor= '#ffffff'
		RowColor=1
	}	
}
function ConfirmRefuse (LoanID, Action) {
	document.forms["Form"].elements["LoanID"].value=LoanID;
	document.forms["Form"].elements["ConfirmOrRefuse"].value=Action;
	document.forms["Form"].submit();
}
**/
</Script>
