<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
tab=5
strTable = "tblstaff"
strGoTo = "AdminPeRsList.asp"   ' asp page to return to once record is deleted
strTabID = "staffID"              ' key field name for table        
strRecid = "staffID"
strCommand = "spPeRsFitnessSummary"

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

objCmd.CommandText = "spFitnessAvailable"	'Name of Stored Procedure
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

'newTodaydate= splitDate(0) + " " + theMonth + " " + splitDate(2)
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

<form action="AddFitness.asp" method="post" name="frmDetails">
    <input type=hidden name=staffID id="staffID" value=<%=request("staffID")%>>
	<input name="hiddenChange" id="hiddenChange" type="hidden" value="">
	<input name="newattached" id="newattached" type="hidden" value="">
	<input name="newdatesattached" id="newdatesattached"  type="hidden" value="">
	<input name="newcompetentattached" id="newcompetentattached" type="hidden" value="">
	<Input Type="Hidden" name="HiddenDate" id="HiddenDate"/>
	<input type="hidden" name="ReturnTo" id="ReturnTo" value="hierarchyPersFitnessAdd.asp">
	<input name="newexpirydateattached" id="newexpirydateattached" type="hidden" value="">


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
						<td height="25px" width=20><a href="javascript:saveNew();"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td height="25px" valign="middle" id="btnSave" class=toolbar >Save</td>
						<td height="25px" class=titleseparator valign="middle" width=14 align="center">|</td>
						<td height="25px" class=toolbar valign="middle"><A class=itemfontlink href="HierarchyPeRsFitness.asp?staffID=<%=request("staffID")%>&thisDate=<%=request("thisDate")%>">Back</A></td>											
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
                    <tr class=columnheading>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Service No:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("serviceno")%></td>
                        <td align="left" width="13%" height="22px">Known as:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("knownas")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Rank:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("rank")%></td>
                        <td align="left" width="13%" height="22px">Trade:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("trade")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Post:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("post")%></td>
                        <td align="left" width="13%" height="22px">Unit:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("unit")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
         
					<tr class=columnheading> 
						<td align="left" width="2%" height="22px">&nbsp;</td>
						<td align="left" width="13%" height="22px">Remedial:</td>
						<td align="left" width="25%" height="22px" class=itemfont><input type="checkbox" <%if rsRecSet("remedial") = true then response.write " checked "%> name=remedial id="remedial" value=1 onClick="frmDetails.exempt.checked=false; RemedialExempt();"></td>
						<td align="left" width="13%" height="22px">Exempt:</td>
						<td align="left" width="25%" height="22px" class=itemfont><input type="checkbox" <%if rsRecSet("exempt") = true then response.write " checked "%> name=exempt id="exempt" value=1 onClick="frmDetails.remedial.checked=false; RemedialExempt();"></td>
						<td align="left" width="22%" height="22px">&nbsp;</td>
					</tr>
					<tr class=columnheading> 
						<td align="left" width="2%" height="22px">&nbsp;</td>
						<td align="left" width="13%" height="22px">Expiry Date:</td>
						<td id="reDate" align="left" width="25%" height="22px" class=itemfont><% if rsRecSet("remedial") = true and rsRecSet("expiryDate") <> "" then %><%= rsRecSet("expiryDate") %><% else %>-<% end if %></td>
						<td align="left" width="13%" height="22px">Expiry Date:</td>
						<td id="exDate" align="left" width="25%" height="22px" class=itemfont><% if rsRecSet("exempt") = true and rsRecSet("expiryDate") <> "" then %><%= rsRecSet("expiryDate") %><%else %>-<% end if %></td>
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
                                    <td width="30%" align="left" height="25px"><b><u>Fitness Types</u></b> Held</td>
                                    <td width=10% align="center" height="25px">Valid From</td>
                                    <td width=10% align="center" height="25px">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan=3 height="22px">&nbsp;</td>
                                </tr>
								<% set rsRecSet = rsRecSet.nextrecordset %>
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
                                                <td height="25px" align="left">Fitness Currencies Available</td>
                                                <td height="25px">&nbsp;</td>
                                                <td height="25px" align="left">Fitness Currencies to Add</td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" height="20">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="ColorBackground">
													<select name="lstAttached" size="10" multiple class="pickbox" style="width:180px;" id="lstAttached" onChange="remAttached()">
														<% if not rsMSAvailableList.bof and not rsMSAvailableList.eof then %>
															<% do while not rsMSAvailableList.eof %>
																<option value=<%= rsMSAvailableList("Fitnessid") %>><%= rsMSAvailableList("Description") %></option>
																<% rsMSAvailableList.movenext() %>
															<% loop %>
														<% end if %>
													</select>
                                                </td>
                                                <td>&nbsp;</td>
                                                <td>
                                                    <select name="pickAttached" size="10" class="pickbox" style="width:180px;" id="pickAttached" onChange="addAttached()"> </select>
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
    <!--<div id="container">-->
        <div id="PopUpwindow1" class="PopUpWindow" align="center">
            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                <tr height=22>
                    <td class=MenuStyleParent colspan=4 align="center"><u>Confirm Fitness Details</u></td>
                </tr>
                <tr>
                    <td colspan="4" height="22px">&nbsp;</td>
                </tr>
                <tr class=columnheading>
                    <td width="20%">&nbsp;</td>
                    <td align="left" height="22px">Qualification:</td>
                    <td align="left" height="22px" class=toolbar><div id="QName"></div></td>
                    <td width="20%">&nbsp;</td>
                </tr>
                <tr class=columnheading>
                    <td width="20%">&nbsp;</td>
                    <td align="left" height=22px>Valid From:</td>
                    <td align="left" height=22px class=itemfont> 
                        <input name="DateAttained" type="text" id="DateAttained" class=" itemfontEdit inputboxEdit" style="Width:85px;"  value ="<%=newTodaydate%>" readonly onclick="calSet(this)">&nbsp;
                        <img src="images/cal.gif" alt="Calender" onclick="calSet(DateAttained)" align="absmiddle" style="cursor:hand;">
                    </td>
                    <td width="20%">&nbsp;</td>
                </tr>
                <% if request("QTypeID")=2  then %>
                    <tr class=columnheading>
                        <td width="20%">&nbsp;</td>
                        <td align="left" height=22px>Competent:</td>
                        <td align="left" height=22px class=itemfont>
                            <select class="itemfont" name=Competent id="Competent">
                                <option value=A>A</option>
                                <option value=B>B</option>
                                <option value=C>C</option>
                                <option value=N selected>N</option>
                            </select>
                        </td>
                        <td width="20%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="4" height=22>&nbsp;</td>
                    </tr>
                <% else %>
                    <tr class=columnheading>
                        <td width="10%">&nbsp;</td>
                        <td align="right" height=22px></td>
                        <td align="left" height=22px class=itemfont><input type=hidden name=Competent id="Competent" value=N></td>
                        <td width="10%">&nbsp;</td>
                    </tr>
                <% end if %>
                <tr>
                    <td height=22px align="center" colspan=4><Input CLASS="StandardButton" Type=Button style="width:60px;" Value=OK onclick="javascript:populateDateArray('DateAttained');"></td>
                </tr>
                <tr>
                    <td height=22px colspan=4>&nbsp;</td>
                </tr>
            </table>
        </div>
         <div id="PopUpwindow2" class="PopUp">
            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                <tr height=22>
                    <td class=MenuStyleParent colspan=2 align="center"><div id="Title"></div></td>
                </tr>
                <tr>
                    <td colspan="2" height="22px">&nbsp;</td>
                </tr>
                <tr class=columnheading>
                    <td colspan="2" valign="middle" height="22px"><div id=Note></div></td>
                </tr>
                <tr>
                    <td colspan="2" height="22px">&nbsp;</td>
                </tr>
                <tr class=columnheading>
                    <td align="right" height=22px width=38%>Expiry Date:</td>
                    <td align="left" height=22px width=62% class=itemfont> 
                        <input name="expirydate" type="text" id="expirydate" class=" itemfontEdit inputboxEdit" style="Width:85px;"  value ="<%=newTodaydate%>" readonly onclick="calSet(this)">&nbsp;
                        <img src="images/cal.gif" alt="Calender" onclick="calSet(expirydate)" align="absmiddle" style="cursor:hand;">
                    </td>
                </tr>
                <tr>
                    <td colspan="2" height=22px>&nbsp;</td>
                </tr>
                <tr>
                    <td height=22px align="center" colspan=2><Input CLASS="StandardButton" Type=Button style="width:60px;" Value=OK onclick="javascript:populateDateExpiry();"></td>
                </tr>
                <tr>
                    <td height=22px colspan=2>&nbsp;</td>
                </tr>
          </table>
      </div>
       
    <!--</div>-->
  </form>
</body>
</html>


<script type="text/javascript" src="calendar.js"></script>

<script language="javascript">

var DateAttainedArray = new Array();
var CompetentArray = new Array();
CurrentDateArray = 0;

function remAttached()
{
	/* we've clicked on an Attachment to REMOVE it */
	frmDetails.remedial.checked=false
	frmDetails.exempt.checked=false
	var list, field, location, picked, txt;
	var newattached;
		
	list = document.forms['frmDetails']['pickAttached'];        /* list of Sections to REMOVE */
	location = document.forms['frmDetails']['lstAttached'];     /* list of Sections that can be REMOVED */
	var optArr = document.frmDetails.lstAttached.options;

	/* this is the value for the assigned list */
	for(x=0;x<optArr.length;x++){
		if(optArr[x].value == location.value){
			var obj = optArr[x];
		}
	}
    var txt = obj.innerHTML;
	document.frmDetails.hiddenChange.value = "true";
	
	list.options[list.options.length] = new Option(txt,obj.value,false); /* true would select it */
    obj.parentNode.removeChild(obj);

	
	/* if we just clicked on last entry don't try to assign focus - cos theres nowt there */
	if(document.frmDetails.lstAttached.options.length != 0)
	{
		document.frmDetails.lstAttached[0].focus();
	}

	document.frmDetails.remedial.disabled=true;
	document.getElementById('reDate').innerHTML = '-';
	document.frmDetails.exempt.disabled=true;
	document.getElementById('exDate').innerHTML = '-';
	document.frmDetails.lstAttached.disabled=true;
	document.frmDetails.pickAttached.disabled=true;
	document.getElementById('DateAttained').value = "<%=newTodaydate%>";
	//document.frmRon.DateAttained.value = "<%=newTodaydate%>";
	document.getElementById('PopUpwindow1').style.visibility = "Visible";
	document.getElementById('QName').innerHTML=txt;
}

function populateDateExpiry()
{
	document.frmDetails.newexpirydateattached.value = document.getElementById('expirydate').value;
	if(frmDetails.remedial.checked==true)
	{
		document.getElementById('reDate').innerHTML = document.getElementById('expirydate').value;
	}
	else if(frmDetails.exempt.checked==true)
	{
		document.getElementById('exDate').innerHTML = document.getElementById('expirydate').value;
	}
	PopUpwindow2.style.visibility = 'hidden';
	document.frmDetails.remedial.disabled=false;
	document.frmDetails.exempt.disabled=false;
	document.frmDetails.lstAttached.disabled=false;
	document.frmDetails.pickAttached.disabled=false;	
}

function populateDateArray(DateAttained)
{
	competent=document.all["Competent"].value
	PopUpwindow1.style.visibility = 'Hidden';
	CompetentArray[CurrentDateArray] = competent;
	dateStr=document.all[DateAttained].value;
	DateAttainedArray[CurrentDateArray] = dateStr;
	CurrentDateArray++;
	document.frmDetails.lstAttached.disabled=false;
	document.frmDetails.pickAttached.disabled=false;
	document.all["Competent"].selectedIndex=3;
	
	//alert("Date Array");
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
	var optArr = document.frmDetails.pickAttached.options;
	
	for(x=0;x<optArr.length;x++){
		if(optArr[x].value == location.value){
			var obj = optArr[x];
		}
	}

	var txt = obj.innerHTML;

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
	document.frmDetails.pickAttached.selectedIndex=-1
	
	/* There is nothing picked to remove - so make sure change flag is unset */
    if(document.frmDetails.pickAttached.options.length == 0)
	{
		document.frmDetails.hiddenChange.value = "";
		document.frmDetails.remedial.disabled=false;
		document.frmDetails.exempt.disabled=false;
	}

}

function RemedialExempt()
{
	
	var title, txt;
	
	if(frmDetails.remedial.checked==true)
	{
		title = "Confirm Remedial Details";
		txt = "Ticking Remedial will remove any existing Fitness types held.";
		PopUpwindow1.style.visibility = "hidden";
		PopUpwindow2.style.visibility = "Visible";
		Title.innerHTML = title;
		document.getElementById('Title').style.textDecoration = "underline";
		Note.innerHTML = txt;
		document.getElementById('Note').style.color = "Red";
		document.getElementById('expirydate').value = "<%'=newTodaydate%>";
		document.frmDetails.remedial.disabled=true;
		document.frmDetails.exempt.disabled=true;
		document.getElementById('exDate').innerHTML = '-';
		document.frmDetails.lstAttached.disabled=true;
		document.frmDetails.pickAttached.disabled=true;
	}
	else if(frmDetails.exempt.checked==true)
	{
		title = "Confirm Exempt Details";
		txt = "Ticking Exempt will remove any existing Fitness types held.";
		PopUpwindow1.style.visibility = "hidden";
		PopUpwindow2.style.visibility = "Visible";
		Title.innerHTML = title;
		document.getElementById('Title').style.textDecoration = "underline";
		Note.innerHTML = txt;
		document.getElementById('Note').style.color = "Red";
		document.getElementById('expirydate').value = "<%'=newTodaydate%>";
		document.frmDetails.remedial.disabled=true;
		document.frmDetails.exempt.disabled=true;
		document.getElementById('reDate').innerHTML = '-';
		document.frmDetails.lstAttached.disabled=true;
		document.frmDetails.pickAttached.disabled=true;
	}	
	
}

/* clicked the SUBMIT button - so write the changes to the database */
function saveNew()
{	
  //alert("save new");
  
	if(frmDetails.remedial.checked==true)
	{
		frmDetails.action ="addRemedial.asp"
		frmDetails.submit();
	}
	else if(frmDetails.exempt.checked==true)
	{
		frmDetails.action ="addExempt.asp"
		frmDetails.submit();
	}
	else
	{
		if(PopUpwindow1.style.visibility=="visible")
		{
			return;
		}
		else if(PopUpwindow2.style.visibility=="visible")
		{
			return
		}
		else 
		{	
			var list, field, location, current;
			var newattached;
			var errMsg = "";
		
			/* not picked any so ignore submit */		
			if(document.frmDetails.hiddenChange.value == "")
			{
				errMsg += "Select Fitness Type Available";
				document.frmDetails.lstAttached.focus(); 
			}
	
			/* now build the section list - if any - to be removed */
			if(document.frmDetails.pickAttached.options.length != 0)
			{
				list = document.frmDetails.pickAttached.value;
		
				/* now build hidden value with list of Locations to submit so the program writelocations can update database */
				newattached = document.frmDetails.pickAttached[0].value; 
				newdatesattached = DateAttainedArray[0]; 
				newcompetentattached = CompetentArray [0];
	
				for(var i = 1; i < document.frmDetails.pickAttached.options.length; i++)
				{
					newattached = newattached + "," + document.frmDetails.pickAttached[i].value
					newdatesattached = newdatesattached + "," + DateAttainedArray[i]
					newcompetentattached = newcompetentattached + "," + CompetentArray [i];
				}
				document.frmDetails.newattached.value = newattached;
				document.frmDetails.newdatesattached.value = newdatesattached;
				document.frmDetails.newcompetentattached.value = newcompetentattached;
			}
	
			if(!errMsg=="")
			{
				alert(errMsg)
				return;	  		
			} 
			
			//alert("Save now " + document.frmDetails.newattached.value + " * " + document.frmDetails.newdatesattached.value + " * " + document.frmDetails.newcompetentattached.value);
	
			document.frmDetails.hiddenChange.value = "";
			document.frmDetails.submit();  
		}
	}
}

</script>
<script lanuage="javascript">

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