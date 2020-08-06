<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
%>
	<script language="JScript">
		var myHeight = document.documentElement.clientHeight - 138; //(screen.availHeight) ;
		window.location = "reportsUnitHarmonyStatus.asp?myHeight1="+myHeight;
	</script>
<%
else
   'session.timeout = 60
   session("heightIs") = request("myHeight1") 
end if 

itemsListed=6
location="Reports"
subLocation="6"

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

if Len(splitDate(0)) < 2 then splitDate(0) = "0" & splitDate(0)
newTodaydate= splitDate(0) + " " + theMonth + " " + splitDate(2) 

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("nodeID",3,1,5, session("nodeID"))
objCmd.Parameters.Append objPara
objCmd.CommandText = "spListHierarchyDropDown"
set rsHrcList = objCmd.Execute


%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>

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
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>    		
			<td> 
				<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10px>&nbsp;</td>
                        <td><a title="" href="index.asp" class=itemfontlinksmall>Home</a> > <A href='reportsHome.asp' class=itemfontlinksmall >Reports</A> > <font class='youAreHere'>Unit Harmony</font></td>
                    </tr>
                    <tr>
                        <td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
				</table>
                <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
                    <tr valign=Top>
                        <td class="sidemenuwidth" background="Images/tableback.png">
							<!--#include file="Includes/reportsSideMenu.inc"-->
                        </td>
                        <td width=16></td>
                        <td align=left>
							<form action="reportsUnitHarmonySubmit.asp" method="POST" name="frmDetails" target="Report">
								<Input name="repunit" id="repunit" type="hidden" value="0" >
								<Input name="repby" id="repby" type="hidden" value="0" >
                                    <table border=0 cellpadding=0 cellspacing=0 width=100% height=100% >
                                        <tr class=SectionHeader>
                                            <td>
                                                <table width="235px" border="0" cellpadding="0" cellspacing="0">
                                                    <tr height="25px">
                                                        <td width="25px" align="center"><a class="itemfontlink" href="javascript:launchReportWindow();"><img class="imagelink" src="images/report.gif"></a></td>
                                                        <td width="85px" align="center" class="toolbar">Create Report</td>
                                                        <td width="10px" class="titleseparator" align="center">|</td>
                                                        <td width="25px" align="center"><a class="itemfontlink" href="javascript:launchReportWindowExcel();"><img class="imagelink" src="images/excel.gif"></a></td>
                                                        <td width="90px" align="center" class="toolbar">Create In Excel</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
										<tr>
     										<td align=left valign=top>
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                    	<td>
                                                            <table border=0 cellpadding=0 cellspacing=0 width=615>
                                                                <tr>
                                                                    <td colspan="4">&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td width="100" align=left class=subheading>Select Unit:</td>
                                                                    <td width="515" colspan="5">					
                                                                        <select name="cboHrc" id="cboHrc" class="pickbox" id="cboHrc" style="width:180px;" >
                                                                            <% do while not rsHrcList.eof %>
                                                                                <option value="<%= rsHrcList("hrcID") %>"><%= rsHrcList("hrcname") %></option>
                                                                                <% rsHrcList.movenext %>
                                                                            <% loop %>
                                                                        </select>
                                                                    </td>
                                                                </tr>					  
                                                                <tr>
                                                                    <td colspan="4">&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td width="100" align=left class=subheading>Report By:</td>
                                                                    <td width="185" class=subheading>
                                                                        <p>
                                                                            <label class=subHeading><input type="radio" name="rg1" id="rg1" onClick="checkRadio()" value="0" checked>Unit</label>
                                                                            <br><label class=subHeading><input type="radio" name="rg1" id="rg1" onClick="checkRadio()" value="1">Unit/Rank</label>
                                                                            <br><label class=subHeading><input type="radio" name="rg1" id="rg1" onClick="checkRadio()" value="2">Unit/Trade</label>
                                                                            <br>
                                                                        </p>
                                                                    </td>
                                                                    <td width="165" class=subheading>Show Harmony as % of </td>
                                                                    <td width="165" class=subheading>
                                                                        <p>
                                                                            <label class=subHeading><input type="radio" name="rg2" id="rg2" onClick="checkRadio()" value="0" checked>Strength</label>
                                                                            <br><label class=subHeading><input type="radio" name="rg2" id="rg2" onClick="checkRadio()" value="1">Establishment</label>
                                                                            <br>
                                                                        </p>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="4">&nbsp;</td>
                                                                </tr>
															</table>
													  </td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td colspan=2 class=titlearealine  height=1></td> 
										</tr>
									</table>
								</form>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

</body>
</html>

<script language="javascript">

var currentlyOpen = new Object;
currentlyOpen = document.all.sectionQualifications;
var currentIcon = new Object;
currentIcon = document.all.qIcon;
var currentStatus = new Object;
currentStatus = frmDetails.QStatus;
var win = null;

function closeCurrentObject(obj,obj2,obj3)
{
	obj.style.display = 'none';
	obj2.src="images/plus.gif";
	obj3.value=0;
}

function unselectTheRest(thisElement1,thisElement2,thisElement3)
{
	document.forms["frmDetails"].elements[thisElement1].selectedIndex = -1
	document.forms["frmDetails"].elements[thisElement2].selectedIndex = -1
	document.forms["frmDetails"].elements[thisElement3].selectedIndex = -1
}

function deselectBox(whichBox)
{
	switch(whichBox)
	{
		case 1:
			document.forms["frmDetails"].elements["generalQ"].selectedIndex = -1
			document.forms["frmDetails"].elements["technicalQ"].selectedIndex = -1
			document.forms["frmDetails"].elements["operationalQ"].selectedIndex = -1
			document.forms["frmDetails"].elements["driverQ"].selectedIndex = -1
		break
		
		case 2:
			document.forms["frmDetails"].elements["milSkill"].selectedIndex = -1
		break
		
		case 3:
			document.forms["frmDetails"].elements["vacs"].selectedIndex = -1
		break
		
		case 4:
			document.forms["frmDetails"].elements["fitness"].selectedIndex = -1
		break
	
		case 5:
			document.forms["frmDetails"].elements["dental"].selectedIndex = -1
		break
	}
}

function advancedReporting()
{
	document.getElementById('MSTab').style.width="46px";
	document.getElementById('VacsTab').style.width="46px";
	document.getElementById('FitnessTab').style.width="46px";
	document.getElementById('DentalTab').style.width="46px";
	document.getElementById('AdvancedQ').style.display='';
	document.getElementById('AdvancedMS').style.display='';
	document.getElementById('AdvancedVacs').style.display='';
	document.getElementById('AdvancedFitness').style.display='';
	document.getElementById('AdvancedDental').style.display='';
	document.getElementById('advancedLink').style.display='none';
	document.getElementById('standardLink').style.display='';
}

function standardReporting()
{
	document.getElementById('AdvancedQ').style.display='none';
	document.getElementById('AdvancedMS').style.display='none';
	document.getElementById('AdvancedVacs').style.display='none';
	document.getElementById('AdvancedFitness').style.display='none';
	document.getElementById('AdvancedDental').style.display='none';
	document.getElementById('MSTab').style.width="0px";
	document.getElementById('VacsTab').style.width="0";
	document.getElementById('FitnessTab').style.width="0";
	document.getElementById('DentalTab').style.width="0";
	document.getElementById('standardLink').style.display='none';
	document.getElementById('advancedLink').style.display='';
}

function launchReportWindow()
{
	if(win)
	{
		win.close();
	}
	
	if(document.frmDetails.cboHrc.value == 0)
	{
		alert( "Please select a Team");
		return;
	}

	var x = (screen.width);
	var y = (screen.height);

	document.frmDetails.action="reportsUnitHarmonySubmit.asp";
	win = window.open("","Report","top=0,left=0,width="+x+",height="+y+",toolbar=0,menubar=1,scrollbars=1");
	window.setTimeout("document.frmDetails.submit();",500);	
}

function launchReportWindowExcel()
{
	if(win)
	{
		win.close();
	}
	
    if(document.frmDetails.cboHrc.value == 0)
	{
		alert( "Please select a Team");
		return;
	}

	document.frmDetails.action="reportsUnitHarmonyExcel.asp";
	document.frmDetails.submit();
}

function checkRadio()
{
	var rdo = window.event.srcElement.value   
	var nme = window.event.srcElement.name
   
	if(nme == 'rg1')
	{
		document.frmDetails.repunit.value = rdo;
	}
	else
	{
		document.frmDetails.repby.value = rdo;
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
	whole = document.forms["frmDetails"].elements["HiddenDate"].value
	day = document.forms["frmDetails"].elements["HiddenDate"].value.substring (8,10)
	day.replace (" ","")
	month = document.forms["frmDetails"].elements["HiddenDate"].value.substring (4,7)
	strlength = document.forms["frmDetails"].elements["HiddenDate"].value.length
	year = document.forms["frmDetails"].elements["HiddenDate"].value.substring (strlength-4,strlength)

	if(day < 10)
	{
		day = '0' + day
	}
	
	if(day >= 10)
	{
		day = day + " "
	}

	SelectedDate.value = day  + month + " " + year
}

</script>