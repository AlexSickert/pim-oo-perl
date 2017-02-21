
//alert("mobileLanguage.js");

var fromLanguage = "";
var fromLanguageValue = "";
var fromLanguageLabel = "";
var toLanguage = "";
var toLanguageValue = "";
var toLanguageLabel = "";
var result = "";
var id = "";

// startup function to get values first time - gets called automatically
function initialize(){
	//alert("inititalize");
	getMethodWithCallback(makeUrl(),setValues);
}

function menu(){
	alert("not implemented");
}

function question(){
	showHide('V2');
}

function processOk(){
	result = 'Ok';
	setLoading();
	getMethodWithCallback(makeUrl(),setValues);
}

function processNo(){
	result = 'No';
	setLoading();
	getMethodWithCallback(makeUrl(),setValues);
}

function makeUrl(){
	//alert("makeUrl");
	var url = "./mobileAjaxProcess.pl?";
	url = url  + "id=" + id + "&";
	url = url  + "fromLanguage=" + fromLanguage + "&";
	url = url  + "toLanguage=" + toLanguage + "&";
	url = url  + "result=" + result + "&";
	//alert(url);
	return url;
}


// callback of ajax
function setValues(s){
	//alert("setValues: " + s);
	var arr= s.split("<x>");
	var info;

	id = arr[0];
	fromLanguageLabel = arr[1];
	fromLanguage = arr[2];
	fromLanguageValue = arr[3];
	toLanguageLabel = arr[4];
	toLanguage = arr[5];
	toLanguageValue = arr[6];
	info = arr[8];

	document.getElementById("L1").innerHTML = fromLanguageLabel + ":";
	document.getElementById("V1").innerHTML = fromLanguageValue;

	document.getElementById("L2").innerHTML = toLanguageLabel + "?";
	document.getElementById("V2").innerHTML = toLanguageValue;
	//document.getElementById("V2").innerHTML = toLanguageValue + arr[7];
	document.getElementById("info").innerHTML = info;

	document.getElementById('V2').style.visibility = "hidden";

}

function setLoading(){
	document.getElementById("L1").innerHTML = "Loading...";
	document.getElementById("V1").innerHTML = "";
	document.getElementById("L2").innerHTML = "";
	document.getElementById("V2").innerHTML = "";
}

function showHide(id)
{
    if (document.getElementById(id).style.visibility == "hidden" || document.getElementById(id).style.visibility == "")
    {
        document.getElementById(id).style.visibility = "visible";
    }else{
        document.getElementById(id).style.visibility = "hidden";
    }
}


initialize();

