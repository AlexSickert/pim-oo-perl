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
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailSender.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailParser.pm';

if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}

print "Content-type: text/html;Charset=iso-8859-1". "\n\n";

# =======================================================================================
my @arr;
my @inner;
my $test;
my $navigationHtml;
my $pathToTmpFolder;
my $page = Page->new();
my $innerTable = Table->new();
my $outerTable = Table->new();
my $navigation = Navigation->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objMailBusinessLayer = MailBusinessLayer->new();
my $objMail = MailParser->new();
my $objConfig = PageConfig->new();

my $pathToTarFile;
my $pathToExtract;
my $pathToDelete;
my $commandString;
my $commandStringReply;
my @raw_data;
my $dataLine;
# my $pathToTmpFolder;
my $mailBody;
my $sourcePath;
my $virtualAttachmentPath;
my $absolutAttachmentPath;
my $attachmentLinks;
my $attachmentDbLinks;

# =======================================================================================

my $v_u = param("v_u");
my $v_s = param("v_s");
my $mailId = param("mailId");

my $delimiter = "<delimiter>";

# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# =======================================================================================
# content with security

   @arr = $objMailBusinessLayer->getMailById($mailId);

   	print $objMail->cleanFromToSubject($arr[3]);

	print $delimiter;
   
 # if text then text area else iframe
   if($arr[7] eq 'text.html'){

	print "txt";
	print $delimiter;

      $pathToTmpFolder = $objConfig->mailDownloadPath();
      $pathToTmpFolder .= "" .$arr[4];
      $pathToTmpFolder .= "/" .$arr[5];
      $pathToTmpFolder .= "/" .$arr[0];
      $pathToTmpFolder .= "/" .$arr[7] ;

      open(DAT, $pathToTmpFolder );
      @raw_data=<DAT>;
      close(DAT);

      foreach $dataLine(@raw_data)
      {
         $mailBody .= $dataLine;
      }
	print "<textarea id='mailContent' class='iPhoneMailArea' >";
      print $objMail->cleanHtmlBody($mailBody);
print "</textarea >";

   }else{
	print "html";
	print $delimiter;
	print $page->getIframe('mailContent','../mail/loadMail.pl?mailId=' . $mailId . '&v_u=' . $v_u . '&v_s=' . $v_s,'mailContent');
   }




   $page->setBodyClass('showMailBody');
      $page->addContent(  $outerTable->getTable );

# =======================================================================================
#now else part  of security check
}else{
   #$page->addContent(  'permission denied'  );
   #$page->jumpToPage("../admin/login.pl");
}
#end  part  of security check
# =======================================================================================


exit 0