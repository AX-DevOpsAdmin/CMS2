<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<%
' so the menu include - QMenu.inc knows what page we're on
dim strPage
strPage="Hmny"
%>

<html>

<head> 

<!--#include file="Includes/IECompatability.inc"-->
<title>Personnel Data</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
<!--
body {
	background-image: url();
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}

.style1 {color: #0000FF}
-->
</style></head>
<body>
<!--#include file="Includes/Header.inc"--> 
<SCRIPT LANGUAGE="JavaScript">
var obj = new Object;
var obj2 = new Object;
var obj = new Object;
var win = null;
homeString ='javascript:refreshIframeAfterDateSelect("ManningTeamPersonnel.asp");'
window.crumbTrail.innerHTML="<A href='index.asp' class=itemfontlinksmall >Home</A> > <A href='reportsHome.asp' class=itemfontlinksmall >Reports</A> > <font class='youAreHere' >Harmony Reports</font>"

function hideObject(obj) {
//var el = document.getElementById(obj);
//obj.style.backgroundColor="#ff0000";
obj.style.display = 'none';

}

function switchObject(obj,obj2,obj3,whichBox) {

	if (obj.style.display !='none'){
		obj.style.display = 'none';
		obj2.src="images/plus.gif";
		obj2.disabled=1
		obj3.value=0;
		deselectBox (whichBox);
		
	}else{
		//closeCurrentObject(currentlyOpen,currentIcon,currentStatus);
		obj.style.display = '';
		obj2.src="images/minus.gif";
		obj3.value=1;
		//alert(obj);
		var currentlyOpen = obj;
		var currentIcon = obj2;
		var currentStatus = obj3;
	}
	
}

</Script>

<form  action="" method="POST" name="frmDetails">
      	  <tr valign=Top>
            <!--#include file="Includes/HarmonyMenu.inc"-->
			<td width=16></td>
		    <td align=left >
			  <table border=0 cellpadding=0 cellspacing=0 width=60%>
				<tr height=16 class=SectionHeader>
				  <td>
				    <table border=0 cellpadding=0 cellspacing=0 width=80%>
					  <tr height=16 class=SectionHeader>
					    <!-- <td width="12%" class=toolbar>Personnel Tasks</td> -->
						<td width="12%" class=toolbar>Harmony reports </td>
					  </tr>
				    </table>
					 <table border=0 cellpadding=0 cellspacing=0 width=85% class=MenuStyleParent>
					  <tr height=16 class="">
					    <td width="5%" class=toolbar>&nbsp;</td>
					    <td width="23%" class=toolbar>&nbsp;</td>
					    <td width="30%" class=toolbar>&nbsp;</td>
					    <td width="42%" class=toolbar>&nbsp;</td>
					  </tr>
					  <tr height=16>
					    <td class=toolbar>&nbsp;</td>
				        <td class=toolbar><A title="" href="reportsHarmonyStatus.asp">Personnel Harmony Status</a></td>
					    <td class=toolbar><A title="" href="reportsUnitHarmonyStatus.asp">Unit Harmony Status</a></td>
					    <td class=toolbar>&nbsp;</td>
					  </tr>

					 </table>				  </td>
				</tr>
				<tr>
				  <td>				  </td>
				</tr>
			  </table>			</td>
      	 </tr>
       </table>
	 </td>
	</tr>
  </table>
</form>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">

</Script>
