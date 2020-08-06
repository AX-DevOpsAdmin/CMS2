<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--include file="Includes/manageradmin.inc"-->  

<%
tab=3
strTable = "tblstaff"
strGoTo = "AdminPeRsList.asp"   ' asp page to return to once record is deleted'
strTabID = "staffID"              ' key field name for table   '     
strRecid = "staffID"

strCommand = "spPostDetailSummary"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("postID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strTable = "tblQTypes"
strCommand = "spListTable"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID", 200,1,50, nodeID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsQTypeList = objCmd.Execute	''Execute CommandText when using "ADODB.Command" object

intHrc= int(rsRecSet("hrcID"))

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
<form action="HierarchyPostQualificationsDetails.asp" method="post" name="frmDetails">
	<input type=hidden name=postID id="postID" value=<%=request("postID")%>>
    <input type="hidden" name="hrcID" id="hrcID" value=<%=intHrc%>>

	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyPostDetails.inc"--> 
		<tr>
			<td class=titlearealine  height=1></td> 
		</tr>
		<tr height="22px"px class=SectionHeader>
			<td>
				<table border=0 cellpadding=0 cellspacing=0 >
					<td height="25px" class=toolbar width=8>&nbsp;</td>
					<td height="25px" class=toolbar valign="middle"><A class=itemfontlink href="HierarchyPostQualifications.asp?postID=<%=request("postID")%>">Back to summary</A></td>											
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
                    <tr>
                    	<td height="22px" colspan="3">&nbsp;</td>
                    </tr>
					<tr class=columnheading>
						<td align="left" width="2%" height="22px">&nbsp;</td>
						<td width="13%" align="left" height="22px">Qualification Type:</td>
						<td width="85%" align="left" height="22px">
                            <Select class="inputbox" name="QTypeID" id="QTypeID" onchange="frmDetails.submit();" style="width:120px;">
                            <option value=0>Select...</option>
                            <% do while not rsQTypeList.eof %>
                                <option value=<%= rsQTypeList("QTypeID") %>><%= rsQTypeList("description") %></option>
                                <% rsQTypeList.MoveNext %>
                            <% loop %>
                            </Select>
                        </td>
					</tr>
				</table>
			</td>
        </tr>
        <tr height=16>
            <td colspan=3>&nbsp;</td>
        </tr>
        <tr>
            <td colspan=3 class=titlearealine  height=1></td> 
        </tr>
    </table>
</form>

<%
'rsRecSet.close
'set rsRecSet=Nothing
con.close
set con=Nothing
%>
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
function checkDelete(){
     var delOK = false 
    
	  var input_box = confirm("Are you sure you want to delete this Record ?")
	  if(input_box==true) {
		    delOK = true;
	    }
    return delOK;
}
</Script>
