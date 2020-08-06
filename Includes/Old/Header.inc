	<!-- #include file="inc_about.asp" -->
		
    <div style="height:80px; background:#EFEFEF;"><div class="logo">  <img src="Images/logo.jpg" width="188" height="71"></div></div>
    <div id="topmenu">
    	<ul class="select"> 
			<% if session("SignInFlag") = 1 then %>
				<li><a href="index.asp">Home</a></li>
				<li><a href="cms_hierarchy.asp">Personnel</a></li>
				<% if session("UserStatus") = "1" or session("Administrator")=1 then %>
				<li><a href="ManningTaskSearch.asp">Tasking</a></li>
				<% end if %>							
				<li><a href="cms_hierarchy.asp?persSearch=1">Search</a></li>
				<li><a href="reportsHome.asp">Reports</a></li>
				<% end if %>	
				<li><a href="contact.asp">Contact</a></li>
               
				<!-- <li class="lrt1"><a id="ix" href="javascript:ixTeamInfo()" onmouseover="ixTeamInfo()" onmouseout="ixTeamInfo()">Design by IXT</a></li> -->
				<% if session("SignInFlag") = 1 then %>
				<li class="lrt3"><a href="logon.asp">Sign Out</a></li>
				<li class="lrt2">Current User: <b> <%=session("serviceNo")%> </b></li>
				<% end if %>	
		 </ul>
    </div>
    
	<!--  For the IXT Mouse over info -->		
	<div id="ixteam" class="hideTab" onMouseOver="ixTeamInfo()" onMouseOut="ixTeamInfo()"><%=contact%></div>

	<script type="text/javascript">		
		//This is for the IXT hover tab which shows details contained in inc_about.asp located in the top level of polestar iis folder.
		function ixTeamInfo()
		{
			if(document.getElementById('ixteam').className == "hideTab")
			{
				document.getElementById('ixteam').className = "showTab";
			}
			else
			{
				document.getElementById('ixteam').className = "hideTab";
			}
		}		
	</script>
  