<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
%>
	<script language="JScript">
		var myHeight = document.documentElement.clientHeight - 138; //(screen.availHeight) ;
		window.location = "reportsMonthlyStats.asp?myHeight1="+myHeight;
	</script>
<%
else
   'session.timeout = 60
   session("heightIs") = request("myHeight1") 
end if 

itemsListed=6
location="Reports"
subLocation="8"
		
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'List all ranks
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
strCommand = "spListRanks"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara

set rsRankList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next

'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'List all enduring qualifications
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
strCommand = "spEnduringQs"
objCmd.CommandText = strCommand

set rsEnduringQList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next

'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'List all contingent qualifications
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
strCommand = "spContingentQs"
objCmd.CommandText = strCommand
set rsContingentQList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next

'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'List the CSS  qualification
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
strCommand = "spListMilitaryskills"
objCmd.CommandText = strCommand

set rsCCSList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next

'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'List the fitnass test
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
strCommand = "spListFitness"
objCmd.CommandText = strCommand

set rsFitnessList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next

'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'List all qualifications
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
strCommand = "spListQs"
objCmd.CommandText = strCommand

set rsDPList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next

'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'List all qualifications
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
strCommand = "spListQs"
objCmd.CommandText = strCommand
set rsEDList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next

objCmd.CommandText = "spListHierarchyDropDown"
set rsHrcList = objCmd.Execute

'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next
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

<script type="text/javascript" src="calendar.js"></script>

<script language="javascript">

var obj = new Object;
var obj2 = new Object;
var obj = new Object;
var win = null;

function hideObject(obj)
{
	obj.style.display = 'none';
}

function switchObject(obj,obj2,obj3,whichBox)
{
	if(obj.style.display !='none')
	{
		obj.style.display = 'none';
		obj2.src="images/plus.gif";
		obj2.disabled=1
		obj3.value=0;
		deselectBox (whichBox);
	}
	else
	{
		obj.style.display = '';
		obj2.src="images/minus.gif";
		obj3.value=1;
		currentlyOpen = obj;
		currentIcon = obj2;
		currentStatus = obj3;
	}
}

</Script>

</head>
<body
	<table height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>    		
			<td> 
				<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10px>&nbsp;</td>
                        <td><a title="" href="index.asp" class=itemfontlinksmall>Home</a> > <A href='reportsHome.asp' class=itemfontlinksmall >Reports</A> > <font class='youAreHere'>Management Board</font></td>
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
                            <form  action="reportsMonthlyStatsSubmit.asp" method="POST" name="frmDetails" target="Report">
                                <input type=hidden name="RankStatus" id="RankStatus" value="0"%>
                                <input type=hidden name="QStatus" id="QStatus" value="0"%>
                                <input type=hidden name="NStatus" id="NStatus" value="0"%>
                                <input type=hidden name="CCSStatus" id="CCSStatus" value="0"%>
                                <input type=hidden name="FitnessStatus" id="FitnessStatus" value="0"%>
                                <input type=hidden name="DPStatus" id="DPStatus" value="0"%>
                                <input type=hidden name="EDStatus" id="EDStatus" value="0"%>
                                
                                <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">			
                                    <tr class="SectionHeader">
                                        <td>
                                            <table width="235px" border="0" cellpadding="0" cellspacing="0">
                                                <tr height="25px">
                                                    <td width="25px" align="center"><a class="itemfontlink" href="javascript:launchReportWindow ();"><img class="imagelink" src="images/report.gif"></a></td>
                                                    <td width="85px" class="toolbar" align="center">Create Report</td>
                                                    <td class="titleseparator" valign="middle" width="10px" align="center">|</td>
                                                    <td width="25px"><a class="itemfontlink" href="javascript:launchReportWindowExcel ();"><img class="imagelink" src="images/excel.gif"></a></td>
                                                    <td width="90px" class="toolbar" align="center">Create In Excel</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                        
                                    <tr>
                                        <td align="left" valign="top">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr height="16">
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="320" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td width="100" align="left" class="subheading">Select Unit:</td>
                                                                <td width="220" valign="middle">
                                                                    <select name="cboHrc" id="cboHrc" class="pickbox" style="width:180px;">
                                                                        <%do while not rsHrcList.eof%>
                                                                            <option value=<%=rsHrcList("hrcID")%>><%=rsHrcList("hrcname")%></option>
                                                                            <%rsHrcList.movenext%>
                                                                        <%loop%>
                                                                    </select>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" class="titlearealine"  height="1px"><img height="1px" alt="" src="Images/blank.gif"></td> 
                                                </tr>
                                                <tr>
                                                    <td colspan="2">&nbsp;</td>
                                                </tr>
                        
                                                <!--Begin listing search criteria-->
                        
                                                <tr>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td width="8px" align="left" onClick="switchObject(sectionRank,ranIcon,RankStatus,1);"><font ><img id="ranIcon" src="images/plus.gif"></font></td>
                                                                <td align="left" class="subheading">Personnel By Rank</td>
                                                                <td></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td width="16px"></td>
                                                                <td>
                                                                    <div id="sectionRank"  style="display:none;">
                                                                        <table>
                                                                            <tr>
                                                                                <td colspan="2"></td>
                                                                            </tr>
                                                                            <tr  height="16px">
                                                                                <td valign="bottom"  class="ColorBackground"  id="VacsTab"></td>
                                                                                <td class="ColorBackground">
                                                                                    <select name="ranks" id="ranks" size="<%=itemsListed%>"  class="pickbox" style="width:180px;" multiple> 
                                                                                        <%doSelect="Y"%>
                                                                                        <%Do while not rsRankList.EOF%>
                                                                                            <option value="<%=rsRankList("RankID") %>"><%=rsRankList("shortdesc")%></option>
                                                                                            <%doSelect="N"%>
                                                                                            <%rsRankList.Movenext()%>
                                                                                        <%Loop%>
                                                                                    </select>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                
                                                <tr >
                                                    <td >
                                                        <table>
                                                            <tr>
                                                                <td width=16px align=left onclick="switchObject(sectionQualifications,qIcon,QStatus,2);"><font ><img id="qIcon" src="images/minus.gif"></font></td>
                                                                <td align=left class=subheading>Specialist Trained Personnel</td>
                                                                <td></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border=0 cellpadding=0 cellspacing=0 >
                                                            <tr>
                                                                <td width="16px"></td>
                                                                <td>
                                                                    <div id="sectionQualifications" style="display:none;">
                                                                        <table border=0>
                                                                            <tr class=" toolbar">
                                                                                <td width="200px" align="left"><u>Enduring:</u></td>
                                                                                <td width="200px" align="left"><u>Contingent:</u></td>
                                                                            </tr>
                                                                            <tr  height=16>
                                                                                <td width="200px" class="ColorBackground">
                                                                                    <select name="enduring" id="enduring" size="<%=itemsListed%>"  class="pickbox" style="width:180px;" multiple> 
                                                                                        <%doSelect="Y"%>
                                                                                        <%Do while not rsEnduringQList.EOF%>
                                                                                            <option value="<%=rsEnduringQList("qID") %>"><%=rsEnduringQList("description")%></option>
                                                                                            <%doSelect="N"%>
                                                                                            <%rsEnduringQList.Movenext()%>
                                                                                        <%Loop%>
                                                                                    </select>
                                                                                </td>
                                                                                <td width="200px" class="Colorbackground">
                                                                                    <select name="contingent" id="contingent" size="<%=itemsListed%>"  class="pickbox" style="width:180px;" multiple> 
                                                                                        <%doSelect="Y"%>
                                                                                        <%Do while not rsContingentQList.EOF%>
                                                                                            <option value="<%=rsContingentQList("qID") %>"><%=rsContingentQList("description")%></option>
                                                                                            <%doSelect="N"%>
                                                                                            <%rsContingentQList.Movenext()%>
                                                                                        <%Loop%>
                                                                                    </select>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                
                                                <tr>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td width="8px" align="left" onClick="switchObject(sectionNon,nIcon,NStatus,3);"><font ><img id="nIcon" src="images/plus.gif"></font></td>
                                                                <td align="left" class="subheading">Non-Effective Personnel</td>
                                                                <td></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td width="16px"></td>
                                                                <td>
                                                                    <div id="sectionNon"  style="display:none;">
                                                                        <table>
                                                                            <tr>
                                                                                <td colspan="2"></td>
                                                                            </tr>
                                                                            <tr height="16px">
                                                                                <td id="MSTab" valign="bottom" class="ColorBackground"></td>
                                                                                <td class="ColorBackground"><input name="nep" type="checkbox" id="nep" value="1"></td>
                                                                            </tr>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                        
                                                <tr>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td width="8px" align="left" onClick="switchObject(sectionCCS,ccsIcon,CCSStatus,4);"><font ><img id="ccsIcon" src="images/plus.gif"></font></td>
                                                                <td align="left" class="subheading">CCS</td>
                                                                <td></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td width="16px"></td>
                                                                <td>
                                                                    <div id="sectionCCS"  style="display:none;">
                                                                        <table>
                                                                            <tr>
                                                                                <td colspan="2"></td>
                                                                            </tr>
                                                                            <tr  height="16">
                                                                                <td id="MSTab" valign="bottom"  class="ColorBackground"></td>
                                                                                <td class="ColorBackground">
                                                                                    <select name="ccs" id="ccs" size="<%=itemsListed%>"  class="pickbox" style="width:180px;">
                                                                                        <%doSelect="Y"%>
                                                                                        <%Do while not rsCCSList.EOF%>
                                                                                            <option value="<%=rsCCSList("MSid") %>,<%=rsCCSList("MSDescription")%>"><%=rsCCSList("MSDescription")%></option>
                                                                                            <%doSelect="N"%>
                                                                                            <%rsCCSList.Movenext()%>
                                                                                        <%Loop%>
                                                                                    </select>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                        
                                                <tr>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td width="8px" align="left" onClick="switchObject(sectionFitness,fitIcon,FitnessStatus,5);"><font ><img id="fitIcon" src="images/plus.gif"></font></td>
                                                                <td align="left" class="subheading">Fitness</td>
                                                                <td></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td width="16px"></td>
                                                                <td>
                                                                    <div id="sectionFitness"  style="display:none;">
                                                                        <table>
                                                                            <tr>
                                                                                <td colspan="2"></td>
                                                                            </tr>
                                                                            <tr  height="16px">
                                                                                <td id="FitnessTab"></td>
                                                                                <td class="ColorBackground"><input name="fitness" type="checkbox" id="fitness" value="1"></td>
                                                                            </tr>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                
                                                <tr>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td width="8px" align="left" onClick="switchObject(sectionDP,dpIcon,DPStatus,6);"><font ><img id="dpIcon" src="images/plus.gif"></font></td>
                                                                <td align="left" class="subheading">Data Protection</td>
                                                                <td></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td width="16px"></td>
                                                                <td>
                                                                    <div id="sectionDP"  style="display:none;">
                                                                        <table>
                                                                            <tr>
                                                                                <td colspan="2"></td>
                                                                            </tr>
                                                                            <tr  height="16px">
                                                                                <td id="DentalTab"></td>
                                                                                <td class="ColorBackground">
                                                                                    <select name="dprotection" id="dprotection" size="<%=itemsListed%>"  class="pickbox" style="width:180px;" >
                                                                                        <%doSelect="Y"%>
                                                                                        <%Do while not rsDPList.EOF%>
                                                                                            <%if rsDPList("typeID") =1 then%>
                                                                                                <option value="<%=rsDPList("Qid")%>,<%=rsDPList("Description")%>"><%=rsDPList("Description")%></option>
                                                                                                <%doSelect="N"%>
                                                                                            <%end if%>
                                                                                            <%rsDPList.Movenext()%>
                                                                                        <%Loop%>
                                                                                    </select>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                
                                                <tr>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td width="8px" align="left" onClick="switchObject(sectionED,edIcon,EDStatus,7);"><font ><img id="edIcon" src="images/plus.gif"></font></td>
                                                                <td align="left" class="subheading">Equality and Diversity</td>
                                                                <td></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td width="16px"></td>
                                                                <td>
                                                                    <div id="sectionED"  style="display:none;">
                                                                        <table>
                                                                            <tr>
                                                                                <td colspan="2"></td>
                                                                            </tr>
                                                                            <tr  height="16px">
                                                                                <td id="DentalTab"></td>
                                                                                <td class="ColorBackground">
                                                                                    <select name="ed" id="ed" size="<%=itemsListed%>"  class="pickbox" style="width:180px;" >
                                                                                        <%doSelect="Y"%>
                                                                                        <%Do while not rsEDList.EOF%>
                                                                                            <%if rsEDList("typeID") =1 then%>
                                                                                                <option value="<%=rsEDList("Qid")%>,<%=rsEDList("Description") %>"><%=rsEDList("Description")%></option>
                                                                                                <%doSelect="N"%>
                                                                                            <%end if%>
                                                                                            <%rsEDList.Movenext()%>
                                                                                        <%Loop%>
                                                                                    </select>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                        
                                                <tr>
                                                    <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="6" class="titlearealine"  height="1px"><img height="1" alt="" src="Images/blank.gif"></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr height="16px">
                                                    <td colspan="6" height="22px" class="itemfontTip"><u>(Tip: hold down CTRL + click on listed item to select or de-select)</U></td>
                                                </tr>
                        
                                                <!--End list Search Criteria-->
                        
                                                <tr>
                                                    <td></td>
                                                </tr>
                                            </table>
                                        </td>
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
currentStatus = document.frmDetails.QStatus;

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
			document.forms["frmDetails"].elements["ranks"].selectedIndex = -1
		break
		
		case 2:
			document.forms["frmDetails"].elements["enduring"].selectedIndex = -1
			document.forms["frmDetails"].elements["contingent"].selectedIndex = -1
		break
		
		case 3:
			document.forms["frmDetails"].elements["nep"].checked = 0
		break
		
		case 4:
			document.forms["frmDetails"].elements["ccs"].selectedIndex = -1
		break
		
		case 5:
			document.forms["frmDetails"].elements["fitness"].checked = 0
		break
	
		case 6:
			document.forms["frmDetails"].elements["dprotection"].selectedIndex = -1
			
		case 7:
			document.forms["frmDetails"].elements["ed"].selectedIndex = -1
		break
	}
}	

function launchReportWindow()
{
	if(win)
	{
		win.close();
	}
	
	if(document.frmDetails.cboHrc.value==0)
	{
		alert( "Please select a Team");
		document.frmDetails.cboHrc.focus()
		return;
	}
	  
	if(document.forms["frmDetails"].elements["ranks"].selectedIndex == -1 && document.forms["frmDetails"].elements["enduring"].selectedIndex == -1 && document.forms["frmDetails"].elements["contingent"].selectedIndex == -1 && document.forms["frmDetails"].elements["nep"].checked == 0 && document.forms["frmDetails"].elements["ccs"].selectedIndex == -1 && document.forms["frmDetails"].elements["fitness"].checked == 0 && document.forms["frmDetails"].elements["dprotection"].selectedIndex == -1 && document.forms["frmDetails"].elements["ed"].selectedIndex == -1) 
	{
		alert("No items selected");
		return;
	}
	
	var x = (screen.width);
	var y = (screen.height);

	document.frmDetails.action="reportsMonthlyStatsSubmit.asp";
	win = window.open("","Report","top=0,left=0,width="+x+",height="+y+",toolbar=0,menubar=1,scrollbars=1");
	window.setTimeout("document.frmDetails.submit();",500);
}

function launchReportWindowExcel()
{
	if(win)
	{
		win.close();
	}
	
    if(document.frmDetails.cboHrc.value==0)
	{
		alert( "Please select a Team");
		return;
	}
	  
	if(document.forms["frmDetails"].elements["ranks"].selectedIndex == -1 && document.forms["frmDetails"].elements["enduring"].selectedIndex == -1 && document.forms["frmDetails"].elements["contingent"].selectedIndex == -1 && document.forms["frmDetails"].elements["nep"].checked == 0 && document.forms["frmDetails"].elements["ccs"].selectedIndex == -1 && document.forms["frmDetails"].elements["fitness"].checked == 0 && document.forms["frmDetails"].elements["dprotection"].selectedIndex == -1 && document.forms["frmDetails"].elements["ed"].selectedIndex == -1) 
	{
		alert("No items selected");
		return;
	}
	
	document.frmDetails.action="reportsMonthlyStatsExcel.asp";
	document.frmDetails.submit();
}

function checkRadio()
{
	var rdo = window.event.srcElement.value
	var nme = window.event.srcElement.name
   
	if(nme=='rg1')
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