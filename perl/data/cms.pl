#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;

require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Utility.pm';

if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}

# print "Content-type: text/html;Charset=iso-8859-1". "\n\n";

#=======================================================================================
my @arr;
my $uploadPathWithName;
my $localPath;
my $codestring;
my $codepart;
my $url;
my $lastUrl;
my @path_array;
my @arrAbsolut;
my $a;
my $countUpFolder;
my $dynamicPathPart;
my $absolutePathPart;
my $i;
#=======================================================================================
my $objDataBusinessLayer = DataBusinessLayer->new();
my $objConfig = PageConfig->new();
#=======================================================================================
$uploadPathWithName = param("url");
if (! defined($uploadPathWithName )){ $uploadPathWithName = 'ROOT-SYNC\root-sync-cms-file.html';};
$url = $uploadPathWithName;
$lastUrl = param("lastUrl");
if (! defined($lastUrl )){ $lastUrl = '';};
# =======================================================================================

# logik der pade:
# - die lastUrl ist immer ein absoluter pfad
# - die url is ein relativer pfad
# die url muss mit dem last url verrechnet werden - die .. zählen und dann vom absoluten pfad reduzieren

my $replacementString = "https://ssl-id1.de/alex-admin.net/alex-admin/live/perl/";

# https://ssl-id1.de/alex-admin.net/alex-admin/live/perl/

$uploadPathWithName = $url;
$uploadPathWithName =~ s/$replacementString//gi;
$uploadPathWithName =~ s/\//\|/g;
$uploadPathWithName =~ s/\\/\|/g;

@path_array = split(/\|/,$uploadPathWithName );     # Array der einzelnen Teilstrings
$a = @path_array;     # Anzahl der Elemente
$countUpFolder = 0;
$dynamicPathPart = "";

for($i = 0; $i < $a; $i++){
	if($path_array[$i] =~ m/\.\./i){
		$countUpFolder = $countUpFolder + 1;
	}else{
		$dynamicPathPart =$dynamicPathPart . "|" . $path_array[$i];			
	}
}

# now we know how much we need to cut from the absolute path

@arrAbsolut = split(/\|/,$lastUrl ); 
$a = @arrAbsolut ;     # Anzahl der Elemente
$absolutePathPart = "";
$countUpFolder = $countUpFolder + 1; # add one because we need to get rid of the file name of the old path
for($i = 0; $i < $a - $countUpFolder; $i++){
	if($i == 0){
		$absolutePathPart = $arrAbsolut [$i];
	}else{
		$absolutePathPart = $absolutePathPart . "|" . $arrAbsolut [$i];
	}
}

# combine both parts to get the final string that can be loded in the file system

$uploadPathWithName = $absolutePathPart . $dynamicPathPart;

if(substr($uploadPathWithName, 0, 1) eq "|"){
	$uploadPathWithName = substr($uploadPathWithName, 1, length($uploadPathWithName) - 1);
}



@arr = $objDataBusinessLayer->getFile($uploadPathWithName);

# depending on mime type print header

if($arr[1] eq "html"){
	print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
}elsif ($arr[1] eq "pdf"){
	#print "Content-type: application/pdf;Charset=iso-8859-1". "\n\n";

	print "Content-Type:application/octet-stream; name=\"" . $uploadPathWithName . "\"\r\n";
	print "Content-Disposition: attachment; filename=\"" . $uploadPathWithName  .  "\"\r\n\n";

}else{
	# application/pdf
#	print "Content-type: text/html;Charset=iso-8859-1". "\n\n unknown contenttype";
#	print "<br>uploadPathWithName=" . $uploadPathWithName. "<br>";
#	print "<br>absolutePathPart=" . $absolutePathPart . "<br>";
#	print "<br>lastUrl=" . $lastUrl . "<br>";

	print "Content-Type:application/octet-stream; name=\"" . $uploadPathWithName . "\"\r\n";
	print "Content-Disposition: attachment; filename=\"" . $uploadPathWithName  .  "\"\r\n\n";

}


# create the path to the file
$localPath = $objConfig->cmsPath()  . $arr[0];

if(-e $localPath){

}else{
	print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
	print "file does not exist: " . $uploadPathWithName;
	die;
}


# read file
open (CHECKBOOK, $localPath) || die("Could not open file!");
$codestring = "";
while ($codepart = <CHECKBOOK>) {
	$codestring .= $codepart ;
}
close(CHECKBOOK);
# print file content




# for pdf stop script here

if($arr[1] eq "html" || $arr[1] eq "htm"){


	# depending on file typ replace hrefs      
	$replacementString = "href=\"./cms.pl?lastUrl=". $uploadPathWithName .  "&url=";
	$codestring =~ s/href="#/href12345/gi;
	$codestring =~ s/href="/$replacementString/gi;
	$replacementString = "href='./cms.pl?lastUrl=". $uploadPathWithName .  "&url=";
	$codestring =~ s/href='#/href54321/gi;
	$codestring =~ s/href='/$replacementString/gi;

	$codestring =~ s/href54321/href='#/gi;
	$codestring =~ s/href12345/href="#/gi;

	# replace image sources
	$replacementString = "src=\"./cms.pl?lastUrl=". $uploadPathWithName .  "&url=";
	$codestring =~ s/src="#/src12345/gi;
	$codestring =~ s/src="/$replacementString/gi;
	$replacementString = "src='./cms.pl?lastUrl=". $uploadPathWithName .  "&url=";
	$codestring =~ s/src='#/src54321/gi;
	$codestring =~ s/src='/$replacementString/gi;

	$codestring =~ s/src54321/src='#/gi;
	$codestring =~ s/src12345/src="#/gi;

	print $codestring;

	# do nothing
}else{

	print $codestring;

}

## print a div tag
#print '<div id="waitDiv" style="visibility: visible; width: 80%; height: 80%; position:absolute; top:100px; left:100px; z-index:1; background: #AAAAAA; border:thin solid #AAAAAA;">loading...</div>';
## print java script code
#print '
#<script type="text/javascript">
#/* <![CDATA[ */
#// here we need to have the current folder as a reference to calculate the new one
#// we also need the security string v_s and v_u
#';
#print 'var lastUrl = "' . $uploadPathWithName . '";';
#print '
#var divs = document.getElementsByTagName("a");
#var s = "";
#//alert(divs.length);
#for (var i=0; i<divs.length; i++){
#// wenn es sich um ein pdf handelt dann javscript new window und der link
#// dazu muss der href link selbst auf # gesetzt werden oder target auch ??? 
#//link.setAttribute("name", "myanchor");
#//var link = document.createElement("a");
#//link.setAttribute("href", "mypage.htm");
#	// if (divs[i].id.indexOf("testimonial") == 0) divs[i].style.display = "none"; 
#try{
#	s = divs[i].attributes.getNamedItem("href").value;
#	document.write("was before: " + s + "<br>");
#	var sCheck = s.substring(1,0);
#	if(sCheck == "#"){
#		// ignore because is anchor
#	}else{
#		divs[i].attributes.getNamedItem("href").value = "cms.pl?lastUrl="+ lastUrl + "&url="+ s;
#	}
#	document.write("is now: " + divs[i].attributes.getNamedItem("href").value + "<br>");
#	
#	
#}catch(e){
#}
#}
#//alert(s);
#try{
#	document.getElementById("waitDiv").style.visibility = "hidden"; 
#}catch(e){
#}
#try{
#	//document.getElementsByTagName("waitDiv").style.visibility = "hidden"; 
#}catch(e){
#}
#//alert("done");
#/* ]]> */
#</script>
#';

exit 0;
