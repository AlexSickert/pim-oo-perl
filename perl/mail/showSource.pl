#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;

eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailParser.pm`;

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
my $pathToTmpFolder;
my $mailBody;

# =======================================================================================

my $v_u = param("v_u");
my $v_s = param("v_s");
my $mailId = param("mailId");


# =======================================================================================
$page->setTitle($objConfig->get("Read mail"));
$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'mail.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');
$page->addJavaScript($objConfig->jsPath() . 'mail.js');

# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# =======================================================================================
# content with security

   # $innerTable 
   # $outerTable 

  
   @arr = $objMailBusinessLayer->getMailById($mailId);

   # SELECT id, sender, recipient, mail_subject, load_year, load_month, folder, read_version, folder_name



   # id, sender, recipient, mail_subject, load_year, load_month, folder, read_version, folder_name
   @arr = $objMailBusinessLayer->getMailById($mailId);

   #$pathToTmpFolder = "https://www.alex-admin.net/alex-admin/dev/mail/received";
   $pathToTmpFolder = $objConfig->mailDownloadVirtualPath();
   $pathToTmpFolder .= "/" .$arr[4];
   $pathToTmpFolder .= "/" .$arr[5];
   $pathToTmpFolder .= "/" .$arr[0];
   $pathToTmpFolder .= "/" .$arr[7];

   #extract tar archive

   $pathToTarFile.= "" .$arr[0] .".tgz";


   #$pathToExtract = "/var/www/vhosts/alex-admin.net/httpsdocs/alex-admin/dev/mail/received";
   $pathToExtract = $objConfig->mailDownloadPath();
   $pathToExtract .= "/" .$arr[4];
   $pathToExtract .= "/" .$arr[5];

   $pathToDelete = "";
   $pathToDelete .= $pathToExtract;
   $pathToDelete .= "/";
   $pathToDelete .= $arr[0];

   #register folder for deleting
   #$objAdminBusinessLayer->registerFolderForDelete($pathToDelete . "/attachments" , "folder");
   #$objAdminBusinessLayer->registerFolderForDelete($pathToDelete  , "folder" );


   #$commandString = "cd /" ;
   #system($commandString);
   #$commandString = "tar -C " . $pathToExtract . " -xzf " . $ pathToExtract . "/" . $pathToTarFile . "" ;
   #$commandStringReply = system($commandString);

   $navigationHtml = "";
   #$navigationHtml .= $navigation->getLinkButton('./sendMail.pl?v_u=' . $v_u . '&v_s=' . $v_s . '&mailId=' . $mailId, 'reply');
   $navigationHtml .= $navigation->getJavaScriptButton('window.close()', 'close');

   $outerTable->setName('idMailOuterTable');
   $outerTable->setStyle('mailOuterTable'); 
   $outerTable->addRow(); 
   $outerTable->addField('','',$navigationHtml );
   #$outerTable->addRow(); 
   #$outerTable->addField('','',$innerTable->getTable);
   $outerTable->addRow(); 




      $pathToTmpFolder = $objConfig->mailDownloadPath();
      $pathToTmpFolder .= "" .$arr[4];
      $pathToTmpFolder .= "/" .$arr[5];
      $pathToTmpFolder .= "/" .$arr[0];
      $pathToTmpFolder .= "/" .$arr[8]. ".txt" ;

      open(DAT, $pathToTmpFolder );
      @raw_data=<DAT>;
      close(DAT);

      foreach $dataLine(@raw_data)
      {
         #chop($dataLine);
         $mailBody .= $dataLine;
      }

      $mailBody =~ s/</&lt;/i;
      $mailBody =~ s/>/&gt;/i;
      $mailBody .= $pathToTmpFolder;
      $mailBody = $objMail->cleanHtmlBody($mailBody);


      $outerTable->addField('idMailIframeTd','mailIframeTd',$page->getArea('mailBody','mailFormArea',$mailBody));
      $page->setBodyOnLoad("resizeMailArea()");
   



   $page->setBodyClass('showMailBody');
      $page->addContent(  $outerTable->getTable );

# =======================================================================================
#now else part  of security check
}else{
   #$page->addContent(  'permission denied'  );
   $page->jumpToPage("../admin/login.pl");
}
#end  part  of security check
# =======================================================================================

$page->setEncoding('xhtml');
$page->initialize;
$page->display;

exit 0