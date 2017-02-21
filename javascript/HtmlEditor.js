//-------------------------------------------------------------------------------------------------
// Edit html content in WYSIWYG editor
// all needed is a div for the menu and a div for the content
// the editor has also a method that adds stuff to a log 
// the HtmlEditor itself has only two direct methods:
//			1. setMenu()
//			2. log()
// all other stuff is done automatically
//--------------------------------------------------------------------------------------------------

function HtmlEditor(menuId,contentId, instanceName, logId) {
	// variable definitions
	this.menuId = menuId;  // tag where menu is stored
	this.contentId = contentId;  // div id where we edit the text
	this.instanceName = instanceName; // needed to be able to put html code with methods in place
	this.logId= logId; // needed to be able to put html code with methods in place
	// create heloer object
	this.Menu= new Menu(this.instanceName, this.logId); // create child object
	// create manipulator
	this.manipulator = new Manipulator(this.instanceName, this.logId);
	//--------------------------------------------------------------------------------------------------
	// set the menue by adding all necessary tags 
	//--------------------------------------------------------------------------------------------------
	this.setMenu = function () { 
		this.Menu.add('bold', 'bold', 'boldstyle');
	};
	//--------------------------------------------------------------------------------------------------
	// set the menue by adding all necessary tags 
	//--------------------------------------------------------------------------------------------------
	this.log = function (x) { 
		alert("I want to log this: " + x);
	};
	//--------------------------------------------------------------------------------------------------
	// start of helper class
	//--------------------------------------------------------------------------------------------------
	function Menu(instanceName, logId){ 
		this.HelperString = "menustring";
		this.menuHtmlContent = "";
		this.logId= logId; // needed to be able to put html code with methods in place
		this.instanceName = instanceName; // needed to be able to put html code with methods in place
		alert("inner class constructor");
		//-------------------------------------------------------------------------------------------------
		// clear the menu html content
		//--------------------------------------------------------------------------------------------------  
		this.clear= function(){
			this.menuHtmlContent = "";
		}
		//-------------------------------------------------------------------------------------------------
		//add a button to the menu
		//--------------------------------------------------------------------------------------------------  
		this.add= function(label, associatedMethod, styleString){
			this.menuHtmlContent += "<div onclick='" + this.instanceName + "." +  associatedMethod + "()' style='" + styleString + "'">" + label + </>" ;
		}
		//-------------------------------------------------------------------------------------------------
		// get the menu html content
		//--------------------------------------------------------------------------------------------------  
		this.get= function(){
			return this.menuHtmlContent;
		}
	};
	// end of helper class	
	//--------------------------------------------------------------------------------------------------
	//--------------------------------------------------------------------------------------------------
	// start of manipulator class
	//--------------------------------------------------------------------------------------------------
	function Manipulator(instanceName, logId){ 
		this.logId= logId; // needed to be able to put html code with methods in place
		this.makeBold= function(){
			alert("I make the content bold");
		}		
	}
	// end of manipulator class
	//--------------------------------------------------------------------------------------------------
}

// end of HtmlEditor class
//--------------------------------------------------------------------------------------------------
// running a test of the stuff...
//--------------------------------------------------------------------------------------------------
var testcircle = new HtmlEditor(3,4,5);
testcircle.Menu.show();
testcircle.setMenu();
alert("done");