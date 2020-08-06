	<tr height=16px >
		<td colspan=2>
		</td>
	</tr>
	<tr height=16 >
		<td colspan=2>
			<table  border=0 cellpadding=0 cellspacing=0 >
				<tr height=24px>
					<td width=8px></td>
						<%if tab<>6 then%>
                            <%if tab=1 then%>
                                <td class="tabLeft" width=15px>&nbsp;</td>
                                <td class="tabMiddle">Team Members</td>
                                <td class="tabRight" width=15px>&nbsp;</td>
                            <%else%>
                                <td class="greyLeft" width=15px>&nbsp;</td>
                                <td id = "tab1" class="greyMiddle" align="center" onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';" onclick='javascript:window.parent.refreshIframeAfterDateSelect("ManningTeamPersonnel.asp");'>Team Members</td>
                                <td class="greyRight" width=15px>&nbsp;</td>                            
                            <%End if%>
                            <td width=8px>&nbsp;</td>
                            <%if noPlannerTab <> "1" then%>
                                <%if tab = 2 then%>
                                    <td class="tabLeft" width=15px>&nbsp;</td>
                                    <td class="tabMiddle">Team Planner</td>
                                    <td class="tabRight" width=15px>&nbsp;</td>                            
                                <%else%>                                
                                    <td class="greyLeft" width=15px>&nbsp;</td>
                                    <td id="tab2" class="greyMiddle" align="center" onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';" onclick="javascript:gotoTaskingOverView('Team');">Team Planner</td>
                                    <td class="greyRight" width=15px>&nbsp;</td>                                
                                <%end if%>
                                <td  width=8px>&nbsp;</td>
                            <%end if%>
                            <%if tab=3 then%>
                                <td class="tabLeft" width=15px>&nbsp;</td>
                                <td class="tabMiddle">Manager details</td>
                                <td class="tabRight" width=15px>&nbsp;</td>                        
                                <td width=8px></td>
                            <%end if%>                   
                            <%if int(strManager)=1 then%>
                                <td class="<%if tab=4 then%>tabLeft<%else%>greyLeft<%end if%>" width=15px>&nbsp;</td>
                                <td id=tab4 align="center" class="<%if tab=4 then%>tabMiddle<%else%>greyMiddle<%end if%>" onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';" onclick='javascript:gotoPostIn2();'>Post In</td>
                                <td class="<%if tab=4 then%>tabRight<%else%>greyRight<%end if%>" width=15px>&nbsp;</td>                 
                                <td width=8px>&nbsp;</td>                    
                                <td class="<%if tab=5 then%>tabLeft<%else%>greyLeft<%end if%>" width=15px>&nbsp;</td>
                                <td id=tab5 align="center" class="<%if tab=5 then%>tabMiddle<%else%>greyMiddle<%end if%>" onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';" onclick='javascript:gotoPostOut2();'>Post Out</td>
                                <td  class="<%if tab=5 then%>tabRight<%else%>greyRight<%end if%>" width=15px>&nbsp;</td>                                        
                                <td  width=8px>&nbsp;</td>
                            <%end if%>
                        <%else%>
                            <td class="<%if tab=6 then%>tabLeft<%else%>greyLeft<%end if%>" width=15px>&nbsp;</td>
                            <td id=tab6 align="center" class="<%if tab=6 then%>tabMiddle<%else%>greyMiddle<%end if%>" onmouseOut="javascript:this.style.color='#dddddd';" onmouseOver="javascript:this.style.color='#ffffff';" onclick='javascript:gotoPersonnelSearch();'>Search</td>
                            <td class="<%if tab=6 then%>tabRight<%else%>greyRight<%end if%>" width=15px>&nbsp;</td>                                        
                            <td  width=8px></td>
                        <%end if%>
			</table>
		</td>
	</tr>
    <tr height=16 class=tabBottom>
        <td colspan=2>
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
	if(document.frmDetails.serviceNo.value != "")
	{
		alert("This post is occupied!\n\nYou cannot post another person in until\nthe occupying person has been posted out.");
		return;
	}
	else
	{
		if(document.frmDetails.postID.value=="1234")
		{
			alert("Select a Post");
		}
		else
		{
			frmDetails.action="HierarchyPostStaff.asp";
			frmDetails.submit();
		}
	}	
}

function gotoPostOut2()
{
	if(document.frmDetails.staffPostID.value=="")
	{
		alert("Select a Post with Post Holder");
	}
	else
	{
		frmDetails.action="HierarchyPostStaffOut.asp";
		frmDetails.submit();
	}
}

function gotoTaskingOverView()
{
	if (parent.frmDetails.allTeams.checked == true)
	{
		allTeams = 1
	}
	else
	{
		allTeams = 0 
	}
	
	document.frmDetails.action="HierarchyTeamTaskingOverview.asp?allTeams=" + allTeams ;

	document.frmDetails.submit();
	window.parent.startTimer()
}

function gotoPersonnelSearch()
{
	document.frmDetails.action="HierarchyPersonnelSearch.asp";
	document.frmDetails.submit();
}

function gotoTeamDetails()
{
	document.frmDetails.action="HierarchyTeamDetail.asp";
	document.frmDetails.submit();
	window.parent.startTimer()
}

</script>

