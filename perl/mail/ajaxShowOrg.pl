#!/usr/bin/perl


# this creates the dropdown with folder for a given ID

use strict;
use CGI qw(:standard);
use warnings;
use MIME::Base64;

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
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailSender.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailParser.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Organizer.pm';



if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error in ajaxLoadExistingMail.pl - evaluating objects: $@"; 
}


#use MailBusinessLayer;

# ----------------------------------------------------------------------------------



my $id = param("id");
my $v_s = param("v_s");
my $v_u = param("v_u");
my $type = param("type");

my $category = param("category");
my $date = param("date");
my $time = param("time");
my $project = param("project");
my $action = param("action");
my $mailId = param("mailId");
# MailIdStart79156MailIdEnd
# add javascript function to mail
my $link;
my $tmpString;
my @arr;
my $content;
my $objForm;
my $buttons;
my $tmp;

my $v_minute = (localtime())[1];
my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];

$v_month = $v_month + 1;
$v_year = $v_year + 1900;

# ----------------------------------------------------------------------------------

my $objMailBusinessLayer = MailBusinessLayer->new();
my $objOrganizer = Organizer->new();
# ----------------------------------------------------------------------------------
print  "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";

	my $objPage;
	my $tabe = Table->new();
	$objPage = Page->new();

if($type eq "form"){


	$tabe->addRow();
	$tabe->addField('','',$objPage->getJavaScriptButton('','','close','hideDiv(\'orgAction\');'));
	$tabe->addField('','','');
	$tabe->addRow();
	$tabe->addField('','','Date');
	$tabe->addField('','',$objPage->getInput('orgDate','',$v_year . "-" . makeDoubleDigit($v_month) . "-" . makeDoubleDigit($v_day)));
	$tabe->addRow();
	$tabe->addField('','','Time');
	$tabe->addField('','',$objPage->getInput('orgTime','',makeDoubleDigit($v_hour) . ':' . makeDoubleDigit($v_minute)));
	$tabe->addRow();
	$tabe->addField('','','Action');
	$tabe->addField('','',$objPage->getInput('orgTitle','',''));
	$tabe->addRow();
	$tabe->addField('','','Project');
	$tabe->addField('','',$objPage->getInput('orgProject','',''));
	$buttons = "";
	$buttons .= $objPage->getJavaScriptButton('','','Calendar','orgAddCalendarFromMail()');
	$buttons .= $objPage->getJavaScriptButton('','','Act','orgAddActionFromMail()');
	$buttons .= $objPage->getJavaScriptButton('','','Wait','orgAddWaitingFromMail()');
	$buttons .= $objPage->getJavaScriptButton('','','Pending','orgAddPendingFromMail()');
	$tabe->addRow();
	$tabe->addField('','','');
	$tabe->addField('','',$buttons);
	print $objPage->getHidden('orgMailId',$id);
	print $tabe->getTable();
	print "<br />".  $id;

}else{

#$link = "<span onclick=\"classesPopContentById(" . $mailId . ",1)\" >[" . $mailId . "]</span>";
#my $content = $action . ": " . $link;

	@arr = $objMailBusinessLayer->getMailsByIds($mailId);

	$link = "<span onclick=\"classesPopContentById(" . $mailId . ",1)\" >[";

	$tmpString = decode_base64($arr[0][1]);
	$tmpString =~ s/<//gi;
	$tmpString =~ s/>//gi;
	$tmpString =~ s/"//gi;
	$tmpString =~ s/'//gi;
	$link .= substr($tmpString, 0, 20);
	$link .= "&nbsp;|&nbsp;";
	$tmpString = decode_base64($arr[0][3]);
	$tmpString =~ s/</[/gi;
	$tmpString =~ s/>/]/gi;
	$tmpString =~ s/"//gi;
	$tmpString =~ s/'//gi;
	$link .= substr($tmpString, 0, 30);
	$link .= "]</span>";
	$content = $action . ": " . $link;

	print " - category is: " . $category;
	$objOrganizer->insertNewElement($category, $objOrganizer->getDate(), $objOrganizer->getTime(), 'fs6on6c629ymfr');
	sleep(1);
	$tmp = $objOrganizer->getIdOfNewElement('fs6on6c629ymfr');
	#sleep(1);
	$objOrganizer->updateField($tmp, 'project', $project);
	#sleep(1);
	$objOrganizer->updateField($tmp, 'title', $content);
	#sleep(1);
	$objOrganizer->updateField($tmp, 'date_insert', $date);
	#sleep(1);
	$objOrganizer->updateField($tmp, 'date_action', $date);
	sleep(1);



	print "....done..." . $objOrganizer->getCallbackContentOfNewElement($tmp);

	print $objPage->getJavaScriptButton('','','close','hideDiv(\'orgAction\');');
}
# ----------------------------------------------------------------------------------

sub makeDoubleDigit($){
	my $string = shift;
	if($string < 10){
		$string = "0" . $string;
	}
	return $string;
}

exit 0