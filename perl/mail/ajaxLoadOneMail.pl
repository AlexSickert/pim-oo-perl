#!/usr/bin/perl


############################### RUBBISH - not USED #############################################
############################### RUBBISH - not USED #############################################
############################### RUBBISH - not USED #############################################
############################### RUBBISH - not USED #############################################
############################### RUBBISH - not USED #############################################
############################### RUBBISH - not USED #############################################
############################### RUBBISH - not USED #############################################
############################### RUBBISH - not USED #############################################
############################### RUBBISH - not USED #############################################
############################### RUBBISH - not USED #############################################
############################### RUBBISH - not USED #############################################
############################### RUBBISH - not USED #############################################
############################### RUBBISH - not USED #############################################


use strict;
use CGI::Carp qw(fatalsToBrowser);

use CGI qw(:standard);
use warnings;

require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/LanguageBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailSender.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailParser.pm';

if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}

print  "Content-type: text/html;Charset=utf-8". "\n\n"; # for unicode signes
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
#my $pathToTmpFolder;
my $mailBody;
my $sourcePath;

# =======================================================================================

my $v_u = param("v_u");
my $v_s = param("v_s");
my $mailId = param("mailId");

# =======================================================================================



# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# =======================================================================================
# content with security

   # $innerTable 
   # $outerTable 

  
   @arr = $objMailBusinessLayer->getMailById($mailId);


   $pathToTmpFolder = $objConfig->mailDownloadVirtualPath();
   $pathToTmpFolder .= "/" .$arr[4];
   $pathToTmpFolder .= "/" .$arr[5];
   $pathToTmpFolder .= "/" .$arr[0];

   $sourcePath = $pathToTmpFolder . "/"  .$arr[8] . ".txt";

   $pathToTmpFolder .= "/" .$arr[7];

   
   #extract tar archive

   $pathToTarFile.= "" .$arr[0] .".tgz";

   $pathToExtract = $objConfig->mailDownloadPath();
   $pathToExtract .= "/" .$arr[4];
   $pathToExtract .= "/" .$arr[5];

   $pathToDelete = "";
   $pathToDelete .= $pathToExtract;
   $pathToDelete .= "/";
   $pathToDelete .= $arr[0];

   $navigationHtml = "";
   $navigationHtml .= $navigation->getLinkButton('./sendMail.pl?v_u=' . $v_u . '&v_s=' . $v_s . '&mailId=' . $mailId, 'reply');

   #$navigationHtml .= $navigation->getJavaScriptButton('showPop (\'./showSource.pl?v_u=' . $v_u . '&v_s=' . $v_s . '&mailId=' . $mailId . '\')', 'source');
   $navigationHtml .= $navigation->getJavaScriptButton('showPop (\'' . $sourcePath . '\')', 'source');

  

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
         #chop($dataLine);
         $mailBody .= $dataLine;
      }

      #$mailBody = $objMail->cleanHtmlBody($mailBody);


   print $mailBody;





# =======================================================================================
#now else part  of security check
}else{
   print "permission denied";
}
#end  part  of security check
# =======================================================================================



exit 0