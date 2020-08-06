<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%
dim showDetachment
dim showCourses
strAction = "Add"

strGoTo = "ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate="

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

' 'first find out whether its an HQ Tasking Group - cos if it is then we display HQ Task details
strCommand = "spCheckHqTask"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("StaffID",3,1,0, session("StaffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("HQTasking",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	             'Execute CommandText when using "ADODB.Command" object
strHQTasking   = objCmd.Parameters("HQTasking") 
' Now Delete the parameters
objCmd.Parameters.delete ("StaffID")
objCmd.Parameters.delete ("HQTasking")


strCommand = "spListTaskCategories"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
set rsParentList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

strCommand = "spListTaskTypes"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
set rsTaskTypeList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

strCommand = "spCheckIfTeamMember"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
set objPara = objCmd.CreateParameter ("TeamID",3,1,5,23)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("staffID",3,1,5, session("StaffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("inThisTeam",3,2,0, 0)
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
inThisTeam = objCmd.Parameters("inThisTeam")
if inThisTeam = 1 then showDetachment=1

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strCommand = "spCheckIfTeamMember"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
set objPara = objCmd.CreateParameter ("TeamID",3,1,5,42)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("staffID",3,1,5, session("StaffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("inThisTeam",3,2,0, 0)
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
inThisTeam = objCmd.Parameters("inThisTeam")
if int(inThisTeam) = 1 then showCourses=1


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
%>

<html>

<head> 

<!--#include file="Includes/IECompatability.inc"-->
<title><%=pageTitle%></title>
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
<body onclick="checkDropDownMenu(currentDropDown);">
  <form   action="UpdateTask.asp?<%=strGoTo%>" method="post" name="frmDetails">
    <Input name="HiddenDate" id="HiddenDate" type="hidden"  >
    <Input name="ooaTask" id="ooaTask" type="hidden" value="0" >
    <Input name="hqTask" id="hqTask" type="hidden" value="0" >
    <input name="strAction" id="strAction" value="<%=strAction%>" type="hidden">
    <table  height=100% cellspacing=0 cellPadding=0 width=100% border=0>
        <tr>
            <td>
                <!--#include file="Includes/Header.inc"-->
                <table cellSpacing=0 cellPadding=0 width="100%" border=0 >
                    <tr style="font-size:10pt;" height=26x>
                        <td width=10px >&nbsp;</td>
                        <td  ><A title="" href="index.asp" class=itemfontlinksmall >Home</A> > <A title="" href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=" class=itemfontlinksmall >Tasking</A> > <font class="youAreHere" >New Task</font>
                        </td>
                        
                    </tr>
                    <tr>
                        <td colspan=2 class=titlearealine  height=1><img height="1" alt="" src="Images/blank.gif"></td> 
                    </tr>
                </table>
                
                <table width=100% height="<%=session("heightIs")%>px" border=0 cellpadding=0 cellspacing=0 > 
                    <tr valign=Top>
                        <td class="sidemenuwidth" background="Images/tableback.png">
                            <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
                                <tr height=20>
                                  <td ></td>
                                  <td colspan=3 align=left height=20>Current Location</td>
                                </tr>
                                <tr height=20>
                                  <td width=10></td>
                                  <td width=18 valign=top><img src="images/arrow.gif"></td>
                                  <td width=170 align=Left  ><A title="" href="index.asp">Home</A></td>
                                  <td width=50 align=Left  ></td>
                                </tr>
                                <tr height=20>
                                  <td ></td>
                                  <td valign=top><img src="images/arrow.gif"></td>
                                  <td align=Left  ><A title="" href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=&recID=">Tasking</a></td>
                                  <td align=Left  ></td>
                                </tr>
                                <tr height=20>
                                  <td ></td>
                                  <td valign=top><img src="images/vnavicon.gif"></td>
                                  <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">New Task</Div>
                                  </td>
                                  <td class=rightmenuspace align=Left ></td>
                                </tr>
                            </table>
                        </td>
                        <td width=16></td>
                        
                        <td align=left>
                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                <tr height=16 class=SectionHeader>
                                    <td>
                                        <table border=0 cellpadding=0 cellspacing=0 >
                                            <!--
                                            <td width=20>
                                             <input type=image id="SaveCloseLink" class="imagelink" src="images/editgrid.gif" 
                                                onclick="CheckForm();">
                                            </td>
                                            -->
                                <td width=20><a  href="javascript:CheckForm();"><img class="imagelink" src="images/saveitem.gif"></A></td>
    
                                            <td class=toolbar valign="middle" >Save and Close</td>
                                            <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                            <% IF strFrom = "Manning" THEN %>
                                            <td class=toolbar valign="middle" ><A class= itemfontlink href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=&recID=<%=request("recID")%>">Back</A>
                                            </td>
                                            <%ELSE%>
                                            <td class=toolbar valign="middle" ><A class= itemfontlink href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=&recID=<%=request("recID")%>">Back</A>
                                            </td>											
                                            <%END IF%>
                                        </table>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td>
                                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                                            <tr height=16>
                                                <td></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=16></td>
                                                <td valign="middle"  width=158>Task Type:</td>
                                                <td ></td>
                                                <td valign="middle"  width=180>Task:</td>
                                                <td align="center" valign="middle" width=118>Out of Area Task</td>
                                                <!-- Ron 070708 - We don't want dates on Tasks
                                                <td valign="middle">Start Date:</td>
                                                <td width=10px></td>
                                                <td valign="middle" >End Date:</td>
                                                <td width=10px></td>
                                                -->
                                                <td align="center" valign="middle" width=118>Cancellable</td>
                                                <!--<td align="center" valign="middle" width="118" >HQ Task</td>-->
                                                <% if strHQTasking = 1 then %>
                                                     <td align="center" valign="middle" width="118">HQ Task </td>
                                                <% end if %>  
    
                                            </tr>
                                            <tr class=columnheading height=30>
                                                <td valign="middle" width=16></td>
                                                <td valign="middle"  width=158>
                                                    <Select  class="itemfont " Name="TypeID" id="TypeID" style="width:120px;" onChange="changeDropDown('TypeMenu' + document.getElementById('TypeID').value);">
    
                                                    <%Do while not rsTaskTypeList.eof%>
    
                                                    <%if rsTaskTypeList("ttID") = 999 or  rsTaskTypeList("ttID") = 999 or  rsTaskTypeList("ttID") = 999 then%>
                                                        <%if showDetachment =1 then%><option value=<%=rsTaskTypeList("ttID")%> <%if rsTaskTypeList("ttID")=1 then response.write " selected"%> ><%=rsTaskTypeList("Description")%></option><%end if%>
                                                    <%else%>
                                                        <%if rsTaskTypeList("ttID") = 999 or rsTaskTypeList("ttID") = 999 or rsTaskTypeList("ttID") = 999 then%>
                                                            <%if showCourses =1 then%><option value=<%=rsTaskTypeList("ttID")%> <%if rsTaskTypeList("ttID")=1 then response.write " selected"%> ><%=rsTaskTypeList("Description")%></option><%end if%>
                                                        <%else%>
                                                            <option value=<%=rsTaskTypeList("ttID")%> <%if rsTaskTypeList("ttID")=1 then response.write " selected"%> ><%=rsTaskTypeList("Description")%></option>
                                                        <%end if%>
                                                    <%end if%>
    
                                                    <%rsTaskTypeList.MoveNext
                                                    Loop%>
                                                    </Select>											</td>
                                                <td width=7></td>
                                                <td>
                                                    <Input class="itemfont" style="width:120px;" Name="Task" id="Task" >														                                            </td>
                                                <!-- Ron 070708
                                                <td valign="middle"  width=100px>
                                                    <table width=100% border=0 cellpadding=0 cellspacing=0>
                                                        <tr>
                                                            <td>
                                                                <Input class="itemfont" style="width:120px;" Name="Task" >														                                                         </td>
                                                        </tr>
                                                    </table>											
                                                </td>
                                                <td width=10px></td>
                                                
                                                <td valign="middle" width="100px">
                                                    
                                                    <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                        
                                                            <tr>
                                                                <td valign=top width=90px>
                                                                    <INPUT id="startDate" class="itemfont"  style="Width:75px;"  name="startDate" value = <%if request("startDate") <>"" then%>"<%=request("startDate")%>"<%else%>"<%=newTodaydate%>"<%end if%> readonly>
                                                                </td>
                                                                <td >
                                                                    <img src="images/cal.gif" onClick="javascript:CalenderScript(CalenderImage);" style="cursor:hand;">
                                                                </td>
                                                                <td valign="middle" ></td>
                                                            </tr>
    
                                                        
                                                    </table>
    
                                                
                                                </td>
                                                <td width="10px"></td>
                                                
                                                <td valign="middle" width="100px">
                                                    <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                        
                                                            <tr>
                                                                <td width=90px>
                                                                    <INPUT id="endDate" class="itemfont"  style="Width:75px;"  name="endDate" value = <%if request("endDate") <>"" then%>"<%=request("endDate")%>"<%else%>"<%=newTodaydate%>"<%end if%> readonly>
                                                                </td>
                                                                <td>
                                                                    <img src="images/cal.gif" onClick="javascript:CalenderScript(CalenderImage2);" style="cursor:hand;">
                                                                </td>
                                                                <td valign="middle" ></td>
                                                            </tr>
    
                                                        
                                                    </table>
                                                  
                                                </td>
                                                
                                                <td width="10px"></td>
                                                -->
                                                <td align="center" valign="middle" width=118>
                                                  <input type="checkbox" name="ooa" id="ooa" value="">
                                                </td>
                                                <td align="center" valign="middle" width=118>
                                                  <input type="checkbox" name="cancellable" id="cancellable" value="1">
                                                </td>
                                                <% if strHQTasking = 1 then %>
                                                  <td align="center" valign="middle" width=118>
                                                     <input type="checkbox" name=hq value="">
                                                  </td>
                                                <% end if %>  
    
                                                <td ></td>
                                            </tr>
                                            <tr>
                                                <td colspan=20  height=16></td> 
                                            </tr>
                                            <tr>
                                                <td colspan=20 class=titlearealine  height=1></td> 
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                
                            </table>
                        </td>
                         
                    </tr>
                </table>
            </td>
        </tr>
    </table>
  </form>
<Div id="CalenderImage" class="CalenderImageAll" style="top:244px;left:462px;">
	<Div  onclick="javascript:InsertCalenderDate(cal,document.all.startDate);CloseCalender(CalenderImage);">
		<object  classid="CLSID:8e27c92b-1264-101c-8a2f-040224009c02" id="cal"></object>
	</Div>
	<Div align="center"><Input CLASS="StandardButton" Type=Button Value=Cancel onclick="javascript:CloseCalender(CalenderImage);"></Div>
</Div>
<Div id="CalenderImage2" class="CalenderImageAll" style="top:244px;left:572px;">
	<Div  onclick="javascript:InsertCalenderDate(calEndDate,document.all.endDate);CloseCalender(CalenderImage2);">
		<object  classid="CLSID:8e27c92b-1264-101c-8a2f-040224009c02" id="calEndDate"></object>
  </Div>
	<Div align="center"><Input CLASS="StandardButton" Type=Button Value=Cancel onclick="javascript:CloseCalender(CalenderImage2);"></Div>
</Div>

<%rsTaskTypeList.movefirst%>
<%do while not rsTaskTypeList.eof%>
<div id="<%response.write "TypeMenu" & rsTaskTypeList("ttID") %>" style="visibility:hidden;position:absolute;top:217px;left:368px;background-color:#ffffff;"  >
	<Div class=borderArea onclick="secondTime=2;">
		<table  border=0 cellpadding=1 cellspacing=0 width=143px>
			<%rsParentList.movefirst%>
			<%do while not rsParentList.eof%>
			<%if rsParentList("TypeID") = rsTaskTypeList("ttID") then%>
			<tr height=8Px id = "row<%=rsParentList("qID")%>"  class="dropDownMouseOff" onClick="frmDetails.Task.value='<%=rsParentList("Description")%>';secondTime=1;checkDropDownMenu(currentDropDown);"  onMouseOver = "javascript:row<%=rsParentList("qID")%>.className='dropDownMouseOn';" onMouseOut = "javascript:row<%=rsParentList("qID")%>.className='dropDownMouseOff';">
				<td valign=top class=" itemfont"><%=rsParentList("description")%></td>
			</tr>
			<%end if%>
			<%rsParentList.movenext%>
			<%loop%>
			<%rsParentList.movefirst%>
		</table>
	</Div>
</div>
<%rsTaskTypeList.movenext%>
<%loop%>


<SCRIPT LANGUAGE="JavaScript">

var ParentArray = new Array();
<%
Counter=0
do while not rsParentList.eof%>
ParentArray[<%=Counter%>] = "<%=rsParentList("TypeID")%>*<%=rsParentList("QID")%>*<%=rsParentList("Description")%>";
<%
Counter=Counter+1
rsParentList.movenext
loop
rsParentList.movefirst
%>
currentDropDown='TypeMenu1'
secondTime=0

</Script>
<%
con.close
set con=Nothing
%>

</body>
</html>

<SCRIPT LANGUAGE="JavaScript">

function showDropDown(thisDropDown){
temp=document.getElementById(thisDropDown);
temp.style.visibility="visible";
secondTime=2;
}

function changeDropDown (thisDropdown) {
currentDropDown = thisDropdown;
document.frmDetails.Task.value='';
}

function checkDropDownMenu(thisDropDown){
temp=document.getElementById(thisDropDown)
testVisibility=temp.style.visibility;
if (testVisibility=='visible' && secondTime==1){
	temp.style.visibility='hidden';
	secondTime=0;
	}else if (secondTime=2) {
	
	secondTime=1;
	}
}

function saveNew(){
    /* now build the section list - if any - to be removed */
/* now build hidden value with list of Locations to submit so the 
program writelocations can update database */
	newattached="start";
	stringToCheck = document.frmDetails.currentlyChecked.value
	for (var i = 0; i < document.frmPosts.elements.length; i++){
		currentValue=document.frmPosts.elements[i].value;
		if (document.frmPosts.elements[i].checked==true) {
			if (stringToCheck.indexOf(currentValue)<0){
				newattached = newattached + "," + document.frmPosts.elements[i].value;
			}
		}
	}
    document.frmDetails.newattached.value = newattached + document.frmDetails.currentlyChecked.value;
	if(document.frmDetails.newattached.value=="start") {
	alert("Select at least one post")
	return;	  		
} 
document.frmDetails.action="UpdateGroupQualification.asp";
//alert(document.frmDetails.action);
document.frmDetails.submit();
}

function changeParent() {
var TypeID = document.getElementById("TypeID").value;
document.getElementById("TaskCategoryID").length=0;
var counter =0;
for (i=0;i<ParentArray.length;i++)
	{
		strSplit = ParentArray[i].split("*");
			if (strSplit[0]==TypeID)
			{
				document.frmDetails.TaskCategoryID.options[counter] = new Option(strSplit[2],strSplit[0] + "*" + strSplit[1]);
				alert(document.frmDetails.TaskCategoryID.value);
				counter=counter+1;
			}
	}
}

function findParent(){
	var TypeID = document.getElementById("TypeID").value;
	document.getElementById("TaskCategoryID").length=0;
	var counter = 0;
	for (i=0;i < ParentArray.length;i++)
	{
		strSplit = ParentArray[i].split("*");
			if (strSplit[0]==TypeID)
			{
				document.getElementById("TaskCategoryID").options[counter] = new Option (strSplit[2],strSplit[1]);
				counter++;
			}
	}
}

function CheckForm() {
  var passed=true;
  
  if (document.forms["frmDetails"].elements["Task"].value =="") {
     alert("Please enter Task Name");
     passed=false;
     //alert(passed);
  }

  // Check for Out of Area
  if (document.frmDetails.ooa.checked == true) {
	    document.frmDetails.ooaTask.value = "1";
  }	
	
  // Check for HQ Task
  if (document.forms["frmDetails"].elements["hq"] == null) {
  }
  else {
    if (document.frmDetails.hq.checked == true) {
	    document.frmDetails.hqTask.value = "1";
    }	

  }
  
  //alert(passed + document.frmDetails.hqTask.value + document.frmDetails.ooaTask.value);
  //alert(passed);
  if (passed == false) {
   //return passed;
   alert(passed);
   return;
  }

  document.frmDetails.submit();
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
	str=Calender.value;
	document.forms["frmDetails"].elements["HiddenDate"].value = str;
	whole = document.forms["frmDetails"].elements["HiddenDate"].value;
	day = document.forms["frmDetails"].elements["HiddenDate"].value.substring (8,10);
	day.replace (" ","");
	month = document.forms["frmDetails"].elements["HiddenDate"].value.substring (4,7);
	strlength = document.forms["frmDetails"].elements["HiddenDate"].value.length;
	year = document.forms["frmDetails"].elements["HiddenDate"].value.substring (strlength-4,strlength);
	SelectedDate.value = day + " " + month + " " + year;
	}	

</Script>
