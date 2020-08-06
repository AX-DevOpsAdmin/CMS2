<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
todayDate = formatdatetime(date(),2)

splitDate = split (todayDate,"/")
monthList = "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec"

splitMonth = split(monthList, ",")
splitNum = int(splitDate(1) - 1)
theMonth = splitMonth(splitNum)

'newTodaydate= splitDate(0) + " " + theMonth + " " + splitDate(2) 
newTodaydate = formatdatetime(date(),2)

color1="#f4f4f4"
color2="#fafafa"
counter=0
' so the menu include - datamenu.inc knows what page we're on
dim strPage
dim strFrom

strPage="Tasks"
strFrom="Manning"
	if request("sort")="" then
		sort=1
	else
		sort=request("sort")
	end if

set objCmd = server.CreateObject("ADODB.Command")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

' 'first find out whether its an HQ Tasking Group - cos if it is then we display HQ Task details
'strCommand = "spCheckHqTask"
'objCmd.CommandText = strCommand
'objCmd.CommandType = 4		
'
'set objPara = objCmd.CreateParameter ("StaffID",3,1,0, session("StaffID"))
'objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("HQTasking",3,2)
'objCmd.Parameters.Append objPara
'objCmd.Execute	             ' 'Execute CommandText when using "ADODB.Command" object
'strHQTasking   = objCmd.Parameters("HQTasking") 

' now we want to set the access level for managers
' if its HQ Tasking (RAF Police system only) then we only allow Out of Area (OOA) tasking at
' HQ Administrator level otherwise any manager is allowed to task

'IF strHQTasking= 1 THEN
'  'strShowOOA=session("SqnMgr")
'  strShowOOA=session("Administrator")
'END IF 

' 'Now Delete the parameters
'objCmd.Parameters.delete ("StaffID")
'objCmd.Parameters.delete ("HQTasking")

' set default to allow ALL managers to Task OOA
strShowOOA=1

strCommand = "spListTaskTypes"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
objCmd.Parameters.Append objPara

set rsTaskTypeList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'strCommand = "spListTaskCategories"
'objCmd.CommandText = strCommand
'objCmd.CommandType = 4		
'set rsCategoryTypeList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
intSearch= request("doSearch")
if intSearch =1 then	
	   task = request("task")
	   ttID = request("ttID")
	   startDate = request ("startDate")
	   endDate = request("endDate")
	

	strCommand = "spTaskSearchResults"
	objCmd.CommandText = strCommand
	set objPara = objCmd.CreateParameter ("task",200,1,50, task)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("ttID",3,1,0, ttID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("startDate",200,1,50, startdate)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("endDate",200,1,50, enddate)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("sort",3,1,0, sort)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("showooa",3,1,0,strshowooa)
	objCmd.Parameters.Append objPara

	set rsRecSet = objCmd.Execute
	
	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next

	if request("page")<>"" then
		page=int(request("page"))
	else
		page=1
	end if
	recordsPerPage = 20
		
	num=rsRecSet.recordcount
	startRecord = (recordsPerPage * page) - recordsPerPage
	totalPages = (int(num/recordsPerPage))

	if int(num - (recordsPerPage * totalPages)) > 0 then totalPages=totalPages+1
	if page = totalPages then recordsPerPage = int(num - startRecord)

	if rsRecSet.recordcount>0 then rsRecSet.move(startRecord)

	beginAtPage=1
	increaseAfter = 6
	startEndDifference = 9
	if page-increaseAfter >1 then 
		beginAtPage=page-increaseAfter
	end if
	
	if totalPages < beginAtPage+startEndDifference  then
		beginAtPage = totalPages-startEndDifference
	end if
	
	endAtPage=beginAtPage+startEndDifference
	if beginAtPage<1 then beginAtPage=1
else
		task=""
		ttID=0
		startDate=""
		endDate=""
		cancellable=0
		startDate = newTodaydate
		endDate = DateAdd("yyyy", 1, newTodaydate )
		'endate=formatdatetime(date(),2)
		page =0
end if
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

.style1 {color: #0000FF}
-->
</style>

</head>
<body>
<form action="ManningTaskSearch.asp?doSearch=1" method="post" name="frmDetails">
    <Input name="HiddenDate" id="HiddenDate"  type="hidden" >
    <Input name="HiddenStartDate" id="HiddenStartDate" type="hidden" >
    <Input name="HiddenEndDate"  id="HiddenEndDate" type="hidden" >
    <Input name="DoSearch" id="DoSearch" type=Hidden value=<%=intSearch%>>
    <Input name="Page" id="Page" type=Hidden value=1>
    <Input name="Sort" id="Sort" type=Hidden value=<%=sort%>>
	<table  height="100%" cellspacing="0" cellPadding="0" width="100%" border="0">
		<tr>
			<td>
				<!--#include file="Includes/Header.inc"--> 
                <table cellSpacing="0" cellPadding="0" width="100%" border="0" >
                    <tr style="font-size:10pt;" height="26px">
                    	<td width="10px">&nbsp;</td>
                    	<td><a title="" href="index.asp" class="itemfontlinksmall">Home</a> > <font class="youAreHere" style="font-size:14px">Tasking</font></td>
                    </tr>
                    <tr>
                    	<td colspan="2" class="titlearealine"  height="1"></td> 
                    </tr>
                </table>
                
                <table style="height:900px;" width=100% height="328" border="0" cellpadding="0" cellspacing="0"> 
                    <tr valign="Top">
                        <td class="sidemenuwidth" background="Images/tableback.png">
                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="MenuStyleParent">
                                <tr height="30">
                                    <td></td>
                                    <td width="9" valign="top"></td>
                                    <td width="170" align="left"><a href="index.asp">Home</a></td>
                                    <td width="50" align="Left" class="rightmenuspace" ></td>
                                </tr>
                                <tr height="30">
                                	<td></td>
                                	<td valign="top"></td>
                                	<% if strPage = "Tasks" then %>
                                		<td align="Left" class="selected">Tasking</td>
                                	<% else %>  
                                		<td align="Left"><A title="" href="ManningTaskSearch.asp">Tasking</A></td>
                                	<% end if %> 
                                	<td class="rightmenuspace" align="Left"></td>
                                </tr>
							</table>
                        </td>
              
						<td width="16">&nbsp;</td>
						<td align="left">
                            <table border="0" cellpadding="0" cellspacing="0" width="99%">
                                <tr height="16" class="SectionHeader">
                                    <td>
                                        <table width="133" border="0" cellpadding="0" cellspacing="0" >
                                            <tr>
                                                <td class="toolbar" width="8"></td>
                                                <td width="20"><a class=itemfontlink href="javascript:getSearch();"><img class="imagelink" src="images/icongo01.gif"></a></td>
                                                <td width="35" class="toolbar" align="center">Find</td>
                                                <td width="1"0 class="titleseparator" align="center">|</td>
                                                <td width="20" align="center"><a class="itemfontlink" href="javascript:Reset();"><img class="imagelink" src="Images/reset.gif"></a></td>
                                                <td width="40" class="toolbar" align="center">Reset</td>
                                            </tr>  
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr height=16>
                                                <td colspan="6">&nbsp;</td>
                                            </tr>
                                            <tr class="columnheading">
                                                <td width="16" align="left" height="30">&nbsp;</td>
                                                <td width="130" align="left" height="30">Task Type:</td>
                                                <td width="140" align="left" height="30">Task:</td>
                                                <td width="115" align="left" height="30">Start Date:</td>
                                                <td width="125" align="left" height="30">End Date:</td>
                                                <td width="274" height="30">&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading height=30>
                                                <td width=16 align="left">&nbsp;</td>
                                                <td width=130 align="left" height=30>
                                                    <Select  class="inputbox itemfont " Name=ttID style="width:170px;" onChange="frmDetails.submit();" id="ttID">
                                                        <option value=0>All</option>
                                                        <% do while not rsTaskTypeList.eof %>
                                                            <option value=<%=rsTaskTypeList("ttID")%><%if int(ttID)=int(rsTaskTypeList("ttID")) then response.write " selected "%> ><%=rsTaskTypeList("Description")%>								  </option>
                                                            <% rsTaskTypeList.movenext %>
                                                        <% loop %>
                                                    </Select>
                                                </td>
                                                <td width=140 align="left"><Input class="itemfont" style="width:120px;" Name=Task id="Task" value = <%if Task <>"" then%>"<%=Task%>"<%end if%>></td>
                                                <td align="left"><input name="startDate" type="text" id="startDate" class="itemfont"  style="Width:75px;" value ="<%=startDate%>" readonly onclick="calSet(this)">&nbsp;<img src="images/cal.gif" alt="Calender" align="absmiddle" onclick="calSet(startDate)" style="cursor:hand;"></td>
                                                <td align="left"><input name="endDate" type="text" id="endDate" class="itemfont"  style="Width:75px;" value ="<%=endDate%>" readonly onclick="calSet(endDate)">&nbsp;<img src="images/cal.gif" alt="Calender" align="absmiddle" onclick="calSet(endDate)" style="cursor:hand;"></td>
                                                <td align="left">&nbsp;</td>
                                            </tr>
                                            <tr colspan=11 height=16>
                                                <td></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                    <% if intSearch=1 then	%>
                                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                                            <tr class=itemfont height=20>
                                                <td valign="middle" width=2% height=30>&nbsp;</td>
                                                <td colspan=6 valign="middle" height=30>Tasks: <font class=searchheading>records found: <%=rsRecSet.recordcount%></font></td>
                                            </tr>
                                            <tr>
                                                <td colspan=7 class=titlearealine  height=1></td>
                                            </tr>
                                            <tr class=columnheading height=30>
                                                <td align="left" width=2%>&nbsp;</td>
                                                <td align="left" width=25% onClick="javascript:SortByCol1 ();" class="mouseHand">Task
                                                    <% if sort = 1 then %>
                                                        <img src="images/searchUp.jpg">
                                                    <% end if %>
                                                    <% if sort = 2 then %>
                                                        <img src="images/searchDown.jpg">
                                                    <% end if %>
                                                </td>
                                                <td align="left" width=15% onClick="javascript:SortByCol3 ();" class="mouseHand">Task Type
                                                    <% if sort = 5 then %>
                                                        <img src="images/searchUp.jpg">
                                                    <% end if %>
                                                    <% if sort = 6 then %>
                                                        <img src="images/searchDown.jpg">
                                                    <% end if %>
                                                </td>
                                                <!--
                                                <td width="14.5%" align="center" class="mouseHand" onClick="javascript:SortByCol4 ();">Cancellable
                                                    <%' if sort = 7 then %>
                                                        <img src="images/searchUp.jpg">
                                                    <%' end if %>
                                                    <%' if sort = 8 then %>
                                                        <img src="images/searchDown.jpg">
                                                    <%' end if %>
                                                </td>
                                                -->
                                                <td width="14.5%" align="center">Out of Area</td>
                                                <td width="14.5%" align="center">Bed Nights Away</td>                                            	
                                                <td width="14.5%" align="center"><% if strHQTasking = 1 then %>HQ Task<% end if %></td>
                                            </tr>
                                            <tr>
                                                <td colspan=7 class=titlearealine  height=1></td>
                                            </tr>
                                            <% objCmd.CommandText = "spTeamCurrStage"	'Name of Stored Procedure' %>
                                            <% if rsRecSet.recordcount > 0 then %>
                                                <% Row = 0 %>
                                                <% do while Row < recordsPerPage %>
                                                    <tr class=itemfont id="TableRow<%=rsRecSet ("TaskID")%>" height=20 <%if counter=0 then%>style="background-color:<%=color1%>;"<%else%>style="background-color:<%=color2%>;"<%end if%>>
                                                        <td valign="middle" height=30>&nbsp;</td>
                                                        <td valign="middle" height=30><a class=itemfontlink href=" javascript:ManningTaskPersonnel(<%=rsRecSet("TaskID")%>)"><%=rsRecSet("Task")%></a></td>
                                                        <td valign="middle" height=30><%=rsRecSet("Type")%></td>
                                                        <!--
                                                        <td align="center" height=30>
                                                            <%' if rsRecSet("cancellable") = true then %>
                                                                <img src="images/yes.gif">
                                                            <%' else %>
                                                                <img src="images/no.gif">
                                                            <%'+ end if %>                            
                                                        </td>
                                                        -->
                                                        <td align="center" height=30>
                                                            <% if rsRecSet("ooa") = 1 then %>
                                                                <img src="images/yes.gif">
                                                            <% else %>
                                                                <img src="images/no.gif">
                                                            <% end if %>                            
                                                        </td>
                                                        <td align="center" height=30>
                                                            <% if rsRecSet("ooa") = 2 then %>
                                                                <img src="images/yes.gif">
                                                            <% else %>
                                                                <img src="images/no.gif">
                                                            <% end if %>                            
                                                        </td>
                                                        <td align="center" height=30>
                                                            <% if strHQTasking = 1 then %>
                                                                <% if rsRecSet("hqTask") = true then %>
                                                                    <img src="images/yes.gif">
                                                                <% else %>
                                                                    <img src="images/no.gif">
                                                                <% end if %>                            
                                                            <% end if %>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=7 class=titlearealine  height=1></td>
                                                    </tr>
                                                    <% Row = Row + 1 %>
                                                    <% rsRecSet.movenext %>
                                                    <% if counter = 0 then %>
                                                        <% counter = 1 %>
                                                    <% elseif counter = 1 then %>
                                                        <% counter = 0 %>
                                                    <% end if %>                                                
                                                <% loop %>
                                                <tr height=30px>
                                                    <td colspan=7>&nbsp;</td>
                                                </tr>
                                                <tr align="center">
                                                    <td colspan=7>
                                                        <table border=0 cellpadding=0 cellspacing=0>
                                                            <tr>
                                                                <td class=itemfont height=30>Results Pages:&nbsp;</td>
                                                                <td class=ItemLink height=30>
                                                                    <% if int(page) > 1 then %>
                                                                        <a href="javascript:MovetoPage(<%=page-1%>);" class=ItemLink><< Previous</a>
                                                                    <% else %>
                                                                        << Previous
                                                                    <% end if %>
                                                                </td>
                                                                <td class=itemfont height=30>&nbsp;&nbsp;</td>
                                                                <% pagenumber = beginAtPage %>
                                                                <td>
                                                                <% do while pagenumber <= endAtPage %>
                                                                    <% if page <> pagenumber then %>
                                                                        <a class=ItemLink href="javascript:MovetoPage(<%=pagenumber%>);"><%=Pagenumber%></a><% if pagenumber < (endAtPage) then %><font class=itemfont>,</font><% end if %>
                                                                    <% else %>
                                                                        <a class="itemfontbold"><%=Pagenumber%></a><% if pagenumber < (endAtPage) then %><font class=itemfont>,</font><% end if %>
                                                                    <% end if %>                                                                                                                                                                                                                
                                                                    <% pageNumber = pageNumber + 1 %>
                                                                <% loop %>
                                                                </td>
                                                                <td class=itemfont height=30>&nbsp;&nbsp;</td>
                                                                <td class=ItemLink height=30>
                                                                    <% if int(page) < int(endAtPage) then %>
                                                                        <a href="javascript:MovetoPage(<%=page+1%>);" class=ItemLink>Next >></a>
                                                                    <% else %>
                                                                        Next >>
                                                                    <% end if %>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            <% else %>
                                                <tr class=itemfont>
                                                    <td width=1% height=30>&nbsp;</td>
                                                    <td class=itemfontlink colspan=6 height=30>Your search returned no results</td>
                                                </tr>
                                                <tr>
                                                    <td colspan=7 class=titlearealine  height=1></td>
                                                </tr>
                                            <% end if %>
                                        </table>
                                     <% end if %>
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
<%
'rsRecSet.close
'set rsRecSet=Nothing
con.close
set con=Nothing
%>
<script language="javascript" type="text/javascript" src="calendar.js"></script>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript" type="text/javascript">

function getSearch()
{
	changeDate();
	 
	var sd = document.getElementById('startDate').value;
	var ed = document.getElementById('endDate').value;
	
	var sDate = parseInt(sd.split("/")[2] + sd.split("/")[1] + sd.split("/")[0])
	var eDate = parseInt(ed.split("/")[2] + ed.split("/")[1] + ed.split("/")[0])
	
	if(sDate > eDate)
	{
		alert("Start date can not be later than end date")
		document.getElementById('startDate').value = "";
		document.getElementById('endDate').value = "";
		return
	}

	document.frmDetails.submit();
}

function ManningTaskPersonnel (recID)
{   
     document.frmDetails.action = "ManningTaskPersonnel.asp?RecID= " + recID;
	 changeDate();	 
	 document.frmDetails.submit();
}

function MovetoPage (PageNo)
{
	document.forms["frmDetails"].elements["Page"].value = PageNo;
	document.forms["frmDetails"].submit();
}

function SortByCol1 () {
	sort=document.forms["frmDetails"].elements["Sort"].value
	if (sort==1)
	{
	document.forms["frmDetails"].elements["Sort"].value=2;
	}
	if (sort==2)
	{
	document.forms["frmDetails"].elements["Sort"].value=1;
	}
	if (sort > 2)
	{
	document.forms["frmDetails"].elements["Sort"].value=1;
	}
	document.forms["frmDetails"].elements["Page"].value = <%=Page%>;

	document.forms["frmDetails"].submit();
}

function SortByCol2 ()
{
	sort=document.forms["frmDetails"].elements["Sort"].value
	if (sort==3)
	{
	document.forms["frmDetails"].elements["Sort"].value=4;
	}
	if (sort==4)
	{
	document.forms["frmDetails"].elements["Sort"].value=3;
	}
	if (sort < 3 ||sort > 4)
	{
	document.forms["frmDetails"].elements["Sort"].value=3;
	}
	document.forms["frmDetails"].elements["Page"].value = <%=Page%>;

	document.forms["frmDetails"].submit();
}

function SortByCol3 ()
{
	sort=document.forms["frmDetails"].elements["Sort"].value
	if (sort==5)
	{
	document.forms["frmDetails"].elements["Sort"].value=6;
	}
	if (sort==6)
	{
	document.forms["frmDetails"].elements["Sort"].value=5;
	}
	if (sort < 5 || sort>6)
	{
	document.forms["frmDetails"].elements["Sort"].value=5;
	}
	document.forms["frmDetails"].elements["Page"].value = <%=Page%>;

	document.forms["frmDetails"].submit();
}

function SortByCol4 ()
{
	sort=document.forms["frmDetails"].elements["Sort"].value
	if (sort==7)
	{
	document.forms["frmDetails"].elements["Sort"].value=8;
	}
	if (sort==8)
	{
	document.forms["frmDetails"].elements["Sort"].value=7;
	}
	if (sort < 7 || sort>8)
	{
	document.forms["frmDetails"].elements["Sort"].value=7;
	}
	document.forms["frmDetails"].elements["Page"].value = <%=Page%>;

	document.forms["frmDetails"].submit();
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

	SelectedDate.value = day + " " + month + " " + year
}	

// function changeDate(dtn, dtv )
function changeDate()
{
	document.frmDetails.HiddenStartDate.value = document.frmDetails.startDate.value;
	document.frmDetails.HiddenEndDate.value = document.frmDetails.endDate.value;
}

function Reset()
{
	var now = new Date();
	var newDate = new Date();
	var day = newDate.getDate();
	var month = newDate.getMonth()+1;
	if(month < 10)
	{
		month = "0"+month;	
	}
	var year = newDate.getFullYear()
	
	var todayDate = day + "/" + month + "/" + year;

	document.getElementById('ttID').selectedIndex = 0;
	document.getElementById('Task').value = '';
	document.getElementById('startDate').value = todayDate;
	document.getElementById('endDate').value = todayDate;
	document.getElementById("doSearch").value = 0;
	document.frmDetails.submit();
}

</Script>
