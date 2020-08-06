	<!-- Used in the AdminTableList pages to show current location -->
	<table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
		<tr height=22>
			<td width=10></td>
			<td colspan=3 align="left" height=22>Current Location</td>
		</tr>
		<tr height=22>
			<td></td>
			<td width="18" valign=top><img src="Images/arrow.gif"></td>
			<td width="170" align="left"><A title="" href="index.asp">Home</A></td>
			<td width="50" align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top><img src="Images/arrow.gif"></td>
			<td align="left"><A title="" href="AdminHome.asp">Administration</A></td>
			<td align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top><img src="Images/arrow.gif"></td>
				<% if strPage = "StaticData" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Static Data</Div></td>
				<% else %>
					<td align="left"><A title="" href="AdminDataMenu.asp">Static Data</a></td>
				<% end if %>  
			<td class=rightmenuspace align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Group" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Groups</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminGroupList.asp">&bull;&nbsp;Groups</A></td>
				<% end if %> 
			<td class=rightmenuspace align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Wing" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Wings</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminWingList.asp">&bull;&nbsp;Wings</A></td>
				<% end if %> 
			<td class=rightmenuspace align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Squadron" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Squadrons</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminSquadronList.asp">&bull;&nbsp;Squadrons</A></td>
				<% end if %> 
			<td class=rightmenuspace align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Flight" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Flights</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminFlightList.asp">&bull;&nbsp;Flights</A></td>
				<% end if %> 
			<td class=rightmenuspace align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Service" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Services</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminServiceList.asp">&bull;&nbsp;Services</A></td>
				<% end if %> 
			<td class=rightmenuspace align="left"></td>
		</tr>		
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Rank" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Ranks</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminRanks.asp">&bull;&nbsp;Ranks</A></td>
				<% end if %> 
			<td class=rightmenuspace align="left"></td>
		</tr>		
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "HaPer" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Harmony Periods</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminHarPer.asp">&bull;&nbsp;Harmony Periods</A></td>
				<% end if %>  
			<td align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "ooa" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;OOA Max Days</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminooadList.asp">&bull;&nbsp;OOA Max Days</A></td>
				<% end if %>  
			<td align="left"></td>
		</tr>
		<!--
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Trade" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Trades</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminTrades.asp">&bull;&nbsp;Trades</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		-->
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Cycle" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Cycles</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminCycles.asp">&bull;&nbsp;Cycles</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Qualification" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Qualifications</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminQualifications.asp">&bull;&nbsp;Qualifications</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "ValPer" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Validity Periods</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminValPList.asp">&bull;&nbsp;Validity Periods</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Military" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Military</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminMilitary.asp">&bull;&nbsp;Military</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Teams" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Teams</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminTeamList.asp">&bull;&nbsp;Teams</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "CondF" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Conditional Formats</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminCondFList.asp">&bull;&nbsp;Conditional Formats</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "AdminTsk" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Tasks</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminPsTasks.asp">&bull;&nbsp;Tasks</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Posts" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Posts</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminPostList.asp">&bull;&nbsp;Posts</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "PeRs" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Personnel</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminPeRsList.asp">&bull;&nbsp;Personnel</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>		
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Hmny" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Harmony Guidelines</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminHmGlList.asp">&bull;&nbsp;Harmony Guidelines</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "MES" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;MES</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminMESList.asp">&bull;&nbsp;MES</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>		
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "SSC" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;SSC</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminSSCList.asp">&bull;&nbsp;SSC</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>		
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "PWD" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Default Password</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminGenPW.asp">&bull;&nbsp;Default Password</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<%if session("RAFP")=1 then %>
			<tr height=22>
				<td></td>
				<td valign=top></td>
					<% if strPage = "Excel" then %>
						<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;View/Upload Spreadsheet</Div></td>
					<% else %>  
						<td align="left"><A title="" href="UploadExcel.asp">&bull;&nbsp;View/Upload Spreadsheet</A></td>
					<% end if %>
				<td align="left"></td>
			</tr>
		<% end if %>		
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "AdminCon" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Contact</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminContactList.asp">&bull;&nbsp;Contact</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
		<tr height=22>
			<td></td>
			<td valign=top></td>
				<% if strPage = "Config" then %>
					<td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Configuration</Div></td>
				<% else %>  
					<td align="left"><A title="" href="AdminConfigList.asp">&bull;&nbsp;Configuration</A></td>
				<% end if %>
			<td align="left"></td>
		</tr>
	</table>
