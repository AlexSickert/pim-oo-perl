#!/usr/bin/perl

use strict;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:standard);
use warnings;
use File::stat;
use Time::localtime;

require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/LanguageBusinessLayer.pm';
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


my $modifyDate = param('modifyDate');

#  trying to save lastSync with value:1215937794

if($modifyDate eq ""){
    #$modifyDate = 1215021002;
    $modifyDate = 9999999999;
}


if($modifyDate <= 100 ){
    $modifyDate = 1;
}


#processFolder("/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl");
#processFolder("/var/www/vhosts", $modifyDate);

processFolder("/var/www/vhosts/alex-admin.net//httpdocs/db_backup", $modifyDate);
processFolder("/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live", $modifyDate);




# =======================================================================================

#  http://wwww.alex-admin.net/alex-admin/live/perl/data/getFileListForBackup.pl?modifyDate=2215021002



# =======================================================================================
sub processFolder{
   my ($absolutPath, $modifyDate) = @_;
   my @contents;
   my $listitem;
   my $handle;
my $doIt;
   opendir $handle, $absolutPath;

   @contents =  readdir $handle;

   closedir $handle;

#print "in processFolder()" .  "<br>";

   foreach $listitem ( @contents )
   {

     #print "in loop" .  "<br>\n";

     if ( -d $absolutPath . "/" . $listitem ){
	 if ($listitem ne "." &&  $listitem ne ".." ){


# exclude some paths
$doIt = 1;

if($absolutPath . "/" . $listitem eq '/var/www/vhosts/alex-admin.net/statistics/logs'){ $doIt = 0;};

if($absolutPath . "/" . $listitem eq '/var/www/vhosts/alexandersickert.com/statistics/logs'){ $doIt = 0;};
if($absolutPath . "/" . $listitem eq '/var/www/vhosts/cusoto.de/statistics'){ $doIt = 0;};
if($absolutPath . "/" . $listitem eq '/var/www/vhosts/solenski.de/statistics/logs'){ $doIt = 0;};

        

if($doIt == 1){
            processFolder($absolutPath . "/" . $listitem, $modifyDate);

}

         }
      } else{         
     #    print "searching file: " . $absolutPath . "/" . $listitem . "<br>\n";
	# following line added 26.7.2011 due to problems
	 if ($listitem ne "." &&  $listitem ne ".." ){
         	processFile($absolutPath . "/" . $listitem, $modifyDate);
	}
      }
   }
   return 1;
}
# =======================================================================================
sub processFile{
   my ($absolutPath, $modifyDate) = @_;  


  #($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
   #    $atime,$mtime,$ctime,$blksize,$blocks)
    #       = stat($filename);


  # print "processing file: "  . $absolutPath . "<br>\n";

   # der wert gibt sekunden seit 1970 an

if ( stat($absolutPath )->mtime  >  $modifyDate){

	# following line added 29.7.2011 to prevent download attempt of empty files
	if ( stat($absolutPath )->size  >  0 ){
		   print ""  . stat($absolutPath )->mtime  . "|";
		   print ""  . ctime(stat($absolutPath )->mtime)  . "|";
		   print ""  . $absolutPath . "|";
		   print ""  . (stat($absolutPath )->mode)  . "|";
		   print ""  . sprintf("0%o", stat($absolutPath )->mode & 07777) . "|";
		   print ""  . (stat($absolutPath )->size)  . "";
		   print  "\n";
	}

}

   return 1;
}
# =======================================================================================

exit 0