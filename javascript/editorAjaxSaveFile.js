

function ajaxSaveFile(saveAction, saveContent, savePath, url){

	var i;

	document.getElementById('message').style.backgroundColor = "#FF0000";

	for(i = 1; i < 1000; i++){
	
		document.getElementById('message').style.backgroundColor = "#FF0000";

	}
	
	var content = "";

	var contentPlus1 = saveContent.replace(/\+/g, "#SpecialCharPlusSign#");

	var contentPlus = contentPlus1.replace(/%%%02X/g, "#percentpercentpercentzerotwoix#");


	content = escape(contentPlus);

	var xml = "";

	xml = "xml=<?xml version='1.0' encoding='ISO-8859-1' ?><parameter><action>"+saveAction+"</action><filepath>"+savePath+"</filepath><content>"+content+"</content></parameter>";
	
	getHtmlPostXml(url,xml,ajaxSaveFileResult,'x')


}





function ajaxSaveFileResult( innerHtml , parentHtml){

	document.getElementById('message').value = innerHtml ;

        if(innerHtml.match(/error/)){
		alert(innerHtml );
		document.getElementById('message').style.backgroundColor = "#FF0000";
   	}else{
		document.getElementById('message').style.backgroundColor = "#00FF00";
	}

}