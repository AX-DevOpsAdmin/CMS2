<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
tab=4
strTable = "tblstaff"
strGoTo = "AdminPeRsList.asp"   ' asp page to return to once record is deleted'
strTabID = "staffID"              ' key field name for table        '
strRecid = "staffID"
strCommand = "spPeRsMilSkillsSummary"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		


objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("staffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("startDate",200,1,20, request("thisDate"))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.CommandText = "spMSAvailable"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("StaffID",3,1,5, request("staffID"))
objCmd.Parameters.Append objPara
set rsMSAvailableList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

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
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>Personnel Details</title>
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
<body>
<form action="AddMilSkills.asp" method="post" name="frmDetails">
	<input type="hidden" name="staffID" value="<%=request("staffID")%>">
	<input name="hiddenChange" type="hidden" value="">
	<input name="newattached" type="hidden" value="">
	<input name="newexemptattached" type="hidden" id="newexemptattached" value="">
	<input name="newdatesattached" type="hidden" value="">
	<input name="newcompetentattached" type="hidden" value="">
	<Input Type="Hidden" name="HiddenDate">
	<input type="hidden" name="ReturnTo" value="HierarchyPersMSAdd.asp">

	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyStaffDetails.inc"--> 
		<tr>
			<td class=titlearealine  height=1></td> 
		</tr>
		<tr class=SectionHeader>
			<td>
				<table border=0 cellpadding=0 cellspacing=0 >
					<tr>
						<td height="25px" class=toolbar width=8></td>
						<td height="25px" width=20><a  href="javascript:saveNew();"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td height="25px" valign="middle" class=toolbar>Save</td>
						<td height="25px" class=titleseparator valign="middle" width=14 align="center">|</td>
						<td height="25px" class=toolbar valign="middle"><A class=itemfontlink href="HierarchyPeRsMilSkills.asp?staffID=<%=request("staffID")%>&thisDate=<%=request("thisDate")%>">Back</A></td>											
					</tr>
				</table>
			</td>
		</tr>
        <tr>
            <td>
                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr>
                        <td height="22px" colspan=6>&nbsp;</td>
                    </tr>
                    <tr class=columnheading>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">First Name:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("firstname")%></td>
                        <td align="left" width="13%" height="22px">Surname:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("surname")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Service No:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("serviceno")%></td>
                        <td align="left" width="13%" height="22px">Known as:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("knownas")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Rank:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("rank")%></td>
                        <td align="left" width="13%" height="22px">Trade:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("trade")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Post:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("post")%></td>
                        <td align="left" width="13%" height="22px">Unit:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("unit")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan=6 height="22px">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan=6 class=titlearealine height=1></td> 
                    </tr>
                </table>
                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr class=SectionHeader>
                        <td width="2%" align="left" height="25px">&nbsp;</td>
                        <td width="50%" valign="top" height="25px">
                            <table border=0 cellpadding=0 cellspacing=0 width=98%>
                                <tr class="SectionHeader toolbar">
                                    <td width="30%" align="left" height="25px"><b><u>Military Skills</u></b> Held</td>
                                    <td width=10% align="center" height="25px">Valid From</td>
                                    <td width=10% align="center" height="25px">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan=3 height="22px">&nbsp;</td>
                                </tr>
                                <% set rsRecSet=rsRecSet.nextrecordset %>
                                <% if rsRecSet.recordcount > 0 then %>
                                    <% do while not rsRecSet.eof %>
                                        <tr>
                                            <td width="30%" height="22px" align="left" class=toolbar><%= rsRecSet("description") %></td>
                                            <td width="10%" height="22px" align="center" class=toolbar><%= formatDateTime(rsRecSet("ValidFrom"),2) %></td>
                                            <td width="10%" height="22px" align="center" class=toolbar>&nbsp;</td>
                                        </tr>
                                        <% rsRecSet.movenext %>
                                    <% loop %>
                                <% else %>
                                    <tr>
                                        <td colspan="3" height="22px" class="toolbar">None held</td>
                                    </tr>
                                <% end if %>
                            </table>
                        </td>
                        <td width="48%" height="22px" valign="top">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td>
                                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                            <tr class="SectionHeader toolbar">
                                                <td height="25px" align="left">Military Skills Available</td>
                                                <td height="25px">&nbsp;</td>
                                                <td height="25px" align="left">Military Skills to Add</td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" height="20">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="ColorBackground">
                                                    <select name="lstAttached" size="10" multiple class="pickbox" style="width:180px;" id="lstAttached" onChange="remAttached()"> 
                                                        <% if not rsMSAvailableList.bof and not rsMSAvailableList.eof then %>
                                                            <% do while not rsMSAvailableList.eof %>
                                                                <option value=<%= rsMSAvailableList("MSid") & "*" & rsMSAvailableList("Exempt") %>><%= rsMSAvailableList("Description") %></option>
                                                                <% rsMSAvailableList.Movenext() %>
                                                            <% loop %>
                                                        <% end if %>
                                                    </select>
                                                </td>
                                                <td>&nbsp;</td>
                                                <td>
                                                    <select name="pickAttached" size="10" class="pickbox" style="width:180px;" id="pickAttached" onChange="addAttached()">
                                                    </select>
                                                </td>
                                            </tr>
                                        </table>
                            		</td>
                                </tr>
                            </table>
                        </td>
					</tr>
					<tr height=16>
						<td colspan=3></td>
					</tr>
					<tr>
       					<td colspan=3 class=titlearealine  height=1></td> 
     				</tr>
			  	</table>
			</td>
		</tr>
	</table>
</form>

<form name="frmRon">
	<div id="PopUpwindow1" class="PopUpWindow">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr height="22">
				<td colspan="3" class="MenuStyleParent" align="Center"><u>Confirm Military Skill Details</u></td>
			</tr>
            <tr>
            	<td colspan="3" height="22px">&nbsp;</td>
            </tr>
			<tr class="columnheading">
				<td valign="middle" height="22" width="2%"></td>
				<td valign="middle" height="22" width="30%">Military Skill:</td>
				<td valign="middle" height="22" width="68%" class="toolbar"><DIV  id="QName"></DIV></td>
			</tr>
			<tr class="columnheading">
				<td valign="middle" height="22" width="2%"></td>
				<td valign="middle" height="22" width="30%">Valid From:</td>
				<td valign="middle" height="22" width="68%" class="itemfont">
					<input name="DateAttained" type="text" id="DateAttained" class=" itemfontEdit inputboxEdit"  style="Width:85px;"  value ="<%=newTodaydate%>" readonly onclick="calSet(this)">&nbsp;
					<img src="images/cal.gif" alt="Calender" onclick="calSet(DateAttained)" align="middle" style="cursor:hand;"></td>
				</td>
			</tr>
			<tr id="exempt" style="display:none;" class="columnheading">
				<td valign="middle" height="22" width="2%"></td>
				<td valign="middle" height="22" width="30%">Exempt:</td>
				<td valign="middle" height="22" width="68%" class="itemfont"><input type="checkbox" name="chkExempt" id="chkExempt" value="1"></td>
			</tr>
			<% if request("QTypeID")=2  then %>
				<tr class="columnheading" height="22">
					<td valign="middle" width="2%"></td>
					<td valign="middle" width="30%">Competent:</td>
					<td valign="middle" width="68%" class="itemfont">
						<select class="itemfont" name="Competent" id="Competent">
							<option value="A">A</option>
							<option value="B">B</option>
							<option value="C">C</option>
							<option value="N" selected>N</option>
						</select>
					</td>
				</tr>
                <tr>
                	<td colspan="3" height=22>&nbsp;</td>
                </tr>
			<% else %>
				<tr class="columnheading" height="22">
					<td valign="middle" width="2%"></td>
					<td valign="middle" width="30%"></td>
					<td valign="middle" width="68%" class="itemfont"><input type="hidden" name="Competent" id="Competent" value="N"></td>
				</tr>
			<% end if %>
			<tr>
				<td align="center" colspan="3" height="22"><Input CLASS="StandardButton" Type=Button style="width:60px;" Value=OK onclick="javascript:populateDateArray('DateAttained');"></td>
			</tr>
			<tr>
				<td colspan="3" height="22px">&nbsp;</td>
			</tr>
		</table>
	</div>
</form>

</body>
</html>


<script type="text/javascript" src="calendar.js"></script>

<script language="javascript">

var DateAttainedArray = new Array();
var CompetentArray = new Array();
var ExemptArray = new Array();
CurrentDateArray = 0;

function remAttached()
{
    /* we've clicked on an Attachment to REMOVE it */
	var list, field, location, picked, txt;
	var newattached;
		
	list = document.forms['frmDetails']['pickAttached'];        /* list of Sections to REMOVE */
	location = document.forms['frmDetails']['lstAttached'];     /* list of Sections that can be REMOVED */
	//field = document.frmDetails.lstAttached.options.value ;     /* Section selected to REMOVE */
	
	var optArr = document.frmDetails.lstAttached.options;
	
	for(x=0;x<optArr.length;x++){
		if(optArr[x].value == location.value){
			var obj = optArr[x];
		}
	}
    var txt = obj.innerHTML;
	document.frmDetails.hiddenChange.value = "true";

	var strSplit = obj.value.split("*");

	/* This shows the check box if the military skill is exempt*/
	if(strSplit[1] == 1)
	{
		document.getElementById('exempt').style.display = 'block';
	}
	else
	{
		document.getElementById('chkExempt').value = 0;
		document.getElementById('exempt').style.display = 'none';
	}
	
    list.options[list.options.length] = new Option(txt,obj.value,false); /* true would select it */
    obj.parentNode.removeChild(obj);


	/* if we just clicked on last entry don't try to assign focus - cos theres nowt there */
	if(document.frmDetails.lstAttached.options.length != 0)
	{  
	    //alert("new focus");
		document.frmDetails.lstAttached[0].focus();
	}	

   // alert ("pop up is " ); //+ document.getElementById('PopUpwindow1').style.visibility);
	
	document.frmDetails.lstAttached.disabled=true;
	document.frmDetails.pickAttached.disabled=true;
	document.frmRon.DateAttained.value = "<%=newTodaydate%>";
	document.getElementById('PopUpwindow1').style.visibility = "Visible";
	document.getElementById('QName').innerHTML=txt;
}

function populateDateArray(DateAttained)
{
	if(document.getElementById("chkExempt").checked == true)
	{
		ex = 1
	}
	else
	{
		ex = 0
	}
	
	var competent=document.all["Competent"].value;
	document.getElementById('PopUpwindow1').style.visibility = 'Hidden';
	ExemptArray[CurrentDateArray] = ex;
	CompetentArray[CurrentDateArray] = competent;
	var dateStr=document.all[DateAttained].value;
	DateAttainedArray[CurrentDateArray] = dateStr;
	CurrentDateArray++;
	document.frmDetails.lstAttached.disabled=false;
	document.frmDetails.pickAttached.disabled=false;
	document.all["Competent"].selectedIndex=3;
}

/* clicked on assigned list - this will remove entry they clicked from the list and put it back on unassigned list */
function addAttached()
{
	var list, field, location, current;
	var cval, ctxt, cstr;
	var newattached;
	
	var re = /,/; 
	var lstxt= new Array;
	var lsval= new Array;

	list = document.forms['frmDetails']['lstAttached'];      /* Available list */
	location = document.forms['frmDetails']['pickAttached']; /* REMOVE list */
	//field = document.frmDetails.pickAttached.options.value;  /* Entry in REMOVE list they clicked to remove */

	var optArr = document.frmDetails.pickAttached.options;
	
	for(x=0;x<optArr.length;x++){
		if(optArr[x].value == location.value){
			var obj = optArr[x];
		}
	}

	var txt = obj.innerHTML;

    /* now get text from the selected entry so we can replace it in unassigned list 
	var inum = 2000
	for(var i = 0; i < location.options.length; i++)
	{
		if(field == document.frmDetails.pickAttached[i].value)
		{
	    	newattached = document.frmDetails.pickAttached[i].text;
	    	inum = i ;
		}
	}
	*/
	//list.options[list.options.length] = new Option(newattached,field,false); /* true would select it */
   
	list.options[list.options.length] = new Option(txt,obj.value,false); /* true would select it */
	
    var icount = 0;
	for(var i = 0; i < list.options.length; i++)
	{	    
		lsval[icount]= document.frmDetails.lstAttached[i].value;
		lstxt[icount]= document.frmDetails.lstAttached[i].text + "," + document.frmDetails.lstAttached[i].value;
		icount++;
	}

    lsval.sort();
	lstxt.sort();
	for(var i = 0; i < lstxt.length; i ++)
	{
		current = lstxt[i];
		cstr = current.split(re);
		ctxt= cstr[0];
		cval= cstr[1]; 
        document.frmDetails.lstAttached[i].value = cval;
		document.frmDetails.lstAttached[i].text = ctxt;
	}
 
	//document.frmDetails.pickAttached[inum] = null;
	obj.parentNode.removeChild(obj);
	document.frmDetails.pickAttached.selectedIndex=-1;
	
	/* There is nothing picked to remove - so make sure change flag is unset */
    if(document.frmDetails.pickAttached.options.length == 0)
	{
		document.frmDetails.hiddenChange.value = "";
	}
  /*
	for(var i = inum; i < CurrentDateArray; i ++)
	{
		DateAttainedArray[i]=DateAttainedArray[i+1];
		ExemptArray[i]=ExemptArray[i+1];
		CompetentArray[i]=CompetentArray[i+1];
	}
	*/
	
	CurrentDateArray=CurrentDateArray-1;
}

/* clicked the SUBMIT button - so write the changes to the database  via writeGroups.asp */
function saveNew()
{	
	if(document.getElementById('PopUpwindow1').style.visibility=="visible")
	{
		return;
	}
	else
	{
    	var list, field, location, current;
		var newattached;
		var errMsg = "";
	
		/* not picked any so ignore submit */		
		if(document.frmDetails.hiddenChange.value == "")
		{
			errMsg += "Select Military Skills Available";
			document.frmDetails.lstAttached.focus(); 
		}

		/* now build the section list - if any - to be removed */
		if(document.frmDetails.pickAttached.options.length != 0)
		{
			list = document.frmDetails.pickAttached.value;
			/* now build hidden value with list of Locations to submit so the program writelocations can update database */
			id = document.frmDetails.pickAttached[0].value;
			strSplit = id.split("*")
			newattached = strSplit[0]
			newdatesattached = DateAttainedArray[0]; 
			newexemptattached = ExemptArray[0];
			newcompetentattached = CompetentArray [0];
	
			for(var i = 1; i < document.frmDetails.pickAttached.options.length; i++)
			{
				id = document.frmDetails.pickAttached[i].value
				strSplit = id.split("*")
				newattached = newattached + "," + strSplit[0]
				newdatesattached = newdatesattached + "," + DateAttainedArray[i]
				newexemptattached = newexemptattached + "," + ExemptArray[i];
				newcompetentattached = newcompetentattached + "," + CompetentArray [i];
			}
				
			document.frmDetails.newattached.value = newattached;
			document.frmDetails.newexemptattached.value = newexemptattached;
			document.frmDetails.newdatesattached.value = newdatesattached;
			document.frmDetails.newcompetentattached.value = newcompetentattached;
		}

		if(!errMsg=="")
		{
			alert(errMsg)
			return;	  		
		} 

		document.frmDetails.hiddenChange.value = "";
		document.frmDetails.submit();  
	}
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
	var str=Calender.value;
	document.forms["frmDetails"].elements["HiddenDate"].value = str;
	var whole = document.forms["frmDetails"].elements["HiddenDate"].value;
	var day = document.forms["frmDetails"].elements["HiddenDate"].value.substring (8,10);
	day.replace (" ","");
	var month = document.forms["frmDetails"].elements["HiddenDate"].value.substring (4,7);
	var strlength = document.forms["frmDetails"].elements["HiddenDate"].value.length;
	var year = document.forms["frmDetails"].elements["HiddenDate"].value.substring (strlength-4,strlength);
	document.all.DateAttained.value = day + " " + month + " " + year;
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

</script>