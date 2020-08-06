<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
Tab=5
strTable = "tblstaff"
'strGoTo = "HiersrchyPostDetail.asp?postID=" & request("PostID")   ' asp page to return to once record is deleted'
strTabID = "staffID"              ' key field name for table '       
strRecid = "staffID"

strCommand = "spPostStaffSummary"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("PostID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

intHrc= int(request("hrcID"))

ghost = 0
'if request("ghost") = "True" then
'	ghost = 1
'end if

'response.write(ghost)
'response.end()

' Only do the search if they entered some search criteria
strSearch = cint(request("doPostSearch"))
if strSearch=1 then
	surname = replace(request("surname"),"'","''")
	firstname = replace(request("firstName"),"'","''")
	serviceno = replace(request("ServiceNo"),"'","''")
	
	strCommand = "spPostStaffSearchResults"
	objCmd.CommandText = strCommand
	objCmd.CommandType = 4		
	set objPara = objCmd.CreateParameter("surname",200,1,50, surname)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter("firstname",200,1,50, firstname)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter("serviceno",200,1,50, serviceno)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter("ghost",11,1,1, ghost)
	objCmd.Parameters.Append objPara
	set rsSearchResults = objCmd.Execute

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next

	if request("page")<>"" then
		page=int(request("page"))
	else
		page=1
	end if
	
	recordsPerPage = 10
		
	num=rsSearchResults.recordcount
	startRecord = (recordsPerPage * page) - recordsPerPage
	totalPages = (int(num/recordsPerPage))

	if int(num - (recordsPerPage * totalPages)) > 0 then totalPages=totalPages+1
	if page = totalPages then recordsPerPage = int(num - startRecord)

	if rsSearchResults.recordcount>0 then rsSearchResults.move(startRecord)

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
	surname = ""
	firstname = ""
	serviceno = ""
end if

	

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

newTodaydate= formatdatetime(date(),2)

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
	
	newDate = formatdatetime(date(),2)
end function
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
.style3 {color: #FF0000}
-->
</style>

</head>
<body>
<form action="HierarchyPostStaff.asp" method="get" name="frmDetails">
	<input type=hidden name=postID id="postID" value=<%=request("postID")%>>
    <input type="hidden" name="hrcID" id="hrcID" value=<%=intHrc%>>
    <Input name="staffPostID" id="staffPostID" type="Hidden" value=<%=request("staffPostID")%>>
    <Input name="doPostSearch" id="doPostSearch" type="Hidden" value=1>
    <Input name="Page" id="Page" type="Hidden" value=1>
    <Input Type="Hidden" name="HiddenDate" id="HiddenDate">
    <input name="recID" id="recID" type="hidden" value="<%=request("recID")%>">
    <input name="ghost" id="ghost" type="hidden" value="<%=request("ghost")%>">
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyPostDetails.inc"--> 
        <tr height=16 class=SectionHeader>
            <td>
                <table border=0 cellpadding=0 cellspacing=0 >
        
                    <tr>
                        <td width=8px>&nbsp;</td>
                        <td width=20px><img src="images/editgrid.gif" class="imagelink" id="SaveCloseLink" onclick="javascript:PopUpwindow1.style.visibility = 'Visible';"></td>
                        <td class=toolbar valign="middle" >Save and Close</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr height=16>
                        <td colspan=3>&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">Assign No:</td>
                        <td valign="middle" class=itemfont ><%=rsRecSet("assignno")%></td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td valign="middle" width=2%>&nbsp;</td>
                        <td valign="middle" width=13%>Post:</td>
                        <td align=left valign="middle" width=85% class=itemfont  ><%=rsRecSet("description")%></td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td valign="middle"></td>
                        <td valign="middle">Unit:</td>
                        <td valign="middle" class=itemfont ><%=rsRecSet("team")%></td>
                    </tr>
                    <tr height=16>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class=titlearealine  height=1></td> 
        </tr>
        <tr height=16 class=SectionHeader>
            <td>
                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr height=25>
                        <td width=8 class=toolbar>&nbsp;</td>
                        <td width=20><a class=itemfontlink href="javascript:frmDetails.submit();"><img class="imagelink" src="images/icongo01.gif"></a></td>
                        <td width=35 class=toolbar align="center">Find</td>
                         <td width=10 class=titleseparator align="center">|</td>
                         <td width=20 align="center"><a class=itemfontlink href="javascript:Reset();"><img class="imagelink" src="Images/reset.gif"></a></td>
                         <td width=40 class=toolbar align="center">Reset</td>
						<td align="center"><span class="toolbar style3">To narrow the search enter any combination of Surname/First Name and/or Service No.</span></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table width="100%" border=0 cellpadding=0 cellspacing=0>
                    <tr height=16>
                        <td colspan="7">&nbsp;</td>
                    </tr>
                    <tr class=searchheading height=22>
                        <td width=5>&nbsp;</td>
                        <td align="left" width=80>Surname:</td>
                        <td align="left" width=200><input class="itemfont" style="width:150px" maxLength=20 name="surname" id="surname" value=<%=request("surname")%>></td>
                        <td align="left" width=80>Firstname:</td>
                        <td align="left" width=200><input class="itemfont" style="width:150px" maxLength=20 name="firstname" id="firstname" value=<%=request("firstname")%>></td>
                        <td align="left" width=80>Service No:</td>
                        <td align="left" width=200><input class="itemfont" style="width: 100px" maxLength=20 name="serviceNo" id="serviceNo" value="<%=request("serviceno")%>"></td>
                    </tr>
                </table>
            </td>
        </tr>
	</table>
</form>

<%if isObject(rsSearchResults) then%>
<form  action="UpdateStaffPost.asp?strGoTo=<%=strGoTo%>" method="post" name="frmStaff">
        <Input name="postID" id="postID" type=Hidden value=<%=request("postID")%>>
        <table width=100% border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table width=100% border=0 cellpadding=0 cellspacing=0>
                        <tr>
                            <td colspan=6 class=titlearealine height=1></td> 
                        </tr>
                        <tr class=itemfont>
                            <td valign="middle" width=2% height=22></td>
                            <td colspan=5 valign="middle" height=22>Search Results: <Font class=searchheading>records found: <%=rsSearchResults.recordcount%></Font></td>
                        </tr>
                        <tr>
                            <td colspan=6 class=titlearealine height=1></td> 
                        </tr>
                        <tr>
                        	<td colspan="6" height="22">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan=6 class=titlearealine height=1></td> 
                        </tr>
                        <tr class=columnheading>
                            <td valign="middle" width=2% height=22></td>
                            <td valign="middle" width=20% height=22>Surname</td>
                            <td valign="middle" width=20% height=22>Firstname</td>
                            <td valign="middle" width=20% height=22>Service No</td>
                            <td valign="middle" width=20% align="center" height=22>select</td>                    
                            <td valign="middle" width=18% height=22>&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan=6 class=titlearealine  height=1></td> 
                        </tr>
                        <%if rsSearchResults.recordcount > 0 then%>
                            <%Row=0%>
                            <% do while Row < recordsPerPage %>
                                <tr id="TableRow<%=Row%>" class=toolbar>
                                    <td valign="middle" width=2% height=22></td>
                                    <td valign="middle" height=22><%=rsSearchResults("surname")%></td>
                                    <td valign="middle" height=22><%=rsSearchResults("firstname")%></td>
                                    <td valign="middle" height=22><%=rsSearchResults("serviceno")%></td>
                                    <td valign="middle" align="center" height=22><input type="radio" name="StaffID" id="StaffID" value=<%=rsSearchResults("staffID")%> onclick="ChangeRowOn('TableRow<%=Row%>');" ></td>
                                    <td valign="middle" height=22>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan=6 class=titlearealine  height=1></td> 
                                </tr>
                                <% row = row + 1 %>
                                <% rsSearchResults.movenext %>
                            <% loop %>
                            <tr height=22px>
                                <td colspan=6>&nbsp;</td>
                            </tr>
                            <tr align="center">
                                <td colspan=6>
                                    <table border=0 cellpadding=0 cellspacing=0>
                                        <tr>
                                            <td class=itemfont height=22>Results Pages: &nbsp;</td>
                                            <td class=ItemLink height=22><% if int(page) > 1 then %><a id=previousButton href="javascript:MovetoPage(<%=page-1%>);" class=ItemLink><< Previous<% else %><< Previous<% end if %></td>
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
                        <%else%>
                            <tr class=itemfont  height=22>
                                <td valign="middle"  width=2%></td>
                                <td align="center" valign="middle" colspan=5 >Your search returned no results</td>
                            </tr>
                            <tr>
                                <td colspan=6 class=titlearealine height=1></td> 
                            </tr>
                        <%end if%>
                    </table>
                </td>
            </tr>        
        </table>
        
    <div id="PopUpwindow1" class="PopUpWindow">
        <table border=0 cellpadding=0 cellspacing=0 width=100%>
            <tr height=22>
               	<td class=MenuStyleParent colspan=5 align="center"><u>Confirm Posting Date</u></td>
            </tr>
            <tr height=22>
               	<td class=MenuStyleParent colspan=5 align="center"></td>
            </tr>
            <tr class=columnheading height=22>
               	<td valign="middle" width=2%></td>
               	<td valign="middle" width=30%>Posted In:</td>
               	<td valign=top><input name="startDate" type="text" id="startDate" class="itemfont"  style="Width:75px;"  value ="<%=newTodaydate%>" readonly onclick="calSet(this)"><img src="images/cal.gif" alt="Calender" onclick="calSet(startDate)" style="cursor:hand;"></td>
               	<td valign="middle" width=2%></td>
            </tr>
            <tr class=columnheading height=22>
               	<td valign="middle" width=2%></td>
               	<td valign="middle" width=2%></td>
            </tr>
            <tr class=columnheading height=22>
               	<td colspan=6></td>
            </tr>
            <tr class=columnheading height=22>
               	<td align="center" colspan=6>
               		<input CLASS="StandardButton" Type=Button style="width:60px;" Value=OK onclick="javascript:frmStaff.submit();">
               		<input CLASS="StandardButton" Type=Button style="width:60px;" Value=Cancel onclick="javascript:PopUpwindow1.style.visibility = 'Hidden';">
           	    </td>
            </tr>
        </table>
    </div>
  </form>
<% end if %>

<%
con.close
set con=Nothing
%>

</body>
</html>


<script type="text/javascript" src="calendar.js"></script>

<script language="javascript">
	homeString ='javascript:refreshIframeAfterDateSelect("ManningTeamPersonnel.asp");'
	window.parent.crumbTrail.innerHTML="<A href='index.asp' class=itemfontlinksmall >Home</A> > <A title='' href='" + homeString + "' class=itemfontlinksmall >Personnel</A> > <font class='youAreHere' >Post In</font>"
</script>
<script language="javascript">

document.all["SaveCloseLink"].disabled=true;
var SavedLastRow ="first";

function checkDelete()
{
	var delOK = false 

	var input_box = confirm("Are you sure you want to delete this Record ?")
	if(input_box==true)
	{
		delOK = true;
	}
	
	return delOK;
}

function ChangeRowOn(ObjectID)
{
	document.all["SaveCloseLink"].disabled=false;
	
	if(SavedLastRow !== "first")
	{
		document.all[SavedLastRow ].style.backgroundColor= SavedBcolor;
		document.all[SavedLastRow ].style.color= SavedColor;
	}

	SavedLastRow = ObjectID
	var SavedBcolor = document.all[ObjectID].style.backgroundColor;
	var SavedColor = document.all[ObjectID].style.backgroundColor;

	document.all[ObjectID ].style.backgroundColor= '#eeeeee';
	document.all[ObjectID ].style.color= '#000000';
}

function MovetoPage (PageNo) {
	document.forms["frmDetails"].elements["Page"].value = PageNo;
	document.forms["frmDetails"].submit();
}

function Reset()
{
	document.getElementById('surname').value = '';
	document.getElementById('firstname').value = '';
	document.getElementById('serviceNo').value = '';
	document.getElementById("doPostSearch").value = 0;
	document.frmDetails.submit();
}

</Script>
