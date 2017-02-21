//-------------------------------------------------------------------------------------------------
// Variables used rather globally
//--------------------------------------------------------------------------------------------------
var idForMails;
var urlForUnreadMails;
var urlForReadMails;
var blockDoubleclickOnDelete;
blockDoubleclickOnDelete = 0;



//--------------------------------------------------------------------------------------------------
// call clean up of mails in trash
//--------------------------------------------------------------------------------------------------

function mailCleanTrash(vu,vs){
	logInfo("mailCleanTrash fired");
	var timestamp = new Date().getTime();
	ajaxGetMethodAnswerInMsgBox('./popClean.pl?v_u=' + vu + '&v_s=' + vs  + '&t_s=' + timestamp );
	// this is still a todo
	blockDoubleclickOnDelete = 1;
}

//--------------------------------------------------------------------------------------------------
// move mail to its default folder
//--------------------------------------------------------------------------------------------------

function moveToDefaultFolder(id, folderId, currentFolderId){
	logInfo("moveToDefaultFolder fired");
   setBusy();
   var matchString;
      //alert("start x");
   if ((currentFolderId * 1) == (folderId * 1)){
      alert("folders equal");
   }else{ 
     //alert("moving");
     var url="ajaxMoveMail.pl?folderId=" + folderId+ "&id=" + id;
	hideElement(id, "");
     	getMethodAnswerInId(url ,setIdleTwoParameter,id);
  }
}

//--------------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function sendMyMailForm(){	
   if(document.myForm.file_1){ moveFileName(document.myForm.file_1, document.myForm.file_name_1);};
   if(document.myForm.file_2){ moveFileName(document.myForm.file_2, document.myForm.file_name_2);};
   if(document.myForm.file_3){ moveFileName(document.myForm.file_3, document.myForm.file_name_3);};
   if(document.myForm.file_4){ moveFileName(document.myForm.file_4, document.myForm.file_name_4);};
   if(document.myForm.file_5){ moveFileName(document.myForm.file_5, document.myForm.file_name_5);};
   //alert(document.myForm.target);
   // alert("action: " + document.myForm.action);
// myForm
 //  alert("action2: " +document.getElementById('myForm').action);
   document.myForm.submit();
}

//-------------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function moveFileName(from, to){
   //alert("in function moveFileName(from, to) in file mail.js. Am I used or am I left over from edit module???");
   var inputstring;
   inputstring = from.value;
   var input_array = inputstring.split("\\");
   to.value = input_array[input_array.length -1 ];
}

// ----------------------------------------------------------------------------------------------
//Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function moveFolder(){
   setBusy();
   var folderFrom;
   folderFrom = document.getElementById('fromFolderId').options[document.getElementById('fromFolderId').selectedIndex].value;
   var folderTo;
   folderTo = document.getElementById('toFolderId').options[document.getElementById('toFolderId').selectedIndex].value;
   //alert( folderFrom );
   //alert( folderTo );
   var url = "ajaxMoveFolder.pl?folderFrom=" + folderFrom + "&folderTo=" + folderTo;
   //alert(url);
   getMethodAnswerInId(url , doAlertResponse , folderTo);
}

// ----------------------------------------------------------------------------------------------
// Function function to raise an alert as result of ajax action
//--------------------------------------------------------------------------------------------------

function doAlertResponse(id, responseText){
	logInfo("doAlertResponse fired with value: " + responseText);
   	alert(trim(responseText));
   	setIdle();
}

// ----------------------------------------------------------------------------------------------
//Function to move mail to trash - should be modified for a more generic use - use next funktion istead
//
function trashMail(id){
	logInfo("trashMail fired for id: " + id);
   	setBusy();
   	var url="ajaxMoveMail.pl?folderId=0&id=" + id;
	hideElement(id, "");
   	getMethodAnswerInId(url ,setIdleTwoParameter,id);
}

// ----------------------------------------------------------------------------------------------
//Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function moveMail(id, thisObject){
   setBusy();
   var folder;
   //alert(thisObject.options[thisObject.selectedIndex].value);
   folder = thisObject.options[thisObject.selectedIndex].value;
   //= thisObject.options[thisObject.selectedIndex].value;
   var url="ajaxMoveMail.pl?folderId=" + folder + "&id=" + id;
	hideElement(id, "");
   	getMethodAnswerInId(url ,setIdleTwoParameter,id);
	logInfo("moveMail fired");
}

// ----------------------------------------------------------------------------------------------
//Function hides a row in the table of mails
//--------------------------------------------------------------------------------------------------

function hideElement(id, responseText){
   document.getElementById("mail_" + id).style.display = "none";
   document.getElementById("mail_" + id).style.visibility = "hidden";
   setIdle();
}

// ----------------------------------------------------------------------------------------------
// Function gets the search value of the search form and loads the search result into the form
//--------------------------------------------------------------------------------------------------

function mailSearchMail(allFolders){
   setBusy();
   var folder 
   var searchString = document.getElementById('searchValue').value;
   folder = document.getElementById('folderId').options[document.getElementById('folderId').selectedIndex].value;
   //alert(searchString);
   var url;
   if(allFolders == true){
      url = "./ajaxLoadMailByFolderAndSearch.pl?folderId=allFolders&searchString=" + searchString;
   }else{
      url = "./ajaxLoadMailByFolderAndSearch.pl?folderId=" + folder + "&searchString=" + searchString;
   }
   getMailsByFolderAndSearch(url, "mailFormId");
}

// ----------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function getMailsByFolderAndSearch(url, id){
   getMethodAnswerInId(url ,pushSearchResponseInId,id);
   //alert("huhu");
   positionContainerAbsolut("mailFormId","CENTER","CENTER",20,20,100,20);
   setIdle();
// if id = mailFormId the we need to center the box again 
}

// -------------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function pushSearchResponseInId(id, responseText){
   //alert(responseText);
   document.getElementById(id).innerHTML = responseText ;
   positionContainerAbsolut("mailFormId","CENTER","CENTER",10,10,100,10);
      setIdle();
}

// -------------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function pushResponseInId(id, responseText){
   //alert(responseText);
   document.getElementById(id).innerHTML = responseText ;
      setIdle();
}

// ----------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function resizeMailArea(){
resizeMailIframe();
var objIdMailOuterTable = document.getElementById('idMailOuterTable');
var objIdMailIframeTd = document.getElementById('idMailIframeTd');
var objIdMailBody = document.getElementById('mailBody');
var newSize;
newSize = objIdMailIframeTd.offsetHeight;
objIdMailBody.style.height = newSize + "px";
}

// ----------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function resizeMailIframe(){
var objIdMailOuterTable = document.getElementById('idMailOuterTable');
var objIdMailIframeTd = document.getElementById('idMailIframeTd');
//var objTextArea = document.getElementById('mailBody');
var screenHeight = 0;
try { if(screenHeight < document.body.clientHeight){ screenHeight = document.body.clientHeight;}; } catch (e) {  };
try { if(screenHeight < window.innerHeight){ screenHeight = window.innerHeight;}; } catch (e) {  };
try { if(screenHeight <  document.documentElement.clientHeight){ screenHeight = document.documentElement.clientHeight;}; } catch (e) {  };
var delta;
var soll = 600;
var newSize;
//alert(screenHeight);
if (soll > screenHeight  ){
   soll = screenHeight;
}
delta = soll - objIdMailOuterTable.offsetHeight;
newSize = objIdMailIframeTd.offsetHeight + delta;
//newSize = newSize  - 20;
//alert(newSize );
objIdMailIframeTd.style.height = newSize + "px";
//objIdMailIframeTd.style.height = "100px";
// hier muss eine fallunterscheidung rein ob es sich um den iframe handelt oder um das textarea
// das untige geht nur beim textarea
// problem - the object is not always existing
//try{
	//objTextArea.style.height = newSize + "px";
//}catch(e){
	
//}

//alert(objIdMailOuterTable.offsetHeight );
//alert(objIdMailIframeTd.offsetHeight );
//alert(objTextArea.offsetHeight );
}

// ----------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function showMail (mailId) {
  //alert("in showMail");
  var objReadMailWindow;
  var v_u = getUrlParameter('v_u');
  var v_s = getUrlParameter('v_s');
  var fileName = 'showMail.pl'
  var relativeUrl = "./" + fileName + "?v_u=" + v_u + "&v_s=" + v_s + "&mailId=" + mailId
  //alert(relativeUrl);
  
  var jetzt = new Date();
  //alert(jetzt.getTime());
   var x = "mailWin " + jetzt.getTime();

  objReadMailWindow = window.open(relativeUrl, x, "width=800,height=600,left=100,top=200,scrollbars=no");
  markMailRead(mailId);
  objReadMailWindow.focus();
  objReadMailWindow.document.title = "rading mail" + mailId;
}


// --------------------------------------------------------------------------------------------------------------------------
// Function is the same like function before but loads the content in the div 
// --------------------------------------------------------------------------------------------------------------------------

function showMailAjaxInline(mailId) {
  //alert("in showMail");
  var objReadMailWindow;
  var v_u = getUrlParameter('v_u');
  var v_s = getUrlParameter('v_s');
  var fileName = 'showMail.pl'
  var nothingRand;
  var relativeUrl = "./" + fileName + "?v_u=" + v_u + "&v_s=" + v_s + "&mailId=" + mailId
  //alert(relativeUrl);
  
   nothingRand = Math.random();
   getMethodAnswerInId(relativeUrl + "&nothing=" + nothingRand,pushAnswerInId,"contantArea");

}
// ----------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function newMail() {
  var objReadMailWindow;
  var v_u = getUrlParameter('v_u');
  var v_s = getUrlParameter('v_s');
  var fileName = 'sendMail.pl'
  var relativeUrl = "./" + fileName + "?v_u=" + v_u + "&v_s=" + v_s;
  //alert(relativeUrl);
  var jetzt = new Date();
  //alert(jetzt.getTime());
   var x = "newWin " + jetzt.getTime();
  objReadMailWindow = window.open(relativeUrl, x, "width=800,height=600,left=100,top=200,scrollbars=no");
  objReadMailWindow.focus();
  objReadMailWindow.document.title = "new mail";
}

// -------------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function markMailRead(id) {
  //alert("./ajaxSetMailRead.pl?mailId=" + id);
// setMailRead
  document.getElementById("mail_from_" + id).className = "mail_read";
  document.getElementById("mail_to_" + id).className = "mail_read";
  //document.getElementById("mail_subject_" + id).className = "mail_read";
  //document.getElementById("mail_date_" + id).className = "mail_read";
  getHtmlGet("./ajaxSetMailRead.pl?mailId=" + id,doNothing);
}

// -------------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function doNothing(){
}

// -------------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function setIdleTwoParameter(id, responseText){
	setIdle();
}

// -------------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function deleteMail(id) {
  	getHtmlGet("http://www.as-admin.net/cgi-bin/live/mail/ajaxDeleteMail.pl?id=" + id,markMailDeleted);
	logInfo("deleteMail fired");
}

// -------------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function markMailDeleted(id) {
  //alert(id);
  var id2 = id.replace(/ /, "");
  var id3 = id2.replace(/\n/, "");
  var id4 = id3.replace(/\r/, "");
  var Ergebnis = id4.match(/\berror\b/g);
  if (Ergebnis){
    alert("error deleting mail");
  }else{ 
    document.getElementById(id + "-1").className = "mail_2";
    document.getElementById(id + "-2").className = "mail_2";
    document.getElementById(id + "-3").className = "mail_2";
    document.getElementById(id + "-4").className = "mail_2";
  }
	logInfo("markMailDeleted fired");
}

// ----------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function getMailsOnLoad(url_unread, url_read, url_new, id){
	logInfo("getMailsOnLoad fired");
   setBusy();
   idForMails = id;
   urlForUnreadMails = url_unread;
   urlForReadMails = url_read;
   var nothingRand;
   nothingRand = Math.random();
   // following line commented out on 11.3.2011
   //document.getElementById(id).innerHTML = "";
   // first get unread mails
   //alert("url unread: " + url_unread + "&mailId=no");
   getMethodAnswerInId(url_unread + "&mailId=no&nothing=" + nothingRand,addAnswerOnTopOfId,id);
   setBusy();
   // following line commented out on 11.3.2011
   //setContent(id, "loading...");
   // then get read mails
   // alert("url unread: " + url_read + "&mailId=no");
   // next url not loaded because not necessary anymore because we always load everything
   //getMethodAnswerInId(url_read + "&mailId=no&nothing=" + nothingRand,addAnswerAtEndOfId,id);
   // then start process of new mail loop
   setBusy();
   getNewMails(url_new, id);
}

// ----------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function reloadMails(url_unread, url_read, id){
	logInfo("reloadMails fired");
	//alert("reloading into " + id)
   setBusy();
   idForMails = id;
   urlForUnreadMails = url_unread;
   urlForReadMails = url_read;
   var nothingRand;
   nothingRand = Math.random();
   document.getElementById(id).innerHTML = "";
   // first get unread mails
   //alert("url unread: " + url_unread + "&mailId=no");   
   getMethodAnswerInId(url_unread + "&mailId=no&nothing=" + nothingRand,addAnswerOnTopOfId,id);
   setBusy();
   // then get read mails
   // alert("url unread: " + url_read + "&mailId=no");
   // next url not loaded because not necessary anymore because we always load everything
   //getMethodAnswerInId(url_read + "&mailId=no&nothing=" + nothingRand,addAnswerAtEndOfId,id);
}

// -------------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function addAnswerOnTopOfId(id, responseText){
   //alert(responseText);
   document.getElementById(id).innerHTML = responseText + document.getElementById(id).innerHTML ;
   positionContainerAbsolut("mailFormId","CENTER","CENTER", 20, 20, 100, 20);
   setIdle();
}

// -------------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//
function addAnswerAtEndOfId(id, responseText){
   //alert(responseText);
   document.getElementById(id).innerHTML = document.getElementById(id).innerHTML + responseText;
   positionContainerAbsolut("mailFormId","CENTER","CENTER",20,20,100,20);
   setIdle();
}

// -------------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function getNewMails(url_new, id){
	logInfo("getNewMails fired");
   //alert("getNewMails:" + id);
   //alert("in getNewMails - url: " + url_new);
   var nothingRand;
   var finalUrl;
   nothingRand = Math.random();
   setBusy();
   // following line commented out on 11.3.2011
   //setContent("mailFormId", "loading...");
   finalUrl = url_new + "?nothing=" + nothingRand;
   //alert("finalUrl: " + finalUrl);
   getMethodAnswerInId(finalUrl ,getNewMailsLoop,url_new);
}

// -------------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function getNewMailsLoop(url, responseText){
	logInfo("getNewMailsLoop fired");
	// add the result in the log
	try{
		logInfo(responseText);
	}catch(err) {
		alert("error adding to log: " + err);
	}
   // if if answer is continue loop then immediately call again
   //alert("URL:" + url);
   //alert("in loop (" + url + ")- responseText:" + responseText);
   
   var res = responseText.match(/continue-loop/i);
   var parts;
   //alert(responseText);
   
   reloadMails(urlForUnreadMails , urlForReadMails, idForMails )
   if(res ){
      //alert("responseText:" + responseText);
      //show new mail in browser
      parts = responseText.split("|");
      //addSingleMail(parts[0], idForMails );
      //alert("NOT im Loop part! resultis: " + res );
      setIdle();
      window.setTimeout("getNewMails('"+url+"','"+ responseText+"');", 2);  // 2 milliseconds
 
   }else{
      setIdle(); 
      //alert("im 300000 Loop part");
      window.setTimeout("getNewMails('"+url+"','"+ responseText+"');", 300000);
   }
}

// -------------------------------------------------------------------------------------------------
// Function bla bla is doing bla bal
//--------------------------------------------------------------------------------------------------

function addSingleMail(mailId, docId){
   //alert("in add saingle mail:" + mailId + " doc id:" + docId + " URL:" + urlForUnreadMails + "&mailId=" + trim(mailId));
   getMethodAnswerInId(urlForUnreadMails + "&mailId=" + trim(mailId),addAnswerOnTopOfId,docId);
   positionContainerAbsolut("mailFormId","CENTER","CENTER",100,100,100,100);
   setIdle();   
}

// -------------------------------------------------------------------------------------------------
// Function is a simple trim function like in other languages
//--------------------------------------------------------------------------------------------------

function trim(s) {
  while (s.substring(0,1) == ' ') {
    s = s.substring(1,s.length);
  }
  while (s.substring(s.length-1,s.length) == ' ') {
    s = s.substring(0,s.length-1);
  }
  while (s.substring(0,1) == '\n') {
    s = s.substring(1,s.length);
  }
  while (s.substring(s.length-1,s.length) == '\n') {
    s = s.substring(0,s.length-1);
  }
  return s;
}

// -------------------------------------------------------------------------------------------------
// shows or hides the attachment div
// -------------------------------------------------------------------------------------------------

function mailHideAttachments(){
	document.getElementById('mailAttachmentsDivId').style.display = "none";
	document.getElementById('mailAttachmentsDivId').style.visibility = "hidden";
}

// -------------------------------------------------------------------------------------------------
// shows or hides the attachment div
// -------------------------------------------------------------------------------------------------

function mailShowAttachments(){
	document.getElementById('mailAttachmentsDivId').style.display = "inline";
	document.getElementById('mailAttachmentsDivId').style.visibility = "visible";
	positionContainerAbsolut("mailAttachmentsDivId","CENTER","CENTER",1,1,1,1);
}

// -------------------------------------------------------------------------------------------------
// load the drop down for folder move
// -------------------------------------------------------------------------------------------------

function showFolderDropDown(id){
	//alert("in showFolderDropDown 0001")
   	var url="ajaxShowFolderDropDown.pl?id=" + id;
	pushAnswerInId('folderDropDwon', 'loading...');
	showDiv('folderDropDwon');
	positionContainerAbsolut("folderDropDwon","CENTER","CENTER",1,1,1,1);
	setDivToMouse("folderDropDwon");
   	getMethodAnswerInId(url ,pushAnswerInId,"folderDropDwon");
}

// -------------------------------------------------------------------------------------------------
// 
// -------------------------------------------------------------------------------------------------

function moveMailAndHideDrop(id, thisObject){
	moveMail(id, thisObject);
	hideDiv('folderDropDwon');	
}

// -------------------------------------------------------------------------------------------------
// 
// -------------------------------------------------------------------------------------------------

function addMailAddress(id, v_u, v_s){
	
    //loading the basic content for the div tag and then push it into the div
    document.getElementById("mailAddressDivId").innerHTML = "loading...";
   document.getElementById("mailAddressDivId").style.display = "inline";
   document.getElementById("mailAddressDivId").style.visibility = "visible";
    var timestamp = new Date().getTime();
    var url = "ajaxLoadMailAddress.pl?searchString=nothing&targetId=" + id + "&action=init&v_u=";
    url += v_u + "&v_s=" +  v_s + "&t_s=" + timestamp;
    //alert(url );
    getMethodAnswerInId(url , dataAddMailAddressCallBack, "mailAddressDivId");
}

// -------------------------------------------------------------------------------------------------
// this function reloads the list of email addresses if the entered string is 3 characters or more
// -------------------------------------------------------------------------------------------------

function mailRefreshAddressList(sourceId, targetId, finalTarget, v_u, v_s){
    var searchString = document.getElementById(sourceId).value;
    if(searchString.length > 2){
       var timestamp = new Date().getTime();
       var url = "ajaxLoadMailAddress.pl?searchString=" + searchString  + "&targetId=" + finalTarget + "&action=search&v_u=";
       url += v_u + "&v_s=" +  v_s + "&t_s=" + timestamp;
       //alert(url );
       getMethodAnswerInId(url , pushAnswerInId, "addressList");
    }
}

// -------------------------------------------------------------------------------------------------
// 
// -------------------------------------------------------------------------------------------------

function dataAddMailAddressCallBack(id, responseText){
   //alert(responseText);
   document.getElementById(id).innerHTML = responseText;
   positionContainerAbsolut(id,"TOP","CENTER",100,100,150,10);
}

// -------------------------------------------------------------------------------------------------
// 
// -------------------------------------------------------------------------------------------------

function mailUseAddress(id, value){
   //alert(value);
   var tmpVal = trim(document.getElementById(id).value);
   if(tmpVal.length > 0 ){
      tmpVal += ", " + trim(value);
      document.getElementById(id).value = tmpVal;
   }else{
      document.getElementById(id).value = value;
   }
   mailHideAddressDiv();
}

// -------------------------------------------------------------------------------------------------
// 
// -------------------------------------------------------------------------------------------------

function mailHideAddressDiv(){
	document.getElementById('mailAddressDivId').style.display = "none";
	document.getElementById('mailAddressDivId').style.visibility = "hidden";
}

// -------------------------------------------------------------------------------------------------
// 
// -------------------------------------------------------------------------------------------------

function mailClipMail(id){
	var url="ajaxClipMail.pl?id=" + id + "&action=add";
	//getMethodAnswerInId(url , pushAnswerInId, "addressList");
	ajaxGetMethodAnswerInMsgBox(url);
}

// -------------------------------------------------------------------------------------------------
//     // mailClearClip(\''.$v_u.'\',\''.$v_s.'\')
// -------------------------------------------------------------------------------------------------

function mailClearClip(v_u, v_s){
	var url="ajaxClipMail.pl?id=0&action=clear";
	ajaxGetMethodAnswerInLog(url);
}

// -------------------------------------------------------------------------------------------------
//    mailReparse
// -------------------------------------------------------------------------------------------------

function mailReparse(id){
//	alert(id);
	var url="ajaxReparseMail.pl?id=" + id;
	//alert(url);
	ajaxGetMethodAnswerInLog(url);
}

// -------------------------------------------------------------------------------------------------
// load the html content to trigger org actions
// -------------------------------------------------------------------------------------------------

function mailSetOrgAction(id){

	//alert(id + " function located in mail.js session = " + globalSession + " user = " + globalUser);
	//alert("in showFolderDropDown 0001")
   	var url="ajaxShowOrg.pl?id=" + id + "&type=form&v_u=" + globalUser + "&v_s=" + globalSession;
	pushAnswerInId('orgAction', 'loading...');
	showDiv('orgAction');
	positionContainerAbsolut("orgAction","CENTER","CENTER",1,1,1,1);
	setDivToMouse("orgAction");
   	getMethodAnswerInId(url ,pushAnswerInId,"orgAction");
}




// -------------------------------------------------------------------------------------------------