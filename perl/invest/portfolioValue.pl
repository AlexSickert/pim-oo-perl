#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;
use LWP::Simple;

require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/LanguageBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailSender.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailParser.pm';



if($@) { 
	print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
	print "Error evaluating objects: $@"; 
}else{
	# print  "Content-type: text/html;Charset=iso-8859-1". "\n\n"; 
}

# ======================= PARAMETERS ==================================================
my $v_u = param("v_u");
my $v_s = param("v_s");
my $v_action = param("action");
my $v_content = param("content");


if (! defined $v_s){
	$v_s = "";
}

if (! defined $v_u){
	$v_u = "";
}

if (! defined $v_action){
	$v_action= "show";
}

if (! defined $v_content){
	$v_content = "";
}

# ======================= OBJECTS =======================================================
my $objConfig = PageConfig->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objNavigation = Navigation->new();
my $page = Page->new();
my $objForm = Form->new();
my $csv = CvsTable->new();
# ======================= VARIABLES =======================================================
my $content;
my $contentHtml;
my $area;
my $line;
my @rows;
my @fields;
my $field;
my $formulas;
my $countColumn;
my $countRow;
my $calcInitString;
my $maxCol;
$maxCol = 40;  # tables are always 20 cols wide
my $i;
my @chars;
# =======================================================================================

$page->setTitle($objConfig->get("page-title"));
$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'data.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');
$page->addJavaScript($objConfig->jsPath() . 'data.js');
$page->addJavaScript($objConfig->jsPath() . 'ajax.js');
$page->addJavaScript($objConfig->jsPath() . 'TableCalc.js');

if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# =======================================================================================
	$page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"invest")  );
	$page->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);
	$page->addPositionContainerAbsoluteOnWindowResize("navigation", "TOP", "LEFT", 5, 5, 5,1);


	if( $v_action eq "show" ||  $v_action eq "" || $v_action eq "save"){

		if($v_action eq "save"){
			$v_content  =~ s/'/&apos;/i;
			$objAdminBusinessLayer->setParameter('invest','portfolio-construct', $v_content);
		}

		$content = $objAdminBusinessLayer->getParameter('invest','portfolio-construct');


		# create array with table headers
		@chars = split(",", "0,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,AV,AW,AX,AY,AZ");


		# transofrmation needs to take place here
		# split on all \n
		$content =~ s/\n\r/\n/i;
		$content =~ s/\r\n/\n/i;
		$content =~ s/\r/\n/i;
		$content =~ s/\n\n/\n/i;
		$content =~ s/\n\n/\n/i;
		@rows = (split("\n", $content ));	
		
		$contentHtml = "<table>";

		# create header row
		$contentHtml .= "<tr>";
		for($i = 0; $i <= $maxCol; $i++){
			#$contentHtml .= "<td id=\"" .  $i . "X" . "0" . "\"><b>" . $chars[$i] . " (" . $i . ")</b></td>";
			$contentHtml .= "<td id=\"" .  $i . "X" . "0" . "\"><b>" . $i . "</b></td>";
		}

		$contentHtml .= "</tr>";
		$countRow = 1;
		foreach ( @rows) {			
			$countColumn = 1;
			$contentHtml .= "<tr>";

			$contentHtml .= "<td id=\"0X" . $countRow . "\"><b>" . $countRow  . "</b></td>";

			$line = $_;
			@fields = (split(";", $line ));	
			foreach ( @fields) {				
				$contentHtml .= "<td id=\"" .  $countColumn . "X" . $countRow . "\" onclick=\"Calculator.setFormulaForEdit('" .  $countColumn . "X" . $countRow . "');\">";
				$field = $_;				
				
				# if filed starts with = then we have a formula and we need to make all uppercase
				if(substr ($field,0,1) eq "="){
					$field =~ s/=//i;
					$field =~ s/"/\\"/gi;
					chomp($field);
					$calcInitString = "Calculator.execute(" . $countColumn . "," . $countRow . ",\"" . $field  ."\")";
					$calcInitString =~ s/\r//i;
					$calcInitString =~ s/\n//i;
					$formulas .= "\n" . $calcInitString .  ";\n";


					$field = "VALUE?";
				}

				$contentHtml .= $field;
				$contentHtml .= "</td>";
				$countColumn = $countColumn + 1;
			}

			# fill rest of columns
			for($i = $countColumn; $i <= $maxCol; $i++){
				$contentHtml .= "<td id=\"" .  $i . "X" . $countRow . "\" onclick=\"Calculator.setFormulaForEdit('" .  $countColumn  . "X" . $countRow . "');\">&nbsp;</td>";
				#$contentHtml .= "<td id=\"" .  $i . "X" . $countRow . "\" onclick=\"alert(123)\">&nbsp;</td>";
			}

			$contentHtml .= "</tr>";
			$countRow = $countRow + 1;
		}	
		$contentHtml .= "</table>";

		# add javascript content

		$contentHtml .= "\n<script>\n\n";
		#$contentHtml .="alert('hallo');\n";
		$contentHtml .="function calcLoop(){";
		$contentHtml .="\ntry{\n";
		#$contentHtml .="alert('hallo');\n";
		$contentHtml .= $formulas;
		$contentHtml .= "\n";
		$contentHtml .= "coreLogInfo(\"calculation finished\");\n";
		$contentHtml .= "window.setTimeout(\"calcLoop()\", 1000);\n";

		$contentHtml .="}catch(e){\n";
		$contentHtml .="alert(e);\n";
		$contentHtml .="}\n";
		$contentHtml .= "}\n";
		$contentHtml .="window.setTimeout(\"calcLoop()\", 1000);\n";
		$contentHtml .="</script>\n";

		# loop through all lines and create a table
		# for all fileds that start wiht = sign put them in a javascript block and set default value to Error

		$objForm ->addHidden('action', 'edit');
		$objForm ->addHidden('v_u',$v_u);
		$objForm ->addHidden('v_s',$v_s);
		$objForm ->addContainer(1, 'xxx','yyy','input', $page->getJavaScriptButton('myname','myclass','save','alert(123)') . $page->getInput('formulaInputId','formulaIdClass','none') . $page->getInput('formulaInput','formulaInputClass','yy'));
		$objForm ->addContainer(1, 'xxx','yyy','values',$contentHtml);
		$objForm ->addButton(1, 'savebutton','f_databutton','edit','sendMyForm();');
		$page->addContainer('content','navigation',$objForm->getForm('portfolioValue.pl') );
	}else{
		# adding the content - a simple text area that is stored in on common purpose field
		$content = $objAdminBusinessLayer->getParameter('invest','portfolio-construct');
		$objForm ->addArea(1, 'content','f_dataform','portfolio',$content);
		$objForm ->addButton(1, 'savebutton','f_databutton','save','sendMyForm();');
		$objForm ->addHidden('v_u',$v_u);
		$objForm ->addHidden('v_s',$v_s);
		$objForm ->addHidden('action', 'save');
		$page->addContainer('content','navigation',$objForm->getForm('portfolioValue.pl') );
	}

	$page->positionContainerAbsolut("content", "TOP", "LEFT", 10, 10, 100,10);
	$page->addPositionContainerAbsoluteOnWindowResize("content", "TOP", "LEFT", 10, 10, 100,10);

	$page->setEncoding('xhtml');
	$page->initialize;
	$page->display;
# =======================================================================================
}else{

}


# =======================================================================================

# ---------------------- End of CODE ---------------------------------------------------------

package CvsTable;

# -----------------------------------------------------------------------------------
#
#
#
#
# -----------------------------------------------------------------------------------

	# ----------------------------------------------------------------------------------------------------------------------------------
	# constructor
	# ----------------------------------------------------------------------------------------------------------------------------------
	sub new {
		my ($class) = @_;
		my $self =
		{ _col1 => 0, 
		_value => undef };
		$self->{content}  = [[]];
		$self->{links_id}  = [];	
		bless $self, $class;
		return $self;
	}
	# ----------------------------------------------------------------------------------------------------------------------------------
	# set the string and transform to object
	# the method also checks the maximal size of columns and adjusts the arrays accordingly
	# ----------------------------------------------------------------------------------------------------------------------------------
	sub setContent{
	}
	# ----------------------------------------------------------------------------------------------------------------------------------
	# transform back to csv string
	# ----------------------------------------------------------------------------------------------------------------------------------
	sub getContent{
	}
	# ----------------------------------------------------------------------------------------------------------------------------------
	# set field by ID - id is colXRwo
	# ----------------------------------------------------------------------------------------------------------------------------------
	sub setFiledById{
	}
	# ----------------------------------------------------------------------------------------------------------------------------------
	# set field by XY coordinates - uses xy parameters and then fires the setFieldbyID 
	# ----------------------------------------------------------------------------------------------------------------------------------
	sub setFiledByXy{
	}
	# ----------------------------------------------------------------------------------------------------------------------------------
	# get field by ID - id is colXRwo
	# ----------------------------------------------------------------------------------------------------------------------------------
	sub getFiledById{
	}
	# ----------------------------------------------------------------------------------------------------------------------------------
	# get field by XY coordinates - uses xy parameters and then fires the setFieldbyID 
	# ----------------------------------------------------------------------------------------------------------------------------------
	sub getFiledByXy{
	}
	# ----------------------------------------------------------------------------------------------------------------------------------
	# add row - adds a row at the end of the table
	# returns the index of the added row - to be used to cread ids
	# ----------------------------------------------------------------------------------------------------------------------------------
	sub addRow{
	}
	# ----------------------------------------------------------------------------------------------------------------------------------
	# add a column- adds a column at the end of the table
	# returns the index of the added column - to be used to create ids
	# ----------------------------------------------------------------------------------------------------------------------------------
	sub addColumn{
	}
	# ----------------------------------------------------------------------------------------------------------------------------------
	# get ow as an array - to be used to loop through the rows etc.
	# ----------------------------------------------------------------------------------------------------------------------------------
	sub getRow{
	}
	# ----------------------------------------------------------------------------------------------------------------------------------
	# get number of rows
	# ----------------------------------------------------------------------------------------------------------------------------------
	sub getMaxY{
	}
	# ----------------------------------------------------------------------------------------------------------------------------------
	# get number of columns
	# ----------------------------------------------------------------------------------------------------------------------------------
	sub getMaxX{
	}
0;

