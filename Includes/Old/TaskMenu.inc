			  <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
			    <tr height=20>
          		  <td width=45></td>
				  <td colspan=3 align=left height=20>Current Location</td>
			    </tr>
				<tr height=20>
	              <td width=45></td>
				  <td width="18" valign=top><img src="images/arrow.gif"></td>
				  <td width="267" align=Left  ><A title="" href="Asps/index.asp">Home</A></td>
				  <td width="111" align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=45 ></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="Asps/AdminHome.asp">Administration</A></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=45></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="Asps/AdminDataMenu.asp">Static Data</a></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=45></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <% IF strPage = "AdminTsk" THEN %>
				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Tasks</Div></td>
				  <%ELSE%>	
				    <td align=Left><A title="" href="Asps/AdminRanks.asp">Tasks</a></td>
				    <%END IF %>	
				  <td width="596" align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=45></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <% IF strPage = "AdminPs" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Personnel  Tasks </Div></td>
				  <%ELSE%>
				    <td align=Left><A title="" href="Asps/AdminPsTasks.asp">Personnel Tasks </a></td>
			        <%END IF %>		
				  <td class=rightmenuspace align=Left ></td>
				</tr>
<!--				<tr height=20>
	          	  <td width=45></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <% IF strPage = "AdminOps" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Operational Tasks</Div></td>				  				  				  
				  <%ELSE%>
				    <td align=Left  ><A title="" href="AdminOpTasks.asp">Operational Tasks</A></td>
			        <%END IF%>		
				  <td align=Left  ></td>
				</tr>-->
			  </table>
