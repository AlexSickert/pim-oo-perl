#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;
use DBI;


eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm`;



if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}

# =======================================================================================
print  "Content-type: text/html;Charset=iso-8859-1". "\n\n"; 
# =======================================================================================

# ---------------------- REQUEST VARIABLES --------------------------------------------------
my $params = CGI->new();
my $currVal = $params->param("currVal");
my $id = $params->param("id ");

# ---------------------- VARIABLES  ---------------------------------------------------------
my $objDBL = DataBusinessLayer->new();

# ---------------------- CODE---------------------------------------------------------

if($currVal eq "open"){
$objDBL->setStatusTimesheet($id, 'billed');
print "billed";
}

if($currVal eq "billed"){
$objDBL->setStatusTimesheet($id, 'open');
print "open";
}
# ---------------------- END OF CODE---------------------------------------------------------
exit 0;