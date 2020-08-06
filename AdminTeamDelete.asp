<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = "spTeamDetail"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure
set objPara = objCmd.CreateParameter ("TeamID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
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
    	  <tr >
      	    <td align="center" class="sidemenuwidth" ><img alt="" src="images/spssites.gif" ></td>
       		<td  class=titlearea >Teams<BR><span class="style1"><Font class=subheading>Team Details</Font></span></td>
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
          		  <td width=30></td><td colspan=3 align=left height=20>Current Location</td>
			    </tr>
				<tr height=20>
	              <td width=30></td>
				  <td width="25" valign=top><img src="images/arrow.gif"></td>
				  <td width="132" align=Left  ><A title="" href="index.asp">Home</A></td>
				  <td width="13" align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=30 ></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="AdminHome.asp">Administration</A></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=30></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="AdminDataMenu.asp">Static Data</a></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=30></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="AdminFlightList.asp">Teams</a></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=30></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Team Details</Div></td>
				  <td class=rightmenuspace align=Left ></td>
				</tr>
				<tr height=20>
	          	  <td width=30></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left  ><A title="" href="AdminTeamEdit.asp?RecID=<%=request("RecID")%>">Edit Team</A></td>
				  <td align=Left  ></td>
				</tr>
			    <tr height=20>
	          	  <td width=30></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left  ><A title="" href="AdminTeamAdd.asp">New Team</A></td>
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
					  <td class=toolbar width=8></td><td width=20><a class=itemfontlink href="AdminTeamAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
					    <td class=toolbar valign="middle" >New Team</td>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar width=8></td><td width=20><a class=itemfontlink href="AdminTeamEdit.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td class=toolbar valign="middle" >Edit Team</td>
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
						<td valign="middle" width=2%></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >Parent Type:</td>
						<td valign="middle"  class=itemfont ><%=rsRecSet("TeamInName")%></td>
						<td></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >Parent:</td>
						<td valign="middle"  class=itemfont ><%=rsRecSet("ParentDescription")%></td>
						<td></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >Team Size:</td>
						<td valign="middle"  class=itemfont ><%=rsRecSet("Teamsize")%></td>
						<td></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >Team Weight:</td>
						<td valign="middle"  class=itemfont ><%=rsRecSet("Weight")%></td>
						<td></td>
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
