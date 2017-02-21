#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;
use LWP::Simple;
use Encode;

if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}

# =======================================================================================

print  "Content-type: text/html;Charset=utf-8". "\n\n"; # for debugging

# =======================================================================================

# ---------------------- REQUEST VARIABLES --------------------------------------------------
my $params = CGI->new();
my $search= $params->param("search");
my $lang = $params->param("lang");

# ---------------------- VARIABLES  ---------------------------------------------------------
my $get_html;
my $service;
# ---------------------- CODE FOR PAGE ----------------------------------------------------

# ital
# http://dict.leo.org/itde?lp=itde&lang=de&searchLoc=0&cmpType=relaxed&sectHdr=on&spellToler=on&chinese=both&pinyin=diacritic&search=hallo&relink=on

# span
# http://dict.leo.org/esde?lp=esde&lang=de&searchLoc=0&cmpType=relaxed&sectHdr=on&spellToler=std&chinese=both&pinyin=diacritic&search=hallo&relink=on

#franz
# http://dict.leo.org/frde?lp=frde&lang=de&searchLoc=0&cmpType=relaxed&sectHdr=on&spellToler=on&chinese=both&pinyin=diacritic&search=hallo&relink=on


#------------------------------------------------------------------------------

if($lang eq 'ende' | $lang eq 'deen')
{	
	$get_html = get('http://dict.leo.org/ende?lp=ende&lang=de&searchLoc=0&cmpType=relaxed&sectHdr=on&spellToler=on&chinese=both&pinyin=diacritic&search=' .  $search . '&relink=on');
}

if($lang eq 'itde'  | $lang eq 'deit')
{	

	$get_html = get('http://dict.leo.org/itde?lp=ende&lang=de&searchLoc=0&cmpType=relaxed&sectHdr=on&spellToler=on&chinese=both&pinyin=diacritic&search=' .  $search . '&relink=on');
}

if($lang eq 'esde'  | $lang eq 'dees')
{	

	$get_html = get('http://dict.leo.org/esde?lp=ende&lang=de&searchLoc=0&cmpType=relaxed&sectHdr=on&spellToler=on&chinese=both&pinyin=diacritic&search=' .  $search . '&relink=on');
}

if($lang eq 'frde'  | $lang eq 'defr')
{	
	$get_html = get('http://dict.leo.org/frde?lp=ende&lang=de&searchLoc=0&cmpType=relaxed&sectHdr=on&spellToler=on&chinese=both&pinyin=diacritic&search=' .  $search . '&relink=on');
}

if($lang eq 'rude'  | $lang eq 'deru')
{	
	$get_html = get('http://dict.leo.org/rude?lp=rude&lang=de&searchLoc=0&cmpType=relaxed&sectHdr=on&spellToler=&search=' .  $search . '');
}

#------------------------------------------------------------------------------

my $enc = 'utf-8';

if(utf8::is_utf8($get_html)){
	# $get_html = decode($enc,  $get_html);
}else{
	$get_html = decode($enc,  $get_html);
}

# deactivated 24.12.2010
#$get_html =~ m/<td id="contentholder">(.*)=====================/si;		

# modification 24.12.2010 nextline

#$get_html =~ m/>Unmittelbare Treffer(.*)=====================/si;
$get_html =~ m/>Unmittelbare Treffer(.*)html>/si;		

$get_html = "$1";
# following line deactivated 24.12.2010
#$get_html =~ m/<table cellpadding=0 cellspacing=0 width="100%" id="results" border=1>(.*)<\/table>/si;
$get_html = "$1";
$get_html =~ s/,/./g;
$get_html =~ s/<(?:[^>'"]*|(['"]).*?\1)*>//gs;
$get_html =~ s/&#160;/; /g;
$get_html =~ s/&nbsp;/ /g;
$get_html =~ s/  / /g;
$get_html =~ s/  / /g;
$get_html =~ s/  / /g;
$get_html =~ s/  / /g;
$get_html =~ s/  / /g;
$get_html =~ s/  / /g;
$get_html =~ s/  / /g;
$get_html =~ s/  / /g;
$get_html =~ s/                          / /g;
$get_html =~ s/                    / /g;
$get_html =~ s/    / /g;
$get_html =~ s/    / /g;
$get_html =~ s/    / /g;
$get_html =~ s/	/ /g;

# encoding of special characters
my $searchString  = chr 243;

$get_html =~ s/&uuml;/ü/g;
$get_html =~ s/&ouml;/ö/g;
$get_html =~ s/&auml;/ä/g;

$get_html =~ s/&Uuml;/Ü/g;
$get_html =~ s/&Ouml;/Ö/g;
$get_html =~ s/&Auml;/Ä/g;

print encode($enc,  "----content----");
# print $get_html;
# $return .= substr($tmpString, 0, 20);
print encode($enc,  substr($get_html, 0, 250) );

print encode($enc, "_end_");


# ---------------------- Endo of CODE ---------------------------------------------------------


