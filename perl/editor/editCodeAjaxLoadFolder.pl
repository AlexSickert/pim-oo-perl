#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use Net::SMTP;   
use DBI;

print  "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";


my  $xml = param("xml");

if ($xml eq ''){

$xml = '<?xml version="1.0" encoding="ISO-8859-1" ?>
<parameter>
   <id></id>
   <v_u></v_u>
   <v_s></v_s>
<folderpath>/</folderpath>
   	  
   <filecontent></filecontent>
</parameter>';

}

print $xml;

sub getXmlParameter{

    my $parameter = $_[0];
    
    if($_[1] eq "folderpath"){
        $parameter =~ m/<folderpath>(.*)<\/folderpath>/si;
        $parameter = "$1";
    }
    
    if($_[1] eq "id"){
        $parameter =~ m/<id>(.*)<\/id>/si;
        $parameter = "$1";
    }
    if($_[1] eq "v_u"){
        $parameter =~ m/<v_u>(.*)<\/v_u>/si;
        $parameter = "$1";
    } 
    if($_[1] eq "v_s"){
        $parameter =~ m/<v_s>(.*)<\/v_s>/si;
        $parameter = "$1";
    }    
    if($_[1] eq "filecontent"){
        $parameter =~ m/<filecontent>(.*)<\/filecontent>/si;
        $parameter = "$1";
    }    
     
    $parameter =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;

return $parameter;
}

sub url_encode {
    my $text = shift;
    $text =~ s/([^a-z0-9_.!~*'(  ) -])/sprintf "%%%02X", ord($1)/ei;
    $text =~ tr/ /+/;
    return $text;
}

# -------------------------------------------------------------------------------------------

my $folderPath = getXmlParameter($xml,  'folderpath');

print "folderPath: " . $folderPath;

# pfas derzeleg und wieder zusammensetzen

my @pathParts = split(/\//, $folderPath);
my @resultFiles;
my @resultFolders;
my $upDir = "";
my $i;
my $x;
my $arrLen = scalar @pathParts; 

if ($arrLen > 1){
	for($i = 0; $i < ($arrLen - 1); $i++){
		$upDir .= "/" . $pathParts[$i];
	}
}

$i = 0;
$x = 0;
if (-e $folderPath )
	{
		opendir(my $DIR, $folderPath );

		while(my $currentdatei = readdir($DIR))
		{			
				if(-f $folderPath . '/' . $currentdatei )
				{
						$resultFiles[$x] .= '<option value="'.$folderPath . '/' . $currentdatei.'">';
						$resultFiles[$x] .=  $currentdatei;
						$resultFiles[$x] .= '</option >'."\n";	
						$x = $x + 1;
				}
				else  # also wenn folder
				{

					
					if ($currentdatei eq '..'){
						$resultFolders[$i] .=  '<option value="'.$upDir.'">';
						$resultFolders[$i] .=  "..";
						$resultFolders[$i] .= '</option >'."\n";	
						$i = $i + 1;
					}
					else{
						if ($currentdatei ne '.'){
							$resultFolders[$i] .= '<option value="'.$folderPath . '/' . $currentdatei.'">';
							$resultFolders[$i] .= $currentdatei;
							$resultFolders[$i] .= '</option >'."\n";
							$i = $i + 1;	
						}	
					}
						
				}
		}
	}


print '<input type="text" id="selectPath" value="'.$folderPath.'" size="100"><br /><br />';

print '<select name=\'selectFolders\' id=\'selectFolders\' size=\'20\'  onchange="loadFolder()" style="width:350px" >'."\n";
sort(@resultFolders);
print sort(@resultFolders);
print '</select>'."\n";

print '<select  name=\'selectFiles\'  id=\'selectFiles\' size=\'20\'  onchange="loadFile()" style="width:350px" >'."\n";
sort(@resultFiles);
print sort(@resultFiles);
print '</select>'."\n";


exit 0;
