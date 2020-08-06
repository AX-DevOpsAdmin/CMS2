				 
				 <!-- Used in the AdminTableList pages to show current location -->
				 <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
					  <tr height=20>
          			    <td width=10></td><td colspan=3 align=left height=20>Current Location</td>
					  </tr>
					  <tr height=20>
	          		    <td width=10></td>
						<td width="18" valign=top><img src="images/arrow.gif"></td>
						<td width="159" align=Left  ><A title="" href="Asps/index.asp">Home</A></td>
					    <td width="70" align=Left  ></td>
					  </tr>
					  <tr height=20>
	          			<td width=10></td>
						<td valign=top><img src="images/arrow.gif"></td>
						<% IF strPage = "Manning" THEN %>
    					  <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Manning</Div></td>
						<% ELSE %>
						  <td align=Left  ><A title="" href="ManningDataMenu.asp">Manning</a></td>
						<% END IF %>  
					    <td width="780" align=Left class=rightmenuspace ></td>
					  </tr>
					  <tr height=20>
	          			<td width=10></td>
						<td valign=top><img src="images/vnavicon.gif"></td>
						<% IF strPage = "Capability" THEN %>
						  <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Capabilities</Div></td>
						<% ELSE %>  
						  <td align=Left  ><A title="" href="Asps/ManningCapabilityList.asp">Capabilities</A></td>
						<% END IF %> 
					    <td class=rightmenuspace align=Left ></td>
					  </tr>
					  <tr height=20>
	          			<td width=10></td>
						<td valign=top><img src="images/vnavicon.gif"></td>
						<% IF strPage = "PersonnelSearch" THEN %>
						  <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Personnel</Div></td>
						<% ELSE %>  
						  <td align=Left  ><A title="" href="Asps/ManningPersonnelSearch.asp">Personnel</A></td>
						<% END IF %> 
					    <td class=rightmenuspace align=Left ></td>
					  </tr>
					  <tr height=20>
	          			<td width=10></td>
						<td valign=top><img src="images/vnavicon.gif"></td>
						<% IF strPage = "Teams" THEN %>
						  <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Teams</Div></td>
						<% ELSE %>  
						  <td align=Left  ><A title="" href="Asps/ManningTeamSearch.asp">Teams</A></td>
						<% END IF %> 
					    <td class=rightmenuspace align=Left ></td>
					  </tr>
					  <tr height=20>
	          			<td width=10></td>
						<td valign=top><img src="images/vnavicon.gif"></td>
						<% IF strPage = "Posts" THEN %>
						  <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Posts</Div></td>
						<% ELSE %>  
						  <td align=Left  ><A title="" href="Asps/ManningPostSearch.asp">Posts</A></td>
						<% END IF %> 
					    <td class=rightmenuspace align=Left ></td>
					  </tr>
					  <tr height=20>
	          			<td width=10></td>
						<td valign=top><img src="images/vnavicon.gif"></td>
						<% IF strPage = "Tasks" THEN %>
						  <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Tasking</Div></td>
						<% ELSE %>  
						  <td align=Left  ><A title="" href="Asps/ManningTaskSearch.asp">Tasking</A></td>
						<% END IF %> 
					    <td class=rightmenuspace align=Left ></td>
					  </tr>
  					  <tr height=20>
	          			<td width=10></td>
						<td valign=top><img src="images/vnavicon.gif"></td>
						<% IF strPage = "Hierarchy" THEN %>
						  <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Group Hierarchy</Div></td>
						<% ELSE %>  
						  <td align=Left  ><A title="" href="Asps/Hierarchy.asp">Group Hierarchy</A></td>
						<% END IF %> 
					    <td class=rightmenuspace align=Left ></td>
					  </tr>
  					  <tr height=20>
	          			<td width=10></td>
						<td valign=top><img src="images/vnavicon.gif"></td>
						<% IF strPage = "AssignQ" THEN %>
						  <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Assign Qualifications</Div></td>
						<% ELSE %>  
						  <td align=Left  ><A title="" href="Asps/ManningQualifications.asp">Assign Qualifications</A></td>
						<% END IF %> 
					    <td class=rightmenuspace align=Left ></td>
					  </tr>

				  </table>
