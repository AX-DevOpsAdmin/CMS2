<div id="sideMenu">
  <ul>
        <li><A title="" href="index.asp">Home</A></li>

       
        <% if session("authAdmin") = 1 or strAuth=1 or strAuth=2 then %> 
            <li><a href="AdminAuthorisor.asp">Authorisor</a></li>
              
			<% if session("authAdmin") = 1 or strAuth=1 then %>
              
               <li><a  href="AdminAuthTypeList.asp">Authorisation Types</a></li>
               <li><a  href="AdminAuthLevelList.asp">Authorisation Levels</a></li>
               <li><a  href="AdminAuthList.asp">Authorisations</a></li>
            <%end if %>
                
            <li></li>
                
            <li><a href="#">View Audit History</a>
                 <ul>  
                    <li><a href="AdminAuthStaffAudit.asp">Audit by Staff</a></li>
                    <li><a href="AdminAuthCodeAudit.asp">Audit by Auth Code</a></li>
                 </ul>
            </li>

         <%end if %>


  </ul>
 </div>

