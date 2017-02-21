
//alert("language.js");
var langKeyEnabled;
langKeyEnabled = false;

document.onkeyup = KeyCheck;       

// ======================================

function langEnableKey(){
	langKeyEnabled = true;
}

// ======================================

function KeyCheck(e)

{

	var KeyID = (window.event) ? event.keyCode : e.keyCode;

	if(langKeyEnabled){

		switch(KeyID){
			case 16:
			// document.Form1.KeyName.value = "Shift";
			break; 
			case 17:
			// document.Form1.KeyName.value = "Ctrl";
			break;
			case 18:
			// document.Form1.KeyName.value = "Alt";
			break;
			case 19:
			// document.Form1.KeyName.value = "Pause";
			break;
			case 37:
			// document.Form1.KeyName.value = "Arrow Left";
			sendOk();
			break;
			case 38:
			// document.Form1.KeyName.value = "Arrow Up";
			showHide('vokabel');
			break;
			case 39:
			// document.Form1.KeyName.value = "Arrow Right";
			sendNo();
			break;
			case 40:
			// document.Form1.KeyName.value = "Arrow Down";
			showHide('vokabel');
			break;
		}
	}

}
// ======================================
function showHide(id)
{
    if (document.getElementById(id).style.visibility == "hidden" || document.getElementById(id).style.visibility == "")
    {
        document.getElementById(id).style.visibility = "visible";
    }else{
        document.getElementById(id).style.visibility = "hidden";
    }
}

function sendOk(){
    document.getElementById('result').value = 'Ok';
    document.this_form.submit();
}

function sendNo(){
    document.getElementById('result').value = 'No';
    document.this_form.submit();
}

