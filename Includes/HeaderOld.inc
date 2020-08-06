	<!-- #include file="inc_about.asp" -->
		
	<table width="100%" height="80px" border="0" cellpadding="0" cellspacing="0" bgcolor="#4F7DD2">
		<tr>
			<td width="510" align="left"><img src="Images/CmsBegin.png" /></td>
            <td align="center"><img src="Images/CmsMiddle.png" /></td>
			<td width="510" align="right"><div id="banner"><img class="crest" src="images/90SU-Crest.png"/></div></td>
		</tr>
	</table>

    <table width=100% cellpadding="0" cellspacing="0" border=0>		
        <tr height="28px">
            <td>
                <table width=100% border=0  cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="60%">
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
									<li class="lrt1"><a id="ix" href="javascript:ixTeamInfo()" onMouseOver="ixTeamInfo()" onMouseOut="ixTeamInfo()">Design by IXT</a></li>
									<% if session("SignInFlag") = 1 then %>
										<li class="lrt3"><a href="logon.asp">Sign Out</a></li>
										<li class="lrt2">Current User: <b><font style="color:#000000;background-color:#999999;"> <%=session("serviceNo")%> </font></b></li>
									<% end if %>	
								</ul>
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
    
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
  