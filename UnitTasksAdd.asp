<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%

' sets date to UK format - dmy
session.lcid=2057

dim strAction
dim strFrom
dim strGoTo
dim strOOA
dim strtoday

strtoday=Date()
strAction="Update"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
set objPara = objCmd.CreateParameter ("TaskID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
objCmd.CommandText = "sp_TaskDetail"	'Name of Stored Procedure'
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

strOOA = rsRecSet("ooa")

 ' RAFP - If its HQTASK (RAFP log-on ) and OOA then prompt for Task Slot
if rsRecSet("HQTask") = true and strOOA = 1 then
	strSlot = 1
else
	strSlot = 0
end if    
 
if request("page")<>"" then
	page=int(request("page"))
else
	page=1
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

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

' Get the Team List
objCmd.CommandText = "spListTeams"
objCmd.CommandType = 4		
set rsTeamList = objCmd.Execute

%>	
	
<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%=pageTitle%></title>
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
.style2 {color: #FFFFFF}
.style3 {color: #FF0000}
-->
</style>

</head>
<body >
<form action="" method="post" name="frmDetails">
<Input name="RecID" type="hidden" value=<%=request("RecID")%>>
<input name="newattached" type="hidden" value="">
<input name="ReturnTo" type="hidden"  value="UnitTasks.asp">
<input name="currentlyChecked" type=hidden value=<%=request("currentlyChecked")%>>
<input name="hiddenChange" type="hidden" value="">
<Input name="HiddenDate" type="hidden" >

<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
	<tr>
     	<td>
        	<!--#include file="Includes/Header.inc"-->
            <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                <tr style="font-size:10pt;" height=26px>
                    <td width=10px>&nbsp;</td>
                    <td><A title="" href="index.asp" class=itemfontlinksmall >Home</A> > <A title="" href="ManningTaskSearch.asp" class=itemfontlinksmall >Tasking</A> > <A title="" href="ManningTask.asp?RecID=<%=request("RecID")%>" class=itemfontlinksmall >Task</A> > <A title="" href="UnitTasks.asp?RecID=<%=request("RecID")%>" class=itemfontlinksmall >Tasked Units</A> > <font class="youAreHere" >Add Unit</font></td>
                </tr>
                <tr>
	                <td colspan=2 class=titlearealine  height=1></td> 
                </tr>
            </table>
  			<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0>
      	  		<tr valign=Top>
            		<td class="sidemenuwidth" background="Images/tableback.png">
			  			<table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
                            <tr height=22>
                            	<td>&nbsp;</td>
                                <td colspan=3 align=left height=20>Current Location</td>
                            </tr>
                            <tr height=22>
                                <td width=10>&nbsp;</td>
                                <td width=18 valign=top><img src="images/arrow.gif"></td>
                                <td width=170 align=Left><A title="" href="index.asp">Home</A></td>
                                <td width=50 align=Left></td>
                            </tr>
                            <tr height=22>
                                <td>&nbsp;</td>
                                <td valign=top><img src="images/arrow.gif"></td>
                                <td align=Left><A title="" href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=">Tasking</a></td>
                                <td align=Left></td>
							</tr>
                            <tr height=22>
                                <td>&nbsp;</td>
                                <td valign=top><img src="images/arrow.gif"></td>
                                <td align=Left><A title="" href="ManningTask.asp?RecID=<%=request("RecID")%>">Task</a></td>
                                <td align=Left>&nbsp;</td>
                            </tr>
                            <tr height=22>
                                <td>&nbsp;</td>
                                <td valign=top><img src="images/vnavicon.gif"></td>
                                <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Task Units</Div></td>
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
										<td width=20><img src="images/editgrid.gif" width="17" class="imagelink" id="SaveCloseLink" onclick="saveNew();"></td>
										<td class=toolbar valign="middle">Save and Close</td>
                                        <td class=titleseparator valign="middle" width=14 align="center">|</td>
										<td class=toolbar valign="middle"><a class=itemfontlink href="UnitTasks.asp?RecID=<%=request("recID")%>">Back</a></td>										
									</table>
								</td>
							</tr>
							<tr>
                                <td>
                              		<table width=100% border=0 cellpadding=0 cellspacing=0>
                                        <tr height=16>
                                            <td colspan="5">&nbsp;</td>
                                        </tr>
                                        <tr class=columnheading height=22>
                                            <td valign="middle" width=2%>&nbsp;</td>
                                            <td valign="middle" width=13%>Task:</td>
                                            <td valign="middle" width="34%" class=itemfont><%=rsRecSet("Task")%></td>
                                            <td width="56%" colspan="2" rowspan=6 valign=top>
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="245" class=columnheading>Notes:</td>
                                                    </tr>
                                                    <tr>
                                                        <td><textarea cols="20" rows="5" name="notes" class="itemfont" style="width:210px;" ><%=request("notes")%></textarea></td>
                                                    </tr>
                                                </table>                                
                                            </td>
                                        </tr>
                                        <tr class=columnheading height=22>
                                            <td valign="middle" width=1%></td>
                                            <td valign="middle" width="9%">Task Type:</td>
                                            <td colspan="3" valign="middle" class=itemfont><%=rsRecSet("Type")%></td>
                                        </tr>
                                        <tr class=columnheading height=22>
                                            <td valign="middle" width=1%></td>
                                            <td valign="middle" width="9%">Cancellable:</td>
                                            <td colspan="3" valign="middle" class=itemfont>
                                                <% if rsRecSet("cancellable") = true then %>
                                                    Yes
                                                <% else %>
                                                    No
                                                <% end if %> 
                                            </td>
                                        </tr>	
                                        <tr class=columnheading height=22>
                                            <td valign="middle" width=1%></td>
                                            <td valign="middle">Specify Dates:</td>
                                            <td colspan="3" valign="middle" class=itemfont>
                                                <table border=0 cellpadding=0 cellspacing=0 >
                                                    <tr>											
                                                        <td><input name="startDate" type="text" id="startDate" class="itemfont"  style="Width:75px;"  value ="<%=request("startDate")%>" readonly  onclick="getStart(this)">&nbsp;<img src="images/cal.gif" alt="Calender" align="absmiddle" onclick="getStart(startDate)" style="cursor:hand;"></td>
                                                        <td width="10px"></td>
                                                        <td><input name="endDate" type="text" id="endDate" class="itemfont"  style="Width:75px;"  value ="<%=request("endDate")%>" readonly onclick="calSet(this)">&nbsp;<img src="images/cal.gif" alt="Calender" align="absmiddle" onclick="calSet(endDate)" style="cursor:hand;"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>								  
                                        <tr height=16>
                                            <td colspan="5">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=5 class=titlearealine  height=1></td> 
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr height=16 class=SectionHeader>
                                <td>
                                    <table width="100%" border=0 cellpadding=0 cellspacing=0>
                                        <tr>
                                            <td valign="middle" width="1%">&nbsp;</td>
                                            <td valign="middle" width="99%" class=toolbar>Units To Task:</td>
                                        </tr>
                                    </table>
                                    <table width="100%" border=0 cellpadding=0 cellspacing=0>
                                    	<tr>
                                        	<td colspan="5">&nbsp;</td>   
										</tr>
                                        <tr>
                                        	<td width="34%">&nbsp;</td>
                                            <td width="20%" class="columnheading">Available Units:</td>
                                            <td width="8%" rowspan="2">&nbsp;</td>
                                            <td width="20%" class="columnheading">Tasked Units:</td>
                                            <td width="34%">&nbsp;</td>
                                        </tr>
                                        <tr class="columnheading">
                                        	<td width="28%" valign="middle">&nbsp;</td>
                                        	<td width="20%" valign="middle">                                            
                                            	<select name="cboUnitAvailable" size="10" class="pickbox" id="cboUnitAvailable" style="width: 180px" onChange="addAttached()">
												<%do while not rsTeamList.eof%>
													<option value=<%=rsTeamList("teamID")%>><%=rsTeamList("description")%></option>
													<%rsTeamList.movenext%>
												<%loop%>
                                                </select>
                                          </td>
                                            <td width="20%" valign="middle">                                            
                                            	<select name="cboUnitTasked" size="10" class="pickbox" id="cboUnit" style="width: 180px" onChange="remAttached()">
                                                </select>
                                   		  </td>
                                            <td width="28%" valign="middle">&nbsp;</td>
                                        </tr>
                                        <tr height=16>
                                            <td colspan="5">&nbsp;</td>
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


<script type="text/javascript" src="calendar.js"></script>

<script language="JavaScript">

function InsertCalenderDate(Calender,SelectedDate)
	{
	var stDate = document.all.startDate.value
	var enDate = document.all.endDate.value
	
	var intSTDate = parseInt(stDate.split("/")[2] + stDate.split("/")[1] + stDate.split("/")[0])
	var intENDate = parseInt(enDate.split("/")[2] + enDate.split("/")[1] + enDate.split("/")[0])

	var startDate = new Date
	var endDate = new Date
	var tDate= new Date

	var stDays=startDate.getTime();
	var enDays=endDate.getTime();
	var numdays=0;
	
	startDate=dateConv(document.all.startDate.value);
	endDate=dateConv(document.all.endDate.value);
	tDate=dateConv(Calender);

	dateOK=1
	str=Calender
	
	document.forms["frmDetails"].elements["HiddenDate"].value = str
	whole = document.forms["frmDetails"].elements["HiddenDate"].value
	day = document.forms["frmDetails"].elements["HiddenDate"].value.substring (8,10)
	day.replace (" ","")
	month = document.forms["frmDetails"].elements["HiddenDate"].value.substring (4,7)
	month.replace (" ","")
	strlength = document.forms["frmDetails"].elements["HiddenDate"].value.length
	year = document.forms["frmDetails"].elements["HiddenDate"].value.substring (strlength-4,strlength)
	
	if (day < 10)
	{
		day = "0" + day
	}
	
	if (day >= 10)
	{
		day = day + " "
	}
	
	var convertedDate = new Date((day + month + " " + year ))
	var todayDate = new Date()
	todayDate.getDate()

    // Now see if we input both days then find the number of days between them
	var oneday=1000*60*60*24     // one day in miliseconds
	
	if (SelectedDate == document.all.startDate.id)
	{
		if (!document.all.endDate.value=="")
		{
			if (intENDate < intSTDate)
			{
				alert("Start date can not be later than end date")
				document.all.startDate.value="";
				document.all.startDate.focus;
				dateOK=0;
				return;
			}
			
			if (dateOK==1)
			{
				numdays=Math.ceil((endDate.getTime()-tDate.getTime())/(oneday))
			}  
		}
	}
	
	if (SelectedDate == document.all.endDate.id)
	{
		if (!document.all.startDate.value=="")
		{
			if (intENDate < intSTDate)
			{
				alert("End date can not be earlier than start date")
				document.all.endDate.value="";
				document.all.endDate.focus;
				dateOK=0;
				return;
			}
			
			if (dateOK==1)
			{
				numdays=Math.ceil((tDate.getTime()-startDate.getTime())/(oneday))
			}
		} 
	}
	
	if (dateOK==1)
	{
		SelectedDate.value = day + month + " " + year
	}
	
	//here we have the total days for the new task - so store them and add to any currently selected - but we will need to subtract any already added so make sure we store them
	if(!numdays==0)
	{
		document.frmDetails.newdays.value = numdays
	}
}
	
function dateConv(dteVar)
{
	var dteVal= new Date;
	
	var dteVarStr = dteVar.split("/");
	dteVal.setDate(dteVarStr[0]);
	dteVal.setMonth(dteVarStr[1]-1);
	dteVal.setFullYear(dteVarStr[2]);
	return (dteVal);
}

function dateSplit(dteVal,dteVar)
{
	var dteVarStr = dteVar.split("/");
	dteVal.setDate(dteVarStr[0]);
	dteVal.setMonth(dteVarStr[1]-1);
	dteVal.setFullYear(dteVarStr[2]);
	return (dteVar);
}

</script>
<%

con.close
set con=Nothing
%>


<SCRIPT LANGUAGE="JavaScript">

function checkDates(srch){

 // make sure they have Start/End dates so we can add days
 if(document.frmDetails.startDate.value == "" && document.frmDetails.endDate.value == ""){
    alert (" You Must Enter Task Start/End Dates");
	return;
 }
 if (srch==1){
    MovetoPage(1)
  }	
 else {
   setSearch()
   }

}

function getStart(inputID)
{
  calSet(inputID);
}

// to check Start date
function gsTimer()
{
  var stDate = (document.all.startDate.value);
  var chDate = (document.all.startDate.value);
  var tmo;
  
  starttime(3000);
  var i=1;
  while (stDate==chDate){	
     i++;
     alert("Start is " + stDate + " Check is " + chDate + " * " + i);
     chDate = (document.all.startDate.value);
	 
	 starttime(3000);
   }	
   
   stoptimer()       
}

function starttime(millis){
  //alert ("timer in");
  var dt = new Date();
  while((new Date()) - dt <= millis) { /* do nothing - just pause */ }
  
}

function MovetoPage (PageNo) {
//alert(PageNo);
if (document.frmDetails.criteriaChange.value==1){
	PageNo=1;
	}
	stringToCheck = document.frmDetails.currentlyChecked.value

	for (var i = 0; i < document.frmPosts.elements.length; i++){
		currentValue=document.frmPosts.elements[i].value;
		
		if (document.frmPosts.elements[i].checked==true ) {
			if (stringToCheck.indexOf(currentValue)<0){
				
				stringToCheck = stringToCheck + "," + document.frmPosts.elements[i].value;
			}
		}else{
			if (stringToCheck.indexOf(currentValue)>=0){
				
				stringToCheck=stringToCheck.replace(","+currentValue,"");
			}
		}
	}

	document.frmDetails.currentlyChecked.value = stringToCheck;
	document.forms["frmDetails"].elements["Page"].value = PageNo;
	document.forms["frmDetails"].submit();
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

	var sd = document.getElementById('startDate').value;
	sd = sd.killWhiteSpace();
	var ed = document.getElementById('endDate').value;	
	ed = ed.killWhiteSpace();
	var u = document.frmDetails.hiddenChange.value;
	
	if(sd == "" || ed == "")
	{
		errMsg += "Specify Dates\n"
		error = true;
	}

	if(u == "")
	{
		errMsg += "Select unit(s)\n"
		error = true;
	}

	if(error == true)
	{
		alert(errMsg)
		return;	  		
	}
	
	var list, field, location, current;
	var newattached;
	
	/* now build the section list - if any - to be removed */
	if (document.frmDetails.cboUnitTasked.options.length != 0)
	{
		list = document.frmDetails.cboUnitTasked.value;
		/* now build hidden value with list of units to submit */
		id = document.frmDetails.cboUnitTasked[0].value;
		newattached = id
	
		for (var i = 1; i < document.frmDetails.cboUnitTasked.options.length; i++)
		{
			id = document.frmDetails.cboUnitTasked[i].value
			newattached = newattached + "," + id
		}
		document.frmDetails.newattached.value = newattached;
	}

	document.frmDetails.hiddenChange.value = "";
	document.frmDetails.action = "UpdateTaskUnit.asp"
	document.frmDetails.submit();  
}

function changeParent() {
var TypeID = document.getElementById("TypeID").value;
document.getElementById("QID").length=0;
var counter =0;
for (i=0;i<ParentArray.length;i++)
	{
		strSplit = ParentArray[i].split("*");
			if (strSplit[0]==TypeID)
			{
				document.frmDetails.QID.options[counter] = new Option(strSplit[2],strSplit[0] + "*" + strSplit[1]);
				alert(document.frmDetails.QID.value);
				counter=counter+1;
			}
	}
}

function findParent(){
	var TypeID = document.getElementById("TypeID").value;
	document.getElementById("QID").length=0;
	var counter = 0;
	for (i=0;i < ParentArray.length;i++)
	{
		strSplit = ParentArray[i].split("*");
			if (strSplit[0]==TypeID)
			{
				document.getElementById("QID").options[counter] = new Option (strSplit[2],strSplit[1]);
				counter++;
			}
	}


}

function addAttached()
{
    /* we've clicked on an Attachment to REMOVE it */
	var list, field, location, picked, txt;
	var newattached;
		
	location = document.forms['frmDetails']['cboUnitAvailable'];     /* list of Sections that can be REMOVED */
	list = document.forms['frmDetails']['cboUnitTasked'];        /* list of Sections to REMOVE */
	field = document.frmDetails.cboUnitAvailable.options.value ;     /* Section selected to REMOVE */
	
	/* this is the value for the assigned list */
	/* newattached = document.frmAdmin.lstLocation.value + "|" + field;  */
	document.frmDetails.hiddenChange.value = "true";
	var inum = 2000
	for (var i = 0; i < location.options.length; i++)
	{
		if(field == document.frmDetails.cboUnitAvailable[i].value)
		{
	    	inum = i ;
		}
	}
			 
    txt=document.frmDetails.cboUnitAvailable.options[inum].text;
	strSplit = field.split("*");
	list.options[list.options.length] = new Option(txt,field,false); /* true would select it */

	document.frmDetails.cboUnitAvailable[inum] = null;
	
	/* if we just clicked on last entry don't try to assign focus - cos theres nowt there */
	if (document.frmDetails.cboUnitAvailable.options.length != 0)
	{  
		document.frmDetails.cboUnitAvailable[0].focus();
	}	
}

function remAttached()
{
	var list, field, location, current;
	var cval, ctxt, cstr;
	var newattached;
	
	re = /,/; 
	lstxt= new Array;
	lsval= new Array;

	list = document.forms['frmDetails']['cboUnitAvailable'];      /* Available list */
	location = document.forms['frmDetails']['cboUnitTasked']; /* REMOVE list */
	field = document.frmDetails.cboUnitTasked.options.value;  /* Entry in REMOVE list they clicked to remove */

    /* now get text from the selected entry so we can replace it in unassigned list */
	var inum = 2000
	for (var i = 0; i < location.options.length; i++)
	{
		if (field == document.frmDetails.cboUnitTasked[i].value)
		{
			newattached= document.frmDetails.cboUnitTasked[i].text;
			inum = i ;
		}
	}
	
	list.options[list.options.length] = new Option(newattached,field,false); /* true would select it */

    var icount = 0;
	for (var i = 0; i < list.options.length; i++)
	{	    
		lsval[icount]= document.frmDetails.cboUnitAvailable[i].value;
		lstxt[icount]= document.frmDetails.cboUnitAvailable[i].text + "," + document.frmDetails.cboUnitAvailable[i].value;
		icount++;
	}

    lsval.sort();
	lstxt.sort();
	for (var i = 0; i < lstxt.length; i ++)
	{
		current = lstxt[i];
		cstr = current.split(re);
		ctxt= cstr[0];
		cval= cstr[1]; 
        document.frmDetails.cboUnitAvailable[i].value = cval;
		document.frmDetails.cboUnitAvailable[i].text = ctxt;
	}
 
	document.frmDetails.cboUnitTasked[inum] = null;
	document.frmDetails.cboUnitTasked.selectedIndex=-1;
	
	/* There is nothing picked to remove - so make sure change flag is unset */
    if (document.frmDetails.cboUnitTasked.options.length == 0)
	{
		document.frmDetails.hiddenChange.value = "";
	}
}

</Script>
<%response.write testDate%>
</body>
</html>
