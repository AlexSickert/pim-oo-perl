#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use DBI;

require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm';

my $v_u = param("v_u");
my $v_s = param("v_s");
my $objAdminBusinessLayer = AdminBusinessLayer->new();

if (! defined $v_s){
	$v_s = "";
}

if (! defined $v_u){
	$v_u = "";
}

if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}

my $objConfig;
$objConfig = PageConfig->new();

my $minTab = 1;
my $maxTab = 6;
my $i = 0;

my $ajaxLoadFilePath = $objConfig->codePathAbsolut . "editor/editCodeAjaxLoadFile.pl";
my $ajaxLoadFolderPath = $objConfig->codePathAbsolut . "editor/editCodeAjaxLoadFolder.pl";
my $ajaxSaveFilePath = $objConfig->codePathAbsolut . "editor/editCodeAjaxSaveFile.pl";

my $defaultFolder = $objConfig->get("server-path");

print  "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";
print '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
print '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' . "\n";
print '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">' . "\n";

# =======================================================================================
# first check security

if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){



# ----------------------------------- static content --------
print '

	<head>	
		<title>AS-EDIT</title>
		<meta http-equiv="Content-Type" content="text/html; Charset=iso-8859-1">

		<style type="text/css">
			p {  font-family:Arial,sans-serif;  }
			div {  font-family:Arial,sans-serif; }
			td {  font-family:Arial,sans-serif;  }	
			textarea { font-family:Arial,sans-serif;  }
		</style>

	</head>

	<body bgcolor="#CCCCCC"><div id="masterdiv">
	
	<SCRIPT SRC="'. $objConfig->jsPath() .'editor.js"></SCRIPT>
	<SCRIPT SRC="'. $objConfig->jsPath() .'ajax.js"></SCRIPT>
       <SCRIPT SRC="'. $objConfig->jsPath() .'editorAjaxSaveFile.js"></SCRIPT>
       <SCRIPT SRC="'. $objConfig->jsPath() .'editorAjaxLoadFile.js"></SCRIPT>
       <SCRIPT SRC="'. $objConfig->jsPath() .'editorAjaxLoadFolder.js"></SCRIPT>
       <SCRIPT SRC="'. $objConfig->jsPath() .'ajaxEditorClearHistory.js"></SCRIPT>

    
	<script type="text/javascript">		
			
	</script>
		
		<form name="myform" action="editcode.pl" target="_self" method="POST" >	
		<input type="button" id="openTab" value="Exit" onclick="window.close();">
		<input type="button" id="openTab" value="Open New" onclick="openNew()">
		<input type="button" id="openTab" value="do #" onclick="commentPerl();">
		<input type="button" id="openTab" value="undo #" onclick="uncommentPerl();">
		<input type="button" id="openTab" value="do //" onclick="commentJavaScript();">
		<input type="button" id="openTab" value="undo //" onclick="uncommentJavaScript();">
		<input type="button" id="openTab" value="=&gt;" onclick="shiftOneLevel();">
		<input type="button" id="openTab" value="&lt;=" onclick="unshiftOneLevel();">
		<input type="button" id="openTab" value="beautify" onclick="beautifyCode();">
		<input type="button" id="openTab" value="do space" onclick="doSpace();">
		<input type="button" id="openTab" value="undo space" onclick="undoSpace();">
		<input type="button" id="openTab" value="clear Hist." onclick="clearHistory();">
		<input type="button" id="openTab" value="SQL Editor" onclick="showSqlEditor(\'' . $v_u . '\',\'' . $v_s . '\');">

			<div id="fileTabs" style="display: inline;  visibility: visible;"><br />
				<div>';
# -------------------------------------------- LOOP to create the tabs -------------------				
		for ($i = $minTab; $i <= $maxTab; $i++){				
		print '
		<span id="tabSpan'.$i.'" style="display: none;  visibility: hidden;">
                    <input type="text" id="tab'.$i.'" onclick="showhide(\''.$i.'\'); scrollDown(\''.$i.'\');"  value="" size="20" style="background-color: #AAAAAA; ">
		</span>
                ';
					};
					
				print '
				</div>
				';
# -------------------------------------------- LOOP to create the text areas and buttons on each tab ---------------				
				for ($i = $minTab; $i <= $maxTab; $i++){				
                    print '
                    <div id="div'.$i.'" style="display: none;  visibility: hidden;">					
                        <input type="text" name="path'.$i.'" id="path'.$i.'" value="" size="80">
                        <input type="text" name="line'.$i.'" id="line'.$i.'" value="" size="4">
                       <input type="text" name="scroll'.$i.'" id="scroll'.$i.'" value="" size="4">
                        <input type="button" id="load'.$i.'" value="Load" onclick="loadTab(\''.$i.'\');">
                        <input type="button"  id="save'.$i.'" value="Save" onclick="saveTab(\''.$i.'\');">
                        <input type="button"  id="deploy'.$i.'" value="Deploy" onclick="doployTab(\''.$i.'\');">
                        <input type="button"  id="close'.$i.'" value="Close" onclick="closeTab(\''.$i.'\');">
                        <input type="button"  id="debug'.$i.'" value="Debug" onclick="debugTab(\''.$i.'\');">
                        <input type="checkbox" name="check'.$i.'" id="check1" value="chmod700" checked>700	
                        <br />
                        <textarea id="content'.$i.'" rows="6" cols="20" name="code" name="id" wrap="off" onfocus="scrollDown(\''.$i.'\')" onMouseMove="lineNumbers(); setScroll();"    onclick="lineNumbers(); setScroll();" onkeydown="return catchTab(this,event, \''.$i.'\')"></textarea>
                    </div>
                    ';
                }				
# ----------------------------------- the two drop down select lists for files and folders --------
			print '
			</div>
			
			<div id="filesAndFolders" style="display: inline;  visibility: visible;">
				<br />
				<br />
				<input type="button" id="openTab" value="OK - Load" onclick="loadTabOk();">
				<br />
				<br />
				
				<div id="filesAndFoldersAjax">
				current path: <input  type="text" id="selectPath" value="" size="100">
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

				<!-- files at the bottom -->
				<table>
					<tr>
						<td>new file:</td><td><input type="text" name="newFile" id="newFile" size="50"><input type="button"  value="New File" onclick="createNewFile();"></td>
					</tr>
					<tr>
						<td>new folder:</td><td><input type="text" name="newFolder" id="newFolder" size="50"><input type="button"  value="New Folder" onclick="createNewFolder();"></td>
					</tr>
				</table>
				                                
                                
				
			</div>
			<div>
				<textarea id="message" rows="2" cols="100" name="code" name="id" style="width: 100%"></textarea>
				<!-- log message: <input type="text" id="message" size="100"> -->
			</div>	
		</form>
        <script type="text/javascript">
        	openNew();
		//loadFolder();
		</script>
        
        <script type="text/javascript">
            var offset = (navigator.userAgent.indexOf("Mac") != -1 || navigator.userAgent.indexOf("Gecko") != -1 ||  navigator.appName.indexOf("Netscape") != -1) ? 0 : 4;

            	window.moveTo(-offset, -offset);
            
	if(screen.availWidth  > 1200){
		window.resizeTo(1024, 700);
	}else{
		window.resizeTo(screen.availWidth + (2 * offset), screen.availHeight + (2 * offset));
	}

		// resize height of text area if necessary

		';

#---------------------  loop through all tabes and resize the text area -------------------------------

		for ($i = $minTab; $i <= $maxTab; $i++){				
			print '
			resizeEditorArea("content' . $i . '");
               		 ';
		};
#------------------------------------------------------------------------------------------------------------------

# start function for window resizing
		print 'function myResize(){';
#---------------------  loop through all tabes and resize the text area -------------------------------

		for ($i = $minTab; $i <= $maxTab; $i++){				
			print '
			resizeEditorArea("content' . $i . '");
               		 ';
		};
#------------------------------------------------------------------------------------------------------------------

		print '}

		window.onresize = myResize;

		';

#end of function for resizing
#------------------------------------------------------------------------------------------------------------------

		print '



        </script>                        
		</div>
	</body>
</html>';

# END of SECURITY CHECK
}else{
	print 'no security';

}
# =======================================================================================

exit 0;
	
	