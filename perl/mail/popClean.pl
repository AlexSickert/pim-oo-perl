#!/usr/bin/perl

# =======================================================================================
# clean up file syste in loaded mails - delete detleted mails from filesystem
# =======================================================================================

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
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailSender.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailParser.pm';

if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}



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
my $mailBody;

my $pathToMails = "/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/mail/received/";
my $currPathToMail = "";

# =======================================================================================

my $v_u = param("v_u");
my $v_s = param("v_s");

# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# =======================================================================================
# content with security

   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "...";

   @arr = $objMailBusinessLayer->getRawMailsByFolderAndSearch("0", "");

   # SELECT id, sender, recipient, mail_subject, load_year, load_month, folder, read_version, folder_name

   #  id, sender, recipient, mail_subject, load_year, load_month, folder, read_version, folder_name
   #@arr = $objMailBusinessLayer->getMailById($mailId);

#print @arr ;

my $y;
my $count = 0;
my $processHasErrors;

$processHasErrors = 0;

if(-e $pathToMails ){
	####
}else{
	print 'Error: Path does not exist: ' . $currPathToMail;
	$processHasErrors = 1;
}


 for $y (0.. $#arr){

   $currPathToMail = $pathToMails . $arr[$y][4] . "/" . $arr[$y][5] . "/" . $arr[$y][0];

   if(-e $currPathToMail){

      $count = $count  + 1;
   
      deleteteFolderContent($currPathToMail . "/attachments"); 
      rmdir($currPathToMail . "/attachments");  
      deleteteFolderContent($currPathToMail . "/attachment");   
      rmdir($currPathToMail . "/attachment");  

      # --- delete main folder ----  

      deleteteFolderContent($currPathToMail ); 

      #--- delete the now empty folder -----

      rmdir($currPathToMail );  

     # --- delete the tgz files

	if(-e $currPathToMail . ".tgz" ){

		if (unlink($currPathToMail . ".tgz") == 0) {
			print " File was not deleted: " . $currPathToMail . ".tgz";
			$processHasErrors = 1;
		} else {
			#print " File deleted successfully: " . $currPathToMail . ".tgz";
		}
	}else{
		# print " File does not exist: " . $currPathToMail . ".tgz";
	}
   }else{
      #print 'Error: Path does not exist: ' . $currPathToMail;
   }

}

# if no error occured then set mails deleted
if($processHasErrors == 0){
	$objMailBusinessLayer->setMailDeleted;
	print "\nResult: " . $count  . ' mails deleted! No errors.';
}else{
	print "\nResult: " . $count  . ' mails deleted! Errors occured.';
}
  
	# now we clean the database by deleteing old rows
	# Select * from mail where mail_status = 'd' and load_year < (SELECT max(load_year) FROM  mail);
	# DELETE FROM mail where mail_status = 'd' AND load_year < (SELECT max(load_year) FROM  mail);
	# cleanDatabase
	print "... deleted old mails: " . $objMailBusinessLayer->cleanDatabase();

# =======================================================================================
#now else part  of security check

}else{
   	print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
	print 'Permission denied!';
}
#end  part  of security check

# =======================================================================================
sub deleteteFolderContent{
	my $basePath  = $_[0];
	my $subPath;
	my $dir;
	my $fileToDelete;
	my $datei;
	#print "<br>deleting content of: " . $basePath ;
		if(-e $basePath ) 
		{ 
		   opendir($dir,$basePath);
		   while($datei = readdir($dir)) { 	
	                $subPath = $basePath . "/" . $datei;
			if($datei ne "." && $datei ne ".."){
	                  if(-f $subPath ){
	                    $fileToDelete = $basePath . "/" . $datei;
	                    #print "<br>file to delete: " . $fileToDelete ;
	                    if (unlink($fileToDelete) == 0) {
	                        print " File not deleted: " . $fileToDelete;
	                    } else {
	                        #print " File deleted successfully.";
	                    }
	                 }
			     
			}
		   }
		   closedir($dir);
		}else{
	            #print "<br>path does not exist: " . $basePath ;
	       }

}

# =======================================================================================
exit 0