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


my $v_s = param("v_s");
my $v_u = param("v_u");
my $type = param("type");
my $type = param("type");
my $toMoveId = param("toMoveId");
my $targetId= param("targetId");
my $originId= param("originId");
my $action = param("action");
my @arr;
my $dataIds;
my @values;

my $objDataBusinessLayer = DataBusinessLayer->new();



#  var url = "./ajaxCopyPasteExplorer.pl?type=data&v_u=" + globalUser + "&v_s=" + globalSession + "&toMoveId=" + idOfDataElementToCopy  + "&targetId=" + id + "&action=" + moveCopyPasteAction;
		
if($type eq 'data'){

	@arr = $objDataBusinessLayer->prepareCross($targetId);

	if($action eq 'c'){
		# copy paste action
		
		$dataIds = $arr[3];
		if(length($dataIds) > 1){
			$dataIds = $dataIds . ", " .  $toMoveId;
		}else{
			$dataIds =  $toMoveId;
		}
		$objDataBusinessLayer->updateCross($arr[1], $arr[2], $dataIds, $targetId);
	}

	if($action eq 'm'){
		# move action
		# first we add like in copy action 
		$dataIds = $arr[3];
		if(length($dataIds) > 1){
			$dataIds = $dataIds . ", " .  $toMoveId;
		}else{
			$dataIds =  $toMoveId;
		}
		$objDataBusinessLayer->updateCross($arr[1], $arr[2], $dataIds, $targetId);

		# now we remove from source folder
		@arr = $objDataBusinessLayer->prepareCross($originId);
		$dataIds = $arr[3];
		$dataIds =~ s/ //g;	

  		@values = split(',', $dataIds);

		$dataIds = "";

  		foreach my $val (@values) {

			if($toMoveId eq $val){
				# do nothing because we want to ignore
			}else{
				if($dataIds eq ""){
					$dataIds = $val; 
				}else{
					$dataIds = $dataIds . ", " . $val; 
				}
				
			}
  		}

		# now set the values in the database again
		$objDataBusinessLayer->updateCross($arr[1], $arr[2], $dataIds, $originId);

	}
}

if($type eq 'folder'){

	@arr = $objDataBusinessLayer->prepareCross($toMoveId);

	if( $targetId eq $toMoveId){
		# do nothing because pasting into itself makes no sense
	}else{
		if($targetId ne ''){
			if($toMoveId ne ''){
				$objDataBusinessLayer->updateCross($targetId, $arr[2], $arr[3], $toMoveId);
			}
		}
		
	}

}


exit 0;