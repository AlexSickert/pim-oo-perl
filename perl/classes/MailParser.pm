package MailParser;

use MIME::Base64;
# use Encode;

require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Utility.pm';
#asdfasdfasdf
# ============================================================================================
#constructor
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
		_arrCounter => 0
	};

	$self->{attachmentFiles}  = [];	
	$self->{attachmentDescription}  = [];
	$self->{attachmentFileTypes}  = [];
	$self->{attachmentFileSize}  = [];

	bless $self, $class;
	return $self;
}
# ============================================================================================
sub getVersion{
	my ($self) = @_;
	return "2009-09-01";
};
# ============================================================================================

sub addAttachment{
	my ($self, $attachmentFiles, $description, $type, $size) = @_;	
	push(@{ $self->{attachmentFiles} } , $attachmentFiles);	
	push(@{ $self->{attachmentDescription} } , $description);	
	push(@{ $self->{attachmentFileTypes} } , $type);
	push(@{ $self->{attachmentFileSize} } , $size);

}
# ============================================================================================

sub getFileNamesServer{
	my ($self) = @_;	
	return @{$self->{attachmentFiles}};
}
# ============================================================================================

sub getFileNamesDescription{
	my ($self) = @_;	
	return @{$self->{attachmentDescription}};
}

# ============================================================================================

sub getFileTypes{
	my ($self) = @_;	
	return @{$self->{attachmentFileTypes}};
}

# ============================================================================================

sub getFileSizes{
	my ($self) = @_;	
	return @{$self->{attachmentFileSize}};
}
# ============================================================================================
# Mail anhand von file laden und die einzelnen variablen fuellen
sub loadMail(){
	my ( $self, $filePath, $uid, $type ) = @_;
	my $datei;
	my $attachment;
	my @parameter;
	my $contentFlag = 0;
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
	my $updir = $filePath . 'attachments' ;
	my $temporaryLocalFileName;
	my $enc = 'utf-8';
	my $zeile = '';

	# random string for attachment files
	my $randomAttName;
	my $util = Utility->new();
	$randomAttName = $util->getRandomString(20);

    
	$contentPath = $filePath . $uid . "." . $type;
	open($datei, "< $contentPath");

	# zeilenweise durch file gehen und am doppelpunkt splitten
	while (my $zeileTmp = <$datei>){

		#convert to a utf-8 string
		# $zeile = decode($enc,  $zeileTmp);
		$zeile = $zeileTmp;

		$zeileOriginal = $zeile;

		chomp($zeile);

		# $zeile .= "\n\r";   # because this was removed by the line split reading line by line
		# $zeileOriginal .= "\n\r";  # because this was removed by the line split reading line by line

		if ($zeile eq ''){
			$contentFlag = 1;
		}
		
		# =================================== HEADER =================================================
		# find all parameters of the header
		if ($contentFlag == 0){
			
			# add to existing paramters if the new line start with nothing			

			if($lastHeaderStuff eq "to" && substr($zeile ,0, 1) eq ' ' ){
				$self->{_to} .= $zeile;
			}

			if($lastHeaderStuff eq "to" && substr($zeile ,0, 1) eq '	' ){
				$self->{_to} .= $zeile;
			}

			if($lastHeaderStuff eq "from" && substr($zeile ,0, 1) eq ' ' ){
				$self->{_from} .= $zeile;
			}

			if($lastHeaderStuff eq "from" && substr($zeile ,0, 1) eq '	' ){
				$self->{_from} .= $zeile;
			}

			if($lastHeaderStuff eq "subject" && substr($zeile ,0, 1) eq 	'	' ){
				$self->{_subject} .= $zeile;
			}

			if($lastHeaderStuff eq "subject" && substr($zeile ,0, 1) eq ' ' ){
				$self->{_subject} .= $zeile;
			}	
			
		}
		
		
		if ($zeile =~ m/:/  && $contentFlag == 0){
			
			@parameter = (split(":", $zeile ));
			#if($parameter[0] eq "From"){
			if($zeile =~ m/^From:\s+(.*)/i){
				$zeile =~ s/\AFrom://i;
				$self->{_from} = $zeile;
                                		$lastHeaderStuff = "from";
			}

			#if($parameter[0] eq "To"){
			if($zeile =~ m/^To:\s+(.*)/i){
				$zeile =~ s/\ATo://i;
				$self->{_to} = $zeile;
				$lastHeaderStuff = "to";
			}

			#if($parameter[0] eq "Subject"){
			if($zeile =~ m/^Subject:\s+(.*)/i){
				$zeile =~ s/\ASubject://i;
				$self->{_subject} = $zeile;
				$lastHeaderStuff = "subject";
			}

			#   if /^Date:\s+(.*)/i;
			if($zeile =~ m/^Date:\s+(.*)/i){
				$zeile =~ s/\ADate://i;
				$self->{_date} = $zeile;
				$lastHeaderStuff = "date";
			}
			
			# content type
			if($parameter[0] eq "Content-Type"){
				$zeile =~ s/\AContent-Type://i;
				$zeile =~ s/;//g;
				if ($zeile ne ''){				
					$self->{_contentType} = $zeile;
				}
				$lastHeaderStuff = "contenttype";
			}			
			
		} # if we find a : and content flag is 0 

		# =================================== BOUNDARY =================================================
		# get main boundary 
		if ($zeile =~ m/boundary/i  && $contentFlag == 0){
			# $zeile =~ s/(\D*)"(*)"(\D*)/$2/;

 			($boundary) = $zeile =~ m/"(.*)"/;
			$self->{_mainBoundary} = ($boundary);
			$allBoundaries[0] = ($boundary);
			$allBoundariesString = 	($boundary);
			$lastHeaderStuff = "boundary";
		}
		
		# =================================== BODY =================================================
		# process the body
		if($contentFlag == 1){
			# simple mail simple process
			if ($self->{_contentType} =~ m/text\/plain/){
				$self->{_text} .= $zeileOriginal;	
			}
			# simple html mail
			elsif($self->{_contentType} =~ m/text\/html/){
				$self->{_html} .= $zeileOriginal;	
			}
			# multipart/alternative mail
			elsif($self->{_contentType} =~ m/multipart\/alternative/ ){

				#wenn boundary erreicht wird dann reset variablen
				#weiter warten auf content type
				# wenn content type nicht html oder text und 
				# wenn html und text schon gefllt sind, dann attachments machen
				
				if ($zeile eq '--' . $self->{_mainBoundary}  ){
					$recordingStatus = 'head';	
				}
				#ende des heads erreicht - jetzt kommt ocntent
				if ($zeile eq '' && $recordingStatus eq 'head'){
					$recordingStatus = 'record';
				}
				#untersuche header
				if ($recordingStatus eq 'head'){
					if ($zeile =~ m/Content-Type/i){
						$zeile =~ s/\AContent-Type://i;
						$zeile =~ s/;//g;				
						$tempContentType = $zeile;						
					}
					# encoding base64
					if ($zeile =~ m/base64/i  ){
						$tmpEncoding = "base64";
					}
					#check encoding - if utf added 29.12.2010
					if ($zeile =~ m/utf-8/gi  ){
						# ToDo.... !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
					}
				}

				if ($recordingStatus eq 'record'){
					if ($zeile ne '--' . $self->{_mainBoundary} . '--'){	
						
						if ($tempContentType =~ m/text\/plain/){
							$self->{_text} .= $zeile . "\n\r";
							if($tmpEncoding  eq 'base64'){
								$self->{_text_encoding} = 'base64';
							}	
						}
						
						if ($tempContentType =~ m/text\/html/){
							$self->{_html} .= $zeile . "\n\r";
							if($tmpEncoding eq 'base64'){
								$self->{_html_encoding} = 'base64';
							}	
						}
					}	
				}       
				
			# end of multipar alternative    
			}else{
				# for all other types of mail

				# $self->{_contentType} =~ m/multipart\/alternative/
				#$self->{_contentType} =~ m/multipart\/alternative/
				#  multipart/mixed und multipart/related
				#  multipart/mixed und multipart/mixed

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
					
				$boundaryTest = $allBoundariesString;

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
				
					# print "FILENAME zum speichern: " . $fileName;
					if($updir ne '' && $fileName ne '' & $fileContent ne ''){
						# wenn attachment content da und so dann speichern
						$fileName = $self->cleanFileName($fileName); 

						$fileType = $self->getFileType($fileName);

						#increase the file counter
						$self->{_attachmentCounter} = $self->{_attachmentCounter} + 1;

						$temporaryLocalFileName = "attachment-" . $randomAttName . "-" . $self->{_attachmentCounter} . ".dat";

						# save the file
						open($attachment, "> ".$updir."/" . $temporaryLocalFileName) or die (print "cant open file");								
						print $attachment decode_base64($fileContent); 
						close $attachment;
	
						# register the file size
						# put the data into the array
						$self->addAttachment($temporaryLocalFileName, $fileName, $fileType, $self->getFileSize($updir."/" . $temporaryLocalFileName));

						$fileContent = '';
						$fileName = '';
					}
					
					$recordingStatus = 'head';
					$tmpEncoding = "";                                        
					$isAttachment = 0;
					$isContent = 1;					
				}							
				
				# wenn recordingstatus head dann headerinfos aufzeichnen
				if ($recordingStatus eq 'head'){
					if ($zeile =~ m/Content-Type/i){
						$zeile =~ s/\AContent-Type://i;
						$zeile =~ s/;//g;				
						$tempContentType = $zeile;	
						$lastHeaderStuff = "contenttype";
					}
					
					# Content-Disposition: attachment;
					#if ($zeile =~ m/Content-Disposition/i){
						if($zeile =~ m/attachment/i){
							$isAttachment = 1;
							# print "\n isAttachment " . $isAttachment . "\n "
							$lastHeaderStuff = "contentdisposition";
						}

						if($zeile =~ m/inline/i){
							$isAttachment = 1;
							# print "\n isAttachment " . $isAttachment . "\n "
							$lastHeaderStuff = "attachment";
						}
					#}
                                       

					# wenn bounday dann kein content dafuer boundary erweitern
					if ($zeile =~ m/boundary/i){	
						($boundary) = $zeile =~ m/"(.*)"/;	
						$allBoundariesString .= ($boundary);	
						$isContent = 0;	
						# print "\n isContent " . $isContent . "\n "	
						$lastHeaderStuff = "boundary";
					}
					#  filename bei attachments
					if ($zeile =~ m/name=/i  ){	
						#($tmp) = $zeile =~ m/"(.*)"/;	
						$fileName = $self->cleanFileName($zeile);	
                                                			$self->{_html} .= $zeile;	  
                                                			$self->{_text} .= $zeile;	                                              	
						# print "\n fileName " . $fileName . "\n "
						$lastHeaderStuff = "filename";
					}

					# encoding base64
					if ($zeile =~ m/base64/i  ){
						$tmpEncoding = "base64";
						$lastHeaderStuff = "encoding";
					} # set recoding type
						
				}
				
				#ende des heads erreicht - jetzt kommt content
				if ($zeile eq '' && $recordingStatus eq 'head' && $isContent == 1){
					$recordingStatus = 'record';
				} # enable recording
                
				# zeichne content auf
				if ($recordingStatus eq 'record' && $isAttachment == 0){
					if ($tempContentType =~ m/text\/plain/){
						#$self->{_text} .= $zeile . "\n\r";	
						$self->{_text} .= $zeileOriginal;	
					}
					if ($tempContentType =~ m/text\/html/){
						#$self->{_html} .= $zeile . "\n\r";	
						$self->{_html} .= $zeileOriginal;	
					}
				} # record text and html
                
				# speichere attachments
				if ($recordingStatus eq 'record' && $isAttachment == 1){
					
					if(-e $updir) { 
					   #print $updir ." datei existiert\n" 
					}else { 
					   # print $updir ." folder existiert nicht \n";
					   mkdir($updir,0777);					
					};
					#sammle attachmentcontent
					if(defined $zeile){
						$fileContent .= $zeile;
					}
				} # record attachments
			} # if multipart mixed or related
		}	# if content flag = 1	
	} # while lines in the file
	close($datei);
}
# ============================================================================================
# alle weiteren methoden geben nur die variablen zurÃ¼ck
sub getFrom{
	my ($self) = @_;
	return $self->{_from};
};

# ============================================================================================
sub getTo{
	my ($self) = @_;
	return $self->{_to};
};
# ============================================================================================
sub getSubject{
	my ($self) = @_;
	return $self->{_subject};
};



# ============================================================================================
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
        }
        else{
           return $self->cleanCode($self->{_text});
        }

};

# ============================================================================================
sub getHtml{
	my ($self) = @_;
        my $temp;
        if ($self->{_html_encoding} eq 'base64'){
           $temp = decode_base64($self->{_html});
           return $self->cleanCode($temp);
        }
        else{
           return $self->cleanCode($self->{_html});
        }
};

sub getMainBoundary{
   my ($self) = @_;
   return $self->{_mainBoundary};
};

# ============================================================================================
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
# ============================================================================================
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
# ============================================================================================
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

# ============================================================================================
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
        #$string =~ s/'/-/gi;
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

	# if its utf-8 unicode ten we convert to a proper string
#	if ($start =~ m/utf/gi){
#		$returnString = decode('utf-8',  $returnString);
#	}

	return $returnString;
}
# ============================================================================================
# ============================================================================================
sub xxxxxxxxxxspecialReplacements{

	my ($self, $start, $end, $string, $encoding) = @_;
	my @stringArr;
	my $firstPart;
	my $lastPart;
	my $returnString;
	my $test;

	$returnString = $string;

	if ($string=~ m/$start/gi){
		@stringArr = split(/$start/i, $string );
		$firstPart = $stringArr[0];
		$lastPart = $stringArr[1];
		$returnString = $firstPart;

		#add middle part that is encoded

		if ($string=~ m/$end/i){

			@stringArr = split(/$end/i, $lastPart  );
			$firstPart = $stringArr[0];

			if($encoding eq 'B'){
				$firstPart = decode_base64($firstPart);
			}
			if($encoding eq 'Q'){
				$firstPart = $self->cleanHexCode($firstPart);
			}
			$lastPart = $stringArr[1];
			$returnString .= $firstPart  . $lastPart ;
		}else{
			if($encoding eq 'B'){
				$lastPart = decode_base64($lastPart );
			}
			if($encoding eq 'Q'){
				$lastPart = $self->cleanHexCode($lastPart );
			}
			$returnString .=  $lastPart ;
		}
		
	}

	return $returnString;
}
# ============================================================================================


# ============================================================================================
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
# ============================================================================================
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
# ============================================================================================
sub dumpContent{
	my ($self, $string) = @_;
	$string =~ s/=3D/=/gi;
	$string =~ s/=2E/\./gi;
	$string =~ s/=\n//gi;
	$string =~ s/"//gi;
	$string =~ s/'//gi;
	return $string;
}
# ============================================================================================
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
# ============================================================================================
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

# ============================================================================================
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
# ============================================================================================
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

# ============================================================================================
sub getFileSize{
	my ($self, $string) = @_;
	my $filesize = -s $string;
	return $filesize;
}
# ============================================================================================

sub getAttachmentNumber{};
# ============================================================================================
sub getAttachment{};
# ============================================================================================
1;
