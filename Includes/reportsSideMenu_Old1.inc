<div class="leftnav">

<table border="0" cellspacing="0" cellpadding="0"class="MenuStyleParent" style="width:190px;">
	<tr height="30">
		<td></td>
		<td width="" valign="top"></td>
		<td width="170" height=18 align="left"><A title="" href="index.asp">Home</A></td>
		<td width="50" align="left"></td>
	</tr>
	<tr height="30">
		<td></td>
		<td valign="top"></td>
		<% if location = "Reports" and subLocation = "1" then %>
			<td align="left" class="selected">Reports</td>
		<% else %>  
			<td align="left"><A title="" href="reportsHome.asp">Reports</A></td>
		<% end if %>
		<td align="left"></td>
	</tr>
	<% if session("Man") <> 0 then %>
		<tr height="30">
			<td></td>
			<td valign="top"></td>
			<% if location = "Reports" and subLocation="2" then %>
				<td align="left" class="selected">Manning</td>
			<% else %>  
				<td align="left"><A title="" href="reportsManningMultiple.asp">Manning</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Per") <> 0 then %>
		<tr height="30">
			<td></td>
			<td valign="top"></td>
			<% if location = "Reports" and subLocation="5" then %>
				<td align="left" class="selected">Personnel Harmony</td>
			<% else %>  
				<td align="left"><A title="" href="reportsHarmonyStatus.asp">Personnel Harmony</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Uni") <> 0 then %>
		<tr height="30">
			<td></td>
			<td valign="top"></td>
			<% if location = "Reports" and subLocation="6" then %>
				<td align="left" class="selected">Unit Harmony</td>
			<% else %>  
				<td align="left"><A title="" href="reportsUnitHarmonyStatus.asp">Unit Harmony</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>						
	<% end if %>
	
	<% if session("Fit") <> 0 then %>
		<tr height="30">
			<td></td>
			<td valign="top"></td>
			<% if location = "Reports" and subLocation="7" then %>
				<td align="left" class="selected">RAF Fitness</td>
			<% else %>  
				<td align="left"><A title="" href="reportsFitnessStatus.asp">RAF Fitness</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	
	<% if session("Ran") <> 0 then %>
		<tr height="30">
			<td></td>
			<td valign="top"></td>
			<% if location = "Reports" and subLocation="11" then %>
				<td align="left" class="selected">Personnel by Rank</td>
			<% else %>  
				<td align="left"><A title="" href="reportsPersonnelbyRank.asp">Personnel by Rank</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
		
	<%' if session("Aut") <> 0 or session("Ind") <> 0 then %>
	    <% if session("Aut") <> 0 then %>
			<tr height="30">
				<td></td>
				<td valign="top"></td>
				<% if location = "Reports" and subLocation="12" then %>
					<td align="left" class="selected">Unit Authorisations</td>
				<% else %>  
					<td align="left"><A title="" href="reportsCISAuth.asp">Unit Authorisations</A></td>
				<% end if %> 
				<td align="left"></td>
			</tr>
		<% end if %>
		<% if session("Ind") <> 0 then %>
			<tr height="30">
				<td></td>
				<td valign="top"></td>
				<% if location = "Reports" and subLocation="13" then %>
					<td align="left" class="selected">Auth 4820B </td>
				<% else %>  
					<td align="left"><A title="" href="reportsAuth4820B.asp">Auth 4820B </A></td>
				<% end if %> 
				<td align="left"></td>
			</tr>
		<% end if %>
    <%'end if %>
	<% if session("Rod") <> 0 then %>
		<tr height="30">
			<td></td>
			<td valign="top"></td>
			<% if location = "Reports" and subLocation="15" then %>
				<td align="left" class="selected">Q Expiry Date</td>
			<% else %>  
				<td align="left"><A title="" href="reportsRunOutDate.asp">Q Expiry Date</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Paq") <> 0 then %>
		<tr height="30">
			<td></td>
			<td valign="top"></td>
			<% if location = "Reports" and subLocation="16" then %>
				<td align="left" class="selected">Personnel & Qs</td>
			<% else %>  
				<td align="left"><A title="" href="reportsPersAndQs.asp">Personnel & Qs</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>

    <!-- Only 90SU for this one-->
    <% if session("nodeID") = 1 then %>
	    <% if session("Boa") <> 0 then %>
			<tr height="30">
				<td></td>
				<td valign="top"></td>
				<% if location = "Reports" and subLocation="8" then %>
					<td align="left" class="selected">Management Board</td>
				<% else %>  
					<td align="left"><A title="" href="reportsMonthlyStats.asp">Management Board</A></td>
				<% end if %> 
				<td align="left"></td>
			</tr>
	    <% end if %>

		<tr height="30">
			<td></td>
			<td valign="top"></td>
			<% if location = "Reports" and subLocation="17" then %>
				<td align="left" class="selected">Working At Height</td>
			<% else %>  
				<td align="left"><A title="" href="reportsWorkingAtHeight.asp">Working At Heights</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
    <% end if %>
	
		<!--
	<%' if session("Pre") <> 0 then %>
		<tr height="30">
			<td></td>
			<td valign="top"></td>
			<% if location = "Reports" and subLocation="4" then %>
				<td align="left" class="selected">Present/Absent</td>
			<% else %>  
				<td align="left"><A title="" href="reportsPersonnelPresentOrAbsent.asp">Present/Absent</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% 'end if %>

    <%' if session("Cap") <> 0 then %>
		<tr height="30">
			<td></td>
			<td valign="top"></td>
			<% if location = "Reports" and subLocation="3" then %>
				<td align="left" class="selected">Capability</td>
			<% else %>  
				<td align="left"><A title="" href="reportsCapability.asp">Capability</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% 'end if %>

	<%' if session("Sch") <> 0 then %>
		<tr height="30">
			<td></td>
			<td valign="top"></td>
			<% if location = "Reports" and subLocation="9" then %>
				<td align="left" class="selected">Tasking Schedule</td>
			<% else %>  
				<td align="left"><A title="" href="reportsTaskingSchedule.asp">Tasking Schedule</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% 'end if %>
    <%' if session("Pos") <> 0 then %>
		<tr height="30">
			<td></td>
			<td valign="top"></td>
			<% if location = "Reports" and subLocation="14" then %>
				<td align="left" class="selected">Personnel by Post</td>
			<% else %>  
				<td align="left"><A title="" href="reportsPersonnelbyPost.asp">Personnel by Post</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% 'end if %>
	
	<%' if session("Nom") <> 0 and session("Administrator") = 1 then %>
		<tr height="30">
			<td></td>
			<td valign="top"></td>
			<% if location = "Reports" and subLocation="10" then %>
				<td align="left" class="selected">Nominal Role</td>
			<% else %>
				<td align="left"><A title="" href="reportsNominalRole.asp">Nominal Role</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% ' end if %>


		-->
</table>

</div>