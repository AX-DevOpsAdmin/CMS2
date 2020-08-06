<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
strAction="Update"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4		

'Recordset to populate Hierarchy Drop Down Box
objCmd.CommandText = "spGetHierarchyList"
set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara
set rsHrc = objCmd.Execute	

objCmd.Parameters.delete ("nodeID")

objCmd.CommandText = "spGetHierarchyDetail"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter ("hrcID",3,1,5, request("hrcID"))
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
<form action="UpdateHierarchy.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
  <input type="hidden" name="hrcID" id="hrcID" value="<%=request("hrcID")%>">  
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"-->
  	    
        <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Hierarchy</strong></font></td>
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
						<td class=toolbar valign="middle">Save and Close</td>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminHierarchyList.asp">Back To List</A></td>											
					</table>
				  </td>
				</tr>
				<tr>
				  <td>
					<table width=100% border=0 cellpadding=0 cellspacing=0>
					  <tr height=16>
					    <td></td>
					  </tr>
					  <tr class=columnheading height=30>
                        <td valign="middle" width=2%>&nbsp;</td>
                        <td valign="middle" width=13%>Hierarchy:</td>
                        <td valign="middle" width=85%><input class="inputbox itemfont" style="WIDTH: 360px" maxLength="50" name="txtdescription" id="txtdescription" Value="<%= rsRecSet("hrcname")%>"><% if request("err") = "True" then %>&nbsp;<span class="style2">Already exists</span><% end if %></td>
					  </tr>
					  <tr class=columnheading height=30>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width=13%>Parent:</td>
						<td valign="middle" width=85%>
                        	<select name="cmbhrc" class="inputbox" id="cmbhrc" >
						    <option value="0">Select...</option>
                            <%do while not rsHrc.eof %>
                              <option value="<%= rsHrc("hrcID") %>" <%if rsHrc("hrcID") = rsRecSet("parentID") then%>selected<%end if%>><%= rsHrc("hrcName") %></option>
                            <% rsHrc.movenext
			                loop%>
							</select>
					    </td> 
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

function checkThis()
{
	//This function renoves any leading or trailing spaces from a string
	String.prototype.killWhiteSpace = function()
	{
		return this.replace(/\s/g, '');
	};

	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;
	  
	var hrc = document.frmDetails.txtdescription.value;
	hrc = hrc.killWhiteSpace(); 
	var parent = document.frmDetails.cmbhrc.value;

	/* make sure they have entered comments for the next stage */
	if(hrc == "")
	{
		errMsg += "Hierarchy\n"
		error = true;
	}

	if(parent == "")
	{
		errMsg += "Parent"
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
