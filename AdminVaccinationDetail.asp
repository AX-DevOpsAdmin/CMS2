<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
strTable = "tblMilitaryVacs"
strGoTo = "AdminVaccinationsList.asp"   ' asp page to return to once record is deleted
strTabID = "mvID"              ' key field name for table        

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = "spVaccinationDetail"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' now see if we can delete it - if it has no children then we can
' return parameter for Delete check
objCmd.CommandText = "spVacDel"	'Name of Stored Procedure
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
          <tr style="font-size:10pt;" height=26px>
                <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Vaccination Details</strong></font></td>
          </tr>
  		  <tr>
       		<td colspan=2 class=titlearealine  height=1></td> 
     	  </tr>
  		</table>
  		<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      	  <tr valign=Top>
            <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td> 
			<td width=16></td>
			<td align=left >
		    <td align=left >
			  <table border=0 cellpadding=0 cellspacing=0 width=100%>
				<tr height=16 class=SectionHeader>
				  <td>
					<table border=0 cellpadding=0 cellspacing=0 >
					  <td class=toolbar width=8></td>
                      <!--
                      <td width=20><a class=itemfontlink href="AdminVaccinationAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
					    <td class=toolbar valign="middle">New Vaccination</td>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
                       -->
                        <td width=20><a class=itemfontlink href="AdminVaccinationEdit.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td class=toolbar valign="middle">Edit Vaccination</td>
						<% IF strDelOK = "0" THEN %>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
                        <td width=20><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("recID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
						<td class=toolbar valign="middle">Delete Vaccination</td>
                        <%END IF %>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle"><A class=itemfontlink href="AdminVaccinationsList.asp">Back To List</A></td>											
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
						<td valign="middle" width=13%>Vaccination:</td>
						<td valign="middle" width=85% class=itemfont><%=rsRecSet("Description")%></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Required:</td>
						<td valign="middle" width="85%" class=itemfont ><%If rsRecSet("MVRequired")= True then response.write "Yes" else response.write "No" End if%></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Validity Period:</td>
						<td valign="middle" width="85%" class=itemfont ><%=rsRecSet("ValidityPeriod")%></td>
					  </tr>
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%></td>
						<td valign="middle" width=13%>Combat Ready:</td>
						<td valign="middle" width=85% class=itemfont><% if rsRecSet("Combat") = true then %><img src="Images/checked.gif"><% else %><img src="Images/unchecked.gif"><% end if %></td>
					  </tr>					  
					  <tr height=16>
						<td></td>
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
</Script>
<SCRIPT LANGUAGE="JavaScript">
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
