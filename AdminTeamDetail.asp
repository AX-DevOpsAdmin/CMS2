<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%

' parameters for the Delete Option
strTable = "tblTeam"    ' tablename
strGoTo = "AdminTeamList.asp"   ' asp page to return to once record is deleted
strTabID = "teamID"              ' key field name for table    
strFrom="Admin"    

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4				'Code for Stored Procedure

' first get the Team details
set objPara = objCmd.CreateParameter ("TeamID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
objCmd.CommandText = "spTeamDetail"	'Name of Stored Procedure
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' Now get the Cycle Stage the Team is currently in
objCmd.CommandText = "spTeamCurrStage"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter ("CurrStage",3,2)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("teamCycle",200,2, 20)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("teamStage",200,2, 20)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("endDate",200,2,20)
objCmd.Parameters.Append objPara
objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' now get the output from spTeamCurrStage
strCurrStage = objCmd.Parameters("CurrStage")
strTeamCycle = objCmd.Parameters("teamCycle")
strTeamStage = objCmd.Parameters("teamStage")
strEndDate   = objCmd.Parameters("endDate")
' We don't want this in check for Delete

'response.write strCurrStage
'response.End()

' now see if we can delete it - if it has no children then we can return parameter for Delete check
objCmd.CommandText = "spTeamDel"	'Name of Stored Procedure
objCmd.Parameters.delete ("CurrStage")
objCmd.Parameters.delete ("teamCycle")
objCmd.Parameters.delete ("teamStage")
objCmd.Parameters.delete ("endDate")

set objPara = objCmd.CreateParameter("@DelOK",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	

strDelOK = objCmd.Parameters("@DelOK")


%>

<html>

<head> 

<!--#include file="Includes/IECompatability.inc"-->
<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<form  action="" method="POST" name="frmDetails">
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"-->
		<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Team Details</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
			<td width=16></td>
		    <td align=left >
			  <table border=0 cellpadding=0 cellspacing=0 width=100%>
				<tr height=16 class=SectionHeader>
				  <td>
					<table border=0 cellpadding=0 cellspacing=0 >
					  <td class=toolbar width=8></td><td width=20><a class=itemfontlink href="AdminTeamAdd.asp?fromPage=<%=strFrom%>"><img class="imagelink" src="images/newitem.gif"></a></td>
					    <td class=toolbar valign="middle" >New Team</td>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
                        </td><td width=20><a class=itemfontlink href="AdminTeamEdit.asp?RecID=<%=request("RecID")%>&fromPage=<%=strFrom%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td class=toolbar valign="middle" >Edit Team</td>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
                        </td><td width=20><a class=itemfontlink href="AdminTeamCycle.asp?RecID=<%=request("RecID")%>&fromPage=<%=strFrom%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td class=toolbar valign="middle" >Team Cycle</td>
						<% IF strDelOK = "0" THEN %>
                            <td class=titleseparator valign="middle" width=14 align="center">|</td>
                            <td width=20><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("recID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
                            <td class=toolbar valign="middle" >Delete Team</td>
						<%END IF %>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class=itemfontlink href="AdminTeamList.asp">Back To List</A></td>											
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
					    <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width=13%>Unit:</td>
						<td valign="middle" width=85% class=itemfont><%=rsRecSet("Description")%></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Parent Type:</td>
						<td valign="middle" width="85%" class=itemfont ><%=rsRecSet("TeamInName")%></td>
						<td></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Parent:</td>
						<td valign="middle" width="85%" class=itemfont ><%=rsRecSet("ParentDescription")%></td>
						<td></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Team Size:</td>
						<td valign="middle" width="85%" class=itemfont ><%=rsRecSet("Teamsize")%></td>
						<td></td>
					  </tr>
					  <!--
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >Control Post:</td>
						<td valign="middle"  class=itemfont ><%if rsRecSet("TeamCP")=true then response.write "Yes" else response.write "No" end if%></td>
						<td></td>
					  </tr>
					  -->
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Team Weight:</td>
						<td valign="middle" width="85%" class=itemfont ><%=rsRecSet("Weight")%></td>
						<td></td>
					  </tr>
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%></td>
						<td valign="middle" width="13%">Team Cycle:</td>
					    <td valign="middle" width=85% class=itemfont><%= strTeamCycle %></td>
					 </tr>	
					 <tr class=columnheading height=22>
					 <td valign="middle" width=2%></td>
						<td valign="middle" width="13%">Current Stage:</td>
						<td valign="middle" width=85% class=itemfont><%= strTeamStage%></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle" width="13%">Stage Ends:</td>
						<td valign="middle" width=85% class=itemfont><%= strEndDate%></td>
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
