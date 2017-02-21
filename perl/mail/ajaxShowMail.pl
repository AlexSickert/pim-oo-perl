#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;

use Time::HiRes;
my $start = [ Time::HiRes::gettimeofday( ) ];

#print "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";

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


# print "Content-type: text/html;Charset=iso-8859-1". "\n\n-2008-03-10-";
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

# =======================================================================================
$page->setTitle($objConfig->get("Read mail"));
$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'mail.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');
$page->addJavaScript($objConfig->jsPath() . 'mail.js');
$page->addJavaScript($objConfig->jsPath() . 'ajax.js');

# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# =======================================================================================
# content with security

   # $innerTable 
   # $outerTable 

  
   @arr = $objMailBusinessLayer->getMailById($mailId);

   # SELECT id, sender, recipient, mail_subject, load_year, load_month, folder, read_version, folder_name

   $innerTable->setStyle('mailInnerTable');
   $innerTable->addRow();
   $innerTable->addField('','','date:');
   $innerTable->addField('','','(not implemented)');
   $innerTable->addRow();
   $innerTable->addField('','','from:');
   $innerTable->addField('','',$objMail->cleanEmail($objMail->cleanFromToSubject($arr[1])));
   $innerTable->addRow();
   $innerTable->addField('','','to:');
   $innerTable->addField('','',$objMail->cleanEmail($objMail->cleanFromToSubject($arr[2])));
   $innerTable->addRow();
   $innerTable->addField('','','cc:');
   $innerTable->addField('','','(not implemented)');
   $innerTable->addRow();
   $innerTable->addField('','','subject:');
   $innerTable->addField('','',$objMail->cleanFromToSubject($arr[3]));
   $innerTable->addRow();
   $innerTable->addField('','','attachments:');

   



   # id, sender, recipient, mail_subject, load_year, load_month, folder, read_version, folder_name
   @arr = $objMailBusinessLayer->getMailById($mailId);

   #$pathToTmpFolder = "https://www.alex-admin.net/alex-admin/dev/mail/received";
   $pathToTmpFolder = $objConfig->mailDownloadVirtualPath();
   $pathToTmpFolder .= "/" .$arr[4];
   $pathToTmpFolder .= "/" .$arr[5];
   $pathToTmpFolder .= "/" .$arr[0];

   $sourcePath = $pathToTmpFolder . "/"  .$arr[8] . ".txt";
   $pathToTmpFolder .= "/" .$arr[7];

   # load the links to the attachments
   $absolutAttachmentPath = $objConfig->mailDownloadPath() . "" . $arr[4] . "/" . $arr[5] . "/" . $arr[0];
   $virtualAttachmentPath = $objConfig->mailDownloadVirtualPath() . "" . $arr[4] . "/" . $arr[5] . "/" . $arr[0];

   
   $attachmentLinks = getFilesAsPopLinkArray($absolutAttachmentPath, $virtualAttachmentPath); 

   $attachmentDbLinks = $objMailBusinessLayer->getAttachmentLinks($mailId, $v_s, $v_u);

   if($attachmentDbLinks eq ''){
   	$attachmentLinks .= getFilesAsPopLinkArray($absolutAttachmentPath . "/attachments", $virtualAttachmentPath . "/attachments"); 
   }else{
	$attachmentLinks .= $attachmentDbLinks;
   }

   #$attachmentLinks = "";
   $innerTable->addField('','',$attachmentLinks);

   
   #extract tar archive


   # we extract and register for delete only if it is a texst email - therwise we do this in the loadMail.pl
   if($arr[7] eq 'text.html'){

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

      # aoskommentiert 28.02.2008 weil es fehler produziert
      #$commandString = "cd /" ;
      #system($commandString);
      #$commandString = "tar -C " . $pathToExtract . " -xzf " . $ pathToExtract . "/" . $pathToTarFile . "" ;
      #$commandStringReply = system($commandString);

   }
  
   $navigationHtml = "";
   $navigationHtml .= $navigation->getLinkButton('./sendMail.pl?v_u=' . $v_u . '&v_s=' . $v_s . '&mailId=' . $mailId, 'reply');

   $navigationHtml .= $navigation->getJavaScriptButton('showPop (\'./showSource.pl?v_u=' . $v_u . '&v_s=' . $v_s . '&mailId=' . $mailId . '\')', 'source');
   $navigationHtml .= $navigation->getJavaScriptButton('alert (\'todo\')', 'all recipients');
   $navigationHtml .= $navigation->getJavaScriptButton('alert (\'todo\')', 'attachments');
   $navigationHtml .= $navigation->getJavaScriptButton('mailClipMail(\'MailIdStart' . $arr[0] . 'MailIdEnd\')', 'clip mail');

   $navigationHtml .= $navigation->getJavaScriptButton('window.close()', 'close');


   #$navigationHtml .= "\n".'<span class="xxx">MailIdStart' . $arr[0] . 'MailIdEnd</span>';


   $outerTable->setName('idMailOuterTable');
   $outerTable->setStyle('mailOuterTable'); 
   $outerTable->addRow(); 
   $outerTable->addField('','',$navigationHtml );
   $outerTable->addRow(); 
   $outerTable->addField('','',$innerTable->getTable);
   $outerTable->addRow(); 


 # if text then text area else iframe
   if($arr[7] eq 'text.html'){

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

      $mailBody = $objMail->cleanHtmlBody($mailBody);


      $outerTable->addField('idMailIframeTd','mailIframeTd',$page->getArea('mailBody','mailFormArea',$mailBody));
      $page->setBodyOnLoad("resizeMailArea()");
   }else{
      $outerTable->addField('idMailIframeTd','mailIframeTd',$page->getIframe('mailFormIframe','./loadMail.pl?mailId=' . $mailId . '&v_u=' . $v_u . '&v_s=' . $v_s,'myIframe'));
      $page->setBodyOnLoad("resizeMailIframe()");
   }



   $page->setTitle(substr($objMail->cleanFromToSubject($arr[3]), 0, 30) . "... (" . substr($objMail->cleanEmail($objMail->cleanFromToSubject($arr[1])), 0, 20) . "... ) ");
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
my $elapsed = Time::HiRes::tv_interval( $start );
print "<!-- $elapsed -->\n";
# =======================================================================================

sub getFilesAsPopLinkArray{
   my ($absolutPath, $virtualPath) = @_;
   my @contents;
   my $listitem;
   opendir MYDIR, $absolutPath;
   @contents = readdir MYDIR;
   closedir MYDIR;
   my $currentPath;
   my $ret = "(abs: " . $absolutPath . "),(virt: " . $virtualPath . ")";
   my $pageTmp = Page->new();
   $ret = "";
   my $tmp;

   foreach $listitem ( @contents )
   {
     $tmp = $absolutPath . "/" . $listitem;
     if ( -d $tmp )
      {
	#print "It's a directory!";
      }
      else
      {         
         $currentPath = "$virtualPath/$listitem"; 
         $ret = $ret . $pageTmp->getPopLink("mailAttachmentStyle", $currentPath, $listitem) . ";&nbsp;&nbsp;";
      }
   }
   return $ret;
}
# =======================================================================================

exit 0