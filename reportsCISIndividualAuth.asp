<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
itemsListed=6
location="Reports"
subLocation="13"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4	

set objPara = objCmd.CreateParameter ("nodeID",3,1,5, session("nodeID"))
objCmd.Parameters.Append objPara
objCmd.CommandText = "spListHierarchyDropDown"
set rsHrcList = objCmd.Execute
	
if request("page") <>"" then
	page = int(request("page"))
else
	page = 1
end if

strDoSearch = request("DoSearch")

if strDoSearch = "" then
	strDoSearch = 0
end if

if strDoSearch = 0 then
	surname = ""
	firstname = ""
	serviceno = ""
	taskID = 0
	hrcID = 0
	rsrecount=0
else
	surname = replace(request("surname"),"'","''")
	firstname = replace(request("firstname"),"'","''")
	serviceno = replace(request("serviceno"),"'","''")
	hrcID = request("cboHrc")
	
'	for x = 1 to objCmd.parameters.count
'		objCmd.parameters.delete(0)
'	next
	
	'response.write(hrcID)
	'response.end()
	
	strCommand = "spGetAuthIndividuals"
	objCmd.CommandText = strCommand
	set objPara = objCmd.CreateParameter ("surname",200,1,50, surname)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("firstname",200,1,50, firstname)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("serviceno",200,1,50, serviceno)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("hrcID",3,1,0, hrcID)
	objCmd.Parameters.Append objPara
	
	set rsSearchResults = objCmd.Execute
	
	rsrecount=rsSearchResults.recordcount
	
	if request("page") <> "" then
		page = int(request("page"))
	else
		page = 1
	end if
	
	recordsPerPage = 20	
	num = rsSearchResults.recordcount
	startRecord = (recordsPerPage * page) - recordsPerPage
	totalPages = (int(num/recordsPerPage))
	
	if int(num - (recordsPerPage * totalPages)) > 0 then totalPages=totalPages+1
	if page = totalPages then recordsPerPage = int(num - startRecord)
	if rsSearchResults.recordcount>0 then rsSearchResults.move(startRecord)
	
	beginAtPage=1
	increaseAfter = 6
	startEndDifference = 9
	
	if page - increaseAfter > 1 then 
		beginAtPage = page - increaseAfter
	end if
	
	if totalPages < beginAtPage + startEndDifference then
		beginAtPage = totalPages - startEndDifference
	end if
	
	endAtPage = beginAtPage + startEndDifference
	if beginAtPage < 1 then beginAtPage = 1
	
end if
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
                        <td><a title="" href="index.asp" class=itemfontlinksmall>Home</a> > <A href='reportsHome.asp' class=itemfontlinksmall >Reports</A> > <font class='youAreHere'>CIS Individual Auth</font></td>
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
                            <table border=0 cellpadding=0 cellspacing=0 width=100%>	
                                <tr class=SectionHeader>							
                                    <td>
                                        <table border=0 cellpadding=0 cellspacing=0 width="250px">
                                            <tr height=28px>
                                                <td width="10px" ><a class=itemfontlink href="javascript:launchReportWindow();"><img class="imagelink" src="images/report.gif"></a></td>
                                                <td width="90px" class=toolbar valign="middle" align="left" >Create Report</td>
                                                <!--
                                                <td width="10px" class=titleseparator valign="middle" align="center">|</td>
                                                <td width="25px"><a class=itemfontlink href="javascript:launchReportWindowExcel();"><img class="imagelink" src="images/excel.gif"></a></td>
                                                <td width="100px" class=toolbar valign="middle" >Create In Excel</td>
                                                -->
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr >
                                    <td align=left valign=top>
                                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                            <tr height="16">
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <form action="" method="POST" name="frmDetails">
                                                        <Input name="RecID" id="RecID"  type="hidden" value=<%=request("RecID")%>>
                                                        <Input name="DoSearch" id="DoSearch" type="hidden" value="<%=strDoSearch%>">
                                                        <input name="currentlyChecked" id="currentlyChecked" type=hidden value=<%=request("currentlyChecked")%>>
                                                        <input name ="criteriaChange" id ="criteriaChange" type=hidden value=0>
                                                        <Input name="Page" id="Page"  type="hidden" value=1>
                                                        <input name="newattached" id="newattached" type="hidden" value="start">
                                                        <table width="955px" border="0" cellpadding="0" cellspacing="0">
                                                            <tr class="columnheading">
                                                                <td width="100" align="left" class="subheading">Select Unit:</td>
                                                                <td width="220" valign="middle">
                                                                    <select name="cboHrc" id="cboHrc"  class="pickbox" style="width:180px;">
                                                                        <option value="0">All</option>
                                                                        <%do while not rsHrcList.eof%>
                                                                            <option value="<%=rsHrcList("hrcID")%>" <% if cint(request("cboHrc")) = cint(rsHrcList("hrcID")) then %>selected<% end if %>><%=rsHrcList("hrcname")%></option>
                                                                            <%rsHrcList.movenext%>
                                                                        <%loop%>
                                                                    </select>
                                                                </td>
                                                                <td width="100"></td>
                                                                <td width="210"></td>
                                                                <td width="100"></td>
                                                                <td width="170"></td>
                                                                <td width="20"></td>
                                                                <td width="35"></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="subheading">Service No:</td>
                                                                <td><input name="serviceno" type="text" id="serviceno" value="<%= request("serviceno") %>" class="itemfont" /></td>
                                                                <td align="left" class="subheading">Surname:</td>
                                                                <td><input name="surname" type="text" id="surname" value="<%= request("surname") %>" class="itemfont" /></td>
                                                                <td align="left" class="subheading">First Name:</td>
                                                                <td><input name="firstname" type="text" id="firstname" value="<%= request("firstname") %>" class="itemfont" /></td>
                                                                <td><img class="imagelink" onClick="javascript:setSearch();" src="images/icongo01.gif"><a class=itemfontlink href=""></a></td>
                                                                <td class=toolbar align="center">Find</td>
                                                            </tr>
                                                        </table>
                                                    </form>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="5" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr>
                                                <td colspan="5">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td valign=top>
                                                    <form action="" method="post" name="frmPers" id="frmPers">
                                                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                                                            <tr class=itemfont height=20>
                                                                <td colspan=4 valign="middle" >Search Results: <%if isObject(rsSearchResults) then%><Font class=searchheading>records found: <%=rsSearchResults.recordcount%><%end if%></Font></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan=4 class=titlearealine  height=1></td> 
                                                            </tr>
                                                            <tr class=columnheading>
                                                                <td>
                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td width="100" height=22 valign="middle">Service No</td>
                                                                            <td width="100" height=22 valign="middle">Rank</td>
                                                                            <td width="350" height=22 valign="middle">Surname</td>
                                                                            <td width="350" height=22 valign="middle">Firstname</td>
                                                                            <td width="50" valign="middle" align="center">Select</td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan=4 class=titlearealine  height=1></td> 
                                                            </tr>
                                                            <% if rsrecount > 0 then %>
                                                                <% Row = 0 %>
                                                                <% do while Row < recordsPerPage %>
                                                                    <tr>
                                                                        <td>
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                    <tr id="TableRow<%=Row%>" class=toolbar>
                                                                                        <td width="100" height=22 valign="middle"><%=rsSearchResults("serviceno")%></td>
                                                                                        <td width="100" height=22 valign="middle"><%=rsSearchResults("ShortDesc")%></td>
                                                                                        <td width="350" height=22 valign="middle"><%=rsSearchResults("surname")%></td>
                                                                                        <td width="350" height=22 valign="middle"><%=rsSearchResults("firstname")%></td>
                                                                                        <td width="50" height=22 valign="middle" align="center"><input type="radio" name="StaffID" value="<%=rsSearchResults("staffID")%>"></td>
                                                                                    </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class=titlearealine height=1></td> 
                                                                    </tr>
                                                                    <% row = row + 1 %>
                                                                    <% rsSearchResults.movenext %>
                                                                <% loop %>
                                                                <tr>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr align="center">
                                                                    <td colspan=4>
                                                                        <table border=0 cellpadding=0 cellspacing=0>
                                                                            <tr>
                                                                                <td class=itemfont height=22>Results Pages: &nbsp;</td>
                                                                                <td class=ItemLink height=22>
                                                                                    <% if int(page) > 1 then %>
                                                                                        <a id=previousButton href="javascript:MovetoPage(<%=page-1%>);" class=ItemLink><< Previous</a>
                                                                                    <% else %>
                                                                                        << Previous
                                                                                    <% end if %>
                                                                                </td>
                                                                                <td class=itemfont height=22>&nbsp;&nbsp;</td>
                                                                                <% pagenumber = beginAtPage %>
                                                                                <% do while pagenumber <= endAtPage %>
                                                                                    <td>
                                                                                        <a class="<% if page <> pagenumber then %>ItemLink<% else %>itemfontbold<% end if %>" href="javascript:MovetoPage(<%= pagenumber %>);"><%= Pagenumber %></a>
                                                                                        <%if pagenumber < (endAtPage) then%>
                                                                                            <font class="itemfont">,</font>
                                                                                        <%end if%>
                                                                                    </td>
                                                                                    <% pageNumber = pageNumber + 1 %>
                                                                                <% loop %>
                                                                                <td class=itemfont height=22>&nbsp;&nbsp;</td>
                                                                                <td class=ItemLink height=22>
                                                                                    <% if int(page) < int(endAtPage) then %>
                                                                                        <a id=nextButton href="javascript:MovetoPage(<%= page + 1 %>);" class=ItemLink>Next >></a>
                                                                                    <% else %>
                                                                                        Next >>
                                                                                    <% end if %>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            <% else %>
                                                                <tr>
                                                                    <td>
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr class=itemfont>
                                                                                <td align="center" valign="middle" height=22>Your search returned no results</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan=4 class=titlearealine  height=1></td> 
                                                                </tr>
                                                            <% end if %>
                                                        </table>
                                                    </form>
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
	</table>
</body>
</html>

<script language="javascript">

var win = null;

function launchReportWindow()
{
	if(win)
	{
		win.close();
	}

	for(var i = 0; i < document.frmPers.elements.length; i++)
	{
		if (document.frmPers.elements[i].checked == true)
		{
			document.frmDetails.newattached.value = document.frmPers.elements[i].value;
		}
	}

	if(document.frmDetails.newattached.value=="start")
	{
	    alert("Select personnel")
	    return;	  		
    }
		
	var x = (screen.width);
	var y = (screen.height);
	
	document.frmDetails.target = "Report";
	document.frmDetails.action="reportsCISIndividualAuthSubmit.asp";
	win = window.open("","Report","top=0,left=0,width="+x+",height="+y+",toolbar=0,menubar=1,scrollbars=1");
	window.setTimeout("document.frmDetails.submit();",500);
	
	document.frmDetails.DoSearch.value=0;
}

function launchReportWindowExcel()
{
	if (win)
	{
		win.close();
	}

	for(var i = 0; i < document.frmPers.elements.length; i++)
	{
		if (document.frmPers.elements[i].checked == true)
		{
			document.frmDetails.newattached.value = document.frmPers.elements[i].value;
		}
	}

	if(document.frmDetails.newattached.value=="start")
	{
	    alert("Select personnel")
	    return;	  		
    }
	
	document.frmDetails.action="reportsCISIndividualAuthExcel.asp";
	document.frmDetails.submit();
	
	document.frmDetails.DoSearch.value=0;
}

function setSearch()
{
	for(var i = 0; i < document.frmPers.elements.length; i++)
	{
		if (document.frmPers.elements[i].checked == true)
		{
			document.frmPers.elements[i].checked = false;
		}
	}
	
	document.frmDetails.target = "";
	document.frmDetails.action = "";
	document.frmDetails.newattached.value = "start"
	document.frmDetails.DoSearch.value=1;
	document.frmDetails.submit();
}

function MovetoPage (PageNo)
{
	if(document.frmDetails.criteriaChange.value==1)
	{
		PageNo=1;
	}
	
	stringToCheck = document.frmDetails.currentlyChecked.value

	for(var i = 0; i < document.frmDetails.elements.length; i++)
	{
		currentValue=document.frmDetails.elements[i].value;
		
		if(document.frmDetails.elements[i].checked==true)
		{
			if(stringToCheck.indexOf(currentValue)<0)
			{	
				stringToCheck = stringToCheck + "," + document.frmDetails.elements[i].value;
			}
		}
		else
		{
			if(stringToCheck.indexOf(currentValue)>=0)
			{	
				stringToCheck=stringToCheck.replace(","+currentValue,"");
			}
		}
	}

	document.frmDetails.currentlyChecked.value = stringToCheck;
	document.forms["frmDetails"].elements["Page"].value = PageNo;
	document.forms["frmDetails"].submit();
}


</script>