#!/usr/bin/perl

use lib "../classes";
use strict;
use CGI qw(:standard);
use warnings;
use Page;
use Table;
use Grid;
use AdminBusinessLayer;
use DataBusinessLayer;
use Form;
use Navigation;
use PageConfig;
# =======================================================================================

# I THINK THIS FILE CAN BE DELETED AS I DONT USE ITS FUNCTIONALITY

# =======================================================================================
#my @arr;
#my @inner;
#my $page = Page->new();
#my $objAdminBusinessLayer = AdminBusinessLayer->new();
#my $objDataBusinessLayer = DataBusinessLayer->new();

# =======================================================================================
#my $system = param('system');
#my $dvd = param('dvd');
#my $path = param('path');

# encoding of path for mysql

#$objDataBusinessLayer->registerFile($system ,$dvd , $path );


#$page->addContent(  'ok'  );

#$page->setEncoding('xhtml');
#$page->initialize;
#$page->display;



exit 0