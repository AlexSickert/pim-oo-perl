#!/usr/bin/perl -w
#!C:\Perl\bin\perl.exe
#!c:\apachefriends\xampp\perl\bin\perl.exe
#use CGI::Carp qw(fatalsToBrowser);
#no warnings;
use Socket;
use Config;
#alarm(300);
use CGI qw(:standard);

print  "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";

my $pfad  = param("path");


print "<input type='button' value='close' onclick='window.close()' />";
print "<br />___________________________________________________________________________________<br /><br />";
print  "debugging: " . $pfad;
print "<br />___________________________________________________________________________________<br />";
#my $pfad = "/var/www/vhosts/alex-admin.net/cgi-bin/dev/editor/debug.pl";

my $perl;
my $perl2;
#my $return = command("perl -cw $pfad 2>&1");

my @shell = split(/\n/,&command("perl -cw $pfad 2>&1"));
			foreach my $line (@shell) {
				$perl .= "$line<br>";
			} 
			$perl2 = join('', @shell);
print $perl2;

sub command {
	local($e) = @_;
	eval {
		local $SIG{ALRM} = sub { die "alarm\n" };
		alarm(5);
		$return = join("",`$e`);
		alarm(0);
	};
	return($return);
}