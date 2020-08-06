			  <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
			    <tr height=22>
          		  <td width=10></td>
				  <td colspan=3 align=left height=22>Current Location</td>
			    </tr>
				<tr height=22>
	              <td></td>
				  <td width="18" valign=top><img src="images/arrow.gif"></td>
				  <td width="170" align=Left><A title="" href="Asps/index.asp">Home</A></td>
				  <td width="50" align=Left></td>
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
				  <% IF strPage = "Military" THEN %>
				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Military</Div></td>
				  <%ELSE%>	
				    <td align=Left><A title="" href="Asps/AdminMilitary.asp">Military</a></td>
				  <%END IF %>	
				  <td align=Left  ></td>
				</tr>
				<tr height=22>
	          	  <td></td>
				  <td valign=top></td>
				  <% IF strPage = "MS" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Skills</Div></td>
				  <%ELSE%>
				    <td align=Left><A title="" href="Asps/AdminMSList.asp">&bull;&nbsp;Skills</a></td>
			      <%END IF %>		
				  <td class=rightmenuspace align=Left ></td>
				</tr>
				<tr height=22>
	          	  <td></td>
				  <td valign=top></td>
				  <% IF strPage = "MSWeight" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Skills Weighting</Div></td>				  
				  <%ELSE%>
				     <td align=Left  ><A title="" href="Asps/AdminMSWeightingList.asp">&bull;&nbsp;Skills Weighting</A></td>
				  <%END IF%>	 
				  <td align=Left  ></td>
				</tr>
			    <tr height=22>
	          	  <td></td>
				  <td valign=top></td>
				  <% IF strPage = "Fit" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Fitness</Div></td>				  				  
				  <%ELSE%>
  				    <td align=Left  ><A title="" href="Asps/AdminFitnessList.asp">&bull;&nbsp;Fitness</A></td>
			      <%END IF%>
				  <td align=Left  ></td>
				</tr>
				<tr height=22>
	          	  <td></td>
				  <td valign=top></td>
				  <% IF strPage = "Vacc" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Vaccinations</Div></td>				  				  
				  <%ELSE%>
  				    <td align=Left  ><A title="" href="Asps/AdminVaccinationsList.asp">&bull;&nbsp;Vaccinations</A></td>
			      <%END IF%>
				  <td align=Left  ></td>
				</tr>
			    <tr height=22>
	          	  <td></td>
				  <td valign=top></td>
				  <% IF strPage = "Dent" THEN %>
  				    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;Dental</Div></td>				  				  
				  <%ELSE%>
  				    <td align=Left  ><A title="" href="Asps/AdminDentalList.asp">&bull;&nbsp;Dental</A></td>
			      <%END IF%>
				  <td align=Left  ></td>
				</tr>

			  </table>
