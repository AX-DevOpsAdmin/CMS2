<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
tab=9
strCommand = "spPeRsPostMoveSummary"

'response.Write(request("staffID")&"<br>")
'response.Write(request("thisDate"))

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("staffID",3,1,0, request("staffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("startDate",200,1,20, request("thisDate"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	


for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

%>
<!-- First check to see if they have manager permissions to be on this page
     then if they don't log them off  -->
<!--#include file="Includes/checkmanager.inc"--> 
<!--include file="Includes/manageradmin.inc"-->  

<%

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
-->
</style>

</head>
<body>
<form action="" method="POST" name="frmDetails">
	<input type=hidden name="staffID" id="staffID" value="<%=request("staffID")%>">
	<input type=hidden name="returnto" id="returnto" value="hierarchyPersPostAndMove.asp">

	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyStaffDetails.inc"--> 
		<tr>
			<td class=titlearealine  height=1></td> 
		</tr>
		<tr class=SectionHeader>
			<td>
				<table border=0 cellpadding=0 cellspacing=0 >
					<tr>
						<td class=toolbar width=8>
						<% if strManager = 1 then %>
							<td height="25px" width=20><a class=itemfontlink  href="javascript:confirmRemove();"><img class="imagelink" src="images/editgrid.gif"></A></td>
							<td height="25px" class=toolbar valign="middle">Confirm Untask Movements</td>
						<% end if %>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr>
                        <td height="22px" colspan=6>&nbsp;</td>
                    </tr>
                    <tr class=columnheading>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">First Name:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("firstname")%></td>
                        <td align="left" width="13%" height="22px">Surname:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("surname")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Service No:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("serviceno")%></td>
                        <td align="left" width="13%" height="22px">Known as:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("knownas")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Rank:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("rank")%></td>
                        <td align="left" width="13%" height="22px">Trade:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("trade")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Post:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("post")%></td>
                        <td align="left" width="13%" height="22px">Unit:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("unit")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan=6 height="22px">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan=6 class=titlearealine height=1></td> 
                    </tr>
				</table>
			</td>
		</tr>
		<tr class=SectionHeader>
			<td>
				<table width="100%" border=0 cellpadding=0 cellspacing=0>
                	<tr>
						<td class=toolbar height="25px" width="1%">&nbsp;</td>
						<td class=toolbar height="25px" width="99%" align="left">Summary of Postings and Movements</td>
					</tr>
                    <tr>
                    	<td colspan="2" height="22px">&nbsp;</td>
                    </tr>
				</table>
			</td>
		</tr>

		<% color1 = "#f4f4f4" %>
		<% color2 = "#fafafa" %>
		<% counter = 0 %>
		<% set rsRecSet = rsRecSet.nextrecordset %>
        
		<tr>
			<td>
				<table border=0 cellpadding=0 cellspacing=0 width=100%>
					<tr>
						<td>
							<table width=630px border=0 cellpadding=0 cellspacing=0>
								<tr height=24px>
									<td colspan=5 class=toolbar align="center"><u>Postings</u></td>
								</tr>
								<tr>
									<td colspan=5 class=titlearealine  height=1></td> 
								</tr>
								<tr class="SectionHeaderGreen columnheading"   height=20>
									<td class=toolbar width=8></td><td width=130px>Assign No</td><td width=130px>Unit</td><td align="center"  width=100px>In</td><td align="center"  width=100px>Out</td>
								</tr>
								<tr>
									<td class=titlearealine  height=1></td> 
								</tr>
							</table>
							<div class="ScrollingPostMove borderArea">
								<table width=630px border=0 cellpadding=0 cellspacing=0>
									<% do while not rsRecSet.eof %>
										<tr id="<%= rsRecSet("staffPostID") %>" class=itemfont   height=20 <% if counter = 0 then %>style="background-color:<%=color1%>;"<% else %>style="background-color:<%= color2 %>;cursor:hand;"<% end if %>>
											<td width=8></td>
                                        	<td width=130px title="Description: <%= rsRecSet("Description") %>"><%= rsRecSet("Assignno") %></td>
											<td width=130px><%= rsRecSet("unit") %></td>
                                        	<td align="center" width=100px><% convertDate(rsRecSet("startDate")) %></td>
                                        	<td align="center" width=100px><% if rsRecSet("endDate") <> "" then convertDate(rsRecSet("endDate")) %></td>
										</tr>
                                        <tr>
                                            <td colspan=5 class=titlearealine  height=1></td> 
                                        </tr>
										<% rsRecSet.movenext %>
										<% if counter = 0 then %>
											<% counter = 1 %>
										<% else %>
											<% if counter = 1 then counter = 0 %>
										<% end if %>
									<% loop %>
								</table>
							</div >
						</td>
						<% counter = 0 %>
						<% set rsRecSet = rsRecSet.nextrecordset %>
						<td>
							<table width=630px border=0 cellpadding=0 cellspacing=0>
								<tr height=24px>
									<td colspan=6 class=toolbar align="center"><u>Movements</u></td>
								</tr>
								<tr class="calenderLightOrange columnheading"   height=20>
									<td class=toolbar width=8></td>
                                    <td width=160px>Description</td>
                                    <td align="center" width=100px>From</td>
                                    <td align="center" width=100px>To</td>
                                    <td align="center" width=80px><% if strManager = 1 then%>Untask<% else %>&nbsp;<%end if%></td>
                                    <td align="left" width=120px>Notes</td>
								</tr>
                                <tr>
                                    <td colspan=6 class=titlearealine  height=1></td> 
                                </tr>
							</table>
							<div class="ScrollingPostMove">
								<table width=630px border=0 cellpadding=0 cellspacing=0>
									<% do while not rsRecSet.eof %>
										<tr id="<%= rsRecSet("taskStaffID") %>" class=itemfont height=20 <% if counter = 0 then %>style="background-color:<%= color1 %>;"<% else %>style="background-color:<%= color2 %>;cursor:hand;"<% end if %>>
											<td width=8></td>
											<td width=160px><%= rsRecSet("description") %></td>
                                            <td align="center" width=100px><%= formatdatetime(rsRecSet("startDate"),2) %></td>
                                            <td align="center" width=100px><% if rsRecSet("endDate") <> "" then response.write formatdatetime(rsRecSet("endDate"),2) %></td>
											<td align="center" width=80px><% if strManager = 1 then %><input name="taskStaffID" id="taskStaffID" value ="<%= rsRecSet("taskStaffID") %>" type=checkbox><% else %>&nbsp;<% end if %></td>
                                            <td align="left" width=120px><%= rsRecSet("taskNote") %></td>					
										</tr>
                                        <tr>
                                            <td colspan=6 class=titlearealine  height=1></td> 
                                        </tr>
										<% rsRecSet.movenext %>
										<% if counter = 0 then %>
											<% counter = 1 %>
										<% else %>
											<% if counter = 1 then counter = 0 %>
										<% end if %>
									<% loop %>
								</table>
							</div >
						</td>
					</tr>
				</table>
			</td>
		</tr>
</table>
</form>

</body>
</html>

<script language="javascript">

function confirmRemove()
{
	var myform = document.forms['frmDetails'];
	var len = myform.elements.length;
	var intCount = 0;
	
	for(var i=0; i < len; i++)
	{
		if(myform.elements[i].type == 'checkbox' && myform.elements[i].checked == true)
		{
			intCount = 1;
		}
	}
	
	if(intCount == 1)
	{
		yesBox=confirm("Are you sure you want to untask checked movements?");

		if(yesBox == true)
		{
			if(document.frmDetails.taskStaffID)
			{
				document.frmDetails.action="RemoveMovements.asp";
				document.frmDetails.submit();
			}
		}
		else
		{
			for(var i=0; i < len; i++)
			{
				if(myform.elements[i].type == 'checkbox')
				{
					myform.elements[i].checked = false;
				}
			}
		}
	}
	else
	{
		alert("Select Movements to Untask")
		return;
	}
}

</Script>
