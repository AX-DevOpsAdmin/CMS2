<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
'if isnull(session("teamID")) or session("teamID") = "" then session("teamID") = "9999"

if request ("thisDate") = "" then
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
	thisDate= splitDate(0) + " " + theMonth + " " + splitDate(2) 
else
	thisDate = request ("thisDate")
end if 

tab=6
color1="#f4f4f4"
color2="#fafafa"
counter=0

'' Check to see if they are managers - set at Log-On - 1 = Manager  0 = User
if session("Administrator") = "1" then
  strManager = "1" 
else
  strManager = session("UserStatus")
end if  

strpage = "PersonnelSearch"

if request("sort")="" then
	sort=5
else
	sort=request("sort")
end if
	
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

'Default tblRank is Node 1
strTable = "tblRank" 
strCommand = "spListTable"
objCmd.CommandText = strCommand
objCmd.CommandType = 4	
set objPara = objCmd.CreateParameter ("nodeID",200,1,50, 1)
objCmd.Parameters.Append objPara	
set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsRank = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.CommandText = "spListTrades"
set objPara = objCmd.CreateParameter ("nodeID",200,1,50, nodeID)
objCmd.Parameters.Append objPara	

set rsTrade = objCmd.Execute
for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

firstName=""

if request("doSearch")=1 then
	firstName = replace(request("firstName"),"'","''")
	surname = replace(request("surName"),"'","''")
	serviceNo = replace(request("ServiceNo"),"'","''")
	RankID = request("RankID")
	post = replace(request("post"),"'","''")
	assignNo= replace(request("assignNo"),"'","''")
	tradeid = request("TradeID")
	
	if request("ooa") = "" then 
		ooa = 0
	else 
		ooa = 1
	end if
	
	if request("mgr") = "" then 
		mgr = 0
	else 
		mgr = 1
	end if

	if request("admin") = "" then 
		admin = 0
	else 
		admin = 1
	end if
	
	strCommand = "spPersonnelSearchResults"
	objCmd.CommandText = strCommand
	objCmd.CommandType = 4	
	set objPara = objCmd.CreateParameter ("nodeID",200,1,50, nodeID)
    objCmd.Parameters.Append objPara		
	set objPara = objCmd.CreateParameter ("firstName",200,1,50, firstName)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("surname",200,1,50, surname)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("serviceno",200,1,50, serviceno)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("RankID",3,1,0, RankID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("post",200,1,50, post)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("TradeID",3,1,0, TradeID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("sort",3,1,0, sort)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("assignNo",200,1,50, assignNo)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("thisDate",200,1,30,  thisDate)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("mgr",3,1,0, mgr)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("admin",3,1,0, admin)
	objCmd.Parameters.Append objPara
	
	set rsRecSet = objCmd.Execute
	
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
	firstName=""
	surname=""
	ServiceNo=""
	RankID=0
	post=""
	assignNo=""
	tradeid=0
	ooa=0
	mgr=0
	admin=0
	page=0
end if

if rankID="" then rankId=0
if tradeID="" then tradeID=0


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
%>

<html>
<head>
<!--#include file="Includes/IECompatability.inc"-->
<title>Squadron Data</title>
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
    <form action="HierarchyPersonnelSearch.asp" method="post" name="frmDetails" id="frmDetails">
        <Input name="DoSearch" id="DoSearch" type=Hidden value=1>
        <Input name="Page"  id="Page" type=Hidden value=1>
        <Input name="Sort" id="Sort" type=Hidden value=<%=sort%>>
        <Input name="checkChange" id="checkChange" type=Hidden value=0>
        <input name="recID" id="recID" type="hidden" value="<%=request("recID")%>">
        <input name="thisDate" id="thisDate" type="hidden" value="<%=thisDate%>">
        <input name="postID" id="postID" type="hidden" value="<%=request("postID")%>">
        <input name="staffPostID" id="staffPostID" type="hidden" value="<%=request("staffPostID")%>">
        <input name="staffID" id="staffID" type="hidden">
        <input name="hrcID" id="hrcID" type="hidden">
        
        <%if session("Administrator")=1 then%>
        <input type = hidden name="Mgr" id="Mgr" value="">
        <input type = hidden name="admin" id="admin"  value="" >
        <%end if%>

		<table border=0 cellpadding=0 cellspacing=0 width=100%>
			<!--include file="Includes/hierarchyTeamDetails.inc"--> 
            <tr height=16 class=SectionHeader>
                <td width="100%">
                    <table width=133 border=0 cellpadding=0 cellspacing=0 >
                        <tr> 
                             <td class=toolbar width=8></td>
                             <td width=20><a class=itemfontlink href="javascript:frmDetails.submit();"><img class="imagelink" src="images/icongo01.gif"></a></td>
                             <td width=35 class=toolbar align="center">Find</td>
							 <td width=10 class=titleseparator align="center">|</td>
                             <td width=20 align="center"><a class=itemfontlink href="javascript:Reset();"><img class="imagelink" src="Images/reset.gif"></a></td>
                             <td width=40 class=toolbar align="center">Reset</td>
                        </tr>  
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table width=100% border=0 cellpadding=0 cellspacing=0>
                        <tr height=16>
                            <td colspan="9">&nbsp;</td>
                        </tr>
                        <tr class=searchheading height=22>
                            <td valign="middle" width=2%>&nbsp;</td>
                            <td valign="middle" width=11%>Surname:</td>
                            <td valign="middle" width=18%><input class="inputboxsearch itemfont" style="width: 150px" maxLength="20" name="surname" id="surname" value="<%= replace(surname,"''","'") %>" onchange="javascript:newSearch();"></td>
                            <td valign="middle" width=2%>&nbsp;</td>
                            <td valign="middle" width=11%>First Name:</td>
                            <td valign="middle" width=18%><input class="inputboxsearch itemfont" style="width: 150px" maxLength="20" name="firstname" id="firstname" value="<%= replace(firstname,"''","'") %>"></td>
                            <td valign="middle" width=2%>&nbsp;</td>
                            <td valign="middle" width=11%>Trade:</td>
                            <td valign="middle" width=43%>
                                <Select  Name="tradeID" id="tradeID" style="width:170px;">
                                    <option value=0>All</option>
                                    <%do while not RSTrade.eof%>
                                    <option value=<%=RSTrade("TradeID")%> <%if int(RSTrade("TradeID"))=int(TradeID) then response.write " Selected"%>><%=RSTrade("Description")%></option>
                                    <%RSTrade.Movenext
                                    loop%>
                                </Select>
                            </td>
                        </tr>
                        <tr class=searchheading height=22>
                            <td valign="middle"></td>
                            <td valign="middle">Service No:</td>
                            <td valign="middle"><input class="inputboxsearch itemfont" style="WIDTH: 150px" maxLength=20 name="serviceno" id="serviceno" value="<%= replace(serviceno,"''","'") %>"></td>
                            <td valign="middle"></td>
                            <td valign="middle">Rank:</td>
                            <td valign="middle">
                                <Select  Name="rankID" id="rankID" >
                                    <option value=0>All</option>
                                    <%do while not RSRank.eof%>
                                    <option value=<%=RSRank("RankID")%> <%if int(RSRank("RankID"))=int(RankID) then response.write " selected"%>><%=RSRank("shortDesc")%></option>
                                    <%RSRank.Movenext
                                    loop%>
                                </Select>
                            </td>
                            <td valign="middle">&nbsp;</td>
                            <td valign="middle"><%if session("Administrator")=1 then%>Administrators:<% end if %></td>
                            <td valign="middle"><%if session("Administrator")=1 then%><input name="admin" id="admin" type="checkbox" value=1 <%if admin=1 then%>checked<%end if%>><%end if%></td>
                        </tr>
                        <tr class=searchheading height=22>
                            <td valign="middle"></td>
                            <td valign="middle">Post:</td>
                            <td valign="middle" class=itemfont><input class="inputboxsearch itemfont" style="WIDTH: 150px" maxLength=20 name="post" id="post" value="<%= replace(post,"''","'") %>"></td>
                            <td valign="middle"></td>
                            <td valign="middle">Assign No:</td>
                            <td valign="middle"><input class="inputboxsearch itemfont" style="WIDTH: 150px" maxLength=20 name="assignNo" id="assignNo" value="<%= replace(assignNo,"''","'") %>"></td>
                            <td valign="middle">&nbsp;</td>
                            <td valign="middle"><%if session("Administrator")=1 then%>Managers:<% end if %></td>
                            <td valign="middle"><%if session("Administrator")=1 then%><input name="Mgr" id="Mgr" type="checkbox" value=1 <%if mgr=1 then%>checked<%end if%>><%end if%></td>
                        </tr>                        <tr>
                            <td colspan="9">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="9" class="titlearealine" height="1"></td>
                        </tr>
                    </table>
                <td width="0%"></td>
            </tr>
			<%if isObject(rsRecSet) then%>
            <tr>
                <td>
                    <table width=100% border=0 cellpadding=0 cellspacing=0>
                        <tr class=itemfont height=30>
                            <td valign="middle" width=1%>&nbsp;</td>
                            <td colspan=10 valign="middle" width=10%>Search Results: <Font class=searchheading><b>Records found <%=rsRecSet.recordcount%></b></Font></td>
                        </tr>
                        <tr>
                            <td colspan="11" class=titlearealine  height=1></td> 
                        </tr>
                        <tr>
                            <td colspan="11">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan=11 class=titlearealine  height=1></td> 
                        </tr>
                        <tr class=columnheading height=30>
							<td valign="middle" width=1%>&nbsp;</td>
							<td valign="middle" width=8% onclick="javascript:SortByCol5();" class="mouseHand">Assign No<%if sort=9 then%><img src="images/searchUp.jpg"><%end if%><%if sort=10 then%><img src="images/searchDown.jpg"><%end if%></td>
							<td valign="middle" width=8% onclick="javascript:SortByCol1();" class="mouseHand">Service No<%if sort=5 then%><img src="images/searchUp.jpg"><%end if%><%if sort=6 then%><img src="images/searchDown.jpg"><%end if%></td>
							<td valign="middle" width=7% class="mouseHand">Rank</td>
							<td valign="middle" width=15% onclick="javascript:SortByCol2();" class="mouseHand">First Name<%if sort=3 then%><img src="images/searchUp.jpg"><%end if%><%if sort=4 then%><img src="images/searchDown.jpg"><%end if%></td>
							<td valign="middle" width=11% onclick="javascript:SortByCol3();" class="mouseHand">Surname<%if sort=1 then%><img src="images/searchUp.jpg"><%end if%><%if sort=2 then%><img src="images/searchDown.jpg"><%end if%></td>
							<td valign="middle" width=11% onclick="javascript:SortByCol6();" class="mouseHand">Last OOA Date<%if sort=11 then%><img src="images/searchUp.jpg"><%end if%><%if sort=12 then%><img src="images/searchDown.jpg"><%end if%></td>
							<td valign="middle" width=7% align=left>MES</td>
							<td valign="middle" width=14% onclick="javascript:SortByCol4();" class="mouseHand">Unit
							  <%if sort=7 then%><img src="images/searchUp.jpg"><%end if%><%if sort=8 then%><img src="images/searchDown.jpg"><%end if%></td>
							<td valign="middle" width=6% align="center"><%if session("Administrator")=1 then%>Manager<%end if%></td>
							<td valign="middle" width=6% align="center"><%if session("Administrator")=1 then%>Admin<%end if%></td>
                        </tr>
                        <tr>
                          <td colspan="11"  class=titlearealine  height=1></td> 
                        </tr>
						<%if rsRecSet.recordcount > 0 then%>
							<%Row=0%>
							<%do while Row < recordsPerPage%>
								<%teamID = rsRecSet("hrcID")%>
                                <% 'if isnull(teamID) then teamID = 9999 %>
                                <tr class=itemfont ID="TableRow<%=rsRecSet ("staffID")%>" height=30 <%if counter=0 then%>style="background-color:<%=color1%>;"<%else%>style="background-color:<%=color2%>;"<%end if%>>
                                    <td valign="middle" width=1%></td>
                                    <td valign="middle"><%=rsRecSet("assignno")%></td>
                                    <td valign="middle"><%if cint(session("Administrator"))=1 or strManager=1 and cint(rsRecSet("staffID")) = cint(session("staffID")) or cint(hrcID) = cint(session("hrcID")) then%><A class=itemfontlink href='javascript:window.parent.frmDetails.hrcID.value="<%if rsRecSet("hrcID")<>"" then response.write rsRecSet("hrcID") else response.write "0" end if%>";frmDetails.recID.value="<%=rsRecSet("hrcID")%>";frmDetails.postID.value="<%=rsRecSet("postID")%>";gotoStaffDetails(<%=rsRecSet ("staffID")%>,<%=rsRecSet("hrcID")%>)'><%=rsRecSet("serviceno")%></A><% else %><%=rsRecSet("serviceno")%><% end if %></td>
                                    <td valign="middle"><%=rsRecSet("rank")%></td>
                                    <td valign="middle"><%=rsRecSet("firstname")%></td>
                                    <td valign="middle"><%=rsRecSet("surname")%></td>
                                    <td valign="middle"><%=rsRecSet("lastOOA")%></td>
                                    <td valign="middle"><%=rsRecSet("messtat")%></td>
                                    <td valign="middle"><A class=itemfontlink href='javascript:window.parent.frmDetails.hrcID.value="<%=rsRecSet("hrcID")%>";window.parent.frmDetails.fromSearch.value="<%=rsRecSet("postID")%>";window.parent.refreshIframeAfterDateSelect("HierarchyTaskingView.asp");'><%=rsRecSet("hrcname")%></A></td>
                                    <td valign="middle" align="center"><%if session("Administrator")=1 then%><%if rsRecSet("manager")<>"" then%><img src="images/yes.gif"><%else%><img src="images/no.gif"><%end if%><%end if%></td>
                                    <td valign="middle" align="center"><%if session("Administrator")=1 then%><%if cint(rsRecSet("administrator"))=true then%><img src="images/yes.gif"><%else%><img src="images/no.gif"><%end if%><%end if%></td>                                
                                </tr>
                                <tr>
                                    <td colspan="11"  class=titlearealine  height=1></td> 
                                </tr>
                                <% Row=Row+1
                                rsRecSet.MoveNext
                                if counter=0 then
                                    counter=1
                                else
                                    if counter=1 then counter=0
                                end if
                            Loop%>
							<tr height=30px>
								<td colspan=11></td>
							</tr>
                            <tr align="center">
                                <td colspan=11>
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
						<%else%>
                            <tr class=itemfont height=30>
                                <td valign="middle" width=1%>&nbsp;</td>
                                <td colspan="10" class=valign="middle" width=99%>Your search returned no results</td>
                            </tr>
                            <tr>
                                <td colspan=11 class=titlearealine  height=1></td> 
                            </tr>
						<%end if%>                        
					</table>
				</td>
			</tr>
			<%end if%>
		</table>
	</form>

<%
if isObject(rsRecSet) then 
	rsRecSet.close
	set rsRecSet=Nothing
end if

con.close
set con=Nothing
%>

</body>
</html>

<script language="JavaScript">

function gotoStaffDetails(staffID, hrcID)
{
	document.frmDetails.action="HierarchyPersDetail.asp";
	document.frmDetails.staffID.value=staffID;
	document.frmDetails.hrcID.value=hrcID;
	document.frmDetails.submit();
	window.parent.startTimer();
}

function MovetoPage(PageNo)
{
	/*
	var checkChange = document.forms["frmDetails"].elements["checkChange"].value;
	
	if(checkChange==0)
	{
		document.forms["frmDetails"].elements["Page"].value = PageNo;
	}
	else
	{
		document.forms["frmDetails"].elements["Page"].value = 1;
	}
	*/
	document.forms["frmDetails"].elements["Page"].value = PageNo;
	document.forms["frmDetails"].submit();
}

function SortByCol1()
{
	sort=document.forms["frmDetails"].elements["Sort"].value
	
	if(sort==5)
	{
		document.forms["frmDetails"].elements["Sort"].value=6;
	}
	
	if(sort==6)
	{
	document.forms["frmDetails"].elements["Sort"].value=5;
	}
	
	if(sort < 5 || sort>6)
	{
		document.forms["frmDetails"].elements["Sort"].value=5;
	}
	
	document.forms["frmDetails"].elements["Page"].value = <%=page%>;
	document.forms["frmDetails"].submit();
}

function SortByCol2()
{
	sort=document.forms["frmDetails"].elements["Sort"].value
	
	if(sort==3)
	{
		document.forms["frmDetails"].elements["Sort"].value=4;
	}
	
	if(sort==4)
	{
		document.forms["frmDetails"].elements["Sort"].value=3;
	}
	
	if(sort < 3 || sort>4)
	{
		document.forms["frmDetails"].elements["Sort"].value=3;
	}
	
	document.forms["frmDetails"].elements["Page"].value = <%=page%>;
	document.forms["frmDetails"].submit();
}

function SortByCol3()
{
	sort=document.forms["frmDetails"].elements["Sort"].value
	
	if(sort==1)
	{
		document.forms["frmDetails"].elements["Sort"].value=2;
	}
	
	if(sort==2)
	{
		document.forms["frmDetails"].elements["Sort"].value=1;
	}
	
	if (sort > 2)
	{
		document.forms["frmDetails"].elements["Sort"].value=1;
	}
	
	document.forms["frmDetails"].elements["Page"].value = <%=page%>;
	document.forms["frmDetails"].submit();
}

function SortByCol4()
{
	sort=document.forms["frmDetails"].elements["Sort"].value
	
	if(sort==7)
	{
		document.forms["frmDetails"].elements["Sort"].value=8;
	}
	
	if(sort==8)
	{
		document.forms["frmDetails"].elements["Sort"].value=7;
	}
	
	if(sort < 7 || sort>8)
	{
		document.forms["frmDetails"].elements["Sort"].value=7;
	}
	
	document.forms["frmDetails"].elements["Page"].value = <%=page%>;
	document.forms["frmDetails"].submit();
}

function SortByCol5()
{
	sort=document.forms["frmDetails"].elements["Sort"].value
	
	if (sort==9)
	{
		document.forms["frmDetails"].elements["Sort"].value=10;
	}
	
	if(sort==10)
	{
		document.forms["frmDetails"].elements["Sort"].value=9;
	}
	
	if(sort < 9 || sort>10)
	{
		document.forms["frmDetails"].elements["Sort"].value=9;
	}
	
	document.forms["frmDetails"].elements["Page"].value = <%=page%>;
	document.forms["frmDetails"].submit();
}

function SortByCol6()
{
	sort=document.forms["frmDetails"].elements["Sort"].value
	
	if(sort==11)
	{
		document.forms["frmDetails"].elements["Sort"].value=12;
	}
	
	if(sort==12)
	{
		document.forms["frmDetails"].elements["Sort"].value=11;
	}
	
	if(sort < 11 || sort>12)
	{
		document.forms["frmDetails"].elements["Sort"].value=11;
	}
	
	document.forms["frmDetails"].elements["Page"].value = <%=page%>;
	document.forms["frmDetails"].submit();
}

function newSearch()
{
	document.forms["frmDetails"].elements["checkChange"].value = 1;
}

function Reset()
{
	document.getElementById('surname').value = '';
	document.getElementById('serviceno').value = '';
	document.getElementById('post').value = '';
	document.getElementById('assignNo').value = '';
	document.getElementById('firstname').value = '';
	document.getElementById('rankID').selectedIndex = 0;
	document.getElementById('tradeID').selectedIndex = 0;
	document.getElementById('Mgr').checked = false;
	document.getElementById('admin').checked = false;
	document.getElementById("doSearch").value = 0;
	document.frmDetails.submit();
}

</Script>