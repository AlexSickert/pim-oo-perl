#!/usr/bin/perl


use strict;
use CGI qw(:standard);
use warnings;
use LWP::Simple;


eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/LanguageBusinessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm`;

if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}


# =======================================================================================
print  "Content-type: text/html;Charset=iso-8859-1". "\n\n"; # for debugging

# =======================================================================================

# ---------------------- REQUEST VARIABLES --------------------------------------------------
my $params = CGI->new();
my $service = $params->param("service");
my $wkn_isn = $params->param("id");
my $k = $params->param("k");

#$service = 'yahoo';
#$service = 'wallstreet';
# http://de.finance.yahoo.com/q?s=BMW.DE
#$wkn_isn = 'BMW.DE';
#$wkn_isn = '519000';

# 891jdget32 846rdvxgfsmtuez394zru
# aufruf:    https://ssl-id1.de/alex-admin.net/alex-admin/live/perl/invest/index.pl?service=yahoo&id=BMW.DE&k=891jdget32846rdvxgfsmtuez394zru


# weitere provider:
# Data Definitions</a></li></ul></div><div class="quote"><table><tr><td class="first"><span class="dataValue ">35.15<span class="currencyCode">EUR</span></span><div class="dataLabel">Last Price<
# http://markets.ft.com/tearsheets/performance.asp?s=BMWX:GER
# http://markets.ftd.de/indices/factsheet_overview.html?ID_NOTATION=6623216
# http://www.onvista.de/suche.html?SEARCH_VALUE=DE0005190003&SELECTED_TOOL=ALL_TOOLS
# http://boersen.manager-magazin.de/spo_mmo/kurse_einzelkurs_uebersicht.htm?u=0&p=0&k=0&s=519000&b=9&l=276&n=BMW&sektion=dax





# ---------------------- VARIABLES  ---------------------------------------------------------
my $get_html;
# ---------------------- CODE FOR PAGE ----------------------------------------------------
if($k eq '999'){
				if($service eq 'yahoo')
				{	
					$get_html = get('http://de.finance.yahoo.com/q?s=' . $wkn_isn);	

					$get_html =~ m/Letzter Kurs(.*)Kurszeit/si;		
					$get_html = "$1";
                                        $get_html =~ m/Letzter Kurs(.*)\#8364/si;		
					$get_html = "$1";
                                        $get_html =~ m/(.*)8364/si;		
					$get_html = "$1";	
					$get_html =~ m/<b>(.*)&/si;
					$get_html = "$1";	
					$get_html =~ s/\.//g;		
					$get_html =~ s/,/./g;
				}

# deutsche börse mit http://deutsche-boerse.com/dbag/dispatch/de/isg/gdb_navigation/home?module=InOverview_Equi&wp=DE0005190003&foldertype=_Equi&wplist=DE0005190003&active=overview&wpbpl=
# bei onvista mit http://aktien.onvista.de/snapshot.html?ID_OSI=81490

# wallstreet geht nicht mehr

				if($service eq 'wallstreet')
				{
					$get_html = get('http://www.wallstreet-online.de/si/?k=' . $wkn_isn);		
					$get_html =~ m/Letzter Kurs(.*)WKN/si;		
					$get_html = "$1";		
					$get_html =~ m/(.*)WKN/si;		
					$get_html = "$1";		
					$get_html =~ m/<b>(.*)<font/si;
					$get_html = "$1";
					#---- neu 2.4.06 -------------------
					$get_html =~ m/s12b(.*)<img/si;
					$get_html = "$1";
					$get_html =~ m/<b>(.*)<\/b>/si;
					$get_html = "$1";
					#-----------------------------------
		
					$get_html =~ s/\.//g;		
					$get_html =~ s/,/./g;	
				}

print "<value>";
print "service:" . $service;
print "|";
print "id:" . $wkn_isn;
print "|";
print "price:" . $get_html;
print "</value>";

}else{

print "<value>";
print "service:" . 'error';
print "|";
print "id:" . 'error';
print "|";
print "price:" . 'error';
print "|";

print $k;
print "|";
print "service:" . $service;
print "|";
print "id:" . $wkn_isn;
print "|";
print "</value>";


}


# ---------------------- Endo of CODE ---------------------------------------------------------


