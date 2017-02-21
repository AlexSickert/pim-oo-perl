/*

Konzept:

- login mit separater seite, danach nur noch 1 seite und dort alles via ajax

1. seite: iPhoneLogin.pl
2. Seite: iPhoneIndex.pl
	- mehrere divs per default da: data, mail, org, navigation
	- aller content wird im gechached um reload zu vermeiden
	- tendentiell alles read only
	- javascript mit Klassen
	- contetn immer mit pipe getrennt
	
	- perl scripts to create:
		- iPhoneMailList.pl     zeigt from und subject in 2 zeilen, aber kein to oder daum etc.
		- iPhoneMailRead.pl     zeigt nur den mail test, kein subject oder so
		- iPhoneMailIframe.pl
		- iPhoneOrg.pl
		- iPhoneData.pl

*/

// ----------------------------------------------------------------------
// constructor
// ----------------------------------------------------------------------
function iPhoneAlex(){

	var currentModule = "";
	var currentPage = "";
	var currentUser = "";
	var currentSession = "";
	var mainDiv = "iPhone";  // usually holds the content

	var buttonArray = new Array(0);   // array that holds the buttons for window resizing

	// ----------------------------------------------------------------------
	// show a mail by id
	// ----------------------------------------------------------------------
	this.showMail = function(id){
		// create url
		var url = "../mail/iPhoneShowMail.pl?mailId=" + id + "&v_u=" + currentUser  + "&v_s=" + currentSession;
		// call ajax
		//alert("calling ajax");
		getMethodWithCallback(url,iPhoneObject.showMailCallback);
	}
	// ----------------------------------------------------------------------
	// show a mail by id
	// ----------------------------------------------------------------------
	this.showMailCallback = function(content){
		// use the content and
		var contentArr = content.split("<delimiter>");
		var top = iPhoneObject.getButton("Inbox", "iPhoneObject.mailInbox", "inbox", 90, 15, "btnMailInbox");
		var middle = contentArr[0];
		var main  = contentArr[2];
		var table;
		table = iPhoneObject.getStandardTableThree(top,middle, main);
		iPhoneObject.registerButton("mailContent",90,90);
		// mailContent
		iPhoneObject.setContent(table);
	}
	// ----------------------------------------------------------------------
	// make a button with title and method and id
	// ----------------------------------------------------------------------
	this.getButton = function(title, method, id, w, h, idForHandle){
		var str = "<input type='button'  id='" + idForHandle + "' style='width: " + this.calcWidth(w) + "; heigth: " + this.calcHeigth(h) + "' value='" + title + "' onclick='" + method + "(\"" + id + "\");'>";
		// style="font-size:10pt;"
		// register in the resiz array
		this.registerButton(idForHandle, w, h);
		return str ;
	}
	// ----------------------------------------------------------------------
	// set button size
	// ----------------------------------------------------------------------
	this.setButtonSize = function(id, w, h){
		var theObject;
		try{
			theObject = document.getElementById(id);
	      		theObject.style.width = this.calcWidth(w) + "px";
	      		theObject.style.height = this.calcHeigth(h) + "px";
			//alert(w + " - " + h);
			
		}catch(e){
			//alert(e);
		}
	}
	// ----------------------------------------------------------------------
	// set button size
	// ----------------------------------------------------------------------
	this.setButtonSizeLoop = function(){
		var id;
		var w;
		var h;

		for(var i = 0; i < buttonArray.length; i++){
	
			id = buttonArray[i][0];
			w = buttonArray[i][1];
			h = buttonArray[i][2];
			this.setButtonSize(id, w, h);
		}
	}
	// ----------------------------------------------------------------------
	// calcaulte width of button
	// ----------------------------------------------------------------------
	this.calcWidth = function(x){
		var y;
		y = this.windowWidth() * (x/100);
		return Math.round(y);	
	}

	// ----------------------------------------------------------------------
	// calcaulte heigth of button
	// ----------------------------------------------------------------------
	this.calcHeigth = function(x){
		var y;
		y = this.windowHeigth() * (x/100);
		return Math.round(y);	
	}
	// ----------------------------------------------------------------------
	// calcaulte heigth of button
	// ----------------------------------------------------------------------
	this.windowWidth = function() {
	  if (window.innerWidth) {
	    return window.innerWidth;
	  } else if (document.body && document.body.offsetWidth) {
	    return document.body.offsetWidth;
	  } else {
	    return 0;
	  }
	}
	// ----------------------------------------------------------------------
	// calcaulte heigth of button
	// ----------------------------------------------------------------------
	this.windowHeigth = function() {
	  if (window.innerHeight) {
	    return window.innerHeight;
	  } else if (document.body && document.body.offsetHeight) {
	    return document.body.offsetHeight;
	  } else {
	    return 0;
	  }
	}
	// ----------------------------------------------------------------------
	// make a button with title and method and id
	// ----------------------------------------------------------------------
	this.registerButton = function(id, width, heigth){
		var button = new Array(3);
		button[0]  = id;
		button[1]  = width;
		button[2]  = heigth;
		buttonArray.push(button); 
		//alert("yyy - l: " + buttonArray.length);
	}

	// ----------------------------------------------------------------------
	// make a TD
	// ----------------------------------------------------------------------
	this.getTd = function(fontSize, content){
		// display main navigation
	}

	// ----------------------------------------------------------------------
	// make a TR
	// ----------------------------------------------------------------------
	this.getTr = function(content){
		// 
	}

	// ----------------------------------------------------------------------
	// make a Table
	// ----------------------------------------------------------------------
	this.getTable = function(content){
		// 
	}
	// ----------------------------------------------------------------------
	// get a standard Table - used often
	// ----------------------------------------------------------------------
	this.getStandardTable = function(top,main){
		var str = "<table>";
		str += "<tr>";
		str += "<td>";
		str += top;  // here goes teh button
		str += "</td>";
		str += "</tr>";
		str += "<tr>";
		str += "<td>";
		str += main;  // and here goes the main content
		str += "</td>";
		str += "</tr>";
		str += "</table>";
		return str;
	}

	// ----------------------------------------------------------------------
	// get a standard Table - three fields
	// ----------------------------------------------------------------------
	this.getStandardTableThree = function(top,middle, main){
		var str = "<table>";
		str += "<tr>";
		str += "<td>";
		str += top;  // here goes teh button
		str += "</td>";
		str += "</tr>";
		str += "<tr>";
		str += "<td>";
		str += middle;  // here goes teh button
		str += "</td>";
		str += "</tr>";
		str += "<tr>";
		str += "<td>";
		str += main;  // and here goes the main content
		str += "</td>";
		str += "</tr>";
		str += "</table>";
		return str;
	}
	// ----------------------------------------------------------------------
	// show main navigation
	// ----------------------------------------------------------------------
	this.navigationMain = function(){
		var str = "<center>";
		str += this.getButton("Data", "iPhoneObject .navigationData", "", 90, 30, "btnNaviData") + "<br />";
		str += this.getButton("Mail", "iPhoneObject .navigationMail", "", 90, 30, "btnNaviMail") + "<br />";
		str += this.getButton("Org", "iPhoneObject .navigationOrg", "", 90, 30, "btnNaviOrg") + "</center>";
		this.setContent(str);
	}

	// ----------------------------------------------------------------------
	// show data navigation
	// ----------------------------------------------------------------------
	this.navigationData = function(){
		try{
			var str = "<center>";
			str += this.getButton("Main", "iPhoneObject .navigationMain", "", 90, 40, "btnDataMain") + "<br />";
			str += this.getButton("Search", "iPhoneObject.dataSearch", "", 90, 40, "btnDataSearch") + "<br />";
			str += "</center>";
			this.setContent(str);
		}catch(e){
			alert(e);
		}
	}

	// ----------------------------------------------------------------------
	// show data search
	// ----------------------------------------------------------------------
	this.dataSearch = function(){
		try{
			var navi = "";
			navi += this.getButton("Main", "iPhoneObject .navigationMain", "", 90, 40, "btnDataSearchMain");
			navi += this.getButton("Data", "iPhoneObject .navigationData", "", 90, 40, "btnDataData");
			var str = this.getStandardTable(navi, "body");
			this.setContent(str);
		}catch(e){
			//alert(e);
		}
	}

	// ----------------------------------------------------------------------
	// show mail navigation
	// ----------------------------------------------------------------------
	this.navigationMail = function(){
		var str = "<center>";
		str += this.getButton("Main", "iPhoneObject .navigationMain", "", 90, 20, "btnMailMain") + "<br />";
		str += this.getButton("Load new mail", "iPhoneObject.mailLoadNew", "", 90, 20, "btnMailLoad") + "<br />";
		str += this.getButton("Inbox", "iPhoneObject.mailInbox", "inbox", 90, 20, "btnMailInbox") + "<br />";
		str += this.getButton("Search", "alert", "search", 90, 20, "btnMailSearch") + "<br />";
		str += "</center>";
		this.setContent(str);
	}

	// ----------------------------------------------------------------------
	// load new mails
	// ----------------------------------------------------------------------
	this.mailLoadNew = function(){

		// create url
		var url = "../mail/iPhoneAjaxLoadNewMails.pl?v_u=" + currentUser  + "&v_s=" + currentSession;
		// call ajax
		getMethodWithCallback(url,alert);
	}

	// ----------------------------------------------------------------------
	// show mail inbox
	// ----------------------------------------------------------------------
	this.mailInbox = function(){

		// create url
		var url = "../mail/iPhoneAjaxMailsTable.pl?v_u=" + currentUser  + "&v_s=" + currentSession;
		// call ajax
//		alert("calling ajax");
		getMethodWithCallback(url,iPhoneObject.mailInboxCallback);
	}

	// ----------------------------------------------------------------------
	// show mail inbox
	// ----------------------------------------------------------------------
	this.mailInboxCallback = function(str){
		//alert("callback called: " + str);		
		var top = iPhoneObject.getButton("Mail menu", "iPhoneObject.navigationMail", "", 90, 15, "btnInboxBack");
		var main = iPhoneObject.mailTransformTable(str);		
		iPhoneObject.setContent(iPhoneObject.getStandardTable(top,main));
	}

	// ----------------------------------------------------------------------
	// show mail inbox
	// ----------------------------------------------------------------------
	this.mailTransformTable = function(str){
		var rows = str.split("<r>");
		var y;
		var x;
		var row;
		var fields;
		var ret;
		
		ret = "<table width='100%'>" 
		for(y = 0; y < rows.length; y++){
			ret += "<tr>"; 
			fields = rows[y].split("<f>");

			ret += "<td>"; 
			ret += this.getButton("?", "iPhoneObject.showMail", fields[0], 10, 15, "btn" + fields[0]);
			ret += "</td>"; 
			ret += "<td class='standardContent' >"; 
			ret += fields[1] + "<br />" + fields[2] + "[" +  fields[3] + "]"; 
			ret += "</td>"; 
			ret += "</tr>"; 
		}
		ret += "</table>"; 
		return ret;
	}

	// ----------------------------------------------------------------------
	// show org navigation
	// ----------------------------------------------------------------------
	this.navigationOrg = function(){
		var str = "<center>";
		str += this.getButton("Main", "iPhoneObject .navigationMain", "", 45, 30, "btnOrgMain") + "&nbsp;";
		str += this.getButton("Today", "alert", "today", 45, 30, "btnOrgToday") + "<br />";
		str += this.getButton("Week", "alert", "week", 45, 30, "btnOrgWeek") + "&nbsp;";
		str += this.getButton("Goto", "alert", "goto", 45, 30, "btnOrgGoto") + "<br />";
		str += this.getButton("Actions", "alert", "actions", 45, 30, "btnOrgActions") + "&nbsp;";
		str += this.getButton("Calendar List", "alert", "list", 45, 30, "btnOrgList") + "";
		str += "</center>";
		this.setContent(str);
	}

	// ----------------------------------------------------------------------
	// set content in maindiv
	// ----------------------------------------------------------------------
	this.setContent = function(s){
		document.getElementById(mainDiv).innerHTML = s;
		this.setButtonSizeLoop();
	}

	// ----------------------------------------------------------------------
	// convert a twodimensional array to a table
	// first element in array is id for processing
	// give function method in second parameter of table
	// ----------------------------------------------------------------------
	this.convertArrayToTable = function(arr, func){
		//
	}
	// ----------------------------------------------------------------------
	// convert a string to a two dimensional array
	// delimiters are predefined
	// ----------------------------------------------------------------------
	this.convertStringToArray = function(s){
		//   flied delimiter is <f>
		//   row delimiter is <r>
	}
	// ----------------------------------------------------------------------
	// start application by loading initial content - navigation only
	// ----------------------------------------------------------------------
	this.initialize = function(){
		currentUser = globalUser;
		currentSession = globalSession;
		this.navigationMain();
		// initialize resizing of buttons
		this.setButtonSizeLoop();

	}
}

// ----------------------------------------------------------------------
// start application
// ----------------------------------------------------------------------
var iPhoneObject = new iPhoneAlex();  // do not change the name of the object because its used later in html code
//then wait 3 seconds;

window.onresize = function(event) {
	//alert("ss");
	iPhoneObject.setButtonSizeLoop(); 
}
