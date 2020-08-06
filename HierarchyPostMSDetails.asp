<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
tab=4
strTable = "tblstaff"
strGoTo = "AdminPeRsList.asp"   ' asp page to return to once record is deleted
strTabID = "staffID"              ' key field name for table        
strRecid = "staffID"

strCommand = "spPostMSSummary"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

objCmd.CommandText = strCommand
objCmd.CommandType = 4		
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("postID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.CommandText = "spPostMSDetails"	'Name of Stored Procedure'
objCmd.CommandType = 4				'Code for Stored Procedure'
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("postID"))
objCmd.Parameters.Append objPara

set rsQualificationDetails = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

intHrc= int(rsRecSet("hrcID"))

%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>Post Details</title>
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
<form action="" method="post" name="frmDetails">
    <Input Type="Hidden" name="postID" id="postID" value="<%=request("postID")%>">
    <input type="hidden" name="hrcID" id="hrcID"  value=<%=intHrc%>>
    <Input Type="Hidden" name="HiddenDate" id="HiddenDate">

	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyPostDetails.inc"--> 
		<tr>
			<td class=titlearealine  height=1></td> 
		</tr>
		<tr class=SectionHeader>
			<td>
				<table border=0 cellpadding=0 cellspacing=0>
					<td height="25px" width=22><a class=itemfontlink href="HierarchyPostMSAdd.asp?postID=<%=request("postID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
					<td height="25px" class=toolbar valign="middle">Add Military Skills</td>
					<td height="25px" class=titleseparator valign="middle" width=14 align="center">|</td>
					<td height="25px" width=22><a class=itemfontlink  href="HierarchyPostMSRemove.asp?postID=<%=request("postID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
					<td height="25px" class=toolbar valign="middle" >Remove Military Skills</td>
					<td height="25px" class=titleseparator valign="middle" width=14 align="center">|</td>
					<td height="25px" class=toolbar valign="middle" ><A class=itemfontlink href="HierarchyPostMS.asp?postID=<%=request("postID")%>">Back</A></td>											
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table border=0 cellpadding=0 cellspacing=0 width=100%>
					<tr>
						<td height="22px" colspan=3>&nbsp;</td>
					</tr>
					<tr class=columnheading>
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">Post:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont><%=rsRecSet("Description")%></td>
					</tr>
					<tr class=columnheading>
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">Assignment Number:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont><%=rsRecSet("assignno")%></td>
					</tr>
					<tr class=columnheading height="22px">
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">Unit:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont><%=rsRecSet("team")%></td>
					</tr>
					<tr>
						<td height="22px" colspan="3">&nbsp;</td>
					</tr>
					<tr>
						<td colspan=3 class=titlearealine  height=1></td> 
					</tr>
					<tr class=SectionHeader>
						<td valign="middle" height="22px">&nbsp;</td>
						<td align="left" colspan=3 height="22px">
							<table border=0 cellpadding=0 cellspacing=0 width=50%>
								<tr class="SectionHeader toolbar">
									<td width=58% align="left" height="25px"><u><b><%= rsQualificationDetails("Type") %></b></u> Required</td>
									<td width=20% align="center" height="25px">Status</td>
									<td width=20% align="center" height="25px">Competent</td>									 
								</tr>
								<tr>
									<td colspan=3 height=22>&nbsp;</td>
								</tr>

								<% color1="#fcfcfc" %>
								<% color2="#f7f7f7" %>
								<% counter = 0 %>
								<% set rsQualificationDetails = rsQualificationDetails.nextrecordset %>
								<% if rsQualificationDetails.recordcount > 0 then %>
									<% do while not rsQualificationDetails.eof %>
                                    	<tr <%if counter=0 then%>style="background-color:<%=color1%>;"<%else%>style="background-color:<%=color2%>;"<%end if%>>
                                        	<td class=toolbar height="22px"><a href="javascript:DisplayForm('<%= rsQualificationDetails("status") %>','<%= rsQualificationDetails("competent") %>','<%= rsQualificationDetails("postMSID") %>','<%= rsQualificationDetails("description") %>');" class=ItemLink><%= rsQualificationDetails("description") %></A></td>
                                        	<td align="center" class=toolbar height="22px"><%= rsQualificationDetails("statusDesc") %></td>
                                        	<td align="center" class=toolbar height="22px"><% if rsQualificationDetails("competent") = true then response.write("Yes") else response.write("No") end if %></td>
                                    	</tr>
                                    	<% rsQualificationDetails.movenext %>
                                    	<% if counter = 0 then %>
                                    		<% counter = 1 %>
                                    	<% else %>
                                        	<% if counter = 1 then counter = 0 %>
                                    	<% end if %>
                                	<% loop %>
								<% else %>
									<tr>
										<td colspan="3" height="22px" class="columnheading">None held</td>
									</tr>
								<% end if %>
							</table>
						</td>
					</tr>
					<tr>
						<td height="22px" colspan=3>&nbsp;</td>
					</tr>
					<tr>
       					<td colspan=3 class=titlearealine  height=1></td> 
     				</tr>
			  	</table>
			</td>
		</tr>
	</table>
</form>

<form action="ManningPostSingleMSUpdate.asp" method="post" name="popupDetails">
    <Input Type="Hidden" name="postID" id="postID" value="<%=request("postID")%>">
    <input type=hidden name="QTypeID" id="QTypeID" value=<%=request("QTypeID")%>>
    <input type="hidden" name="ReturnTo" id="ReturnTo" value="HierarchyPostMSDetails.asp">
    <Input Type="Hidden" name="postMSID" id="postMSID">
  <Div id="PopUpwindow1" class="PopUpWindow">
      <table border=0 cellpadding=0 cellspacing=0 width=100%>
          <tr>
              <td colspan=3 height=22 align="center" class=MenuStyleParent><u>Confirm Military Skill Details</u></td>
          </tr>
          <tr>
           	  <td colspan="3" height="22px">&nbsp;</td>
          </tr>
          <tr class=columnheading>
              <td valign="middle" height=22 width=2%></td>
              <td valign="middle" height=22 width=30%>Military Skill:</td>
              <td valign="middle" height=22 width=68% class=toolbar><DIV id="QName"></DIV></td>
          </tr>
          <tr class=columnheading>
              <td valign="middle" height=22 width=2%></td>
              <td valign="middle" height=22 width=30%>Status:</td>
              <td valign="middle" height=22 width=68% class=itemfont>
                  <select class="itemfont" name="Status" id="Status">
                      <option value=1>Mandatory</option>
                      <option value=2>Highly Desirable</option>
                      <option value=3>Nice to Have</option>
                  </select>
              </td>
          </tr>
          <tr class=columnheading>
              <td valign="middle" height=22></td>
              <td valign="middle" height=22>Competent?:</td>
              <td valign="middle" height=22 class=itemfont>
                  <select class="itemfont" name="Competent" id="Competent">
                      <option value=True>Yes</option>
                      <option value=False>No</option>
                  </select>
              </td>
          </tr>
          <tr>
              <td colspan=3 height=22>&nbsp;</td>
          </tr>
          <tr>
              <td colspan=3 align=center height=22><Input CLASS="StandardButton" Type=Button style="width:60px;" Value=Cancel onclick="ClosePopup()"><Input CLASS="StandardButton" Type=Button style="width:60px;" Value=OK onclick="popupDetails.submit();"></td>
          </tr>
          <tr>
              <td colspan="3" height="22px">&nbsp;</td>
          </tr>
      </table>
  </Div>
</form>

</body>
</html>

<script language="javascript">

function  ClosePopup()
{
	document.getElementById('PopUpwindow1').style.visibility = "Hidden";
}

function checkDelete()
{
	var delOK = false 
    
	var input_box = confirm("Are you sure you want to delete this Record ?")
	if(input_box == true)
	{
		delOK = true;
	}
	
    return delOK;
}

function DisplayForm(status,Competent,postMSID,Description)
{
	document.popupDetails.postMSID.value = postMSID;

	for(var i = 0; i < document.popupDetails.Competent.options.length; i++)
	{	
		if(document.popupDetails.Competent[i].value == Competent)
		{
			document.popupDetails.Competent.selectedIndex=i;
		}
	}
	
	for(var i = 0; i < document.popupDetails.Status.options.length; i++)
	{
		if(document.popupDetails.Status[i].value == status)
		{
			document.popupDetails.Status.selectedIndex=i;
		}
	}
	
	document.getElementById('QName').innerHTML=Description;
	document.getElementById('PopUpwindow1').style.visibility = "Visible";
}

</script>