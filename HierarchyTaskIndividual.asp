<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
teamID = request("teamID")
dim strAction
dim strFrom
dim strGoTo

strAction="Update"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3	
objCmd.CommandType = 4

' 'first find out whether its an HQ Tasking Group - cos if it is then we display HQ Task details
'strCommand = "spCheckHqTask"
'objCmd.CommandText = strCommand		
'
'set objPara = objCmd.CreateParameter ("StaffID",3,1,0, session("StaffID"))
'objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("HQTasking",3,2)
'objCmd.Parameters.Append objPara
'objCmd.Execute	             ' 'Execute CommandText when using "ADODB.Command" object
'strHQTasking   = objCmd.Parameters("HQTasking") 
'	
'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next
	
objCmd.CommandText = "spPersDetailByStaffID"			
set objPara = objCmd.CreateParameter ("staffID",200,1,16, request("staffID"))
objCmd.Parameters.Append objPara
set rsPersDetails = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

' now we want to set the access level for managers
' if its HQ Tasking (RAF Police system only) then we only allow Out of Area (OOA) tasking at
' HQ Administrator level otherwise any manager is allowed to task
' set default to allow NO managers to Task OOA
strShowOOA=0

if request("ttID") <> 0 then
	strCommand = "spTaskSearchResults"
	objCmd.CommandText = strCommand
	objCmd.CommandType = 4		
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
	objCmd.Parameters.Append objPara

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
	set objPara = objCmd.CreateParameter ("showOOA",3,1,0, strShowOOA)
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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<form action="" method="post" name="frmDetails" onSubmit="javascript:return(CheckForm());">
    <Input name="staffID" id="staffID" type="hidden" value=<%=request("staffID")%>>
    <Input name="RecID" id="RecID" type="hidden" >
    <Input name="ttID" id="ttID" type="hidden" value=<%=request("ttID")%>>
    <input name="ReturnTo" id="ReturnTo" type="hidden"  value="ManningTaskPersonnel.asp">
    <Input name="HiddenDate" id="HiddenDate" type="hidden" >
    
    <table width=100% border=0 cellpadding=0 cellspacing=0>
        <!--include file="Includes/hierarchyTaskDetails.inc"--> 
        <tr>
            <td colspan=10 class=titlearealine  height=1></td> 
        </tr>
        <tr  height=16px class=SectionHeader>
            <td>
                <table border=0 cellpadding=0 cellspacing=0 >
                    <tr valign=top class=toolbar >
                        <td height="25" class=toolbar width=8>
                        <td height="25" width=20px><img id="SaveCloseLink" class="imagelink" src="Images/editgrid.gif" width="16" height="16" onClick="saveNew();"></td>
                        <td height="25" class=toolbar valign="middle" >Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
                        <td height="25" class=toolbar valign="middle" ><A class=itemfontlink href="javascript:window.parent.refreshIframeAfterDateSelect('HierarchyTaskingView.asp');">Cancel</A></td>											
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
                                    <td><span style="color:#F00;font-weight: bold; font-size:12px">NOTES: Enter Task Details Here</span></td>
                                </tr>
                                <tr>
                                    <td><textarea cols="20" rows="5" name="notes" id="notes"  class="itemfont" style="width:210px;" ></Textarea></td>
                                </tr>
                            </table>					
                       </td>
                      <td rowspan=5></td>
                    </tr>				
                    <tr height=26>
                        <td valign="middle" width=2%></td>
                        <td valign="middle" class=columnheading>Task:</td>
                        <td valign="middle" class=itemfont>
                            <%if request("ttID") <> 0 then%>
                                <% arraycount=1	%>
                                <select onChange="checkSlot(this)" class="itemfont" name="slrecID" id="slrecID" style="width:320px;" >
                                <option value="0" selected>...Select</option>
                                <%Do while not rsTaskList.eof%>
                                    <%'if rsTaskList("Task")<>"Course" and rsTaskList("Task")<>"501" then%>
                                        <option value="<%=rsTaskList("taskID") & "," & rsTaskList("ooa")%>" ><%=rsTaskList("Task")%></option>
                                        <%arraycount=arraycount+1
                                   ' end if
									%>
                                <%                            
                                rsTaskList.MoveNext
                                Loop%>
                                </select>
                            <%else%>
                                <Select  class="itemfont" Name="Task" id="Task" style="width:320px;">
                                <%Do while not rsCategoryList.eof%>
                                    <option  value="<%=rsCategoryList("Description")%>" ><%=rsCategoryList("Description")%></option>
                                    <%rsCategoryList.MoveNext
                                Loop%>
                                </Select>
                            <%end if%>
                        </td>
                    </tr>
                    <tr class=columnheading height=26>
                        <td valign="middle" ></td>
                        <td valign="middle">Specify Dates:</td>
                        <td valign="middle" class=itemfont >
                            <table border=0 cellpadding=0 cellspacing=0 >
                                <tr>
                                    <td valign="middle" >
                                        <table border=0 cellpadding=0 cellspacing=0 >
                                            <tr>
                                                <td valign=top colspan="2"> 
                                                    <input name="startDate" type="text" id="startDate" class="itemfont" style="Width:75px;"  readonly onClick="calSet(this)">
                                                    <img src="Images/cal.gif" alt="Calender" align="absmiddle" onClick="calSet(startDate)">
                                                </td>  
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="10px"></td>
                                    <td valign="middle" >
                                        <table border=0 cellpadding=0 cellspacing=0 >
                                            <tr>
                                                <td class=columnheading>To:&nbsp;</td>
                                                <td valign=top> 
                                                    <input name="endDate" type="text" id="endDate" class="itemfont" style="Width:75px;"  readonly onClick="calSet(this)">
                                                    <img src="Images/cal.gif" alt="Calender" align="absmiddle" onClick="calSet(endDate)">
                                                </td>  
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
        <tr>
            <td height=22>&nbsp;</td>
        </tr>
        <tr>
            <td colspan=6 class=titlearealine  height=1></td> 
        </tr>
        <tr valign="middle" height=16px class=SectionHeader>
            <td>
                <table border=0 cellpadding=0 cellspacing=0 >
                    <tr valign="middle" class=toolbar >
                        
                        <td class=toolbar width=8></td><td class=toolbar valign="middle">Individual To Task</td>											
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

</body>
</html>


<script type="text/javascript" src="calendar.js"></script>

<script language="javascript">

var startDateArray = new Array();
var endDateArray = new Array();

var thisDate = window.parent.frmDetails.startDate.value;
var homeString ='javascript:refreshIframeAfterDateSelect("ManningTeamPersonnel.asp");'

window.parent.crumbTrail.innerHTML="<A title='' href='index.asp' class=itemfontlinksmall >Home</A> > <A title='' href='" + homeString + "' class=itemfontlinksmall >Personnel</A> > <font class='youAreHere' >Task Individual</font>" 

function CalenderScript(CalImg)
{
	CalImg.style.visibility = "Visible";
}

function CloseCalender(CalImg)
{
	CalImg.style.visibility = "Hidden";
}

function convertMonth(month)
{
	switch(month)
	{
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
<script language="javascript">

function checkSlot()
{
	var sltID=document.getElementById("slrecID").value;
 	var ooa;
	var slot;
  
	// its the Choose Slot option so ignore it
	if(sltID==0)
	{
    	return
	}
  	
	// get the ooa of the task - its true display slot input box	
	var strSplit=sltID.split(",");
	slot=strSplit[0];
	ooa=strSplit[1];
  
	document.frmDetails.RecID.value=slot;
}

function saveNew()
{
	//This function renoves any leading or trailing spaces from a string
	String.prototype.killWhiteSpace = function()
	{
		return this.replace(/\s/g, '');
	};

	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;
	  
	var t = document.frmDetails.slrecID.value;
	t = t.killWhiteSpace();
	var sd = document.getElementById('startDate').value;
	sd = sd.killWhiteSpace();
	var ed = document.getElementById('endDate').value;	
	ed = ed.killWhiteSpace();
	
	var note = document.getElementById('notes').value;
	
	/* make sure they have entered comments for the next stage */
	if(t == 0)
	{
		errMsg += "Task\n"
		error = true;
	}
	
	if (note=="" ){
		
		errMsg += "You Must Enter Task Details in the Notes\n"
		error = true;
	}
	
	if( note.length < 3 ){
		errMsg += "You Must Enter at least 3 characters in the Notes\n"
		error = true;
	}
	
	if(sd == "" || ed == "")
	{
		errMsg += "Specify Dates\n"
		error = true;
	}

	if(error == true)
	{
		alert(errMsg);
		return;	  		
	}
		
	document.frmDetails.action="updateTaskIndividual.asp";
    document.frmDetails.submit();  
}

function InsertCalenderDate(Calender,SelectedDate)
{
	var sDate = document.all.startDate.value
	var eDate = document.all.endDate.value
	
	var intSDate = parseInt(sDate.split("/")[2] + sDate.split("/")[1] + sDate.split("/")[0])
	var intEDate = parseInt(eDate.split("/")[2] + eDate.split("/")[1] + eDate.split("/")[0])
	
	if(intEDate < intSDate)
	{
		alert("End date can not be earlier than start date")
		document.frmDetails.endDate.value = "";
		return
	}
}

</Script>
