
<%
' Now we have to check that we can edit/view the details - and it works like this'
' If we are an ADMINISTRATOR then we can do anything - '
' ELSE'
' We MUST be a manager in their Unit or Unit Hierarchy Hierarchy 
' to be able to edit/view all the details - the string strManager will be set accordingly
' 1 = We have permissions to edit/view  0 = We don't 

	set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	objCmd.CommandType = 4	

	if request("hrcID")="" then
	  intHrc=session("hrcID")
	else
	  intHrc= int(request("hrcID"))
	end if
	
	' this holds the Hierarchy ID of the Unit Hierarchy element we just clicked on
	' and we will use this to check that the current user is a manager and authorised to view/edit
	' certain web pages
	session("thisHrcID") = intHrc

    'response.write("Here we are " & session("hrcID") & " * " & session("thisHrcID") & " * " & intHrc)
    'response.End()

        strManager = "0"
	if session("Administrator") = "1" then
		strManager = "1"
	elseif session("UserStatus")  = "1" then  ' they are a manager - but maybe NOT for this Hierarchy so check
		set objPara = objCmd.CreateParameter ("hrcID",3,1,5,session("thisHrcID"))
		objCmd.Parameters.Append objPara  
		set objPara = objCmd.CreateParameter ("staffID",3,1,5, session("StaffID") )
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("Manager",3,2)
		objCmd.Parameters.Append objPara
		

  
		objCmd.CommandText = "spCheckManager"	'Name of Stored Procedure'
		objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
		strManager = objCmd.Parameters("Manager")

		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
    end if
	
	' now get Q Authorisation status
	set objPara = objCmd.CreateParameter ("staffID",3,1,5, session("StaffID") )
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("@authby", 200,2,50)
	objCmd.Parameters.Append objPara
    objCmd.CommandText = "spQsAuthority"	'Name of Stored Procedure'
	objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
	strAuthBy=  objCmd.Parameters("@authby")

		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next

	'response.write ("manager  is " & strManager & " User Status is " & session("UserStatus") & "/" & request("StaffID") & " HrcID is " & session("thisHrcID") & " Auth By is " & strAuthBy)
%>
