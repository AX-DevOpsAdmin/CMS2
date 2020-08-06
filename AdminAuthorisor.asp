<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/authsecurity.inc"-->

<%
'
''If user is not valid Authorisation Administrator then log them off
'If session("authadmin") <> 1 then
'	Response.redirect("noaccess.asp")
'End If

color1="#f4f4f4"
color2="#fafafa"
counter=0

dim strPage
strPage="PeRs"

' 'Check to see if they are managers - set at Log-On - 1 = Manager  0 = User
'if session("Administrator") = "1" then
'  strManager = "1"
'else
'  strManager = session("UserStatus")
'end if  

'strpage="PersonnelSearch"
if request("sort")="" then
	sort = 5
else
	sort = request("sort")
end if
	
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

' default to tblRank ndeID=1
strTable = "tblRank" 
strCommand = "spListTable"
objCmd.CommandText = strCommand
objCmd.CommandType = 4	
set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara	
set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsRank = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.CommandText = "spListTrades"
set objPara = objCmd.CreateParameter ("nodeID",3,1,0, session("nodeID"))
objCmd.Parameters.Append objPara	

set rsTrade = objCmd.Execute

if request("doSearch") = 1 then
	firstname = replace(request("firstName"),"'","''")
	surname = replace(request("surName"),"'","''")
	serviceno = replace(request("ServiceNo"),"'","''")
	rankID = request("RankID")
	tradeID = request("TradeID")
	'strActive = request("active")

	strCommand = "spPersonnelSearchList"
	objCmd.CommandText = strCommand
	objCmd.CommandType = 4		
	set objPara = objCmd.CreateParameter ("firstName",200,1,50, firstname)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("surname",200,1,50, surname)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("serviceno",200,1,50, serviceno)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("RankID",3,1,0, rankID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("TradeID",3,1,0, tradeID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("Active",3,1,0,1)
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
else
	firstname = ""
	surname = ""
	serviceno = ""
	rankID = 0
	tradeID = 0
    strActive = 1
	page=0
end if


%>
<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<form action="AdminAuthorisor.asp" method="post" name="frmDetails">
    <Input name="DoSearch" id="dosearch" type="Hidden" value="1">
    <Input name="Page" id="Page" type="Hidden" value="1">
    <!--<Input name="active" id="active" type="Hidden" value="0">-->
    <Input name="Sort" id="Sort" type="Hidden" value="<%=sort%>">
    <Input name="checkChange" id="checkChange" type="Hidden" value="0">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
        	<td>
				  <!--#include file="Includes/Header.inc"--> 
                  <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Authorisations</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
                  </table>
          
                  <!--<table width=100% height='<%'=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> -->
                  <table style="height:900px;" width=100% height="328" border=0 cellpadding=0 cellspacing=0> 
                    <tr valign=Top>
                      <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/authmenu.inc"--></td>
				  		<td width=16></td>
				  		<td align=left >
				    		<table border=0 cellpadding=0 cellspacing=0 width=100%>
					  			<tr height=16 class=SectionHeader>
					    			<td>
						  				<table width="159" border=0 cellpadding=0 cellspacing=0 >
						    				<tr> 
                                                <td width=12 class=toolbar></td>											   
                                                <td width=26><a class=itemfontlink href="javascript:CheckForm();"><img class="imagelink" src="images/icongo01.gif"></a></td>
                                                <td width=37 align="center" class=toolbar>Find</td>
                                                <td width=11 align="center" class=titleseparator>|</td>
                                                <td width=29 align="center"><a class=itemfontlink href="javascript:Reset();"><img class="imagelink" src="Images/reset.gif"></a></td>
                                                <td width=44 class=toolbar align="center">Reset</td>
											</tr>  
					      				</table>
									</td>
					  			</tr>
								<tr>
									<td>
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td colspan="6">&nbsp;</td>
                                            </tr>
                                            <tr class="searchheading" height="30">
                                                <td valign="middle" width="2%">&nbsp;</td>
                                                <td valign="middle" width="11%">Surname:</td>
                                                <td valign="middle" width="18%"><input class="itemfont" style="width:150px" maxLength="20" name="surname" id="surname" value="<%=replace(request("surname"),"''","'")%>" onchange="javascript:newSearch();"></td>
                                                <td valign="middle" width="2%"></td>
                                                <td valign="middle" width="11%">First Name</td>
                                                <td valign="middle" width="56%"><input class="itemfont" style="width:150px" maxLength="20" name="firstname" id="firstname" value="<%=replace(request("firstname"),"''","'")%>"></td>
                                            </tr>
                                            <tr class="searchheading" height="22">
                                                <td valign="middle" width="2%">&nbsp;</td>
                                                <td valign="middle" width="11%">Service No:</td>
                                                <td valign="middle" width="18%"><input class="itemfont" style="width:150px" maxLength="20" name="serviceno" id="serviceno" value="<%=replace(request("serviceno"),"''","'")%>"></td>
                                                <td valign="middle" width="2%"></td>
                                                <td valign="middle" width="11%">Rank:</td>
                                                <td valign="middle" width="56%">
                                                    <select class="itemfont" name="rankID" id="rankID">
                                                        <option value=0>All</option>
                                                        <%do while not RSRank.eof%>
                                                            <option value=<%=RSRank("RankID")%> <%if int(RSRank("RankID"))=int(request("RankID")) then response.write " Selected"%>><%=RSRank("shortDesc")%></option>
                                                            <%RSRank.Movenext
                                                        loop%>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr class="searchheading" height="22">
                                                <td valign="middle" width="2%">&nbsp;</td>
                                                <td valign="middle" width="11%">Trade</td>
                                                <td valign="middle" width="18%">
                                                    <select class="itemfont" name="tradeID" id="tradeID">
                                                        <option value=0>All</option>
                                                        <%do while not RSTrade.eof%>
                                                            <option value=<%=RSTrade("TradeID")%> <%if int(RSTrade("TradeID"))=int(request("TradeID")) then response.write " Selected"%>><%=RSTrade("Description")%></option>
                                                            <%RSTrade.Movenext
                                                        loop%>
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
								<%if isObject(rsRecSet) then%>
								<tr>
					    			<td>
						  				<table width=100% border=0 cellpadding=0 cellspacing=0>
						    				<tr colspan=6 class=itemfont height=30>
							  					<td valign="middle" width=2%>&nbsp;</td>
							  					<td colspan=4 valign="middle" width=98%>Search Results: <Font class=searchheading>records found: <%=rsRecSet.recordcount%></Font></td>
											</tr>
										
											<tr>
												<td colspan=5 class=titlearealine  height=1></td> 
											</tr>
											<tr class=columnheading height=30>
											  <td valign="middle" width=2%>&nbsp;</td>
											  <td valign="middle" width=13% onclick="javascript:SortByCol1();" class="mouseHand">Service No<%if sort=5 then%><img src="images/searchUp.jpg"><%end if%><%if sort=6 then%><img src="images/searchDown.jpg"><%end if%></td>
											  <td valign="middle" width=20% onclick="javascript:SortByCol2();" class="mouseHand">First Name<%if sort=3 then%><img src="images/searchUp.jpg"><%end if%><%if sort=4 then%><img src="images/searchDown.jpg"><%end if%></td>
											  <td valign="middle" width=25% onclick="javascript:SortByCol3();" class="mouseHand">Surname<%if sort=1 then%><img src="images/searchUp.jpg"><%end if%><%if sort=2 then%><img src="images/searchDown.jpg"><%end if%></td>
											  <td valign="middle" width=40%>Rank</td>
											</tr>
											<tr>
											  <td colspan=5 class=titlearealine  height=1></td> 
											</tr>
											<%if rsRecSet.recordcount > 0 then%>
											<%Row=0%>
											<%do while Row < recordsPerPage%>
											<tr class=itemfont ID="TableRow<%=rsRecSet ("staffID")%>" height=30 <%if counter=0 then%>style="background-color:<%=color1%>;"<%else%>style="background-color:<%=color2%>;"<%end if%>>
												<td valign="middle" width=2%>&nbsp;</td>
												<td valign="middle" width="13%"><A class=itemfontlink href="AdminPeRsAuthSelect.asp?staffID=<%=rsRecSet("staffID")%>"><%=rsRecSet("serviceno")%></A></td>
												<td valign="middle" width="20%"><%=rsRecSet("firstname")%></td>
												<td valign="middle" width="25%"><%=rsRecSet("surname")%></td>
												<td valign="middle" width="40%"><%=rsRecSet("rank")%></td>
						      				</tr>
											<tr>
												<td colspan=5 class=titlearealine  height=1></td> 
										  	</tr>
											<%
											Row=Row+1
											rsRecSet.MoveNext
											if counter=0 then
												counter=1
											else
												if counter=1 then counter=0
											end if
											Loop%>
											<tr height=22px>
												<td colspan=6></td>
											</tr>											
											<tr align="center">
												<td colspan=6>
													<table  border=0 cellpadding=0 cellspacing=0>
                                                        <tr>
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
                                                                </table>
                                                            </td>
                                                        </tr>
												<%else%>
                                                    <tr class=itemfont  height=20>
                                                        <td valign="middle"  width=2%></td>
                                                        <td class=itemfontlink valign="middle" colspan=4 width=2%>Your search returned no results</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=5 class=titlearealine  height=1></td> 
                                                    </tr>
												<%end if%>
										</table>
									</td>
								</tr>
								<%end if%>		      
							</table>
				  		</td>
      				</tr>
    		  	</table>
			</td>  
		</tr>
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

<SCRIPT LANGUAGE="JavaScript">

function CheckForm() {
  var passed=true;
  
  // Check for Out of Area
  /**
  if (document.frmDetails.chkActive.checked == true) {
	    document.frmDetails.active.value = "1";
  }	
  **/
  document.frmDetails.submit();
}


function MovetoPage (PageNo) {
var checkChange = document.forms["frmDetails"].elements["checkChange"].value;
if (checkChange==0){
	document.forms["frmDetails"].elements["Page"].value = PageNo;
	}else{
	document.forms["frmDetails"].elements["Page"].value = 1;
	}
// document.forms["frmDetails"].submit();
   CheckForm();
}
function SortByCol1 () {
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

	//document.forms["frmDetails"].submit();
	CheckForm();
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
	if (sort < 3 || sort>4)
	{
	document.forms["frmDetails"].elements["Sort"].value=3;
	}
	document.forms["frmDetails"].elements["Page"].value = <%=Page%>;

	//document.forms["frmDetails"].submit();
	CheckForm();
}

function SortByCol3 () {
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

	//document.forms["frmDetails"].submit();
	CheckForm();
}

function newSearch() {
	document.forms["frmDetails"].elements["checkChange"].value = 1;

}

function Reset()
{
	document.getElementById('surname').value = '';
	document.getElementById('firstname').value = '';
	document.getElementById('serviceno').value = '';
	document.getElementById('rankID').selectedIndex = 0;
	document.getElementById('tradeID').selectedIndex = 0;
	//document.getElementById('chkActive').checked = false;
	document.getElementById("doSearch").value = 0;
	document.frmDetails.submit();
}

</Script>