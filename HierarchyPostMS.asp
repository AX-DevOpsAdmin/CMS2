<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
Tab=4
color1="#fcfcfc"
color2="#f7f7f7"
counter=0

strTable = "tblstaff"
strGoTo = "AdminPeRsList.asp"   
strTabID = "staffID"                     
strRecid = "staffID"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3


'strCommand = "spPostMSSummary"

objCmd.CommandText = "spPostMSSummary"
objCmd.CommandType = 4		
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("postID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

'Now see if we can delete it - if it has no children then we can return parameter for Delete check'
objCmd.CommandText = "spPostDel"	'Name of Stored Procedure'
set objPara = objCmd.CreateParameter ("PostID",3,1,5, request("postID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@DelOK",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	

strDelOK = objCmd.Parameters("@DelOK")
objCmd.Parameters.delete ("@DelOK")

intHrc= int(request("hrcID"))

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
<form action="" method="POST" name="frmDetails">
	<input type=hidden name="postID" id="postID" value="<%=request("postID")%>">
    <input type="hidden" name="hrcID" id="hrcID" value=<%=intHrc%>>
    <Input name="staffPostID" id="staffPostID" type="Hidden" value=<%=request("staffPostID")%>>
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyPostDetails.inc"--> 
		<tr>
			<td class=titlearealine height=1></td> 
		</tr>
		<tr class=SectionHeader>
			<td>
				<table border=0 cellpadding=0 cellspacing=0 >
					<%' if strManager = 1 then %>
						<td  height="25px" class=toolbar width=8>&nbsp;</td>
                        <td  height="25px" width=22><a class=itemfontlink href="HierarchyPostMSDetails.asp?postID=<%=request("postID")%>"><img class="imagelink" src="images/editgrid.gif"></a></td>
					    <td  height="25px" class=toolbar valign="middle">Edit Post Military skills</td>
					<%' end if %>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table border=0 cellpadding=0 cellspacing=0 width=100%>
					<tr>
						<td  height="22px" colspan=3>&nbsp;</td>
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
					<tr class=columnheading>
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">Unit:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont><%=rsRecSet("team")%></td>
					</tr>
                    <tr>
                    	<td  height="22px" colspan="3">&nbsp;</td>
                    </tr>
					<tr>
       					<td colspan=3 class=titlearealine  height=1></td> 
     				</tr>
			  	</table>
			</td>
		</tr>

		<% set rsRecSet = rsRecSet.nextrecordset %>
        
		<tr>
			<td>
                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr class=SectionHeader>
                        <td width="2%" align="left" height="25px">&nbsp;</td>
                        <td width="98%" align="left" height="25px" colspan=5>
                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                <tr class="SectionHeader toolbar">
                                    <td width="100%" align="left" height="25px">Summary of Military Skills Required for the post</td>
                                </tr>
                                <tr>
                                    <td height="22px">&nbsp;</td>
                                </tr>
                                <% if not rsRecSet.eof then %>
                                    <% do while not rsRecSet.eof %>
                                        <tr class="columnheading">
                                            <td width="100%" height="22px" class=toolbar><%=rsRecSet("description")%></td>
                                        </tr>
                                        <% rsRecSet.movenext %>
                                    <% loop %>
                                <% else %>
                                <tr>
                                    <td width="100%" align="left" height="22px" class="toolbar">None Required</td>
                                </tr>
                                <% end if %>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="7">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan=7 class=titlearealine height=1></td> 
                    </tr>
                </table>
			</td>
		</tr>
	</table>
</form>

</body>
</html>

<script language="javascript">

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

function gotoEditMS()
{
	document.frmDetails.action="HierarchyPostMSDetails.asp";
	document.frmDetails.submit();
}

</Script>