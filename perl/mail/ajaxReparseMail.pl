#!/usr/bin/perl

# --------------------------------------- STATUS UND TODOs --------------------------------------------------
# 
#    der multipart alterntive geht zum teil - weitere tests nötig !!!!
#    in multipart alternative habe ihc noch keine attachments getested !!!!
#    ich glaube es fehlt das speicern der attachments - oder ??? eventuell sind sie auf der platte aber fehlt in der datenbank...
#
#    das hier geht noch nicht sauger - siehe referenz mail von hvb mit attachments - die umlaute passen auch nicht
#    Content-Type: text/plain; charset="iso-8859-1"
#    Content-Transfer-Encoding: quoted-printable
#
# --------------------------------------- LIBRARIES --------------------------------------------------

use strict;
use CGI qw(:standard);
use warnings;
use Net::POP3;
# use MIME::Base64;
use MIME::Base64 qw( decode_base64 );


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
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Utility.pm';

# --------------------------------------- PARAMETER --------------------------------------------------

my $mailId = "";
if (defined   param("id")   ){   $mailId = param("id");  };

# --------------------------------------- VARIABLES --------------------------------------------------
my @arr;
my $path;
my $pathAttachments;
my $sourceFile;
my $fileHtml;
my $fileText;
my $datei;
my $DIR;
# --------------------------------------- OTHER ---------------------------------------------------------

# --------------------------------------- OBJECTS------------------------------------------------------
my $parser = MailParser2010->new();
my $objConfig = PageConfig->new();
my $objMailBusinessLayer = MailBusinessLayer->new();
# --------------------------------------- PROGRAM ----------------------------------------------------


if($@) { 
	print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
	print "Error in ajaxLoadMail.pl - evaluating objects: $@"; 
}else{
	# do not delete next line - it's a ajax file...
	print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
	print "ajaxReparseMail.pl fired for id:" . $mailId;
}

# use the id and get from database the parameters

@arr = $objMailBusinessLayer->getMailById($mailId);

$path = $objConfig->mailDownloadPath();
$path .= "" .$arr[4];
$path .= "/" .$arr[5];
$path .= "/" .$arr[0];
$sourceFile = $path ."/" .$arr[7] ;
$fileHtml  = $path ."/html.html" ;
$fileText  = $path ."/text.html" ;
$pathAttachments = $path ."/attachments";


# --------------------------------------------------------------------------
# GET DATA FROM DATABASE

my $objDAL = DataAccessLayer->new();
$objDAL->setModul('mail');
my $sqlDAL;	
$sqlDAL = "SELECT  folder_name FROM mail WHERE id =" . $mailId;
my @arrDAL;
@arrDAL = $objDAL->getOneLineArray($sqlDAL);
my $tmpUID = $arrDAL [0];

# -------------------------------------------------------------------------
# DELETE OLD FILES

my $sourceFilePath = $path ."/";

# delete the HTML file
if(-e $fileHtml){
	unlink($fileHtml);
	print "deleted = " . $fileHtml . "... ";
}

# delete the text file
if(-e $fileText ){
	unlink($fileText );
	print "deleted = " . $fileText  . "... ";
}
# delete the files in attachment folder if exists
if(-e $pathAttachments){
	print "attachment folder existst... ";

	   opendir($DIR, $pathAttachments);
	   while($datei = readdir($DIR)) { 	
		if($datei ne "." && $datei ne ".."){
		   	#print  $pathAttachments . "/" . $datei ;
			if(-e $pathAttachments . "/" . $datei){
				unlink($pathAttachments . "/" . $datei);
				print "deleted = " . $pathAttachments . "/" . $datei . "... ";
			}
		}
	   }
	   closedir($DIR);
}else{
	print "attachment folder does not existst...";
}

# ---------------------------------------------------------------------------------------------
# PARSE FILE

$parser->loadMail($sourceFilePath, $tmpUID, "txt");

print "... END OF PARSING ...";

# ---------------------------------------------------------------------------------------------
# SAVING THE FILES

my $fileHandle;

open($fileHandle, "> ".$sourceFilePath ."/html.html");						
print $fileHandle $parser->getHtml(); 
close $fileHandle;

open($fileHandle, "> ".$sourceFilePath ."/text.html");						
print $fileHandle $parser->getText(); 
close $fileHandle;

# ---------------------------------------------------------------------------------------------
# regixster the attachments in the database
# first we need to delete the existing entries for this mail id - with a delete statmeent delete * frim xxx where... aber nur wenn die ID nicht leet oder * sind


$objMailBusinessLayer->unRegisterAttachment($mailId, "", "", "", ""); 


my @attachmentLocalName = $parser->getFileNamesServer();
my @attachmentOriginalName = $parser->getFileNamesDescription();
my @attachmentType = $parser->getFileTypes();
my @attachmentSize = $parser->getFileSizes();
my $attachmentMax = $#attachmentLocalName;

# add each file
for $attachmentMax  (0.. $#attachmentLocalName){
	print " adding attachment " . $attachmentMax . " ... ";
	$objMailBusinessLayer->registerAttachment($mailId, $attachmentLocalName[$attachmentMax], $attachmentOriginalName[$attachmentMax], $attachmentType[$attachmentMax], $attachmentSize[$attachmentMax]);
}

# update from, to, subject, date... ToDo  ToDo  ToDo  ToDo  ToDo  ToDo  !!!!!!!!!!!!!!!!!!!!1




# END OF SCRIPT EXECUTION

# ====================================================================================
# ====================================================================================
# ====================================================================================
# ====================================================================================
# ====================================================================================
# ====================================================================================
# --------------------------------------- CLASS ----------------------------------------------------

package MailParser2010;

use MIME::Base64 qw( decode_base64 );

# -------------------------------------------------------------------------------------------------------
# constructor
# -------------------------------------------------------------------------------------------------------

sub new {
	my ($class) = @_;
	my $self =
	{ 
		_content => '', 
		_from => "",
		_to => "", 
		_subject => '', 
		_contentType => 'text/plain', 
		_text => '', 
		_text_encoding => '', 
		_html => '' , 
		_html_encoding => '' , 
		_mainBoundary => '',
		_attachment => "", 
		_date_received => "", 
		_date => "",
		_attachmentCounter => 0,
		_lastHeaderStuff => 'unknown',
		_updir => '',
		_fileName => '',
		_fileContent => '',
		_arrCounter => 0,
		_tmpEncoding => '',   # encoding of sub elements

		_contentFlag => 0,
		_allBoundariesString  => '',
		_recordingStatus => '',
		_tempContentType => '',
		_tmpEncoding  => '',
		_recordingStatus => '',
		_isAttachment => '',
		_mainEncoding => '',
		_isContent => ''
	};

	$self->{attachmentFiles}  = [];	
	$self->{attachmentDescription}  = [];
	$self->{attachmentFileTypes}  = [];
	$self->{attachmentFileSize}  = [];
	$self->{allBoundaries}  = [];

	bless $self, $class;
	return $self;
}


# -------------------------------------------------------------------------------------------------------
# Mail anhand von file laden und die einzelnen variablen fuellen
# -------------------------------------------------------------------------------------------------------

sub loadMail(){
	my ( $self, $filePath, $uid, $type ) = @_;
	my $datei;  			# handler for the file
	my $attachment;
	my @parameter;
	my $contentFlag = 0;   	# flag to see if the current line is content or header
	my $boundary;
	my @allBoundaries = ();
	my $allBoundariesString = '';
	my $recordingStatus = 'off';
	my $tempContentType;
	my $tmpEncoding;
	my $isAttachment;
	my $isContent = 0;
	my $fileName;
	my $fileContent = "";
	my $fileType;
	my $tmp;
	my $zeileOriginal;
	my $lastHeaderStuff;
	my $contentPath;
	my $boundaryTest;	
	my $temporaryLocalFileName;

	$self->{_updir} = $filePath . 'attachments' ;

	# random string for attachment files
	my $randomAttName;
	my $util = Utility->new();
	$randomAttName = $util->getRandomString(20);

		
	$contentPath = $filePath . $uid . "." . $type;
	# first open the file and read line by line from it

	if(-e $contentPath){
		print "EXISTS";
	}else{
		print "PROBLEM: " . $contentPath;
	}

	open($datei, "< $contentPath");

	# zeilenweise durch file gehen und am doppelpunt splitten
	while (my $zeile = <$datei>){

		# remove line endings
		$zeileOriginal = $zeile;
		chomp($zeile);

		# if the line is empty then we arrived at a line that indicates the end of the header
		if ($zeile eq ''){
			$self->{_contentFlag} = 1;   # this one is never reset to 0 !!!
			$self->processBody($zeile);
		}else{
			if ($self->{_contentFlag} == 0){
				# process the header
				$self->processHeaderLine($zeile);
			}else{
				# process the body
				$self->processBody($zeile);
			}
		}	
	} # while loop reading the file
	close($datei);
}

# -------------------------------------------------------------------------------------------------------
# process a line of the header
# -------------------------------------------------------------------------------------------------------
sub processHeaderLine{
	my ( $self, $zeile) = @_;
	my $boundary;
	my @parameter;

		# ===  HEADER =================================================
		# find all parameters of the header
		# $self->{_lastHeaderStuff}
			
		# add to existing paramters if the new line start with nothing			

		if($self->{_lastHeaderStuff} eq "to" && substr($zeile ,0, 1) eq ' ' ){
			$self->{_to} .= $zeile;
		}

		if($self->{_lastHeaderStuff} eq "to" && substr($zeile ,0, 1) eq '	' ){
			$self->{_to} .= $zeile;
		}

		if($self->{_lastHeaderStuff} eq "from" && substr($zeile ,0, 1) eq ' ' ){
			$self->{_from} .= $zeile;
		}

		if($self->{_lastHeaderStuff} eq "from" && substr($zeile ,0, 1) eq '	' ){
			$self->{_from} .= $zeile;
		}

		if($self->{_lastHeaderStuff} eq "subject" && substr($zeile ,0, 1) eq 	'	' ){
			$self->{_subject} .= $zeile;
		}

		if($self->{_lastHeaderStuff} eq "subject" && substr($zeile ,0, 1) eq ' ' ){
			$self->{_subject} .= $zeile;
		}	
			
		# fill the header fields
		if ($zeile =~ m/:/  ){
			
			@parameter = (split(":", $zeile ));
			#if($parameter[0] eq "From"){
			if($zeile =~ m/^From:\s+(.*)/i){
				$zeile =~ s/\AFrom://i;
				$self->{_from} = $zeile;
				$self->{_lastHeaderStuff} = "from";
			}

			#if($parameter[0] eq "To"){
			elsif($zeile =~ m/^To:\s+(.*)/i){
				$zeile =~ s/\ATo://i;
				$self->{_to} = $zeile;
				$self->{_lastHeaderStuff} = "to";
			}

			#if($parameter[0] eq "Subject"){
			elsif($zeile =~ m/^Subject:\s+(.*)/i){
				$zeile =~ s/\ASubject://i;
				$self->{_subject} = $zeile;
				$self->{_lastHeaderStuff} = "subject";
			}

			#   if /^Date:\s+(.*)/i;
			elsif($zeile =~ m/^Date:\s+(.*)/i){
				$zeile =~ s/\ADate://i;
				$self->{_date} = $zeile;
				$self->{_lastHeaderStuff} = "date";
			}
			
			# content type
			# Content-Type: text/html; charset=iso-8859-1
			# elsif($parameter[0] eq "Content-Type"){
			elsif($zeile =~ m/^Content-Type:\s+(.*)/i){
				print "CONTENT-TYPE: " . $zeile;
				$zeile =~ s/\AContent-Type://i;
				$zeile =~ s/;//g;
				if ($zeile ne ''){				
					$self->{_contentType} = $zeile;
				}
				$self->{_lastHeaderStuff} = "contenttype";
			}else{
				$self->{_lastHeaderStuff} = "unknown";
			}		
			
		}else{
			# if the line is not starting with empty stuff and does not contain a : then we need to reset the last header stuff
			# this function did not exist so far in the former parser version
			if (substr($zeile ,0, 1) ne ' ' && substr($zeile ,0, 1) ne '	'){	
				$self->{_lastHeaderStuff} = "unknown";
			}
		}

		# === BOUNDARY =================================================
		# get main boundary 

		if ($zeile =~ m/boundary/i  && $self->{_contentFlag} == 0){
			($boundary) = $zeile =~ m/"(.*)"/;
			if(($boundary) ne ''){
				$self->{_mainBoundary} = ($boundary);
				$self->{allBoundaries}[0] = ($boundary);
				$self->{_allBoundariesString} = 	($boundary);
				$self->{_lastHeaderStuff} = "boundary";
			}else{
				@parameter = (split("boundary=", $zeile ));
				$self->{_mainBoundary} = $parameter[1];
				$self->{allBoundaries}[0] = $parameter[1];
				$self->{_allBoundariesString} = 	$parameter[1];
				$self->{_lastHeaderStuff} = "boundary";
			}

		}

		# ==== GET NEW and additional stuff from header - not done so far !!!

		#Content-Type: text/html; charset=iso-8859-1
		#Content-Transfer-Encoding: quoted-printable
		# Content-Transfer-Encoding: base64

		if ($zeile =~ m/Content-Transfer-Encoding/i  && $self->{_contentFlag} == 0){
			if($zeile =~ m/base64/i){
				$self->{_mainEncoding} = "base64";
				print "... is base64...";
			}else{
				$self->{_mainEncoding} = "";
			}
		}


};

# -------------------------------------------------------------------------------------------------------
# process the body - entry in sub structure
# PROBLEM - does not differe between encoding base 64 and other
# this is the readon why hubbsi mails are not processed correctly
# I assume that if encodede base 64 we should first transform the mail within a
# interim step
# -------------------------------------------------------------------------------------------------------
sub processBody{
	my ($self, $zeileOriginal) = @_;

	# distinguish between the different mail types

	#print "CONTENT-TYPE FOR PROCESSING: " . $self->{_contentType};


	# simple mail simple process
	if ($self->{_contentType} =~ m/text\/plain/){
		$self->processBodyTextMail($zeileOriginal);
	}
	# simple html mail
	elsif($self->{_contentType} =~ m/text\/html/){
		$self->processBodyHtmlMail($zeileOriginal);
	}
	# multipart/alternative mail
	elsif($self->{_contentType} =~ m/multipart\/alternative/ ){
		#print "moltipart-alternative...";
		$self->processBodyMultipartAlternativeMail($zeileOriginal);
	}
	# multipart/mixed mail
	elsif($self->{_contentType} =~ m/multipart\/mixed/ ){
		$self->processBodyMultipartMixedOrRelatedMail($zeileOriginal);
	}
	# multipart/related mail
	elsif($self->{_contentType} =~ m/multipart\/related/ ){
		$self->processBodyMultipartMixedOrRelatedMail($zeileOriginal);
	}else{
		# all other cases
		$self->processBodyMultipartMixedOrRelatedMail($zeileOriginal);
	}			
};

# -------------------------------------------------------------------------------------------------------
# process body - plain text mail
# -------------------------------------------------------------------------------------------------------
sub processBodyTextMail{
	my ($self, $line) = @_;
	$self->{_text} .= $line  . "\n";	;	
};

# -------------------------------------------------------------------------------------------------------
# process body - pure html mail
# -------------------------------------------------------------------------------------------------------
sub processBodyHtmlMail{
	my ($self, $line) = @_;
	$self->{_html} .= $line . "\n";	
};

# -------------------------------------------------------------------------------------------------------
# process body - multipart alternative
# -------------------------------------------------------------------------------------------------------
sub processBodyMultipartAlternativeMail{
	my ($self, $zeile) = @_;

	# process the content here
	#wenn boundary erreicht wird dann reset variablen
	# die variablen müssen hier so sein dass sie von der klasse sind und sons nix..,..

	#print "in processBodyMultipartAlternativeMail: " . $zeile;

	print "status: " . $self->{_recordingStatus} . "...";
	
	if ($zeile eq '--' . $self->{_mainBoundary}  ){
		$self->{_recordingStatus} = 'head';	
	}

	#ende des heads erreicht - jetzt kommt ocntent
	if ($zeile eq '' && $self->{_recordingStatus} eq 'head'){
		$self->{_recordingStatus} = 'record';
	}

	#untersuche header
	if ($self->{_recordingStatus} eq 'head'){
		if ($zeile =~ m/Content-Type/i){
			$zeile =~ s/\AContent-Type://i;
			$zeile =~ s/;//g;				
			$self->{_tempContentType} = $zeile;						
		}
		# encoding base64
		if ($zeile =~ m/base64/i  ){
			$self->{_tmpEncoding} = "base64";
		}
	}

	if ($self->{_recordingStatus} eq 'record'){
		print "recording...";
		if ($zeile ne '--' . $self->{_mainBoundary} . '--'){	
			
			if ($self->{_tempContentType} =~ m/text\/plain/){
				$self->{_text} .= $zeile . "\n\r";
				if($self->{_tmpEncoding} eq 'base64'){
					$self->{_text_encoding} = 'base64';
				}	
			}
			
			if ($self->{_tempContentType} =~ m/text\/html/){
				$self->{_html} .= $zeile . "\n\r";
				if($self->{_tmpEncoding} eq 'base64'){
					$self->{_html_encoding} = 'base64';
				}	
			}
		}	
	} 

	# print $zeile;
	# print $self->{_recordingStatus};
};


# -------------------------------------------------------------------------------------------------------
# process body - multipart related
# -------------------------------------------------------------------------------------------------------
sub processBodyMultipartMixedOrRelatedMail{
	my ($self, $zeile) = @_;
	my $boundaryTest;
	my $fileType;
	my $randomAttName;
	my $temporaryLocalFileName;
	my $attachment;
	my $boundary;

	# bei jedem boundary cut und analyse des headers
		
	my $zeilePart = $zeile;
	$zeilePart = substr ($zeilePart, 2);
	$zeilePart = substr ($zeilePart, -102,100);
	
	$zeilePart =~ s/\(//g;
	$zeilePart =~ s/\)//g;
	$zeilePart =~ s/\*//g;
	$zeilePart =~ s/\.//g;
	$zeilePart =~ s/\+//g;
	$zeilePart =~ s/\<//g;
	$zeilePart =~ s/\>//g;
	$zeilePart =~ s/\]//g;
	$zeilePart =~ s/\[//g;
	$zeilePart =~ s/-//g;
		
	$boundaryTest = $self->{_allBoundariesString};

	$boundaryTest =~ s/\(//g;
	$boundaryTest =~ s/\)//g;
	$boundaryTest =~ s/\*//g;
	$boundaryTest =~ s/\.//g;
	$boundaryTest =~ s/\+//g;
	$boundaryTest =~ s/\<//g;
	$boundaryTest =~ s/\>//g;
	$boundaryTest =~ s/\]//g;
	$boundaryTest =~ s/\[//g;
	$boundaryTest =~ s/-//g;
		
	# if boundary then save content recorded so far
	if ($boundaryTest =~ m/$zeilePart/ ){
	
		print "... important line...: " . $zeile;
		print "FILENAME zum speichern: " . $self->{_fileName};

		if($self->{_updir} eq ''){
			print "...directory empty...";
		}
		if($self->{_fileName} eq ''){
			print "...file name empty...";
		}else{
			print "...file name available...";
		}
		if($self->{_fileContent} eq ''){
			print "...content empty...";
		}else{
			print "...content available...";
		}

		if($self->{_updir} ne '' && $self->{_fileName} ne '' & $self->{_fileContent} ne ''){
			# wenn attachment content da und so dann speichern
			$self->{_fileName} = $self->cleanFileName($self->{_fileName}); 
			#print $self->{_fileName};
			$fileType = $self->getFileType($self->{_fileName});

			#increase the file counter
			$self->{_attachmentCounter} = $self->{_attachmentCounter} + 1;

			$temporaryLocalFileName = "attachment-" . $randomAttName . "-" . $self->{_attachmentCounter} . ".dat";

			print "SAVING THE FILE: " . $temporaryLocalFileName;

			# save the file
			open($attachment, "> ".$self->{_updir}."/" . $temporaryLocalFileName) or die (print "cant open file");								
			print $attachment decode_base64($self->{_fileContent} ); 
			close $attachment;

			# register the file size
			# put the data into the array
			$self->addAttachment($temporaryLocalFileName, $self->{_fileName}, $fileType, $self->getFileSize($self->{_updir}."/" . $temporaryLocalFileName));

			$self->{fileContent}  = '';
			$self->{_fileName} = '';
		}
		
		$self->{_recordingStatus} = 'head';
		$self->{_tmpEncoding} = "";                                        
		$self->{_isAttachment} = 0;
		$self->{_isContent} = 1;					
	}							
	
	# wenn recordingstatus head dann headerinfos aufzeichnen
	if ($self->{_recordingStatus} eq 'head'){
		if ($zeile =~ m/Content-Type/i){
			$zeile =~ s/\AContent-Type://i;
			$zeile =~ s/;//g;				
			$self->{_tempContentType} = $zeile;	
			$self->{_lastHeaderStuff} = "contenttype";
		}
		
		# Content-Disposition: attachment;
		#if ($zeile =~ m/Content-Disposition/i){
			if($zeile =~ m/attachment/i){
				$self->{_isAttachment} = 1;
				# print "\n isAttachment " . $isAttachment . "\n "
				$self->{_lastHeaderStuff} = "contentdisposition";
			}

			if($zeile =~ m/inline/i){
				$self->{_isAttachment} = 1;
				# print "\n isAttachment " . $isAttachment . "\n "
				$self->{_lastHeaderStuff} = "attachment";
			}
		#}
					               

		# wenn bounday dann kein content dafuer boundary erweitern
		if ($zeile =~ m/boundary/i){	
			($boundary) = $zeile =~ m/"(.*)"/;	
			if(($boundary) eq ""){
				($boundary) = $zeile =~ m/boundary=(.*)/;
			}
			print "... added boundary " . ($boundary) . " ... ";
			$self->{_allBoundariesString} .= ($boundary);	
			$self->{_isContent} = 0;	
			$self->{_lastHeaderStuff} = "boundary";
		}
		#  filename bei attachments
		if ($zeile =~ m/name=/i  ){	
			$self->{_fileName} = $self->cleanFileName($zeile);
			print "...file name is set to..." . $self->{_fileName}; 
			$self->{_html} .= $zeile;	  
			$self->{_text} .= $zeile;	 
			$self->{_lastHeaderStuff} = "filename";
		}

		# encoding base64
		if ($zeile =~ m/base64/i  ){
			print "...mixed stuff is base64...";
			$self->{_tmpEncoding} = "base64";
			$self->{_lastHeaderStuff} = "encoding";
		} # set recoding type
			
	}
	
	#ende des heads erreicht - jetzt kommt content
	if ($zeile eq '' && $self->{_recordingStatus} eq 'head' && $self->{_isContent} == 1){
		$self->{_recordingStatus} = 'record';
	} # enable recording
			
	# zeichne content auf
	if ($self->{_recordingStatus} eq 'record' && $self->{_isAttachment} == 0){
		if ($self->{_recordingStatus} =~ m/text\/plain/){
			if($self->{_tmpEncoding} eq "base64"){
				$self->{_text_encoding} = 'base64';
			}
			$self->{_text} .= $zeile . "\n";				
		}
		if ($self->{_tempContentType} =~ m/text\/html/){
			if($self->{_tmpEncoding} eq "base64"){
				$self->{_html_encoding} = 'base64';
			}
			$self->{_html} .= $zeile  . "\n";	
		}
	} # record text and html
			
	# speichere attachments
	if ($self->{_recordingStatus} eq 'record' && $self->{_isAttachment} == 1){

		if(-e $self->{_updir}) { 
		   #print $updir ." datei existiert\n" 
		}else { 
		   # print $updir ." folder existiert nicht \n";
		   mkdir($self->{_updir},0777);					
		};
		#sammle attachmentcontent
		if(defined $zeile){
			#print ". "; 
			$self->{_fileContent} .= $zeile;
		}
	} # record attachments

}

# ========================================================
#
#     alle weiteren methoden geben nur die variablen zurueck !!!!!!
#
# ========================================================
# ========================================================
# ========================================================


# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------
# alle weiteren methoden geben nur die variablen zurueck
sub getFrom{
	my ($self) = @_;
	return $self->{_from};
};

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub getTo{
	my ($self) = @_;
	return $self->{_to};
};

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub getSubject{
	my ($self) = @_;
	return $self->{_subject};
};

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub getDate{
	my ($self) = @_;
	return $self->{_date};
};

# ============================================================================================
sub getContentType{
	my ($self) = @_;
	return $self->{_contentType};
};

# ============================================================================================
sub getText{
	my ($self) = @_;
	my $temp;
		
	if ($self->{_text_encoding} eq 'base64'){
		$temp = decode_base64($self->{_text});
		return $self->cleanCode($temp );
	}elsif($self->{_mainEncoding} eq 'base64'){
		$temp = decode_base64($self->{_text});
		return $self->cleanCode($temp);
	}else{
		return $self->cleanCode($self->{_text});
	}
};

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub getHtml{
	my ($self) = @_;
	my $temp;
	if ($self->{_html_encoding} eq 'base64'){
		$temp = decode_base64($self->{_html});
		return $self->cleanCode($temp);
	}elsif($self->{_mainEncoding} eq 'base64'){
		$temp = decode_base64($self->{_html});
		return $self->cleanCode($temp);
	}else{
		return $self->cleanCode($self->{_html});
	}
};

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------
sub getMainBoundary{
	my ($self) = @_;
	return $self->{_mainBoundary};
};

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub cleanCode{
	my ($self, $string) = @_;
	my $tmpThreeCharacters;
	my $ret = "";
	my $tmp;
	my $i = 0;
	my $lengthBefore;
	my $lengthAfter;
	my $lengthDiff;
	my $continue = "1";
	my $c;

	#first try to replace standard returns

			$c = "=" . chr(13) . chr(10);
	$string =~ s/$c//gi;
				$c = "=" . chr(10) . chr(13);
	$string =~ s/$c//gi;
				$c = "=" . chr(13);
	$string =~ s/$c//gi;
			$c = "=" . chr(10);
	$string =~ s/$c//gi;
	$c = "=" . chr(32);
	$string =~ s/$c//gi; 

	# special stuff added 20.8.2009
			$c = "=E2=80=99";
	$string =~ s/$c/'/gi;
	$string =~ s/=E2=82=AC/£/gi;
	$string =~ s/=C2=BB/»/gi;

	
	while($continue eq "1"){
	
		$tmpThreeCharacters = substr($string, $i, 3);
		$lengthBefore = length($tmpThreeCharacters);
	
		if($lengthBefore == 0){
			$continue =  "0" ;
		}
		
		$tmp = $self->cleanCodeThreeCharacters($tmpThreeCharacters);
		$lengthAfter = length($tmp);
		$lengthDiff = $lengthBefore - $lengthAfter + 1;
		$i = $i + $lengthDiff;
		
		$ret .= substr($tmp, 0, 1);
	}
	return $ret;
}

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub cleanCodeThreeCharacters{
	my ($self, $string) = @_;

	$string =~ s/=3D/=/gi;
	$string =~ s/=2E/\./gi;

	$string =~ s/=\n\r//gi;
	$string =~ s/=\r\n//gi;

	
	#$string =~ s/=\r//gi;
	#$string =~ s/=\n//gi;

	$string =~ s/=0D/\n/gi;
	$string =~ s/=FC/ü/gi;
	#$string =~ s/=20\n//gi;
			# =20

	$string =~ s/=00//gi;
	$string =~ s/=01//gi;
	$string =~ s/=02//gi;
	$string =~ s/=03//gi;
	$string =~ s/=04//gi;
	$string =~ s/=05//gi;
	$string =~ s/=06//gi;
	$string =~ s/=07//gi;
	$string =~ s/=08//gi;
	$string =~ s/=09//gi;
	$string =~ s/=0A/\n/gi;
	$string =~ s/=0B//gi;
	$string =~ s/=0C//gi;
	$string =~ s/=0D//gi;
	$string =~ s/=0E//gi;
	$string =~ s/=0F//gi;
	$string =~ s/=10//gi;
	$string =~ s/=11//gi;
	$string =~ s/=12//gi;
	$string =~ s/=13//gi;
	$string =~ s/=14//gi;
	$string =~ s/=15//gi;
	$string =~ s/=16//gi;
	$string =~ s/=17//gi;
	$string =~ s/=18//gi;
	$string =~ s/=19//gi;
	$string =~ s/=1A//gi;
	$string =~ s/=1B//gi;
	$string =~ s/=1C//gi;
	$string =~ s/=1D//gi;
	$string =~ s/=1E//gi;
	$string =~ s/=1F//gi;
	$string =~ s/=20/ /gi;
	$string =~ s/=21/\!/gi;
	$string =~ s/=22/"/gi;
	$string =~ s/=23/#/gi;
	$string =~ s/=24/\$/gi;
	$string =~ s/=25/%/gi;
	$string =~ s/=26/&/gi;
	$string =~ s/=27/'/gi;
	$string =~ s/=28/\(/gi;
	$string =~ s/=29/\)/gi;
	$string =~ s/=2A/\*/gi;
	$string =~ s/=2B/\+/gi;
	$string =~ s/=2C/,/gi;
	$string =~ s/=2D/-/gi;
	$string =~ s/=2E/\./gi;
	$string =~ s/=2F/\//gi;
	$string =~ s/=30/0/gi;
	$string =~ s/=31/1/gi;
	$string =~ s/=32/2/gi;
	$string =~ s/=33/3/gi;
	$string =~ s/=34/4/gi;
	$string =~ s/=35/5/gi;
	$string =~ s/=36/6/gi;
	$string =~ s/=37/7/gi;
	$string =~ s/=38/8/gi;
	$string =~ s/=39/9/gi;
	$string =~ s/=3A/:/gi;
	$string =~ s/=3B/;/gi;
	$string =~ s/=3C/</gi;
	$string =~ s/=3D/=/gi;
	$string =~ s/=3E/>/gi;
	$string =~ s/=3F/\?/gi;
	$string =~ s/=40/\@/gi;
	$string =~ s/=41/A/gi;
	$string =~ s/=42/B/gi;
	$string =~ s/=43/C/gi;
	$string =~ s/=44/D/gi;
	$string =~ s/=45/E/gi;
	$string =~ s/=46/F/gi;
	$string =~ s/=47/G/gi;
	$string =~ s/=48/H/gi;
	$string =~ s/=49/I/gi;
	$string =~ s/=4A/J/gi;
	$string =~ s/=4B/K/gi;
	$string =~ s/=4C/L/gi;
	$string =~ s/=4D/M/gi;
	$string =~ s/=4E/N/gi;
	$string =~ s/=4F/O/gi;
	$string =~ s/=50/P/gi;
	$string =~ s/=51/Q/gi;
	$string =~ s/=52/R/gi;
	$string =~ s/=53/S/gi;
	$string =~ s/=54/T/gi;
	$string =~ s/=55/U/gi;
	$string =~ s/=56/V/gi;
	$string =~ s/=57/W/gi;
	$string =~ s/=58/X/gi;
	$string =~ s/=59/Y/gi;
	$string =~ s/=5A/Z/gi;
	$string =~ s/=5B/\[/gi;
	$string =~ s/=5C/\\/gi;
	$string =~ s/=5D/\]/gi;
	$string =~ s/=5E/\^/gi;
	$string =~ s/=5F/_/gi;
	$string =~ s/=60/`/gi;
	$string =~ s/=61/a/gi;
	$string =~ s/=62/b/gi;
	$string =~ s/=63/c/gi;
	$string =~ s/=64/d/gi;
	$string =~ s/=65/e/gi;
	$string =~ s/=66/f/gi;
	$string =~ s/=67/g/gi;
	$string =~ s/=68/h/gi;
	$string =~ s/=69/i/gi;
	$string =~ s/=6A/j/gi;
	$string =~ s/=6B/k/gi;
	$string =~ s/=6C/l/gi;
	$string =~ s/=6D/m/gi;
	$string =~ s/=6E/n/gi;
	$string =~ s/=6F/o/gi;
	$string =~ s/=70/p/gi;
	$string =~ s/=71/q/gi;
	$string =~ s/=72/r/gi;
	$string =~ s/=73/s/gi;
	$string =~ s/=74/t/gi;
	$string =~ s/=75/u/gi;
	$string =~ s/=76/v/gi;
	$string =~ s/=77/w/gi;
	$string =~ s/=78/x/gi;
	$string =~ s/=79/y/gi;
	$string =~ s/=7A/z/gi;
	$string =~ s/=7B/\{/gi;
	$string =~ s/=7C/\|/gi;
	$string =~ s/=7D/\}/gi;
	$string =~ s/=7E/\~/gi;
	$string =~ s/=7F//gi;
	$string =~ s/=80/?/gi;
	$string =~ s/=81/0/gi;
	$string =~ s/=82/0/gi;
	$string =~ s/=83/0/gi;
	$string =~ s/=84/0/gi;
	$string =~ s/=85/0/gi;
	$string =~ s/=86/0/gi;
	$string =~ s/=87/0/gi;
	$string =~ s/=88/0/gi;
	$string =~ s/=89/0/gi;
	$string =~ s/=8A/0/gi;
	$string =~ s/=8B/0/gi;
	$string =~ s/=8C/0/gi;
	$string =~ s/=8D/0/gi;
	$string =~ s/=8E/0/gi;
	$string =~ s/=8F/0/gi;
	$string =~ s/=90/0/gi;

	$string =~ s/=91/?/gi;
			$string =~ s/=92/?/gi;
	$string =~ s/=93/?/gi;
	$string =~ s/=94/?/gi;
	$string =~ s/=95/?/gi;
	$string =~ s/=96/?/gi;
	$string =~ s/=97/?/gi;
	$string =~ s/=98/?/gi;
	$string =~ s/=99/?/gi;
	$string =~ s/=9A/?/gi;
	$string =~ s/=9B/?/gi;
	$string =~ s/=9C/?/gi;
	$string =~ s/=9D/?/gi;
	$string =~ s/=9E/?/gi;
	$string =~ s/=9F/?/gi;

	$string =~ s/=A0/ /gi;
	$string =~ s/=A1/¡/gi;
	$string =~ s/=A2/¢/gi;
	$string =~ s/=A3/£/gi;
	$string =~ s/=A4/¤/gi;
	$string =~ s/=A5/¥/gi;
	$string =~ s/=A6/¦/gi;
	$string =~ s/=A7/§/gi;
	$string =~ s/=A8/¨/gi;
	$string =~ s/=A9/©/gi;
	$string =~ s/=AA/ª/gi;
	$string =~ s/=AB/«/gi;
	$string =~ s/=AC/¬/gi;
	$string =~ s/=AD/­/gi;
	$string =~ s/=AE/®/gi;
	$string =~ s/=AF/¯/gi;
	$string =~ s/=B0/°/gi;
	$string =~ s/=B1/±/gi;
	$string =~ s/=B2/²/gi;
	$string =~ s/=B3/³/gi;
	$string =~ s/=B4/´/gi;
	$string =~ s/=B5/µ/gi;
	$string =~ s/=B6/¶/gi;
	$string =~ s/=B7/·/gi;
	$string =~ s/=B8/¸/gi;
	$string =~ s/=B9/¹/gi;
	$string =~ s/=BA/º/gi;
	$string =~ s/=BB/»/gi;
	$string =~ s/=BC/¼/gi;
	$string =~ s/=BD/½/gi;
	$string =~ s/=BE/¾/gi;
	$string =~ s/=BF/¿/gi;
	$string =~ s/=C0/À/gi;
	$string =~ s/=C1/Á/gi;
	$string =~ s/=C2/Â/gi;
	$string =~ s/=C3/Ã/gi;
	$string =~ s/=C4/Ä/gi;
	$string =~ s/=C5/Å/gi;
	$string =~ s/=C6/Æ/gi;
	$string =~ s/=C7/Ç/gi;
	$string =~ s/=C8/È/gi;
	$string =~ s/=C9/É/gi;
	$string =~ s/=CA/Ê/gi;
	$string =~ s/=CB/Ë/gi;
	$string =~ s/=CC/Ì/gi;
	$string =~ s/=CD/Í/gi;
	$string =~ s/=CE/Î/gi;
	$string =~ s/=CF/Ï/gi;
	$string =~ s/=D0/Ð/gi;
	$string =~ s/=D1/Ñ/gi;
	$string =~ s/=D2/Ò/gi;
	$string =~ s/=D3/Ó/gi;
	$string =~ s/=D4/Ô/gi;
	$string =~ s/=D5/Õ/gi;
	$string =~ s/=D6/Ö/gi;
	$string =~ s/=D7/×/gi;
	$string =~ s/=D8/Ø/gi;
	$string =~ s/=D9/Ù/gi;
	$string =~ s/=DA/Ú/gi;
	$string =~ s/=DB/Û/gi;
	$string =~ s/=DC/Ü/gi;
	$string =~ s/=DD/Ý/gi;
	$string =~ s/=DE/Þ/gi;
	$string =~ s/=DF/ß/gi;
	$string =~ s/=E0/à/gi;
	$string =~ s/=E1/á/gi;
	$string =~ s/=E2/â/gi;
	$string =~ s/=E3/ã/gi;
	$string =~ s/=E4/ä/gi;
	$string =~ s/=E5/å/gi;
	$string =~ s/=E6/æ/gi;
	$string =~ s/=E7/ç/gi;
	$string =~ s/=E8/è/gi;
	$string =~ s/=E9/é/gi;
	$string =~ s/=EA/ê/gi;
	$string =~ s/=EB/ë/gi;
	$string =~ s/=EC/ì/gi;
	$string =~ s/=ED/í/gi;
	$string =~ s/=EE/î/gi;
	$string =~ s/=EF/ï/gi;
	$string =~ s/=F0/ð/gi;
	$string =~ s/=F1/ñ/gi;
	$string =~ s/=F2/ò/gi;
	$string =~ s/=F3/ó/gi;
	$string =~ s/=F4/ô/gi;
	$string =~ s/=F5/õ/gi;
	$string =~ s/=F6/ö/gi;
	$string =~ s/=F7/÷/gi;
	$string =~ s/=F8/ø/gi;
	$string =~ s/=F9/ù/gi;
	$string =~ s/=FA/ú/gi;
	$string =~ s/=FB/û/gi;
	$string =~ s/=FC/ü/gi;

	return $string;
}

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub cleanFromToSubject{
	my ($self, $string) = @_;
	$string =~ s/=3D/=/gi;
	$string =~ s/=2E/\./gi;
	$string =~ s/=\n//gi;

	
	$string =~ s/"//gi;

	$string = $self->specialReplacements('=\?iso-8859-15\?Q\?','\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?ISO-8859-15\?Q\?','\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?ISO-8859-15\?B\?','\?=',$string, 'B');
	$string = $self->specialReplacements('=\?ISO-8859-1\?Q\?=22','=22\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?iso-8859-1\?Q\?','\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?ISO-8859-1\?Q\?','\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?windows-1252\?Q\?','\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?utf-8\?B\?','\?=',$string, 'B');
	$string = $self->specialReplacements('=\?UTF-8\?Q\?','\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?iso-8859-1\?B\?','\?=',$string, 'B');
	$string = $self->specialReplacements('=\?WINDOWS-1250\?Q\?','\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?windows-1251\?B\?','\?=',$string, 'B');
	$string = $self->specialReplacements('=\?unicode-1-1-utf-7\?Q\?','\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?koi8-r\?B\?','\?=',$string, 'B');
	$string = $self->specialReplacements('=\?Cp1252\?Q\?','\?=',$string, 'Q');


	$string =~ s/_/ /gi;   
	return $string;
}

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub cleanFileName{
	my ($self, $string) = @_;   

	my @stringArr;
	my $firstPart;
	my $lastPart ;

	$string = $self->specialReplacements('=\?iso-8859-15\?Q\?','\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?ISO-8859-15\?Q\?','\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?ISO-8859-1\?Q\?=22','=22\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?iso-8859-1\?Q\?','\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?ISO-8859-1\?Q\?','\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?windows-1252\?Q\?','\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?utf-8\?B\?','\?=',$string, 'B');
	$string = $self->specialReplacements('=\?UTF-8\?Q\?','\?=',$string, 'Q');
	$string = $self->specialReplacements('=\?Cp1252\?Q\?','\?=',$string, 'Q');


	if(index($string,"=",0) > 0 ){
		$string = substr($string,index($string,"=",0),100);
	}



	$string =~ s/=/_/gi;
	$string =~ s/'//gi;
	$string =~ s/"//gi;
	#$string =~ s/!/_/gi;   
	$string =~ s/\?/_/gi;   
	return $string;
}

# ============================================================================================
# get the file name from a longer file type by splitting it
# ============================================================================================
sub getFileType{

	my ($self, $string) = @_;   
	my @arr;
	my $x;
	my $ret = ".xxx";

	@arr = split(/\./,$string);     # Array der einzelnen Teilstrings
	$x = @arr;     # Anzahl der Elemente
	eval {$ret = $arr[$x-1]};
	return $ret;
}

# ============================================================================================
sub specialReplacements{

	my ($self, $start, $end, $string, $encoding) = @_;
	my @outerArr;
	my @innerArr;
	my $firstPart;
	my $lastPart;
	my $returnString;
	my $test;

	$returnString = "";
	

	if ($string=~ m/$start/gi){

		@outerArr = split(/$start/i, $string );

		# start of loop block
		foreach my $x (@outerArr) {

			# this part contains the stuff to encode if end is alos in it
			

			if ($x=~ m/$end/i){

				#split again - the first part needs to be decoded, the rest used undecoded
				@innerArr = split(/$end/i, $x  );

				if($encoding eq 'B'){
					$returnString .= decode_base64($innerArr[0] );
				}
				if($encoding eq 'Q'){
					$returnString .= $self->cleanHexCode($innerArr[0] );
					$returnString =~ s/_/ /gi;
				}	

				$returnString .= $innerArr[1];			

			}else{
				$returnString .= $x;
			}
		
		# end of loop block 
		}
		
	}else{
		$returnString = $string;
	}

	return $returnString;
}


# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub cleanEmail{
	my ($self, $string) = @_;
	$string =~ s/=3D/=/gi;
	$string =~ s/=2E/\./gi;
	$string =~ s/=\n//gi;
	$string =~ s/"//gi;
	$string =~ s/</[/gi;
	$string =~ s/>/]/gi;

	return $string;
}

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub stripEmail{
	my ($self, $string) = @_;
	$string =~ s/=3D/=/gi;
	$string =~ s/=2E/\./gi;
	$string =~ s/=\n//gi;
	$string =~ s/"//gi;

	my @parts;

	if($string =~ m/</){
		@parts = split(/</, $string );
		$string = $parts[1];
		$string =~ s/>//gi;
	}

	return $string;
}

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub dumpContent{
	my ($self, $string) = @_;
	$string =~ s/=3D/=/gi;
	$string =~ s/=2E/\./gi;
	$string =~ s/=\n//gi;
	$string =~ s/"//gi;
	$string =~ s/'//gi;
	return $string;
}

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub cleanHtmlBody{
	my ($self, $string) = @_;
	my $bodyPart;
	my @bodyParts;
	my $pos;


	# first cut e3verything before the body tag

	if($string =~ m/<body/i){
		@bodyParts = split(/<body/i, $string );
		$bodyPart = $bodyParts[1];
		$pos = index($bodyPart, ">");
		$pos = $pos + 1;
		$string = substr($bodyPart, $pos);
		#$string = $pos ."|" . $bodyPart ."|";
	}

	$string =~ s/<br>/<br>\n/gi;
	$string =~ s/<br >/<br >\n/gi;
	$string =~ s/<br \/>/<br \/>\n/gi;

	# then add linebreaks to relevant html tags

	$string =~ s/<(?:[^>'"]*|(['"]).*?\1)*>//gs;
	# $value =~ s/\<[^\<]+\>//g;

	$string =~ s/=0D/\n/gi;

	return $string;
}

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub deleteFilesAndFolder{
	my ($self, $path) = @_;
	my @contents;
	my $listitem;
	opendir MYDIR, $path;
	@contents = readdir MYDIR;
	closedir MYDIR;

	foreach $listitem ( @contents )
	{
		if ( -d $listitem )
		{
		#print "It's a directory!";
		}
		else
		{
		unlink "$path/$listitem"; 
		}
	}

	unlink $path; 
	return 1;
}

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub cleanHexCode{
	my ($self, $string) = @_;
	my $tmpThreeCharacters;
	my $ret = "";
	my $tmp;
	my $i = 0;
	my $lengthBefore;
	my $lengthAfter;
	my $lengthDiff;
	my $continue = "1";
	
	while($continue eq "1"){
	
		$tmpThreeCharacters = substr($string, $i, 3);
		$lengthBefore = length($tmpThreeCharacters);
	
		if($lengthBefore == 0){
			$continue =  "0" ;
		}
		
		$tmp = $self->cleanHexCodeThreeCharacters($tmpThreeCharacters);
		$lengthAfter = length($tmp);
		$lengthDiff = $lengthBefore - $lengthAfter + 1;
		$i = $i + $lengthDiff;
		
		$ret .= substr($tmp, 0, 1);
	}
	return $ret;
}

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub cleanHexCodeThreeCharacters{
	my ($self, $string) = @_;


	$string =~ s/=c3=b6/ö/gi;

	$string =~ s/=00//gi;
	$string =~ s/=01//gi;
	$string =~ s/=02//gi;
	$string =~ s/=03//gi;
	$string =~ s/=04//gi;
	$string =~ s/=05//gi;
	$string =~ s/=06//gi;
	$string =~ s/=07//gi;
	$string =~ s/=08//gi;
	$string =~ s/=09//gi;
	$string =~ s/=0A//gi;
	$string =~ s/=0B//gi;
	$string =~ s/=0C//gi;
	$string =~ s/=0D//gi;
	$string =~ s/=0E//gi;
	$string =~ s/=0F//gi;
	$string =~ s/=10//gi;
	$string =~ s/=11//gi;
	$string =~ s/=12//gi;
	$string =~ s/=13//gi;
	$string =~ s/=14//gi;
	$string =~ s/=15//gi;
	$string =~ s/=16//gi;
	$string =~ s/=17//gi;
	$string =~ s/=18//gi;
	$string =~ s/=19//gi;
	$string =~ s/=1A//gi;
	$string =~ s/=1B//gi;
	$string =~ s/=1C//gi;
	$string =~ s/=1D//gi;
	$string =~ s/=1E//gi;
	$string =~ s/=1F//gi;
	$string =~ s/=20/ /gi;
	$string =~ s/=21/\!/gi;
	$string =~ s/=22/"/gi;
	$string =~ s/=23/#/gi;
	$string =~ s/=24/\$/gi;
	$string =~ s/=25/%/gi;
	$string =~ s/=26/&/gi;
	$string =~ s/=27/'/gi;
	$string =~ s/=28/\(/gi;
	$string =~ s/=29/\)/gi;
	$string =~ s/=2A/\*/gi;
	$string =~ s/=2B/\+/gi;
	$string =~ s/=2C/,/gi;
	$string =~ s/=2D/-/gi;
	$string =~ s/=2E/\./gi;
	$string =~ s/=2F/\//gi;
	$string =~ s/=30/0/gi;
	$string =~ s/=31/1/gi;
	$string =~ s/=32/2/gi;
	$string =~ s/=33/3/gi;
	$string =~ s/=34/4/gi;
	$string =~ s/=35/5/gi;
	$string =~ s/=36/6/gi;
	$string =~ s/=37/7/gi;
	$string =~ s/=38/8/gi;
	$string =~ s/=39/9/gi;
	$string =~ s/=3A/:/gi;
	$string =~ s/=3B/;/gi;
	$string =~ s/=3C/</gi;
	$string =~ s/=3D/=/gi;
	$string =~ s/=3E/>/gi;
	$string =~ s/=3F/\?/gi;
	$string =~ s/=40/\@/gi;
	$string =~ s/=41/A/gi;
	$string =~ s/=42/B/gi;
	$string =~ s/=43/C/gi;
	$string =~ s/=44/D/gi;
	$string =~ s/=45/E/gi;
	$string =~ s/=46/F/gi;
	$string =~ s/=47/G/gi;
	$string =~ s/=48/H/gi;
	$string =~ s/=49/I/gi;
	$string =~ s/=4A/J/gi;
	$string =~ s/=4B/K/gi;
	$string =~ s/=4C/L/gi;
	$string =~ s/=4D/M/gi;
	$string =~ s/=4E/N/gi;
	$string =~ s/=4F/O/gi;
	$string =~ s/=50/P/gi;
	$string =~ s/=51/Q/gi;
	$string =~ s/=52/R/gi;
	$string =~ s/=53/S/gi;
	$string =~ s/=54/T/gi;
	$string =~ s/=55/U/gi;
	$string =~ s/=56/V/gi;
	$string =~ s/=57/W/gi;
	$string =~ s/=58/X/gi;
	$string =~ s/=59/Y/gi;
	$string =~ s/=5A/Z/gi;
	$string =~ s/=5B/\[/gi;
	$string =~ s/=5C/\\/gi;
	$string =~ s/=5D/\]/gi;
	$string =~ s/=5E/\^/gi;
	$string =~ s/=5F/_/gi;
	$string =~ s/=60/`/gi;
	$string =~ s/=61/a/gi;
	$string =~ s/=62/b/gi;
	$string =~ s/=63/c/gi;
	$string =~ s/=64/d/gi;
	$string =~ s/=65/e/gi;
	$string =~ s/=66/f/gi;
	$string =~ s/=67/g/gi;
	$string =~ s/=68/h/gi;
	$string =~ s/=69/i/gi;
	$string =~ s/=6A/j/gi;
	$string =~ s/=6B/k/gi;
	$string =~ s/=6C/l/gi;
	$string =~ s/=6D/m/gi;
	$string =~ s/=6E/n/gi;
	$string =~ s/=6F/o/gi;
	$string =~ s/=70/p/gi;
	$string =~ s/=71/q/gi;
	$string =~ s/=72/r/gi;
	$string =~ s/=73/s/gi;
	$string =~ s/=74/t/gi;
	$string =~ s/=75/u/gi;
	$string =~ s/=76/v/gi;
	$string =~ s/=77/w/gi;
	$string =~ s/=78/x/gi;
	$string =~ s/=79/y/gi;
	$string =~ s/=7A/z/gi;
	$string =~ s/=7B/\{/gi;
	$string =~ s/=7C/\|/gi;
	$string =~ s/=7D/\}/gi;
	$string =~ s/=7E/\~/gi;
	$string =~ s/=7F//gi;
	$string =~ s/=80/â/gi;
	$string =~ s/=81/0/gi;
	$string =~ s/=82/0/gi;
	$string =~ s/=83/0/gi;
	$string =~ s/=84/0/gi;
	$string =~ s/=85/0/gi;
	$string =~ s/=86/0/gi;
	$string =~ s/=87/0/gi;
	$string =~ s/=88/0/gi;
	$string =~ s/=89/0/gi;
	$string =~ s/=8A/0/gi;
	$string =~ s/=8B/0/gi;
	$string =~ s/=8C/0/gi;
	$string =~ s/=8D/0/gi;
	$string =~ s/=8E/0/gi;
	$string =~ s/=8F/0/gi;
	$string =~ s/=90/0/gi;
	$string =~ s/=91/â/gi;
	$string =~ s/=92/â/gi;
	$string =~ s/=93/â/gi;

	$string =~ s/=94/â/gi;
	$string =~ s/=95/?/gi;
	$string =~ s/=96/?/gi;
	$string =~ s/=97/?/gi;
	$string =~ s/=98/0/gi;
	$string =~ s/=99/â/gi;
	$string =~ s/=9A/Å/gi;

	$string =~ s/=9B/â/gi;
	$string =~ s/=9C/Å/gi;
	$string =~ s/=9D//gi;
	$string =~ s/=9E/Å/gi;
	$string =~ s/=9F/Å/gi;
	$string =~ s/=A0/ /gi;
	$string =~ s/=A1/¡/gi;
	$string =~ s/=A2/¢/gi;
	$string =~ s/=A3/£/gi;
	$string =~ s/=A4/¤/gi;
	$string =~ s/=A5/¥/gi;
	$string =~ s/=A6/¦/gi;
	$string =~ s/=A7/§/gi;
	$string =~ s/=A8/¨/gi;
	$string =~ s/=A9/©/gi;
	$string =~ s/=AA/ª/gi;
	$string =~ s/=AB/«/gi;
	$string =~ s/=AC/¬/gi;
	$string =~ s/=AD/­/gi;
	$string =~ s/=AE/®/gi;
	$string =~ s/=AF/¯/gi;
	$string =~ s/=B0/°/gi;
	$string =~ s/=B1/±/gi;
	$string =~ s/=B2/²/gi;
	$string =~ s/=B3/³/gi;
	$string =~ s/=B4/´/gi;
	$string =~ s/=B5/µ/gi;
	$string =~ s/=B6/¶/gi;
	$string =~ s/=B7/·/gi;
	$string =~ s/=B8/¸/gi;
	$string =~ s/=B9/¹/gi;
	$string =~ s/=BA/º/gi;
	$string =~ s/=BB/»/gi;
	$string =~ s/=BC/¼/gi;
	$string =~ s/=BD/½/gi;
	$string =~ s/=BE/¾/gi;
	$string =~ s/=BF/¿/gi;
	$string =~ s/=C0/À/gi;
	$string =~ s/=C1/Á/gi;
	$string =~ s/=C2/Â/gi;
	$string =~ s/=C3/Ã/gi;
	$string =~ s/=C4/Ä/gi;
	$string =~ s/=C5/Å/gi;
	$string =~ s/=C6/Æ/gi;
	$string =~ s/=C7/Ç/gi;
	$string =~ s/=C8/È/gi;
	$string =~ s/=C9/É/gi;
	$string =~ s/=CA/Ê/gi;
	$string =~ s/=CB/Ë/gi;
	$string =~ s/=CC/Ì/gi;
	$string =~ s/=CD/Í/gi;
	$string =~ s/=CE/Î/gi;
	$string =~ s/=CF/Ï/gi;
	$string =~ s/=D0/Ð/gi;
	$string =~ s/=D1/Ñ/gi;
	$string =~ s/=D2/Ò/gi;
	$string =~ s/=D3/Ó/gi;
	$string =~ s/=D4/Ô/gi;
	$string =~ s/=D5/Õ/gi;
	$string =~ s/=D6/Ö/gi;
	$string =~ s/=D7/×/gi;
	$string =~ s/=D8/Ø/gi;
	$string =~ s/=D9/Ù/gi;
	$string =~ s/=DA/Ú/gi;
	$string =~ s/=DB/Û/gi;
	$string =~ s/=DC/Ü/gi;
	$string =~ s/=DD/Ý/gi;
	$string =~ s/=DE/Þ/gi;
	$string =~ s/=DF/ß/gi;
	$string =~ s/=E0/à/gi;
	$string =~ s/=E1/á/gi;
	$string =~ s/=E2/â/gi;
	$string =~ s/=E3/ã/gi;
	$string =~ s/=E4/ä/gi;
	$string =~ s/=E5/å/gi;
	$string =~ s/=E6/æ/gi;
	$string =~ s/=E7/ç/gi;
	$string =~ s/=E8/è/gi;
	$string =~ s/=E9/é/gi;
	$string =~ s/=EA/ê/gi;
	$string =~ s/=EB/ë/gi;
	$string =~ s/=EC/ì/gi;
	$string =~ s/=ED/í/gi;
	$string =~ s/=EE/î/gi;
	$string =~ s/=EF/ï/gi;
	$string =~ s/=F0/ð/gi;
	$string =~ s/=F1/ñ/gi;
	$string =~ s/=F2/ò/gi;
	$string =~ s/=F3/ó/gi;
	$string =~ s/=F4/ô/gi;
	$string =~ s/=F5/õ/gi;
	$string =~ s/=F6/ö/gi;
	$string =~ s/=F7/÷/gi;
	$string =~ s/=F8/ø/gi;
	$string =~ s/=F9/ù/gi;
	$string =~ s/=FA/ú/gi;
	$string =~ s/=FB/û/gi;
	$string =~ s/=FC/ü/gi;

	return $string;
}

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub getFileSize{
	my ($self, $string) = @_;
	my $filesize = -s $string;
	return $filesize;
}


# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub getVersion{
	my ($self) = @_;
	return "2010-07-22";
};

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub addAttachment{
	my ($self, $attachmentFiles, $description, $type, $size) = @_;	
	push(@{ $self->{attachmentFiles} } , $attachmentFiles);	
	push(@{ $self->{attachmentDescription} } , $description);	
	push(@{ $self->{attachmentFileTypes} } , $type);
	push(@{ $self->{attachmentFileSize} } , $size);
}

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub getFileNamesServer{
	my ($self) = @_;	
	return @{$self->{attachmentFiles}};
}

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub getFileNamesDescription{
	my ($self) = @_;	
	return @{$self->{attachmentDescription}};
}

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub getFileTypes{
	my ($self) = @_;	
	return @{$self->{attachmentFileTypes}};
}

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub getFileSizes{
	my ($self) = @_;	
	return @{$self->{attachmentFileSize}};
}
# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub getAttachmentNumber{};

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------

sub getAttachment{};

# -------------------------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------------------------
1;


exit 0;