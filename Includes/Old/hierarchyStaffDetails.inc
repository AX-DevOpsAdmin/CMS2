	<Input Type="hidden" name="thisDate">	
    
	<tr height="16px">
		<td></td>
	</tr>
	<tr height="16px">
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr height="24px">
					<td width="8px"></td>
					<td class="greyLeft" width="15px">&nbsp;</td>
					<td id="tab9" align="center" class="greyMiddle" onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';" onclick='javascript:if (window.parent.frmDetails.teamID.value != 0){window.parent.refreshIframeAfterDateSelect("ManningTeamPersonnel.asp")}else{alert("Not a member of a team")};'>Team Members</td>
					<td class="greyRight" width="15px">&nbsp;</td>
					
					<td width="8px"></td>
					<td class="<%if tab=1 then%>tabLeft<%else%>greyLeft<%end if%>" width="15px">&nbsp;</td>
					<td id="tab1" align="center" class="<%if tab=1 then%>tabMiddle<%else%>greyMiddle<%end if%>" <%if tab<>1 then%>onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';" onclick='javascript:frmDetails.action="HierarchyPersDetail.asp";frmDetails.submit();'<%end if%>>Personal</td>
					<td  class="<%if tab=1 then%>tabRight<%else%>greyRight<%end if%>" width="15px">&nbsp;</td>
					
					<td width="8px"></td>
					<td  class="<%if tab=3 then%>tabLeft<%else%>greyLeft<%end if%>" width="15px">&nbsp;</td>
					<td id="tab3" align="center" class="<%if tab=3 then%>tabMiddle<%else%>greyMiddle<%end if%>" <%if tab<>3 then%>onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';" onclick='javascript:frmDetails.action="HierarchyPersQualifications.asp";frmDetails.submit();'<%end if%>>Qualifications</td>
					<td class="<%if tab=3 then%>tabRight<%else%>greyRight<%end if%>" width="15px">&nbsp;</td>
					
					<td width="8px"></td>
					<td  class="<%if tab=4 then%>tabLeft<%else%>greyLeft<%end if%>" width="15px">&nbsp;</td>
					<td id="tab4" align="center" class="<%if tab=4 then%>tabMiddle<%else%>greyMiddle<%end if%>" <%if tab<>4 then%>onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';"  onclick='javascript:frmDetails.action="HierarchyPersMilSkills.asp" ;frmDetails.submit();'<%end if%>>Military Skills</td>
					<td class="<%if tab=4 then%>tabRight<%else%>greyRight<%end if%>" width="15px">&nbsp;</td>
					
					<td width="8px"></td>
					<td class="<%if tab=5 then%>tabLeft<%else%>greyLeft<%end if%>" width="15px">&nbsp;</td>
					<td id="tab5" align="center" class="<%if tab=5 then%>tabMiddle<%else%>greyMiddle<%end if%>" <%if tab<>5 then%>onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';"  onclick='javascript:frmDetails.action="HierarchyPersFitness.asp";frmDetails.submit();'<%end if%>>Fitness</td>
					<td class="<%if tab=5 then%>tabRight<%else%>greyRight<%end if%>" width="15px">&nbsp;</td>
					
					<td width="8px"></td>
					<td class="<%if tab=6 then%>tabLeft<%else%>greyLeft<%end if%>" width="15px">&nbsp;</td>
					<td id="tab6" align="center" class="<%if tab=6 then%>tabMiddle<%else%>greyMiddle<%end if%>" <%if tab<>6 then%>onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';"  onclick='javascript:frmDetails.action="HierarchyPersVacs.asp";frmDetails.submit();'<%end if%>>Vaccinations</td>
					<td class="<%if tab=6 then%>tabRight<%else%>greyRight<%end if%>" width="15px">&nbsp;</td>
					
					<td width="8px"></td>
					<td class="<%if tab=7 then%>tabLeft<%else%>greyLeft<%end if%>" width="15px">&nbsp;</td>
					<td id="tab7" align="center" class="<%if tab=7 then%>tabMiddle<%else%>greyMiddle<%end if%>" <%if tab<>7 then%>onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';"  onclick='javascript:frmDetails.action="HierarchyPersDental.asp";frmDetails.submit();'<%end if%>>Dental</td>
					<td class="<%if tab=7 then%>tabRight<%else%>greyRight<%end if%>" width="15px">&nbsp;</td>
					
					<td width="8px"></td>
					<td class="<%if tab=8 then%>tabLeft<%else%>greyLeft<%end if%>" width="15px">&nbsp;</td>
					<td id="tab8" align="center" class="<%if tab=8 then%>tabMiddle<%else%>greyMiddle<%end if%>" <%if tab<>8 then%>onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';"  onclick='javascript:frmDetails.action="HierarchyPersPostAndMove.asp";frmDetails.submit();'<%end if%>>Posting and Movement History</td>
					<td class="<%if tab=8 then%>tabRight<%else%>greyRight<%end if%>" width="15px">&nbsp;</td>
					
					<td width="8px"></td>
					<td class="toolbar" valign="middle"></td>
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
    
<script language="JavaScript">
	frmDetails.thisDate.value = window.parent.frmDetails.startDate.value
</script>
