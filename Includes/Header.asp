<div class="logoHeader">
<div class="logo">
<img src="Images/logo.jpg" width="188" height="71">
</div>
</div>
 
<div id="topmenu">
    	<ul class="select"> 
			<% if session("SignInFlag") = 1 then %>
				<li><a href="index.asp">Home</a></li>
				<li><a href="cms_hierarchy2.asp?teamID=<%=session("teamID")%>">Personnel</a></li>
				<% if session("UserStatus") = "1" or session("Administrator")=1 then %>
				<li><a href="ManningTaskSearch.asp">Tasking</a></li>
				<% end if %>							
				<li><a href="cms_hierarchy.asp?persSearch=1">Search</a></li>
				<li><a href="reportsHome.asp">Reports</a></li>
				<% end if %>	
                
				<li><a href="contact.asp">Contact</a></li>
                <li><a href='javascript:userguide()' title='Help'>Help</a></li>
               
				<!-- <li class="lrt1"><a id="ix" href="javascript:ixTeamInfo()" onmouseover="ixTeamInfo()" onmouseout="ixTeamInfo()">Design by IXT</a></li> -->
				<% if session("SignInFlag") = 1 then %>
				<li class="lrt3"><a href="logon.asp">Sign Out</a></li>
				<li class="lrt2">Current User: <b> <%=session("serviceNo")%> </b></li>
				<% end if %>	
		 </ul>
    </div>
   