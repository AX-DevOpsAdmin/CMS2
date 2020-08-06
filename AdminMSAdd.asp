<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Includes/checkadmin.asp"--> 
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
strAction="Add"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con

strTable = "tblValPeriod"
strCommand = "spListTable"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
objCmd.Parameters.Append objPara

set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsValidityPeriodList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<form action="UpdateMS.asp?strAction=<%=strAction%>" method="post" name="frmDetails">
	<input type="hidden" name="recID" id="recID" value="<%=request("recID")%>">
	
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
		<tr>
			<td>
				<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Military Skills</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>



		    			<td align=left>
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr class=SectionHeader>
									<td>
										<table border=0 cellpadding=0 cellspacing=0>
											<tr>
												<td height="25px" class=toolbar width=8></td>
												<td height="25px" width=20><a href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
												<td height="25px" class=toolbar valign="middle" >Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
												<td height="25px" class=toolbar valign="middle" ><A class= itemfontlink href="AdminMSList.asp">Back To List</A></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<table width=100% border=0 cellpadding=0 cellspacing=0>
											<tr>
												<td colspan="3" height=22>&nbsp;</td>
											</tr>
											<tr class=columnheading>
												<td height=22 valign="middle" width=2%>&nbsp;</td>
												<td height=22 valign="middle" width=13%>Military Skill:</td>
												<td height=22 valign="middle" width=85% class=itemfont><input class="itemfont" style="WIDTH: 340px" maxLength="300" id="MSDescription" name="MSDescription" ></td>
											</tr>
											<tr class=columnheading>
												<td height=22 valign="middle" width="2%">&nbsp;</td>
												<td height=22 valign="middle" width="13%">Validity Period:</td>
												<td height=22 valign="middle" width="85%" class=itemfont>
													<Select  class="itemfont" Name="VPID" id="VPID" style="width:80px;">
                                                    	<option value="0">...Select</option>
														<% do while not rsValidityPeriodList.eof %>
															<option value=<%= rsValidityPeriodList("vpID") %>><%= rsValidityPeriodList("description") %></option>
															<% rsValidityPeriodList.movenext %>
														<% loop %>
													</Select>
												</td>
											</tr>
                                            <tr class="columnheading">
												<td height=22 align="left" width="2%">&nbsp;</td>
                                            	<td height=22 align="left" width="13%">Amber Period</td>
                                                <td height=22 align="left" width="85%"><input class="itemfont" style="width:30px" name="txtAmberDays" id="txtAmberDays"  type="text" value="0"/></td>
                                            </tr>
											<tr class=columnheading>
												<td height=22 valign="middle" width=2%>&nbsp;</td>
												<td height=22 valign="middle" width=13%>Exempt:</td>
												<td height=22 valign="middle" width=85% class=itemfont><input type="checkbox" name="chkExempt" id="chkExempt" value="1"></td>
											</tr>					  
											<tr class=columnheading>
												<td height=22 valign="middle" width=2%>&nbsp;</td>
												<td height=22 valign="middle" width=13%>Combat Ready:</td>
												<td height=22 valign="middle" width=85% class=itemfont><input type="checkbox" name="chkCombat" id="chkCombat" value="1"></td>
											</tr>					  
											<tr class=columnheading height=22>
												<td height=22 valign="middle" width=2%>&nbsp;</td>
												<td height=22 valign="middle" width=13%>FEAR:</td>
												<td height=22 valign="middle" width=85% class=itemfont><input type="checkbox" name="chkFear" id="chkFear" value="1"></td>
											</tr>					  
											<tr>
												<td colspan=3 height=22>&nbsp;</td>
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

<script language="javascript">

function checkThis()
{
	//This function renoves any leading or trailing spaces from a string
	String.prototype.killWhiteSpace = function()
	{
		return this.replace(/\s/g, '');
	};

	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;
	  
	var d = document.frmDetails.MSDescription.value;
	d = d.killWhiteSpace();
	var vp = document.frmDetails.VPID.value;
	var a = document.frmDetails.txtAmberDays.value;
	var re = /[a-z,A-Z\^,£<>$":;{}\[\]\*\.+\-_=~#@?\\\/%\'!¬`¦&]/g;

	/* make sure they have entered comments for the next stage */
	if(d == "")
	{
		errMsg += "Military Skill\n"
		error = true;
	}
	
	if(vp == 0)
	{
		errMsg += "Validity Period\n"
		error = true;
	}
	
	if(a == "")
	{
		errMsg += "Amber Period"
		error = true;
	}
	
	if(re.test(a))
	{
		errMsg += "Amber Period - Numeric characters only\n"
		error = true;
	}

	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 
	
    document.frmDetails.submit();  
}

</script>
