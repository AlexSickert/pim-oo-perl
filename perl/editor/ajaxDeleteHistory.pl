#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use DBI;

require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';


if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}



my $objConfig;
$objConfig = PageConfig->new();

my $admin = AdminBusinessLayer->new();


print  "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";


# delete the complete history of all files

# the path to use is /var/www/vhosts/alex-admin.net/httpdocs/db_backup

# /var/www/vhosts/alex-admin.net//httpdocs/db_backup

my $updir; 
my $fullPath; 
my $datei;

my $counter = 0;

 $updir = "/var/www/vhosts/alex-admin.net//httpdocs/db_backup"; 

if(-e $updir) 
{ 
   opendir(DIR,$updir);
   while($datei = readdir(DIR)) { 	
	if($datei ne "." && $datei ne ".."){
	   	$fullPath =  $updir . "/" .  $datei ;
		unlink($fullPath);  
		# print("deleted: " . $fullPath);
		$counter = $counter + 1;
	}
   }
   closedir(DIR);
}

print("number of deleted files: " . $counter);

exit 0;



