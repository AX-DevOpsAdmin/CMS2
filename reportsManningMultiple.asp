<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
%>
	<script language="JScript">
		var myHeight = document.documentElement.clientHeight - 138; //(screen.availHeight) ;
		window.location = "reportsManningMultiple.asp?myHeight1="+myHeight;
	</script>
<%
else
   'session.timeout = 60
   session("heightIs") = request("myHeight1") 
end if 

itemsListed=6
location="Reports"
subLocation="2"

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

if Len(splitDate(0))<2 then splitDate(0)="0" & splitDate(0)
}
'newTodaydate= splitDate(0) + " " + theMonth + " " + splitDate(2)
newTodaydate = formatdatetime(date(),2)

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("nodeID",3,1,5, session("nodeID"))
objCmd.Parameters.Append objPara

objCmd.CommandText = "spListHierarchyDropDown"
set rsHrcList = objCmd.Execute

strCommand = "spListQTypes"
objCmd.CommandText = strCommand
set rsTypeQList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next

strCommand = "spListMilitaryskills"
objCmd.CommandText = strCommand
set rsMilSkillList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next

strCommand = "spListMilitaryVacs"
objCmd.CommandText = strCommand
set rsVacsList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next

strCommand = "spListFitness"
objCmd.CommandText = strCommand
set rsFitnessList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next

strCommand = "spListDental"
objCmd.CommandText = strCommand
set rsDentalList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next


%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
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
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>    		
			<td> 
				<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10px>&nbsp;</td>
                        <td><a title="" href="index.asp" class=itemfontlinksmall>Home</a> > <A href='reportsHome.asp' class=itemfontlinksmall >Reports</A> > <font class='youAreHere' >Manning</font></td>
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
                        <td width=16px>&nbsp;</td>
                        <td align=left>
                        	<form action="reportsProcessMultipleSubmit.asp" method="POST" name="frmDetails" id="frmDetails" target="Report">
                                <input name="HiddenDate" id="HiddenDate" type="hidden" >
                                <input type=hidden name="QStatus" id="QStatus" value="1">
                                <input type=hidden name="MSStatus" id="MSStatus" value="0">
                                <input type=hidden name="VacStatus" id="VacStatus" value="0">
                                <input type=hidden name="FitnessStatus" id="FitnessStatus" value="0">
                                <input type=hidden name="DentalStatus" id="DentalStatus" value="0">
                                <input type=hidden name="advancedReportingOn" id="advancedReportingOn" value="0">
                                <input type="hidden" name="newattached" id="newattached" value="">

                                <table border=0 cellpadding=0 cellspacing=0 width=100% height=100%>
                                    <tr class=SectionHeader>
                                        <td>
                                            <table width="240px" border=0 cellpadding=0 cellspacing=0>
                                                <tr height=28px>
                                                    <td width=25px align="center"><a class=itemfontlink href="javascript:launchReportWindow();"><img class="imagelink" src="images/report.gif"></a></td>
                                                    <td width=90px class=toolbar align="center">Create Report</td>
                                                    <td width=10px class=titleseparator align="center">|</td>
                                                    <td width=25px align="center"><a class=itemfontlink href="javascript:launchReportWindowExcel();"><img class="imagelink" src="images/excel.gif"></a></td>
                                                    <td width=90px class=toolbar align="center">Create In Excel</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align=left valign=top>
                                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                <tr>
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="1000px" border=0 cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td width="100px" height="22px" align="left" class="subheading">Select Unit:</td>
                                                                <td width="220px" align="left" class="subheading" height="22px">
                                                                    <select name="cboHrc" class="itemfont" id="cboHrc" style="width:180px;" >
                                                                        <% do while not rsHrcList.eof %>
                                                                            <option value=<%= rsHrcList("hrcID") %>><%= rsHrcList("hrcName") %></option>
                                                                            <% rsHrcList.movenext %>
                                                                        <% loop %>
                                                                    </select>
                                                                </td>
                                                                <td width="100px" align="left" class="subheading" height="22px">Civilian Posts:</td>
                                                                <td width="150px" height="22px" class="subheading"><input type="checkbox" name="civi" id="civi"  value=1></td>
                                                                  <!--
                                                                <td width="60px" align="left" class="subheading" height="22px">Gender</td>
                                                                <td width="100px" height="22px" align="left" class="subheading">
                                                                    <select name="gender" id="gender" class="itemfont" style="width:70px;">
                                                                        <option value=1 selected>Both</option>
                                                                        <option value=2>Male</option>
                                                                        <option value=3>Female</option>
                                                                    </select>	                                            
                                                                </td>
                                                              
                                                              	<td width="50px" align="left" class="subheading" height="22px">Active</td>
                                                                <td width="40px"><input name="radpersonnel" type="radio" id="radpersonnel_0" value="1" checked></td>
                                                                <td width="60px" align="left" class="subheading" height="22px">Inactive</td>
                                                                <td width="40px"><input type="radio" name="radpersonnel" value="2" id="radpersonnel_1"></td>
                                                                <td width="40px" align="left" class="subheading" height="22px">Both</td>
                                                                <td width="40px"><input type="radio" name="radpersonnel" value="3" id="radpersonnel_2"></td>
                                                                -->
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="subheading" height="22px">Start Date:</td>
                                                                <td height="22px"><input name="startDate" type="text" id="startDate" class="itemfont" style="Width:85px;" value ="<%=newTodaydate %>" readonly onClick="calSet(this)">&nbsp;<img src="images/cal.gif" alt="Calender" align="absmiddle" width="16" height="16" onClick="calSet(startDate)" style="cursor:hand;"></td>
                                                                <td align="left" class="subheading" height="22px">End Date:</td>
                                                                <td height="22px"><input name="endDate" type="text" id="endDate" class="itemfont" style="Width:85px;" value ="<%= newTodaydate %>" readonly onClick="calSet(this)">&nbsp;<img src="images/cal.gif" alt="Calender" align="absmiddle" width="16" height="16" onClick="calSet(endDate)" style="cursor:hand;"></td>
                                                                <td align="left" class="subheading" height="22px">&nbsp;</td>
                                                                <td height="22px" class="subheading">&nbsp;</td>
                                                                <td align="left" class="subheading" height="22px">&nbsp;</td>
                                                                <td height="22px" class="subheading">&nbsp;</td>
                                                                <td align="left" class="subheading" height="22px">&nbsp;</td>
                                                                <td height="22px" class="subheading">&nbsp;</td>
                                                                <td align="left" class="subheading" height="22px">&nbsp;</td>
                                                                <td height="22px" class="subheading">&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="12" height="22px">&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan=12 class=itemfontTip height="22px"><u>(Tip: to obtain results for one day, select same date in both date boxes.)</U></td>
                                                            </tr>		
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td colspan=2 class=titlearealine  height=1></td> 
                                                </tr>
                                                <tr>
                                                    <td colspan="2">&nbsp;</td>
                                                </tr>
                    
                                                <!--Begin listing search criteria-->
                                                
                                                <tr>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td width="15px" align=left onclick = "switchObject('sectionQualifications','qIcon','QStatus',1);"><font ><img id="qIcon" src="images/minus.gif"></font></td>
                                                                <td width="100px" align=left class="subheading">Qualifications</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border=0 cellpadding=0 cellspacing=0 >
                                                            <tr>
                                                                <td width=16px></td>
                                                                <td>
                                                                    <% i = 0 %>
                                                                    <% j = rsTypeQList.recordcount - 1 %>
                                                                    <% q = 1 %>
                                                                    <% r = 2 %>
                                                                    <div id="sectionQualifications" style="width:100%;">
                                                                        <% if not rsTypeQList.eof then %>
                                                                            <% do while not rsTypeQList.eof %>
                                                                                <div style="float:left; display: inline;">
                                                                                <table>
                                                                                    <tr class="toolbar">
                                                                                        <td>&nbsp;</td>
                                                                                        <td valign="middle"><%= rsTypeQList("Type") %></td>
                                                                                    </tr>                                                                
                                                                                    <tr>
                                                                                        <td colspan="2">
                                                                                            <div id="AdvancedQ" style="display: none;">
                                                                                                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                                                                    <tr>
                                                                                                        <td width="10">&nbsp;</td>
                                                                                                        <td>
                                                                                                            <select name="all<%= rsTypeQList("QTypeID") %>Q" id="all<%= rsTypeQList("QTypeID") %>Q"  class="pickbox" style="width:180px;background-color:#ffff00;" >
                                                                                                                <option value=1>Match ALL that are highlighted</option>
                                                                                                                <option value=0>Match ANY that are highlighted</option>
                                                                                                            </select>                                                                                    
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <% if rsTypeQList.recordcount > 1 and i < j then %>
                                                                                                                <select name="or<%= q %>Q<%= r %>Q" id="or<%= q %>Q<%= r %>Q" class="pickbox" style="width:50px;" >
                                                                                                                    <option value=1>And</option>
                                                                                                                    <option value=0>Or</option>
                                                                                                                </select>
                                                                                                            <% else %>
                                                                                                                <select name="or<%= q %>Q" id="or<%= q %>Q" class="pickbox" style="width:50px;" >
                                                                                                                    <option value=1>And</option>
                                                                                                                    <option value=0>Or</option>
                                                                                                                </select>
                                                                                                            <% end if %>
                                                                                                        </td>
                                                                                                        <% i = i + 1 %>
                                                                                                        <% q = q + 1 %>
                                                                                                        <% r = r + 1 %>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </div>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="2">&nbsp;</td>
                                                                                        <td width="180" class="ColorBackground">
                                                                                            <% objCmd.commandtext = "spListQs" %>
                                                                                            <%' objCmd.CommandType = 4 %>
                                                                                            <% set rsQList = objCmd.Execute	%>
                                                                                            
                                                                                            <%' for x = 1 to objCmd.parameters.count %>
                                                                                                <%' objCmd.parameters.delete(0) %>
                                                                                            <%' next %>
                                                                                            
                                                                                            <% Counter = 0 %>
                                                                                            
                                                                                            <select name="<%= rsTypeQList("QTypeID") %>Q" id="<%= rsTypeQList("QTypeID") %>Q" size="<%=itemsListed%>" class="pickbox" multiple style="width:180px;" onChange="MaxSelection(this)"> 
                                                                                            <% doSelect = "Y" %>
                                                                                            <% do while not rsQList.eof %>
                                                                                                <% if rsQList("typeID") = rsTypeQList("QTypeID") then %>
                                                                                                    <option value="<%= rsQList("Qid") %>"><%= rsQList("Description") %> </option>
                                                                                                    <% doSelect = "N" %>
                                                                                                <% end if %>
                                                                                                <% rsQList.movenext() %>
                                                                                            <% loop %>
                                                                                            </select>
                                                                                            <% rsQList.movefirst() %>
                                                                                    	</td>
                                                                                    </tr>
                                                                                </table>
                                                                                </div>
                                                                                <% rsTypeQList.movenext %>
                                                                            <% loop %>
                                                                        <% end if %>
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
                                                                <td width=15px align=left onclick = "switchObject('sectionMilSkills','msIcon','MSStatus',2);"><font ><img id="msIcon" src="images/plus.gif"></font></td>
                                                                <td width="100px" align=left class="subheading">Military Skills</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border=0 cellpadding=0 cellspacing=0 >
                                                            <tr>
                                                                <td width=16px></td>
                                                                <td>
                                                                    <div id="sectionMilSkills" style="display:none;">
                                                                        <table>
                                                                            <tr>
                                                                                <td colspan=2>
                                                                                    <div id="AdvancedMS" style="display:none;">
                                                                                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <select name="orMilSkill" id="orMilSkill" class="pickbox" style="width:50px;" >
                                                                                                        <option value=1>And</option>
                                                                                                        <option value=0>Or</option>
                                                                                                    </select>
                                                                                                </td>
                                                                                                <td class="ColorBackground">
                                                                                                    <select name="allMilskill" id="allMilskill" class="pickbox" style="width:180px;background-color:#ffff00;" >
                                                                                                        <option value=1>Match ALL that are highlighted</option>
                                                                                                        <option value=0>Match ANY that are highlighted</option>
                                                                                                    </select>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr height=16>
                                                                                <td id="MSTab"></td>
                                                                                <td class="ColorBackground">
                                                                                    <select name="milSkill" id="milSkill" size="<%=itemsListed%>" multiple  class="pickbox" style="width:180px;" onChange="MaxSelection()" > 
                                                                                        <% doSelect = "Y" %>
                                                                                        <% do while not rsMilSkillList.eof %>
                                                                                            <option value=<%=rsMilSkillList("MSid")%> ><%=rsMilSkillList("MSDescription")%></option>
                                                                                            <% doSelect = "N" %>
                                                                                            <% rsMilSkillList.movenext() %>
                                                                                        <% loop %>
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
                                                                <td width="15px" align=left onclick = "switchObject('sectionVaccinations','vacIcon','VacStatus',3);"><font ><img id="vacIcon" src="images/plus.gif"></font></td>
                                                                <td width="100px" align=left class="subheading">Vaccinations</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border=0 cellpadding=0 cellspacing=0 >
                                                            <tr>
                                                                <td width=16px></td>
                                                                <td>
                                                                    <div id="sectionVaccinations" style="display:none;">
                                                                        <table>
                                                                            <tr>
                                                                                <td colspan=2>
                                                                                    <div id="AdvancedVacs" style="display:none;">
                                                                                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <select name="orVacs" id="orVacs" class="pickbox" style="width:50px;" >
                                                                                                        <option value=1>And</option>
                                                                                                        <option value=0>Or</option>
                                                                                                    </select>
                                                                                                </td>
                                                                                                <td class="ColorBackground">
                                                                                                    <select name="allVacs" id="allVacs" class="pickbox" style="width:180px;background-color:#ffff00;" >
                                                                                                        <option value=1>Match ALL that are highlighted</option>
                                                                                                        <option value=0>Match ANY that are highlighted</option>
                                                                                                    </select>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr height=16>
                                                                                <td id=VacsTab></td>
                                                                                <td class="ColorBackground">
                                                                                    <select name="vacs" id="vacs" size="<%=itemsListed%>" multiple   class="pickbox" style="width:180px;" onChange="MaxSelection()" > 
                                                                                        <% doSelect = "Y" %>
                                                                                        <% do while not rsVacsList.eof %>													
                                                                                            <option value=<%= rsVacsList("MVid") %>><%= rsVacsList("Description") %></option>
                                                                                            <% doSelect = "N" %>
                                                                                            <% rsVacsList.movenext() %>
                                                                                        <% loop %>
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
                                                                <td width="15px" align=left onclick = "switchObject('sectionFitness','fitIcon','FitnessStatus',4);"><font ><img id="fitIcon" src="images/plus.gif"></font></td>
                                                                <td width="100px" align=left class="subheading">Fitness</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border=0 cellpadding=0 cellspacing=0 >
                                                            <tr>
                                                                <td width=16px></td>
                                                                <td>
                                                                    <div id="sectionFitness" style="display:none;">
                                                                        <table>
                                                                            <tr>
                                                                                <td colspan=2>
                                                                                    <div id="AdvancedFitness" style="display:none;">
                                                                                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                                                            <tr class="pickbox" style="width:50px;" >
                                                                                                <td>
                                                                                                    <select name="orFitness" id="orFitness" class="pickbox" style="width:50px;" >
                                                                                                        <option value=1>And</option>
                                                                                                        <option value=0>Or</option>
                                                                                                    </select>
                                                                                                </td>
                                                                                                <td class="ColorBackground">
                                                                                                    <select name="allFitness" id="allFitness" class="pickbox" style="width:180px;background-color:#ffff00;" >
                                                                                                        <option value=1>Match ALL that are highlighted</option>
                                                                                                        <option value=0>Match ANY that are highlighted</option>
                                                                                                    </select>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr height=16>
                                                                                <td id=FitnessTab></td>
                                                                                <td class="ColorBackground">
                                                                                    <select name="fitness" id="fitness" size="<%=itemsListed%>" class="pickbox" style="width:180px;" onChange="MaxSelection()" > 
                                                                                        <% doSelect = "Y" %>
                                                                                        <% do while not rsFitnessList.eof %>
                                                                                            <option value=<%=rsFitnessList("fitnessid")%> ><%=rsFitnessList("Description")%></option>
                                                                                            <% doSelect = "N" %>
                                                                                            <% rsFitnessList.movenext() %>
                                                                                        <% loop %>
                                                                                    </select>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </Div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td width="15px" align=left onclick = "switchObject('sectionDental','dentIcon','DentalStatus',5);"><font ><img id="dentIcon" src="images/plus.gif"></font></td>
                                                                <td width="100px" align=left class="subheading">Dental</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border=0 cellpadding=0 cellspacing=0 >
                                                            <tr>
                                                                <td width=16px></td>
                                                                <td>
                                                                    <div id="sectionDental" style="display:none;">
                                                                        <table>
                                                                            <tr>
                                                                                <td colspan=2>
                                                                                    <div id="AdvancedDental" style="display:none;">
                                                                                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <select name="orDental" id="orDental" class="pickbox" style="width:50px;" >
                                                                                                        <option value=1>And</option>
                                                                                                        <option value=0>Or</option>
                                                                                                    </select>
                                                                                                </td>
                                                                                                <td class="ColorBackground">
                                                                                                    <select name="allDental" id="allDental" class="pickbox" style="width:180px;background-color:#ffff00;" >
                                                                                                        <option value=1>Match ALL that are highlighted</option>
                                                                                                        <option value=0>Match ANY that are highlighted</option>
                                                                                                    </select>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr height=16>
                                                                                <td id=DentalTab></td>
                                                                                <td class="ColorBackground">
                                                                                    <select name="dental" id="dental" size="<%=itemsListed%>" multiple class="pickbox" style="width:180px;" onChange="MaxSelection()" > 
                                                                                        <% doSelect = "Y" %>
                                                                                        <% do while not rsDentalList.eof %>
                                                                                            <option value=<%= rsDentalList("dentalid") %>><%= rsDentalList("Description") %></option>
                                                                                            <% doSelect = "N" %>
                                                                                            <% rsDentalList.movenext() %>
                                                                                        <% loop %>
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
                                                                                                                                                                                        
                                                <!--End list Search Criteria-->
                                                
                                                <tr>
                                                    <td colspan="6" height="22px">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td colspan=6 class=itemfontTip height="22px"><u>(Tip: hold down CTRL + click on listed item to select or de-select)</U></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="6" height="22px">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td colspan=6 class=titlearealine  height=1></td> 
                                                </tr>
                                                <tr height=30px>
                                                    <td>
                                                        <table border=0 cellpadding=0 cellspacing=0>
                                                            <tr class="subheading">
                                                                <td align =left>List Personnel <input type=radio name=withWithout id="withWithout" value=1 checked><i> that meet</i>  <input type=radio name=withWithout id="withWithout" value=0><I> do not meet</i> the above criteria. </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan=6 class=titlearealine  height=1></td> 
                                                </tr>
                                                <tr>
                                                    <td colspan="6" height="22px">&nbsp;</td>
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


<script type="text/javascript" src="calendar.js"></script>

<script language="javascript">

var obj = new Object;
var obj2 = new Object;
var obj = new Object;
var win = null;

//function switchObject(obj,obj2,obj3,whichBox)
//{
//	alert("Into switchObject");
//	
//	if(obj.style.display !='none')
//	{
//		obj.style.display = 'none';
//		obj2.src="images/plus.gif";
//		obj2.disabled=1
//		obj3.value=0;
//		deselectBox (whichBox);	
//	}
//	else
//	{
//		obj.style.display = '';
//		obj2.src="images/minus.gif";
//		obj3.value=1;
//		currentlyOpen = obj;
//		currentIcon = obj2;
//		currentStatus = obj3;
//	}
//}

function switchObject(showHideDiv, switchImgTag, status, whichBox)
{
	var ele = document.getElementById(showHideDiv);
	var imageEle = document.getElementById(switchImgTag);
	var stat = document.getElementById(status);

//	var divs = new Array ('sectionQualifications','sectionMilSkills','sectionVaccinations','sectionFitness','sectionDental');
//	var imgs = new Array ('qIcon','msIcon','vacIcon','fitIcon','dentIcon');
//	var sta = new Array ('QStatus','MSStatus','VacStatus','FitnessStatus','DentalStatus');
//	var wb = new Array (1, 2, 3, 4, 5)

	if(ele.style.display == "block")
	{
		ele.style.display = "none";
		imageEle.src = "images/plus.gif";
		stat.value = 0;
		deselectBox (whichBox);
	}
	
	else
	{
		/**********
		for(var x = 0; x < divs.length; x++)
		{
			divObj = document.getElementById(divs[x])
			imgObj = document.getElementById(imgs[x])
			staObj = document.getElementById(sta[x])
			wbObj = wb[x]
						
			if(divObj.id !== ele.id)
			{
				divObj.style.display = 'none';
				imgObj.src = "images/plus.gif";
				staObj.value = 0;
				deselectBox (wbObj);
			}
		}
		***********/		
		ele.style.display = "block";
		imageEle.src = "images/minus.gif";
		stat.value = 1;
	}
	document.getElementById('newattached').value = "";
}

</Script>
<script language="JavaScript">

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

function unselectTheRest (thisElement1,thisElement2,thisElement3)
{
	document.forms["frmDetails"].elements[thisElement1].selectedIndex = -1
	document.forms["frmDetails"].elements[thisElement2].selectedIndex = -1
	document.forms["frmDetails"].elements[thisElement3].selectedIndex = -1
}

function deselectBox (whichBox)
{
	switch(whichBox)
	{
		case 1:
			var len = document.frmDetails.elements.length;
			var obj;
			var objlen;
			
			for(var i = 0; i < len; i++)
			{
				if(document.frmDetails.elements[i].type == 'select-multiple')
				{
					obj = document.frmDetails.elements[i].name;
					objlen = obj.substring((obj.length)-1,obj.length);
					
					if(objlen == 'Q')
					{
						document.forms["frmDetails"].elements[obj].selectedIndex = -1;	
					}
				}
			}
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
	
	var myform = document.forms['frmDetails'];
	var divs = myform.getElementsByTagName('div').length;
	myformEle = myform.getElementsByTagName('div');
	
	for(var i=0; i < len; i++)
	{
		if(myformEle[i].id == 'AdvancedQ')
		{
			myformEle[i].style.display='';
		}
	}
	
	document.getElementById('AdvancedMS').style.display='';
	document.getElementById('AdvancedVacs').style.display='';
	document.getElementById('AdvancedFitness').style.display='';
	document.getElementById('AdvancedDental').style.display='';
	document.getElementById('advancedLink').style.display='none';
	document.getElementById('standardLink').style.display='';
}

function standardReporting()
{	
	var myform = document.forms['frmDetails'];
	var len = myform.getElementsByTagName('div').length;
	myformEle = myform.getElementsByTagName('div');
	
	for(var i=0; i < len; i++)
	{
		if(myformEle[i].id == 'AdvancedQ')
		{
			myformEle[i].style.display='none';
		}
	}

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
	
	if(document.getElementById('newattached').value == "") 
	{
		alert("No items selected");
		return;
	}	
	var sd = document.getElementById('startDate').value;
	var ed = document.getElementById('endDate').value;
	
	var sDate = parseInt(sd.split("/")[2] + sd.split("/")[1] + sd.split("/")[0])
	var eDate = parseInt(ed.split("/")[2] + ed.split("/")[1] + ed.split("/")[0])
	
	if(eDate < sDate)
	{
		alert("End date can not be earlier than start date")
		return
	}
	
	var x = (screen.width);
	var y = (screen.height);
	
	document.frmDetails.action="reportsProcessMultipleSubmit.asp";
	win = window.open("","Report","top=0,left=0,width="+x+",height="+y+",toolbar=0,menubar=1,scrollbars=1");
	window.setTimeout("document.frmDetails.submit();",500);
}

function launchReportWindowExcel()
{
	if(win)
	{
		win.close();
	}
	
	if(document.getElementById('newattached').value == "") 
	{
		alert("No items selected");
		return;
	}	
	var sd = document.getElementById('startDate').value;
	var ed = document.getElementById('endDate').value;
	
	var sDate = parseInt(sd.split("/")[2] + sd.split("/")[1] + sd.split("/")[0])
	var eDate = parseInt(ed.split("/")[2] + ed.split("/")[1] + ed.split("/")[0])
	
	if(eDate < sDate)
	{
		alert("End date can not be earlier than start date")
		return
	}
	
	document.frmDetails.action="reportsProcessMultipleSubmitExcel.asp";
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
	str=Calender.value
	document.forms["frmDetails"].elements["HiddenDate"].value = str
	whole = document.forms["frmDetails"].elements["HiddenDate"].value
	day = document.forms["frmDetails"].elements["HiddenDate"].value.substring (8,10)
	day.replace (" ","")
	month = document.forms["frmDetails"].elements["HiddenDate"].value.substring (4,7)
	strlength = document.forms["frmDetails"].elements["HiddenDate"].value.length
	year = document.forms["frmDetails"].elements["HiddenDate"].value.substring (strlength-4,strlength)
	if (day<10) {
	day='0'+ day
	}
	if (day>=10) {
	day=day + " "
	}

	SelectedDate.value = day  + month + " " + year	
}

function MaxSelection(sellobj)
{
	var len = document.frmDetails.elements.length;
	var obj;
	var count = 0;
	var limit = 20;
	var newobj = '';
	var newoptions = '';
	var newattached = '';
	
	//alert("Max Selection");
	
	for(var i = 0; i < len; i++)
	{
		if(document.frmDetails.elements[i].type == 'select-multiple')
		{
			obj = document.frmDetails.elements[i].name;
			
			//alert("selected this " + obj );
			
			for(var j = 0; j < document.getElementById(obj).options.length; j++)
			{
				if(document.getElementById(obj)[j].selected)
				{
					newobj = newobj + "," + obj;
					newoptions = newoptions + "," + document.getElementById(obj)[j].index;
					newattached = newattached + ", " + document.getElementById(obj)[j].value;
					
					//alert("list is " + newobj + " * " + newoptions + " * " + newattached);
					count++
				}
			}
			
			if(count > limit)
			{
				alert("You have exceeded the maximum criteria allowed." + "\nMaximum criteria allowed is " + limit + " options")

				var newobjArray = newobj.split(",");
				var newoptionsArray = newoptions.split(",");

				for(var k = newobjArray.length - 1; k > limit; k--)
				{
					count--
					document.getElementById(newobjArray[k])[newoptionsArray[k]].selected = false;
				}
			}
			
			document.getElementById('newattached').value = newattached;
		}
	}
}

</script>