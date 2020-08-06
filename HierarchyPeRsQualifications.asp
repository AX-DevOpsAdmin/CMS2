<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  

<%
tab=3
strTable = "tblstaff"
strGoTo = "AdminPeRsList.asp"   
strTabID = "staffID"                     
strRecid = "staffID"

strCommand = "spPeRsDetailSummary"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("StaffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("startDate",200,1,20, request("thisDate"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'

objCmd.parameters.delete("startDate")

objCmd.CommandText = "spPersDel"	'Name of Stored Procedure'
set objPara = objCmd.CreateParameter("@DelOK",3,2)
objCmd.Parameters.Append objPara
objCmd.execute
	
for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

strCommand = "spGetHierarchyQtypes"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID", 200,1,50, nodeID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("RecID",3,1,0, request("staffID"))
objCmd.Parameters.Append objPara

set rsQTypes = objCmd.Execute

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strCommand = "spPeRsQs"

postID = int(session("postID"))
if postID = "" then postID = 0

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,0, request("staffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("postID",3,1,0, postID)
objCmd.Parameters.Append objPara

set rsQualificationDetails = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
%>

<script type="text/javascript" src="toggle.js"></script>

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
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyStaffDetails.inc"--> 
        <tr>
        	<td class=titlearealine  height=1></td> 
        </tr>
        <tr class=SectionHeader>
            <td>
				<% if strManager = 1 then %>
                    <table width="100%" border=0 cellpadding=0 cellspacing=0 >
                        <tr>
                            <td height="25px" class=toolbar width=8>&nbsp;</td>
                            <td height="25px" width=20><a class=itemfontlink href="HierarchyPeRsQualificationsSelect.asp?staffID=<%=request("staffID")%>&thisdate=<%=request("thisDate")%>"><img class="imagelink" src="images/editgrid.gif"></a></td>
                            <td height="25px" class=toolbar valign="middle">Edit Qualifications</td>
                        </tr>
                    </table>
                <% end if %>
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
                        <td align="left" width="47%" height="22px" class=itemfont><%=rsRecSet("surname")%></td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Service No:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("serviceno")%></td>
                        <td align="left" width="13%" height="22px">Known as:</td>
                        <td align="left" width="47%" height="22px" class=itemfont><%=rsRecSet("knownas")%></td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Rank:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("rank")%></td>
                        <td align="left" width="13%" height="22px">Trade:</td>
                        <td align="left" width="47%" height="22px" class=itemfont><%=rsRecSet("trade")%></td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Post:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("post")%></td>
                        <td align="left" width="13%" height="22px">Unit:</td>
                        <td align="left" width="47%" height="22px" class=itemfont><%=rsRecSet("unit")%></td>
                    </tr>
                    <tr>
                    	<td colspan=5 height="22px">&nbsp;</td>
                    </tr>
                    <tr>
                    	<td colspan=5 class=titlearealine height=1></td> 
                    </tr>
				</table>
				<table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr class="SectionHeader toolbar">
                        <td width="2%" align="left" height="25px">&nbsp;</td>
                        <td width="100%" align="left" height="25px">Summary of Qualifications</td>
					</tr>
                    <tr>
                    	<td colspan="2">&nbsp;</td>
                    </tr>
    			</table>
                <div id="containerDiv">
      
					<% do while not rsQTypes.eof %>
						<% intFlag = 0 %>
                        <table border="0" cellpadding="0" cellspacing="0" width="90%">
                            <tr class="toolbar">
                                <td height="25px" id="Q<%= rsQTypes("QTypeID") %>Img" align=left onclick="toggle('Q<%= rsQTypes("QTypeID") %>', 'Q<%= rsQTypes("QTypeID") %>Img','containerDiv');">
                                    <img src="images/plus.gif" width="18" id="Q<%= rsQTypes("QTypeID") %>Icon"> 
                                  <b><%= rsQTypes("Description") %></b>
                            	</td>
                                
                            </tr>
                            <tr>
                                <td>
                                    <div id="Q<%= rsQTypes("QTypeID") %>" style="display:none; border:0; margin:0; padding:0;">
                                        <% if not rsQualificationDetails.eof then %>
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr class="toolbar">
                                                    <td width="2%" align="left" height="25px">&nbsp;</td>
                                                    <td width="37%" align="left" height="25px">Qualification</td>
                                                    <td width="10%" align="center" height="25px">Held</td>
                                                    <td width="10%" align="center" height="25px">Valid From</td>
                                                    <td width="10%" align="center" height="25px">Valid To</td>
                                                    <!--<td width="10%" align="center" height="25px">Competent</td>-->
                                                    <td width="8%" align="center" height="25px">Status</td>
                                                    <td width="13%" align="center" height="25px">Req'd by Post</td>
                                                </tr>
                                                <tr>
                                                    <td width="2%" class=titlearealine height=1></td>
                                                    <td colspan=6 class=titlearealine height=1></td> 
                                                </tr>
                                                <% do while not rsQualificationDetails.eof %>
                                                    <% if rsQualificationDetails("QTypeID") = rsQTypes("QTypeID") then %>
                                                    	<% intFlag = 1 %>
                                                        <% strQualification = rsQualificationDetails("description") %>
                                                        <% strValidFrom = rsQualificationDetails("ValidFrom") %>
                                                        <% if isnull(rsQualificationDetails("vpdays")) then %>
                                                            <% intDays = 0 %>
                                                        <% else %>
                                                            <% intDays = rsQualificationDetails("vpdays") %>
                                                        <% end if %>
                                                        <% strValidTo = dateadd("d", intDays, strValidFrom) %>
                                                        <% intAmber = rsQualificationDetails("Amber") %>
                                                        <% strAmberDate = dateadd("d", -intAmber, strValidTo) %>
                                                        <% strCompetent = rsQualificationDetails("Competent") %>
                                                        <% 'if isnull(rsQualificationDetails("Req")) then
'														     strRequired=0
'															else
'															 strRequired=1
'															end if
														%>
                                                        <% strRequired = cint(rsQualificationDetails("Req")) %>
                                                        <%'response.write ("req is " & strRequired & " * " & strQualification)%>
                                                    
                                                        
                                                        <tr>
                                                            <td width="2%" align="left" height="22px" class="toolbar">&nbsp;</td>
                                                            <td width="37%" align="left" height="22px" class=toolbar><%= strQualification %></td>
                                                            <td width="10%" align="center" height="22px"><% if rsQualificationDetails("staffID") <> "" then %><img src="images/yes.gif"><% else %><img src="images/no.gif"><% end if %></td>
                                                            <td width="10%" align="center" height="22px" class=toolbar><% if rsQualificationDetails("staffID") <> "" then %><%= strValidFrom %><% else %>-<% end if %></td>
                                                            <td width="10%" align="center" height="22px" class=toolbar><% if rsQualificationDetails("staffID") <> "" then %><%= strValidTo %><% else %>-<% end if %></td>
                                                            <!--<td width="10%" align="center" height="22px" class=toolbar><% if rsQualificationDetails("staffID") <> "" then %><%= strCompetent %><% else %>-<% end if %></td>-->
                                                            <td width="8%" align="center" height="22px" class=toolbar>
                                                                <% if date > strValidTo then %>
                                                                    <img src="Images/red box.gif" alt="Out of Date" width="12" height="12">
                                                                <% elseif date >= strAmberDate and date <= strValidTo then %>
                                                                    <img src="Images/yellow box.gif" alt="Almost out of Date" width="12" height="12">
                                                                <% elseif date >= strValidFrom and date < strAmberDate then %>
                                                                    <img src="Images/green box.gif" alt="In Date" width="12" height="12">
                                                                <% else %>
                                                                    -
                                                                <% end if %>
                                                            </td>
                                                            <td width="13%" align="center" height="22px">
                                                                <% if strRequired = 0 then %>
                                                                    <img src="Images/no.gif" width="10" height="10">
                                                                <% else %>
                                                                    <img src="Images/yes.gif" width="10" height="10">
                                                                <% end if %>
                                                            </td>
                                                        </tr>
                                                    <% end if %>
                                                    <% rsQualificationDetails.movenext %>
                                                <% loop %>
                                                <% rsQualificationDetails.movefirst %>
                                                <% if intFlag = 0 then %>
                                                    <tr>
                                                        <td width="2%">&nbsp;</td>
                                                        <td colspan="6" width="98%" align="left" height="22px" class="toolbar">None Required</td>
                                                    </tr>
                                                <% end if %>
                                                <tr>
                                                    <td colspan="7">&nbsp;</td>
                                                </tr>
                                            </table>
                                        <% else %>
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr class="toolbar">
                                                    <td width="2%" align="left" height="25px">&nbsp;</td>
                                                    <td width="37%" align="left" height="25px">Qualification</td>
                                                    <td width="10%" align="center" height="25px">Held</td>
                                                    <td width="10%" align="center" height="25px">Valid From</td>
                                                    <td width="10%" align="center" height="25px">Valid To</td>
                                                    <!--<td width="10%" align="center" height="25px">Competent</td>-->
                                                    <td width="8%" align="center" height="25px">Status</td>
                                                    <td width="13%" align="center" height="25px">Req'd by Post</td>
                                                </tr>
                                                <tr>
                                                    <td width="2%" class=titlearealine height=1></td>
                                                    <td colspan=6 class=titlearealine height=1></td> 
                                                </tr>
                                                <tr>
                                                    <td width="2%">&nbsp;</td>
                                                    <td colspan="6" width="98%" align="left" height="22px" class="toolbar">None Required</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="7">&nbsp;</td>
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

</Script>