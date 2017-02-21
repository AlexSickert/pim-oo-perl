// ----------------------------------------------------------------------
// definition of the class
// ----------------------------------------------------------------------

//var Mitarbeiter = new Array();
//Mitarbeiter[0] = new Object();
//Mitarbeiter[0]["Name"] = "Müller";
//Mitarbeiter[0]["Vorname"] = "Hans";
//Mitarbeiter[0]["Wohnort"] = "Dresden";
//Mitarbeiter[1] = new Object();
//Mitarbeiter[1]["Name"] = "Schulze";
//Mitarbeiter[1]["Vorname"] = "Frauke";
//Mitarbeiter[1]["Wohnort"] = "Berlin";


//arr['key1']="value1";
//arr['key2']="value2";
//arr['key3']="value3";

//65	A	1
//66	B	2
//67	C	3
//68	D	4
//69	E	5
//70	F	6
//71	G	7
//72	H	8
//73	I	9
//74	J	10
//75	K	11
//76	L	12
//77	M	13
//78	N	14
//79	O	15
//80	P	16
//81	Q	17
//82	R	18
//83	S	19
//84	T	20
//85	U	21
//86	V	22
//87	W	23
//88	X	24
//89	Y	25
//90	Z	26

// chache that holds all values that should be calculated only once
var cacheValues = new Array();
var cacheFormulas = new Array();

function TabCalc(tableId) {
	this.tableId = tableId;  // element to connect the table
	this.rows = 1;  // number of rows starting with 1
	this.fields = 2;  // number of columns starting wit 1 - need to transform it to characters
	//alert("hallo");

	// ----------------------------------------------------------------------	
	// test - do not remove this !!!!!!!!!
	// ----------------------------------------------------------------------	
	this.TEST = function () { 
		//alert("i am a test function");
		return 1;
	};
	// ----------------------------------------------------------------------	
	// entry function
	// ----------------------------------------------------------------------	
	this.execute = function (col, row, val) { 
		var retVal = 0;
		var formulaStr;
		var id;
		id = col + "X" + row;

		this.setFormula (id, val);

		try{
			// replace all functions with the object reference and add the value at the beginning
			formulaStr = "retVal = ";
			val = val.replace(/test\(/gi, "Calculator.TEST(");
			val = val.replace(/nval\(/gi, "Calculator.NVAL(");
			val = val.replace(/sval\(/gi, "Calculator.SVAL(");
			val = val.replace(/vsum\(/gi, "Calculator.VSUM(");
			val = val.replace(/hsum\(/gi, "Calculator.HSUM(");
//			val = val.replace(/get\(/gi, "Calculator.GET(\"" + id + "\", ");
			val = val.replace(/getasy\(/gi, "Calculator.GETASY(\"" + id + "\", ");
			formulaStr += val + ";";
			//alert(formulaStr);
			coreLogInfo("calculating: " + formulaStr);
			eval(formulaStr);
		}catch(e){
			//alert("error - see log");
			coreLogInfo("could no calculate: " + val + " ERROR: " + e);
			retVal  = "Value?";
		}
		this.setValue(id , retVal );
	};
	// ----------------------------------------------------------------------	
	// vertical sum of a range
	// ----------------------------------------------------------------------	
	this.VSUM = function (col, rowStart,rowEnd) { 
		var i;
		var id;
		var val;
		val = 0;
		var tmpRet = 0;
		for(i = rowStart; i <= rowEnd; i++){
			tmpRet =  this.NVAL(col, i);
			if(isNaN(tmpRet)){	
				coreLogInfo("not a number: " + tmpRet);
				return "Value?";
			}else{
				val += tmpRet;
			}

		}
		return val;
	};	
	// ----------------------------------------------------------------------
	// horizontal sum of current line
	// ----------------------------------------------------------------------
	this.HSUM = function (row, colStart, colEnd) { 
		var i;
		var id;
		var val;
		val = 0;
		var tmpRet = 0;
		for(i = colStart; i <= colEnd; i++){
			tmpRet = this.NVAL(i, row);
			if(isNaN(tmpRet)){	
				coreLogInfo("not a number: " + tmpRet);
				return "Value?";
			}else{
				val += tmpRet;
			}
		}
		return val;
	};		
	// ----------------------------------------------------------------------	
	// get value from service - service - via ajax
	// ----------------------------------------------------------------------	
	this.GET  = function (domId, service, id){

		var key;
		key = domId + service + id;
		var ret;

		// VALUE?
		var test;
		//test = this.GETFROMID(key);
		test = this.getCache(key);

		coreLogInfo("value for key = " + key + " = " + test);

		if(test == "VALUE?" || test == ""){

			coreLogInfo("need to load - value on = " + test );
			coreLogInfo("in get method  - 1");
			var xmlHttp = null;
			var url = "";
			if(service == "Y" ){
				url = "./getQuote.pl?service=Y&k=999&id=" + id;
				coreLogInfo("in get method  - 2 - url = " + url);
			}else{
				alert("service unknown: " + service);
				return "Value?";
			}
			ret = getHtmlGetBlocking(url) + "";
			this.setCache(key, ret);
			return ret;
		}else{
			coreLogInfo("value alredy set to = " + test );
			return test;
		}

	}

	// ----------------------------------------------------------------------	
	// get value from service - service - via ajax
	// ----------------------------------------------------------------------	
	this.GETASY  = function (domId, service, id){

		var key;
		key = domId + service + id;
		var ret;

		// VALUE?
		var test;
		//test = this.GETFROMID(key);
		test = this.getCache(key);

		coreLogInfo("GETASY   value for key = " + key + " = " + test);

		if(test == "VALUE?" || test == ""){

			coreLogInfo("need to load - value on = " + test );
			coreLogInfo("in get method  - 1");
			
			var url = "";
			if(service == "Y" ){
				url = "./getQuote.pl?service=Y&k=999&id=" + id;
				coreLogInfo("in get method  - 2 - url = " + url);
			}else{
				alert("service unknown: " + service);
				return "Value?";
			}
			//ret = getHtmlGetBlocking(url) + "";
			this.getAjaxAsyncForCache(url,key);
			//this.setCache(key, ret);
			return "VALUE?";
		}else{
			coreLogInfo("GETASY   value alredy set to = " + test );
			return test;
		}

	}

	// ------------------------------------------------------------------------------------------------------------------------
	// helper function
	// ------------------------------------------------------------------------------------------------------------------------
	this.getAjaxAsyncForCache  = function(url,key)
	{
	    var http = GetXmlHttpObject();
	    var mode = "GET";
	    http.open(mode,url,true);
	    http.onreadystatechange=function(){
			if(http.readyState==4){
				//callback(http.responseText);
				Calculator.setCache(key, http.responseText);
			}
		};
	    http.send(mode);
	}
	// ----------------------------------------------------------------------	
	// round value - round2 for 2 decimals
	// ----------------------------------------------------------------------
	this.getCache  = function (id){
		var key = id + "#";
		var ret;
		try{
			if(typeof(cacheValues[id])=="undefined"){
				return "";
			}else{
				ret = cacheValues[id] + "";
			}			
			return ret;
		}catch(e){
			return "";
		}
	}
	// ----------------------------------------------------------------------	
	// round value - round2 for 2 decimals
	// ----------------------------------------------------------------------
	this.setCache  = function (id, val){
		var key = id + "#";
		cacheValues[id] = val;
	}

	// ----------------------------------------------------------------------	
	// round value - round2 for 2 decimals
	// ----------------------------------------------------------------------
	this.getFormula  = function (id){
		var key = id + "#";
		var ret;
		try{
			if(typeof(cacheFormulas[id])=="undefined"){
				return "";
			}else{
				ret = cacheFormulas[id] + "";
			}			
			return ret;
		}catch(e){
			return "";
		}
	}
	// ----------------------------------------------------------------------	
	// round value - round2 for 2 decimals
	// ----------------------------------------------------------------------
	this.setFormula  = function (id, val){
		var key = id + "#";
		cacheFormulas[id] = val;
	}
	// ----------------------------------------------------------------------	
	// round value - round2 for 2 decimals
	// ----------------------------------------------------------------------	
	
	
	// ----------------------------------------------------------------------	
	// get value from accounting service - service - via ajax
	// ----------------------------------------------------------------------	
	// ----------------------------------------------------------------------	
	// get value from cell - number
	// ----------------------------------------------------------------------	
	this.NVAL = function (col, row) { 
		var x;
		var id;
		id = col + "X" + row;
		try{
			x = document.getElementById(id).innerHTML;
			if(isNaN(x)){	
				coreLogInfo("VAL - not a number in col: " + col + " row: " + row + " value: " + x);
				return "VALUE?";
			}else{
				x = x * 1;
			}	
			return x;
		}catch(e){
			coreLogInfo("error in VAL: " + e);
			return "VALUE?";
		}
	};

	// ----------------------------------------------------------------------	
	// get value from cell - string
	// ----------------------------------------------------------------------	
	this.SVAL = function (col, row) { 
		var x;
		var id;
		id = col + "X" + row;
		try{
			x = document.getElementById(id).innerHTML;	
			return x;
		}catch(e){
			coreLogInfo("error in VAL: " + e);
			return "VALUE?";
		}
	};
	// ----------------------------------------------------------------------	
	// test if cell value is numeric	
	// ----------------------------------------------------------------------	

	// ----------------------------------------------------------------------	
	// get from ID
	// ----------------------------------------------------------------------	
	this.GETFROMID = function (id) { 
		var x;
		var id;
		
		try{
			x = document.getElementById(id).innerHTML;	
			return x;
		}catch(e){
			coreLogInfo("error in VAL: " + e);
			return "VALUE?";
		}
	};
	// ----------------------------------------------------------------------	
	// get the id of a tab cell from x y coordinates
	// ----------------------------------------------------------------------
	// ----------------------------------------------------------------------	
	// set value in cell
	// ----------------------------------------------------------------------	
	this.setValue = function(id, responseText){
		//alert(responseText);
		try{
		document.getElementById(id).innerHTML = responseText;
		}catch(e){
			coreLogInfo("could not get value for id: " + id);
		}
	}
	// ----------------------------------------------------------------------	
	// fire calculation of all fileds - starting from upper left corner ot bottom right	
	// ----------------------------------------------------------------------	
	// ----------------------------------------------------------------------	
	// fire calculation loop	
	// ----------------------------------------------------------------------	
	// ----------------------------------------------------------------------	
	// stop calculation loop
	// ----------------------------------------------------------------------	
	// ----------------------------------------------------------------------	
	// set formula for editing
	// ----------------------------------------------------------------------	
	this.setFormulaForEdit = function(id){
		//alert(responseText);
		var x;
		var setVal = "";
		try{
			//alert(id);
			x = this.getFormula(id);

			if(x.length > 0){
				setVal = "=" + x;
			}else{
				setVal = document.getElementById(id).innerHTML;
			}

			document.getElementById('formulaInput').value = setVal;
			document.getElementById('formulaInputId').value = id;
		}catch(e){
			coreLogInfo("this.setFormulaForEdit - could not get value for id: " + id);
		}
	}
}

var Calculator = new TabCalc();


