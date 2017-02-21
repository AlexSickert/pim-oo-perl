#!/usr/bin/perl

use lib "../classes";
use strict;
use CGI qw(:standard);
use warnings;
use MailBusinessLayer;

# ----------------------------------------------------------------------------------
my $folder = param("folderId") . "";
my $id = param("id");

# ----------------------------------------------------------------------------------

my $objMailBusinessLayer = MailBusinessLayer->new();
# ----------------------------------------------------------------------------------
print  "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";

# steps necessary:

# 1. if category = unread then run this method


$objMailBusinessLayer->moveMail($id, $folder );

print "OK";

# ----------------------------------------------------------------------------------

exit 0