			  <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
			    <tr height=20>
          		  <td width=30></td><td colspan=3 align=left height=20>Current Location</td>
			    </tr>
				<tr height=20>
	              <td width=30></td>
				  <td width="25" valign=top><img src="images/arrow.gif"></td>
				  <td width="132" align=Left  ><A title="" href="Asps/index.asp">Home</A></td>
				  <td width="13" align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=30 ></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="Asps/AdminHome.asp">Administration</A></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=30></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="Asps/AdminDataMenu.asp">Static Data</a></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=30></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="Asps/AdminTasks.asp">Tasks</a></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=30></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <% IF strPage = "AdminOps" THEN %>
				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Operational Tasks </Div></td>
				  <%ELSE%>	
				    <td align=Left><A title="" href="Asps/AdminOpTasks.asp">Operational Tasks</a></td>
				  <%END IF %>	
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=30></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <% IF strPage = "OpTs" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Op Task Status </Div></td>
				  <%ELSE%>
				    <td align=Left><A title="" href="Asps/AdminOpTsList.asp">Op Task Status</a></td>
			      <%END IF %>		
				  <td class=rightmenuspace align=Left ></td>
				</tr>
				<tr height=20>
	          	  <td width=30></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <% IF strPage = "OpTc" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Op Task Category</Div></td>				  
				  <%ELSE%>
				     <td align=Left  ><A title="" href="Asps/AdminOpTcList.asp">Op Task Category</A></td>
				  <%END IF%>	 
				  <td align=Left  ></td>
				</tr>
			    <tr height=20>
	          	  <td width=30></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <% IF strPage = "OpTk" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Op Task</Div></td>				  				  
				  <%ELSE%>
  				    <td align=Left  ><A title="" href="Asps/AdminOpTkList.asp">Op Task</A></td>
			      <%END IF%>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=30></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <% IF strPage = "OpTa" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Op Actions</Div></td>				  				  				  
				  <%ELSE%>
				    <td align=Left  ><A title="" href="Asps/AdminOpTaList.asp">Op Actions</A></td>
			      <%END IF%>		
				  <td align=Left  ></td>
				</tr>
			  </table>
