
// --------------------------------------------------------------------------------------------------------------
// variables needed for the ping function
// --------------------------------------------------------------------------------------------------------------
var pingStartTime;
var pingEndTime;
var pingCurrentTime;
var pingAjaxLoopTimeout = 10000; // wait until next ajax request
var pingLoopDoCheck = false;  // if comparison should be carried out
var pingMaxDelay = 5000;

// --------------------------------------------------------------------------------------------------------------
// start ping() and its methods in ajax...
// --------------------------------------------------------------------------------------------------------------

function startPing(){
	try{
		// calling ../admin/ping.pl   via ajax
		//   = new Date();
		pingStartTime  = new Date();
		pingEndTime = new Date();
		// start control loop thread
		pingControlLoop();
		//start ajay pining loop
		logInfo("starting ping");
		pingAjaxStart();
	}catch(e){
		//alert("error in startPing");
	}
}

// --------------------------------------------------------------------------------------------------------------
// copntrol loop that checks the time differences
// --------------------------------------------------------------------------------------------------------------
function pingControlLoop(){

	var diff;
	var t1;
	var t2;

	try{
		// logic to compare timestamps goes here
		pingCurrentTime = new Date();
		// compare timestamp and set result in logger
		if(pingLoopDoCheck){
			//alert("checking for timeout - YES");
			t1 = pingStartTime.getTime();
			t2 = pingCurrentTime .getTime();
			diff = t2 - t1;

			if(diff > pingMaxDelay){
				logInfo("Ping delay exceeded " + pingMaxDelay + " milliseconds. Value is " + diff);
				//alert("Ping delay exceeded " + pingMaxDelay + " milliseconds. Value is " + diff);
			}
		}else{
			//logInfo("checking for timeout - NO");
		}

		// call myself after a timeout
		//logInfo("pingControlLoop");
		window.setTimeout("pingControlLoop()", 1000);
	}catch(e){
		alert("error in pingControlLoop");
	}
}
// --------------------------------------------------------------------------------------------------------------
// call the ping page
// --------------------------------------------------------------------------------------------------------------
function pingAjaxStart(){
	try{
		pingStartTime  = new Date();
		pingEndTime = new Date();
		//logInfo("pingAjaxStart");
		pingLoopDoCheck  = true;
		getHtmlGet("../admin/ping.pl?time=" + pingEndTime.getTime() , pingAjaxResult)
	}catch(e){
		alert("error in pingAjaxStart");
	}
}
// --------------------------------------------------------------------------------------------------------------
// process the result of ping
// --------------------------------------------------------------------------------------------------------------
function pingAjaxResult(resultText){
	var diff;
	var t1;
	var t2;
	try{
		//document.write(resultText + "<\/br>");

		// set time when ping received
		pingEndTime = new Date();
		// compare 
		t1 = pingStartTime.getTime();
		t2 = pingEndTime.getTime(); 
		diff = t2 - t1;
		logInfo("Ping took " + diff);

		//reset the timestamps
		pingStartTime  = new Date();
		pingEndTime = new Date();
		// fire new ping after waiting a second
		logInfo("pingAjaxResult: " + resultText);
		pingLoopDoCheck  = false;
		window.setTimeout("pingAjaxStart()", pingAjaxLoopTimeout );
	}catch(e){
		alert("error in pingAjaxResult");
	}
}

// ------------------------------------------------------------------------------------------------------------------------
// xxx
// ------------------------------------------------------------------------------------------------------------------------


function GetXmlHttpObject(){
	var http=false;
	try {http=new XMLHttpRequest();} catch (e1){
	try {http=new ActiveXObject("Msxml2.xmlhttp");} catch (e2){
	try {http=new ActiveXObject("Microsoft.xmlhttp");} catch (e3){http=false;}}}
	return http;
}

// ------------------------------------------------------------------------------------------------------------------------
// xxx
// ------------------------------------------------------------------------------------------------------------------------

function getHtmlGet(url,callback)
{
    var http = GetXmlHttpObject();
    var mode = "GET";
    http.open(mode,url,true);
    http.onreadystatechange=function(){if(http.readyState==4){callback(http.responseText);}};
    http.send(mode);
}

// ------------------------------------------------------------------------------------------------------------------------
// xxx
// ------------------------------------------------------------------------------------------------------------------------

function getHtmlGetBlocking(url)
{
	//alert(1);
	var http = GetXmlHttpObject();
	var mode = "GET";
	http.open(mode,url,false);
//	http.onreadystatechange=function(){
//		if(http.readyState==4){
//			alert("xxx");
//			return http.responseText;
//		}
//	};
	// return AJAX.responseText;
	//    http.send(mode);
	http.send(null);
	return http.responseText;
}

// ------------------------------------------------------------------------------------------------------------------------
// xxx
// ------------------------------------------------------------------------------------------------------------------------

function getMethodAnswerInId(url,callback,id)
{
    var http = GetXmlHttpObject();
    //alert("getMethotAnswerInId");
    //alert("getMethotAnswerInId: " + url);
    var mode = "GET";
    http.open(mode,url,true);
    http.onreadystatechange=function(){if(http.readyState==4){callback(id, http.responseText);}};
    http.send(mode);
}
// ------------------------------------------------------------------------------------------------------------------------
// xxx
// ------------------------------------------------------------------------------------------------------------------------

function getMethodWithCallback(url,callback)
{
    var http = GetXmlHttpObject();
    //alert("getMethotAnswerInId");
    //alert("getMethotAnswerInId: " + url);
    var mode = "GET";
    http.open(mode,url,true);
    http.onreadystatechange=function(){if(http.readyState==4){callback(http.responseText);}};
    http.send(mode);
}

// ------------------------------------------------------------------------------------------------------------------------
// xxx
// ------------------------------------------------------------------------------------------------------------------------

function pushAnswerInId(id, responseText){

   //alert(responseText);
   document.getElementById(id).innerHTML = responseText;

}


// ------------------------------------------------------------------------------------------------------------------------
// xxx
// ------------------------------------------------------------------------------------------------------------------------

function getHtmlPostXml(url,request,callback,targetHtml)
{
    var http = GetXmlHttpObject();
    var mode = request?"POST":"GET";
    
    //alert(mode);
    http.open(mode,url,true);
    if(mode=="POST"){http.setRequestHeader('Content-Type','application/x-www-form-urlencoded');}
    http.onreadystatechange=function(){if(http.readyState==4){callback(http.responseText, targetHtml);}};
    http.send(request);
}


// ------------------------------------------------------------------------------------------------------------------------
// xxx
// ------------------------------------------------------------------------------------------------------------------------

function getXmlPostXml(url,xml)
{
	var http = GetXmlHttpObject();
	var mode = "POST";
	
	//alert(mode);
	http.open(mode,url,true);
	if(mode=="POST"){
          http.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
        }
	http.onreadystatechange=function(){
                                  if(http.readyState==4){
                                     callback(http.responseText);
                                      }
        };
	http.send(xml);
	return http.responseXML ;
}


// ------------------------------------------------------------------------------------------------------------------------
// xxx
// ------------------------------------------------------------------------------------------------------------------------

function WebMethod(url,request,callback)
{
    var http = GetXmlHttpObject();
    var mode = request?"POST":"GET";
    
    //alert(mode);
    http.open(mode,url,true);
    if(mode=="POST"){http.setRequestHeader('Content-Type','application/x-www-form-urlencoded');}
    http.onreadystatechange=function(){if(http.readyState==4){callback(http.responseText);}};
    http.send(request);
}

// ------------------------------------------------------------------------------------------------------------------------
// xxx
// ------------------------------------------------------------------------------------------------------------------------

// example
function LoadMail(){
    // ShowMail is the callback function that will receive the response
    
    var f1 = document.getElementById("feld1").value ;
    var f2 = document.getElementById("feld2").value ;
    var f3 = document.getElementById("feld3").value ;
    var f4 = document.getElementById("feld4").value ;
    
    var post = 'f1=' +  f1 +   'f2=' +  f2 + 'f3=' +  f3 + 'f4=' +  f4 ;
    
    WebMethod("http://www.as-admin.net/cgi-bin/dev/admin/ajax.pl",post,ShowMail);
}

// ------------------------------------------------------------------------------------------------------------------------
// xxx
// ------------------------------------------------------------------------------------------------------------------------

// teh callback function
function ShowMail(response){
    // do stuff with response
    alert(response);
}

// ------------------------------------------------------------------------------------------------------------------------
// xxx
// ------------------------------------------------------------------------------------------------------------------------

function ajaxGetMethodAnswerInMsgBox(url)
{
    var http = GetXmlHttpObject();
    //alert("getMethotAnswerInId");
    //alert("getMethotAnswerInId: " + url);
    var mode = "GET";
    http.open(mode,url,true);
    http.onreadystatechange=function(){if(http.readyState==4){alert(http.responseText);}};
    http.send(mode);
}

// ------------------------------------------------------------------------------------------------------------------------
// xxx
// ------------------------------------------------------------------------------------------------------------------------

function ajaxGetMethodAnswerInLog(url)
{
    var http = GetXmlHttpObject();
    //alert("getMethotAnswerInId");
    //alert("getMethotAnswerInId: " + url);
    var mode = "GET";
    http.open(mode,url,true);
    http.onreadystatechange=function(){if(http.readyState==4){logInfo(http.responseText);}};
    http.send(mode);
}

// --------------------------------------------------------------------------------------------------------------
// this function is called by the html tags
// --------------------------------------------------------------------------------------------------------------

function onChFrmBack(obj){

	// we assume that vs and vu is global viable
		
	try{
		onChangeFormBackup(globalSession, globalUser, obj.id, obj.value);	
	}catch(e){
		alert("error in pingControlLoop");
	}
}

// --------------------------------------------------------------------------------------------------------------
// the function that constructs the request
// --------------------------------------------------------------------------------------------------------------
function onChangeFormBackup(vs, vu, id, content){

	try{
		var url;	
		var params = new Array(4);
		params[0] = new Array(2);
		params[1] = new Array(2);
		params[2] = new Array(2);
		params[3] = new Array(2);

		params[0][0] = "v_s";
		params[0][1] = vs;
		params[1][0] = "v_u";
		params[1][1] = vu;
		params[2][0] = "id";
		params[2][1] = id;
		params[3][0] = "content";
		params[3][1] = content;	
	
	// we assume a certain file hierarchy
	url = '../data/ajaxBackup.pl';

	ajaxPostMethodAnswerInLog(url, params);

	}catch(e){
		alert("error in onChangeFormBackup: " + e);
	}
}

// --------------------------------------------------------------------------------------------------------------
// generic ajax PostRequest that sends result to log file
// --------------------------------------------------------------------------------------------------------------

function ajaxPostMethodAnswerInLog(url, params){
	var paramsString = "";
	var i = 0;

	try{
	
		for(i = 0; i < params.length; i++){
			if(i > 0){
				paramsString =  paramsString  + "&"
			}
			paramsString = paramsString  + encodeURIComponent(params[i][0])  + "="  + encodeURIComponent(params[i][1]);
		}
			
		var http = GetXmlHttpObject();
		http.open('POST', url);
		http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		http.onreadystatechange=function(){if(http.readyState==4){logInfo(http.responseText);}};
		http.send(paramsString);

	}catch(e){
		alert("error in ajaxPostMethodAnswerInLog: " + e);
	}	
}

// --------------------------------------------------------------------------------------------------------------
// start ping
// --------------------------------------------------------------------------------------------------------------

window.setTimeout("startPing()", 2000);
