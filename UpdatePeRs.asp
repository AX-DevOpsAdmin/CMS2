<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
dim strCommand
dim strAction
dim strGoTo
dim alreadyExists

'response.write(request("strAction"))
'response.end()

alreadyExists = 0
strArriveDate = request("txtarrival")
strPostDate = request("txtposting")
strPassPortDate = request("txtexpiry")
strWelfareDate = request("txthandbook")
strDOB = request("txtdob")
strOOA = request("txtooa")
strDSG = request("txtdischarge")

strRankID = request("cmbRank")
strTradeID = cInt(request("cmbTrade"))
strMESID = request("cmbmes")

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4				

strGoto=request("strGoTo") & "?staffID=" & request("staffID")
	
' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one
strAction=request("strAction")
strAdmin = request("administrator")

if strAction = "Add" then
    ' Check if Service No exists
	objCmd.CommandText = "spCheckIfServiceNoExists"
    set objPara = objCmd.CreateParameter ("ServiceNo",200,1,100, request("txtserviceno"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("alreadyExists",3,2,0, 0)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("nodename",200,2,50)
	objCmd.Parameters.Append objPara
	
	objCmd.Execute
	alreadyExists = objcmd.parameters ("alreadyExists")
	
	if alreadyExists=2 then
	   strCMS=" " & objcmd.parameters ("nodename")& " CMS "
	end if
	   
	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
'
'	' if we are an administrator then we will have entered Yes or No in their Administrator field
'	if session("Administrator") = "1" then
'		strAdmin = request("cbadmin")
'	else
'		strAdmin = "0"
'	end if
end if

    'response.write ("Update Staff " & request("administrator") & " * " & request("staffID") & " * " & strGoTo & " * " & strAction)
    'response.End()

if cint(alreadyExists) = 0 then

	' Here its UPDATE so pass the Record ID AND whether or not we just made him administrator
	if strAction = "Update" then
		strCommand = "spPeRsUpdate"
	    set objPara = objCmd.CreateParameter ("staffid",3,1,0, request("staffID"))
		objCmd.Parameters.Append objPara
    else
	    strCommand = "spPeRsInsert"
	    set objPara = objCmd.CreateParameter ("nodeID",200,1,50, nodeID)
        objCmd.Parameters.Append objPara 
	end if
    objCmd.CommandText = strCommand
	
	' Now set the common parameters
	set objPara = objCmd.CreateParameter ("ServiceNo",200,1,100, request("txtserviceno"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("FirstName",200,1,100, request("txtfirstname"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("Surname",200,1,100, request("txtsurname"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("Rank",3,1,0, strRankID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("Trade",3,1,0, strTradeID)
	objCmd.Parameters.Append objPara
	if request("txtknownas") <> "" then
	  set objPara = objCmd.CreateParameter ("KnownAs",200,1,100, request("txtknownas"))
	else
	  set objPara = objCmd.CreateParameter ("KnownAs",200,1,100, null)
	end if
	objCmd.Parameters.Append objPara

	set objPara = objCmd.CreateParameter ("Administrator",3,1,0, strAdmin)
	objCmd.Parameters.Append objPara

	
'	if  request("txthphone") <> "" then
'		set objPara = objCmd.CreateParameter ("HomePhone",200,1,100, request("txthphone"))
'	else
'		set objPara = objCmd.CreateParameter ("HomePhone",200,1,100, null)
'	end if   
'	objCmd.Parameters.Append objPara
'	
'	if request("txtmobile") <> "" then
'		set objPara = objCmd.CreateParameter ("Mobile",200,1,100, request("txtmobile"))
'	else
'		set objPara = objCmd.CreateParameter ("Mobile",200,1,100, null)
'	end if   
'	objCmd.Parameters.Append objPara
'	
'	if request("txtWorkPhone") <> "" then
'		set objPara = objCmd.CreateParameter ("workPhone",200,1,100, request("txtWorkPhone"))
'	else
'		set objPara = objCmd.CreateParameter ("workPhone",200,1,100, null)
'	end if   
'	objCmd.Parameters.Append objPara
'	
'	if request("txtpob") <> "" then  
'		set objPara = objCmd.CreateParameter ("POB",200,1,100, request("txtpob"))
'	else
'		set objPara = objCmd.CreateParameter ("POB",200,1,100, null)
'	end if   
'	objCmd.Parameters.Append objPara
'	  
'	if request("txtpptno") <> "" then
'		set objPara = objCmd.CreateParameter ("PassPortNo",200,1,100, request("txtpptno"))
'	else
'		set objPara = objCmd.CreateParameter ("PassPortNo",200,1,100, null)
'	end if   
'	objCmd.Parameters.Append objPara
'	
'	if request("txtissueby") <> "" then
'		set objPara = objCmd.CreateParameter ("PassportIssueBy",200,1,100, request("txtissueby"))
'	else
'		set objPara = objCmd.CreateParameter ("PassportIssueBy",200,1,100, null)
'	end if
'	objCmd.Parameters.Append objPara
'	
'	if request("txtpoc") <> "" then
'		set objPara = objCmd.CreateParameter ("WelfarePOC",200,1,100, request("txtpoc"))
'	else
'		set objPara = objCmd.CreateParameter ("WelfarePOC",200,1,100, null)
'	end if
'	objCmd.Parameters.Append objPara
'	
'	if request("txtwwishes") <> "" then
'		set objPara = objCmd.CreateParameter ("WelfareWishes",200,1,500, request("txtwwishes"))
'	else
'		set objPara = objCmd.CreateParameter ("WelfareWishes",200,1,100, null)
'	end if
'	objCmd.Parameters.Append objPara
'	   
'	if request("txtnotes") <> "" then  
'		set objPara = objCmd.CreateParameter ("Notes",200,1,500, request("txtnotes"))
'	else
'		set objPara = objCmd.CreateParameter ("Notes",200,1,100, null)
'	end if   
'	objCmd.Parameters.Append objPara
'	
'	set objPara = objCmd.CreateParameter ("ArrivalDate",200,1,20, strArriveDate)
'	objCmd.Parameters.Append objPara
'	
'	if strPostDate <> "" then
'		set objPara = objCmd.CreateParameter ("PostingDate",200,1,20, strPostDate)
'	else
'		set objPara = objCmd.CreateParameter ("PostingDate",200,1,100, null)
'	end if   
'	objCmd.Parameters.Append objPara
'	
'	if strOOA <> "" then
'		set objPara = objCmd.CreateParameter ("OOADate",200,1,20, strOOA)
'	else
'		set objPara = objCmd.CreateParameter ("OOADate",200,1,100, null)
'	end if   
'	objCmd.Parameters.Append objPara
'	
'	if strDSG <> "" then
'		set objPara = objCmd.CreateParameter ("dischargeDate",200,1,20, strDSG)
'	else
'		set objPara = objCmd.CreateParameter ("dischargeDate",200,1,100, null)
'	end if 
'	objCmd.Parameters.Append objPara
'	
'	if strPassPortDate <> "" then
'		set objPara = objCmd.CreateParameter ("PassportDate",200,1,20, strPassPortDate)
'	else
'		set objPara = objCmd.CreateParameter ("PassportDate",200,1,100, null)
'	end if   
'	objCmd.Parameters.Append objPara
'	
'	if strWelfareDate <> "" then
'		set objPara = objCmd.CreateParameter ("WelfareDate",200,1,20, strWelfareDate)
'	else
'		set objPara = objCmd.CreateParameter ("WelfareDate",200,1,100, null)
'	end if 
'	objCmd.Parameters.Append objPara
'	
'	set objPara = objCmd.CreateParameter ("Sex",200,1,1, request("cmbGender"))
'	objCmd.Parameters.Append objPara
'	
'	if strDOB <> "" then
'		set objPara = objCmd.CreateParameter ("dob",200,1,100, strDOB)
'		objCmd.Parameters.Append objPara
'	else
'		set objPara = objCmd.CreateParameter ("dob",200,1,100, null)
'		objCmd.Parameters.Append objPara
'	end if   
'	
'	if strMESID <> "" then
'		set objPara = objCmd.CreateParameter ("MES",3,1,0, strMESID)
'	else
'		set objPara = objCmd.CreateParameter ("MES",3,1,0, null)
'	end if 
'	objCmd.Parameters.Append objPara
'	
'	if request("txtWeaponNo") <> "" then
'		set objPara = objCmd.CreateParameter ("weaponNo",200,1,15, request("txtWeaponNo"))
'	else
'		set objPara = objCmd.CreateParameter ("weaponNo",200,1,15, null)
'	end if
'	objCmd.Parameters.Append objPara
'	
'	if request("chkSusat") = 1 then
'		set objPara = objCmd.CreateParameter ("susat",11,1,1, 1)
'	else
'		set objPara = objCmd.CreateParameter ("susat",11,1,1, 0)
'	end if
'	objCmd.Parameters.Append objPara
'	
	' Here its ADD so we need the passowrd and staffid back from the stored procedure
	if strAction = "Add" then
	
		set objPara = objCmd.CreateParameter ("@randomWord",200,&H0002,9)
		objCmd.Parameters.Append objPara
		
		set objPara = objCmd.CreateParameter ("@staffID",3,&H0002,4)
		objCmd.Parameters.Append objPara
	
	end if

    'response.write ("Update Staff " & request("administrator") & " * " & request("staffID") & " * " & strGoTo & " * " & strAction)
    'response.End()

	objCmd.Execute	''Execute CommandText when using "ADODB.Command" object
	
	con.close
	set con=Nothing
	
	'response.Write(request("strAction"))
	'response.end()
	'response.redirect("AdminPeRsDetail.asp?RecID="&ObjCmd.Parameters("@staffID"))
	if strAction = "Add" then

	%>
    <html>
	<Body>
        <form name=frmDetails action="AdminPeRsDetail.asp"  method="POST">
            <input type=hidden name='staffID' id='staffID' value="<%= ObjCmd.Parameters("@staffID")%>">
            <input type=hidden name='randomWord' id='randomWord'  value="<%=ObjCmd.Parameters("@randomWord")%>">
        </form>
        <%=recID%>
        <SCRIPT LANGUAGE="JavaScript">
        	document.forms["frmDetails"].submit();
        </script>
    </Body>
	</html>
    <%else
		response.redirect(strGoto)
	end if
else
	%>
	<html>
	<Body>
	<form name=frmDetails action="AdminPeRsAdd.asp"  method="POST">
	<input type=hidden name=txtfname id="txtfname" value="<%=request("txtfirstname")%>">
	<input type=hidden name=txtsname id="txtsname" value="<%=request("txtsurname")%>">
	<input type=hidden name=txtserviceno id="txtserviceno" value="<%=request("txtserviceno")%>">
    
    <input type=hidden name=cmbRank id="cmbRank" value="<%=request("cmbRank")%>">
	<input type=hidden name=cmbTrade id="cmbTrade" value="<%=request("cmbTrade")%>">
    <input type=hidden name=txtknownas id="txtknownas" value="<%=request("txtknownas")%>">
    
    <input type=hidden name=alreadyExists id="alreadyexists" value="<%=alreadyExists%>">
    <input type=hidden name=strCMS id="strCMS" value="<%=strCMS%>">
    
    

<!--
	<input type=hidden name=administrator id="administrator"  value="<%'=request("administrator")%>">

	<input type=hidden name=txthphone id="txthphone" value="<%'=request("txthphone")%>">
	<input type=hidden name=txtmobile id="txtmobile" value="<%'=request("txtmobile")%>">
	<input type=hidden name=txtpob id="txtpob" value="<%'=request("txtpob")%>">
	<input type=hidden name=txtpptno id="txtpptno"  value="<%'=request("txtpptno")%>">
	<input type=hidden name=txtissueby id="txtissueby" value="<%'=request("txtissueby")%>">
	<input type=hidden name=txtpoc id="txtpoc" value="<%'=request("txtpoc")%>">
	<input type=hidden name=txtwwishes id="txtwwishes" value="<%'=request("txtwwishes")%>">
	<input type=hidden name=txtnotes id="txtnotes" value="<%'=request("txtnotes")%>">
	<input type=hidden name="txtarrival" id="txtarrival" value="<%'=request("txtarrival")%>">
	<input type=hidden name="txtposting" id="txtposting" value="<%'=request("txtposting")%>">
	<input type=hidden name="txtexpiry" id="txtexpiry"  value="<%'=request("txtexpiry")%>">
	<input type=hidden name="txthandbook" id="txthandbook"  value="<%'=request("txthandbook")%>">
	<input type=hidden name="txtdob" id="txtdob" value="<%'=request("txtdob")%>">
    <input type=hidden name="cmbGender" id="cmbGender" value="<%'=request("cmbGender")%>">
	<input type=hidden name=duplicateServiceNo id="duplicateServiceNo" value=1>
 -->
	</form>
    
	<SCRIPT LANGUAGE="JavaScript">
	document.forms["frmDetails"].submit();
	</script>
	</Body>
	</html>
<%end if%>
