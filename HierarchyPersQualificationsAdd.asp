<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
tab=3
strTable = "tblstaff"
strGoTo = "HierarchyPersQualificationsDetails.asp"   ' asp page to return to once record is deleted'
strTabID = "staffID"              ' key field name for table '       
strRecid = "staffID"
strCommand = "spPeRsDetailSummary"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

objCmd.CommandText = strCommand
objCmd.CommandType = 4	
	
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("StaffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("startDate",200,1,20, request("thisDate"))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.CommandText = "spQualificationsTypeDetails"	'Name of Stored Procedure'
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("StaffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TypeID",3,1,5, request("QTypeID"))
objCmd.Parameters.Append objPara

set rsQualificationDetails = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

QtypeID=request("QTypeID")
strAuth=rsQualificationDetails("Auth")

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.CommandText = "spQsAvailable"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("StaffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TypeID",3,1,5, request("QTypeID"))
objCmd.Parameters.Append objPara

set rsQAvailableList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

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

'newTodaydate= splitDate(0) + " " + theMonth + " " + splitDate(2) 
newTodaydate = formatdatetime(date(),2)

QTypeID=request("QTypeID")

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
<form action="AddQualifications.asp" method="post" name="frmDetails">
    <input type=hidden name=recID id="RecID" value=<%=request("recID")%>>
    <input type=hidden name=QTypeID id="QTypeID" value=<%=request("QTypeID")%>>
    <input name="hiddenChange" id="hiddenChange" type="hidden" value="">
    <input name="newattached" id="newattached" type="hidden" value="">
    <input name="newdatesattached" id="newdatesattached" type="hidden" value="">
    <input name="newauthattached" id="newauthattached" type="hidden" value="">
    <input name="newupbyattached" id="newupbyattached" type="hidden" value="">
    <input name="newupdatedattached" id="newupdatedattached" type="hidden" value="">
    <input name="newcompetentattached" id="newcompetentattached"type="hidden" value="">
    <Input Type="Hidden" name="staffID" id="staffID" value="<%=request("staffID")%>">
    <Input Type="Hidden" name="HiddenDate" id="HiddenDate">
    <input type="hidden" name="hiddenAuth" id="hiddenAuth" value="">
    <input type="hidden" name="ReturnTo" id="ReturnTo" value="HierarchyPersQualificationsAdd.asp"/>
    
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyStaffDetails.inc"-->
		<tr>
			<td class=titlearealine  height=1></td> 
		</tr>
		<tr class=SectionHeader>
			<td>
				<table border=0 cellpadding=0 cellspacing=0>
                	<tr>
						<td height="25px" class=toolbar width=8></td>
						<td height="25px" width=20><a href="javascript:saveNew();"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td height="25px" valign="middle" class=toolbar >Save</td>
						<td height="25px" class=titleseparator valign="middle" width=14 align="center">|</td>
						<td height="25px" class=toolbar valign="middle" ><A class=itemfontlink href="HierarchyPersQualificationsDetails.asp?staffID=<%=request("staffID")%>&QTypeID=<%=request("QTypeID")%>&thisdate=<%=request("thisDate")%>">Back</A></td>											
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
                        <td width="2%" valign="middle" height="22px">&nbsp;</td>
                        <td width="13%" valign="middle" height="22px">First Name:</td>
                        <td width="25%" valign="middle" height="22px" class=itemfont><%=rsRecSet("firstname")%></td>
                        <td width="13%" valign="middle" height="22px">Surname:</td>
                        <td width="25%" valign="middle" height="22px" class=itemfont><%=rsRecSet("surname")%></td>
                        <td width="22%" valign="middle" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22px>
                        <td width="2%" valign="middle" height="22px">&nbsp;</td>
                        <td width="13%" valign="middle" height="22px">Service No:</td>
                        <td width="25%" valign="middle" height="22px" class=itemfont><%=rsRecSet("serviceno")%></td>
                        <td width="13%" valign="middle" height="22px">Known as:</td>
                        <td width="25%" valign="middle" height="22px" class=itemfont><%=rsRecSet("knownas")%></td>
                        <td width="22%" valign="middle" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22px>
                        <td width="2%" valign="middle" height="22px">&nbsp;</td>
                        <td width="13%" valign="middle" height="22px">Rank:</td>
                        <td width="25%" valign="middle" height="22px" class=itemfont><%=rsRecSet("rank")%></td>
                        <td width="13%" valign="middle" height="22px">Trade:</td>
                        <td width="25%" valign="middle" height="22px" class=itemfont><%=rsRecSet("trade")%></td>
                        <td width="22%" valign="middle" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22px>
                        <td width="2%" valign="middle" height="22px">&nbsp;</td>
                        <td width="13%" valign="middle" height="22px">Post:</td>
                        <td width="25%" valign="middle" height="22px" class=itemfont><%=rsRecSet("post")%></td>
                        <td width="13%" valign="middle" height="22px">Unit:</td>
                        <td width="25%" valign="middle" height="22px" class=itemfont><%=rsRecSet("unit")%></td>
                        <td width="22%" valign="middle" height="22px">&nbsp;</td>
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
									<td width=30% align="left" height="25px"><b><u><%=rsQualificationDetails("Type")%></u></b> Qualifications Held</td>
									<td width=10% align="center" height="25px">Valid From</td>
									<td width=10% align="center" height="25px"><% if request("QTypeID")=2 then %>Competence<% else %>&nbsp;<% end if %></td>
								</tr>
								<tr>
									<td colspan=3 height="22px">&nbsp;</td>
								</tr>
								<% set rsQualificationDetails=rsQualificationDetails.nextrecordset %>
								<% if rsQualificationDetails.recordcount > 0 then %>
									<% do while not rsQualificationDetails.eof %>
                                        <tr>
                                        	<td width="30%" height="22px" align="left" class=toolbar><%= rsQualificationDetails("description") %></td>
                                        	<td width="10%" height="22px" align="center" class=toolbar><%= formatDateTime(rsQualificationDetails("ValidFrom"),2) %></td>
                                        	<td width="10%" height="22px" align="center" class=toolbar><% if request("QTypeID")=2 then %><%= rsQualificationDetails("competent") %><% end if %></td>
										</tr>
                                        <% rsQualificationDetails.movenext %>
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
                                                <td height="25px" align="left">Qualifications Available</td>
                                                <td height="25px">&nbsp;</td>
												<td height="25px" align="left">Qualifications to Add</td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" height="20">&nbsp;</td>
                                            </tr>
                                            <tr>
                                            	<td class="ColorBackground">
													<select name="lstAttached" size="10" multiple class="pickbox" style="width:180px;" id="lstAttached" onChange="remAttached()"> 
														<% do while not rsQAvailableList.eof %>
                                                            <option value="<%= rsQAvailableList("QID") %>*<%= rsQAvailableList("Auth") %>"><%= rsQAvailableList("Description") %></option>
                                                            <% rsQAvailableList.movenext() %>
                                                        <% loop %>
													</select>
                                                </td>
                                                <td>&nbsp;</td>
                                                <td>
													<select name="pickAttached" size="10" class="pickbox"  style="width:180px;" id="pickAttached" onChange="addAttached()">
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
		<table border=0 cellpadding=0 cellspacing=0 width=100%>
			<tr>
				<td colspan=3 height=22 align="center" class=MenuStyleParent><u>Confirm Qualification Details</u></td>
			</tr>
            <tr>
            	<td colspan="3" height="22px">&nbsp;</td>
            </tr>
			<tr class=columnheading>
				<td valign="middle" height=22 width=2%></td>
				<td valign="middle" height=22 width=30%>Qualification:</td>
				<td valign="middle" height=22 width=68% class=toolbar><DIV  id=QName></DIV></td>
			</tr>
			<tr class=columnheading>
				<td valign="middle" height=22 width=2%></td>
				<td valign="middle" height=22 width=30%>Valid From:</td>
				<td valign="middle" height=22 width=68% class=itemfont> 
					<input name="DateAttained" type="text" id="DateAttained" class="itemfont" style="Width:85px;"  value ="<%=newTodaydate%>" readonly onclick="calSet(this)">&nbsp;
					<img src="images/cal.gif" alt="Calender" onclick="calSet(DateAttained)" align="absmiddle" style="cursor:hand;">
				</td>
			</tr>
            
            <% if strAuth then %>
                <tr id="auth" class="columnheading">
                    <td valign="middle" height="22" width="2%"></td>
                    <td valign="middle" height="22" width="30%">Authorisor:</td>
                    <td valign="middle" height="22" width="68%" class="itemfont"><input type="text" name="txtAuth" id="txtAuth" class="itemfont" style="Width:160px;" value="<%=strAuthBy%>" readonly></td>
                </tr>
			<% else %>
				<tr class=columnheading>
					<td valign="middle" height=22 width=2%></td>
					<td valign="middle" height=22 width=30%></td>
					<td valign="middle" height=22 width=68% class=itemfont></td>
				</tr>
			<% end if %>
           
			<% if request("QTypeID")=2 then %>
				<tr class=columnheading>
					<td valign="middle" height=22 width=2%></td>
					<td valign="middle" height=22 width=30%>Competent:</td>
					<td valign="middle" height=22 width=68% class=itemfont>
					<select class="itemfont" name="Competent" id="Competent">
						<option value=A>A</option>
						<option value=B>B</option>
						<option value=C>C</option>
						<option value=N selected>N</option>
					</select>
					</td>
				</tr>
                <tr>
                	<td colspan="3" height=22>&nbsp;</td>
                </tr>
			<% else %>
				<tr class=columnheading>
					<td valign="middle" height=22 width=2%></td>
					<td valign="middle" height=22 width=30%></td>
					<td valign="middle" height=22 width=68% class=itemfont><input type=hidden name="Competent" id="Competent" value=N></td>
				</tr>
			<% end if %>
			<tr class=columnheading height=22>
				<td align="center" colspan=6><Input CLASS="StandardButton" Type=Button style="width:60px;" Value=OK onclick="javascript:populateDateArray('DateAttained');"></td>
			</tr>
			<tr>
				<td colspan=3 height=22>&nbsp;</td>
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
var AuthArray = new Array();
var UpByArray = new Array();
var UpdatedArray = new Array();
var CurrentDateArray = 0;

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

	
	/* this is the value for the assigned list */
	/* newattached = document.frmAdmin.lstLocation.value + "|" + field;  */
	document.frmDetails.hiddenChange.value = "true";
	
	/*var inum = 2000
	for (var i = 0; i < location.options.length; i++)
	{
		if(field == document.frmDetails.lstAttached[i].value)
		{
	    	inum = i ;
		}
	}*/
	//	 
   // txt=document.frmDetails.lstAttached.options[inum].text;
	var txt = obj.innerHTML;
	
	//strSplit = field.split("*");
	var strSplit = obj.value.split("*");
		
	/* This shows the check box if the military skill is exempt*/
	if(strSplit[1] == 'True')
	{
		//document.getElementById('txtAuth').value = "";
		//document.getElementById('auth').style.display = 'block';
		document.getElementById('hiddenAuth').value = 'True';
	}
	else
	{
		//document.getElementById('txtAuth').value = "";
		//document.getElementById('auth').style.display = 'none';
		document.getElementById('hiddenAuth').value = '';
	}
	
	list.options[list.options.length] = new Option(txt,obj.value,false); /* true would select it */

	//document.frmDetails.lstAttached[inum] = null;
	
	obj.parentNode.removeChild(obj);
	
	/* if we just clicked on last entry don't try to assign focus - cos theres nowt there */
	if(document.frmDetails.lstAttached.options.length != 0)
	{
		document.frmDetails.lstAttached[0].focus();
	}	

	document.frmDetails.lstAttached.disabled=true;
	document.frmDetails.pickAttached.disabled=true;
	document.frmRon.DateAttained.value = "<%=newTodaydate%>";
	document.getElementById('PopUpwindow1').style.visibility = "Visible";
	document.getElementById('QName').innerHTML=txt;
}

function populateDateArray(DateAttained)
{
	var auth = null;
	var upby = null;
	var updated = null;
	var day, month, year;
	var todayDate = new Date();

	day = todayDate.getDate();
	month = todayDate.getMonth() + 1;
	year = todayDate.getFullYear();

    if (document.getElementById("hiddenAuth").value == 'True')
	{
		if(document.getElementById("txtAuth").value == "" )
			{
				alert("Enter Authorised By");
				return;
			}
		else
		//if(document.getElementById("txtAuth").value !== "" )
			{
				auth = document.getElementById('txtAuth').value;
				upby = <%= session("StaffID") %>;
				updated = day + "/" + month + "/" + year;
			}
			
/*			if(document.getElementById("txtAuth").value == ""  && document.getElementById("hiddenAuth").value == 'True')
			{
				alert("Enter Authorised By");
				return;
			}
			
			if(document.getElementById("txtAuth").value !== ""  && document.getElementById("hiddenAuth").value == 'True')
			{
				auth = document.getElementById('txtAuth').value;
				upby = <%= session("StaffID") %>;
				updated = day + "/" + month + "/" + year;
			}
*/	}
	competent=document.all["Competent"].value
	PopUpwindow1.style.visibility = 'Hidden';
	AuthArray[CurrentDateArray] = auth;
	UpByArray[CurrentDateArray] = upby;
	UpdatedArray[CurrentDateArray] = updated;
	CompetentArray[CurrentDateArray] = competent;
	dateStr=document.all[DateAttained].value;
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
	
	re = /,/; 
	lstxt= new Array;
	lsval= new Array;

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
    /* now get text from the selected entry so we can replace it in unassigned list */
	/*var inum = 2000
	for(var i = 0; i < location.options.length; i++)
	{
		if(field == document.frmDetails.pickAttached[i].value)
		{
	    	newattached= document.frmDetails.pickAttached[i].text;
	    	inum = i ;
		}
	}*/
	
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
	
	//alert(1)
	
	document.frmDetails.pickAttached.selectedIndex=-1;
	
	/* There is nothing picked to remove - so make sure change flag is unset */
    if(document.frmDetails.pickAttached.options.length == 0)
	{
		document.frmDetails.hiddenChange.value = "";
	}

    /**
	for(var i = inum; i < CurrentDateArray; i ++)
	{
		DateAttainedArray[i]=DateAttainedArray[i+1];
		AuthArray[i]=AuthArray[i+1];
		UpByArray[i]=UpByArray[i+1];
		UpdatedArray[i]=UpdatedArray[i+1];
		CompetentArray[i]=CompetentArray[i+1];
	}
	**/
	CurrentDateArray=CurrentDateArray-1;
}

/* clicked the SUBMIT button - so write the changes to the database  via writeGroups.asp */
function saveNew()
{	

//prompt("",document.frmDetails.pickAttached.innerHTML )

	if(PopUpwindow1.style.visibility=="visible")
	{
		return;
	}
	else
	{
	    var list, field, location, current;
		var newattached;
		var errMsg = "";
	
		/* not picked any so ignore submit */		
		if (document.frmDetails.hiddenChange.value == "")
		{
			errMsg += "Select Qualifications Available";
			document.frmDetails.lstAttached.focus(); 
		}
	
		/* now build the section list - if any - to be removed */
		if(document.frmDetails.pickAttached.options.length != 0)
		{
			list = document.frmDetails.pickAttached.value;
			/* now build hidden value with list of Locations to submit so the program writelocations can update database */
			id = document.frmDetails.pickAttached[0].value;
			strSplit = id.split("*");
			newattached =  strSplit[0];
			newdatesattached = DateAttainedArray[0];
			newauthattached = AuthArray[0];
			newupbyattached = UpByArray[0];
			newupdatedattached = UpdatedArray[0];
			newcompetentattached = CompetentArray [0];
	
			for(var i = 1; i < document.frmDetails.pickAttached.options.length; i++)
			{
				id = document.frmDetails.pickAttached[i].value
				strSplit = id.split("*")
				newattached = newattached + "," + strSplit[0]
				newdatesattached = newdatesattached + "," + DateAttainedArray[i]
				newauthattached = newauthattached + "," + AuthArray[i]
				newupbyattached = newupbyattached + "," + UpByArray[i]
				newupdatedattached = newupdatedattached + "," + UpdatedArray[i]
				newcompetentattached = newcompetentattached + "," + CompetentArray [i];
			}
			
			document.frmDetails.newattached.value = newattached;
			document.frmDetails.newdatesattached.value = newdatesattached;
			document.frmDetails.newauthattached.value = newauthattached;
			document.frmDetails.newupbyattached.value = newupbyattached;
			document.frmDetails.newupdatedattached.value = newupdatedattached;
			document.frmDetails.newcompetentattached.value = newcompetentattached;
		}
		
		//alert("newattached= "+newattached+' \n'+"newdatesattached= "+newdatesattached+' \n'+"newauthattached= "+newauthattached+' \n'+"newupbyattached= "+newupbyattached+' \n'+"newupdatedattached= "+newupdatedattached+' \n'+"newcompetentattached= "+newcompetentattached)
	
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
		str=Calender.value
		document.forms["frmDetails"].elements["HiddenDate"].value = str
		DateAttained.value = str
	}	
	
</script>
<script language="javascript">

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

</script>

