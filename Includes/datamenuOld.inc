	<!-- Used in the AdminTableList pages to show current location -->
	<table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
	    <tr height=30>
			<td></td>
			<td width="9" valign=top></td>
			<td width="170" align="left"><A title="" href="index.asp">Home</A></td>
			<td width="50" align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "StaticData" then %>
					<td align="left" class="selected">Static Data</td>
				<% else %>
					<td align="left"><A title="" href="AdminDataMenu.asp">Static Data</a></td>
				<% end if %>  
			<td class=rightmenuspace align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Group" then %>
					<td align="left" class="selected">Groups</td>
				<% else %>  
					<td align="left"><A title="" href="AdminGroupList.asp">Groups</A></td>
				<% end if %> 
			<td class=rightmenuspace align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Wing" then %>
					<td align="left" class="selected">Wings</td>
				<% else %>  
					<td align="left"><A title="" href="AdminWingList.asp">Wings</A></td>
				<% end if %> 
			<td class=rightmenuspace align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Squadron" then %>
					<td align="left" class="selected">Squadrons</td>
				<% else %>  
					<td align="left"><A title="" href="AdminSquadronList.asp">Squadrons</A></td>
				<% end if %> 
			<td class=rightmenuspace align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Flight" then %>
					<td align="left" class="selected">Flights</td>
				<% else %>  
					<td align="left"><A title="" href="AdminFlightList.asp">Flights</A></td>
				<% end if %> 
			<td class=rightmenuspace align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Rank" then %>
					<td align="left" class="selected">Ranks</td>
				<% else %>  
					<td align="left"><A title="" href="AdminRanks.asp">Ranks</A></td>
				<% end if %> 
			<td class=rightmenuspace align="left"></td>
		</tr>		
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "HaPer" then %>
					<td align="left" class="selected">Harmony Periods</td>
				<% else %>  
					<td align="left"><A title="" href="AdminHarPer.asp">Harmony Periods</A></td>
				<% end if %>  
			<td align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "ooa" then %>
					<td align="left" class="selected">OOA Max Days</td>
				<% else %>  
					<td align="left"><A title="" href="AdminooadList.asp">OOA Max Days</A></td>
				<% end if %>  
			<td align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Trade" then %>
					<td align="left" class="selected">Trades</td>
				<% else %>  
					<td align="left"><A title="" href="AdminTrades.asp">Trades</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Cycle" then %>
					<td align="left" class="selected">Cycles</td>
				<% else %>  
					<td align="left"><A title="" href="AdminCycles.asp">Cycles</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Qualification" then %>
					<td align="left" class="selected">Qualifications</td>
				<% else %>  
					<td align="left"><A title="" href="AdminQualifications.asp">Qualifications</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "ValPer" then %>
					<td align="left" class="selected">Validity Periods</td>
				<% else %>  
					<td align="left"><A title="" href="AdminValPList.asp">Validity Periods</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Military" then %>
					<td align="left" class="selected">Military</td>
				<% else %>  
					<td align="left"><A title="" href="AdminMilitary.asp">Military</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Teams" then %>
					<td align="left" class="selected">Teams</td>
				<% else %>  
					<td align="left"><A title="" href="AdminTeamList.asp">Teams</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "CondF" then %>
					<td align="left" class="selected">Conditional Formats</td>
				<% else %>  
					<td align="left"><A title="" href="AdminCondFList.asp">Conditional Formats</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "AdminTsk" then %>
					<td align="left" class="selected">Tasks</td>
				<% else %>  
					<td align="left"><A title="" href="AdminPsTasks.asp">Tasks</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Posts" then %>
					<td align="left" class="selected">Posts</td>
				<% else %>  
					<td align="left"><A title="" href="AdminPostList.asp">Posts</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "PeRs" then %>
					<td align="left">Personnel</td>
				<% else %>  
					<td align="left"><A title="" href="AdminPeRsList.asp">Personnel</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>		
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Hmny" then %>
					<td align="left" class="selected">Harmony Guidelines</td>
				<% else %>  
					<td align="left"><A title="" href="AdminHmGlList.asp">Harmony Guidelines</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "MES" then %>
					<td align="left" class="selected">Medical Employed Status</td>
				<% else %>  
					<td align="left"><A title="" href="AdminMESList.asp">Medical Employed Status</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>		
		<tr height=50>
			<td></td>
			<td valign=top></td>
				<% if strPage = "SSC" then %>
					<td align="left" class="selected">Separated Service Codes</td>
				<% else %>  
					<td align="left"><A title="" href="AdminSSCList.asp">Separated Service Codes</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>		
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "PWD" then %>
					<td align="left" class="selected">Change Default Password</td>
				<% else %>  
					<td align="left"><A title="" href="AdminGenPW.asp">Change Default Password</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<%if session("RAFP")=1 then %>
			<tr height=30>
				<td></td>
				<td valign=top></td>
					<% if strPage = "Excel" then %>
						<td align="left" class="selected">View/Upload Spreadsheet</td>
					<% else %>  
						<td align="left"><A title="" href="UploadExcel.asp">View/Upload Spreadsheet</A></td>
					<% end if %>
				<td align="left"></td>
			</tr>
		<% end if %>		
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "AdminCon" then %>
					<td align="left" class="selected">Contact</td>
				<% else %>  
					<td align="left"><A title="" href="AdminContactList.asp">Contact</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=30>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Config" then %>
					<td align="left" class="selected">Configuration</td>
				<% else %>  
					<td align="left"><A title="" href="AdminConfigList.asp">Configuration</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
	</table>
