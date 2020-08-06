<!--#include file="Connection/Connection.inc"-->
<%
teamID = request("teamID")
dim strAction
dim strFrom
dim strGoTo

'response.write strFrom & strGoTo
'response.End()
strAction="Update"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = "spPersDetailByServiceNo"	
objCmd.CommandType = 4				
set objPara = objCmd.CreateParameter ("serviceNo",200,1,16, request("serviceNo"))
objCmd.Parameters.Append objPara
set rsPersDetails = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

if request("ttID") <> 0 then
	strCommand = "spTaskSearchResults"
	objCmd.CommandText = strCommand
	objCmd.CommandType = 4		
	set objPara = objCmd.CreateParameter ("task",200,1,50, "")
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("ttID",3,1,0, request("ttID"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("startDate",200,1,50, "")
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("endDate",200,1,50, "")
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("sort",3,1,0, 1)
	objCmd.Parameters.Append objPara

	set rsTaskList = objCmd.Execute

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next
	
else
objCmd.CommandText = "spListTaskCategoriesByType"	
objCmd.CommandType = 4				
set objPara = objCmd.CreateParameter ("ttID",3,1,5, request("ttID"))
objCmd.Parameters.Append objPara
set rsCategoryList = objCmd.Execute	
end if

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

if request("ttID") <> 0  then
defaultCalStartDate = split (rsTaskList("startDate"),"/")
defaultCalStartDay = defaultCalStartDate(0)
defaultCalStartMonth = defaultCalStartDate(1)
defaultCalStartYear = defaultCalStartDate(2)

defaultCalEndDate = split (rsTaskList("endDate"),"/")
defaultCalEndDay = defaultCalEndDate(0)
defaultCalEndMonth = defaultCalEndDate(1)
defaultCalEndYear = defaultCalEndDate(2)
end if
%>	
	
<html>

<head> 

<!--#include file="Includes/IECompatability.inc"-->
<title>Task Personnel</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
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
</style></head>
<body >
<form   action="" method="post" name="frmDetails" onSubmit="javascript:return(CheckForm());">
<Input name="serviceNo" type="hidden" value=<%=request("serviceNo")%>>
<Input name="ttID" type="hidden" value=<%=request("ttID")%>>
<input name="ReturnTo" type="hidden"  value="ManningTaskPersonnel.asp">
<Input name="HiddenDate" type="hidden" >

<table width=100% border=0 cellpadding=0 cellspacing=0>
<!--#include file="Includes/hierarchyTaskDetails.inc"--> 
				<tr>
					<td colspan=10 class=titlearealine  height=1></td> 
				</tr>

	<tr  height=16px class=SectionHeader>
		<td>
			<table border=0 cellpadding=0 cellspacing=0 >
				<tr valign=top class=toolbar >
					<td class=toolbar width=8>
					<td width=20px><img id="SaveCloseLink" class="imagelink" src="images/editgrid.gif" onClick="saveNew();"></td>
					<td class=toolbar valign="middle" >Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
					<td class=toolbar valign="middle" ><A class=itemfontlink href="javascript:window.parent.refreshIframeAfterDateSelect('ManningTeamPersonnel.asp');">Cancel</A></td>											
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table border=0 cellpadding=0 cellspacing=0>
				<tr height=16>
					<td></td>
				</tr>
				<tr height=26>
					<td valign="middle"></td>
					<td valign="middle"  class=columnheading width="20%">Task Type:</td>
					<td valign="middle"  class=itemfont ><%=request("description")%></td>
					<td width="20px"></td>
					
					<td valign=top rowspan=5>
						<table>
							<tr>
								<td class=columnheading>Notes : </td>
							</tr>
							<tr>
								<td>
									<Textarea cols="20" rows="10" name="notes" class="pickbox itemfontEdit" ></Textarea>
								</td>
							</tr>
						
						</table>
					
					</td>
					<td rowspan=5></td>
				</tr>
				
				<tr height=26>
					<td valign="middle" width=2%></td>
					<td valign="middle"  class=columnheading >Task:</td>


					<td valign="middle"  class=itemfont>

						<%if request("ttID") <> 0   then%>
						<%firstStartDate= rsTaskList("startDate")
						firstEndDate= rsTaskList("endDate")
						arraycount=1
						%>
						
						<Select  class="inputbox itemfontEdit" Name="recID" style="width:320px;" onChange="changeDates( document.frmDetails.recID.selectedIndex+1)">
						<%Do while not rsTaskList.eof%>
						<%if rsTaskList("Task")<>"Course" and rsTaskList("Task")<>"501" then%> 
<SCRIPT LANGUAGE="JavaScript">
						startDateArray [<%=arraycount%>] = "<%=convertDate (rsTaskList("startDate"))%>"
						endDateArray [<%=arraycount%>] = "<%=convertDate (rsTaskList("endDate"))%>"	
</script>
						<option value=<%=rsTaskList("taskID")%> ><%=rsTaskList("Task")%></option>


						<%arraycount=arraycount+1
                                                end if%>
						<%
						
						rsTaskList.MoveNext
						Loop%>
						</Select>
						<%else%>

						<Select  class="inputbox itemfontEdit" Name="Task" style="width:160px;">
						<%Do while not rsCategoryList.eof%>
						<option value="<%=rsCategoryList("Description")%>" ><%=rsCategoryList("Description")%></option>
						<%rsCategoryList.MoveNext
						Loop%>
						</Select>
						<%end if%>
					</td>
					
				</tr>
				<!--
<'%if request("ttID") <> 0   then%>
				<tr height=26>
					<td valign="middle"></td>
					<td valign="middle"  class=columnheading >Start Date:</td>
					<td id=taskStartDate valign="middle"  class=itemfont ><%'=convertDate(firstStartDate)%></td>
					<td></td>
				</tr>
				<tr height=26>
					<td valign="middle"></td>
					<td valign="middle"  class=columnheading >End Date:</td>
					<td id=taskEndDate valign="middle"  class=itemfont ><%'=convertDate(firstEndDate)%></td>
					<td></td>
				</tr>
<'%end if%>
				-->
				<tr class=columnheading height=26>
					<td valign="middle" ></td>
					<td valign="middle"  >Specify Dates:</td>
					<td valign="middle"  class=itemfont >
						<table border=0 cellpadding=0 cellspacing=0 >
							<tr>
								<td valign="middle" >
									<table border=0 cellpadding=0 cellspacing=0 >
										<tr>
											<td >
											<td class=columnheading ></td>
											<td valign=top width=90px>
												<INPUT id="startDate" class="inputbox itemfontEdit"  style="Width:75px;"  name="startDate"  readonly>
											</td>
											<td>
											  <img src="images/cal.gif" onClick="javascript:CalenderScript(CalenderImage,cal<%if request("ttID") <> 0   then%>,taskStartDate<%end if%>);" style="cursor:hand;">
											</td>
											<td valign="middle" ></td>
										</tr>
									</table>
								</td>
								<td width="10px"></td>
								<td valign="middle" >
									<table border=0 cellpadding=0 cellspacing=0 >
										<tr>
											<td class=columnheading >To:&nbsp;</td>
											<td width=90px>
												<INPUT id="endDate" class="inputbox itemfontEdit"  style="Width:75px;"  name="endDate"  readonly>
											</td>
											<td>
											  <img src="images/cal.gif" onClick="javascript:CalenderScript(CalenderImage2,calEndDate<%if request("ttID") <> 0   then%>,taskEndDate<%end if%>);" style="cursor:hand;">
											</td>
											<td valign="middle" ></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>									
					</td>
				</tr>
				<tr height=16>
					<td></td>
				</tr>
				
			</table>
		</td>

	</tr>
	<tr>
		<td colspan=6 class=titlearealine  height=1></td> 
	</tr>
	<tr valign="middle" height=16px class=SectionHeader>
		<td>
			<table border=0 cellpadding=0 cellspacing=0 >
				<tr valign="middle" class=toolbar >
					
					<td class=toolbar width=8></td><td class=toolbar valign="middle" >Individual To Task:</td>											
				</tr>
			</table>
		</td>
	</tr>
	<tr valign="middle" height=16px >
	<td></td>
	</tr>
	<tr valign="middle" height=16px >
		<td>
			<table width=450px border=0 cellpadding=0 cellspacing=0 >

				<tr class=columnheading height=20>
					<td valign="middle" width=2%></td>
					<td valign="middle" width=33%>Surname</td>
					<td valign="middle" width=20%>Firstname</td>
					<td valign="middle" align="center" width=28% > Service No</td>
				</tr>
				<tr>
					<td colspan=5 class=titlearealine  height=1></td> 
				</tr>

				<tr class=toolbar height=20>
					<td valign="middle"></td>
					<td valign="middle" ><%=rsPersDetails("Surname")%></td>
					<td valign="middle"  ><%=rsPersDetails("firstName")%></td>
					<td valign="middle"  align="center"><%=rsPersDetails("serviceNo")%></td>
					
				</tr>

				<tr>
					<td colspan=5 class=titlearealine  height=1></td> 
				</tr>

			</table>
		</td>
	</tr>



</table>
</Form>

<Div id="CalenderImage" class="CalenderImageAll" style="top:114px;left:200px;">
	<Div  onclick="javascript:InsertCalenderDate(cal,document.all.startDate);CloseCalender(CalenderImage);">
		<object  classid="CLSID:8e27c92b-1264-101c-8a2f-040224009c02" id="cal">
		
		</object>
	</Div>
	<Div align="center"><Input CLASS="StandardButton" Type=Button Value=Cancel onClick="javascript:CloseCalender(CalenderImage);"></Div>
</Div>
<Div id="CalenderImage2" class="CalenderImageAll" style="top:114px;left:338px;">
	<Div  onclick="javascript:InsertCalenderDate(calEndDate,document.all.endDate);CloseCalender(CalenderImage2);">
		<object  classid="CLSID:8e27c92b-1264-101c-8a2f-040224009c02" id="calEndDate">

		</object>

  </Div>
	<Div align="center"><Input CLASS="StandardButton" Type=Button Value=Cancel onClick="javascript:CloseCalender(CalenderImage2);"></Div>
</Div>



<SCRIPT LANGUAGE="JavaScript">
//alert("helll<%=request("postID")%>" + "<%=request("serviceNo")%>" + "<%=request("ttID")%>")
var startDateArray = new Array();
var endDateArray = new Array();

var thisDate = window.parent.frmDetails.startDate.value;
var homeString ='javascript:refreshIframeAfterDateSelect("ManningTeamPersonnel.asp");'

window.parent.crumbTrail.innerHTML="<A title='' href='index.asp' class=itemfontlinksmall >Home</A> > <A title='' href='" + homeString + "' class=itemfontlinksmall >Personnel</A> > <font class='youAreHere' >Task Individual</font>" 

function InsertCalenderDate(Calender,SelectedDate)
	{
	var startDate = new Date(document.all.startDate.value);
	var endDate = new Date(document.all.endDate.value);
	//startDate =  document.all.startDate.value
	//endDate =  document.all.endDate.value

	var dateOK=1;
	var str=Calender.value;
	document.forms["frmDetails"].elements["HiddenDate"].value = str;
	var whole = document.forms["frmDetails"].elements["HiddenDate"].value;
	var day = document.forms["frmDetails"].elements["HiddenDate"].value.substring (8,10);
	day.replace (" ","");
	var month = document.forms["frmDetails"].elements["HiddenDate"].value.substring (4,7);
	month.replace (" ","");
	var strlength = document.forms["frmDetails"].elements["HiddenDate"].value.length;
	var year = document.forms["frmDetails"].elements["HiddenDate"].value.substring (strlength-4,strlength);
	if (day<10) {
		day="0"+day;
	}
	if (day>=10) {
		day=day + " ";
	}
	var convertedDate = new Date((day + month + " " + year ))
	
        //var convertedDate = new Date(("23 Mar 2007"))
	//convertedDate = day + month + " " + year
	//var todayDate = new Date()
	//todayDate.getDate()
	//d = todayDate.getDate()
	//m = todayDate.getMonth()
	//yy = todayDate.getYear()
	//var testDate = new Date(d + " " + "march" + " " + yy)
	//alert("convertedDate=" + convertedDate + "," + "Start Date=" + startDate +  "End Date=" + endDate)
	if (SelectedDate == document.all.startDate){
		var compareDate = new Date();

<%if request("ttID") <> 0   then%>
		var compareDate = new Date(document.getElementById('taskStartDate').innerHTML);
		//compareDate = taskStartDate.innerHTML
		if (convertedDate < compareDate){
		alert("Start Date can not be less than Task Start Date")
		dateOK=0;
		}
<%end if%>
		startDate=convertedDate
		if (endDate < startDate){
		alert("start date can not be later than end date")
		dateOK=0;
		}

	}

	if (SelectedDate == document.all.endDate){
		//var compareDate = new Date()
<%if request("ttID") <> 0   then%>
		var compareDate = new Date(document.getElementById('taskEndDate').innerHTML);
		//compareDate = taskEndDate.innerHTML
		if (convertedDate > compareDate){
		alert("Start Date can not be more than Task End Date");
		dateOK=0;
		}
<%end if%>

		endDate=convertedDate;
		if (endDate < startDate){
		alert("End date can not be earlier than start date");
		dateOK=0;


		}

	}
//alert("startdate="+startDate + "enddate=" + endDate)	
	if (dateOK==1){
	SelectedDate.value = day + month + " " + year
	}
}	

function CalenderScript(CalImg,Cal<%if request("ttID") <> 0   then%>,thisDate<%end if%>)
	{
	<%if request("ttID") <> 0   then%>
	var str=thisDate.innerHTML;
	str = "<%=convertDate(Date())%>"
	
    var day = str.substring (0,2);
	day.replace (" ","");
	var month = str.substring (3,6);
	month.replace (" ","");
	var strlength = str.length;
	var year = str.substring (strlength-4,strlength);
	//alert (day + "," + month + "," + year)
	Cal.Year=year;
	Cal.Day=day;
	Cal.Month = convertMonth(month);
	<%end if%>
	CalImg.style.visibility = "Visible";
	 }

function CloseCalender(CalImg)
	{
	 CalImg.style.visibility = "Hidden";
	}

function convertMonth(month)
{
switch(month){
	case "Jan":
	return "1"
	break

	case "Feb":
	return "2"
	break
	
	case "Mar":
	return "3"
	break
	
	case "Apr":
	return "4"
	break

	case "May":
	return "5"
	break

	case "Jun":
	return "6"
	break
	
	case "Jul":
	return "7"
	break
	
	case "Aug":
	return "8"
	break
	
	case "Sep":
	return "9"
	break

	case "Oct":
	return "10"
	break
	
	case "Nov":
	return "11"
	break
	
	case "Dec":
	return "12"
	break
	}
}
</script>
<%

con.close
set con=Nothing
%>


<SCRIPT LANGUAGE="JavaScript">

function changeDates(selectedIndex){
//alert (selectedIndex + " ," + startDateArray[selectedIndex])
document.getElementById('taskStartDate').innerHTML = startDateArray[selectedIndex];
document.getElementById('taskEndDate').innerHTML = endDateArray[selectedIndex];
//frmDetails.startDate.value = startDateArray[selectedIndex]
//frmDetails.endDate.value = endDateArray[selectedIndex]
document.frmDetails.startDate.value = "";
document.frmDetails.endDate.value = "";

}

function saveNew(){
document.frmDetails.action="updateTaskIndividual.asp";
//alert(document.frmDetails.action);
if (document.frmDetails.endDate.value =="" || document.frmDetails.startDate.value ==""){
	
alert("Completed Date Fields");
	
	}else{
	document.frmDetails.submit();
	}
}

function CheckForm(){
if (document.frmDetails.endDate.value=="") {
	alert("No!!!");
	return false;
	}
}
</Script>

</body>
</html>
