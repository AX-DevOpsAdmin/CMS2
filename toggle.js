// JavaScript Document

function toggle(showHideDiv, switchImgTag, mainDiv){
	var ele = document.getElementById(showHideDiv);
	var imageEle = document.getElementById(switchImgTag);
	var divs = document.getElementById(mainDiv).getElementsByTagName('DIV')
	
	var imgID;
	
	//alert("toggle " + showHideDiv + " * " +  switchImgTag + " * " +	 mainDiv);
	
	if(ele.style.display == "block")
	{
		ele.style.display = "none";
		imageEle.getElementsByTagName('img')[0].src = 'images/plus.gif';
	}

	else
	{
		for(var x = 0; x < divs.length; x++)
		{
			if(divs[x].id == 'A1' ||divs[x].id == 'A2' ||divs[x].id == 'A3')
			{
				divs[x].style.display = 'none';
				imgID=divs[x].id+'Icon';
				//alert("image is  " + imgID + " * " + x + " * " + divs[x].id);
				document.getElementById(divs[x].id+'Icon').src = 'images/plus.gif';
			}
		}
		ele.style.display = "block";
		imageEle.getElementsByTagName('img')[0].src = 'images/minus.gif';
	}
	
}

