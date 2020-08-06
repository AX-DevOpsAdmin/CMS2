



<div id="sideMenu">
  <ul>
		<li><A title=""  href="cms_hierarchy3.asp?hrcID=<%=session("hrcID")%>">Personnel </A></li>

        <% if session("UserStatus") = "1" or session("administrator") = "1" then %>
         <li><A  href="ManningTaskSearch.asp?dosearch=0">Tasking</A></li>
        <%end if%>
                                                                 
       
        <% if session("authAdmin") = 1 or strAuth=1 or strAuth=2 or strAuth = 14 or strAuth = 11 then %> 
           <li> <a href="#">Authorisations </a>
               <ul>
                   <li><a href="AdminAuthorisor.asp">Authoriser</a></li>            
                <% if session("authAdmin") = 1 or strAuth=1 or strAuth = 14 then %>                  
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
               </ul>   
            </li>
         <%end if %>
                  
        <% if session("Administrator") = "1" then %>
            <li><A  href="AdminDataMenu.asp">Administration</A></li>
        <% end if %>       
  </ul>
 </div>

