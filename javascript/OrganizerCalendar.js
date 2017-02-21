
//in glob alen variablen setzt man die aktuellen parameter.
// Objektname = new Date(Jahr, Monat, Tag);
//currentDate = new Date();
//   var today       =new Date();
//   var in_a_week   =new Date().setDate(today.getDate()+7);
//   var ten_days_ago=new Date().setDate(today.getDate()-10);

// -------------------------------------------------------------------------------------------------------------------
//  show or hide the calendar alert window
// -------------------------------------------------------------------------------------------------------------------

function orgShowHideCalendarAlert(){
	orgShowHideCalendarAlertDiv();
	orgCalendarAlertAjax();
}

// -------------------------------------------------------------------------------------------------------------------
//  show or hide the calendar alert window
// -------------------------------------------------------------------------------------------------------------------

function orgShowHideCalendarAlertDiv(){
	var id = 'calendarAlert';
	var testSTring = document.getElementById(id).style.display;
	var result = testSTring.match(/inline/gi);	
	if(result){
		hideDiv(id);
	}else{
		showDiv(id);	
		positionContainerAbsolut(id , "CENTER", "CENTER", 10, 10, 10,10);	
	}
}

// -------------------------------------------------------------------------------------------------------------------
//  load the calendar alert after a certain timeout
// -------------------------------------------------------------------------------------------------------------------
function orgCalendarAlert(){
	// start after 10 minutes
	// this load only the data
	var t=setTimeout("orgCalendarAlertAjax()",60000);
	// this shows the data
	var t2=setTimeout("orgShowHideCalendarAlertDiv()",120000);
}
// -------------------------------------------------------------------------------------------------------------------
//  
// -------------------------------------------------------------------------------------------------------------------
function orgCalendarAlertAjax(){
	var myOrgCalendar = new OrganizerCalendar();
    	document.getElementById("calendarAlert").innerHTML = "loading...";
    	var timestamp = new Date().getTime();
	var url = "../data/ajaxOrg.pl?"
	url += "category=calendarAlert";
	url += "&offset=";
	url += "&location=";
    	url += "&t_s=" + timestamp;
    	url += "&fromDate=" + myOrgCalendar .getSQLDateString(myOrgCalendar.getInitialDate(new Date(), "3d"));;
    	url += "&toDate=" + myOrgCalendar .getSQLDateString(myOrgCalendar.getEndDate(new Date(), "3d"));;


	// make div visible
	pushAnswerInId("calendarAlert", "Loading data...")
	//showDiv("calendarAlert");	
    	//getMethodAnswerInId(url , orgCalendarAlertAjaxCallback, "calendarAlert");
	getMethodWithCallback(url,orgCalendarAlertAjaxCallback);

}
// ----------------------------------------------------------------------
//  process result and set in div
// ----------------------------------------------------------------------
function orgCalendarAlertAjaxCallback(i){
	//alert(i);
	var myOrgCalendar = new OrganizerCalendar();
	var tab = myOrgCalendar.simpleTableTransform(i);
	// getMethodWithCallback(url,ajaxDataLoaderCallbackHtml);
	// pushAnswerInId
	setContent("calendarAlert", tab);
}
// ----------------------------------------------------------------------
//  adding an actions etc  from mail 
// ----------------------------------------------------------------------

function orgAddActionFromMail(){
	orgAddStuffFromMailDialogue("a");
}

function orgAddCalendarFromMail(){
	orgAddStuffFromMailDialogue("c");
}

function orgAddWaitingFromMail(){
	orgAddStuffFromMailDialogue("w");
}

function orgAddPendingFromMail(){
	orgAddStuffFromMailDialogue("p");
}

function orgAddStuffFromMailDialogue(typeOfAction){

  	var zeit = new Date();
  	var ms = zeit.getTime();
	var url = "ajaxShowOrg.pl?t=" + ms;
	url += "&type=insert&v_u=" + globalUser + "&v_s=" + globalSession;
	url +=  "&category=" + typeOfAction;
	url +=  "&date=" + escape(document.getElementById("orgDate").value);
	url +=  "&mailId=" + escape(document.getElementById("orgMailId").value);
	url +=  "&action=" + escape(document.getElementById("orgTitle").value);
	url +=  "&time=" + escape(document.getElementById("orgTime").value);
	url +=  "&project=" + escape(document.getElementById("orgProject").value);
	//alert(url);
	pushAnswerInId("orgAction", "Wait! saving data...")
   	getMethodAnswerInId(url ,pushAnswerInId,"orgAction");
}

// ----------------------------------------------------------------------
// 
// ----------------------------------------------------------------------

var myOrgCalendar = new OrganizerCalendar();
var myOrgCalendarTargetDiv = "";


// ----------------------------------------------------------------------
// 
// ----------------------------------------------------------------------

function jumpToDate(id){
    	//alert("jump to " + id);
    	//myOrgCalendar.getData(id, "d");

	var url = "./ajaxOrg.pl?category=calendarlist&refDate=" + id;
	//alert(url);
	// this method is located in data.js !!!
	dataSetGlobalsOrganizer("organizer","calendarlist",0,"all");
	getMethodWithCallback(url,ajaxDataLoaderCallbackHtml);


}

// ----------------------------------------------------------------------
// 
// ----------------------------------------------------------------------
function ajaxDataLoaderCallbackHtml(x){
	document.getElementById(myOrgCalendarTargetDiv).innerHTML = x;
}
// ----------------------------------------------------------------------
// 
// ----------------------------------------------------------------------

function ajaxDataLoaderCallback(x){
	myOrgCalendar.processData(x);
}

// ----------------------------------------------------------------------
// 
// ----------------------------------------------------------------------

function addStuff(id){

	// construct the URL
	var url = "";

	//alert("date where we want to add stuff: " + id);

	// get content
	var content = prompt("Action - new ", "new");
	if(content == null){
		alert("aborted");
	}else{
		content = orgStringTrim(content);

		if (content != "") {
			url = "./ajaxOrg.pl?category=newcalendaritem&refDate=" + id + "&content=" + escape(content);
			//ajaxGetMethodAnswerInLog(url);
			//ajaxGetMethodAnswerInMsgBox(url);
			getMethodWithCallback(url,addStuffCallback);
		}
	}

    	//alert("add: " + id);
	// now reload the page - only a temporary solution because if we have an offset then it becomes ugly
	// and as the ajax call is not blocking the reload would be faster than the ajax call
	//window.location.reload();
}

// ------------------------------------------------------------------------------------------------------------
// trim function
// ------------------------------------------------------------------------------------------------------------
function orgStringTrim(s) {
	//alert("orgStringTrim");
  while (s.substring(0,1) == ' ') {
    s = s.substring(1,s.length);
  }
  while (s.substring(s.length-1,s.length) == ' ') {
    s = s.substring(0,s.length-1);
  }
  return s;
}



// ------------------------------------------------------------------------------------------------------------
// call back for add stuf.. aill be a pipe separated string that we split
// ------------------------------------------------------------------------------------------------------------
function addStuffCallback(s){
	try{
		var arr;
		var newElement;
		//split string
		//alert("asfdasdf" + s);
		arr = s.split("|");
		// id, date, content
		// add to existing table via ID
		// this.makeHtmlEntry = function(id, content, idDate){
		newElement = myOrgCalendar.makeHtmlEntry(arr[0], arr[2], arr[1]);
		document.getElementById(arr[1]).innerHTML += newElement ;
	}catch(e){
		alert("addStuffCallback: " + e + " THE original string was " + s);
	}
}

// ------------------------------------------------------------------------------------------------------------
// call back for add stuf.. aill be a pipe separated string that we split
// ------------------------------------------------------------------------------------------------------------
function editStuffCallback(s){
	try{
		var arr;
		var newElement;
		//split string
		//alert("editStuffCallback: " + s);
		arr = s.split("|");
		// id, date, content
		// this.makeHtmlEntry = function(id, content, idDate){
		document.getElementById(arr[0]).innerHTML = arr[2];
	}catch(e){
		alert("editStuffCallback: " + e);
	}
}
// ----------------------------------------------------------------------
// 
// ----------------------------------------------------------------------

function editStuff(idTable, idDate){

	//alert("editStuff: " + idTable + " date: " + idDate);
	var contentNow = document.getElementById(idTable).innerHTML
	var content = prompt("Action - update", contentNow);
	var field = "title";
	var url = "";

	if(content == null){
		alert("aborted");
	}else{
		content = orgStringTrim(content);

		if (content != "") {
			url = "./ajaxOrg.pl?category=ajax&field=" + field + "&row=" + idTable + "&content=" + escape(content);
			//ajaxGetMethodAnswerInLog(url);
			getMethodWithCallback(url,editStuffCallback);
		}
		//window.location.reload();
	}
}

// ----------------------------------------------------------------------
// add style for td, saturday, sunday, current day, span style for date, span style for [+]
// ----------------------------------------------------------------------

function OrganizerCalendar(){
    
    var table = "";
    var td = "";
    var sat = "";
    var sun = "";
    var today = "";
    var spanDate = "";
    var spanPlus = "";
    var span = "";  
    var currentDate;
    var currentOffset;
    var currentFormatting;
    var targetDiv;
    var htmlOfNavi;
    // ----------------------------------------------------------------------
    // div reference
    // ----------------------------------------------------------------------
    
   this.setRef = function(id){
	targetDiv = id;   
	myOrgCalendarTargetDiv  = id;
   }
    
    // ----------------------------------------------------------------------
    // css styles
    // ----------------------------------------------------------------------
    this.setStyles = function(a, b, c, d, e, f, g, h){
        table = a;
        td = b;
        sat = c;
        sun = d;
        today = e;
        spanDate = f;
        spanPlus = g; 
        span = h;        
    }
    
    // ----------------------------------------------------------------------
    //
    // ----------------------------------------------------------------------
    // get data from databse
    this.getData = function(strDateFrom, formatting){
        try{   
            // formatting = max, mid, small, summary
            currentFormatting = formatting;
            currentDate = this.getJsDate(strDateFrom);

	// calculate start date and end date for sql

	var sqlStartDate = this.getSQLDateString(this.getInitialDate(currentDate , formatting));
	//alert(sqlStartDate );	
	var sqlEndDate = this.getSQLDateString(this.getEndDate(currentDate , formatting));
	//alert(sqlEndDate );
     

		//fire to ajax
		var url = "./ajaxOrg.pl?category=day&fromDate=" + sqlStartDate  + "&toDate=" + sqlEndDate;
		getMethodWithCallback(url,ajaxDataLoaderCallback);


        }catch(e){
            alert("this.getData: " + e);
        }
    }

    // --------------------------------------------------------------------------------------------------------------
    // simple list transform - transform data from database to siemple table
    // --------------------------------------------------------------------------------------------------------------
    this.simpleTableTransform = function(data){

        var rows = data.split("<r>");
        var arr = new Array();
        var htmlArray;
        var htmlContent;
	var x = "";
	var ret = "";
	var clsN = "calendarAlertNormal";
	var clsH = "calendarAlertHighlight";
	var cls;

	var nowDateString = this.getSQLDateString(new Date());

        for(var i = 0; i < rows.length; i++){
            arr[i] = rows[i].split("<f>");
        }

            //then fill javascript construct
            for(var i = 0; i < rows.length; i++){
 		try{
			// if date is today then different style 
			if(nowDateString  == arr[i][0]){
				cls = clsH;
			}else{
				cls = clsN;
			}
			ret += "<tr><td class='" +cls + "'>" + arr[i][0] + "</td><td class='" +cls + "'>" + arr[i][2] + "</td></tr>";
		}catch(e){
			logInfo("processData - error with id : '" + x + "' error: " + e);
        	}
            }
	ret = "<table>" + ret  + "</table>";
	return ret;
    }

    // ----------------------------------------------------------------------
    // transform string to a date object
    // ----------------------------------------------------------------------
    this.getJsDate = function(s){
        var x = s.split("-");
        var d = new Date(x[0], x[1] - 1, x[2]);
        return d;
    }
    // ----------------------------------------------------------------------
    //
    // ----------------------------------------------------------------------
    // process data as callback from data loading
    this.processData = function(data){
	//alert(data);
        //transform data to array
        // erst split nach <r> und dann split nach <f>
        var rows = data.split("<r>");
        var arr = new Array();
        var htmlArray;
        var htmlContent;
	var x = "";
        for(var i = 0; i < rows.length; i++){
            arr[i] = rows[i].split("<f>");
        }
        // get the array
        //alert("working wiht date: " + currentDate + " formatting: " + currentFormatting);
        htmlArray = this.getDataArray(currentFormatting, currentDate);
        
        // make html for navigation
        this.makeHtmlNavigation();
        // transform the array into html
        htmlContent = this.transformToHtml(htmlArray);
        document.getElementById(targetDiv).innerHTML = htmlContent;
        
           
            //then fill javascript construct
            for(var i = 0; i < rows.length; i++){
 		try{
			x = arr[i][0];
                	document.getElementById(arr[i][0]).innerHTML += this.makeHtmlEntry(arr[i][1], arr[i][2], arr[i][0]);
		}catch(e){
			logInfo("processData - error with id : '" + x + "' error: " + e);
            	//alert("processData: " + e);
        	}
            }

    }
    // ----------------------------------------------------------------------
    // create an entry
    // ----------------------------------------------------------------------   
    this.makeHtmlEntry = function(id, content, idDate){
        var s;
        s = "<br />";
        //s += "<span class='" + span + "'  id='" + id + "' onclick=\"editStuff('" + id + "', '" + idDate + "');\" >";
	s += "<div class='" + span + "'  id='" + id + "'  onclick=\"editStuff('" + id + "', '" + idDate + "');\" >";
        s += content;
        //s += "</span>";
	s += "</div>";
        return s;
    }
    
    // ----------------------------------------------------------------------
    // make navitgation on tp of table
    // ----------------------------------------------------------------------   
    this.makeHtmlNavigation = function(){
        htmlOfNavi = "here comes the navigtion form function this.makeHtmlNavigation()<br />";
    }
    // ----------------------------------------------------------------------
    // function to initialize an array construct that holds all necessary
    // ----------------------------------------------------------------------    
    this.transformToHtml = function(content){
    
        try{ 
    
            //x, y, z
            var x, y, z;
            var html;
            
            html = htmlOfNavi + "<table  class='" + table + "' >";
            for(y = 0; y < content[0].length; y++){
                html += "<tr>";
                for(x = 0; x < content.length; x++){
                    html += "<td id='" + content[x][y][0] + "'  class='" + td + "' >";

                    // das label muss zu einem html link werden sodass der tag dann editiert werden kenn
                    //sofern es sich nicht um ein tag oder wochen ansicht sondern monat bzw. jahr handelt
 
                    html += "<span  class='" + spanDate + "' onclick=\"jumpToDate('" + content[x][y][0] + "');\" >" + content[x][y][1] + "</span>";
                    if(content[x][y][0].length > 0){
                        html += "&nbsp;<span  class='" + spanPlus + "'  onclick=\"addStuff('" + content[x][y][0] + "');\" >[+]</span>";
                    }

                    html += "</td>";
                }           
                html += "</tr>";
            }
            html += "</table>";
            return html; 
        }catch(e){
            alert("transformToHtml: " + e);
        }
    }
    // ----------------------------------------------------------------------
    // function to initialize an array construct that holds all necessary
    // ----------------------------------------------------------------------
    this.getDataArray = function(typeOfStructure, startDate){
        try{  
            //distinct between day, week, month year
            
            //alert(typeOfStructure);
            // loop von start date bis zum ende. 
            // d=1, w=5, m=35, y= 12*31
            // starting with start date, add one day and contruct date string for id
            // depending of type of structure we need differetn arrays
            var arr;
            
            if(typeOfStructure == "d"){
                arr = this.getGenericDataArray(startDate, 1, 1, 5)
            }
            
            if(typeOfStructure == "w"){               
                arr = this.getGenericDataArray(startDate, 7, 2, 5)
            }
            
            if(typeOfStructure == "m"){
                arr = this.getGenericDataArray(startDate, 7, 6, 5)
            }
            
            if(typeOfStructure == "y"){
                arr = this.getGenericDataArray(startDate, 12, 31, 5)
            } 
            
            return arr;
        }catch(e){
            alert(e);
        }
    }
  
    // ----------------------------------------------------------------------
    //
    // ----------------------------------------------------------------------
    this.getGenericDataArray = function(startDate, cols, rows, depth){
    
	//alert("getGenericDataArray: " + startDate);
        var cellDate;
        var checkDate;
        //array hat 3 dimenstion3 - horizontal 1 hat ein labels und ein fled für deninhalt und dann noch ei feld für id
        // genau dieselbe arraystruktur wie die anderen typen!!! 
        
        // day
        //array hat 3 dimenstion3 - horizontal 1 hat ein labels und ein fled für deninhalt und dann noch ei feld für id
        // genau dieselbe arraystruktur wie die anderen typen!!!
        
        // week
        //array hat 3 dimenstionen - 7 tage horizontal und vertikal hat ein labels und ein fled für deninhalt und in der tiefe label, inhalt, id
        // month
        // array hat 3 dimensionen - 7 tage hundrizontal davon dann 5 reihen und in der tiefe label, inhalt, id
        // year
        // array hat 3 dimensionen - 12 monate horizontal und vertikal 31 reihen und in der tiefe label, inhalt, id
        
        try{    
            var arr = new Array(cols); // for cols
            
            // for each col
            for(var x = 0; x < cols; x++){
               
                arr[x] = new Array(rows); // for rows
                //for each row
                for(var y = 0; y < rows; y++){  
                    
                    arr[x][y] = new Array(5);  // for depth
                    
                    //current date
                    cellDate = this.getCellDate(startDate, x, y, currentFormatting);
		    //alert("getGenericDataArray: " + cellDate);

                    if(currentFormatting == "y"){
                        if(y == 0){
                            checkDate = cellDate;
                        }

                        // this is necessary for not having a month lages on the 31s if month ahs only 30 days
                        if(checkDate.getMonth() == cellDate.getMonth()){
                            arr[x][y][0] = this.getDateStringForID(cellDate); // to be used for manipulating the value
				//alert(cellDate + " vs " + arr[x][y][0]);
                            arr[x][y][1] = this.getDateStringForLabel(cellDate, currentFormatting); //                         
                        }else{				
                            arr[x][y][0] = ""; // to be used for manipulating the value
                            arr[x][y][1] = ""; //                           
                        }
                    }else{
                        arr[x][y][0] = this.getDateStringForID(cellDate); // to be used for manipulating the value
                        arr[x][y][1] = this.getDateStringForLabel(cellDate, currentFormatting); // 
                    }
                    
                    
                    
                    arr[x][y][2] = "";
                    arr[x][y][3] = "";
                    arr[x][y][4] = ""; // content can be added here endlessly
                }
            }
            return arr;
        }catch(e){
            alert("getGenericDataArray: " + e);
        }
    }
    // ----------------------------------------------------------------------
    // calculate the date horicontally - depends if d,w,m,y
    // siehe auch http://de.selfhtml.org/javascript/objekte/date.htm#get_year
    // ----------------------------------------------------------------------
    this.getCellDate = function(date, xOffset, yOffset, type){
    
        var dat; 
        var tmpDate;
        var x;
        var y;
        var z;
	var m;
	var i;
        
        try{  
        
            tmpDate = this.getInitialDate(date, type);
            
            if(type == "d"){
               //nur datum zurück geben
               return date; // nothing to calculate
            }
            
            if(type == "w"){               
               //vertikal geht nix und horizontal +1 nachdem man den dayOfWeek abgezogen hat und so zum Montag kommt
               //return this.addDays(tmpDate, xOffset);
                x = (7 * yOffset) + xOffset;
                return this.addDays(tmpDate, x);
            }
            
            if(type == "m"){
                //zuerst aus getYear und getMonth den anfang ermitteln und dann den ersten tag des monats herstellen
                // dann horizontal jeweils +1 und vertikal + 7
                // problem: feststellen dass man nicht über 30 hinaus geht
                x = (7 * yOffset) + xOffset;
                return this.addDays(tmpDate, x);
            }
            
            if(type == "y"){
               // hier wird das datum aus string zusammen gesetzt. einfach jahr nehmen und monate hinzufügen und dann 
               // umwandeln zu datum
		y = tmpDate.getYear();
                if (y < 999){
                    y += 1900;
                }
//               return new Date(y, xOffset, yOffset + 1);
		// here we need to subtract months but not all months have same lengths - the y offset is easy
		// as a temporary workaround we create the 15th of the months and then subtract always 30,41 days
		tmpDate = new Date(y, tmpDate.getMonth(), 15);
		// then we subtract the months
		i = xOffset * 30.41;
		tmpDate  = this.addDays(tmpDate, i);
		// now get the first day of the month
		y = tmpDate.getYear();
                if (y < 999){
                    y += 1900;
                }
		tmpDate   = new Date(y, tmpDate.getMonth(), 1);
		//now we add the yOffset
		tmpDate  = this.addDays(tmpDate, yOffset);
		return  tmpDate;
            } 
            
            return dat;
        
        }catch(e){
            alert(e);
        }
    }
    // ----------------------------------------------------------------------
    // 
    // ----------------------------------------------------------------------    
    this.addDays = function(d, off){
        var newDate = new Date( d.getTime() + (off  * 24 * 60 * 60 * 1000) );
        return newDate;
    }
    
    // ----------------------------------------------------------------------
    // 
    // ----------------------------------------------------------------------     
     this.getInitialDate = function(date, type){
     
        var ret;
        var d;
        var y;
        var days;
        var newDate;
        y = date.getYear();
        if (y < 999){
            y += 1900;
        }
        
        var monthInYear = date.getMonth();
        //monthInYear = monthInYear - 1;        
        try{    
            if(type == "d"){
               //nur datum zurück geben
               ret = date;
            }
            
            if(type == "3d"){               
               // einen tag davor
               days = date.getDay();
               newDate = new Date( date.getTime() - (1 * 24 * 60 * 60 * 1000) );
               ret = newDate;
            }

            if(type == "w"){               
               //montag der laufenden woche zurück geben
               days = date.getDay();
               //ret = new Date().setDate(now.getDate() - 5);
               newDate = new Date( date.getTime() - (days  * 24 * 60 * 60 * 1000) );
               ret = newDate;
            }
            
            if(type == "m"){
                //return first day of month
                d = new Date(y, monthInYear, 1);
                // if not a monday then we need to shift backwards
                days = d.getDay();
               //ret = new Date().setDate(now.getDate() - 5);
               newDate = new Date( d.getTime() - (days  * 24 * 60 * 60 * 1000) );
               ret = newDate;
                
            }
            
            if(type == "y"){
               // return first day of year - 1st january

		//we desplay the last 3 months and upcoming 9 months

		// first create a date now minus 6 * 30 days = 180
		newDate = this.addDays(date, -90);
		//alert(newDate );

		//now move to the first day of this month
		monthInYear = newDate.getMonth();
	        y = newDate.getYear();

	        if (y < 999){
	            y += 1900;
	        }
                d = new Date(y, monthInYear, 1);
                //d = new Date(y, 0, 1);
                //alert(d);
                ret = d;               
            } 
            
            return ret;
        }catch(e){
            alert(e);
        }
    }   

 // ----------------------------------------------------------------------
    //  get end date 
    // ----------------------------------------------------------------------     
     this.getEndDate = function(dateSelected, type){
     
        var ret;
        var d;
        var y;
        var days;
        var newDate;
	var date

        date = this.getInitialDate(dateSelected, type);
    
        try{    
            if(type == "d"){
		ret = date;
            }
            
            if(type == "3d"){               
               ret = this.addDays(date , 2);
            }

            if(type == "w"){               
               ret = this.addDays(date , 15);
            }
            
            if(type == "m"){
               ret = this.addDays(date , 43);
            }
            
            if(type == "y"){
               ret = this.addDays(date , 400);          
            } 
            
            return ret;
        }catch(e){
            alert(e);
        }
    }   
    // ----------------------------------------------------------------------
    // 
    // ----------------------------------------------------------------------    
    this.getDateStringForID = function(date){
        // hat immer das format df2011x10x02
        // date format = df
        
        var y;
        y = date.getYear();
        if (y < 999){
            y += 1900;
        } 
        
        try{    
            return y + "-" + this.makeDoubleDigit(date.getMonth() + 1) + "-" + this.makeDoubleDigit(date.getDate()) ;
        }catch(e){
            alert(e);
        }
    }
    // ----------------------------------------------------------------------
    // 
    // ----------------------------------------------------------------------    
    this.getSQLDateString = function(date){
        // hat immer das format df2011x10x02
        // date format = df
        
        var y;
        y = date.getYear();
        if (y < 999){
            y += 1900;
        } 
        
        try{    
            return y + "-" + this.makeDoubleDigit(date.getMonth() + 1) + "-" + this.makeDoubleDigit(date.getDate()) ;
        }catch(e){
            alert(e);
        }
    }    
    // ----------------------------------------------------------------------
    // 
    // ----------------------------------------------------------------------  
    
    this.makeDoubleDigit = function(x){
    
        if(x < 10){
            return "0" + x;
        }else{
            return x;
        }
    
    }
    // ----------------------------------------------------------------------
    // 
    // ----------------------------------------------------------------------
    this.getDateStringForLabel = function(date, typeOfStructure){
        // dpending on structure the labels differ. Mo, 12,3,   oder nur 12.3. oder 12
        var m;
        var days = new Array("Su", "Mo", "Tu", "We", "Th", "Fr", "Sa");
        m = date.getMonth() + 1;
        try{    
            return days[date.getDay()] + ",&nbsp;" + date.getDate() + ".&nbsp;" + m ;
        }catch(e){
            alert(e);
        }
    }
} // end of class
