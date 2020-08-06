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

	dim strPage
	strPage="AuthType"
	strTable = "tblAuthsType"
	strCommand = "spListTable"
	
	set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	
	objCmd.CommandText = strCommand
	objCmd.CommandType = 4		
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 0)
	objCmd.Parameters.Append objPara

	set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
	objCmd.Parameters.Append objPara
	set rsAuthTypes = objCmd.Execute	''Execute CommandText when using "ADODB.Command" object
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
	<input name="atpID" id="atpID" type="hidden">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
		<tr>
			<td>
				<!--#include file="Includes/Header.inc"--> 
  					<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Authorisation Types</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
            <!--<table width=100% height='<%'=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> -->
            <table style="height:900px;" width=100% height="328" border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/authmenu.inc"--></td>
						<td width=16></td>
						<td align=left>
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr height=16 class=SectionHeader>
									<td>
										<table border=0 cellpadding=0 cellspacing=0>
											<tr>
												<td class=toolbar width=8></td>
												<td width=20><a class=itemfontlink href="AdminAuthTypeAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
												<td class=toolbar valign="middle">New Authorisation Type</td>
											</tr>  
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<table width=100% border=0 cellpadding=0 cellspacing=0>
											<tr class=columnheading height=30>
												<td valign="middle" width=2%></td>
												<td valign="middle" width=28%>Authorisation Type</td>
                                                <td valign="middle" width=55%>&nbsp;</td>
											</tr>
											<tr>
       											<td colspan=4 class=titlearealine  height=1></td> 
     										</tr>
											<% do while not rsAuthTypes.eof %>
												<tr class=itemfont ID="TableRow<%= rsAuthTypes("atpID") %>" height=30>
													<td valign="middle"></td>
													<td valign="middle"><a class=itemfontlink href="javascript: subForm(<%= rsAuthTypes("atpID") %>)"><%= rsAuthTypes("authType") %></a></td> 
                                                    <td valign="middle">&nbsp;</td>
												</tr>
  												<tr>
       												<td colspan=4 class=titlearealine  height=1></td> 
     											</tr>
												<% rsAuthTypes.movenext %>
											<% loop %>
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
	rsAuthTypes.close
	set rsAuthTypes = Nothing
	con.close
	set con = Nothing
%>

</body>
</html>

<script language="javascript">

function subForm(recID)
{
     document.forms.frmDetails.action = "AdminAuthTypeDetail.asp";
	 document.forms.frmDetails.atpID.value = recID;
	 document.forms.frmDetails.submit(); 
}

</Script>
