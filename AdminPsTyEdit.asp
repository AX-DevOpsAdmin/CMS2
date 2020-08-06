<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
strAction="Update"

strTable = "tblTaskType"
strRecid = "ttID"
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

<script type="text/javascript" src="jscolor/jscolor.js"></script>
</head>
<body>
<form action="UpdatePsTy.asp?strAction=<%=strAction%>&strTable=<%=strTable%>&strTabid=<%=strRecID%>" method="POST" name="frmDetails">
  <input type="hidden" name="RecID" id="RecID" value=<%=request("RecID")%>> 
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"--> 
  		  <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Task Type</strong></font></td>
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
					    <td class=toolbar width=8></td>
						<td width=20><a  href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td class=toolbar valign="middle" >Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminPsTyDetail.asp?RecID=<%=request("RecID")%>">Back</A></td>											
					 </table>
					</td>
			      </tr>
				  <tr>
					<td>
					  <table width="100%" border=0 cellpadding=0 cellspacing=0>
						<tr height=16>
						  <td colspan="3"></td>
						</tr>
						<tr class=columnheading height=22>
						  <td valign="middle" width=2%>&nbsp;</td>
						  <td valign="middle" width=13%>Task Type:</td>
						  <td valign="middle" width=85%><INPUT class="inputbox" style="WIDTH: 300px" maxLength="200" name="description" id="description" Value="<%=rsRecSet("Description")%>"></td>
						</tr>
                        <tr class=columnheading height=22>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width=13%>Task Colour:</td>
						<td valign="middle" width=85%><input name="txtcolor" id="txtcolor" type="text" class='color1' value="<%=rsRecSet("taskcolor")%>"></td>
					  </tr>

						<tr height=16>
						  <td colspan="3"></td>
						</tr>
						<tr>
       					  <td colspan=3 class=titlearealine height=1></td> 
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

function checkThis()
{
	//This function renoves any leading or trailing spaces from a string
	String.prototype.killWhiteSpace = function()
	{
		return this.replace(/\s/g, '');
	};

	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;
	  
	var tt = document.frmDetails.description.value;
	tt = tt.killWhiteSpace(); 

	/* make sure they have entered comments for the next stage */
	if(tt == "")
	{
		errMsg += "Task Type"
		error = true;
	}

	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 
	
    document.frmDetails.submit();  
}

</Script>
