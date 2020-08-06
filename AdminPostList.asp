<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
color1="#f4f4f4"
color2="#fafafa"
counter=0
' so the menu include - datamenu.inc knows what page we're on
dim strPage
dim strFrom

' Check to see if they are managers - set at Log-On - 1 = Manager  0 = User'
'IF session("Administrator") = "1" THEN
'  strManager = "1" 
'ELSE
'  strManager = session("UserStatus")
'END IF  

strPage="Posts"
strFrom=""
	if request("sort")="" then
		sort=1
	else
		sort=request("sort")
	end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

strCommand = "spGetHierarchyList"
objCmd.CommandText = strCommand

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara
set rsHrc = objCmd.Execute
'
'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next

if request("doSearch")=1 then
	post = replace(request("post"),"'","''")
	assignno = replace(request("assignno"),"'","''")
	'teamID = request("teamID")
	hrcID = request("hrcID")
	postHolder = replace(request("postholder"),"'","''")
	ghost = 0
'	if request("chkGhost") = "" then
'		ghost = 0
'	else
'		ghost = 1
'	end if
	strstatus = request("Status")
else
	post = ""
	assignno = ""
	hrcID = 0
	postHolder = ""
	ghost = 0
	strstatus = 1
end if

strCommand = "spPostSearchResults"
objCmd.CommandText = strCommand

'response.write("Post Is " & nodeID & " * " & post)


set objPara = objCmd.CreateParameter ("post",200,1,50, post)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("assignno",200,1,50, assignno)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("hrcID",200,1,50, hrcID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("postholder",200,1,50, postHolder)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("ghost",11,1,1, ghost)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("status",11,1,1, strstatus)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("sort",3,1,0, sort)
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
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->



<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>
<body>
<form action="AdminPostList.asp" method="POST" name="frmDetails">
	<Input name="DoSearch"  id="DoSearch" type="Hidden" value="1">
	<Input name="Page" id="Page" type="Hidden" value="1">
	<Input name="Sort" id="Sort" type="Hidden" value="<%=sort%>">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
		<tr>
			<td>
				<!--#include file="Includes/Header.inc"--> 
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Posts</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
						<td width=16></td>
						<td align=left>
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr height=16 class=SectionHeader>
									<td>
                                        <!--<table width="<% 'if strManager = "1" then %>250<%' else %>133<%' end if %>" border=0 cellpadding=0 cellspacing=0 >-->
                                        <table width="250" border=0 cellpadding=0 cellspacing=0 >
                                            <tr>
                                                <td width=8 class=toolbar></td>
                                                <% 'if strManager = "1" then %>
                                                    <td width=15><a class=itemfontlink href="AdminPostAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
                                                    <td width=80 class=toolbar align="center">New Post</td>
                                                    <td width=10 class=titleseparator align="center">|</td>
                                                <%' end if %> 
                                                <td width=20><a class=itemfontlink href="javascript:frmDetails.submit();"><img class="imagelink" src="images/icongo01.gif"></a></td>
                                                <td width=35 class=toolbar align="center">Find</td>
                                                <td width=10 align="center" class=titleseparator>|</td>
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
										<td colspan="6">&nbsp;</td>
									</tr>
									<tr class=searchheading height=22>
										<td valign="middle" width=1%>&nbsp;</td>
										<td valign="middle" width=7%>Post:</td>
										<td valign="middle" width=15%><input class="itemfont" style="width:150px" maxLength=20 name="post" id="post" value="<%=request("post")%>"> 
                                        <td valign="middle" width=2%>&nbsp;</td>
										<td valign="middle" width=9%>Assign No:</td>
										<td valign="middle" width=66%><input class="itemfont" style="width:150px" maxLength=20 name="assignno" id="assignno" value="<%=request("assignno")%>"></td>
									</tr>
									<tr class=searchheading height=22>
										<td valign="middle" width=1%>&nbsp;</td>
										<td valign="middle" width=7%>Unit:</td>
										<td valign="middle" width=15%>
                                            <select class="itemfont" name="hrcID" id="hrcID" style="width:170px">
                                                <option value=0>All</option>
                                                <% do while not rsHrc.eof %>
                                                    <option value="<%= rsHrc("hrcID")%>" <% if int(rsHrc("hrcID"))=int(request("hrcID")) then response.write " Selected"%>><%= rsHrc("hrcname")%></option>
                                                    <% rsHrc.movenext %>
                                                <% loop %>
                                            </select>
										</td>
                                        <td valign="middle" width=2%>&nbsp;</td>
										<td valign="middle" width=9%>Post Holder Name:</td>
										<td valign="middle" width=66%><input class="itemfont" style="width:150px" maxLength=20 name="postholder" id="postholder" value="<%=request("postholder")%>"></td>
									</tr>
                                    <tr class="searchheading" height="22">
                                    	<td valign="middle" width=1%>&nbsp;</td>
                                        <!--
                                        <td valign="middle" width=11%>Ghost Posts:</td>
                                        <td valign="middle" width=18%><input name="chkGhost" type="checkbox" id="chkGhost" value="1" <%'if ghost=1 then%>checked<%'end if%>></td>
                                        <td valign="middle" width=2%>&nbsp;</td>
                                        -->
                                        <td valign="middle" width=7%>Status:</td>
                                        <td valign="middle" width=15%>
                                        	<select name="Status" id="Status" class="itemfont" style="width:70px;">
                                            	<option value="1" <% if strstatus = 1 then %>selected<% end if %>>Active</option>
                                                <option value="0" <% if strstatus = 0 then %>selected<% end if %>>Inactive</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="6">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan="6" class="titlearealine" height="1"></td>
                                    </tr>
								</table>
							</td>
						</tr>
					  <tr>
					    <td>
						  <table width=99% border=0 cellpadding=0 cellspacing=0>
							<tr class=itemfont height=30>
								<td valign="middle" width=2%></td>
								<td colspan=5 valign="middle" width=13%>Search Results: <Font class=searchheading>records found: <strong><%=rsRecSet.recordcount%></strong></Font></td></tr>
							              						<tr>
								<td colspan=5 class=titlearealine  height=1></td> 
							</tr>
						    <tr class=columnheading height=30>
							  <td valign="middle" width=2%>&nbsp;</td>
							  <td valign="middle" width=25% onclick="javascript:SortByCol1 ();" class="mouseHand">Post<%if sort=1 then%><img src="images/searchUp.jpg"><%end if%><%if sort=2 then%><img src="images/searchDown.jpg"><%end if%></td>
							  <td valign="middle" width=10% onclick="javascript:SortByCol2 ();" class="mouseHand">Assign No.<%if sort=3 then%><img src="images/searchUp.jpg"><%end if%><%if sort=4 then%><img src="images/searchDown.jpg"><%end if%></td>
							  <td valign="middle" width=25% onclick="javascript:SortByCol3 ();" class="mouseHand">Team<%if sort=5 then%><img src="images/searchUp.jpg"><%end if%><%if sort=6 then%><img src="images/searchDown.jpg"><%end if%></td>
							  <td valign="middle" width="40%" onclick="javascript:SortByCol4 ();" class="mouseHand">Post Holder<%if sort=7 then%><img src="images/searchUp.jpg"><%end if%><%if sort=8 then%><img src="images/searchDown.jpg"><%end if%></td>
							</tr>
						  	<tr>
       						  <td colspan=5 class=titlearealine  height=1></td> 
     					    </tr>
							<% objCmd.CommandText = "spTeamCurrStage"	'Name of Stored Procedure' %>
							<% if rsRecSet.recordcount > 0 then %>
								<% Row = 0 %>
								<% do while Row < recordsPerPage %>
                                    <tr class=itemfont ID="TableRow<%=rsRecSet ("PostID")%>" height=30 <%if counter=0 then%>style="background-color:<%=color1%>;"<%else%>style="background-color:<%=color2%>;"<%end if%>>
                                        <td valign="middle" width="2%">&nbsp;</td>
                                        <td valign="middle" width="25%"><a class=itemfontlink href="AdminPostDetail.asp?RecID=<%=rsRecSet("PostID")%>"><%=rsRecSet("description")%></A></td>                                    
                                        <td valign="middle" width="10%"><%=rsRecSet("AssignNo")%></td>
                                        <td valign="middle" width="25%"><%=rsRecSet("Team")%></td>
                                        <td valign="middle" width="40%"><%=rsRecSet("PostHolder")%></td>
                                    </tr>
                                    <tr>
                                    	<td colspan=5 class=titlearealine height=1></td> 
                                    </tr>							  
									<% Row = Row + 1 %>
									<% rsRecSet.MoveNext %>
									<% if counter = 0 then %>
										<% counter = 1 %>
									<% elseif counter = 1 then %>
                                    	<% counter = 0 %>
									<% end if %>
								<% loop %>
                                <tr height=22px>
                                    <td colspan=5></td>
                                </tr>											
                                <tr align="center">
                                    <td colspan=5>
                                        <table border=0 cellpadding=0 cellspacing=0>
                                            <tr height="22px">
                                                <td class=itemfont>Results Pages:&nbsp;</td>
                                                <td class=ItemLink>
                                                    <% if int(page) > 1 then %>
                                                        <a href="javascript:MovetoPage(<%=page-1%>);" class=ItemLink><< Previous</a>
                                                    <% else %>
                                                        << Previous
                                                    <% end if %>
                                                </td>
                                                <td class=itemfont>&nbsp;&nbsp;</td>
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
                                                <td class=itemfont>&nbsp;&nbsp;</td>
                                                <td class=ItemLink>
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
                                <tr class=itemfont height=20>
                                    <td valign="middle" width=2%></td>
                                    <td class=itemfontlink valign="middle" colspan=4 width=2%>Your search returned no results</td>
                                </tr>
                                <tr>
                                    <td colspan=6 class=titlearealine  height=1></td> 
                                </tr>
							<% end if %>
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
			</td>  
		</tr>
	</table>
</form>
<%
rsRecSet.close
set rsRecSet=Nothing
con.close
set con=Nothing
%>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
function MovetoPage (PageNo) {
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

function SortByCol2 () {
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

function SortByCol3 () {
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

function SortByCol4 () {
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

function Reset()
{
	document.getElementById('post').value = '';
	document.getElementById('assignno').value = '';
	document.getElementById('hrcID').selectedIndex = 0;
	document.getElementById('postHolder').value = '';
	document.getElementById('chkGhost').checked = false;
	document.getElementById("doSearch").value = 0;
	document.frmDetails.submit();
}

</Script>
