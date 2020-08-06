<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
strTable = "tblHarmonyPeriod"
strTabID = "hpID"              ' key field name for table        

strRecid = "hpID"

strGoTo = "AdminHPList.asp"   ' asp page to return to once record is deleted
strCommand = "spGetPersonnelHP"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

'set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("RecID"))
'objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("TableID",200,1,50, strRecID)
'objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("Tablename",200,1,50, strTable)
'objCmd.Parameters.Append objPara

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

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
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Harmony Period Details</strong></font></td>
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
                                            <td class=toolbar width=9></td>
                                            <td width=20><a class=itemfontlink href="AdminHPEdit.asp?RecID=<%=rsRecSet("hpID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
                                            <td valign="middle" class=toolbar >Edit Harmony Period</td>
                                            <!--
                                            <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                            <td valign="middle" class=toolbar ><A class=itemfontlink href="AdminHPList.asp">Back To List</A></td>
                                            -->											
										</table>
                                    </td>
                                </tr>
                            </table>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td height=22>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width="2%"></td>
                                    <td width="98%">
                                        <table width=770px border=0 cellpadding=0 cellspacing=0>
                                            <tr class=columnheading>
                                                <td height=22>&nbsp;</td>
                                                <td colspan="3"><span class="style10">NB: All Harmony Periods are Rolling Periods in Months ie: 20 = 20 Months</span></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" height=22>&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height=22></td>
                                                <td colspan="3" valign="middle" height=22><span class="style7"><strong>Out of Area (OOA) Harmony Period Limits</strong></span></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">OOA Harmony Period:</td>
                                                <td colspan="2" valign="middle" class="itemfont"><%=rsRecSet("ooaperiod")%></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td width="4px" valign="middle"></td>
                                                <td width="150px" valign="middle">Red Days:</td>
                                                <td width="40px" valign="middle" class="itemfont"><%=rsRecSet("ooared")%></td>
                                                <td width="600px" valign="middle"><span class="style7">The number of Operational Days Away in a Rolling Period before the Harmony Status is</span><span class="style10"> RED</span></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">Amber Days:</td>
                                                <td valign="middle" class="itemfont"><%=rsRecSet("ooaamber")%></td>
                                                <td valign="middle"><span class="style7">The number of Operational Days Away in a Rolling Period before the Harmony Status is</span> <span class="style12"> AMBER</span></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" height=22>&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height=22></td>
                                                <td colspan="3" valign="middle"><span class="style7"><strong>SSC A Harmony Period Limits</strong></span></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">SSC A Harmony Period:</td>
                                                <td colspan="2" valign="middle" class="itemfont"><%=rsRecSet("ssaperiod")%></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">Red Days:</td>
                                                <td valign="middle" class="itemfont"><%=rsRecSet("ssared")%></td>
                                                <td valign="middle"><span class="style7">The number of Seperated Service (A) Days in a Rolling Period before the Harmony Status is </span><span class="style10"> RED</span></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">Amber Days:</td>
                                                <td valign="middle" class="itemfont"><%=rsRecSet("ssaamber")%></td>
                                                <td valign="middle"><span class="style7">The number of Seperated Service (A) Days in a Rolling Period before the Harmony Status is</span> <span class="style12"> AMBER</span></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" height=22>&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td colspan="3" valign="middle"><span class="style7"><strong>SSC B Harmony Period Limits</strong></span></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">SSC B Harmony Period:</td>
                                                <td colspan="2" valign="middle" class="itemfont"><%=rsRecSet("ssbperiod")%></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">Red Days:</td>
                                                <td valign="middle" class="itemfont"><%=rsRecSet("ssbred")%></td>
                                                <td valign="middle"><span class="style7">The number of Seperated Service (B) Days in a Rolling Period before the Harmony Status is </span><span class="style10"> RED</span></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">Amber Days:</td>
                                                <td valign="middle" class="itemfont"><%=rsRecSet("ssbamber")%></td>
                                                <td valign="middle"><span class="style7">The number of Seperated Service (B) Days in a Rolling Period before the Harmony Status is</span> <span class="style12"> AMBER</span></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" height=22>&nbsp;</td>
                                            </tr>
                                        </table>
                                    </td>
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
