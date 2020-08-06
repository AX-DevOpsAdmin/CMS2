<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%

strTable = "tbl_Task"
strGoTo = "AdminPsTaList.asp"   ' asp page to return to once record is deleted
strTabID = "taskID"              ' key field name for table   

strRecid = "taskID"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4		
objCmd.Activeconnection.cursorlocation = 3

' 'first find out whether its an HQ Tasking Group - cos if it is then we display HQ Task details
'strCommand = "spCheckHqTask"
'objCmd.CommandText = strCommand
'
'set objPara = objCmd.CreateParameter ("StaffID",3,1,0, session("StaffID"))
'objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("HQTasking",3,2)
'objCmd.Parameters.Append objPara
'
'objCmd.Execute	             ' 'Execute CommandText when using "ADODB.Command" object
'strHQTasking   = objCmd.Parameters("HQTasking") 
'
'' 'Now Delete the parameters
'objCmd.Parameters.delete ("StaffID")
'objCmd.Parameters.delete ("HQTasking")

strCommand = "sp_TaskDetail"
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
objCmd.CommandText = strCommand
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

if rsRecSet("ooa")=1 then
  strHarmony = "Out of Area"
elseif rsRecSet("ooa")=2 then
  strHarmony = "Bed Nights Away"
else  
  strHarmony = "None"
End if

if int(rsRecSet("sscID")) = 0 then
  strSSC= "None"
elseif int(rsRecSet("ssCode")) < 10 then
  strSSC= "0" & rsRecSet("ssCode") & "  -  " & rsRecSet("SSC")
else
  strSSC= rsRecSet("ssCode") & "  -  " & rsRecSet("SSC")
end if	 		 

' now see if we can delete it - if it has no children then we can return parameter for Delete check'
objCmd.CommandText = "spPsTaDel"	' 'Name of Stored Procedure
set objPara = objCmd.CreateParameter("@DelOK",3,2)'
objCmd.Parameters.Append objPara
objCmd.Execute	
strDelOK = objCmd.Parameters("@DelOK")'

%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->

<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<form action="" method="POST" name="frmDetails">
  <table height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"-->
		<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Task Details</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
			<td width=16></td>
		    <td  align=left >
			  <table border=0 cellpadding=0 cellspacing=0 width=100%>
				<tr height=16 class=SectionHeader>
				  <td>
					<table border=0 cellpadding=0 cellspacing=0 >
                    <!--
					  <td class=toolbar width=8></td><td width=20><a class=itemfontlink href="AdminPsTaAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
					    <td class=toolbar valign="middle" >New Task</td>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
                     -->
                        <td width=20><a class=itemfontlink href="AdminPsTaEdit.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td class=toolbar valign="middle" >Edit Task </td>
						<%IF strDelOK = "0" THEN %>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
                        <td width=20><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("recID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
						<td class=toolbar valign="middle" >Delete Task</td>
                        <%END IF %>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class=itemfontlink href="AdminPsTaList.asp">Back To List</A></td>											
					</table>
				  </td>
				</tr>
				<tr>
				  <td>
					<table width=100% border=0 cellpadding=0 cellspacing=0>
					  <tr height=16>
						<td>&nbsp;</td>
					  </tr>
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Task Type:</td>
						<td valign="middle" width="85%" class=itemfont><%=rsRecSet("type")%></td> 
					  </tr>

					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width=13%>Task:</td>
						<td valign="middle" width=85% class=itemfont><%=rsRecSet("task")%></td>
					  </tr>
					 <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Task SSC:</td>
					    <td valign="middle" width=85% class=itemfont><%=strSSC%></td>
					 </tr>	
                      <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Task Harmony:</td>
					    <td valign="middle" width=85% class=itemfont><%=strHarmony%></td>
					 </tr>						 
                      <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Cancellable:</td>
					    <td valign="middle" width=85% class=itemfont>
						<% if rsRecSet("cancellable") = true then %>
							Yes
						<% else %>
							No									 
					    <% end if %>
                        </td>
					 </tr>	
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
						<% if strHQTasking = 1 then %>
							<td valign="middle" width="13%">HQ Task:</td>
					    	<td valign="middle" width=85% class=itemfont>
							<% if rsRecSet("hqTask") = true then %>
								Yes
						    <% else %>
								No
							<% end if %> 
						</td> 
					   <%end if %>	
					 </tr>	
					  <tr>
       					<td colspan=3 class=titlearealine  height=1></td> 
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