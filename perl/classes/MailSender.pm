package MailSender;


use Net::POP3;
use Net::SMTP;
use MIME::Base64;
use Socket; 
use CGI qw(:standard);


#=============================================================================================	

#constructor

sub new {
    my ($class) = @_;
    my $self =
      { 
	_content => '', 
	_from => "",
	_to => "", 
	_subject => '',
	_boundary => 'ltf0349875934750298374051987430982',
	_cc => "", 
	_bcc => "", 
	_attachment => "", 
	_mail => ""
	};
    	
    bless $self, $class;
    return $self;
}

#=============================================================================================	

sub addAttachment{

my ( $self) = @_;    

my @dateiArray;
my @dateinameArray;
my @dateiArrayFinal;


if (defined param('file_1')){ $dateiArray[1] = param('file_1'); }else{ $dateiArray[1] = ""; };
if (defined param('file_2')){ $dateiArray[2] = param('file_2'); }else{ $dateiArray[2] = ""; };
if (defined param('file_3')){ $dateiArray[3] = param('file_3'); }else{ $dateiArray[3] = ""; };
if (defined param('file_4')){ $dateiArray[4] = param('file_4'); }else{ $dateiArray[4] = ""; };
if (defined param('file_5')){ $dateiArray[5] = param('file_5'); }else{ $dateiArray[5] = ""; };

if (defined param('file_name_1')){ $dateinameArray[1] = param('file_name_1'); }else{ $dateiArray[1] = ""; };
if (defined param('file_name_2')){ $dateinameArray[2] = param('file_name_2'); }else{ $dateiArray[2] = ""; };
if (defined param('file_name_3')){ $dateinameArray[3] = param('file_name_3'); }else{ $dateiArray[3] = ""; };
if (defined param('file_name_4')){ $dateinameArray[4] = param('file_name_4'); }else{ $dateiArray[4] = ""; };
if (defined param('file_name_5')){ $dateinameArray[5] = param('file_name_5'); }else{ $dateiArray[5] = ""; };

my $dateiname_insert;
my @path_array;
my $a;
my $i = 1;

my $datei;
my $data;
my $dateiname;
my $filenameTest;
my $thisAttachment;

# -------------- start loop ----------------
$self->{_attachment} = "";

while ($i <= 5){

   $datei  = $dateiArray[$i];
   $dateiname = $dateinameArray[$i];
   $filenameTest = $dateiname;


   if($filenameTest =~ m/\//){
      # linux
      $a = split(/\//,$dateiname);     # Anzahl der Elemente
      @path_array = split(/\//,$dateiname);     # Array der einzelnen Teilstrings
      $dateiname = @path_array[$a-1];
   }else{
      # windows
      $a = split(/\\/,$dateiname);     # Anzahl der Elemente
      @path_array = split(/\\/,$dateiname);     # Array der einzelnen Teilstrings
      $dateiname = @path_array[$a-1];
   }

   if ( $dateiname ne '')   {
      if($datei){    
        #print "creating file";
         while(read $datei,$data,1024){ $dateiArrayFinal[$i] = $dateiArrayFinal[$i] . $data; }
         
        
         # now file is in variable and we can transform to base64
         $thisAttachment = "";

         $thisAttachment .= "------".$self->{_boundary}."" . "\n";

         $thisAttachment .= "Content-Type: ". $self->getMimeType($dateiname) . ";  ". "name=\"".$dateiname."\"\n";
         $thisAttachment .= "Content-Description: " . $dateiname . "\n";
         $thisAttachment .= "Content-Disposition: attachment;\n filename=\"" . $dateiname . "\"\n";
         $thisAttachment .= "Content-Transfer-Encoding: ". "base64\n\n";

         $thisAttachment .= encode_base64($dateiArrayFinal[$i]) . "\n\n";;

         $self->{_attachment} = $self->{_attachment} . $thisAttachment;

      }else{
         #print $i."mail file empty<br>";
      }
   }else{
      #print $i."mail file name empty<br>";
   }
   
   $i = $i + 1;
}
# --------------- end loop ------------------
}

# ================================================================================
sub getMimeType{

    my ( $self, $fileName ) = @_;
    my @fileCheck = split(/\./, $fileName);
    my $testString = $fileCheck [$#fileCheck];
    my $file_extension_ucase = uc($testString);

    my $mimetype = "";

    if ($file_extension_ucase eq "GZ"){$mimetype = "application/gzip";};
    if ($file_extension_ucase eq "XLS"){$mimetype = "application/msexcel";};
    if ($file_extension_ucase eq "HLP"){$mimetype = "application/mshelp";};
    if ($file_extension_ucase eq "PPT"){$mimetype = "application/mspowerpoint";};
    if ($file_extension_ucase eq "PPZ"){$mimetype = "application/mspowerpoint";};
    if ($file_extension_ucase eq "PPS"){$mimetype = "application/mspowerpoint";};		
    if ($file_extension_ucase eq "DOC"){$mimetype = "application/msword";}; 
    if ($file_extension_ucase eq "DOT"){$mimetype = "application/msword";};		
    if ($file_extension_ucase eq "BIN"){$mimetype = "application/octet-stream";};
    if ($file_extension_ucase eq "EXE"){$mimetype = "application/octet-stream";}; 
    if ($file_extension_ucase eq "COM"){$mimetype = "application/octet-stream";};
    if ($file_extension_ucase eq "DLL"){$mimetype = "application/octet-stream";};		
    if ($file_extension_ucase eq "PDF"){$mimetype = "application/pdf";}; 
    if ($file_extension_ucase eq "RTC"){$mimetype = "application/rtc";};
    if ($file_extension_ucase eq "RTF"){$mimetype = "application/rtf";};
    if ($file_extension_ucase eq "HTML"){$mimetype = "application/xhtml+xml";}; 
    if ($file_extension_ucase eq "HTM"){$mimetype = "application/xhtml+xml";}; 		
    if ($file_extension_ucase eq "SHTML"){$mimetype = "application/xhtml+xml";};
    if ($file_extension_ucase eq "XHTML"){$mimetype = "application/xhtml+xml";}; 		
    if ($file_extension_ucase eq "XML"){$mimetype = "application/xml";};
    if ($file_extension_ucase eq "PHP"){$mimetype = "application/x-httpd-php";};
    if ($file_extension_ucase eq "JS"){$mimetype = "application/x-javascript";}; 
    if ($file_extension_ucase eq "LATEX"){$mimetype = "application/x-latex";};
    if ($file_extension_ucase eq "BIN"){$mimetype = "application/x-macbinary";};
    if ($file_extension_ucase eq "SWF"){$mimetype = "application/x-shockwave-flash";}; 
    if ($file_extension_ucase eq "TAR"){$mimetype = "application/x-tar";};
    if ($file_extension_ucase eq "TEX"){$mimetype = "application/x-tex";};
    if ($file_extension_ucase eq "ZIP"){$mimetype = "application/zip";};
    if ($file_extension_ucase eq "TSI"){$mimetype = "audio/tsplayer";};
    if ($file_extension_ucase eq "VOX"){$mimetype = "audio/voxware";};
    if ($file_extension_ucase eq "AIFF"){$mimetype = "audio/x-aiff";}; 
    if ($file_extension_ucase eq "MID"){$mimetype = "audio/x-midi";}; 
    if ($file_extension_ucase eq "MP2"){$mimetype = "audio/x-mpeg";}; 
    if ($file_extension_ucase eq "WAV"){$mimetype = "audio/x-wav";}; 
    if ($file_extension_ucase eq "GIF"){$mimetype = "image/gif";};
    if ($file_extension_ucase eq "JPEG"){$mimetype = "image/jpeg";};
    if ($file_extension_ucase eq "JPG"){$mimetype = "image/jpeg";};
    if ($file_extension_ucase eq "JPE"){$mimetype = "image/jpeg";};	
    if ($file_extension_ucase eq "PSD"){$mimetype = "image/psd";};		 
    if ($file_extension_ucase eq "PNG"){$mimetype = "image/png";}; 
    if ($file_extension_ucase eq "CSV"){$mimetype = "text/comma-separated-values";}; 
    if ($file_extension_ucase eq "CSS"){$mimetype = "text/css";};
    if ($file_extension_ucase eq "HTM"){$mimetype = "text/html";}; 
    if ($file_extension_ucase eq "HTML"){$mimetype = "text/html";}; 
    if ($file_extension_ucase eq "SHTML"){$mimetype = "text/html";};		
    if ($file_extension_ucase eq "JS"){$mimetype = "text/javascript";};
    if ($file_extension_ucase eq "TXT"){$mimetype = "text/plain";};
    if ($file_extension_ucase eq "RTX"){$mimetype = "text/richtext";};
    if ($file_extension_ucase eq "XML"){$mimetype = "text/xml";};
    if ($file_extension_ucase eq "MPEG"){$mimetype = "video/mpeg";};
    if ($file_extension_ucase eq "MPG"){$mimetype = "video/mpeg";};
    if ($file_extension_ucase eq "MPE"){$mimetype = "video/mpeg";};

    return $mimetype;
}

#=================================================================================
# compose final mail
sub setContent{
my ( $self, $from, $to, $cc, $bcc, $subject, $mailBody ) = @_;
my $mailComplete = "";

$self->{_from} = $from;
$self->{_to} = $to;
$self->{_cc} = $cc;
$self->{_subject} = $subject;



# cut mailbody in pieces

my @mailBodyArr= split(/\n/, $mailBody );
my $currentLine;
my $finalMailBody;
my $restString;
my $firstPart;
my $testString;

#foreach (@mailBodyArr) {
#   $currentLine = $_;
#   if(length($currentLine) > 60 ){
#      $restString = $currentLine;
#      while(length($restString) > 60 ){
#         $firstPart = substr($restString,0,60);
#         $finalMailBody = $finalMailBody . "=" . chr(13) . chr(10) . $firstPart;
#         $restString = substr($restString,60);
#     }
#     $testString = $restString;
#     $testString =~ s/^\s+//;
#     $testString =~ s/\s+$//;
#     
#     if($testString ne "."){
#        $finalMailBody = $finalMailBody . "=" . chr(13) . chr(10) . $restString;
#     }else{
#        $finalMailBody = $finalMailBody . $restString;
#     }
#   }else{
#      $testString = $currentLine ;
#      $testString =~ s/^\s+//;
#      $testString =~ s/\s+$//;
#      if($testString ne "."){
#         $finalMailBody = $finalMailBody . "\n" . $currentLine;
#      }else{
#         $finalMailBody = $finalMailBody . $currentLine ;
#      }
#   }
#}

$finalMailBody = encode_base64($mailBody);

$mailComplete = "";
$mailComplete .= "MIME-Version: 1.0" . "\n";
$mailComplete .= "Content-Type: multipart/mixed; boundary=\"----".$self->{_boundary}."\" " . "\n";
$mailComplete .= "Subject: ".$self->{_subject}."" . "\n";
$mailComplete .= "From: <".$self->{_from}.">" . "\n";
$mailComplete .= "To: ".$self->{_to}."" . "\n";
$mailComplete .= "Cc: ".$self->{_cc}."" . "\n\n";
$mailComplete .= "This is a multi-part message in MIME format." . "\n\n";
$mailComplete .= "------".$self->{_boundary}."" . "\n";

# following lines deactivated on 6th may 2011
#$mailComplete .= "Content-Type: text/plain;  " . "\n";
#$mailComplete .= "	charset=\"ISO-8859-1\"" . "\n";
#$mailComplete .= "Content-Transfer-Encoding: quoted-printable" . "\n\n";

#following lines introduced 6th may 2011
#$mailComplete .= "Content-Type: text/plain; charset=utf-8" . "\n";
$mailComplete .= "Content-Type: text/html; charset=utf-8" . "\n";
$mailComplete .= "Content-Transfer-Encoding: base64" . "\n\n";
$mailComplete .= "". $finalMailBody  ."" . "\n\n";

if($self->{_attachment} ne ''){

   $mailComplete .= $self->{_attachment} . "\n\n";

}

$mailComplete .= "------".$self->{_boundary}."--" . "\n";

$self->{_mail} = $mailComplete; 
return 1;  
}    
#=================================================================================
# send the mail
sub sendMail{
    my ( $self, $server, $login, $password  ) = @_;
    my $ret;
    # "solenski.com", "solenski.com", "ph234p1", "ncgg1x", "alex\@solenski.com", $recipi

    $ret = sendSmtpAll($server, $server, $login, $password , $self->{_from}, $self->{_to}, $self->{_cc}, $self->{_cc}, $self->{_mail});


    if($ret =~ m/error/i){
       $ret = "ERROR !!! <br />" . $ret ;
    }else{
       $ret = "OK !!!<br />(v.1.3 - 6th May 2011)<script language='javascript'>window.setTimeout('window.close()', 500);</script>";     
    }
    return $ret;
}
#=================================================================================
sub getMail{
   my ( $self ) = @_;
   return $self->{_mail};
}
#=================================================================================

sub sendSmtpAll{
    my ($pophost, $account, $user, $password, $from, $to, $cc, $bcc, $mailbody) = @_;
    my $allOk = "yes";
    my $thisOk = "yes";
    my $allRecipientsString;
    my $currentRecipient;

   $allRecipientsString = $to . ", " . $cc;

    my @allRecipients = split(/,/, $allRecipientsString);

    foreach (@allRecipients) {

       $currentRecipient = $_;

       $currentRecipient =~ s/ //gi;
       if($currentRecipient ne ""){

          $thisOk = sendMailSocket($account, $user, $password,$currentRecipient,$from,$mailbody);

          if($thisOk eq "error"){
             $allOk = "error" . $thisOk ;
          }
       }
    }
    
    $allOk  = $allOk  . $thisOk ;
    # send als backup
    $thisOk = sendMailSocket($account, $user, $password,"this.is.alex\@gmx.de",$from,$mailbody);

       if($thisOk eq "error"){
          $allOk = "error";
       }

    return $allOk . $thisOk ;
}

#===============================================================================================

sub sendMailSocket{
    my ($server, $userName, $password, $to, $from , $mailbody  ) = @_;

    my $responses = "-----------------------------------------------------------------";
    my $in_addr;
    my $server_addr;
    my $sockaddr_in ;

    my $user = encode_base64($userName); #Yes the encryption for AUTH is really this easy
    my $pass = encode_base64($password); #Base 64 is not really and encryption just a translation

    my $Response = "";
    chomp($user);   #Get rid of line ending
    chomp($pass);   #Get rid of line ending   

    socket(SOCK, PF_INET, SOCK_STREAM, getprotobyname('tcp')); #set up the socket
    #socket(SOCK, PF_INET, SOCK_STREAM, getprotobyname('tcp')); #set up the socket 

    $sockaddr_in = 'S n a4 x8';
    $in_addr = (gethostbyname($server))[4];
    $server_addr = pack( $sockaddr_in, AF_INET, 25, $in_addr );

    #connect(SOCK, sockaddr_in(25, inet_aton($server))); #connect to my server on port 25
    connect(SOCK, $server_addr ); #connect to my server on port 25

    sysread(SOCK, $Response, 1024); #Read what the server says
    $responses .=  join('<br>', split(/\n/,$Response)) ."<br>"; #Print Server Greeting
    $responses .=  "TX  ehlo demo\n" ."<br>";  #print our response
    send(SOCK, "ehlo ".$server."\r\n", 0);  #Hello my name is demo
    sysread(SOCK, $Response, 1024); #Read resp
    $responses .=  join('<br>', split(/\n/,$Response)) ."<br>";      #print resp 


    #Tell the server we wish to use Authentication
    $responses .=  "TX  AUTH LOGIN\n" ."<br>";   #print our resp
    send(SOCK, "AUTH LOGIN\r\n",0); #Ask for AUTH Login
    sysread(SOCK, $Response, 1024); #Read Resp
    $responses .=  $Response ."<br>";                #Print RESP
    $responses .=  "TX  " . $user . " (login)\n" ."<br>"; #Our Resp
    send(SOCK, $user . "\r\n", 0); #Encrypted User Name
    sysread(SOCK, $Response, 1024); #Read Resp
    $responses .= $Response ." (sending user)<br>"; #print Resp
    #send the encrypted password
    $responses .=  "TX  " . $pass . "\n" ."<br>";    #our Resp
    send(SOCK, $pass . "\r\n", 0); #Encrypted Pass
    sysread(SOCK, $_, 1024); #Read Resp
    $responses .= $_ ." (sending passowrd)<br>"; #print Resp
    send(SOCK, "mail from: <".$from .">" . "\r\n", 0); #Encrypted Pass
    sysread(SOCK, $Response, 1024); #Read Resp
    $responses .= $Response ."( from)<br>"; #print Resp
    send(SOCK, "rcpt to: <".$to.">" . "\r\n", 0);
    sysread(SOCK, $Response, 1024); #Read Resp
    $responses .= $Response ."(to)<br>"; #print Resp
    #send(SOCK, "sdfsdfsdfsdfsf" . "\r\n", 0);
    send(SOCK, "data" . "\r\n", 0);

    my @message = split(/(\n)/, $mailbody); 
    
    for (@message) { 
        send(SOCK, $_ , 0);
    }

    send(SOCK, "" . "\r\n.\r\n", 0);
    sysread(SOCK, $Response, 1024); #Read Resp
    $responses .= $Response ."(data)<br>"; #print Resp
    send(SOCK, "quit" . "\r\n", 0);
    sysread(SOCK, $Response, 1024); #Read Resp
    $responses .= $Response ."(finish)<br>"; #print Resp
    close(SOCK);

    $responses .= "-----------------------------------------------------------------";

    if($responses =~ m/error/i){
    #print $responses;
    return "error" . $responses;
    }else{
    return "ok" . $responses;
    }
}


#=============================================================================================	

1;
