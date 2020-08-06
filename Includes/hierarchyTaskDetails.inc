	<tr>
		<td height="22">&nbsp;</td>
	</tr>
	<tr>
		<td height="22">
			<table border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=8px height="22">&nbsp;</td>
					<% if tab=1 then %>
						<td class="tabLeft" width=15px>&nbsp;</td>
						<td class="tabMiddle">Team Members</td>
						<td class="tabRight" width=15px>&nbsp;</td>
					<% else %>
						<td class="greyLeft" width=15px>&nbsp;</td>
						<td id="tab1" class="greyMiddle" align="center" onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';" onclick='javascript:window.parent.refreshIframeAfterDateSelect("ManningTeamPersonnel.asp");'>Team Members</td>
						<td class="greyRight"   width=15px>&nbsp;</td>
					<% end if %>
					<td width=8px>&nbsp;</td>
					<td class="tabLeft"width=15px>&nbsp;</td>
					<td id=tab4 align="center" class="tabMiddle">Task Individual</td>
					<td class="tabRight" width=15px>&nbsp;</td>
					<td width=8px></td>
				</tr>  
			</table>
		</td>
	</tr>
	<tr class=tabBottom>
		<td height="22">
			<table border=0 cellpadding=0 cellspacing=0>
				<tr>
				   <td class=toolbar width=8>&nbsp;</td>
				</tr>  
			</table>
		</td>
	</tr>
    
<script language="javascript">

function gotoPostIn2()
{
	if(document.frmDetails.postID.value == "1234")
	{
		alert("Select a Post");
	}
	else
	{
		document.frmDetails.action="HierarchyPostStaff.asp";
		document.frmDetails.submit();
	}
}

function gotoPostOut2()
{
	if(document.frmDetails.staffPostID.value == "")
	{
		alert("Select a Post with Post Holder");
	}
	else
	{
		document.frmDetails.action="HierarchyPostStaffOut.asp";
		document.frmDetails.submit();
	}
}

function gotoTaskingOverView()
{
	document.frmDetails.action="HierarchyTeamTaskingOverview.asp";
	document.frmDetails.submit();
	window.parent.startTimer()
}

</script>