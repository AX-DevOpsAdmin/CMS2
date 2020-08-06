<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%

' This is the Initial Display Page of Harmony Period data

' so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="PsHp"

strCommand = "spGetHarmonyPeriods"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4
objCmd.Activeconnection.cursorlocation = 3	

set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

strExists=rsRecSet.recordcount

'response.write strExists
'response.End()

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
  <Input name="RecID" id="RecID" type="Hidden">

	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
      <tr>
        <td>
          <!--#include file="Includes/Header.inc"--> 
  		 <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Harmony Periods</strong></font></td>
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
						  <table width="100%" border=0 cellpadding=0 cellspacing=0 >
						    <tr>
							    <!-- we only want ONE record here -->
						        <% if rsRecset.recordcount = 0 then %>
							  	 <td class=toolbar width=8>&nbsp;</td>
							     <td width=20><a class=itemfontlink href="AdminHPAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
							     <td class=toolbar valign="middle">New Harmony Period</td>
								 <% end if %>
							</tr>  
					      </table>
						  
						</td>
					  </tr>
					  <tr>
					    <td>
						  <table width=123% border=0 cellpadding=0 cellspacing=0>
						    <tr class=columnheading height=20>
							  <td valign="middle" width=2%>&nbsp;</td>
							  <td valign="middle" width=20%>Out of Area Period </td>
							  <td valign="middle" width=20%>SSC A Period </td>
							  <td valign="middle" width=20%>SSC B Period </td>
							  <td valign="middle" width=38%>&nbsp;</td>
							</tr>
						  	<tr>
       						  <td colspan=5 class=titlearealine  height=1></td> 
     					    </tr>
							<%do while not rsRecSet.eof%>
							  <tr class=itemfont ID="TableRow<%=rsRecSet("hpID")%>" height=30>
								<td valign="middle" width=2%>&nbsp;</td>
				                <td valign="middle" width="20%"><a class=itemfontlink href="javascript: subForm(<%=rsRecSet("hpID")%>)"><%=rsRecSet("ooaperiod") & " Months"%></a></td> 
							    <td valign="middle" width="20%"><%=rsRecSet("ssaperiod") & " Months"%></td> 
								<td valign="middle" width="20%"><%=rsRecSet("ssbperiod") & " Months"%></td>
                                <td valign="middle" width="38%">&nbsp;</td>
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
     document.forms.frmDetails.action = "AdminHPDetail.asp";
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
