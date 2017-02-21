#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;
use Encode;
use utf8;
use HTML::Entities;
use MIME::Base64;

# print "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";


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
   print "Fehler: $@"; 
}


# =======================================================================================

my @arr;
my @inner;
my $test;
my $form;
my $navigationHtml;
my $pathToTmpFolder;
my $ret;
my @raw_data;
my $dataLine;
my $emailDropString;
my $emailCompareString;
my $emailDefault;
my $signature;

# =======================================================================================

my $navigation = Navigation->new();
my $page = Page->new();
my $innerTable = Table->new();
my $outerTable = Table->new();
my $attachmentTable = Table->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();

# print "->test begin...";
#print $objAdminBusinessLayer->checkLoginT("xxx", "yyy");
# print $objAdminBusinessLayer->checkLogin("xxx", "yyy");
 #print "->test end...-";

my $objMailBusinessLayer = MailBusinessLayer->new();
 #print "---test 2 ---";
my $objConfig = PageConfig->new();
 #print "---test 3 ---";
my $objMail = MailParser->new();
 #print "---test 4 ---";
my $mailSender = MailSender->new();
 #print "---test 4 ---";


# =======================================================================================

my $v_u = "";
my $v_s =  "";
my $mailId = "";
my $action = "";
my $mailBody = "";
my $mailFrom = "";
my $mailTo = "";
my $mailCC = "";
my $mailSubject = "";

if (defined   param("v_u")   ){   $v_u = param("v_u");  };
if (defined   param("v_s")   ){   $v_s = param("v_s");  };
if (defined   param("mailId")   ){   $mailId  = param("mailId");  };
if (defined   param("formAction")   ){   $action = param("formAction");  };
if (defined   param("mailBody")   ){   $mailBody = param("mailBody");  };
if (defined   param("from")   ){   $mailFrom = param("from");  };
if (defined   param("to")   ){   $mailTo = param("to");  };
if (defined   param("cc")   ){   $mailCC = param("cc");  };
if (defined   param("subj")   ){   $mailSubject = param("subj");  };

$mailBody = decode_utf8($mailBody);

#$mailSubject = decode_utf8($mailSubject);
#$mailSubject = '=?UTF-8?B? ' . encode_base64($mailSubject) . ' ?=';
$mailSubject = decode_utf8($mailSubject);
$mailSubject = "=?UTF-8?B?" . encode_base64(encode("utf8", $mailSubject), "") . "?=";


# =======================================================================================

$page->setTitle($objConfig->get("Read mail"));
$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'mail.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');
$page->addJavaScript($objConfig->jsPath() . 'mail.js');
$page->addJavaScript($objConfig->jsPath() . 'ajax.js');


# =======================================================================================




 #print "---test 5 ---";
# print $objAdminBusinessLayer->checkLogin($v_u,$v_s);
 #print "--- after 5 ----";


if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){

# =======================================================================================
# content with security

 #print "xxx 4444";

# 2 teile - 1. teil erzeugt das formular und 2. teil sendet mail

# tmp save einbauen 

# ================================ SEND THE MAIL =======================================================
   if($action eq 'send'){
      # ------------------------------------------------------------------------------------------------


      # find out which mail

      $emailCompareString = $objConfig->mailLogin("1","email");
      if($mailFrom =~ m/$emailCompareString/){ 
         $mailId = "1"; 
         $signature = $objConfig->mailLogin("1","signature"); 
      }
      $emailCompareString = $objConfig->mailLogin("2","email"); 

      if($mailFrom =~ m/$emailCompareString/){ 
         $mailId = "2"; 
         $signature = $objConfig->mailLogin("2","signature"); 
      }
      $emailCompareString = $objConfig->mailLogin("3","email"); 
      if($mailFrom =~ m/$emailCompareString/){ 
         $mailId = "3"; 
         $signature = $objConfig->mailLogin("3","signature"); 
      }

      # append signature

      $mailBody = $mailBody  . "\n--\n\n" . $signature;

	$mailBody = encode_entities($mailBody);
	$mailSubject = encode_entities($mailSubject);

	# convert to html
	$mailBody =~s/\n\r/<br >/g;
	$mailBody =~s/\r\n/<br >/g;
	$mailBody =~s/\n/<br >/g;

	$mailBody = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8' /><title>...</title></head><body><font size='2' face='Arial, Helvetica, Verdana, sans-serif' >" . $mailBody . "</font></body></html>";
	# <font size='2' face='Arial, Helvetica, Verdana, sans-serif>

      # add attachments  addAttachment
      $mailSender->addAttachment();

      # compose final mail

      # $mailBody = encodeBody($mailBody);
      # use base 64 for encoding now hence no encoding anymore

      # $mailSender->setContent($mailFrom , $mailTo , $mailCC , $mailCC , $mailSubject , $mailBody );
      $mailSender->setContent($mailFrom , $mailTo , $mailCC , $mailCC , $mailSubject , $mailBody );
	# this.is.alex@gmx.de


      $ret = $mailSender->sendMail($objConfig->mailLogin($mailId,"server"), $objConfig->mailLogin($mailId,"login"), $objConfig->mailLogin($mailId,"password"));

      $page->addContainer('mailFormId','mailSuccess',  $ret);
      $page->positionContainerAbsolut("mailFormId", "CENTER", "CENTER", 10, 10, 10,10);

# ================================ PREPARE  MAIL =======================================================
   }else{

   $navigationHtml = "";
   #$navigationHtml .= $page->getSubmit('a','b','Send');
   $navigationHtml .= $navigation->getJavaScriptButton('sendMyMailForm()', 'send');
   #$navigationHtml .= $page->getSubmit('','','send (IE)');
   $navigationHtml .= $navigation->getJavaScriptButton('window.close()', 'close');
  $navigationHtml .= $navigation->getJavaScriptButton('mailShowAttachments()', 'Attachments');

   
   # get mail content from DB
   
   #  0    1       2            3           4          5             6       7             8
   # id, sender, recipient, mail_subject, load_year, load_month, folder, read_version, folder_name
   @arr = $objMailBusinessLayer->getMailById($mailId);

   # $innerTable 
   # $outerTable 
   $innerTable->setStyle('mailInnerTable');
   $innerTable->addRow();
   $innerTable->addField('','mailNoBorder','from:');


#   my ( $self, $name, $class, $dropdown, $default, $defaultDisplay)

   $emailDropString = "";
   $emailDropString .= $objConfig->mailLogin("1","email") ."<f>". $objConfig->mailLogin("1","email") . "<r>";
   $emailDropString .= $objConfig->mailLogin("2","email") ."<f>". $objConfig->mailLogin("2","email") . "<r>";
   $emailDropString .= $objConfig->mailLogin("3","email") ."<f>". $objConfig->mailLogin("3","email") . "";

   $emailCompareString = $objMail->cleanEmail($objMail->stripEmail($arr[2])) . "";
   $emailCompareString =~ s/ //gi;

   if($emailDropString =~ m/$emailCompareString/){
      $emailDefault = $emailCompareString;
   }else{
      $emailDefault = $objConfig->mailLogin("0","default");
   }



   #$innerTable->addField('','mailNoBorder',$page->getInput('from','sendMailInput',$emailDropString ));
   $innerTable->addField('','mailNoBorder',$page->getDropdown('from','sendMailInput',$emailDropString ,$emailDefault ,$emailDefault ));
   
   $innerTable->addRow();
   $innerTable->addField('','mailNoBorder',$page->getJavaScriptButton('toAddress', 'mailBtnToAndCc', 'To: [, ]', 'addMailAddress(\'to\', \'' . $v_u . '\',\'' . $v_s . '\')'));
   $innerTable->addField('','mailNoBorder',$page->getInput('to','sendMailInput',$objMail->stripEmail($arr[1])));
   #$innerTable->addField('','mailNoBorder','[comma + space]');

   $innerTable->addRow();
   $innerTable->addField('','mailNoBorder',$page->getJavaScriptButton('ccAddress', 'mailBtnToAndCc', 'Cc:  [, ]', 'addMailAddress(\'cc\', \'' . $v_u . '\',\'' . $v_s . '\')'));
   $innerTable->addField('','mailNoBorder',$page->getInput('cc','sendMailInput',''));
   #$innerTable->addField('','mailLabel','[comma + space]');

   $innerTable->addRow();
   $innerTable->addField('','mailNoBorder','subject:');
   $innerTable->addField('','mailNoBorder',$page->getInput('subj','sendMailInput',$objMail->cleanFromToSubject($arr[3])));
   #$innerTable->addField('','mailNoBorder','');


   $pathToTmpFolder = $objConfig->mailDownloadPath();

   $pathToTmpFolder .= "" .$arr[4];
   $pathToTmpFolder .= "/" .$arr[5];
   $pathToTmpFolder .= "/" .$arr[0];
   #$pathToTmpFolder .= "/" .$arr[7];
   $pathToTmpFolder .= "/" .$arr[7] ;

   open(DAT, $pathToTmpFolder );
   @raw_data=<DAT>;
   close(DAT);

   foreach $dataLine(@raw_data)
   {
      #chop($dataLine);
      $mailBody .= $dataLine;
   }

   if($arr[7] eq 'html.html'){
      $mailBody = $objMail->cleanHtmlBody($mailBody);
   }

   if($mailBody ne ""){
      $mailBody =  "\n\n-----Original Message-----\n\n" . $mailBody ;
   }


   $outerTable->setName('idMailOuterTable');
   $outerTable->setStyle('mailOuterTable'); 
   $outerTable->addRow(); 
   $outerTable->addField('','mailNoBorder',$navigationHtml );
   $outerTable->addRow(); 
   $outerTable->addField('','mailNoBorder',$innerTable->getTable);
   $outerTable->addRow(); 
   $outerTable->addField('idMailIframeTd','mailNoBorder',$page->getArea('mailBody','mailFormArea',$mailBody));


   $form = $outerTable->getTable ;


	# adding a container that holds the attachments - in a hidden div

	$attachmentTable->addRow(); 
	$attachmentTable->addField('','','file 1:'. $page->getFile('file_1','file_1'));
	$attachmentTable->addRow(); 
	$attachmentTable->addField('','','file 2:'. $page->getFile('file_2','file_2'));
	$attachmentTable->addRow(); 
	$attachmentTable->addField('','','file 3:'. $page->getFile('file_3','file_3'));
	$attachmentTable->addRow(); 
	$attachmentTable->addField('','','file 4:'. $page->getFile('file_4','file_4'));
	$attachmentTable->addRow(); 
	$attachmentTable->addField('','','file 5:'. $page->getFile('file_5','file_5'));

	$attachmentTable->addRow(); 
	$attachmentTable->addField('','',$page->getJavaScriptButton('toAddress', 'xyzclass', 'OK', 'mailHideAttachments()')    );




   $form .= $page->getContainer('mailAttachmentsDivId', 'mailAttachmentsDiv', $attachmentTable->getTable );

	# end of adding hidden container

   $form .= $page->getHidden('v_u',$v_u);
   $form .= $page->getHidden('v_s',$v_s);
   $form .= $page->getHidden('formAction','send');

   $form .= $page->getHidden('file_name_1','');
   $form .= $page->getHidden('file_name_2','');
   $form .= $page->getHidden('file_name_3','');
   $form .= $page->getHidden('file_name_4','');
   $form .= $page->getHidden('file_name_5','');

   #    $objConfig->codePathAbsolut() . "/mail/sendMail.pl"

   $form = $page->getForm('myForm','',$objConfig->codePathAbsolut() . "mail/sendMail.pl", $form );

   $page->setBodyClass('showMailBody');
   #$page->setBodyOnLoad("resizeMailIframe()");
   $page->setBodyOnLoad("resizeMailArea()");

   $page->addContent($form );

   $page->addContainer('mailAddressDivId', 'mailAddressDiv', 'sdfasdfasdfasdfa');

   $page->positionContainerAbsolut("mailAttachmentsDivId", "CENTER", "CENTER", 100, 100, 100,100);
   $page->positionContainerAbsolut("mailAddressDivId", "CENTER", "CENTER", 100, 100, 100,100);

   }    # end of paret for preparing the mail




# ================================ SECURITY FAILED =======================================================
#now else part  of security check - if no security then jump back
}else{
 #print "xxx 555";
   $page->jumpToPage("../admin/login.pl");
}
#end  part  of security check
# ================================== DISPLAY PAGE =====================================================
 #print "xxx 666";
$page->setEncoding('xhtml');
$page->initialize;
$page->display;

#################################################
sub xxxxxxencodeBody{
	my ($string) = @_;
	my $tmpThreeCharacters;
	my $ret = "";
	my $tmp;
	my $i = 0;
	my $lengthBefore;
	my $lengthAfter;
	my $lengthDiff;
	my $continue = "1";
	my $c;

	while($continue eq "1"){
	
		$tmpThreeCharacters = substr($string, $i, 1);
		$lengthBefore = length($tmpThreeCharacters);
	
		if($lengthBefore == 0){
			$continue =  "0" ;
		}else{		
			$tmp = encodeOneCharacters($tmpThreeCharacters);		
			$i = $i + 1;		
			$ret .= $tmp;
		}
	}
	return $ret;
}

#################################################
sub xxxxxxxencodeOneCharacters{
	my ($string) = @_;
	my $c;

	if($string eq '='){
		$string =~s/=/=3D/g;
	}else{

		$string =~s/#/=23/g;
		$string =~s/%/=25/g;
		$string =~s/&/=26/g;
		#$string =~s/'/=27/g;
#	$string =~s/:/=3A/g;
#	$string =~s/;/=3B/g;
		$string =~s/</=3C/g;
#	$string =~s/=/=3D/g;
		$string =~s/=/=3D/g;
		$string =~s/>/=3E/g;
		$string =~s/_/=5F/g;
		$string =~s/`/=60/g;
		$string =~s/¡/=A1/g;
		$string =~s/¢/=A2/g;
		$string =~s/£/=A3/g;
		$string =~s/¤/=A4/g;
		$string =~s/¥/=A5/g;
		$string =~s/¦/=A6/g;
		$string =~s/§/=A7/g;
		$string =~s/¨/=A8/g;
		$string =~s/©/=A9/g;
		$string =~s/ª/=AA/g;
		$string =~s/«/=AB/g;
		$string =~s/¬/=AC/g;
		$string =~s/­/=AD/g;
		$string =~s/®/=AE/g;
		$string =~s/¯/=AF/g;
		$string =~s/°/=B0/g;
		$string =~s/±/=B1/g;
		$string =~s/²/=B2/g;
		$string =~s/³/=B3/g;
		$string =~s/´/=B4/g;
		$string =~s/µ/=B5/g;
		$string =~s/·/=B7/g;
		$string =~s/¸/=B8/g;
		$string =~s/¹/=B9/g;
		$string =~s/º/=BA/g;
		$string =~s/»/=BB/g;
		$string =~s/¼/=BC/g;
		$string =~s/½/=BD/g;
		$string =~s/¾/=BE/g;
		$string =~s/¿/=BF/g;
		$string =~s/À/=C0/g;
		$string =~s/Á/=C1/g;
		$string =~s/Â/=C2/g;
		$string =~s/Ã/=C3/g;
		$string =~s/Ä/=C4/g;
		$string =~s/Å/=C5/g;
		$string =~s/Æ/=C6/g;
		$string =~s/Ç/=C7/g;
		$string =~s/È/=C8/g;
		$string =~s/É/=C9/g;
		$string =~s/Ê/=CA/g;
		$string =~s/Ë/=CB/g;
		$string =~s/Ì/=CC/g;
		$string =~s/Í/=CD/g;
		$string =~s/Î/=CE/g;
		$string =~s/Ï/=CF/g;
		$string =~s/Ð/=D0/g;
		$string =~s/Ñ/=D1/g;
		$string =~s/Ò/=D2/g;
		$string =~s/Ó/=D3/g;
		$string =~s/Ô/=D4/g;
		$string =~s/Õ/=D5/g;
		$string =~s/Ö/=D6/g;
		$string =~s/×/=D7/g;
		$string =~s/Ø/=D8/g;
		$string =~s/Ù/=D9/g;
		$string =~s/Ú/=DA/g;
		$string =~s/Û/=DB/g;
		$string =~s/Ü/=DC/g;
		$string =~s/Ý/=DD/g;
		$string =~s/Þ/=DE/g;
		$string =~s/ß/=DF/g;
		$string =~s/à/=E0/g;
		$string =~s/á/=E1/g;
		$string =~s/â/=E2/g;
		$string =~s/ã/=E3/g;
		$string =~s/ä/=E4/g;
		$string =~s/å/=E5/g;
		$string =~s/æ/=E6/g;
		$string =~s/ç/=E7/g;
		$string =~s/è/=E8/g;
		$string =~s/é/=E9/g;
		$string =~s/ê/=EA/g;
		$string =~s/ë/=EB/g;
		$string =~s/ì/=EC/g;
		$string =~s/í/=ED/g;
		$string =~s/î/=EE/g;
		$string =~s/ï/=EF/g;
		$string =~s/ð/=F0/g;
		$string =~s/ñ/=F1/g;
		$string =~s/ò/=F2/g;
		$string =~s/ó/=F3/g;
		$string =~s/ô/=F4/g;
		$string =~s/õ/=F5/g;
		$string =~s/ö/=F6/g;
		$string =~s/÷/=F7/g;
		$string =~s/ø/=F8/g;
		$string =~s/ù/=F9/g;
		$string =~s/ú/=FA/g;
		$string =~s/û/=FB/g;
		$string =~s/ü/=FC/g;
		$string =~s/ü/=FC/g;
		$string =~s/ü/=FC/g;
		$string =~s/ü/=FC/g;
		$string =~s/â€ž/=84/g;
		$string =~s/â€œ/=93/g;   
        	$c = chr(132);
		$string =~ s/$c/=84/g;
        	$c = chr(147);
		$string =~ s/$c/=93/g;

	}

	 
    
   	return $string;
} 
#################################################

exit 0