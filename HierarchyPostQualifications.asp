<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
tab=3
strTable = "tblstaff"
strGoTo = "AdminPeRsList.asp"   
strTabID = "staffID"                     
strRecid = "staffID"

strCommand = "spPostDetailSummary"

set objCmd = server.createobject("ADODB.Command")
set objPara = server.createobject("ADODB.Parameter")
objCmd.activeconnection = con
objCmd.commandtext = strCommand
objCmd.commandtype = 4

set objPara = objCmd.createparameter("RecID",3,1,5, request("postID"))
objCmd.parameters.append objPara
set rsRecSet = objCmd.execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

' now see if we can delete it - if it has no children then we can return parameter for Delete check'
objCmd.commandtext = "spPostDel"	'Name of Stored Procedure'
set objPara = objCmd.createparameter("PostID",3,1,5, request("postID"))
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@DelOK",3,2)
objCmd.parameters.append objPara
objCmd.execute	

strDelOK = objCmd.Parameters("@DelOK")
objCmd.Parameters.delete ("@DelOK")

'now check to see if they are in a team'
strTeamOK = "0"   ' set to No Team'
objCmd.CommandText = "spGetPostTeams"
set rsTeam = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
   
'get a list of TeamIDs cos they could be in more than one'
do while not rsTeam.bof and not rsTeam.eof 	
	strTeamOK = "1"
	if strList = "" then
		strList = rsTeam("teamID")
	else
		strList = strList & "," & rsTeam("teamID")  
    end if	
    rsTeam.movenext()
loop

strCommand = "spListTable"
strTableName = "tblQTypes"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
set objPara = objCmd.CreateParameter ("nodeID", 200,1,50, session("nodeID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("tableName", 200,1,50, strTableName)
objCmd.Parameters.Append objPara
set rsQTypes = objCmd.Execute

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.commandtext = "spPostQsSummary"
objCmd.commandtype = 4
set objPara = objCmd.createparameter("RecID",3,1,4, request("postID"))
objCmd.parameters.append objPara
                    
set rsQualificationDetails = objCmd.execute

intHrc= int(request("hrcID"))

%>

<script type="text/javascript" src="toggle.js"></script>

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
<body">

<form action="" method="POST" name="frmDetails">
	<input type=hidden name="postID" id="postID" value="<%=request("postID")%>">
    <input type="hidden" name="hrcID" id="hrcID" value=<%=intHrc%>>
    <Input name="staffPostID" id="staffPostID" type="Hidden" value=<%=request("staffPostID")%>>
	<input type=hidden name="QTypeID" id="QTypeID">
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyPostDetails.inc"--> 
		<tr>
			<td class=titlearealine height=1></td> 
		</tr>
		<tr class=SectionHeader>
			<td>
				<% 'if strManager = 1 then %>
                    <table width="100%" border=0 cellpadding=0 cellspacing=0>
                        <tr>
                            <td height="25px" class=toolbar width=8>&nbsp;</td>
                            <td height="25px" width=22><a class=itemfontlink href="HierarchyPostQualificationsSelect.asp?postID=<%=request("postID")%>"><img class="imagelink" src="images/editgrid.gif"></a></td>
                            <td height="25px" class=toolbar valign="middle">Edit Post Qualifications</td>
                        </tr>
                    </table>
				<% 'end if %>
			</td>
		</tr>
		<tr>
			<td>
				<table border=0 cellpadding=0 cellspacing=0 width=100%>
					<tr>
						<td height="22px" colspan=3>&nbsp;</td>
					</tr>
					<tr class=columnheading>
						<td align="left" width="2%" height="22px">&nbsp;</td>
						<td align="left" width="13%" height="22px">Post:</td>
						<td align="left" width="85%" height="22px" class=itemfont><%=rsRecSet("Description")%></td>
					</tr>
					<tr class=columnheading>
					    <td align="left" width="2%" height="22px">&nbsp;</td>
						<td align="left" width="13%" height="22px">Assignment Number:</td>
						<td align="left" width="85%" height="22px" class=itemfont><%=rsRecSet("assignno")%></td>
					</tr>
					<tr class=columnheading height="22px">
						<td align="left" width="2%" height="22px">&nbsp;</td>
						<td align="left" width="13%" height="22px">Unit:</td>
						<td align="left" width="85%" height="22px" class=itemfont><%=rsRecSet("team")%></td>
					</tr>
                    <tr>
                    	<td height="22px" colspan="3">&nbsp;</td>
                    </tr>
					<tr>
       					<td colspan=3 class=titlearealine height=1></td> 
     				</tr>
			  	</table>
                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr class="SectionHeader toolbar">
                        <td width="2%" align="left" height="25px">&nbsp;</td>
                        <td width="100%" align="left" height="25px">Summary of Qualifications Required for the post
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp;</td>
                    <tr>
                </table>
                <div id="containerDiv">
					<% do while not rsQTypes.eof %>
						<% intFlag = 0 %>
                        <table border="0" cellpadding="0" cellspacing="0" width="50%">
                            <tr class="toolbar">
                                <td width="2%" height="25px" id="Q<%= rsQTypes("QTypeID") %>Img" align=left onclick="toggle('Q<%= rsQTypes("QTypeID") %>', 'Q<%= rsQTypes("QTypeID") %>Img','containerDiv');"><img id="Q<%= rsQTypes("QTypeID") %>Icon" src="images/plus.gif"></td>
                                <td width="98%" height="25px" align=left><b><%= rsQTypes("Description") %></b></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div id="Q<%= rsQTypes("QTypeID") %>" style="display:none;">
                                        <% if not rsQualificationDetails.eof then %>
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr class="toolbar">
                                                    <td width="2%" align="left" height="25px">&nbsp;</td>
                                                    <td width="98%" align="left" height="25px">Qualification</td>
                                                </tr>
                                                <tr>
                                                    <td width="2%" class=titlearealine height=1></td>
                                                    <td class=titlearealine height=1></td> 
                                                </tr>
                                                <% do while not rsQualificationDetails.eof %>
                                                    <% if rsQualificationDetails("QTypeID") = rsQTypes("QTypeID") then %>
                                                    	<% intFlag = 1 %>
                                                        <% strQualification = rsQualificationDetails("description") %>

                                                        <tr>
                                                            <td width="2%" align="left" height="22px" class="toolbar">&nbsp;</td>
                                                            <td width="98%" align="left" height="22px" class=toolbar><%= strQualification %></td>
                                                        </tr>
                                                    <% end if %>
                                                    <% rsQualificationDetails.movenext %>
                                                <% loop %>
                                                <% rsQualificationDetails.movefirst %>
                                                <% if intFlag = 0 then %>
                                                    <tr>
                                                        <td width="2%">&nbsp;</td>
                                                        <td width="98%" align="left" height="22px" class="toolbar">None Required</td>
                                                    </tr>
                                                <% end if %>
                                                <tr>
                                                    <td colspan="2">&nbsp;</td>
                                                </tr>
                                            </table>
                                        <% else %>
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr class="toolbar">
                                                    <td width="2%" align="left" height="25px">&nbsp;</td>
                                                    <td width="47%" align="left" height="25px">Qualification</td>
                                                </tr>
                                                <tr>
                                                    <td width="2%" class=titlearealine height=1></td>
                                                    <td class=titlearealine height=1></td> 
                                                </tr>
                                                <tr>
                                                    <td width="2%">&nbsp;</td>
                                                    <td width="98%" align="left" height="22px" class="toolbar">None Required</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">&nbsp;</td>
                                                </tr>
                                            </table>
                                        <% end if %>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        
                        <% rsQTypes.movenext %>
                    <% loop %>
                </div>
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

function gotoEditQs(QTypeID)
{
	document.frmDetails.action="HierarchyPostQualificationsDetails.asp";
	document.frmDetails.QTypeID.value=QTypeID;
	document.frmDetails.submit();
}

</Script>