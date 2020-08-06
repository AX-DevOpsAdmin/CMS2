<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
strAction="Add"

'Recordset to populate FlightGroup Drop Down Box
set objCmd = server.CreateObject("ADODB.Command")
objCmd.ActiveConnection = con
objCmd.CommandText = "spListSquadrons"	'Name of Stored Procedure
objCmd.CommandType = 4				    'Code for Stored Procedure
set rsRecSet = objCmd.Execute	
	
%>

<html>
<head>
<!--#include file="Includes/IECompatability.inc"-->
<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<form method="post" name="frmDetails" action="UpdateFlight.asp?strAction=<%=strAction%>" >
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"-->
  	    
       <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Add New Flight</strong></font></td>
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
						<td width=20><a href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td class=toolbar valign="middle">Save and Close</td>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminFlightList.asp">Back To List</A></td>											
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
						<td valign="middle" width=13%>Flight:</td>
						<td valign="middle" width=85%><input name="txtdescription" class="inputbox itemfont" id="txtdescription" style="WIDTH: 360px" Value="<%if request("err") = "True" then%><%= request("description") %><%end if%>" maxLength=50><% if request("err") = "True" then %>&nbsp;<span class="style2">Already exists</span><% end if %></td>
					  </tr>
					  <tr class=columnheading height=30>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width=13%>Squadron:</td>
						<td valign="middle" width=85%>
                          <select name="cmbSqn" id="cmbSqn" class="inputbox" id="cmbSqn" >
                            <option value="">...Select...</option>
                            <%do while not rsRecSet.eof %>
                            <option <% if request("err") = "True" then %><%if rsRecSet("sqnid") = cint(request("sqn")) then%>selected<%end if%><%end if%> value="<%= rsRecSet("sqnid") %>" ><%= rsRecSet("description") %></option>
                            <% rsRecSet.movenext
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
	  
	var Flight = document.frmDetails.txtdescription.value;
	Flight = Flight.killWhiteSpace(); 
	var Squadron = document.frmDetails.cmbSqn.value;

	/* make sure they have entered comments for the next stage */
	if(Flight == "")
	{
		errMsg += "Flight\n"
		error = true;
	}

	if(Squadron == "")
	{
		errMsg += "Squadron"
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
