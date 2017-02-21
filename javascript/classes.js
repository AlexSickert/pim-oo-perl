
var globalSession;
var globalUser;

// --------------------------------------------------------------------------------------------------------------
// use content id an show content
// --------------------------------------------------------------------------------------------------------------
function classesPopContentById(id, type){
	//alert(id + "..." + type);
	//var globalSession = '7TlrwwXMEStGHGMXRiHyA5j8i3JL0iGMM04Mknq8JFBRL3oXj0s';
	//var globalUser = 'haselmax';
	if(type == 1){
		baseShowPopMail(id, globalSession , globalUser );
	}

}

// --------------------------------------------------------------------------------------------------------------
// create a new window without toolbar and show mail
// --------------------------------------------------------------------------------------------------------------
function baseShowPopMail(id, vs, vu){
	var url;
	url = "../mail/showMail.pl?v_u=" + vu + "&v_s=" + vs + "&mailId=" + id;
	showPop (url);
}

// --------------------------------------------------------------------------------------------------------------

function setBusy(){
   document.getElementById('loadcheck').style.backgroundColor = "#FF0000";
}

// --------------------------------------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------------------------------------

function setIdle(){
   document.getElementById('loadcheck').style.backgroundColor = "#00FF00";
}

// --------------------------------------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------------------------------------

function setContent(id, ContentString){
	document.getElementById(id).innerHTML = ContentString;
}

// --------------------------------------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------------------------------------

function getUrlParameter(param) {
	var hier = document.URL;
	var parameterzeile = hier.substr((hier.indexOf("?")+1), 500000);
	var trennpos;
	var endpos;
	var paramname;
	var paramwert;
	var returnValue;
        returnValue = "";
	while (parameterzeile != "") {
                trennpos = parameterzeile.indexOf("=");
		endpos = parameterzeile.indexOf("&");
		if (endpos < 0) { endpos = 500000 }
		
		paramname = parameterzeile.substr(0,trennpos);
		paramwert = parameterzeile.substring(trennpos+1,endpos);
		
                //alert(paramname );
                //alert(paramwert );
		//alert('|'+param +'=='+ paramname+'|');
		if(param == paramname){
			returnValue = paramwert;
		}
		
		//eval (paramname + " = \"" + paramwert + "\"");
		parameterzeile = parameterzeile.substr(endpos+1);
	}
	//alert(returnValue );
	return returnValue;
}

// --------------------------------------------------------------------------------------------------------------
// resize a container to a specific size
// difference to the other maximized functions is that the others use only as much sapce as necessary
// --------------------------------------------------------------------------------------------------------------

function positionContainerMaximised(divTag, topPixel, rightPixel, bottomPixel, leftPixel){
// todo
}

// --------------------------------------------------------------------------------------------------------------
// make a container the size of its child but only if enough space left 
// if not then create scroll bars
// the problem with the mail windwos is that the size of the table is not always the same
// at the beginning the size is zero because the table is not loaded. later the div tag size is fixed and the table size
// distorted - this is very bad... therefore here a new approach
// --------------------------------------------------------------------------------------------------------------

function positionContainerMaximisedWithChild(containerTag, childTag, topPixel, rightPixel, bottomPixel, leftPixel){
// todo
}

// --------------------------------------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------------------------------------

function positionContainerAbsolut(divTag, verticalOrientation, horizontalOrientation, spaceLeft, spaceRight, spaceTop,spaceBottom){
   var theObject;
//alert("sss");
   try {
   try {
      theObject  = document.getElementById(divTag)
   }catch(e){
      alert("could not find: " + divTag);
   }
   var screenWidth = 0;
   var screenHeight = 0;
   var newTop = 100;
   var newLeft = 100;
   var newWidth = 100;
   var newHeight = 100;
   try { if(screenHeight < document.body.clientHeight){ screenHeight = document.body.clientHeight;}; } catch (e) {  };
   try { if(screenHeight < window.innerHeight){ screenHeight = window.innerHeight;}; } catch (e) {  };
   try { if(screenHeight <  document.documentElement.clientHeight){ screenHeight = document.documentElement.clientHeight;}; } catch (e) {  };
   try { if(screenWidth < document.body.clientWidth){ screenWidth = document.body.clientWidth;}; } catch (e) {  };
   try { if(screenWidth < window.innerWidth){ screenWidth = window.innerWidth;}; } catch (e) {  };
   try { if(screenWidth < document.documentElement.clientWidth){ screenWidth = document.documentElement.clientWidth;}; } catch (e) {  };
   var theObjectWidthString = theObject.offsetWidth + "";
   var theObjectWidth = 100;
   var theObjectWidthString2 = theObjectWidthString.replace(/px/, "");
   theObjectWidth  = theObjectWidthString2 * 1;
   // for IE only - add some pixel to prevent scrollbars
   //alert(theObjectWidth);
   theObjectWidth  = theObjectWidth  + 100;
   //alert(divTag + " = " + theObjectWidth);
   //theObject.style.width = theObjectWidth + "px";
   var theObjectHeightString = theObject.offsetHeight + "";
   var theObjectHeight = 100;
   var theObjectHeightString2 = theObjectHeightString.replace(/px/, "");
   theObjectHeight = theObjectHeightString2 * 1;
   newHeight = screenHeight - (spaceTop + spaceBottom);
   newWidth = screenWidth - (spaceLeft + spaceRight);
   //alert(screenWidth );
   // compare object size with available space and if available space is smaller then se the smaller size
   if(theObjectWidth > newWidth ){
      theObject.style.width = newWidth + "px";
      theObject.style.overflow = "auto";
      theObjectWidth = newWidth;
      //alert(theObjectWidth + " --" +  newWidth );
   }else{
//      theObject.style.width = theObjectWidth  + "px";
//      theObject.style.overflow = "auto";
//      theObjectWidth = theObjectWidth;
   }
   if(theObjectHeight > newHeight ){
      theObject.style.height = newHeight + "px";
      theObjectHeight = newHeight;
      theObject.style.overflow = "auto";
   }else{

   }
   /// vertical position
   res = verticalOrientation.match(/TOP/g);    
   if(res){ newTop = spaceTop ; };
   res = verticalOrientation.match(/BOTTOM/g);    
   if(res){ newTop = screenHeight - spaceBottom - (newHeight / 2); };
   res = verticalOrientation.match(/CENTER/g);    
   if(res){ newTop = spaceTop + ((screenHeight - (spaceTop + spaceBottom))/2) - (theObjectHeight / 2); };
   // horizontal position
   res = horizontalOrientation.match(/LEFT/g);    
   if(res){ newLeft = spaceLeft ; };
   res = horizontalOrientation.match(/RIGHT/g);    
   if(res){ newLeft = screenWidth - spaceRight - (newWidth / 2); };
   res = horizontalOrientation.match(/CENTER/g);    
   if(res){ newLeft = spaceLeft + ((screenWidth - (spaceLeft + spaceRight ))/2) - (theObjectWidth / 2); };
   theObject.style.left = newLeft + "px";
   theObject.style.top = newTop + "px";
   //alert("spaceRight : " + spaceRight );

	//alert(divTag + " top: " + newTop  + " left: " + newLeft );

   }catch(err)	  {
	alert("error when positioning id: " + divTag + " error: " + err.description);
}
    
   return true;
}
// --------------------------------------------------------------------------------------------------------------
//  positionContainerAbsolutMax - same function like function before but this time maximized to max size
// --------------------------------------------------------------------------------------------------------------

function positionContainerAbsolutMax(divTag, verticalOrientation, horizontalOrientation, spaceLeft, spaceRight, spaceTop,spaceBottom){
   var theObject;
//alert("sss");
   try {
   try {
      theObject  = document.getElementById(divTag)
   }catch(e){
      alert("could not find: " + divTag);
   }
   var screenWidth = 0;
   var screenHeight = 0;
   var newTop = 100;
   var newLeft = 100;
   var newWidth = 100;
   var newHeight = 100;
   try { if(screenHeight < document.body.clientHeight){ screenHeight = document.body.clientHeight;}; } catch (e) {  };
   try { if(screenHeight < window.innerHeight){ screenHeight = window.innerHeight;}; } catch (e) {  };
   try { if(screenHeight <  document.documentElement.clientHeight){ screenHeight = document.documentElement.clientHeight;}; } catch (e) {  };
   try { if(screenWidth < document.body.clientWidth){ screenWidth = document.body.clientWidth;}; } catch (e) {  };
   try { if(screenWidth < window.innerWidth){ screenWidth = window.innerWidth;}; } catch (e) {  };
   try { if(screenWidth < document.documentElement.clientWidth){ screenWidth = document.documentElement.clientWidth;}; } catch (e) {  };
   var theObjectWidthString = theObject.offsetWidth + "";
   var theObjectWidth = 100;
   var theObjectWidthString2 = theObjectWidthString.replace(/px/, "");
   theObjectWidth  = theObjectWidthString2 * 1;
   // for IE only - add some pixel to prevent scrollbars
   //alert(theObjectWidth);
   theObjectWidth  = theObjectWidth  + 100;
   //alert(divTag + " = " + theObjectWidth);
   //theObject.style.width = theObjectWidth + "px";
   var theObjectHeightString = theObject.offsetHeight + "";
   var theObjectHeight = 100;
   var theObjectHeightString2 = theObjectHeightString.replace(/px/, "");
   theObjectHeight = theObjectHeightString2 * 1;
   newHeight = screenHeight - (spaceTop + spaceBottom);
   newWidth = screenWidth - (spaceLeft + spaceRight);
   //alert(screenWidth );
   // compare object size with available space and if available space is smaller then se the smaller size

   theObject.style.width = newWidth + "px";
   theObject.style.overflow = "auto";
   theObjectWidth = newWidth;
   //alert(theObjectWidth + " --" +  newWidth );


   theObject.style.height = newHeight + "px";
   theObjectHeight = newHeight;
   theObject.style.overflow = "auto";

   /// vertical position
   res = verticalOrientation.match(/TOP/g);    
   if(res){ newTop = spaceTop ; };
   res = verticalOrientation.match(/BOTTOM/g);    
   if(res){ newTop = screenHeight - spaceBottom - (newHeight / 2); };
   res = verticalOrientation.match(/CENTER/g);    
   if(res){ newTop = spaceTop + ((screenHeight - (spaceTop + spaceBottom))/2) - (theObjectHeight / 2); };
   // horizontal position
   res = horizontalOrientation.match(/LEFT/g);    
   if(res){ newLeft = spaceLeft ; };
   res = horizontalOrientation.match(/RIGHT/g);    
   if(res){ newLeft = screenWidth - spaceRight - (newWidth / 2); };
   res = horizontalOrientation.match(/CENTER/g);    
   if(res){ newLeft = spaceLeft + ((screenWidth - (spaceLeft + spaceRight ))/2) - (theObjectWidth / 2); };
   theObject.style.left = newLeft + "px";
   theObject.style.top = newTop + "px";
   //alert("spaceRight : " + spaceRight );

	//alert(divTag + " top: " + newTop  + " left: " + newLeft );

   }catch(err)	  {
	alert("error when positioning id: " + divTag + " error: " + err.description);
}
    
   return true;
}
// --------------------------------------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------------------------------------

function positionContainerPercent(divTag, percentLeft, percentTop, percentWidth){
	positionContainerPercentPos(divTag, percentLeft, percentTop, percentWidth, 'top-left');
}

// --------------------------------------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------------------------------------

function positionContainerPercentPos(divTag, percentLeft, percentTop, percentWidth, pos){
	var theObject = document.getElementById(divTag)
    var screenWidth = 0;
    var screenHeight = 0;
    var newObjectWidth;
    var newObjcetTopOffset;
    var newObjectLeftOffset;
    var res;
    try { if(screenHeight == 0){ screenHeight = document.body.clientHeight;}; } catch (e) { screenHeight = 0; };
    try { if(screenHeight == 0){ screenHeight = window.innerHeight;}; } catch (e) { screenHeight = 0; };
    try { if(screenHeight == 0){ screenHeight = document.documentElement.clientHeight;}; } catch (e) { screenHeight = 700; };
    try { if(screenWidth == 0){ screenWidth = document.body.clientWidth;}; } catch (e) { screenWidth = 0; };
    try { if(screenWidth == 0){ screenWidth = window.innerWidth;}; } catch (e) { screenWidth = 0; };
    try { if(screenWidth == 0){ screenWidth = document.documentElement.clientWidth;}; } catch (e) { screenWidth = 1000; };
	var divObjectWidth = theObject.offsetWidth;
	var divObjectHeight = theObject.offsetHeight;
    
    //alert("screen width: " + screenWidth + " screen height:  " + screenHeight);
    
    if(percentWidth == 0){
        newObjectWidth = ((100-percentLeft)/100) * screenWidth;
    }else{
        newObjectWidth = (percentWidth / 100) * screenWidth;
    }
    
    theObject.style.width = newObjectWidth + "px";
    //alert("breite des divs: " + divObjectWidth);
    //alert("höhe des divs: " + divObjectHeight);
       
    res = pos.match(/top-left/g);
    
    if(res){
        newObjcetTopOffset = (screenHeight * (percentTop / 100));
        newObjectLeftOffset = (screenWidth * (percentLeft / 100));    
    }
    
    res = pos.match(/center-center/g);
    
    if(res){
        
        newObjcetTopOffset = (screenHeight * (percentTop / 100)) - (0.5 * divObjectHeight);
        if(newObjcetTopOffset < 0){
            newObjcetTopOffset = 0;        
        }        
        newObjectLeftOffset = (screenWidth * (percentLeft / 100)) - (0.5 * divObjectWidth); 
        if(newObjectLeftOffset < 0){
            newObjectLeftOffset = 0;        
        }          
        //alert('center-center');        
    }  
    // top-center
    
    res = pos.match(/top-center/g);
    
    if(res){
        
        newObjcetTopOffset = (screenHeight * (percentTop / 100)) ;
        if(newObjcetTopOffset < 0){
            newObjcetTopOffset = 0;        
        }
        newObjectLeftOffset = (screenWidth * (percentLeft / 100)) - (0.5 * divObjectWidth); 
        if(newObjectLeftOffset < 0){
            newObjectLeftOffset = 0;        
        }        
        //alert('center-center');        
    } 
	theObject.style.left = newObjectLeftOffset + "px";
	theObject.style.top = newObjcetTopOffset + "px";
    
	return true;
}

// --------------------------------------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------------------------------------

function showPop (Adresse) {
  var win = "window_" + Math.round(Math.random() * 10000);
  var forEval = win + "= window.open('" + Adresse + "', '" + win + "', 'width=800,height=600,left=100,top=200,scrollbars=yes');";
  //alert(forEval );
  eval(forEval );
  var forEval = win + ".focus();";
  eval(forEval );
}

// --------------------------------------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------------------------------------

function action_opener(x)
{
        window.open(x,"Actions","resizable=yes,scrollbars=yes, widht=950, height=700");        
};
// --------------------------------------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------------------------------------

function window_opener(x,y)
{
        window.open(x,y,"resizable=yes,scrollbars=yes, widht=950, height=700");        
};
// --------------------------------------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------------------------------------

function jumpToPage(loc){
    //alert("moving to: " + loc);
    window.location.href = loc;
}

// --------------------------------------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------------------------------------

function sendMyForm(){	
   var inputstring;
   if(document.myform.datei){
   inputstring = document.myform.datei.value;
   
   var input_array = inputstring.split("\\");
   document.myform.dateiname.value = input_array[input_array.length -1 ];
   //alert(document.myform.dateiname.value);
   }
   document.myform.submit();
}

// --------------------------------------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------------------------------------

function maximizeWindow(){
	//alert("asdfasdf");
	var offset = (navigator.userAgent.indexOf("Mac") != -1 || navigator.userAgent.indexOf("Gecko") != -1 ||  navigator.appName.indexOf("Netscape") != -1) ? 0 : 4;
	window.moveTo(-offset, -offset);
	if(screen.availWidth > 1200){
		window.resizeTo(1000, 600);
	}else{
		window.resizeTo(screen.availWidth + (2 * offset), screen.availHeight + (2 * offset));
	}
}

// --------------------------------------------------------------------------------------------------------------
// bottom of id
// --------------------------------------------------------------------------------------------------------------

function getSouthPosition(id){
}

// --------------------------------------------------------------------------------------------------------------
// top side of id
// --------------------------------------------------------------------------------------------------------------

function getNorthPosition(id){
// todo
}

// --------------------------------------------------------------------------------------------------------------
// left side of id
// --------------------------------------------------------------------------------------------------------------

function getWestPosition(id){
// todo
}

// --------------------------------------------------------------------------------------------------------------
// gets the horizontal value of an id x - position - the right side
// --------------------------------------------------------------------------------------------------------------

function getEastPosition(id){
// todo
}

// --------------------------------------------------------------------------------------------------------------
// make ement same size as parent - 100% same siz. necessary because text areas have difficulties
// --------------------------------------------------------------------------------------------------------------

function fitIntoParent(id){
// todo
}

// --------------------------------------------------------------------------------------------------------------
// simple sort function to sort tables - needs only a reference to a td and the way to sort
// --------------------------------------------------------------------------------------------------------------

function coreSimpleTableSort(tdObj, columnPos, sortMethod){
	//alert(sortMethod);
	coreLogInfo("starting sort - 1");
	// use the tdObj and go to parents until table element 
	// we are a TD so two levels up would be either tablebody or table
	
	//alert("tableId: " + tableId + " columnPos: " + columnPos + " method: " + sortMethod);
	
	//var tableObject = document.getElementById(tableId);
	var tableObject = tdObj.parentNode.parentNode;
	var rows = tableObject.getElementsByTagName("tr");
	var rowArray = [];
	var headRow = rows[0];
	
//	alert(rows.length);
//	alert(rows.length);
	
	for (var i=1; i<rows.length; i++) {
		//rowArray[rowArray.length] = [rows[i].getElementsByTagName("td")[columnPos].firstChild.data, rows[i]];
//		alert(i);
//		alert(rows[i].getElementsByTagName("td").length);
		if(rows[i].getElementsByTagName("td").length > 0){
			rowArray[rowArray.length] = [rows[i].getElementsByTagName("td")[columnPos].innerHTML, rows[i]];
		}
	}
	coreLogInfo("created index - 2");
	coreLogInfo("now sorting - 3");
	if(sortMethod.match(/s/gi)){
		rowArray.sort(coreSortByString);
	}
	if(sortMethod.match(/n/gi)){
		rowArray.sort(coreSortByNumber);
	}
	if(sortMethod.match(/d/gi)){
		rowArray.sort(coreSortByString);
	}
	var l = tableObject.getElementsByTagName("tr").length;
	var rowParent = tableObject.getElementsByTagName("tr")[0].parentNode;
	coreLogInfo("removing old elements - 4");
	for (var i=0; i<l; i++) {
		tableObject.getElementsByTagName("tr")[0].parentNode.removeChild(tableObject.getElementsByTagName("tr")[0]); 
	}
	rowParent.appendChild(headRow);
	coreLogInfo("adding new elements - 5");
	for (var i=0; i<rowArray.length; i++) {
		rowParent.appendChild(rowArray[i][1]);
	}
	coreLogInfo("adding new elements - 6 - finish");
}

// -------------------------------------------------------------------------------
// xxxx
// -------------------------------------------------------------------------------
  function coreSortByNumber(a,b) {
    aa = parseFloat(a[0].replace(/[^0-9.-]/g,''));
    if (isNaN(aa)) aa = 0;
    bb = parseFloat(b[0].replace(/[^0-9.-]/g,'')); 
    if (isNaN(bb)) bb = 0;
    return aa-bb;
  }

// -------------------------------------------------------------------------------
// xxxx
// -------------------------------------------------------------------------------
  function coreSortByString(a,b) {
    if (a[0]==b[0]) return 0;
    if (a[0]<b[0]) return -1;
    return 1;
  };
// -------------------------------------------------------------------------------
// xxxx
// -------------------------------------------------------------------------------
  function coreSortByDateDDMM(a,b) {
    mtch = a[0].match(sorttable.DATE_RE);
    y = mtch[3]; m = mtch[2]; d = mtch[1];
    if (m.length == 1) m = '0'+m;
    if (d.length == 1) d = '0'+d;
    dt1 = y+m+d;
    mtch = b[0].match(sorttable.DATE_RE);
    y = mtch[3]; m = mtch[2]; d = mtch[1];
    if (m.length == 1) m = '0'+m;
    if (d.length == 1) d = '0'+d;
    dt2 = y+m+d;
    if (dt1==dt2) return 0;
    if (dt1<dt2) return -1;
    return 1;
  };
// -------------------------------------------------------------------------------
// xxxx
// -------------------------------------------------------------------------------
  function coreSortByDateMMDD(a,b) {
    mtch = a[0].match(sorttable.DATE_RE);
    y = mtch[3]; d = mtch[2]; m = mtch[1];
    if (m.length == 1) m = '0'+m;
    if (d.length == 1) d = '0'+d;
    dt1 = y+m+d;
    mtch = b[0].match(sorttable.DATE_RE);
    y = mtch[3]; d = mtch[2]; m = mtch[1];
    if (m.length == 1) m = '0'+m;
    if (d.length == 1) d = '0'+d;
    dt2 = y+m+d;
    if (dt1==dt2) return 0;
    if (dt1<dt2) return -1;
    return 1;
  };
// -------------------------------------------------------------------------------
// simple logger - needs a div tag
// -------------------------------------------------------------------------------

function coreLogInfo(s){
	try{
		var logDiv = document.getElementById('logDiv');
		var content = logDiv.innerHTML;
		var maxLength = 3000;
		var contentArr = [];
		var brTag = "<br>";
		//alert(content);
		if(content.length > maxLength){
			//content = content.substring(content.length-maxLength, content.length);
			contentArr = content.split(brTag);
			var arrLength = contentArr.length;
			//alert(arrLength);
			var contentNew = "";
	
			for(var i = arrLength-1; i > 0; i--){
				if(contentNew.length < maxLength){
					//contentNew = contentNew + brTag + contentArr[i];
					contentNew =  brTag +contentArr[i]  + contentNew;
				}
			}
	
			content = contentNew;
			
		}
		var Jetzt = new Date();
		//alert(Jetzt.toGMTString());
		content = content + brTag + Jetzt.toGMTString() + " Info: " + s;
		logDiv.innerHTML = content;
	}catch(e){
		alert("error writing to logger (" + s + "): " + e);
	}
}

// -------------------------------------------------------------------------------
// LOGGING
// -------------------------------------------------------------------------------

function logInfo(s){
	coreLogInfo(s);
//	showHideLog();
}

// -------------------------------------------------------------------------------
// LOGGING - shor and hid the layer
// -------------------------------------------------------------------------------

function showHideLog(){
	//alert("showing log");
	var id = 'logDiv';
	var testSTring = document.getElementById(id).style.display;
	var result = testSTring.match(/inline/gi);	
	if(result){
		hideDiv(id);
	}else{
		showDiv(id);		
	}
	positionContainerAbsolut(id,"CENTER","CENTER",200,200,200,200);
}

// -------------------------------------------------------------------------------
// set div to mouse
// -------------------------------------------------------------------------------

function setDivToMouse(id){
}

// -------------------------------------------------------------------------------
// show or hide a div tag
// -------------------------------------------------------------------------------

function showDiv(id){
	document.getElementById(id).style.display = "inline";
	document.getElementById(id).style.visibility = "visible";
}
function hideDiv(id){
	document.getElementById(id).style.display = "none";
	document.getElementById(id).style.visibility = "hidden";
}

// -------------------------------------------------------------------------------
// method to veryif data types and if OK then submit a form
// -------------------------------------------------------------------------------

function submitIfFormOk(objForm, idsOfFields, dataTypesOfFields){
	try{
		// use this value and if it is set to false then do not submit form
		var allOK = true;
		// split the idsOfFields
		// split the dataTypesOfFields
		// then use methods checkDecimal(x){ and  checkSqlDate(x){
		//not sure if the following line works
		// document.getElementById(idForm)
	}catch(e){
		//alert("error writing to logger (" + s + "): " + e);
	}
}

// -------------------------------------------------------------------------------
// method to check decimal value
// -------------------------------------------------------------------------------
function checkDecimal(x){
	// should return true if decimal value. this is the case if 
	// either a comma or a point is made
	// but if both then error
	// if comma then replace it with bullet?? 
	try{
	}catch(e){
//		alert("error writing to logger (" + s + "): " + e);
	}
}
// -------------------------------------------------------------------------------
// method to check sql date
// -------------------------------------------------------------------------------
function checkSqlDate(x){
	// should return true if valid date
	try{
	}catch(e){
//		alert("error writing to logger (" + s + "): " + e);
	}
}