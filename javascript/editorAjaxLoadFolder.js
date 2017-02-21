
function ajaxLoadFolder(folderPath, foldersDropDown, url, defaultFolder){

	var xml = "";
	var response = "";

	if(folderPath == ""){
		folderPath = defaultFolder;
	}
	
	
	xml = "xml=<?xml version='1.0' encoding='ISO-8859-1' ?><parameter> <folderpath>"+folderPath+"</folderpath></parameter>";
	//alert("load folder" + xml);
	//getHtmlPostXml('http://www.as-admin.net/cgi-bin/dev/admin/editCodeAjaxLoadFolder.pl', xml );
    //alert("url: " + url);
    //alert("xml: " + xml);
    //alert("ajaxSetFolder: " + ajaxSetFolder);
    //alert("foldersDropDown: " + foldersDropDown);
	getHtmlPostXml(url,xml,ajaxSetFolder,foldersDropDown)
};

function ajaxSetFolder( innerHtml , parentHtml){

//alert("ajaxSetFolder html = " + innerHtml);
document.getElementById(parentHtml).innerHTML = innerHtml;
}