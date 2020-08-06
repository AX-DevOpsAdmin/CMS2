	<tr height=16px>
		<td></td>
	</tr>
	<tr height=16 >
		<td>
			<table  border=0 cellpadding=0 cellspacing=0 >
				<tr height=24px>
					<td width=8px></td>
                    <!--
					<td  class="greyLeft" width=15px>&nbsp;</td>
					<td  id=tab9 align="center" class="greyMiddle" onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';" onclick='javascript:if (window.parent.frmDetails.teamID.value != 0){window.parent.refreshIframeAfterDateSelect("ManningTeamPersonnel.asp")}else{alert("Not a member of a team")};'>Team Members</td>
					<td class="greyRight" width=15px>&nbsp;</td>
					<td  width=8px></td>
                    -->
                    <%'= "tab is " & tab %>
                   
					<td class="<% if tab=1 or tab=10 then %>tabLeft<% else %>greyLeft<% end if %>" width=15px>&nbsp;</td>
					<td id=tab1 align="center" class="<% if tab=1 or tab =10 then %>tabMiddle<% else %>greyMiddle<% end if %>" onmouseOut="javascript:this.style.color='#333333';" onmouseOver="javascript:this.style.color='#003399';"  onclick='javascript:frmDetails.action="HierarchyPostDetail.asp";frmDetails.submit();'>Post</td>
					<td class="<% if tab=1 or tab =10 then %>tabRight<% else %>greyRight<% end if %>" width=15px>&nbsp;</td>
					<td  width=8px></td>
					<% if tab=1 then %>
					    <% if tab < 6 then%>
							<td class="<% if tab=3 then %>tabLeft<% else %>greyLeft<% end if %>" width=15px>&nbsp;</td>
							<td  id=tab3 align="center" class="<% if tab=3 then %>tabMiddle<% else %>greyMiddle<%end if%>" onmouseOut="javascript:this.style.color='#333333';" onmouseOver="javascript:this.style.color='#003399';" onclick='javascript:frmDetails.action="HierarchyPostQualifications.asp";frmDetails.submit();'>Qualifications</td>
							<td class="<% if tab=3 then %>tabRight<% else %>greyRight<% end if %>" width=15px>&nbsp;</td>
							<td  width=8px></td>
							<td  class="<% if tab=4 then %>tabLeft<% else %>greyLeft<%end if%>" width=15px>&nbsp;</td>
							<td id=tab4 align="center" class="<% if tab=4 then %>tabMiddle<% else %>greyMiddle<%end if%>" onmouseOut="javascript:this.style.color='#333333';" onmouseOver="javascript:this.style.color='#003399';" onclick='javascript:frmDetails.action="HierarchyPostMS.asp";frmDetails.submit();'>Military Skills </td>
							<td class="<% if tab=4 then %>tabRight<% else %>greyRight<%end if%>" width=15px>&nbsp;</td>
							<td  width=8px></td>
					    <% end if %>
                        <% if isNull (rsRecset("postholder")) then %>
						  <td class="<%if tab=5 then%>tabLeft<%else%>greyLeft<%end if%>" width=15px>&nbsp;</td>
						  <td id=tab5 align="center" class="<%if tab=5 then%>tabMiddle<%else%>greyMiddle<%end if%>" onmouseOut="javascript:this.style.color='#333333';" onmouseOver="javascript:this.style.color='#003399';" onclick='javascript:gotoPostIn2();'>Post In</td>
						  <td class="<%if tab=5 then%>tabRight<%else%>greyRight<%end if%>" width=15px>&nbsp;</td>                 
						  <td width=8px>&nbsp;</td> 
						<% else %>                   
						  <td class="<%if tab=6 then%>tabLeft<%else%>greyLeft<%end if%>" width=15px>&nbsp;</td>
						  <td id=tab6 align="center" class="<%if tab=6 then%>tabMiddle<%else%>greyMiddle<%end if%>" onmouseOut="javascript:this.style.color='#333333';" onmouseOver="javascript:this.style.color='#003399';" onclick='javascript:gotoPostOut2();'>Post Out</td>
						  <td  class="<%if tab=6 then%>tabRight<%else%>greyRight<%end if%>" width=15px>&nbsp;</td>                                        
						  <td  width=8px>&nbsp;</td>
						<% end if %>
                    <% end if %> 
					
					 <% if tab = 3 then%>
							<td class="tabLeft" width=15px>&nbsp;</td>
							<td  id=tab3 align="center" class="tabMiddle" onmouseOut="javascript:this.style.color='#333333';" onmouseOver="javascript:this.style.color='#003399';" onclick='javascript:frmDetails.action="HierarchyPostQualifications.asp";frmDetails.submit();'>Qualifications</td>
							<td class="tabRight" width=15px>&nbsp;</td>
							<td  width=8px></td>
					<%end if %>
					<% if tab = 4 then%>
							<td class="tabLeft" width=15px>&nbsp;</td>
							<td id=tab4 align="center" class="tabMiddle" onmouseOut="javascript:this.style.color='#333333';" onmouseOver="javascript:this.style.color='#003399';" onclick='javascript:frmDetails.action="HierarchyPostMS.asp";frmDetails.submit();'>Military Skills </td>
							<td class="tabRight" width=15px>&nbsp;</td>
							<td  width=8px></td>
					<%end if %>
					<% if tab = 5 then%>
							<td class="tabLeft" width=15px>&nbsp;</td>
						  <td id=tab5 align="center" class="tabMiddle" onmouseOut="javascript:this.style.color='#333333';" onmouseOver="javascript:this.style.color='#003399';" onclick='javascript:gotoPostIn2();'>Post In</td>
							<td class="tabRight" width=15px>&nbsp;</td>
							<td  width=8px></td>
					<%end if %>
					<% if tab = 6 then%>
							<td class="tabLeft" width=15px>&nbsp;</td>
						  <td id=tab6 align="center" class="tabMiddle" onmouseOut="javascript:this.style.color='#333333';" onmouseOver="javascript:this.style.color='#003399';" onclick='javascript:gotoPostOut2();'>Post Out</td>
							<td class="tabRight" width=15px>&nbsp;</td>
							<td  width=8px></td>
					<%end if %>


					<td class=toolbar valign="middle" ></td>
				</tr>  
			</table>
		</td>
	</tr>
	<tr height=16 class=tabBottom>
		<td>
			<table border=0 cellpadding=0 cellspacing=0 >
				<tr>
				   <td class=toolbar width=8></td>
				   
				</tr>  
			</table>
		</td>
	</tr>

<script language="javascript">

function gotoPostIn2()
{
	document.frmDetails.action="HierarchyPostStaff.asp";
	document.frmDetails.submit();
}

function gotoPostOut2(staffpostID)
{
	document.frmDetails.action="HierarchyPostStaffOut.asp";
	document.frmDetails.submit();
}



</Script>