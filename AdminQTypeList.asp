<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
	dim strPage
	strPage="QType"
	strTable = "tblQTypes"
	strCommand = "spListTable"
	
	set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	
	objCmd.CommandText = strCommand
	objCmd.CommandType = 4		
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
	objCmd.Parameters.Append objPara

	set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
	objCmd.Parameters.Append objPara
	set rsQTypeList = objCmd.Execute	''Execute CommandText when using "ADODB.Command" object
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
	<input name="QTypeID" id="QTypeID" type="hidden">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
		<tr>
			<td>
				<!--#include file="Includes/Header.inc"--> 
  					<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Qualification Types</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
						<td width=16></td>
						<td align=left>
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr height=16 class=SectionHeader>
									<td>
										<table border=0 cellpadding=0 cellspacing=0>
											<tr>
												<td class=toolbar width=8></td>
												<td width=20><a class=itemfontlink href="AdminQTypeAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
												<td class=toolbar valign="middle">New Qualification Type</td>
											</tr>  
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<table width=100% border=0 cellpadding=0 cellspacing=0>
											<tr class=columnheading height=30>
												<td valign="middle" width=2%></td>
												<td valign="middle" width=28%>Qualification Type</td>
                                                <td align="center" width=15%>Authorisation Req'd</td>
                                                <td valign="middle" width=55%>&nbsp;</td>
											</tr>
											<tr>
       											<td colspan=4 class=titlearealine  height=1></td> 
     										</tr>
											<% do while not rsQTypeList.eof %>
												<tr class=itemfont ID="TableRow<%= rsQTypeList("QTypeID") %>" height=30>
													<td valign="middle"></td>
													<td valign="middle"><a class=itemfontlink href="javascript: subForm(<%= rsQTypeList("QTypeID") %>)"><%= rsQTypeList("Description") %></a></td> 
                                                    <td align="center"><% if rsQTypeList("Auth") = true then %><img src="Images/yes.gif" width="10" height="10" alt="Yes"><% else %><img src="Images/no.gif" width="10" height="10" alt="No"><% end if %></td>
                                                    <td valign="middle">&nbsp;</td>
												</tr>
  												<tr>
       												<td colspan=4 class=titlearealine  height=1></td> 
     											</tr>
												<% rsQTypeList.movenext %>
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
	rsQTypeList.close
	set rsQTypeList = Nothing
	con.close
	set con = Nothing
%>

</body>
</html>

<script language="javascript">

function subForm(recID)
{
     document.forms.frmDetails.action = "AdminQTypeDetail.asp";
	 document.forms.frmDetails.QTypeID.value = recID;
	 document.forms.frmDetails.submit(); 
}

</Script>
