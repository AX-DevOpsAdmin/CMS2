			  <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
			    <tr height=22>
          		  <td width=10></td>
				  <td colspan=3 align=left height=22>Current Location</td>
			    </tr>
				<tr height=22>
	              <td></td>
				  <td width="18" valign=top><img src="images/arrow.gif"></td>
				  <td width="170" align=Left  ><A title="" href="Asps/index.asp">Home</A></td>
				  <td width="50" align=Left  ></td>
				</tr>
				<tr height=22>
	          	  <td></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left><A title="" href="Asps/AdminHome.asp">Administration</A></td>
				  <td align=Left></td>
				</tr>
				<tr height=22>
	          	  <td></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left><A title="" href="Asps/AdminDataMenu.asp">Static Data</a></td>
				  <td align=Left></td>
				</tr>
				
				<tr height=22>
	          	  <td></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  	<% IF strPage = "HaPer" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Harmony Periods </Div></td>
				  <%ELSE%>
				    <td align=Left><A title="" href="Asps/AdminHarPer.asp">Harmony Periods</a></td>
			        <%END IF %>		
				  <td align=Left  ></td>
				</tr>
				<tr height=22>
	          	  <td></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <% IF strPage = "PsHp" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Personnel Harmony </Div></td>
				  <%ELSE%>
				    <td align=Left><A title="" href="Asps/AdminHPList.asp">Personnel Harmony</a></td>
			        <%END IF %>		
				  <td width="647" align=Left class=rightmenuspace ></td>
				</tr>
				<tr height=22>
	          	  <td></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <% IF strPage = "UnHp" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Unit Harmony </Div></td>
				  <%ELSE%>
				    <td align=Left><A title="" href="Asps/AdminUnitHPList.asp">Unit Harmony</a></td>
			        <%END IF %>		
				  <td width="647" align=Left class=rightmenuspace ></td>
				</tr>
				
			  </table>
