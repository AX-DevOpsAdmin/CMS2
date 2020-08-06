<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
color1 = "#f4f4f4"
color2 = "#fafafa"
counter = 0 
row = 0
strOOADays = 0

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

if request("id") <> "" then
	intID = request("id")
else
	intID = 0
end if

if request("flag") <> "" then
	intFlag = request("flag")
else
	intFlag = 0
end if

'response.write "Update Task " & request("ttID") & " ** " & request("RecID") & " * " & request("staffID") & " * " & strOOADays & " * " & session("staffID") & " * " & request("startDate") & " * " & request("endDate") & " * " & request("notes") & " * " & intID & " * " & intflag
'response.End()

'if request("ttID") <> 0 then
	objCmd.CommandText = "spTaskPersonnelAdd"	
	objCmd.CommandType = 4
	
	set objPara = objCmd.CreateParameter ("node",3,1,0, session("nodeID"))
	objCmd.Parameters.Append objPara					
	set objPara = objCmd.CreateParameter ("TaskID",3,1,0, request("RecID"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("staffID",200,1,50, request("staffID"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("ooadays",3,1,50, strOOADays)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("currentUser",3,1,0, session("staffID"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("StartDate",200,1,16, request("startDate"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("EndDate",200,1,16, request("endDate"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("notes",200,1,2000, request("notes"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("id",3,1,0, intID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("Flag",3,1,0, intFlag)
	objCmd.Parameters.Append objPara	

	objCmd.Execute
		
	taskID = request("recID")
'else
'	objCmd.CommandText = "spTaskIndividualAdd"	
'	objCmd.CommandType = 4
'					
'	set objPara = objCmd.CreateParameter ("serviceNo",200,1,50, request("serviceNo"))
'	objCmd.Parameters.Append objPara
'	set objPara = objCmd.CreateParameter ("currentUser",3,1,0, session("staffID"))
'	objCmd.Parameters.Append objPara
'	set objPara = objCmd.CreateParameter ("StartDate",200,1,16, request("startDate"))
'	objCmd.Parameters.Append objPara
'	set objPara = objCmd.CreateParameter ("EndDate",200,1,16, request("endDate"))
'	objCmd.Parameters.Append objPara
'	set objPara = objCmd.CreateParameter ("Task",200,1,100, request("task"))
'	objCmd.Parameters.Append objPara
'	set objPara = objCmd.CreateParameter ("ttID",3,1,0, request("ttID"))
'	objCmd.Parameters.Append objPara
'	set objPara = objCmd.CreateParameter ("TaskID",3,2,0, 0)
'	objCmd.Parameters.Append objPara
'	objCmd.Execute
'	
'	taskID = objCmd.Parameters("TaskID")
'	
'	response.write "Task is "  & taskID ' request("ttID") & " ** " & request("RecID") & " * " & request("serviceNo") & " * " & strOOADays & " * " & session("staffID") & " * " & request("startDate") & " * " & request("endDate") & " * " & request("notes") & " * " & intID & " * " & intflag
'    response.End()
'
'end if

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next


objCmd.CommandText = "spTaskPersonnelCheck"	
objCmd.CommandType = 4				
set objPara = objCmd.CreateParameter ("TaskID",3,1,0, taskID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("currentUser",3,1,0, session("staffID"))
objCmd.Parameters.Append objPara
set RSList = objCmd.Execute	

' response.write(taskID & "  ***  " & session("staffID")) 
' response.end()

if RSList.recordCount > 0 then 'and intFlag = 0 
	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next

    'response.write("Task List " & taskID & "  ***  " & session("staffID")) 
    'response.end()

	set objPara = objCmd.CreateParameter ("TaskID",3,1,5, taskID)
	objCmd.Parameters.Append objPara
	objCmd.CommandText = "sp_TaskDetail"	'Name of Stored Procedure'
	set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'		
	%>
	
	<html>
	<head>
	
	<title>Task Details</title>
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
    <form action="" method="post" name="frmDetails" onSubmit="javascript:return(CheckForm());">
        <Input name="RecID" id="RecID" type="hidden" value=<%=taskID%>>
        <!--<Input name="HiddenDate" type="hidden" >-->
        <input name="id" id="id" type="hidden" value="<%=intID%>">
        <input name="flag" id="flag" type="hidden" value="<%=intFlag%>">
        <input name="staffID" id="staffID"  type="hidden" value="<%=request("staffID")%>">
        <Input name="StartDate" id="StartDate" type="hidden" value="<%=request("startDate")%>">
        <Input name="EndDate" id="EndDate" type="hidden" value="<%=request("endDate")%>">
        <input name="notes" id="notes" type="hidden" value = "<%=request("notes")%>">
    
        <table border=0 cellpadding=0 cellspacing=0 width=100%>
            <!--include file="Includes/hierarchyTaskDetails.inc"--> 
            <tr>
                <td class=titlearealine height=1></td> 
            </tr>
            <tr class=SectionHeader>
                <td height=16>
                    <table border=0 cellpadding=0 cellspacing=0 >
                        <tr>
                            <td class=toolbar width=8>&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table width=100% border=0 cellpadding=0 cellspacing=0>
                        <tr>
                            <td colspan="3" height="22">&nbsp;</td>
                        </tr>
                        <tr class=columnheading>
                            <td valign="middle" width=2% height=22>&nbsp;</td>
                            <td valign="middle" width=13% height=22>Task:</td>
                            <td valign="middle" width=85% class=itemfont height=22><%=rsRecSet("Task")%></td>
                        </tr>
                        <tr class=columnheading>
                            <td valign="middle" width=2% height=22>&nbsp;</td>
                            <td valign="middle" width="13%" height=22>Task Type:</td>
                            <td valign="middle" width="85%" height=22 class=itemfont><%=rsRecSet("Type")%></td>
                        </tr>
                        <tr class=columnheading>
                            <td valign="middle" width=2% height=22>&nbsp;</td>
                            <td valign="middle" width="13%" height="22">Start Date:</td>
                            <td valign="middle" width="85%" height="22" class=itemfont ><%=request("startDate")%></td>
                        </tr>
                        <tr class=columnheading>
                            <td valign="middle" width=2% height=22>&nbsp;</td>
                            <td valign="middle" width="13%" height="22">End Date:</td>
                            <td valign="middle" width="85%" height="22" class=itemfont ><%=request("endDate")%></td>
                        </tr>
                        <tr class=columnheading>
                            <td valign="middle" width=2% height=22>&nbsp;</td>
                            <td valign="middle" width="13%" height="22">Cancellable:</td>
                            <td valign="middle" width=85% height="22" class=itemfont>
                            <% if rsRecSet("cancellable") = true then %>
                                Yes
                            <% else %>
                                No
                            <% end if %> 
                            </td>
                        </tr>	
                        <tr>
                            <td colspan="3" height=22>&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan=3 class=titlearealine  height=1></td> 
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table border=0 cellpadding=0 cellspacing=0 width=100%>
            <tr class=SectionHeader>
                <td height="22" colspan=9>
                    <table width="100%" border=0 cellpadding=0 cellspacing=0 >
                        <tr>
                            <td width=1% height="25px" class=toolbar>&nbsp;</td>
                            <td width="99%" height="25px" class=toolbar valign="middle"><font color=#ff0000>!! Warning !! </font>The Personnel below are already assigned to the listed tasks</td>
                        </tr>
                    </table>
                </td>
            </tr>            
            <tr>
                <td height="22" colspan=9>&nbsp;</td>
            </tr>
            <tr>
                <td colspan=9>
                    <table width=100% border=0 cellpadding=0 cellspacing=0>
                        <tr class=columnheading>
                            <td valign="middle" width=5% height=22>&nbsp;</td>
                            <td valign="middle" width=19.5% height=22>Surname</td>
                            <td valign="middle" width=19.5% height=22>Firstname</td>
                            <td valign="middle" width=13% height=22>Service No</td>
                            <td valign="middle" width=18% height=22>Existing Task</td>
                            <td valign="middle" align="center" width=10% height=22>Start Date</td>
                            <td valign="middle" align="center" width=10% height=22>End Date</td>
                            <td valign="middle" width=5% height=22>&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan=8 class=titlearealine  height=1></td> 
                        </tr>
                        <% tempServiceNo ="" %>
                        <% do while not RSList.eof %>
                            <% if tempServiceNo <> RSList("serviceno") then %>
                                <% if counter = 0 then %>
                                    <% counter = 1 %>
                                <% else %>
                                    <% if counter = 1 then counter = 0 %>
                                <% end if %>
                            <% end if %>
                            <% if tempServiceNo <> RSList("serviceno") and tempServiceNo <> "" then %>
                                <tr>
                                    <td colspan=8 height=10>&nbsp;</td> 
                                </tr>
                                <tr>
                                    <td colspan=8 class=titlearealine  height=1></td> 
                                </tr>
                            <% end if %>
                            <tr class=itemfont <% if counter = 0 then %>style="background-color:<%=color1%>;"<% else %>style="background-color:<%=color2%>;"<% end if %>>
                                <td valign="middle" width=5% height=22>&nbsp;</td>
                                <td valign="middle" width=19.5% height=22 <% if tempServiceNo = RSList("serviceno") then %>style="background-color:#ffffff"<% end if %>><%if tempServiceNo <> RSList("serviceno") then response.write RSList("surname") %></td>
                                <td valign="middle" width=19.5% height=22 <% if tempServiceNo = RSList("serviceno") then %>style="background-color:#ffffff"<% end if %>><%if tempServiceNo <> RSList("serviceno") then response.write  RSList("firstname") %></td>
                                <td valign="middle" width=13% height=22 <% if tempServiceNo = RSList("serviceno") then %>style="background-color:#ffffff"<% end if %>><%if tempServiceNo <> RSList("serviceno") then response.write RSList("serviceno") %></td>
                                <td valign="middle" width=18% height=22><%= RSList("description") %></td>
                                <td valign="middle" align="center" width=10% height=22><%= RSList("startDate") %></td>
                                <td valign="middle" align="center" width=10% height=22><%= RSList("endDate") %></td>
                                <td valign="middle" width=5% height=22>&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan=8 class=titlearealine height=1></td> 
                            </tr>  
                            <% Row = Row + 1 %>
                            <% tempServiceNo=RSList("serviceno") %>
                            <% RSList.movenext %>
                        <% loop %>
                        <tr>
                            <td height="22" colspan=8>&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan=8 align="center">
                                <table width=400px border=0 cellpadding=0 cellspacing=0>
                                    <tr>
                                        <td colspan=5 align="center" class=toolbar height="22">Clicking OK will overwrite the above task(s) with the new task.</td>
                                    </tr>
                                    <tr>
                                        <td height=22 colspan=5>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td width=115px>&nbsp;</td>
                                        <td style="cursor:hand;" width=80px middle align="center"><img width="76px" src="images/OK.gif" onclick="saveNew();"></td>
                                        <td>&nbsp;</td>
                                        <td style="cursor:hand;" width=80px valign="middle" align="center"><img width="76px" src="images/cancel.gif" onclick="window.parent.refreshIframeAfterDateSelect('HierarchyTaskingView.asp');"></td>
                                        <td width=115px>&nbsp;</td>
                                    </tr>
                                </table>
                            </td> 
                        </tr>
                    </table>
                </td> 
            </tr>
        </table>
    </Form>
    </Body>
    </html>

     <script language="javascript">
	
		function saveNew()
		{		
			document.frmDetails.action="UpdateTaskIndividualConfirmed.asp";
			document.frmDetails.submit();
		}
    </Script>
<%elseif RSList.recordCount > 0 and intFlag = 1 then %>
	<script language="javascript">
		window.location="UpdateTaskIndividualConfirmed.asp?RecID=<%= request("RecID") %>&serviceNo=<%= request("serviceNo") %>&startDate=<%= request("startDate") %>&endDate=<%= request("endDate") %>&notes=<%= request("notes") %>&id=<%= intID %>&flag=<%= intFlag %>";
	</script>
<% else %>
	<SCRIPT LANGUAGE="JavaScript">
		window.parent.refreshIframeAfterDateSelect('HierarchyTaskingView.asp');
    </Script>
<%end if%>
