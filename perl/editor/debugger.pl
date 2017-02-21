#!/usr/bin/perl

use lib "../classes";
use PageConfig;
use strict;
use CGI qw(:standard);
use DBI;

my $objConfig;
$objConfig = PageConfig->new();

my $minTab = 1;
my $maxTab = 20;
my $i = 0;

my $ajaxLoadFilePath = $objConfig->codePathAbsolut . "editor/editCodeAjaxLoadFile.pl";
my $ajaxLoadFolderPath = $objConfig->codePathAbsolut . "editor/editCodeAjaxLoadFolder.pl";
my $ajaxSaveFilePath = $objConfig->codePathAbsolut . "editor/editCodeAjaxSaveFile.pl";

my $defaultFolder = $objConfig->get("server-path");

print  "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";
print '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
print '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' . "\n";
print '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">' . "\n";

print '

	<head>	
		<title>AS-EDIT</title>
		<meta http-equiv="Content-Type" content="text/html; Charset=iso-8859-1">
	</head>

	<body bgcolor="#CCCCCC">
	
	<SCRIPT SRC="'. $objConfig->jsPath() .'ajax.js"></SCRIPT>
    <SCRIPT SRC="'. $objConfig->jsPath() .'editorAjaxSaveFile.js"></SCRIPT>
    <SCRIPT SRC="'. $objConfig->jsPath() .'editorAjaxLoadFile.js"></SCRIPT>
    <SCRIPT SRC="'. $objConfig->jsPath() .'editorAjaxLoadFolder.js"></SCRIPT>
    
	<script type="text/javascript">		
		var code;		
		code = "";	
		var openTabs = "";
		var closedTabs = "";
		var minTab = '.$minTab.';
		var maxTab = '.$maxTab.';
		var activeTab = "";
		
		var currentid = "#";

		function showhide(id){ 
			var i;
			for (i = 1; i <= maxTab; i#SpecialCharPlusSign##SpecialCharPlusSign#){
				document.getElementById(\'div\' #SpecialCharPlusSign#i).style.display = "none";
				document.getElementById(\'div\' #SpecialCharPlusSign# i).style.visibility = "hidden";
				document.getElementById(\'tab\' #SpecialCharPlusSign# i).style.backgroundColor = "#CCCCCC";
			}
						
			document.getElementById(\'div\' #SpecialCharPlusSign# id).style.display = "inline";
			document.getElementById(\'div\' #SpecialCharPlusSign# id).style.visibility = "visible";
			document.getElementById(\'tab\' #SpecialCharPlusSign# id).style.backgroundColor="#FFFFFF";
			currentid = id;
		}  
		
		function openNew(){
			
				//find next tab taht is closed
			var tabOpened = "no";
			
			document.getElementById(\'filesAndFolders\').style.display = "none";
			document.getElementById(\'filesAndFolders\').style.visibility = "hidden";
			
			for (i = minTab; i <= maxTab; i#SpecialCharPlusSign##SpecialCharPlusSign#){
				
				if (document.getElementById(\'tabSpan\' #SpecialCharPlusSign#i).style.display == "none"){
				
					if(tabOpened == "no"){
						document.getElementById(\'tabSpan\' #SpecialCharPlusSign#i).style.display = "inline";
						document.getElementById(\'tabSpan\' #SpecialCharPlusSign#i).style.visibility = "visible";
						showhide(i);
						tabOpened = "yes";
					}				
				}		 
			}	 
		}
		
		function closeTab(id){
			//alert("close " #SpecialCharPlusSign# id);
			document.getElementById(\'tab\' #SpecialCharPlusSign#id).style.display = "none";
			document.getElementById(\'div\' #SpecialCharPlusSign#id).style.display = "none";
			document.getElementById(\'tab\' #SpecialCharPlusSign#id).value = "";
			document.getElementById(\'path\' #SpecialCharPlusSign#id).value = "";
			document.getElementById(\'content\' #SpecialCharPlusSign#id).value = "";
		}
		
		function saveTab(id){ 
			//alert("save " #SpecialCharPlusSign# id);
			var saveFile = document.getElementById(\'tab\' #SpecialCharPlusSign#id).value;
			var savePath = document.getElementById(\'path\' #SpecialCharPlusSign#id).value;
			var saveContent = document.getElementById(\'content\' #SpecialCharPlusSign#id).value;
			var saveAction = "save";
			// ajax function
			ajaxSaveFile(saveAction, saveContent, savePath, "'.$ajaxSaveFilePath.'" );
		} 
		
		function loadTab(id){ 
			//alert("load " #SpecialCharPlusSign# id);
			activeTab = id;
			document.getElementById(\'fileTabs\').style.display = "none";
			document.getElementById(\'fileTabs\').style.visibility = "hidden";		
			document.getElementById(\'filesAndFolders\').style.display = "inline"; 
			document.getElementById(\'filesAndFolders\').style.visibility = "visible"; 
		} 

		function loadFolder(){ 
			var folderPath = document.getElementById(\'selectFolders\').options[document.getElementById(\'selectFolders\').selectedIndex].value;
			//alert ("in editcodeAjax.pl loadFolder " #SpecialCharPlusSign# folderPath);
			ajaxLoadFolder(folderPath,"filesAndFoldersAjax", "'. $ajaxLoadFolderPath .'", "'.$defaultFolder.'");
		} 

	
		function loadFile(folder){ 
			//alert("load file" #SpecialCharPlusSign# folder);
			var fileContent = "";
			var filePath = document.getElementById(\'selectFiles\').options[document.getElementById(\'selectFiles\').selectedIndex].value;
			var fileName = document.getElementById(\'selectFiles\').options[document.getElementById(\'selectFiles\').selectedIndex].text;

			ajaxLoadFile(filePath, \'content\' #SpecialCharPlusSign# activeTab, "'.$ajaxLoadFilePath.'");
			
			document.getElementById(\'tab\' #SpecialCharPlusSign# activeTab).value = fileName;
			document.getElementById(\'path\' #SpecialCharPlusSign# activeTab).value = filePath;
			
			// am schluss zu richtigem reiter zurckkehren
			loadTabOk()
		} 
				
		function loadTabOk(){ 
			//alert("OK ");
			document.getElementById(\'fileTabs\').style.display = "inline";
			document.getElementById(\'fileTabs\').style.visibility = "visible"; 
			document.getElementById(\'filesAndFolders\').style.display = "none";
			document.getElementById(\'filesAndFolders\').style.visibility = "hidden"; 
		} 
				
		function doployTab(id){ 
			//alert("deploy " #SpecialCharPlusSign# id);
			var saveFile = document.getElementById(\'tab\' #SpecialCharPlusSign#id).value;
			var savePath = document.getElementById(\'path\' #SpecialCharPlusSign#id).value;
			var saveContent = document.getElementById(\'content\' #SpecialCharPlusSign#id).value;
			var saveAction = "deploy";
			// ajax function
			//ajaxSaveFile(saveAction, saveContent, savePath #SpecialCharPlusSign# "/" #SpecialCharPlusSign# saveFile);
			ajaxSaveFile(saveAction, saveContent, savePath, "'.$ajaxSaveFilePath.'" );
		} 			
				
	</script>
		
		<form name="myform" action="editcode.pl" target="_self" method="POST" >	
		<input type="button" id="openTab" value="Exit" onclick="window.close();">
		<input type="button" id="openTab" value="Open New" onclick="openNew()"><br />
			<div id="fileTabs" style="display: inline;  visibility: visible;">
				<div>';
				
		for ($i = $minTab; $i <= $maxTab; $i#SpecialCharPlusSign##SpecialCharPlusSign#){				
		print '
		<span id="tabSpan'.$i.'" style="display: none;  visibility: hidden;">
                    <input type="text" id="tab'.$i.'" onclick="showhide(\''.$i.'\')"  value="" size="20" style="background-color: #AAAAAA; ">
		</span>
                ';
					};
					
				print '
				</div>
				';
				
				for ($i = $minTab; $i <= $maxTab; $i#SpecialCharPlusSign##SpecialCharPlusSign#){				
                    print '
                    <div id="div'.$i.'" style="display: none;  visibility: hidden;">					
                        <input type="text" name="path'.$i.'" id="path'.$i.'" value="" size="100">
                        <input type="button" id="load'.$i.'" value="Load" onclick="loadTab(\''.$i.'\');">
                        <input type="button"  id="save'.$i.'" value="Save" onclick="saveTab(\''.$i.'\');">
                        <input type="button"  id="deploy'.$i.'" value="Deploy" onclick="doployTab(\''.$i.'\');">
                        <input type="button"  id="close'.$i.'" value="Close" onclick="closeTab(\''.$i.'\');">
                        <input type="checkbox" name="check'.$i.'" id="check1" value="chmod700" checked>700	
                        <br />
                        <textarea id="content'.$i.'" rows="32" cols="120" name="code" name="id" wrap="off" ></textarea>
                    </div>
                    ';
                }				

			print '
			</div>
			
			<div id="filesAndFolders" style="display: inline;  visibility: visible;">
				<br />
				<br />
				<input type="button" id="openTab" value="OK - Load" onclick="loadTabOk();">
				<br />
				<br />
				
				<div id="filesAndFoldersAjax">
				<input  type="text" id="selectPath" value="" size="100">
				<br />
				<br />
				<select name=\'selectFolders\' id=\'selectFolders\' size=\'20\'  onchange="loadFolder()" style=\'width: 250px\'>
					<option value=\''.$defaultFolder.'\' selected>-----------------</option >
					<option value=\''.$defaultFolder.'\'></option >
				</select>
				&nbsp;
				&nbsp;
				&nbsp;
				&nbsp;
				<select name=\'selectFiles\'  id=\'selectFiles\' size=\'20\'  onchange="loadFile()" style=\'width: 250px\'>
					<option value=\'\' selected>-----------------</option >
					<option value=\'\'></option >
				</select>
				</div>
				<br />
				<input type="text" name="newFile" size="50">
				<br />
				<input type="text" name="newFile" size="50">
				
			</div>
			<div>
				<input type="text" id="message" size="100">
			</div>	
		</form>
        <script type="text/javascript">
        	openNew();
		//loadFolder();
		</script>
        
        <script type="text/javascript">
            var offset = (navigator.userAgent.indexOf("Mac") != -1 || navigator.userAgent.indexOf("Gecko") != -1 ||  navigator.appName.indexOf("Netscape") != -1) ? 0 : 4;

            window.moveTo(-offset, -offset);
            window.resizeTo(screen.availWidth #SpecialCharPlusSign# (2 * offset), screen.availHeight #SpecialCharPlusSign# (2 * offset));

        </script>
                        
		
	</body>
</html>';

exit 0;
	