<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/authsecurity.inc"-->

<%
'
''If user is not valid Authorisation Administrator then log them off
'If session("authadmin") <> 1 then
'	Response.redirect("noaccess.asp")
'End If

dim strAction
strAction="Add"
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->



<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>
<body>
<form action="UpdateAuthType.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
  <input type="hidden" name="atpID" id="atpID" value="<%= request("atpID") %>">  
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
                <!--#include file="Includes/Header.inc"-->
  					<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>New Authorisation Type</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
            <!--<table width=100% height='<%'=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> -->
            <table style="height:900px;" width=100% height="328" border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/authmenu.inc"--></td>
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
											<td class=toolbar valign="middle"><a class= itemfontlink href="AdminAuthTypeList.asp">Back To List</a></td>
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
												<td valign="middle" width=13%>Authorisation Type:</td>
												<td valign="middle" width=85%><input class="itemfont" style="width: 360px" maxLength=300 name="txtDescription" id="txtDescription" value="<%if request("err") = "True" then%><%= request("description") %><%end if%>"><% if request("err") = "True" then %>&nbsp;<span class="style2">Already exists</span><% end if %></td>
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
	  
	var atp = document.frmDetails.txtDescription.value;
	atp = atp.killWhiteSpace(); 

	/* make sure they have entered comments for the next stage */
	if(atp == "")
	{
		errMsg += "Authorisation Type"
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
