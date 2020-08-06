			  <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
			    <tr height=22>
          		  <td width=10></td><td colspan=3 align=left height=22>Current Location</td>
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
				  <% IF strPage = "AdminR" THEN %>
				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Ranks</Div></td>
				  <%ELSE%>	
				    <td align=Left><A title="" href="Asps/AdminRanks.asp">Ranks</a></td>
				  <%END IF %>	
				  <td align=Left></td>
				</tr>
				<tr height=22>
	          	  <td></td>
				  <td valign=top></td>
				  <% IF strPage = "Rank" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Rank List</Div></td>
				  <%ELSE%>
				    <td align=Left><A title="" href="Asps/AdminRankList.asp">&bull;&nbsp;Rank List</a></td>
			      <%END IF %>		
				  <td class=rightmenuspace align=Left ></td>
				</tr>
				<tr height=22>
	          	  <td></td>
				  <td valign=top></td>
				  <% IF strPage = "WtRank" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Rank Weight</Div></td>				  				  				  
				  <%ELSE%>
				    <td align=Left><A title="" href="Asps/AdminRankWtList.asp">&bull;&nbsp;Rank Weight</A></td>
			      <%END IF%>		
				  <td align=Left></td>
				</tr>
			  </table>
