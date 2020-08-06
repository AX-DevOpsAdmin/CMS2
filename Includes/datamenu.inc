<div id="sideMenu">

<ul>

        <li><A title="" href="index.asp">Home</A></li>
		<!--
		<li><A title="" href="AdminDataMenu.asp">Static Data</a></li> 
		-->
		<% if session("imxAdmin") = 1 then %>
		   <li><A title="" href="AdminGroupList.asp">Groups</A></li>
		<%end if %>
		<li><A title="" href="AdminHierarchyList.asp">Hierarchy</A></li>
        <!--
		<li><A title="" href="AdminWingList.asp">Wings</A></li>

		<li><a title="" href="AdminSquadronList.asp">Squadrons</a></li>	

		<li><A title="" href="AdminFlightList.asp">Flights</A></li> 
        -->
		<% if session("CMSAdministrator") = 1 then %>
			<li><a href="AdminRankList.asp">Ranks</a>
					<!--
					<ul>  
							<li><a href="AdminRankList.asp">Rank List</a></li>
							<li><a href="AdminRankWtList.asp">Rank Weight</a></li>
					</ul>
					-->
			</li>
		<% end if %>
		<li> 
 			 <a href="#">Trades</a> 
  				<ul>  
    					<li><a href="AdminTradeGroupList.asp">Trade Groups</a></li>
    					<li><a href="AdminTradeList.asp">Trade Lists </a></li>
			</ul>
		</li>
 
		<li>
	 		<a href="#">Qualifications</a> 
  			<ul>  
    					<li><a href="AdminQTypeList.asp">Qualification Types</a></li>
    					<li><a href="AdminQList.asp">Qualifications</a></li>
					<!--<li><a href="AdminQWtList.asp">Q Weight</a></li>-->
			</ul>
		</li>

		<li>
			<a title="" href="#">Tasks</a>
				<ul>
					<li><a title="" href="AdminPsTyList.asp">Task Type</a></li>
					<li><a title="" href="AdminPsTaList.asp">Task Details</a></li>
				</ul>
		</li>
		
        <!--
		<li><a title="" href="AdminTeamList.asp">Teams</a></li>
        -->
		
		<li><a title="" href="AdminMSList.asp">Military Skills</a></li>
		<!--
		<li>
			<a title="" href="#">Military</a>
				<ul>
					<li><a title="" href="AdminMSList.asp">Military Skills</a></li>
					<li><a title="" href="AdminMSWeightingList.asp">Skills Weighting</a></li>
					<% if session("CMSAdministrator") = 1 then %>
						<li><a title="" href="AdminFitnessList.asp">Fitness</a></li>
						<li><a title="" href="AdminVaccinationsList.asp">Vaccinations</a></li>
						<li><a title="" href="AdminDentalList.asp">Dental</a></li>
				    <% end if %>
				</ul>
		</li>
        -->
		
		<li><a title="" href="AdminValPList.asp">Validity Periods</a></li>

		<li><a title="" href="AdminPostList.asp">Posts</a></li>

		<li><a title="" href="AdminPeRsList.asp">Personnel</a></li>
		
		<!--<li><a title="" href="AdminPersAuthList.asp">Authorisation</a></li>-->
		
        <li><a href="#">Harmony Periods</a> 
  				<ul>  
    					<li><a href="AdminHPDetail.asp">Personnel Harmony </a></li>
    					<li><a href="AdminUnitHPDetail.asp">Unit Harmony </a></li>
					
			</ul>
		</li>
		<% if CMSAdmin = 1 then %>
		  <li> 
 			 <a href="#">OOA </a> 
  				<ul>  	
 					<li><a href="AdminooadList.asp">OOA Max Days</a></li>
					<li><a href="AdminHmGlList.asp">Harmony Guidelines</a></li>
					
		        </ul>
		  </li>
		<%end if %>
		
		<li><a title="" href="AdminMESList.asp">Medical Employed Status</a></li>

		<li><a title="" href="AdminSSCList.asp">Separated Service Codes</a></li>
		
		<!--
		<li><a title="" href="AdminCondFList.asp">Conditional Formats</a></li>
	
		<li><a title="" href="AdminGenPW.asp">Change Default Password</a></li>
		-->

		<li><a title="" href="AdminContactList.asp">Contact</a></li>

		<li><a title="" href="AdminConfigList.asp">Configuration</a></li>
		<!--
		<li><a title="" href="UploadExcel.asp">View/Upload Spreadsheet</a></li>
		
		
		<li> 
 			 <a href="#">Cycles</a> 
  				<ul>  
    					<li><a href="AdminCycleList.asp">Cycle List</a></li>
    					<li><a href="AdminCyStageList.asp">Cycle Stages</a></li>
			</ul>
		</li>
         -->
		<% if CMSAdmin = 1 then %>
 			
			<li><a href="AdminAuthorisor.asp">Authorisor</a></li>
			<li> 
 			 <a href="#">Authorisations </a> 
  				<ul>  	
 					<li><a href="AdminAuthTypeList.asp">Authorisation Types</a></li>
					<li><a href="AdminAuthList.asp">Authorisations</a></li>
					
		        </ul>
		    </li>
		<%end if %>
		<li> </li>
		<li> </li>
		<li><a title="" href="javascript:sysadminguide()">System Administrator Guide</a></li>
		<li> </li>
		<li> </li>
		<li> </li>
		<li> </li>
		<li> </li>
		<li> </li>
		<li> </li>
        <li> </li>
		<li> </li>
	    <li> </li>
		<li> </li>
		<li> </li>
		<li> </li>
	
	</ul>
</div>