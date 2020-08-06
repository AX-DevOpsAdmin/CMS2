<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Includes/checkadmin.asp"--> 
<!--#include file="Connection/Connection.inc"-->

<%
' This is the Initial Display Page of Harmony Period data
' so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="UnHp"

strCommand = "spGetUnitHarmonyTarget"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4
objCmd.Activeconnection.cursorlocation = 3	

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
strExists=rsRecSet.recordcount
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
  <Input name=RecID type=Hidden>

	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
      <tr>
        <td>
          <!--#include file="Includes/Header.inc"--> 
  		  <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Unit Harmony</strong></font></td>
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
						  <table width="500" border=0 cellpadding=0 cellspacing=0 >
						    <tr>
							    <!-- we only want ONE record here -->
						        <% if rsRecset.recordcount = 0 then %>
                                 <td valign="middle" width="8">&nbsp;</td>
							     <td width=20><a class=itemfontlink href="AdminUnitHPAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
							     <td valign="middle" class=toolbar>New Harmony Targets </td>
								 <% end if %>
							</tr>  
					      </table>
						  
						</td>
					  </tr>
					  <tr>
					    <td>
						  <table width=123% border=0 cellpadding=0 cellspacing=0>
						    <tr class=columnheading height=20>
							  <td width=2% height="16" valign="middle"></td>
							  <td valign="middle" width=22%>BNA Green</td>
							  <td valign="middle" width=34%>OOA Green</td>
							  <td valign="middle" width=31%></td>
							  <td valign="middle" width=11%></td>
							</tr>
						  	<tr>
       						  <td colspan=5 class=titlearealine  height=1></td> 
     					    </tr>
							<%do while not rsRecSet.eof%>
							  <tr class=itemfont ID="TableRow<%=rsRecSet("uhpID")%>" height=30>
								<td valign="middle" width=2%></td>
				                <td valign="middle" align="left"><a class=itemfontlink href="javascript: subForm(<%=rsRecSet("uhpID")%>)"><%= FormatNumber (rsRecSet("bnagrnmin"), 2) & " > " & FormatNumber (rsRecSet("bnagrnmax"), 2)%></a></td> 
							    <td valign="middle" align="left"><%=FormatNumber (rsRecSet("ooagrnmin"), 2) & " > " & FormatNumber (rsRecSet("ooagrnmax"), 2)%></td> 
						      </tr>
  							  <tr>
       						    <td colspan=5 class=titlearealine  height=1></td> 
     						  </tr>
							<%rsRecSet.MoveNext
							Loop%>
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
function subForm(recID){
     document.forms.frmDetails.action = "AdminUnitHPDetail.asp";
	 document.forms.frmDetails.RecID.value = recID;
	 document.forms.frmDetails.submit(); 
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
