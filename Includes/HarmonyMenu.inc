   <td width=15%>
	  <table BORDER=0 CELLSPACING=0 CELLPADDING=0 width=100% HEIGHT=100%>
		<tr>
		  <td height=100% valign=Top  background="Images/tableback.png">

			  
			  <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
			    <tr height=20>
          		  <td width=27></td><td colspan=3 align=left height=20>Current Location</td>
			    </tr>
				<tr height=20>
	              <td width=27></td>
				  <td width="18" valign=top><img src="images/arrow.gif"></td>
				  <td width="282" align=Left  ><A title="" href="Asps/index.asp">Home</A></td>
				  <td width="63" align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=27 ></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="Asps/reportsHome.asp">Reports</A></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=27></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <% IF strPage = "Hmny" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Harmony Status</Div></td>
				  <%ELSE%>
				    <td align=Left><A title="" href="Asps/HarmonyStatus.asp">Harmony Status</a></td>
			        <%END IF %>		
				  <td width="647" align=Left class=rightmenuspace ></td>
				</tr>

				
				<tr height=20>
	          	  <td width=27></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <% IF strPage = "Hmny1" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Personnel Harmony Status</Div></td>
				  <%ELSE%>
				    <td align=Left><A title="" href="Asps/reportsHarmonyStatus.asp">Personnel Harmony Status</a></td>
			        <%END IF %>		
				  <td width="647" align=Left class=rightmenuspace ></td>
				</tr>
				<tr height=20>
	          	  <td width=27></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <% IF strPage = "Hmny2" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Unit Harmony Status</Div></td>
				  <%ELSE%>
				    <td align=Left><A title="" href="Asps/reportsUnitHarmonyStatus.asp">Unit Harmony Status</a></td>
			        <%END IF %>		
				  <td width="647" align=Left class=rightmenuspace ></td>
				</tr>

			  </table>
	      </td> 
        </tr>
      </table>
    </td>
