#!/usr/bin/perl


use strict;
use CGI qw(:standard);
use warnings;

my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_second = (localtime())[0];
my $v_minute = (localtime())[1];
my $v_year = (localtime())[5];
my $v_day_of_week = (localtime())[6];

print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
print "pingresult: " . $v_year . $v_month . $v_day .  $v_hour .  $v_minute . $v_second;

exit 0;
