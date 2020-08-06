<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
strTable = "tblFlight"
strGoTo = "AdminFlightList.asp"   ' asp page to return to once record is deleted
strTabID = "fltID"              ' key field name for table        

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = "spFlightDetail"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure
set objPara = objCmd.CreateParameter ("FlightID",3,1,5, request("FlightID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' now see if we can delete it - if it has no children then we can
' return parameter for Delete check
objCmd.CommandText = "spFlightDel"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter("@DelOK",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	

strDelOK = objCmd.Parameters("@DelOK")
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
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"-->
		<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Flight Details</strong></font></td>
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
					  <td class=toolbar width=8></td><td width=20><a class=itemfontlink href="AdminFlightAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
					    <td class=toolbar valign="middle" >New Flight</td>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
                        <td width=20><a class=itemfontlink href="AdminFlightEdit.asp?FlightID=<%=request("FlightID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td class=toolbar valign="middle" >Edit Flight</td>
						<% IF strDelOK = "0" THEN %>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
                        <td width=20><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("flightid")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
						<td class=toolbar valign="middle" >Delete Flight</td>
                        <% END IF %>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class=itemfontlink href="AdminFlightList.asp">Back To List</A></td>											
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
						<td valign="middle" width=85% class=itemfont><%=rsRecSet("Description")%></td>
					  </tr>
					  <tr class=columnheading height=30>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width=13%>Squadron:</td>
						<td valign="middle" width=85% class=itemfont ><%=rsRecSet("sqn")%></td>
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
