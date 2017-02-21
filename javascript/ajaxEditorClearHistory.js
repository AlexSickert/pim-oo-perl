
// ----------------------------------------------------------------------------------------------------
// clear all history of all files
// ----------------------------------------------------------------------------------------------------

function clearHistory(){ 

	// https://ssl-id1.de/alex-admin.net/alex-admin/live/perl/editor/ajaxDeleteHistory.pl
	var url = "https://ssl-id1.de/alex-admin.net/alex-admin/live/perl/editor/ajaxDeleteHistory.pl";
	var http = GetXmlHttpObject();
	var mode = "GET";
	http.open(mode,url,true);
	http.onreadystatechange=function(){if(http.readyState==4){alert(http.responseText);}};
	http.send(mode);
}

// ----------------------------------------------------------------------------------------------------		
//
// ----------------------------------------------------------------------------------------------------
