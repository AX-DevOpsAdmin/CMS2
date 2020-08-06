<div class="logoHeader">
<div class="logo">
<img src="Images/logo.jpg" width="188" height="71">
</div>
</div>
   
<div id="topmenu">
    	<ul class="select"> 
			<% if session("SignInFlag") = 1 then %>
				<li><a href="index.asp">Home</a></li>
				<li><a href="cms_hierarchy3.asp?hrcID=<%=session("hrcID")%>">Personnel</a></li>
				<% if session("UserStatus") = "1" or session("Administrator")=1 then %>
					<!--<li><a href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=">Tasking</a></li>-->
					<li><a href="ManningTaskSearch.asp?dosearch=0">Tasking</a></li>
				<% end if %>
				
				<% if session("authorisor") > 0  then %>
			       <li> 
				       <div id="notification" style="display:none; float:left;">
 			              <a style="float:left;" href="HierarchyAuthorisations.asp?startDate=<%=startDate%>">Authorisations </a> 
						
							<!--<div id="notifIcon" style="background: url(images/Notifications.gif); width:22px; height:22px; margin-top:3px; float:left; cursor:pointer;"></div>-->
							<div id="bounceCont" style="float:left; height:15px;width:15px; margin-top:-10px; left:-4px; position:relative;">
								<div id="notifCount" style=" background:#FFF; border:1px solid #F00; font-size:7pt; font-weight:bold; color:#000; height:13px;width:15px; padding:1px; line-height:10px;cursor:pointer;" align="center" >0</div>
							</div>
						</div>
		           </li>
				<% end if %>
								
				<li><a href="cms_hierarchy3.asp?persSearch=1">Search</a></li>
				<li><a href="reportsHome.asp">Reports</a></li>
				<% end if %>	
				
				<li><a href="contact.asp">Contact</a></li>
				<li><a href='javascript:userguide()'>Help</a></li>
               
				<!-- <li class="lrt1"><a id="ix" href="javascript:ixTeamInfo()" onmouseover="ixTeamInfo()" onmouseout="ixTeamInfo()">Design by IXT</a></li> -->
				<% if session("SignInFlag") = 1 then %>
					<li class="lrt3"><a href="logon.asp">Sign Out</a></li>
					<% if conCount > 0 then %>
						<li class="lrt2">
							<div id="confirmation" style="display:none; float:left;">
								<div id="bounceCont" style="float:right; height:15px;width:15px; margin-top:-10px; left:-36px; position:relative;">
									<div id="confirmCount" style=" background:#FFF; border:1px solid #F00; font-size:7pt; font-weight:bold; color:#000; height:13px;width:15px; padding:1px; line-height:10px;cursor:pointer;" align="center" >0</div>
								</div>
								Current User: <b><a style="float:right;" href="HierarchyPersAuthorise.asp?staffID=<%=session("StaffID")%>&thisdate=<%=startDate%>&authflag=2" target="teamIframe"><%=session("serviceNo")%></a></b>
							</div>
						</li>
					<% else %>
						<li class="lrt2">Current User: <b> <%=session("serviceNo")%> </b></li>
					<% end if %>
			<% end if %>	
		</ul>
    </div>

<div id="warning" style="display:none;" align="center"></div>

<script type="text/javascript"> 	
function userguide(){
 window.open("Documents/CMSUserGuide.pdf#page=5")	
}

function sysadminguide(){

alert("System Guide");
 window.open("Documents/CMSAdminGuide.pdf")	
}

</script>
   