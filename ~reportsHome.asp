<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 

<% 
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
%>
	<script language="JScript">
		var myHeight = document.documentElement.clientHeight - 138;
		window.location = "reportsHome.asp?myHeight1="+myHeight;
	</script>
<%
else
   'session.timeout = 60
   session("heightIs") = request("myHeight1") 
end if 

location="Reports"
subLocation="1"
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>

<style type="text/css">
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
</style>	

</head>
<body>
	
	
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>    		
			<td> 
				<!--#include file="Includes/Header.inc"-->
                <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10px>&nbsp;</td>
                        <td><a title="" href="index.asp" class=itemfontlinksmall>Home</a> > <font class="youAreHere">Reports</font></td>
                    </tr>
                    <tr>
                        <td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
				</table>
                
                           
                <table width=100% height='900px' border=0 cellpadding=0 cellspacing=0 > 
                    <tr valign=Top>
                        <td class="sidemenuwidth" style="width:190px;" background="Images/tableback.png">
							<!--#include file="Includes/reportsSideMenu.inc"-->
                        </td>
                        <td width=16></td>
                        <td align=left > 
                            <table border=0 cellpadding=0 cellspacing=0 width=100% height=100% >
                                <tr height=16 class=SectionHeader>
                                    <td colspan=6 class=toolbar></td>
                                </tr>
                                <tr height=20 >
                                                              
                                <div class="indexwrapper">     
    						    
    						    <% if session("Man") <> 0 then %>
								 <div></div>
								<% if location = "Reports" and subLocation="2" then %>				
								<% else %>
				      			<div class="indextiles">
        						<img src="cms_icons/png/64x64/user.png">
                        		<div class="tilesheader"><a title="Manning reports" href="reportsManningMultiple.asp">Manning</a></br><p></p>
                        		</div></div>
								<% end if %> 
								<div></div>
								<% end if %>
								
								<% if session("Per") <> 0 then %>
		    					<div></div>
								<% if location = "Reports" and subLocation="5" then %>				
								<% else %>  
				       			<div class="indextiles">
        							<img src="cms_icons/png/64x64/chart.png">
                        		<div class="tilesheader"><a title="Personnel harmony" href="reportsHarmonyStatus.asp">Personnel Harmony</a></br><p></p>
                        		</div></div>
								<% end if %><div></div><% end if %>			
								
								<% if session("Uni") <> 0 then %>
		    <div></div>
			<% if location = "Reports" and subLocation="6" then %>				
			<% else %>  
				        <div class="indextiles">
        							<img src="cms_icons/png/64x64/chart_pie.png">
                        <div class="tilesheader"><a title="Unit harmony" href="reportsUnitHarmonyStatus.asp">Unit Harmony</a></br><p></p>
                        </div></div>
			<% end if %> 
			<div></div>
			<% end if %> 
     
            <!--
            <%' if session("Cap") <> 0 then %>
		    <div></div>
			<%' if location = "Reports" and subLocation="3" then %>				
			<%' else %>  
				        <div class="indextiles">
        							<img src="cms_icons/png/64x64/puzzle.png">
                        <div class="tilesheader"><a title="Capability" href="reportsCapability.asp">Capability</a></br><p></p>
                        </div></div>
			<%' end if %> 
			<div></div>
			<%' end if %> 
			
			<%' if session("Pre") <> 0 then %>
		    <div></div>
			<%' if location = "Reports" and subLocation="4" then %>				
			<%' else %>  
				        <div class="indextiles">
        							<img src="cms_icons/png/64x64/id_card.png">
                        <div class="tilesheader"><a title="Present / Absent" href="reportsPersonnelPresentOrAbsent.asp">Present / Absent</a></br><p></p>
                        </div></div>
			<%' end if %> 
			<div></div>
			<%' end if %> 
			-->

			<% if session("Fit") <> 0 then %>
		    <div></div>
			<% if location = "Reports" and subLocation="7" then %>				
			<% else %>  
				        <div class="indextiles">
        							<img src="cms_icons/png/64x64/heart.png">
                        <div class="tilesheader"><a title="Fitness reports" href="reportsFitnessStatus.asp">Fitness</a></br><p></p>
                        </div></div>
			<% end if %> 
			<div></div>
			<% end if %> 
			
            <!--
			<%' if session("Sch") <> 0 then %>
		    <div></div>
			<%' if location = "Reports" and subLocation="9" then %>				
			<%' else %>  
				        <div class="indextiles">
        							<img src="cms_icons/png/64x64/clock.png">
                        <div class="tilesheader"><a title="Management board" href="reportsTaskingSchedule.asp">Tasking Schedule</a></br><p></p>
                        </div></div>
			<%' end if %> 
			<div></div>
			<%' end if %> 
			
			<%' if session("Nom") <> 0 and session("Administrator") = 1 then %>
		    <div></div>
			<%' if location = "Reports" and subLocation="10" then %>				
			<%' else %>  
				        <div class="indextiles">
        							<img src="cms_icons/png/64x64/users.png">
                        <div class="tilesheader"><a title="Nominal Role" href="reportsNominalRole.asp">Nominal Role</a></br><p></p>
                        </div></div>
			<%' end if %> 
			<div></div>
			<%' end if %> 
			-->
		    <% if session("Ran") <> 0 then %>		   
		    <div></div>
			<% if location = "Reports" and subLocation="11" then %>				
			<% else %>  
				        <div class="indextiles">
        							<img src="cms_icons/png/64x64/users.png">
                        <div class="tilesheader"><a title="Personnel by Rank" href="reportsPersonnelbyRank.asp">Personnel by Rank</a></br><p></p>
                        </div></div>
			<% end if %> 
			<div></div>
			<% end if %> 
			
            <!--
			<%' if session("Pos") <> 0 then %>		   
		    <div></div>
			<%' if location = "Reports" and subLocation="14" then %>				
			<%' else %>  
				        <div class="indextiles">
        							<img src="cms_icons/png/64x64/search.png">
                        <div class="tilesheader"><a title="Personnel by Post" href="reportsPersonnelbyPost.asp">Personnel by Post</a></br><p></p>
                        </div></div>
			<%' end if %> 
			<div></div>
			<%' end if %> 
			-->
			<% if session("Aut") <> 0 then %>		   
		    <div></div>
			<% if location = "Reports" and subLocation="12" then %>				
			<% else %>  
				        <div class="indextiles">
        							<img src="cms_icons/png/64x64/computer_mouse.png">
                        <div class="tilesheader"><a title="CIS Auth" href="reportsCISAuth.asp">Unit Q Authorised</a></br><p></p>
                        </div></div>
			<% end if %> 
			<div></div>
			<% end if %> 
			
			<% if session("Ind") <> 0 then %>		   
		    <div></div>
			<% if location = "Reports" and subLocation="13" then %>				
			<% else %>  
				        <div class="indextiles">
        							<img src="cms_icons/png/64x64/smart_phone.png">
                        <div class="tilesheader"><a title="CIS Individual Auth" href="reportsCISIndividualAuth.asp">Individual Q Authorised</a></br><p></p>
                        </div></div>
			<% end if %> 
			<div></div>
			<% end if %> 
			
			<% if session("Rod") <> 0 then %>		   
		    <div></div>
			<% if location = "Reports" and subLocation="15" then %>				
			<% else %>  
				        <div class="indextiles">
        							<img src="cms_icons/png/64x64/calendar.png">
                        <div class="tilesheader"><a title="Run Out Date" href="reportsRunOutDate.asp">Q Expiry Date</a></br><p></p>
                        </div></div>
			<% end if %> 
			<div></div>
			<% end if %> 
			
			<% if session("Paq") <> 0 then %>		   
		    <div></div>
			<% if location = "Reports" and subLocation="15" then %>				
			<% else %>  
				        <div class="indextiles">
        							<img src="cms_icons/png/64x64/network.png">
                        <div class="tilesheader"><a title="Personnel & Qs" href="reportsPersAndQs.asp">Personnel & Qs</a></br><p></p>
                        </div></div>
			<% end if %> 
			<div></div>
			<% end if %> 
		
		    <% if session("Boa") <> 0 then %>
		    <div></div>
			<% if location = "Reports" and subLocation="8" then %>				
			<% else %>  
				        <div class="indextiles">
        							<img src="cms_icons/png/64x64/database.png">
                        <div class="tilesheader"><a title="Management board" href="reportsMonthlyStats.asp">Management Board</a></br><p></p>
                        </div></div>
			<% end if %> 
			<div></div>
			<% end if %> 
			

			<% if location = "Reports" and subLocation="17" then %>
			<div></div>
			<% else %>  
			<div class="indextiles">
        	<img src="cms_icons/png/64x64/up_arrow.png">
            <div class="tilesheader"><a title="Working At Heights" href="reportsWorkingAtHeight.asp">Working At Heights</a></br><p></p>
            </div></div>
			<% end if %> 
			<td align="left"></td>
			
			</div>
			 </tr>
                            </table>
                        </td>
                    </tr>
                </table>
			</td>
		</tr>
    </table>
    
    
     
			
            






     
                        
         
    
    

</BODY>
</HTML>