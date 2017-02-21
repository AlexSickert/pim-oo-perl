#!/usr/bin/perl

use strict;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:standard);
use warnings;
use File::stat;
use Time::localtime;
use MIME::Base64;



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


my $filePath = param('filePath');
my $content;
my $record;

# CREATE TABLE `files` (
# `id` BIGINT NOT NULL AUTO_INCREMENT ,
# `type` VARCHAR( 10 ) ,
# `ref_id` VARCHAR( 20 ) ,
# `file_name` VARCHAR( 255 ) ,
# `name_alias` VARCHAR( 255 ) ,
# `timestamp_created` BIGINT DEFAULT '0',
# `path_part` VARCHAR( 255 ) ,
# `upload_path` VARCHAR( 255 ) ,
# `mime_type` VARCHAR( 10 ) ,
# `file_size` BIGINT DEFAULT '0',
# PRIMARY KEY ( `id` ) ) TYPE = MYISAM ;

if ( sprintf("0%o", stat($filePath )->mode & 07777) eq "00"){
   chmod 0777, $filePath;
}

   open (CHECKBOOK, $filePath) || die "error reading from file";

   while ($record = <CHECKBOOK>) {
      $content .=  $record;
   }

   close(CHECKBOOK);

print encode_base64($content) ;


# =======================================================================================

exit 0