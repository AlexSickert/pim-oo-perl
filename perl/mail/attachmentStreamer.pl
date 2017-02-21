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

# =======================================================================================

my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objMailBusinessLayer = MailBusinessLayer->new();
my $objConfig = PageConfig->new();

# =======================================================================================

my $v_u = param("v_u");
my $v_s = param("v_s");
my $attachmentId= param("att");

# =======================================================================================

my @arr;
my @arrAttachments;
my $absolutAttachmentPath;
my $codestring;
my $codepart ;

# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# =======================================================================================
# content with security

	# get the mail id
	# mail_id, local_name,  mime_type 
	@arrAttachments = $objMailBusinessLayer->getAttachmentParams($attachmentId);

	# get parameters for the mail
	@arr = $objMailBusinessLayer->getMailById($arrAttachments[0]);
	$absolutAttachmentPath = $objConfig->mailDownloadPath() . "" . $arr[4] . "/" . $arr[5] . "/" . $arr[0] . "/attachments/" . $arrAttachments[1];
	  
	$arrAttachments[2]  =~ s/;//i;
	$arrAttachments[3]  =~ s/;//i;
	$arrAttachments[3]  =~ s/_//i;
	$arrAttachments[3]  =~ s/ //i;

#	print "Content-Type:application/octet-stream; name=\"DOWNLOADED-FILE." . $arrAttachments[2] . "\"\r\n";
#	print "Content-Disposition: attachment; filename=\"DOWNLOADED-FILE." . $arrAttachments[2] .  "\"\r\n\n";

	print "Content-Type:application/octet-stream; name=\"X." . $arrAttachments[3] . "." . $arrAttachments[2] . "\"\r\n";
	print "Content-Disposition: attachment; filename=\"X." . $arrAttachments[3] . "." . $arrAttachments[2] .  "\"\r\n\n";

	# read file

	open (CHECKBOOK, $absolutAttachmentPath) || die("Could not open file!");
	$codestring = "";
	while ($codepart = <CHECKBOOK>) {
		$codestring .= $codepart ;
	}
	close(CHECKBOOK);

	# stream the file
	print $codestring;

# =======================================================================================
#now else part  of security check
}else{
	# no permission
}
#end  part  of security check
# =======================================================================================

sub getMimeType{

    my ($string) = @_;

    $string = "." . $string;
    
    if("dwg" =~ m/$string/i){ return "application/acad"; };
    if("asd" =~ m/$string/i){ return "application/astound"; };
    if("asn" =~ m/$string/i){ return "application/astound"; };
    if("tsp" =~ m/$string/i){ return "application/dsptype"; };
    if("dxf" =~ m/$string/i){ return "application/dxf"; };
    if("spl" =~ m/$string/i){ return "application/futuresplash"; };
    if("gz" =~ m/$string/i){ return "application/gzip"; };
    if("ptlk" =~ m/$string/i){ return "application/listenup"; };
    if("hqx" =~ m/$string/i){ return "application/mac-binhex40"; };
    if(".mbd" =~ m/$string/i){ return "application/mbedlet"; };
    if(".mif" =~ m/$string/i){ return "application/mif"; };
    if(".xls" =~ m/$string/i){ return "application/msexcel"; };
    if(".xla" =~ m/$string/i){ return "application/msexcel"; };
    if(".hlp" =~ m/$string/i){ return "application/mshelp"; };
    if(".chm" =~ m/$string/i){ return "application/mshelp"; };
    if(".ppt" =~ m/$string/i){ return "application/mspowerpoint"; };
    if(".ppz" =~ m/$string/i){ return "application/mspowerpoint"; };
    if(".pps" =~ m/$string/i){ return "application/mspowerpoint"; };
    if(".pot" =~ m/$string/i){ return "application/mspowerpoint"; };
    if(".doc" =~ m/$string/i){ return "application/msword"; };
    if(".dot" =~ m/$string/i){ return "application/msword"; };
    if(".bin .exe .com .dll .class" =~ m/$string/i){ return "application/octet-stream"; };
    if(".oda" =~ m/$string/i){ return "application/oda"; };
    if(".pdf" =~ m/$string/i){ return "application/pdf"; };
    if(".ai .eps .ps" =~ m/$string/i){ return "application/postscript"; };
    if(".rtc" =~ m/$string/i){ return "application/rtc"; };
    if(".rtf" =~ m/$string/i){ return "application/rtf"; };
    if(".smp" =~ m/$string/i){ return "application/studiom"; };
    if(".tbk" =~ m/$string/i){ return "application/toolbook"; };
    if(".vmd" =~ m/$string/i){ return "application/vocaltec-media-desc"; };
    if(".vmf" =~ m/$string/i){ return "application/vocaltec-media-file"; };
    if(".htm .html .shtml .xhtml" =~ m/$string/i){ return "application/xhtml+xml"; };
    if(".xml" =~ m/$string/i){ return "application/xml"; };
    if(".bcpio" =~ m/$string/i){ return "application/x-bcpio"; };
    if(".cpio" =~ m/$string/i){ return "application/x-cpio"; };
    if(".csh" =~ m/$string/i){ return "application/x-csh"; };
    if(".dcr .dir .dxr" =~ m/$string/i){ return "application/x-director"; };
    if(".dvi" =~ m/$string/i){ return "application/x-dvi"; };
    if(".evy" =~ m/$string/i){ return "application/x-envoy"; };
    if(".gtar" =~ m/$string/i){ return "application/x-gtar"; };
    if(".hdf" =~ m/$string/i){ return "application/x-hdf"; };
    if(".php .phtml" =~ m/$string/i){ return "application/x-httpd-php"; };
    if(".js" =~ m/$string/i){ return "application/x-javascript"; };
    if(".latex" =~ m/$string/i){ return "application/x-latex"; };
    if(".bin" =~ m/$string/i){ return "application/x-macbinary"; };
    if(".mif" =~ m/$string/i){ return "application/x-mif"; };
    if(".nc .cdf" =~ m/$string/i){ return "application/x-netcdf"; };
    if(".nsc" =~ m/$string/i){ return "application/x-nschat"; };
    if(".sh" =~ m/$string/i){ return "application/x-sh"; };
    if(".shar" =~ m/$string/i){ return "application/x-shar"; };
    if(".swf .cab" =~ m/$string/i){ return "application/x-shockwave-flash"; };
    if(".spr .sprite" =~ m/$string/i){ return "application/x-sprite"; };
    if(".sit" =~ m/$string/i){ return "application/x-stuffit"; };
    if(".sca" =~ m/$string/i){ return "application/x-supercard"; };
    if(".sv4cpio" =~ m/$string/i){ return "application/x-sv4cpio"; };
    if(".sv4crc" =~ m/$string/i){ return "application/x-sv4crc"; };
    if(".tar" =~ m/$string/i){ return "application/x-tar"; };
    if(".tcl" =~ m/$string/i){ return "application/x-tcl"; };
    if(".tex" =~ m/$string/i){ return "application/x-tex"; };
    if(".texinfo .texi" =~ m/$string/i){ return "application/x-texinfo"; };
    if(".t .tr .roff" =~ m/$string/i){ return "application/x-troff"; };
    if(".man .troff" =~ m/$string/i){ return "application/x-troff-man"; };
    if(".me .troff" =~ m/$string/i){ return "application/x-troff-me"; };
    if(".me .troff" =~ m/$string/i){ return "application/x-troff-ms"; };
    if(".ustar" =~ m/$string/i){ return "application/x-ustar"; };
    if(".src" =~ m/$string/i){ return "application/x-wais-source"; };
    if(".zip" =~ m/$string/i){ return "application/zip"; };
    if("zip" =~ m/$string/i){ return "application/zip"; };
    if(".au .snd" =~ m/$string/i){ return "audio/basic"; };
    if(".es" =~ m/$string/i){ return "audio/echospeech"; };
    if(".tsi" =~ m/$string/i){ return "audio/tsplayer"; };
    if(".vox" =~ m/$string/i){ return "audio/voxware"; };
    if(".aif .aiff .aifc" =~ m/$string/i){ return "audio/x-aiff"; };
    if(".dus .cht" =~ m/$string/i){ return "audio/x-dspeeh"; };
    if(".mid .midi" =~ m/$string/i){ return "audio/x-midi"; };
    if(".mp2" =~ m/$string/i){ return "audio/x-mpeg"; };
    if(".ram .ra" =~ m/$string/i){ return "audio/x-pn-realaudio"; };
    if(".rpm" =~ m/$string/i){ return "audio/x-pn-realaudio-plugin"; };
    if(".stream" =~ m/$string/i){ return "audio/x-qt-stream"; };
    if(".wav" =~ m/$string/i){ return "audio/x-wav"; };
    if(".dwf" =~ m/$string/i){ return "drawing/x-dwf"; };
    if(".cod" =~ m/$string/i){ return "image/cis-cod"; };
    if(".ras" =~ m/$string/i){ return "image/cmu-raster"; };
    if(".fif" =~ m/$string/i){ return "image/fif"; };
    if(".gif" =~ m/$string/i){ return "image/gif"; };
    if(".ief" =~ m/$string/i){ return "image/ief"; };
    if(".jpeg" =~ m/$string/i){ return "image/jpeg"; };
    if(".jpg" =~ m/$string/i){ return "image/jpeg"; };
    if(".jpe" =~ m/$string/i){ return "image/jpeg"; };
    if(".png" =~ m/$string/i){ return "image/png"; };
    if(".tiff .tif" =~ m/$string/i){ return "image/tiff"; };
    if(".mcf" =~ m/$string/i){ return "image/vasa"; };
    if(".wbmp" =~ m/$string/i){ return "image/vnd.wap.wbmp"; };
    if(".ico" =~ m/$string/i){ return "image/x-icon"; };
    if(".pnm" =~ m/$string/i){ return "image/x-portable-anymap"; };
    if(".pbm" =~ m/$string/i){ return "image/x-portable-bitmap"; };
    if(".pgm" =~ m/$string/i){ return "image/x-portable-graymap"; };
    if(".ppm" =~ m/$string/i){ return "image/x-portable-pixmap"; };
    if(".rgb" =~ m/$string/i){ return "image/x-rgb"; };
    if(".xwd" =~ m/$string/i){ return "image/x-windowdump"; };
    if(".xbm" =~ m/$string/i){ return "image/x-xbitmap"; };
    if(".xpm" =~ m/$string/i){ return "image/x-xpixmap"; };
    if(".wrl" =~ m/$string/i){ return "model/vrml"; };
    if(".csv" =~ m/$string/i){ return "text/comma-separated-values"; };
    if(".css" =~ m/$string/i){ return "text/css"; };
    if(".htm" =~ m/$string/i){ return "text/html"; };
    if(".html" =~ m/$string/i){ return "text/html"; };
    if(".shtml" =~ m/$string/i){ return "text/html"; };
    if(".js" =~ m/$string/i){ return "text/javascript"; };
    if(".txt" =~ m/$string/i){ return "text/plain"; };
    if(".rtx" =~ m/$string/i){ return "text/richtext"; };
    if(".rtf" =~ m/$string/i){ return "text/rtf"; };
    if(".tsv" =~ m/$string/i){ return "text/tab-separated-values"; };
    if(".wml" =~ m/$string/i){ return "text/vnd.wap.wml"; };
    if(".wmlc" =~ m/$string/i){ return "application/vnd.wap.wmlc"; };
    if(".wmls" =~ m/$string/i){ return "text/vnd.wap.wmlscript"; };
    if(".wmlsc" =~ m/$string/i){ return "application/vnd.wap.wmlscriptc"; };
    if(".xml" =~ m/$string/i){ return "text/xml"; };
    if(".etx" =~ m/$string/i){ return "text/x-setext"; };
    if(".sgm .sgml" =~ m/$string/i){ return "text/x-sgml"; };
    if(".talk .spc" =~ m/$string/i){ return "text/x-speech"; };
    if(".mpeg" =~ m/$string/i){ return "video/mpeg"; };
    if(".mpg" =~ m/$string/i){ return "video/mpeg"; };
    if(".mpe" =~ m/$string/i){ return "video/mpeg"; };
    if(".qt .mov" =~ m/$string/i){ return "video/quicktime"; };
    if(".viv .vivo" =~ m/$string/i){ return "video/vnd.vivo"; };
    if(".avi" =~ m/$string/i){ return "video/x-msvideo"; };
    if(".movie" =~ m/$string/i){ return "video/x-sgi-movie"; };
    if(".vts .vtts" =~ m/$string/i){ return "workbook/formulaone"; };
    if(".3dmf .3dm .qd3d .qd3" =~ m/$string/i){ return "x-world/x-3dmf"; };
    if(".wrl" =~ m/$string/i){ return "x-world/x-vrml"; };

}

exit 0