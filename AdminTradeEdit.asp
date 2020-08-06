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
objCmd.CommandType = 4				'Code for Stored Procedure

'Recordset to populate TradeGroup Drop Down Box
objCmd.CommandText = "spListTradeGroup"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
objCmd.Parameters.Append objPara
set rsTrGroup = objCmd.Execute	

objCmd.parameters.delete("nodeID")

'get TG we clicked on
objCmd.CommandText = "spTradeDetail"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter ("TradeID",3,1,5, request("TradeID"))
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
<form  action="UpdateTrade.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
  <input type=hidden name=TradeID id="TradeID" value=<%=request("TradeID")%>>  
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"--> 
  		  <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Trade</strong></font></td>
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
						<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminTradeDetail.asp?TradeID=<%=request("TradeID")%>">Back</A></td>											
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
						  <td valign="middle" width=13%>Trade:</td>
						  <td valign="middle" width=85%><INPUT name=txtdescription class="itemfont" id="txtdescription" style="WIDTH: 360px" Value="<%=rsRecSet("Description")%>" maxLength=300></td>
						</tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle" width=13%>Trade Group:</td>
						<td valign="middle" width=85%>
                        <select name="cmbtrgroup" id="cmbtrgroup" class="inputbox" style="width:80px;">
                            <option value="0">...Select</option>
                            <%do while not rsTrGroup.eof %>
                                <option value = "<%= rsTrGroup("tradegroupid") %>" <%if (rsTrGroup("tradegroup") = rsRecSet("tradegroup")) then Response.Write("SELECTED") : Response.Write("")%> ><%= rsTrGroup("tradegroup") %></option>
                                <% rsTrGroup.movenext
                            loop%>
                        </select>
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

function checkThis()
{
	//This function renoves any leading or trailing spaces from a string
	String.prototype.killWhiteSpace = function()
	{
		return this.replace(/\s/g, '');
	};

	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;
	
	var trade = document.frmDetails.txtdescription.value; 
	trade = trade.killWhiteSpace();
	var tradegroup = document.frmDetails.cmbtrgroup.value;
	
	/* make sure they have entered comments for the next stage */
	if(trade == "")
	{
		errMsg += "Trade\n"
		error = true;
	}

	if(tradegroup == 0)
	{
		errMsg += "Trade Group"
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
