#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;
use Net::POP3;
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


if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error in ajaxLoadMail.pl - evaluating objects: $@"; 
}

# do not delete next line - it's a ajax file...
print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
print "test in ajaxLoadMail.pl";





# --------------------------------------- VARIABLES -----------------------------------------------
#my $user = "this.is.alex\@gmx.de";
#my $passwd = "5Ei4Gi8Ht2";
#my $pop3Server = "pop.gmx.net";

#to be able to load two email adresse withouth trouble of loop with unclear side effects it could be done wiht a check what the last
#email was we loaded - using database and this parameter stuf... 
#but not really professional. differtn approach is to dopy the file here and do proper identitation in scintilla text editor. 
#this then in linus

my $user = "alex\@alexandersickert.com";
my $passwd = "9Pm4Cy7Nx3Xd7Oq6";
my $pop3Server = "alexandersickert.com";


my $hash_ref;
my $currUid;
my $key;
my $oneMailLoaded;

my $to;
my $from;
my $subject;
my $matchAddress;
my $text = "";
my $html = "";
my $tmpValue;
my $mailDate;
my $mailDateSql;
my @mailDateSqlArr;

my $permissions = 0777;
my $v_second = (localtime())[0];
my $v_minute = (localtime())[1];
my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
$v_month = $v_month + 1;
my $v_year = (localtime())[5] + 1900;
my $random;
my $zeile;
my $uidInDb;
my $y;

my $error;
my $readVersion;
my $commandString;
my $result;
my $strippedContent = "";

my $pathToChangeInto ;
my $folderForTar ;
my $yMax;
my $stopLoop;
my $fileOk;
my $deleteFilePath;
my $fileHandle;
my $startTime;
my $currentTime;
my $timeElapsed;
my $maxTimeElapsed = 300000;
my $nextMailId;
my $nextMailIdFirst;
#my $message;
my $uidPopCount;
my $objMail;
my @fileNotOkArr;
my $fileNotOkVal;
my $message = "";
my @attachmentLocalName;
my @attachmentOriginalName;
my @attachmentType;
my @attachmentSize;
my $attachmentMax;
my $spamFrom;
my $spamCompare;
my $spamId;
my @spamAdresses;
my $spamCounter;
# --------------------------------------- OTHER -----------------------------------------------



# --------------------------------------- OBJECTS-----------------------------------------------

my $objMailBusinessLayer = MailBusinessLayer->new();
my $objConfig = PageConfig->new();
my $admin = AdminBusinessLayer->new();



my $pop3Obj = Net::POP3->new($pop3Server, Timeout => 600) ;
$pop3Obj ->user($user);
$pop3Obj ->pass($passwd);




# --------------------------------------- PROGRAM -----------------------------------------------




# make sure we are not loading mails in parallel from various instances
my $mailCurrentlyLoading = $admin->getParameter('mail','currentlyLoading');


# here we need to reset the mail load blocking based on a taime out. if too much time passed, then still allow loading 
$currentTime = time();
$timeElapsed = $currentTime - $admin->getParameter('mail','currentlyLoadingTimeStamp'); 
# if last loading was 100 seconds ago then do not block 

print "... 1 - mailCurrentlyLoading = " . $admin->getParameter('mail','currentlyLoading') . "...";
print "... 2 - mailCurrentlyLoading time elapsed is = " . $timeElapsed . "...";

if ($timeElapsed gt 300){
	$admin->setParameter('mail','currentlyLoading','no');
}

print "... mailCurrentlyLoading = " . $admin->getParameter('mail','currentlyLoading') . "...";

if ($mailCurrentlyLoading  eq 'yes'){
	print "... 3 - mail is currently being loaded from POP... therefore doing nothing now... ";

}else{

$admin->setParameter('mail','currentlyLoading','yes');
print "... 4 - mailCurrentlyLoading = " . $admin->getParameter('mail','currentlyLoading') . "...";

my @arrUilList = $pop3Obj->uidl() ;

my $fileName = $v_year . "-" . $v_month . "-" . $v_day . "-" . $v_hour . "-" . $v_minute . "-" . $v_second ;
#print  $fileName  ;

my $pathToTmpFolder = $objConfig->mailDownloadPath() .$v_year;


if(! -e $pathToTmpFolder ){   
   print "making folder";
   mkdir($pathToTmpFolder );
};

$pathToTmpFolder = $pathToTmpFolder . "/" . $v_month;

#print $pathToTmpFolder ;

if(! -e $pathToTmpFolder ){   
   mkdir($pathToTmpFolder );
};

$pathToChangeInto = $pathToTmpFolder;
#-------------------------------------------------------------------------------------------

$oneMailLoaded = 0;

my @uidArrayInDb = $objMailBusinessLayer->getUidArray();

#-------------------------------------------------------------------------------------------

$nextMailIdFirst = $objMailBusinessLayer->getNextMailId();

$oneMailLoaded = 'stop';
$stopLoop = 'false';

$startTime = time();
$uidPopCount = 0;

foreach $hash_ref ( @arrUilList ) {
   
   foreach $key (keys %{$hash_ref}){
      $uidPopCount = $uidPopCount + 1;
      $currUid = $hash_ref->{$key};	

      #print "uid: " . $currUid . " key: " . $key . "<br>";

      #check if already 10 seconds passed and if so then abort loop
      #$currentTime = time();
      #$timeElapsed = $currentTime - $startTime;  

      $timeElapsed = 1;

      #check if current uidl already downloaded
      $oneMailLoaded = 'stop'; 
      if($timeElapsed < $maxTimeElapsed){
         
         $oneMailLoaded = 'search';
         
         $yMax = $#uidArrayInDb;

         for $y (0.. $#uidArrayInDb ){
            $uidInDb = $uidArrayInDb[$y][0];
            if($uidInDb eq $currUid){
               $oneMailLoaded = 'found';
               $y = $yMax;              
            }
         }

         if($oneMailLoaded ne 'found'){
            $oneMailLoaded = 'insert';           
         }
      }else{
         $oneMailLoaded = 'timeout';
      }
      
      # downloading one single mail
      if($oneMailLoaded eq 'insert'){

         print "need to download file with uid|" . $currUid ;

         #create folder to store files

         $nextMailId = $objMailBusinessLayer->getNextMailId();

         
         $pathToTmpFolder = $pathToChangeInto . "/" . $nextMailId ;
         $folderForTar = $nextMailId ;

         if(! -e $pathToTmpFolder ){   
            mkdir($pathToTmpFolder );
         };


         # if the current uidl is not in array then download else ignore

         # an dieser stelle gibt es ein problem. spezielle mails erzeugen kein file
         # to do: testweise eine 2. methode einbauen die die datei mit andere methode downloaded
         # undzwar mit get() aber ohne filehandle und dann array step by step auslesen 
         # siehe http://perldoc.perl.org/Net/POP3.html

         open($fileHandle, "> " .$pathToTmpFolder . "/" . $fileName . ".txt");
         $pop3Obj ->get($key, $fileHandle);
         close($fileHandle);

         #if the file ist empty then we have a problem. to check that we read content
         open($fileHandle, "< " .$pathToTmpFolder . "/" . $fileName . ".txt");
         $fileOk = 'false';
         $deleteFilePath = $pathToTmpFolder . "/" . $fileName . ".txt";
         #print "-------------------- file -------------------------";
         #print $pathToTmpFolder . "/" . $fileName . ".txt";

	 while ($zeile = <$fileHandle>)
	 {
           # print "zeile: " . $zeile . "<br>";
	    if (length($zeile) > 3 ){
	       $fileOk = 'true';
	    }
         }
         close $fileHandle;

         if($fileOk eq 'false'){
            # @fileNotOkArr = $pop3Obj ->get($key);

            #print "as file not OK getting array: <br>"; 
            for my $fileNotOkVal($pop3Obj ->get($key) ) {
               #print $fileNotOkVal;
            } 
         }

         #print $pathToTmpFolder . "/" . $fileName  ;
         # now we have the mail and we need to process it with database

         $objMail = MailParser->new();

         $error = 0;
         eval {$objMail->loadMail($pathToTmpFolder . "/", $fileName  , "txt") || die $error = 1}; 

         if ($error == 1){
            $to = "error";
            $from = "error";
            $subject = "error";
            $text = "error";
            $html = "error";
            $mailDate = "error";
            $mailDateSql = "1900-01-01 00:00:00"
         }else{
            $to = encode_base64($objMail->getTo());
            $from = encode_base64($objMail->getFrom());
            #$subject = encode_base64($objMail->getSubject() . $objMail->getVersion());
	    $subject = encode_base64($objMail->getSubject());
            $text = $objMail->getText();
            $html = $objMail->getHtml();
            $mailDate = $objMail->getDate(); 

            chomp($mailDate);
            @mailDateSqlArr = split(" ", $mailDate);
            #  Tue, 14 Aug 2007 12:08:26 -0500
            $mailDateSql = $mailDateSqlArr[3] . "-" . $mailDateSqlArr[2] . "-" . $mailDateSqlArr[1] . " " . $mailDateSqlArr[4];

            $mailDateSql =~ s/Jan/01/i;
            $mailDateSql =~ s/Feb/02/i;
            $mailDateSql =~ s/Mar/03/i;
            $mailDateSql =~ s/Apr/04/i;
            $mailDateSql =~ s/May/05/i;
            $mailDateSql =~ s/Jun/06/i;
            $mailDateSql =~ s/Jul/07/i;
            $mailDateSql =~ s/Aug/08/i;
            $mailDateSql =~ s/Sep/09/i;
            $mailDateSql =~ s/Oct/10/i;
            $mailDateSql =~ s/Nov/11/i;
            $mailDateSql =~ s/Dec/12/i;

           # hier ist ggf ein fehler deswegen die nest 3 zeilen auskommentiert - 10.02.2008
           # if date format not OK then use current date
	    if (length($mailDateSql) > 19 ||  length($mailDateSql) < 8){
	       $mailDateSql = $v_year . "-" . $v_month . "-" . $v_day . " " . $v_hour . ":" . $v_minute . ":" . $v_second;
	    }
            $mailDateSql = $v_year . "-" . $v_month . "-" . $v_day . " " . $v_hour . ":" . $v_minute . ":" . $v_second;
            $mailDate .= " (" . $mailDateSql . ")";
         }

         if(length ($html) >= length ($text)){
            $readVersion = 'html.html';
         }else{
            $readVersion = 'text.html';
         }

         $strippedContent = $objMail->dumpContent($objMail->getTo().$objMail->getFrom().$objMail->getSubject().$text . $html); 


	# february 2010
	# register the attachments in database
	# $nextMailId
	@attachmentLocalName = $objMail->getFileNamesServer();
	@attachmentOriginalName = $objMail->getFileNamesDescription();
	@attachmentType = $objMail->getFileTypes();
	@attachmentSize = $objMail->getFileSizes();

	$attachmentMax = $#attachmentLocalName;
	# add each file
	for $attachmentMax  (0.. $#attachmentLocalName){
		$objMailBusinessLayer->registerAttachment($nextMailId, $attachmentLocalName[$attachmentMax], $attachmentOriginalName[$attachmentMax], $attachmentType[$attachmentMax], $attachmentSize[$attachmentMax]);
	}
	# end of february 2010 register mail stuff


         # register mail in DB if content is OK
         if ($fileOk eq 'true'){ 
            #$message .= " put to database: " . $from . " - " . $subject;
            $message .= "<br>&nbsp;&nbsp;&nbsp;&nbsp;loaded mail: " . $currUid . " parser version: " . $objMail->getVersion() ;
            $objMailBusinessLayer->registerMail($currUid , $from , $to , $subject , $v_year , $v_month , $fileName, $readVersion, $strippedContent, $mailDate, $mailDateSql);
         
		#  move mail to spam or trash if sender is in spam list
		#  print "SENDER: " . $from;
		$spamFrom =  decode_base64($from);

		#  load spam list and loop through it
		@spamAdresses = $objMailBusinessLayer->getSpamAdresses();

		for $spamCounter (0.. $#spamAdresses){
			if ($spamFrom =~ m/$spamAdresses[$spamCounter][0]/i){
				$spamId = $objMailBusinessLayer->getMailIdByUid($currUid);
				# 0 is the trash folder
				$objMailBusinessLayer->moveMail($spamId, 0 );
			}
		}



           # so bekommt man da adate - gesehen auf http://www.thomas-fahle.de/pub/perl/Mail_and_News/POP3.html

           #        foreach (@{$pop3->top($msgno)}) { # Header abklappern

           #                $subject = $1 if /^Subject:\s+(.*)/i;
           #                $from    = $1 if /^From:\s+(.*)/i;
           #                $date    = $1 if /^Date:\s+(.*)/i;
           #        }

           open($fileHandle, "> ".$pathToTmpFolder ."/html.html");						
           print $fileHandle $html; 
           close $fileHandle;

           open($fileHandle, "> ".$pathToTmpFolder ."/text.html");						
           print $fileHandle $text; 
           close $fileHandle;

           # pack stuff into tar archive
           #$commandString = "tar -C " . $pathToChangeInto . " -czf " . $pathToChangeInto . "/" . $folderForTar . ".tgz " . $folderForTar . "" ;
           #system($commandString);

           # delete original folder
           my $pathToAttachments = $pathToTmpFolder . '/attachments';

           # register tsr file for sync
           #$admin->registerFileForSync($pathToTmpFolder ."/html.html", "new");
           #$admin->registerFileForSync($pathToTmpFolder ."/text.html", "new"); 

           # save attachments
           opendir MYDIRATTACHMENTS, $pathToAttachments;
           my @contents;
           @contents = readdir MYDIRATTACHMENTS;
           my $listitem;
           my $currentAttachmentPath;
           foreach $listitem ( @contents )
          {
              if ( -d $listitem )
              {
	         #print "It's a directory!";
              }
             else
             {                       
                 $currentAttachmentPath = $pathToAttachments .  "/" . $listitem;
                 #$admin->registerFileForSync($currentAttachmentPath, "new"); 
             }
          }
          closedir MYDIRATTACHMENTS;
   

           # next e zeilen auskommetniert weil es eventuell probleme gibt - 10.02.2008
           #$objMail->deleteFilesAndFolder($pathToTmpFolder . '/attachments');
           #$objMail->deleteFilesAndFolder($pathToTmpFolder );

         }else{
            # delete the file
            $message .= " download failed (" . $uidPopCount . "/" . $currUid .") file: " . $pathToTmpFolder . "/" . $fileName . ".txt";
            unlink($deleteFilePath);
         }
      }
   }

} #next element in array from pop account


$pop3Obj->quit;

#-------------------------------------------------------------------------------------------
# give back result of mail download

$currentTime = time();
$timeElapsed = $currentTime - $startTime;  

if($oneMailLoaded eq 'timeout'){
   print $nextMailIdFirst . "|continue-loop|".$fileName . " msg: " . $message . " elapsed: " . $timeElapsed . " uidPopCount: " . $uidPopCount;
}else{
   #print "-1|stop-loop|".$fileName  . " time elapsed: " . $timeElapsed . " mails on pop server: " . $uidPopCount . " message: " . $message ;
   print "-1|stop-loop|" . " time elapsed in seconds: " . $timeElapsed . " | mails on pop server: " . $uidPopCount . "| message: " . $message ;
}


# now the blocking of mail loading is over. 
$admin->setParameter('mail','currentlyLoadingTimeStamp',$currentTime);
$admin->setParameter('mail','currentlyLoading','no');
# this is end bracket of check if we are currently loading mails
print "... mailCurrentlyLoading = " . $admin->getParameter('mail','currentlyLoading') . "...";
}




exit 0