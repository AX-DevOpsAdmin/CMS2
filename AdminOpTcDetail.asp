<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%
strTable = "tblOpTaskCategory"
strGoTo = "AdminOPTcList.asp"   ' asp page to return to once record is deleted
strTabID = "otcID"              ' key field name for table        

strRecid = "otcID"
strCommand = "spRecDetail"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TableID",200,1,50, strRecID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Tablename",200,1,50, strTable)
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' We don't want these in check for Delete
objCmd.Parameters.delete ("TableID")
objCmd.Parameters.delete ("Tablename")

' now see if we can delete it - if it has no children then we can
' return parameter for Delete check
objCmd.CommandText = "spOpTcDel"	'Name of Stored Procedure
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
    	  <tr >
      	    <td align="center" class="sidemenuwidth" ><img alt="" src="images/spssites.gif" ></td>
       		<td  class=titlearea >Task Categorys<BR>
       		<span class="style1"><Font class=subheading>Op Task Category Details</Font></span></td>
    	  </tr>
  		  <tr>
       		<td colspan=2 class=titlearealine  height=1></td> 
     	  </tr>
  		</table>
  		<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      	  <tr valign=Top>
            <td class="sidemenuwidth" background="Images/tableback.png">
			  <table width=99% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
			    <tr height=20>
          		  <td width=9></td><td colspan=3 align=left height=20>Current Location</td>
			    </tr>
				<tr height=20>
	              <td width=9></td>
				  <td width="18" valign=top><img src="images/arrow.gif"></td>
				  <td width="157" align=Left  ><A title="" href="index.asp">Home</A></td>
				  <td width="6" align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=9 ></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="AdminHome.asp">Administration</A></td>
				  <!--<td align=Left  ></td>-->
				</tr>
				<tr height=20>
	          	  <td width=9></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="AdminDataMenu.asp">Static Data</a></td>
				  <!--<td align=Left  ></td>-->
				</tr>
				<tr height=20>
	          	  <td width=30></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="AdminTasks.asp">Tasks</a></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=9></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="AdminOpTasks.asp">Operational Tasks</a></td>
				  <!--<td align=Left  ></td>-->
				</tr>
				<tr height=20>
	          	  <td width=9></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Op Task Category Details</Div></td>
				  <!--<td class=rightmenuspace align=Left ></td>-->
				</tr>
				<tr height=20>
	          	  <td width=9></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left  ><A title="" href="AdminOpTcEdit.asp?RecID=<%=request("RecID")%>">Edit Op Task Category</A></td>
				  <!-- <td align=Left  ></td> -->
				</tr>
			    <tr height=20>
	          	  <td width=9></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left  ><A title="" href="AdminOpTcAdd.asp">New Op Task Category</A></td>
				  <!--<td align=Left  ></td>-->
				</tr>
			  </table>
			</td>
			<td width=16></td>
		    <td align=left >
			  <table border=0 cellpadding=0 cellspacing=0 width=100%>
				<tr height=16 class=SectionHeader>
				  <td>
					<table width="684" border=0 cellpadding=0 cellspacing=0 >
					  <td class=toolbar width=4></td><td width=16><a class=itemfontlink href="AdminOpTcAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
					    <td width="149" valign="middle" class=toolbar >New Op Task Category</td>
						<td class=titleseparator valign="middle" width=10 align="center">|</td>
						<td width=16><a class=itemfontlink href="AdminOpTcEdit.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td width="131" valign="middle" class=toolbar >Edit Op Task Category</td>
						<% IF strDelOK = "0" THEN %>
						<td class=titleseparator valign="middle" width=9 align="center">|</td>
						<td class=toolbar width=8></td><td width=16><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("recID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
						<td width="141" valign="middle" class=toolbar >Delete Task Category</td>
                        <%END IF %>
						<td class=titleseparator valign="middle" width=5 align="center">|</td>
						<td width="180" valign="middle" class=toolbar ><A class=itemfontlink href="AdminOpTcList.asp">Back To List</A></td>											
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
						<td valign="middle" width=21%>Task Category:</td>
						<td valign="middle" width=76% class=itemfont><%=rsRecSet("Description")%></td>
						<td valign="middle" width=1%></td>
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
