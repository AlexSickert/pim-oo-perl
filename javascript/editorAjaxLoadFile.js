

function ajaxLoadFile(path, element, url){

//alert(path);

var xml = "";
var response = "";

xml = "xml=<?xml version='1.0' encoding='ISO-8859-1' ?><parameter> <filepath>"+path+"</filepath></parameter>";
//alert("load folder" + xml);
//alert(url);
//getHtmlPostXml('http://www.as-admin.net/cgi-bin/dev/admin/editCodeAjaxLoadFolder.pl', xml );
getHtmlPostXml(url,xml,ajaxSetFile,element)

}

function ajaxSetFile( content, element){
	//alert('in ajaxSetFile' + content + "element: " + element);

	var theString = unescape(content);	
	// ajax baut irgendwo lästige zeilenumbrüche rein
	var theStringFinal = theString.slice(3);
	document.getElementById(element).value = theStringFinal;	
}