<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 

<html>
<head>
<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
body {
	overflow:hidden;
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #0000FF}
-->
</style>
</head>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<style type="text/css">
<!--
body {
	overflow:hidden;
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #0000FF}
-->
</style>

</head>
<body>
<form action="" method="POST" name="frmDetails">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>    		
			<td> 
				<!--#include file="Includes/Header.inc"-->
              <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10px>&nbsp;</td>
                        <td class="style1"><font class="youAreHere">Home </font></td>
                    </tr>
                    <tr>
                        <td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
				</table>
                                      
                <table style="height:900px;" width=100%  border=0 cellpadding=0 cellspacing=0>
      				<tr valign=Top>
						<td align="left" class="sidemenuwidth"  background="Images/tableback.png"><!--#include file="Includes/homemenu.inc"--></td>
						<td width=16></td>
						<td align=left>
                    <!--  
                    </tr>
                    <tr valign=Top>
                        <td class="sidemenuwidth" ></td>
                        <td width=16></td>
                        
                        <td align=left ><p>&nbsp;</p>  
                        -->
                            <table>
                                <div class="indexwrapper">
                                                     
                                <div class="indextiles">
                                            <img src="cms_icons/png/64x64/users.png">
                                <div class="tilesheader"><a title="Personnel hierarchy view" href="cms_hierarchy.asp">Personnel Hierarchy</a></br><p></p>
                                </div></div>
                                                     
                                <div class="indextiles">
                                            <img src="cms_icons/png/64x64/search.png">
                                <div class="tilesheader"><a title="Search personnel." href="cms_hierarchy.asp?persSearch=1">Search</a><p></p>
                                </div></div>
                                
                                <div class="indextiles">
                                            <img src="cms_icons/png/64x64/chart.png">
                                <div class="tilesheader"><a title="Run reports on personnel including fitness, harmony, Q status and more." href="reportsHome.asp">Reports</a><p></p>
                                </div></div>
                                
                                                                                  
                                <% IF session("UserStatus") = "1" or session("administrator") = "1" THEN %>
                                     <div class="indextiles">
                                            <img src="cms_icons/png/64x64/calendar_date.png">
                                <div class="tilesheader"><a title="Search and view tasks." href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=">Tasking</a><p></p>
                                </div></div>
                                <%end if%> 
                                                             
                                <% IF session("administrator") = "1" THEN %>
                                     <div class="indextiles">
                                            <img src="cms_icons/png/64x64/process.png">
                                <div class="tilesheader"><a title="Administrator menu." href="AdminDataMenu.asp">Admin Menu</a><p></p>
                                </div></div>
                                <%end if%> 
                                
                                </div>
                                </div>
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
function OverBackgroundChange(itemID){
    itemID.className='testTabHover';
}

function OutBackgroundChange(itemID){
    itemID.className='testTabUnselected';
}
</Script>
