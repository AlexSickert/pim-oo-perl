//-------------------------------------------------------------------------------------------------
//----------------------------------------------
// global variable
//----------------------------------------------
var orgCurrentCategory = "";
var orgCurrentLocation = "";
var orgCurrentOffset = 0;
var orgContentId = "";
var orgLoopRunning = false;
var orgLoopArray = new Array();
var idOfDataElementToCopy = "";
var idOfFolderElementToCopy  = "";
var moveCopyPasteAction = "";
var idOfDataElementFolderToMove = "";
var idOfFolderElementFolderToMove = "";


// -------------------------------------------------------------------------------------------------------------------
//  load calendar
// -------------------------------------------------------------------------------------------------------------------
function orgLoadCalendar(ty){

	myOrgCalendar.setRef("organizer");
	myOrgCalendar.setStyles("a", "a", "a", "a", "a", "orgDateLable", "a", "orgEvent");


//    this.setStyles = function(a, b, c, d, e, f, g, h){
//        table = a;
//        td = b;
//        sat = c;
//        sun = d;
//        today = e;
//        spanDate = f;
//        spanPlus = g; 
//        span = h;        
//    }

	var date;
	date = myOrgCalendar.getSQLDateString(new Date()); 
	//alert(date);
	myOrgCalendar.getData(date, ty);

}
// -------------------------------------------------------------------------------------------------------------------
//  move element to other category
// -------------------------------------------------------------------------------------------------------------------

function orgToCategory(category, id){
//	var arr = id.split("_");
//	var row = arr[1];
	var row = id;
//	var field = arr[0];
	var val = "yes";
	logInfo("orgToCategory: " + id);
	//var url = "./ajaxOrg.pl?category=ajax&field=" + field + "&row=" + row  + "&content=" + encodeURI(val);
	var url = "./ajaxOrg.pl?category=ajax&field=category&row=" + id+ "&content=" + escape(category);
	orgHideElement(id);
	getMethodAnswerInId(url,orgProcessChangeCallback,id);
}

// -------------------------------------------------------------------------------------------------------------------
//  add an item to the curretn deisplayed list. this is dependent ont he global vairables
// -------------------------------------------------------------------------------------------------------------------

function orgAddElement(){
//	alert("orgAddElement")
	var url = "./ajaxOrg.pl?";
	dataAjaxLoadOrganizer(url, orgContentId, "new_" + orgCurrentCategory , orgCurrentOffset , orgCurrentLocation );
}

// ----------------------------------------------------------------------------------------------
//Function hides a row in the table of mails
//--------------------------------------------------------------------------------------------------

function orgHideElement(id){
//	alert(id);
   	document.getElementById("tr_" + id).style.display = "none";
   	document.getElementById("tr_" + id).style.visibility = "hidden";
}

// -------------------------------------------------------------------------------------------------------------------
//  set org element done
// -------------------------------------------------------------------------------------------------------------------

function orgSetDone(id){
//	var arr = id.split("_");
//	var row = arr[1];
	var row = id;
//	var field = arr[0];
	var val = "yes";
	//var url = "./ajaxOrg.pl?category=ajax&field=" + field + "&row=" + row  + "&content=" + encodeURI(val);
	var url = "./ajaxOrg.pl?category=ajax&field=done&row=" + row  + "&content=" + escape(val);
	orgHideElement(id);
	getMethodAnswerInId(url,orgProcessChangeCallback,id);
}

// -------------------------------------------------------------------------------------------------------------------
//  when change of entry then process it
// -------------------------------------------------------------------------------------------------------------------

function orgProcessChange(id){

	// split the id
	var arr = id.split("_");
	var row = arr[1];
	var field = arr[0];
//	var val = document.getElementById(id).innerHTML;
//	logInfo("orgProcessChange: " + id + " string length to be processed: " + val.length);
//	//var url = "./ajaxOrg.pl?category=ajax&field=" + field + "&row=" + row  + "&content=" + encodeURI(val);
//	var url = "./ajaxOrg.pl?category=ajax&field=" + field + "&row=" + row  + "&content=" + escape(val);
//	getMethodAnswerInId(url,orgProcessChangeCallback,id);

	orgRegister(row, field);
}

// -------------------------------------------------------------------------------------------------------------------
//  
// -------------------------------------------------------------------------------------------------------------------

function orgProcessChangeCallback(id, content){
//	alert("allback orgProcessChangeCallback" + id + content);
	logInfo("orgProcessChangeCallback: " + id + " result: " + content);
}


// ----------------------------------------------------------------------------------------------------------------
//Function sets global vairables
// ----------------------------------------------------------------------------------------------------------------
function dataSetGlobalsOrganizer(id, category, offset, location){
	orgCurrentCategory  = category;
	orgCurrentLocation = location;
	orgCurrentOffset = offset;
	orgContentId  = id;
}

// ----------------------------------------------------------------------------------------------------------------
//Function loads organizer element
// ----------------------------------------------------------------------------------------------------------------

function dataAjaxLoadOrganizer(url, id, category, offset, location){
	orgCurrentCategory  = category.replace(/new_/g, "");
	orgCurrentLocation = location;
	orgCurrentOffset = offset;
	orgContentId  = id;
	//alert("hallo");
	// dataAjaxLoadOrganizer("./ajaxOrg.pl?offset=0&category=week",  "organizer","week",0,"all")
	//to do: distinct between categories - depending on categroy js callback needs to be loaded
	// use the global variables !!!
	// offset=0&category=
    	document.getElementById(id).innerHTML = "loading...";
    	var timestamp = new Date().getTime();
	url += "category=" + category;
	url += "&offset=" + offset;
	url += "&location=" + location;
    	url += "&t_s=" + timestamp;
	//alert(url);
    	getMethodAnswerInId(url , pushAnswerInId, id);
}

// ----------------------------------------------------------------------------------------------------------------
// load the mail list using values from the form and load via ajax - september 2009
// ----------------------------------------------------------------------------------------------------------------

function dataLoadMailList(){
	var ids = document.getElementById("mailclip").value;
	var vs = document.getElementById("v_s").value;
	var vu = document.getElementById("v_u").value;
	// https://ssl-id1.de/alex-admin.net/alex-admin/live/perl/mail/ajaxGetMailLinkList.pl?ids=1,2,3,4,5,6,7,8,9,21234
	var url = "../mail/ajaxGetMailLinkList.pl?ids=" + ids + "&v_s=" + vs + "&v_u=" + vu;
	if(ids.length > 0 ){
		getMethodAnswerInId(url , pushAnswerInId, "divMailList");
	}else{
		document.getElementById("divMailList").innerHTML = "no mails";
	}
}

// ----------------------------------------------------------------------------------------------
/*
Function is setting line to billed
*/
function changeStatusTimesheetEntry(id, currVal){
   //alert("id: " + id);
   //alert("currVal: " + currVal);
   var url = "ajaxTimesheet.pl?id =" + id + "&currVal=" + currVal;
   //alert(url);
   getMethodAnswerInId(url , processTimesheetResult, id);
}

// -------------------------------------------------------------------------------------------------
/*
Function sets the result of ajax change status action
*/
function processTimesheetResult(id, responseText){
   //alert("result: " + id + "test: " + responseText);
   document.getElementById("switch_" + id).value = responseText;
}

// -------------------------------------------------------------------------------------------------
/*
Function loads tree lement and sets result in id  
*/
function dataAjaxLoadExplorer(url, id){
    document.getElementById(id).innerHTML = "loading...";
    var timestamp = new Date().getTime();
    url += "&t_s=" + timestamp;
    getMethodAnswerInId(url , dataAjaxLoadExplorerCallBack, id);
}
function dataAjaxLoadExplorerCallBack(id, responseText){
   document.getElementById(id).innerHTML = responseText;
   positionContainerAbsolut("explorerTree","TOP","CENTER",100,100,150,10);
}


// -------------------------------------------------------------------------------------------------
/*
Function opens new tab for a new doc August 2015
https://ssl-id1.de/alex-admin.net/alex-admin/live/perl/data/data.pl?v_u=haselmax&v_s=KSlJHSIfMV3tJyg3HW8R4IeDyNBLVqw9lnGg5lI0AlmlOW0HTs8&mode=full&action=new
var globalSession = 'KSlJHSIfMV3tJyg3HW8R4IeDyNBLVqw9lnGg5lI0AlmlOW0HTs8';
var globalUser = 'haselmax';
*/

function dataNewData(id){
    var url;
    url = "./data.pl?v_u=" + globalUser + "&v_s=" + globalSession + "&mode=full&action=new&treeId=" + id;
    var win = window.open(url, '_blank');
    win.focus();
}

// -------------------------------------------------------------------------------------------------
// prepare copy or cut /  move process of a Data element
// -------------------------------------------------------------------------------------------------


function prepareCopyData(id){
	idOfDataElementToCopy = id;
	idOfFolderElementToCopy = "";
	moveCopyPasteAction = "c";
}

//move data
function prepareCutData(id, idFolder){
	idOfDataElementToCopy = id;
	idOfFolderElementToCopy = "";
	idOfDataElementFolderToMove = idFolder;
	moveCopyPasteAction = "m";
	//alert(id + " and " +  idFolder);
}

// move a folder
function prepareCutFolder(id){
	idOfDataElementToCopy = "";
	idOfFolderElementToCopy =id;
	//idOfFolderElementFolderToMove = idFolder;
	idOfDataElementFolderToMove = "";
	moveCopyPasteAction = "m";
	//alert(" move" +  idOfFolderElementToCopy );
}



function pasteFolderOrData(id){
	
	if(idOfDataElementToCopy   == ""){
		// then we try to copy a folder
		//alert("move " + idOfFolderElementToCopy  + "  to " + id);

		var url = "./ajaxCopyPasteExplorer.pl?type=folder&v_u=" + globalUser + "&v_s=" + globalSession + "&toMoveId=" + idOfFolderElementToCopy  + "&targetId=" + id + "&action=" + moveCopyPasteAction + "&originId=";
		//alert(url);
		getMethodAnswerInId(url,pushAnswerInId,"logDiv");	

	}else{
		//alert("from " + idOfDataElementToCopy  + " to " + id);

		var url = "./ajaxCopyPasteExplorer.pl?type=data&v_u=" + globalUser + "&v_s=" + globalSession + "&toMoveId=" + idOfDataElementToCopy  + "&targetId=" + id + "&action=" + moveCopyPasteAction + "&originId=" + idOfDataElementFolderToMove;
		//alert(url);
		getMethodAnswerInId(url,pushAnswerInId,"logDiv");			

	}

	// clean all variables
	idOfDataElementToCopy = "";
	idOfFolderElementToCopy = "";
	idOfDataElementFolderToMove = "";
	moveCopyPasteAction = "";
}



// -------------------------------------------------------------------------------------------------
// push the mails in the id of the mail ids
// -------------------------------------------------------------------------------------------------

function dataPushMailClip(ids){
	var currentValue = document.getElementById("mailclip").value;
	var finalString;
	
	if(currentValue.length > 0){
		finalString = currentValue + "," + ids;
	}else{
		finalString = ids;
	}
	// remove unnecessary strings
	// MailIdStart45725MailIdEnd
	finalString = finalString.replace(/MailIdStart/g, "");
	finalString = finalString.replace(/MailIdEnd/g, "");
	alert(finalString );
	document.getElementById("mailclip").value = finalString;	
	var clearClip = confirm("clear clip?");
	if(clearClip  == false){
		// do nothing
	}else{
		// clear the clip
		var url = "./ajaxClip.pl?module=mail&parameter=mail-clip&action=clear";
		getMethodAnswerInId(url,pushAnswerInId,"logDiv");		
	}
}

//#################################
//nach unten length  (Anzahl Elemente)
//Methoden:
//nach unten concat() (Arrays verketten)
//nach unten join() (Array in Zeichenkette umwandeln)
//nach unten pop() (letztes Array-Element löschen)
//nach unten push() (neue Array-Elemente anhängen)
//nach unten reverse() (Elementreihenfolge umkehren)
//nach unten shift() (Erstes Array-Element entfernen)
//nach unten slice() (Teil-Array extrahieren)
//nach unten splice() (Elemente löschen und hinzufügen)
//nach unten sort() (Array sortieren)
//nach unten unshift() (Elemente am Array-Anfang einfügen)
//----------------------------------------------
// register and start loop
//----------------------------------------------

function orgRegister(row, field){
	var delimiter = "#";
	var id;
	id = row + delimiter + field;
	
	// insert into array
	// check first if it already existst in the array....
	if(orgLoopArrayContains(id)){
		// write in log that it exists
		logInfo("register() - id already exists in array: " + id);
	}else{
		logInfo("register() - adding id to array: " + id);
		orgLoopArray.push(id);
	}
	if(orgLoopRunning){
		// log here that nothing to do
	}else{
		orgLoopRunning = true;
		orgStartAjaxLoop();
	}
}

//----------------------------------------------
// check if array contains element
//----------------------------------------------

function orgLoopArrayContains(id){
	var i;
	var max;
	max = orgLoopArray.length;
	
	for(i = 0; i < max; i++){
		if(id == orgLoopArray[i]){
			return true;
		}
	}
	return false;
}

//----------------------------------------------
// starts the loop
//----------------------------------------------

function orgStartAjaxLoop(){
	var element;
	// immediately remove element from loop array !!!
	
	if(orgLoopArray.length > 0){
		// get element and send
		element = orgLoopArray.pop();
		// split the element
		var arr = element.split("#");
		var row = arr[0];
		var field = arr[1];
		// get the content
		var id = field + "_" + row ;
		var content = document.getElementById(id).innerHTML;
		orgSendViaAjax(row, field, content);
	}else{
		// log here that we stop the loop now
		logInfo("orgStartAjaxLoop array length 0 - stopping loop");
		orgLoopRunning = false;
	}
}

//----------------------------------------------
// starts the loop
//----------------------------------------------

function orgSendViaAjax(row, field, content){
	var id = row + "_" + field;
	logInfo("orgSendViaAjax: " + id + " string length to be processed: " + content.length);
	//var url = "./ajaxOrg.pl?category=ajax&field=" + field + "&row=" + row  + "&content=" + encodeURI(val);
	var url = "./ajaxOrg.pl?category=ajax&field=" + field + "&row=" + row  + "&content=" + escape(content);
	logInfo("orgSendViaAjax: " + url);
	getMethodAnswerInId(url,orgCallbackLoopAjaxSend,id);
}

//----------------------------------------------
// callback of orgSendViaAjax
//----------------------------------------------

function orgCallbackLoopAjaxSend(id){
	// do some logging here!!!
	logInfo("orgCallbackLoopAjaxSend: " + id);
	// if there are still elements then fire loop again
	if(orgLoopArray.length > 0){
		logInfo("orgCallbackLoopAjaxSend: array length bigger 0 - continue loop: " + orgLoopArray.length);
		orgStartAjaxLoop();	
	}else{
		logInfo("orgCallbackLoopAjaxSend: array length0 - stoploop");
		orgLoopRunning = false;
	}	
}
