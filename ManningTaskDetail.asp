<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%

' parameters for the Delete Option
strTable = "tblTeam"    ' tablename
strGoTo = "ManningTeamSearch.asp"   ' asp page to return to once record is deleted
strTabID = "teamID"              ' key field name for table  
strFrom="Manning"      

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4				'Code for Stored Procedure

' first find out whether its an HQ Tasking Group - cos if it is then we display HQ Task details
strCommand = "spCheckHqTask"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("StaffID",3,1,0, session("StaffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("HQTasking",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	             'Execute CommandText when using "ADODB.Command" object
strHQTasking   = objCmd.Parameters("HQTasking") 
' Now Delete the parameters
objCmd.Parameters.delete ("StaffID")
objCmd.Parameters.delete ("HQTasking")

' first get the Team details
set objPara = objCmd.CreateParameter ("TaskID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
objCmd.CommandText = "sp_TaskDetail"	'Name of Stored Procedure'
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' now check to see if they have manager rights for this team'
' 1 = Manager   0 = User

%>

<html>

<head>  

<!--#include file="Includes/IECompatability.inc"-->
<title><%=pageTitle%></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
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
</style></head>
<body>
<form  action="" method="POST" name="frmDetails">
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"-->
		<table cellSpacing=0 cellPadding=0 width=100% border=0 >
    	  <tr  style="font-size:10pt;" height=26px>
      	    <td width=10px></td>
       		<td   ><A title="" href="index.asp" class=itemfontlinksmall >Home</A> > <A title="" href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=" class=itemfontlinksmall >Tasking</A> > <font class="youAreHere" >Task Details</font></td>
    	  </tr>
  		  <tr>
       		<td colspan=2 class=titlearealine  height=1></td> 
     	  </tr>
  		</table>
  		<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      	  <tr valign=Top>
            <td class="sidemenuwidth" background="Images/tableback.png">
			  <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
			    <tr height=20>
          		  <td ></td><td colspan=3 align=left height=20>Current Location</td>
			    </tr>
				<tr height=20>
	              <td width=10></td>
				  <td width=18 valign=top><img src="images/arrow.gif"></td>
				  <td width=170 align=Left  ><A title="" href="index.asp">Home</A></td>
				  <td width=50 align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td ></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=">Tasking</a></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td ></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Task Details</Div></td>
				  <td class=rightmenuspace align=Left ></td>
				</tr>
				<tr height=20>
	          	  <td ></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left  ><A title="" href="ManningTaskEdit.asp?RecID=<%=request("RecID")%>&fromPage=<%="Manning"%>">Edit Task</A></td>
				  <td align=Left  ></td>
				</tr>
			    <tr height=20>
	          	  <td ></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left  ><A title="" href="ManningNewTask.asp?fromPage=<%=strFrom%>">New Task</A></td>
				  <td align=Left  ></td>
				</tr>
			    <tr height=20>
	          	  <td ></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left  ><A title="" href="ManningTaskPersonnel.asp?RecID=<%=request("RecID")%>">Tasked Personnel</A></td>
				  <td align=Left  ></td>
				</tr>
			  </table>
			</td>
			<td width=16></td>
		    <td align=left >
			  <table border=0 cellpadding=0 cellspacing=0 width=100%>
				<tr height=16 class=SectionHeader>
				  <td>
					<table border=0 cellpadding=0 cellspacing=0 >
					    <td class=toolbar width=8></td>
						<% IF strManager = "1" THEN %>          
						<td class=toolbar width=8></td><td width=20><a class=itemfontlink href="ManningTaskEdit.asp?RecID=<%=request("RecID")%>&fromPage=<%=strFrom%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td class=toolbar valign="middle" >Edit Task</td>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar width=8></td><td width=20><a class=itemfontlink href="ManningTaskPersonnel.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td class=toolbar valign="middle" >Personnel</td>
						<% IF strDelOK = "0" THEN %>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
					    <td class=toolbar width=8></td><td width=20><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("recID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
						<td class=toolbar valign="middle" >Delete Task</td>
						<%END IF %>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
						<%END IF%>
						<td class=toolbar valign="middle" ><A class=itemfontlink href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=">Back To List</A></td>											
					</table>
				  </td>
				</tr>
				<tr>
				  <td>
					<table width=100% border=0 cellpadding=0 cellspacing=0>
					  <tr height=16>
						<td></td>
					  </tr>
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%></td>
						<td valign="middle" width=13%>Task:</td>
						<td valign="middle" width=82% class=itemfont><%=rsRecSet("Task")%></td>
						<td valign="middle" width=3%></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >Task Type:</td>
						<td valign="middle"  class=itemfont ><%=rsRecSet("Type")%></td>
						<td></td>
					  </tr>
					  <!-- Ron 070708
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >Start Date:</td>
						<td valign="middle"  class=itemfont ><'%=rsRecSet("startDate")%></td>
						<td></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >End Date:</td>
						<td valign="middle"  class=itemfont ><'%='rsRecSet("endDate")%></td>
						<td></td>
					  </tr>
					  -->
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%></td>
						<td valign="middle">Cancellable:</td>
					    <td  width=82% class=itemfont>
						<%if rsRecSet("cancellable")=true then%>
									 Yes
									 <%Else%>
									 No
									 <%End if%> 
						</td>
					 </tr>	
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%></td>
						<td valign="middle">Out of Area Task:</td>
					    <td  width=82% class=itemfont>
						<%if rsRecSet("ooa")=true then%>
									 Yes
									 <%Else%>
									 No
									 <%End if%> 
						</td>
					 </tr>	
					  

					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%></td>
						<% if strHQTasking = 1 then %>
						  <td valign="middle">HQ Task:</td>
					      <td  width=82% class=itemfont>
						    <%if rsRecSet("hqTask")=true then%>
									 Yes
						    <%Else%>
									 No
							<%End if%> 
						</td> 
					   <%end if %>	
					 </tr>	
					  
					  <tr height=16>
						<td></td>
					  </tr>
					  <tr>
       					<td colspan=5 class=titlearealine  height=1></td> 
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
<%
rsRecSet.close
set rsRecSet=Nothing
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
/**
function OverBackgroundChange(itemID){
    itemID.className='testTabHover';
}

function OutBackgroundChange(itemID){
    itemID.className='testTabUnselected';
}
RowColor=1
function ChangeRowColor(RowID){
	if (RowColor == 1) {
		document.all[RowID].style.backgroundColor= '#eeeeee'
		RowColor=2
	} else {
		document.all[RowID].style.backgroundColor= '#ffffff'
		RowColor=1
	}	
}
function ConfirmRefuse (LoanID, Action) {
	document.forms["Form"].elements["LoanID"].value=LoanID;
	document.forms["Form"].elements["ConfirmOrRefuse"].value=Action;
	document.forms["Form"].submit();
}
**/
</Script>
