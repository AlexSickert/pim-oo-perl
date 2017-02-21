#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;

use Time::HiRes;
my $start = [ Time::HiRes::gettimeofday( ) ];

require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/LanguageBusinessLayer.pm';

if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}

#   print "Content-type: text/html;Charset=utf-8". "\n\n";

# ==========================================================================================================================
# Objects
my $objPage = Page->new();
my $objConfig = PageConfig->new();

# ==========================================================================================================================
# insert bei request

my $fromLanguage = param("fromLanguage");
my $toLanguage = param("toLanguage");
my $result = param("result");
my $language = param("language");
my $id  = param("id");
my $content;

# ==========================================================================================================================

$objPage->setEncoding('xhtml');
$objPage->initialize();

# $objPage->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
# $objPage->addStyleSheet($objConfig->cssPath() . 'classes.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'mobileLanguage2.css');
$objPage->addJavaScript($objConfig->jsPath() . 'ajax.js');
$objPage->addJavaScript($objConfig->jsPath() . 'mobileLanguage3.js');


$content = "
<center>



<table>
	<tr>
		<td><input type='button' id='buttonMenuId' name='buttonMenuName' class='buttonMenuClass'  value='Menu'  onclick='menu()' />
		</td>
	</tr>
	<tr>
		<td><div id='L1' class='L1' name = 'L1'>L1</div></td>
	</tr>
	<tr>
		<td><div id='V1' class='V1' name = 'V1'>V1</div></td>
	</tr>
	<tr>
		<td><div id='L2' class='L2' name = ''>L2</div></td>
	</tr>
	<tr>
		<td><div id='V2' class='' name = 'V2'>V2</div></td>
	</tr>

	<tr>
		
		<td><input type='button' id='buttonNo' name='buttonNo' class='buttonNo'  value='NO'  onclick='processNo()'  /></td>
	</tr>

	<tr>
		<td><input type='button' id='buttonQuestion' name='buttonQuestion' class='buttonQuestion'  value='?'  onclick='question()'  /></td>
	</tr>

	<tr>
		<td><input type='button' id='buttonYes' name='buttonYes' class='buttonYes'  value='Yes'  onclick='processOk(1)'  /></td>
	</tr>

		<tr>
			<td '><div id='info' class='info' name = 'info'>info</div></td>
		</tr>
</table>

</center>
";


$objPage ->addContainer('content','content',$content );

# ====== ab hier darf kein content mehr agefügt werden ==================================
$objPage->display();
# ==========================================================================================================================

					exit 0