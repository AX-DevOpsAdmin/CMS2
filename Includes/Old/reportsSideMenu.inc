<table border="0" cellspacing="0" cellpadding="0" width="100%" class="MenuStyleParent">
	<tr height="22">
		<td width="10px"></td>
		<td colspan="3" align="left" height="18">Current Location</td>
	</tr>
	<tr>
		<td></td>
		<td width="18" valign="top"><img src="Images/arrow.gif"></td>
		<td width="170" height=18 align="left"><A title="" href="index.asp">Home</A></td>
		<td width="50" align="left"></td>
	</tr>
	<tr height="22">
		<td></td>
		<td valign="top"><img src="Images/arrow.gif"></td>
		<% if location = "Reports" and subLocation = "1" then %>
			<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Reports</div></td>
		<% else %>  
			<td align="left"><A title="" href="reportsHome.asp">Reports</A></td>
		<% end if %>
		<td align="left"></td>
	</tr>
	<% if session("Man") <> 0 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="2" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Manning</div></td>
			<% else %>  
				<td align="left"><A title="" href="reportsManningMultiple.asp">Manning</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Per") <> 0 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="5" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Personnel Harmony</div></td>
			<% else %>  
				<td align="left"><A title="" href="reportsHarmonyStatus.asp">Personnel Harmony</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Uni") <> 0 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="6" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Unit Harmony</div></td>
			<% else %>  
				<td align="left"><A title="" href="reportsUnitHarmonyStatus.asp">Unit Harmony</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>						
	<% end if %>
	<% if session("Cap") <> 0 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="3" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px;border-color:#438BE4; color:#003399;">Capability</div></td>
			<% else %>  
				<td align="left"><A title="" href="reportsCapability.asp">Capability</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Pre") <> 0 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="4" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color:#003399;">Present/Absent</div></td>
			<% else %>  
				<td align="left"><A title="" href="reportsPersonnelPresentOrAbsent.asp">Present/Absent</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Fit") <> 0 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="7" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color:#003399;">RAF Fitness</div></td>
			<% else %>  
				<td align="left"><A title="" href="reportsFitnessStatus.asp">RAF Fitness</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Boa") <> 0 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="8" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color:#003399;">Management Board</div></td>
			<% else %>  
				<td align="left"><A title="" href="reportsMonthlyStats.asp">Management Board</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Sch") <> 0 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="9" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color:#003399;">Tasking Schedule</div></td>
			<% else %>  
				<td align="left"><A title="" href="reportsTaskingSchedule.asp">Tasking Schedule</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Nom") <> 0 and session("Administrator") = 1 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="10" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color:#003399;">Nominal Role</div></td>
			<% else %>
				<td align="left"><A title="" href="reportsNominalRole.asp">Nominal Role</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Ran") <> 0 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="11" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color:#003399;">Personnel by Rank</div></td>
			<% else %>  
				<td align="left"><A title="" href="reportsPersonnelbyRank.asp">Personnel by Rank</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Pos") <> 0 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="14" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color:#003399;">Personnel by Post</div></td>
			<% else %>  
				<td align="left"><A title="" href="reportsPersonnelbyPost.asp">Personnel by Post</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Aut") <> 0 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="12" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color:#003399;">CIS Auth</div></td>
			<% else %>  
				<td align="left"><A title="" href="reportsCISAuth.asp">CIS Auth</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Ind") <> 0 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="13" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color:#003399;">CIS Individual Auth</div></td>
			<% else %>  
				<td align="left"><A title="" href="reportsCISIndividualAuth.asp">CIS Individual Auth</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Rod") <> 0 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="15" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color:#003399;">Run Out Date</div></td>
			<% else %>  
				<td align="left"><A title="" href="reportsRunOutDate.asp">Run Out Date</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
	<% if session("Paq") <> 0 then %>
		<tr height="22">
			<td></td>
			<td valign="top"><img src="Images/vnavicon.gif"></td>
			<% if location = "Reports" and subLocation="16" then %>
				<td align="left" bgcolor="#FFFFFF"><div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color:#003399;">Personnel & Qs</div></td>
			<% else %>  
				<td align="left"><A title="" href="reportsPersAndQs.asp">Personnel & Qs</A></td>
			<% end if %> 
			<td align="left"></td>
		</tr>
	<% end if %>
</table>