var scrollx = document.documentElement.scrollLeft?document.documentElement.scrollLeft:document.body.scrollLeft;
var scrolly = document.documentElement.scrollTop?document.documentElement.scrollTop:document.body.scrollTop;

var ITime = 1800; // = 30 Mins
var ITime = 3600; // = 60 Mins
//var ITime = 50; // = 50 Secs

function setITime(){
	ITime = 1800;	// = 30 Mins
	ITime = 3600;	// = 30 Mins
	//ITime = 50; // = 50 Secs
}

function timer1()
{
	ITime-=1;
	
	
	var IMins=(ITime-(ITime%60))/60;
	var ISecs=ITime%60;
	
	//window.name = IMins + " Min " + ISecs + " Sec";
	//window.status="Your session will end and you will be automatically logged out in: " + IMins + " Min " + ISecs + " Sec";

	document.getElementById('warning').innerHTML =  "Your session will end in "+IMins + " Min " + ISecs + " Sec. Click here to continue.";
	if (IMins==5 & ISecs==0)
	//if (IMins==0 & ISecs==10)
	{
		//alert(1)
		window.focus()
		document.getElementById("warning").style.display = 'block';
		document.getElementById("topmenu").style.display = 'none';
	}
	if (IMins==0 & ISecs==0)
	{
		window.location="logon.asp";
	} 
}

window.setInterval("timer1()",1000);
timer1();

if(document.body.addEventListener){ // most modern browsers
	document.body.addEventListener("click", resettimeout, false);
	document.body.addEventListener("keypress", resettimeout, false);
}
else if(document.attachEvent){ // ie8
	document.attachEvent("onclick",resettimeout);
	document.attachEvent("onkeypress",resettimeout);
}
else{
 	alert("Browser does not support session timeout. Please inform your System Administrator.");
}
 
/*document.attachEvent("onclick",resettimeout);
document.attachEvent("onkeypress",resettimeout);*/

function resettimeout(){
		document.getElementById("warning").style.display = 'none';
		document.getElementById("topmenu").style.display = 'block';
		ITime = 1800;	// = 30 Mins
		ITime = 3600;	// = 30 Mins
		//ITime = 50; // = 50 Secs
		timer1();
		resetsession();
}

function resetsession(){
	var xhr;  
	if (typeof XMLHttpRequest !== 'undefined') {
		xhr = new XMLHttpRequest(); 
	}
	else{  
		var versions = ["MSXML2.XmlHttp.6.0",
						"MSXML2.XmlHttp.5.0",
						"MSXML2.XmlHttp.4.0",
						"MSXML2.XmlHttp.3.0",
						"MSXML2.XmlHttp.2.0",
						"Microsoft.XmlHttp"];
		for(var i = 0; i < versions.length; i++){  
			try{  
				xhr = new ActiveXObject(versions[i]);
				break;  
			}  
			catch(e){}  
		} 
	}
	xhr.onreadystatechange = function(){ 
		if ((xhr.readyState === 4) && (xhr.status === 200)){
				
		}
		else{
			return;
		}
	}
	xhr.open("post","resettimeout.asp",true);
	xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xhr.send('');
	
}