<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%
strAction = "Update"
' parameters for the Delete Option
strTable = "tblTeam"    ' tablename
strGoTo = "ManningTeamSearch.asp"   ' asp page to return to once record is deleted
strTabID = "teamID"              ' key field name for table  
strFrom="Manning"      
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con

' first find out whether its an HQ Tasking Group - cos if it is then we display HQ Task details
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

strCommand = "spListTaskTypes"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
set rsTaskTypeList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
strCommand = "spListTaskCategories"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
set rsCategoryTypeList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
objCmd.CommandType = 4				'Code for Stored Procedure
' first get the Team details
set objPara = objCmd.CreateParameter ("TaskID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
objCmd.CommandText = "sp_TaskDetail"	'Name of Stored Procedure
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
' now check to see if they have manager rights for this team
' 1 = Manager   0 = User
'here
'startDate = rsRecSet("startDate")
'endDate = rsRecSet("endDate")

Function convertDate (convertThis)

splitDate = split (convertThis,"/")
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
newdate= splitDate(0) + " " + theMonth + " " + splitDate(2) 
response.write newdate
		
End Function
%>
<SCRIPT LANGUAGE="JavaScript">

var ParentArray = new Array();
<%
Counter=0
do while not rsCategoryTypeList.eof%>
ParentArray[<%=Counter%>] = "<%=rsCategoryTypeList("TypeID")%>*<%=rsCategoryTypeList("QID")%>*<%=rsCategoryTypeList("Description")%>";
<%
Counter=Counter+1
rsCategoryTypeList.movenext
loop
rsCategoryTypeList.movefirst
if session("UserStatus") = "1" or session ("administrator") ="1" then strManager= "1"
%>

</Script>

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
<body>
<form   action="UpdateTask.asp" method="post" name="frmDetails" onSubmit="return(CheckForm());">
<Input name="RecID" type="Hidden" value=<%=request("RecID")%>>
<Input name="HiddenDate" type="hidden"  >
<Input name="ooaTask" type="hidden" value="0" >
<Input name="hqTask" type="hidden" value="0" >
<input name="strAction" value="<%=strAction%>" type="hidden">


  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"-->
		<table cellSpacing=0 cellPadding=0 width=100% border=0 >
    	  <tr style="font-size:10pt;" height=26px>
      	    <td width=10px>&nbsp;</td>
       		<td   ><A title="" href="index.asp" class=itemfontlinksmall >Home</A> > <A title="" href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=" class=itemfontlinksmall >Tasking</A> > <font class="youAreHere" >Edit Task</font></td>
    	  </tr>
  		  <tr>
       		<td colspan=2 class=titlearealine  height=1></td> 
     	  </tr>
  		</table>
  		<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      	  <tr valign=Top>
            <td class="sidemenuwidth" background="Images/tableback.png">
			  <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
			    <tr height=20>
          		  <td ></td><td colspan=3 align=left height=20>Current Location</td>
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
				  <td align=Left  ><A title="" href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=">Tasking</a></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td ></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left  ><A title="" href="ManningTaskDetail.asp?RecID=<%=request("RecID")%>&fromPage=<%="Manning"%>">Task Details</A></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td ></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Edit Task</Div></td>
				  <td class=rightmenuspace align=Left ></td>
				</tr>


			    <tr height=20>
	          	  <td ></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left  ><A title="" href="ManningNewTask.asp?fromPage=<%=strFrom%>">New Task</A></td>
				  <td align=Left  ></td>
				</tr>
			    <tr height=20>
	          	  <td ></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left  ><A title="" href="ManningTaskPersonnel.asp?RecID=<%=request("RecID")%>">Tasked Personnel</A></td>
				  <td align=Left  ></td>
				</tr>
			  </table>
			</td>
			<td width=16></td>
		    <td align=left >
			  <table border=0 cellpadding=0 cellspacing=0 width=100%>
				<tr height=16 class=SectionHeader>
				  <td>
					<table border=0 cellpadding=0 cellspacing=0 >
					    <td class=toolbar width=8></td>
						<% IF strManager = "1" THEN %>          
							<td width=20><a  href="javascript:CheckForm();"><img class="imagelink" src="images/saveitem.gif"></A></td>
										<td class=toolbar valign="middle" >Save and Close</td>
						<% IF strDelOK = "0" THEN %>
					    <td class=toolbar width=8></td><td width=20><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("recID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
						<td class=toolbar valign="middle" >Delete Task</td>
						<%END IF %>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
						<%END IF%>
						<td class=toolbar valign="middle" ><A class=itemfontlink href="ManningTaskDetail.asp?RecID=<%=request("RecID")%>">Back</A></td>											
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
					    <td valign="middle" width=2%></td>
						<td valign="middle" width=14%>Task:</td>
						<td valign="middle" width=81% class=itemfont>
						  <INPUT class="itemfont" style="WIDTH: 200px" maxLength=50 name=task Value="<%=rsRecSet("Task")%>">
						</td>
						<td valign="middle" width=3%></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >Task Type:</td>
						<td valign="middle"  class=itemfont >
						<Select  class="inputbox" Name=TypeID style="width:130px;" >
						<%Do while not rsTaskTypeList.eof%>
						<option value=<%=rsTaskTypeList("ttID")%><%if int(rsRecSet("ttID"))=int(rsTaskTypeList("ttID")) then response.write " selected "%> ><%=rsTaskTypeList("Description")%></option>
						<%rsTaskTypeList.MoveNext
						Loop%>

						</Select>
						</td>
						<td></td>
					  </tr>
					  <!-- Ron 070708 - don't need dates 
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >Start Date:</td>
						<td valign="middle"  class=itemfont >
						
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								
									<tr>
										<td valign=top width=90px>
										<INPUT id="startDate" class="itemfont"  style="Width:75px;"  name="startDate" onDblclick="this.value='';" readonly value = "<%'convertDate (startDate)%>">
										</td>
										<td ><img id="firstDateButton" src="images/cal.gif" onClick="javascript:CalenderScript(CalenderImage,secondDateButton);" style="cursor:hand;"></td>
										<td valign="middle" ></td>
									</tr>
								
							</table>
							
						</td>
						<td></td>
					  </tr>
					
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >End Date:</td>
						<td valign="middle"  class=itemfont >
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								
									<tr>
										<td width=90px>
										<INPUT id="endDate" class="itemfont"  style="Width:75px;"  name="endDate" onDblclick="this.value='';" readonly value = "<%'convertDate (endDate)%>" >
										</td>
										<td><img id="secondDateButton" src="images/cal.gif" onClick="javascript:CalenderScript(CalenderImage2,firstDateButton);" style="cursor:hand;"></td>
										<td valign="middle" ></td>
									</tr>
								
							</table>
						</td>
						<td></td>
					  </tr>
					  -->
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%></td>
						<td valign="middle">Cancellable:</td>
					    <td   class=itemfont><input type="checkbox" name=cancellable value= 1 <%if rsRecSet("cancellable")=true then%>
									 checked
									 <%End if%> >
						
						</td>
					 </tr>	
					 <tr class=columnheading height=22>
					    <td valign="middle" width=2%></td>
						<td valign="middle">Out of Area Task:</td>
					    <td   class=itemfont>
						  <input type="checkbox" name=ooa 
						     <%if rsRecSet("ooa")=true then%>checked<%End if%> >
						
						</td>
					 </tr>	
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%></td>
						<% if strHQTasking = 1 then %>
						  <td valign="middle">HQ Task:</td>
					      <td   class=itemfont>
						   <input type="checkbox" name=hq
						      <%if rsRecSet("hqTask")=true then%>checked<%End if%> >
						</td>
						<% end if %>
					 </tr>	

					  <tr height=16>
						<td></td>
					  </tr>
					  <tr>
       					<td colspan=5 class=titlearealine  height=1></td> 
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
<Div id="CalenderImage" class="CalenderImageAll" style="top:290px;left:450px;">
	<Div  onclick="javascript:InsertCalenderDate(cal,document.all.startDate);CloseCalender(CalenderImage,document.all.secondDateButton);">
		<object  classid="CLSID:8e27c92b-1264-101c-8a2f-040224009c02" id="cal"></object>
	</Div>
	<Div align="center"><Input CLASS="StandardButton" Type=Button Value=Cancel onclick="javascript:CloseCalender(CalenderImage,document.all.secondDateButton);"></Div>
</Div>
<Div id="CalenderImage2" class="CalenderImageAll" style="top:314px;left:450px;">
	<Div  onclick="javascript:InsertCalenderDate(calEndDate,document.all.endDate);CloseCalender(CalenderImage2,document.all.firstDateButton);">
		<object  classid="CLSID:8e27c92b-1264-101c-8a2f-040224009c02" id="calEndDate"></object>
  </Div>
	<Div align="center"><Input CLASS="StandardButton" Type=Button Value=Cancel onclick="javascript:CloseCalender(CalenderImage2,document.all.firstDateButton);"></Div>
</Div>
<%
rsRecSet.close
set rsRecSet=Nothing
con.close
set con=Nothing
%>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">

function CheckForm() {
  var passed=true;
  
  if (document.forms["frmDetails"].elements["task"].value =="") {
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

function findParent(){
	var TypeID = document.getElementById("ttID").value;
	document.getElementById("taskCategoryID").length=0;
	var counter = 0;
	for (i=0;i < ParentArray.length;i++)
	{
		strSplit = ParentArray[i].split("*");
			if (strSplit[0]==TypeID)
			{
				document.getElementById("taskCategoryID").options[counter] = new Option (strSplit[2],strSplit[1]);
				counter++;
			}
	}
}

function CalenderScript(CalImg,disableThis)
	{
	 CalImg.style.visibility = "Visible";
	 disableThis.disabled = true
	 
	 
	 }
function CloseCalender(CalImg,enableThis)
	{
	 CalImg.style.visibility = "Hidden";
	 enableThis.disabled=false;
	 //alert (document.all.firstDateButton.disabled)
	 
	}
function InsertCalenderDate(Calender,SelectedDate)
	{

	str=Calender.value
	document.forms["frmDetails"].elements["HiddenDate"].value = str
	whole = document.forms["frmDetails"].elements["HiddenDate"].value
	day = document.forms["frmDetails"].elements["HiddenDate"].value.substring (8,10)
	day.replace (" ","")
	month = document.forms["frmDetails"].elements["HiddenDate"].value.substring (4,7)
	strlength = document.forms["frmDetails"].elements["HiddenDate"].value.length
	year = document.forms["frmDetails"].elements["HiddenDate"].value.substring (strlength-4,strlength)

	SelectedDate.value = day + " " + month + " " + year
	}	
	
function checkDelete(){
     var delOK = false 
    
	  var input_box = confirm("Are you sure you want to delete this Record ?")
	  if(input_box==true) {
		    delOK = true;
	    }
    return delOK;
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
