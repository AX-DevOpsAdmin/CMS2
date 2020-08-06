<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%
strTable = "tblCycle"
strGoTo = "AdminCycleList.asp"   ' asp page to return to once record is deleted
strTabID = "cyID"              ' key field name for table        

strRecid = "cyID"

' set basic commands
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4		

' now get any stages attached to this cycle
strCommand = "spGetCurrStages"
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
objCmd.CommandText = strCommand
set rsCySteps = objCmd.Execute

' now get the Cycle 
strCommand = "spRecDetail"
set objPara = objCmd.CreateParameter ("TableID",200,1,50, strRecID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Tablename",200,1,50, strTable)
objCmd.Parameters.Append objPara
objCmd.CommandText = strCommand
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' We don't want these in check for Delete
objCmd.Parameters.delete ("TableID")
objCmd.Parameters.delete ("Tablename")

' now see if we can delete it - if it has no children then we can
' return parameter for Delete check
objCmd.CommandText = "spCycleDel"	'Name of Stored Procedure
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
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Admin Cycle Details</strong></font></td>
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
					  <td class=toolbar width=4></td>
                      <td width=20><a class=itemfontlink href="AdminCycleAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
					    <td width="60" valign="middle" class=toolbar >New Cycle</td>
						<td class=titleseparator valign="middle" width=12 align="center">|</td>
						<td width=20><a class=itemfontlink href="AdminCycleEdit.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td width="60" valign="middle" class=toolbar >Edit Cycle</td>
						<td class=titleseparator valign="middle" width=10 align="center">|</td>
						<td width=20><a class=itemfontlink href="AdminCyAddStages.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/newitem.gif"></A></td>
						<td width="103" valign="middle" class=toolbar >Add Cycle Stages</td>
                        <td class=titleseparator valign="middle" width=10 align="center">|</td>
						<td width=20><a class=itemfontlink href="AdminCyRemStages.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td width="130" valign="middle" class=toolbar >Remove Cycle Stages</td>
						<% IF strDelOK = "0" THEN %>
						<td class=titleseparator valign="middle" width=10 align="center">|</td>
					    <td width=20><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("Recid")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
						<td width="80" valign="middle" class=toolbar >Delete Cycle</td>
                        <%END IF %>
						<td class=titleseparator valign="middle" width=10 align="center">|</td>
						<td width="84" valign="middle" class=toolbar ><A class=itemfontlink href="AdminCycleList.asp">Back To List</A></td>											
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
						<td valign="middle" width=13%>Cycle:</td>
						<td valign="middle" width=85% class=itemfont><%=rsRecSet("Description")%></td>
					  </tr>
					  <tr class=columnheading height=22>
					    <td valign="middle" width=1%>&nbsp;</td>
					    <td valign="middle" width="13%">Cycle Days:</td>
						<td valign="middle" width=85% class=itemfont><%=rsRecSet("cydays")%></td>
					  </tr>
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
					    <td valign="middle" width="13%">Cycle Stages:</td>
						<td valign="middle" width="85%">&nbsp;</td>
					  </tr>
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
						<td valign=middle width=13% class=itemfont>
						    <table>
							  <tr><td></td></tr>
							  <% do while not rsCySteps.eof 
							      ' build string of current stages
							      if strCurrStages = "" then
								   strCurrStages = rsCySteps("cysID") & ","
								 else
								   strCurrStages = strCurrStages & rsCySteps("cysID") & ","
								 end if
							  %>
							     <tr>
								   <td><%=rsCySteps("description")%></td>
								 </tr>
								 <% rsCySteps.movenext %>
							  <% loop %>	 							
							</table>
						</td>
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
