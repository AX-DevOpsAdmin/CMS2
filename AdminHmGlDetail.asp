<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
strTable = "tblHarmonyOverride"
strRecid = "hmovID"
strGoTo = "AdminHmGlList.asp"   ' asp page to return to once record is deleted
strTabID = "hmovID"              ' key field name for table   
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
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Harmony Guide Lines</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
		    <td align=left >
			  <table border=0 cellpadding=0 cellspacing=0 width=100%>
				<tr height=16 class=SectionHeader>
				  <td>
					<table width="628" height="24" border=0 cellpadding=0 cellspacing=0 >
						<td width=10 class=toolbar></td>
                        <!--
						<td width=20><a class=itemfontlink href="AdminHmGlAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
						<td width="145" valign="middle" class=toolbar >New Harmony Guidelines</td>
						<td width=10 class=titleseparator valign="middle" align="center">|</td>
                        -->
						<td width=26><a class=itemfontlink href="AdminHmGlEdit.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td width="166" valign="middle" class=toolbar >Edit Harmony Guidelines</td>
						<td width=16 class=titleseparator valign="middle" align="center">|</td>
						<td width=26><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("recID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
						<td width="188" valign="middle" class=toolbar >Delete Harmony Guidelines</td>
						<td width=18 class=titleseparator valign="middle" align="center">|</td>
						<td width="178" valign="middle" class=toolbar ><A class=itemfontlink href="AdminHmGlList.asp">Back To List</A></td>											
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
						<td valign="middle" width=18%>Harmony Override Reason:</td>
						<td valign="middle" width=80% align="left" class=itemfont><%=rsRecSet("Description")%></td>
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

</body>
</html>

<SCRIPT LANGUAGE="JavaScript">

function checkDelete(){
     var delOK = false 
    
	  var input_box = confirm("Are you sure you want to delete this Record?")
	  if(input_box==true) {
		    delOK = true;
	    }
    return delOK;
}

</Script>
