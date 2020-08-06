				 
			  <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
			    <tr height=20>
          		  <td width=10></td>
          		  <td colspan=3 align=left height=20>Current Location</td>
			    </tr>
				<tr height=20>
	              <td width=10></td>
				  <td width="18" valign=top><img src="images/arrow.gif"></td>
				  <td width="170" align=Left  ><A title="" href="Asps/index.asp">Home</A></td>
				  <td width="66" align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=10 ></td>
				  <td width="18" valign=top><img src="images/arrow.gif"></td>
				  <td width="170" align=Left  ><A title="" href="Asps/ManningDataMenu.asp">Manning</A></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=10></td>
				  <td width="18" valign=top><img src="images/arrow.gif"></td>
				  <td width="170" align=Left  ><A title="" href="Asps/ManningPersonnelSearch.asp">Personnel</a></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=10></td>
				  <td width="18" valign=top><img src="images/vnavicon.gif"></td>
				  <td width="170" align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Personnel Details</Div></td>
				  <td class=rightmenuspace align=Left ></td>
				</tr>
				<% IF strManager = "1" THEN %>
				 <tr height=20>
	          	  <td width=10></td>
				  <td width="18" valign=top><img src="images/vnavicon.gif"></td>
				  <td width="170" align=Left  ><A title="" href="manningPersonnelmenu.inc">New Personnel</A></td>
				  <td align=Left  ></td>
				 </tr>
			      <tr height=20>
	          	   <td width=10></td>
				   <td width="18" valign=top><img src="images/vnavicon.gif"></td>
				   <td width="170" align=Left  ><A title="" href="Asps/ManningPeRsEdit.asp?RecID=<%=request("RecID")%>">Edit Personnel</A></td>
				   <td align=Left  ></td>
				  </tr>
				  <tr height=20>
	          	   <td width=10></td>
				   <td width="18" valign=top><img src="images/vnavicon.gif"></td>
				   <td width="170" align=Left  ><A title="" href="Asps/ManningPeRsQualifications.asp?RecID=<%=request("RecID")%>">Qualifications</A></td>
				   <td align=Left  ></td>
				  </tr>
			      <tr height=20>
	          	   <td width=10></td>
				   <td width="18" valign=top><img src="images/vnavicon.gif"></td>
				   <td width="170" align=Left  ><A title="" href="Asps/ManningPeRsMilQsMenu.asp?RecID=<%=request("RecID")%>">Military Qualifications</A></td>
				   <td align=Left  ></td>
				  </tr>
			      <tr height=20>
	          	   <td width=10></td>
				   <td width="18" valign=top><img src="images/vnavicon.gif"></td>
				   <td width="170" align=Left  ><A title="" href="Asps/ManningPeRsPosts.asp?RecID=<%=request("RecID")%>">Posts</A></td>
				   <td align=Left  ></td>
				  </tr>
				  <!--<tr height=20>-->
	          	   <!--<td width=10></td>-->
				   <!--<td width="18" valign=top><img src="images/vnavicon.gif"></td>-->
				   <!--<td width="170" align=Left  ><A title="" href="ManningPeRsTasks.asp?RecID=<%'=request("RecID")%>">Tasking</A></td>-->
				   <!--<td align=Left  ></td>-->
				  <!--</tr>-->
			   <%END IF %>	
</table>
