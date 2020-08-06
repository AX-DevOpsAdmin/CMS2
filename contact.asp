<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"--> 

<% 
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
	%>
		<script language="JScript">
			var myHeight = document.documentElement.clientHeight - 138;
			window.location = "contact.asp?myHeight1="+myHeight;
		</script>
	<%
else
   'session.timeout = 60
   session("heightIs") = request("myHeight1")
end if

'' sets date to UK format - dmy
session.lcid=2057

strLogPage = "index"

	dim rsContact
	dim cmdContactList
	dim intContactID
	dim strEmail
	dim strEmailName
	dim strRankDesc
	dim strSurname
	dim strFirstname
	dim strMilPhone
	dim strExt

	set rsContact = server.createObject("ADODB.RecordSet")
	set cmdContactList = server.createobject("ADODB.Command")
	cmdContactList.activeconnection = con
	cmdContactList.activeconnection.cursorlocation = 3
	cmdContactList.commandtext = "spContactList"
	cmdContactList.commandtype = 4
	
	set objPara = cmdContactList.CreateParameter ("nodeID",3,1,5, nodeID)
    cmdContactList.Parameters.Append objPara

	set rsContact = cmdContactList.execute
	
	if not rsContact.eof then
		strEmail = rsContact.fields("Email")
		if rsContact.fields("EmailName") <> "" then
			strEmailName = rsContact.fields("EmailName")
		else
			strEmailName = strEmail
		end if
		strMilPhone = rsContact.fields("MilPhone")
		strExt = rsContact.fields("Ext")
	end if
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>CMS</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>
<body>
<form  action="" method="POST" name="frmDetails">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
			  <!--#include file="Includes/Header.inc"--> 
              <!--
  				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
    				<tr  style="font-size:10pt;" height=26px>
      					<td width=10px>&nbsp;</td>
						<td><%' if session("SignInFlag") = 1 then %><A title="" href="index.asp" class=itemfontlinksmall >Home</A> > <%' else %><A title="" href="logon.asp" class=itemfontlinksmall >Sign In</A> > <% 'end if %><font class="youAreHere" >Contact</font></td>
    				</tr>
   
  					<tr>
       					<td colspan=2 class=titlearealine  height=1></td> 
     				</tr>
  				</table>
                -->
                <table width="200px" border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
                                <tr height=30>
                                    <td ></td>
                                    <td valign=top></td>
                                    <td align=Left></td>
                                    <td class=rightmenuspace align=Left ></td>
                                </tr>
                                
                               
                            </table>
  				<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      				<tr valign=Top>
                        <td class="sidemenuwidth" background="Images/tableback.png"><!--include file="Includes/datamenu.inc"--></td>
						<td width=16></td>
				       	<td align=left > 
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr class=SectionHeader>
									<td colspan=2 height=16 class=toolbar>&nbsp;Contact Details</td>
								</tr>
							</table>
							<!--<div style="position:relative;float:right;height:541px;width:400px;background-image:url(images/cmsbacklogo.png);"></div>-->
							<table border=0 cellpadding=0 cellspacing=0 width=50%>
								<tr>
									<td colspan=2 height=20px class=toolbar></td>
								</tr>
								<tr class=columnheading>
								  	<td width=80px height="20px">Email:</td>
                  					<td class=itemfont height="20px"><A class=itemfontlink href ="mailto:<%=strEmail%>"><%=strEmailName%></A></td>
								</tr>
								<tr class=columnheading>
									<td width=80px height="20px">Telephone:</td>
									<td class=itemfont height="20px"><%=strMilPhone & " x" &  strExt%></A></td>
								</tr>
							</table>
						</td>
      				</tr>
    			</table>
			</td>
		</tr>
	</table>
</div>
</form>

</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
function OverBackgroundChange(itemID){
    itemID.className='testTabHover';
}

function OutBackgroundChange(itemID){
    itemID.className='testTabUnselected';
}
</Script>
