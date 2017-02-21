//-------------------------------------------------------------------------------------------------
//
//--------------------------------------------------------------------------------------------------
var code;		
code = "";	
var openTabs = "";
var closedTabs = "";
var minTab = 1;
var maxTab = 6;
var activeTab = "1";		
var currentid = "#";
var currentSelectionStartPos = 0;
var currentSelectionEndPos = 0;
var currentSelectionString = "";
	
// ----------------------------------------------------------------------------------------------------
//
// ----------------------------------------------------------------------------------------------------

function showhide(id){ 
	var i;
	for (i = 1; i <= maxTab; i++){
		document.getElementById('div' +i).style.display = "none";
		document.getElementById('div' + i).style.visibility = "hidden";
		document.getElementById('tab' + i).style.backgroundColor = "#CCCCCC";
	}						
	document.getElementById('div' + id).style.display = "inline";
	document.getElementById('div' + id).style.visibility = "visible";
	document.getElementById('tab' + id).style.backgroundColor="#FFFFFF";
	currentid = id;
	activeTab = id;
}

// ----------------------------------------------------------------------------------------------------		
//
// ----------------------------------------------------------------------------------------------------

function openNew(){
	
		//find next tab taht is closed
	var tabOpened = "no";
	
	document.getElementById('filesAndFolders').style.display = "none";
	document.getElementById('filesAndFolders').style.visibility = "hidden";
	
	for (i = minTab; i <= maxTab; i++){				
		if (document.getElementById('tabSpan' +i).style.display == "none"){			
			if(tabOpened == "no"){
				document.getElementById('tabSpan' +i).style.display = "inline";
				document.getElementById('tabSpan' +i).style.visibility = "visible";
				showhide(i);
				tabOpened = "yes";
			}	
		}	
	}
}

// ----------------------------------------------------------------------------------------------------		
//
// ----------------------------------------------------------------------------------------------------

function closeTab(id){
	//alert("close " + id);
	document.getElementById('tab' +id).style.display = "none";
	document.getElementById('div' +id).style.display = "none";
	document.getElementById('tab' +id).value = "";
	document.getElementById('path' +id).value = "";
	document.getElementById('content' +id).value = "";
}

// ----------------------------------------------------------------------------------------------------		
//
// ----------------------------------------------------------------------------------------------------

function saveTab(id){ 
	//alert("save " + id);
	var saveFile = document.getElementById('tab' +id).value;
	var savePath = document.getElementById('path' +id).value;
	var saveContent = document.getElementById('content' +id).value;
	var saveAction = "save";
	// ajax function
	ajaxSaveFile(saveAction, saveContent, savePath, "https://ssl-id1.de/alex-admin.net/alex-admin/live/perl/editor/editCodeAjaxSaveFile.pl" );
}

// ----------------------------------------------------------------------------------------------------        
//
// ----------------------------------------------------------------------------------------------------

function debugTab(id){ 
	//alert("save " + id);
	var saveFile = document.getElementById('tab' +id).value;
	var savePath = document.getElementById('path' +id).value;
	var saveContent = document.getElementById('content' +id).value;
            		var debugWindow;  
            		debugWindow = window.open("./debug.pl?path=" + savePath, "debugWindow", "width=700,height=500,left=100,top=200,resizable=yes, scrollbars=yes");
} 
       		
// ----------------------------------------------------------------------------------------------------		
//
// ----------------------------------------------------------------------------------------------------

function loadTab(id){ 
	//alert("load " + id);
	activeTab = id;
	document.getElementById('fileTabs').style.display = "none";
	document.getElementById('fileTabs').style.visibility = "hidden";	
	document.getElementById('filesAndFolders').style.display = "inline"; 
	document.getElementById('filesAndFolders').style.visibility = "visible"; 
}

// ----------------------------------------------------------------------------------------------------
//
// ----------------------------------------------------------------------------------------------------

function loadFolder(){ 
	var folderPath = document.getElementById('selectFolders').options[document.getElementById('selectFolders').selectedIndex].value;
	//alert ("in editcodeAjax.pl loadFolder " + folderPath);
	ajaxLoadFolder(folderPath,"filesAndFoldersAjax", "https://ssl-id1.de/alex-admin.net/alex-admin/live/perl/editor/editCodeAjaxLoadFolder.pl", "/var/www/vhosts/alex-admin.net/");
}

// ----------------------------------------------------------------------------------------------------
//// load file if drop down value changed in file list
// ----------------------------------------------------------------------------------------------------
	       
function loadFile(){ 
	//alert("load file" + folder);
	var fileContent = "";
	var filePath = document.getElementById('selectFiles').options[document.getElementById('selectFiles').selectedIndex].value;
	var fileName = document.getElementById('selectFiles').options[document.getElementById('selectFiles').selectedIndex].text;
	//alert("load file" + fileName );
	//alert("load folder" + filePath );
	//alert("https://ssl-id1.de/alex-admin.net/alex-admin/live/perl/editor/editCodeAjaxLoadFile.pl");
	ajaxLoadFile(filePath, 'content' + activeTab, "https://ssl-id1.de/alex-admin.net/alex-admin/live/perl/editor/editCodeAjaxLoadFile.pl");	
	document.getElementById('tab' + activeTab).value = fileName;
	document.getElementById('path' + activeTab).value = filePath;
	// am schluss zu richtigem reiter zurckkehren
	loadTabOk();
} 
			
// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function loadTabOk(){ 
	//alert("OK ");
	document.getElementById('fileTabs').style.display = "inline";
	document.getElementById('fileTabs').style.visibility = "visible"; 
	document.getElementById('filesAndFolders').style.display = "none";
	document.getElementById('filesAndFolders').style.visibility = "hidden"; 
}

// ----------------------------------------------------------------------------------------------------
//
// ----------------------------------------------------------------------------------------------------

function doployTab(id){ 
	//alert("deploy " + id);
	var saveFile = document.getElementById('tab' +id).value;
	var savePath = document.getElementById('path' +id).value;
	var saveContent = document.getElementById('content' +id).value;
	var saveAction = "deploy";
	// ajax function
	//ajaxSaveFile(saveAction, saveContent, savePath + "/" + saveFile);
	ajaxSaveFile(saveAction, saveContent, savePath, "https://ssl-id1.de/alex-admin.net/alex-admin/live/perl/editor/editCodeAjaxSaveFile.pl" );
}

// ----------------------------------------------------------------------------------------------------
//
// ----------------------------------------------------------------------------------------------------

function createNewFile(){
	var xxx = document.getElementById('newFile').value;
	alert(xxx);
	// need to refresh the list box!!
}

// ----------------------------------------------------------------------------------------------------
//
// ----------------------------------------------------------------------------------------------------

function createNewFolder(){
	var xxx = document.getElementById('newFolder').value;
	alert(xxx);
	//need to refresh the list box!!
}

// ----------------------------------------------------------------------------------------------------
//
// ----------------------------------------------------------------------------------------------------

function resizeEditorArea(id){		
	var obj = document.getElementById(id);
	var objMaster = document.getElementById("masterdiv");
	//alert(obj.offsetWidth);
	//alert("w: " + getWindowWidth());
	//alert("h: " + getWindowHeight());
	var wInit = getWindowWidth();
	var hInit = getWindowHeight();
	var objWidthStr = obj.offsetWidth;
	var objWidth = objWidthStr;
	var objHeightStr = obj.offsetHeight;
	var objHeight = objHeightStr;
	var masterHeightStr = objMaster.offsetHeight;
	var masterHeight = masterHeightStr;
	var masterWidthStr = objMaster.offsetWidth;
	var masterWidth = masterWidthStr;
//alert(masterWidth);
/*
	var ok = false;
	var tmpVal = 10;
	while(! ok){				
		if(wInit < getWindowWidth() ){
			ok = true;
			tmpVal = tmpVal  - 10;
			obj.style.width = tmpVal + "px";
     			}else{
			tmpVal = tmpVal  + 10;
			obj.style.width = tmpVal + "px";
		}
		if(ok){
			ok = true;
			tmpVal = tmpVal  - 200;
			obj.style.width = tmpVal + "px";
     			}
		if(tmpVal > 4000){
			ok = true;
		}	
	}
	ok = false;
	tmpVal = 10;
	while(! ok){	
		if(hInit < getWindowHeight() ){
			ok = true;
			tmpVal = tmpVal  - 10;
			obj.style.height = tmpVal + "px";
     			}else{
			tmpVal = tmpVal  + 10;
			obj.style.height = tmpVal + "px";
		}
		if(ok){
			ok = true;
			tmpVal = tmpVal  - 30;
			obj.style.height = tmpVal + "px";
     			}
		if(tmpVal > 2000){
			ok = true;
		}
	}
*/
                tmpVal = wInit  - 30;
        obj.style.width = tmpVal + "px";
                tmpVal = hInit  - 200;
        obj.style.height = tmpVal + "px";
	
}

// ----------------------------------------------------------------------------------------------------
//// ret widht fo window
// ----------------------------------------------------------------------------------------------------

function getWindowWidth(){
	var screenWidth = 0;
	try { if(screenWidth < document.body.clientWidth){ screenWidth = document.body.clientWidth;}; } catch (e) {  };
	try { if(screenWidth < window.innerWidth){ screenWidth = window.innerWidth;}; } catch (e) {  };
	try { if(screenWidth < document.documentElement.clientWidth){ screenWidth = document.documentElement.clientWidth;}; } catch (e) {  };
	return screenWidth ;
}

// ----------------------------------------------------------------------------------------------------
// get height of window
// ----------------------------------------------------------------------------------------------------

function getWindowHeight(){
	var screenHeight = 0;
	try { if(screenHeight < document.body.clientHeight){ screenHeight = document.body.clientHeight;}; } catch (e) {  };
	try { if(screenHeight < window.innerHeight){ screenHeight = window.innerHeight;}; } catch (e) {  };
	try { if(screenHeight <  document.documentElement.clientHeight){ screenHeight = document.documentElement.clientHeight;}; } catch (e) {  };
	return screenHeight ;
}

// ----------------------------------------------------------------------------------------------------
// stuff to enable tab key   
// ----------------------------------------------------------------------------------------------------  
function setSelectionRange(input, selectionStart, selectionEnd) {
          if (input.setSelectionRange) {
            input.focus();
            input.setSelectionRange(selectionStart, selectionEnd);
          }
          else if (input.createTextRange) {
            var range = input.createTextRange();
            range.collapse(true);
            range.moveEnd('character', selectionEnd);
            range.moveStart('character', selectionStart);
            range.select();
          }
}

// ----------------------------------------------------------------------------------------------------
//
// ----------------------------------------------------------------------------------------------------

function replaceSelection (input, replaceString) {
    if (input.setSelectionRange) {
		// this one is for firefox
		//alert("firefox in replaceSelection");
		
        var selectionStart = input.selectionStart;
        var selectionEnd = input.selectionEnd;
		
        input.value = input.value.substring(0, selectionStart)+ replaceString + input.value.substring(selectionEnd);
    
        if (selectionStart != selectionEnd){ 
            setSelectionRange(input, selectionStart, selectionStart + 	replaceString.length);
        }else{
            setSelectionRange(input, selectionStart + replaceString.length, selectionStart + replaceString.length);
        }
    }else if (document.selection) {
		// this one is internet explorer !!!
        var range = document.selection.createRange();
		//alert("internet explorer");
        if (range.parentElement() == input) {
            var isCollapsed = range.text == '';
            range.text = replaceString;
             if (!isCollapsed)  {
                //range.moveStart('character', -replaceString.length);
                //range.select();
            }
        }
    }
}

// ----------------------------------------------------------------------------------------------------
//   // We are going to catch the TAB key so that we can use it, Hooray!
// ----------------------------------------------------------------------------------------------------

function catchTab(item,e, i){
	if(navigator.userAgent.match("Gecko")){
		c=e.which;
	}else{
		c=e.keyCode;		
	}
	if(c==9){
		lineNumbers();
		setScroll();
		replaceSelection(item,String.fromCharCode(9));
		setTimeout("document.getElementById('"+item.id+"').focus();",0);
		scrollDown(i);	
		return false;
	}
	if(c == 38){
		lineNumbers();
		setScroll();
	}
	if(c == 40){
		lineNumbers();
		setScroll();
	}
	if(c == 13){
		lineNumbers();
		setScroll();
	}
	// lineNumbers();
	// setScroll();
	//scrollDown(i);	
  
}

// ----------------------------------------------------------------------------------------------------
//function to get line numbers 
// ----------------------------------------------------------------------------------------------------

function lineNumbers(){
	try{
	
		var cursorPos = 0; 
		//alert("active tab: " + activeTab );
		var nBox = document.getElementById('content' + activeTab );
                
         		if (document.selection)
			{ 
            		//alert("doc selection yes ie");
         	 	nBox.focus();
             	 	 	var tmpRange = document.selection.createRange();
  	         	 	tmpRange.moveStart('character',-nBox.value.length);
        	 	 	cursorPos = tmpRange.text.length;
     			}else	{
            			//alert("doc selection no - firefox");
	 		if (nBox.selectionStart || nBox.selectionStart == '0'){
                			//alert("start");
				cursorPos = nBox.selectionStart;
			}
		}
            
            		var firstPart = nBox.value.substring(0, cursorPos);          
           		var lineArray = firstPart.split("\n");            
		document.getElementById('line' + activeTab ).value = lineArray .length;
 		}catch(e){
		alert("error in lineNumbers(): " + e);
          	}
	return true;
}

// ----------------------------------------------------------------------------------------------------
//  function to get line numbers 
// ----------------------------------------------------------------------------------------------------

function scrollDown(id){
  try{
     //alert(id);
     var objBox = document.getElementById('content' + id);
    objBox.scrollTop =  document.getElementById('scroll' + id).value
  }catch(e){
      alert("error");
  }
}

// ----------------------------------------------------------------------------------------------------
// function to get line numbers 
// ----------------------------------------------------------------------------------------------------

function setScroll(){
   var objBox = document.getElementById('content' + activeTab );        
    // activeTab         
   document.getElementById('scroll' + activeTab ).value = objBox.scrollTop;
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function getSelectedString(){
	var input = document.getElementById('content' + activeTab ); 
	var retString = "";
	if (input.setSelectionRange) {
		//alert("firefox in getSelectedString");
		var selectionStart = input.selectionStart;
		currentSelectionStartPos = selectionStart;
		var selectionEnd = input.selectionEnd;
		currentSelectionEndPos = selectionEnd;
		//retString = input.value.substring(0, selectionStart)+ input.value.substring(selectionEnd);
		
		retString = input.value.substring(selectionStart, selectionEnd);
		currentSelectionString = retString;
	}else if (document.selection) {
		var range = document.selection.createRange();
//alert(range.text);
		if (range.parentElement() == input) {	
			retString = range.text;
		}
	}
	//alert(retString);
	return retString;
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function getSelectionParameter(parameter){
	if(parameter == "start"){
		alert("not implemented");
	}
	
	if(parameter == "end"){
		alert("not implemented");
	}
	
	if(parameter == "string"){
		return currentSelectionString;
	}
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function commentPerl(){
	appendAtStart("#");
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function uncommentPerl(){
	removeAtStart("#");
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function commentJavaScript(){
	appendAtStart("//");
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function uncommentJavaScript(){
	removeAtStart("//");
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function shiftOneLevel(){
	appendAtStart("	");
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function unshiftOneLevel(){
	removeAtStart("	");
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function doSpace(){
	appendAtStart(" ");
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function undoSpace(){
	removeAtStart(" ");
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function removeAtStart(appendString){
	var objBox = document.getElementById('content' + activeTab );
	var inputString = getSelectedString();
	var newString = ""; 
	var checkString = ""; 	
	var lineArray = inputString.split("\n");   
	var i = 0;
	
	
	
	if(inputString.length > 0){
		for(i = 0; i < lineArray.length; i++){	
			checkString = lineArray[i].substring(0, appendString.length);		
			if(checkString == appendString){	
				if(i == 0){
					newString = lineArray[i].substring(appendString.length, lineArray[i].length);
				}else{
					newString = newString + "\n" + lineArray[i].substring(appendString.length, lineArray[i].length) ;
				}
			}else{
				if(i == 0){
					newString = lineArray[i];
				}else{
					newString = newString + "\n" + lineArray[i] ;
				}
			}
		}	
		//newString = newString + "\n";
		replaceSelection (objBox, newString); 
		
	}else{		
		alert("selected string is null - go to start of line and perform action - not implemented yet");
	}
}

// ----------------------------------------------------------------------------------------------------	
// special for internet explorer - find the position of curosor 
// attention this is only if nothing selected
// ----------------------------------------------------------------------------------------------------

function getIESelectionStart(textArea) {
	var originalTest = textArea.value;
	var tmpText = "";
	var findString = "~p345723048957023947502937502934785023984752345~";	
	var range = document.selection.createRange();
	var insText = range.text;
	range.text = findString;	
	tmpText = textArea.value;	
	var foundAtPos = tmpText.indexOf(findString);
	textArea.value = originalTest;
	var diff = 0;
	diff = originalTest.length - foundAtPos;
	diff = diff * -1;
	//recreate text range from ent to current position
	range = document.selection.createRange();
	range.move('character', diff);
	
	//range.moveStart('character', aTag.length + insText.length + eTag.length);   
	return foundAtPos
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function insertAtLineStart(insertString){
	var cursorPos = 0; 
	var tmpStringVal = "";
	var continueLoop = true;
	var posFound = false;
	var newTextBoxString = "";
	//alert("active tab: " + activeTab );
	var nBox = document.getElementById('content' + activeTab );
	var diffForRange = 0;
	if (document.selection)
		{ 
		//alert("doc selection yes ie");
			//nBox.focus();
			//var tmpRange = document.selection.createRange();
			//tmpRange.moveStart('character',-nBox.value.length);
			//cursorPos = tmpRange.text.length;
			
			cursorPos = getIESelectionStart(nBox) ;
			diffForRange = nBox.value.length - cursorPos;
			diffForRange = diffForRange * -1;
			//alert(cursorPos);
			
	}else	{
		//alert("doc selection no - firefox");
		if (nBox.selectionStart || nBox.selectionStart == '0'){
			//alert("start");
			cursorPos = nBox.selectionStart;
		}
	}
	
	//alert(cursorPos);
	
	if(cursorPos > 0){
	
		while(continueLoop){
				
			tmpStringVal = nBox.value.substring(cursorPos-1, cursorPos);	
			
			
			if(tmpStringVal.charCodeAt(0) == 10 || tmpStringVal.charCodeAt(0) == 13){
				continueLoop = false;
				posFound = true;
			}else{
				cursorPos = cursorPos - 1;
			}
			
			if(cursorPos == 0){
				continueLoop = false;
			}
		}
		
	}
	
	if(posFound == true){
		newTextBoxString = nBox.value.substring(0, cursorPos) + insertString + nBox.value.substring(cursorPos);
		nBox.value = newTextBoxString;
		
		//problem with IE
		if(browserIsIE()){
			range = document.selection.createRange();
			alert("cursorPos: " + diffForRange);
			range.move('character', diffForRange);
			//range.moveStart('character', -5);
			range.select();
		}
	}
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function browserIsIE(){
	//alert(navigator.userAgent);
	return /MSIE/.test(navigator.userAgent);
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function trimString(s) {
    return (s.replace(/\s+$/,"").replace(/^\s+/,""));
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function appendAtStart(appendString){
	var objBox = document.getElementById('content' + activeTab ); 
	var inputString = getSelectedString();
	//alert("ok");
	var newString = ""; 
	var currentArrayString;	
	
	//alert("input string is: " + inputString);
	if(inputString.length > 0 ){
	// \r\n
		var lineArray = inputString.split("\n");   
		var i = 0;
	
		for(i = 0; i < lineArray.length; i++){	
			//currentArrayString = trimString(lineArray[i]);
			currentArrayString = lineArray[i];
			currentArrayString = currentArrayString.replace(/\r|\n|\r\n/g, "");
			if(i == 0){
				if(currentArrayString.length > 0){
					newString = appendString + currentArrayString;
				}else{
					//newString = newString + "\n";
				}
			}
			
			if( i > 0 && i < lineArray.length-1 ){
				if(currentArrayString.length > 0){
					newString = newString + "\n" + appendString +currentArrayString;
				}else{
					//newString = newString + "\n";
				}
			}
			
			if(i == lineArray.length - 1 ){
				if(currentArrayString.length > 0){
					//newString = newString + "\n" + appendString + currentArrayString + "(" + currentArrayString.length + ")";
					newString = newString + "\n" + appendString + currentArrayString;
					//newString = newString +  + currentArrayString;
				}else{
					//newString = newString + "\n";
				}
			}	
		}	
		//newString = newString + "\n";
		replaceSelection (objBox, newString); 
		
		
	}else{
		//alert("now inserting at ssss line start");
		lineNumbers();
		setScroll();
		insertAtLineStart(appendString)
		scrollDown(activeTab);
	}
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function beautifyCodeJavaScript(){
	var objBox = document.getElementById('content' + activeTab ); 
	var currentContent = objBox.value;
	var newValue = currentContent;
	newValue = newValue.replace(/\r\n\r\n/g, "\r\n");
	newValue = newValue.replace(/\n\r\n\r/g, "\n\r");
	newValue = newValue.replace(/\r\r/g, "\r");
	newValue = newValue.replace(/\n\n/g, "\n");
	newValue = newValue.replace(/---\r\nfunction/g, "---\r\n\r\nfunction");
	newValue = newValue.replace(/---\n\rfunction/g, "---\n\r\n\rfunction");
	newValue = newValue.replace(/---\rfunction/g, "---\r\rfunction");
	newValue = newValue.replace(/---\nfunction/g, "---\n\nfunction");
	newValue = newValue.replace(/}\r\n\/\//g, "}\r\n\r\n\/\/");
	newValue = newValue.replace(/}\n\r\/\//g, "}\n\r\n\r\/\/");
	newValue = newValue.replace(/}\r\/\//g, "}\r\r\/\/");
	newValue = newValue.replace(/}\n\/\//g, "}\n\n\/\/");
	objBox.value = newValue;
	// tab
	//alert(document.getElementById('tab' + activeTab ).value);
}

// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function beautifyCodePerl(){

	// first count the tabs and blanks... then replace appropriately

	var objBox = document.getElementById('content' + activeTab ); 
	var currentContent = objBox.value;
	var newValue = currentContent;
	var startString ;

	newValue = newValue.replace(/\r\n/g, "~pcjtzd610957ft~");
	newValue = newValue.replace(/\n\r/g, "~pcjtzd610957ft~");
	newValue = newValue.replace(/\r/g, "~pcjtzd610957ft~");
	newValue = newValue.replace(/\n/g, "~pcjtzd610957ft~");
	//alert(newValue );

	// startString
	startString = "~pcjtzd610957ft~";
	for (var t = 0; t < 5; t++){

		for (var i = 20; i >= 0; i--){

			if( i > 9 && i < 13){
				newValue  = replaceStartOfLine(newValue, startString, i, 4);
			}

			if( i > 6 && i < 10){
				newValue  = replaceStartOfLine(newValue, startString, i, 3);
			}

			if( i > 3 && i < 7){
				newValue  = replaceStartOfLine(newValue, startString, i, 2);
			}

			if( i > 0 && i < 4){
				newValue  = replaceStartOfLine(newValue, startString, i, 1);
			}
		}
		startString += "	";
	}
	
	newValue = newValue.replace(/~pcjtzd610957ft~/g, "\r\n");	

	newValue = newValue.replace(/---\r\nsub/gi, "---\r\n\r\nsub");
	newValue = newValue.replace(/---\n\rsub/gi, "---\n\r\n\rsub");
	newValue = newValue.replace(/---\rsub/gi, "---\r\rfunction");
	newValue = newValue.replace(/---\nsub/gi, "---\n\nsub");
	newValue = newValue.replace(/}\r\n\/\//g, "}\r\n\r\n\/\/");
	newValue = newValue.replace(/}\n\r\/\//g, "}\n\r\n\r\/\/");
	newValue = newValue.replace(/}\r\/\//g, "}\r\r\/\/");
	newValue = newValue.replace(/}\n\/\//g, "}\n\n\/\/");

	objBox.value = newValue;

	//alert(document.getElementById('tab' + activeTab ).value);
}

// ----------------------------------------------------------------------------------------------------	
// problem - this method is not good enough because if there are tabs and blankes mixed at the start of line then it does not work
// ----------------------------------------------------------------------------------------------------
function replaceStartOfLine(origionalCompleteString, startString, numOfBlanks, numOfTabs){

	var findString = "";
	var tabs ="";
	var tabString = "";
	var blanks = "";
	var ret = "";

	for (var x = 1; x <= numOfTabs; x++){
		tabs = tabs  + "	";
	}

	for (var i = 1; i <= numOfBlanks; i++){
		blanks = blanks  + " ";
	}

	findString = startString + blanks ;
	tabString = startString + tabs;
	origionalCompleteString = origionalCompleteString.replace(findString , tabString );


	//  x X
	blanks = "";
	for (var i = 1; i <= numOfBlanks; i++){
		blanks = blanks  + " ";
	}

	findString = startString + blanks ;
	tabString = startString + tabs;
	origionalCompleteString = origionalCompleteString.replace(findString , tabString );

	return origionalCompleteString;

}
// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------

function beautifyCode(){

	fileName = "xxx" + document.getElementById('tab' + activeTab ).value;

	if(fileName.match(/.pl/gi)){
		for (var x = 1; x <= 10; x++){
			beautifyCodePerl();
		}		
	}
	if(fileName.match(/.pm/gi)){
		for (var x = 1; x <= 10; x++){
			beautifyCodePerl();
		}		
	}
	if(fileName.match(/.js/gi)){
		beautifyCodeJavaScript();
	}
}
// ----------------------------------------------------------------------------------------------------	
//
// ----------------------------------------------------------------------------------------------------
	
function showSqlEditor(user,session){
  var url = "./sqlEditor.pl?v_u=" + user + "&v_s=" + session;
  var name = "SQL Editor";
  newWindow = window.open(url, name, "width=800,height=500,left=50,top=50,resizable=yes");
  newWindow.focus();
}