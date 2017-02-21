#!/usr/bin/perl



#CREATE TABLE IF NOT EXISTS `dictionary_statistics` (
#  `id` bigint(20) NOT NULL AUTO_INCREMENT,
#  `id_dictionary` bigint(20) DEFAULT NULL,
#  `L1` int(11) DEFAULT NULL,
#  `L2` int(11) DEFAULT NULL,
#  `pos` int(11) DEFAULT NULL,
#  `neg` int(11) DEFAULT NULL,
#  `ratio` int(11) DEFAULT NULL,
#  `counter` decimal(10,3) DEFAULT NULL,
#  `last_access` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
#  `last_access_number` bigint(20) DEFAULT NULL,
#  UNIQUE KEY `id` (`id`)
#) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;


use strict;
use CGI qw(:standard);
use warnings;

use Time::HiRes;
my $start = [ Time::HiRes::gettimeofday( ) ];

require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm';
# require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/LanguageBusinessLayer.pm';

if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}

# ==========================================================================================================================

my $objPage = Page->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = LanguageBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();

# ==========================================================================================================================

# insert bei request

my $L1 ;
my $L2 ;
my $L3 ;
my $L4 ;
my $L5 ;
my $L6 ;
my $L7 ;
my $tableAndForm ;
my $sql_string = "";
my @zeile = ();
my @languages = ();
my @languageid = ();
my @values = ();
my $countLanguages = 0;
my $fromLanguage = param("fromLanguage");
my $toLanguage = param("toLanguage");
my $result = param("result");
my $language = param("language");
my $v_s  = param("v_s");
my $v_u  = param("v_u");
my $id  = param("id");
my $counter;
my $db;
my $sql;
my $randomRecord;
my $recCount;
my $maxRatio;
my $methodOfSelection;



# =========================================================================================================================

$objPage ->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"language")  );
$objPage ->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);
  
# resultat von der letzten abfrage eintragen
$objDataBusinessLayer->registerResult($result, $id, $fromLanguage, $toLanguage);

# =========================================================================================================================

## dieser teil wir immer ausgefuehrt !!!!!!!!!
#if($methodOfSelection ne '999'){
## zufalls eintrag auswählen - 2 methoden gibt es - davon zu 2 dritteln 
#    @zeile = $objDataBusinessLayer->getRandomContent();
#    
#        $id = $zeile[0] . "";
#        $L1 = $zeile[1] . "";
#        $L2 = $zeile[4] . "";
#        $L3 = $zeile[7] . "";
#        $L4 = $zeile[10] . "";
#        $L5 = $zeile[13] . "";
#        $L6 = $zeile[16] . "";
#        $L7 = $zeile[19] . "";
#    
#    $countLanguages = 0;
#    
#    if ($L1 ne ''){
#        $languages[$countLanguages] = 'deutsch';
#        $values[$countLanguages] = decodeValue($L1);
#        $languageid[$countLanguages] = "1";        
#        $countLanguages +=1;
#    }
#    
#    if ($L2 ne ''){
#        $languages[$countLanguages] = 'englisch';
#        $values[$countLanguages] = decodeValue($L2);
#        $languageid[$countLanguages] = "2"; 
#        $countLanguages +=1;
#    }
#    
#    if ($L3 ne ''){
#        $languages[$countLanguages] = 'spanisch';
#        $values[$countLanguages] = decodeValue($L3);
#        $languageid[$countLanguages] = "3"; 
#        $countLanguages +=1;
#    }
#    
#    if ($L4 ne ''){
#        $languages[$countLanguages] = 'französisch';
#        $values[$countLanguages] = decodeValue($L4);
#        $languageid[$countLanguages] = "4"; 
#        $countLanguages +=1;
#    }
#    
#    if ($L5 ne ''){
#        $languages[$countLanguages] = 'italienisch';
#        $values[$countLanguages] = decodeValue($L5);
#        $languageid[$countLanguages] = "5"; 
#        $countLanguages +=1;
#    }
#    if ($L6 ne ''){
#        $languages[$countLanguages] = 'portugiesisch';
#        $values[$countLanguages] = decodeValue($L6);
#        $languageid[$countLanguages] = "6"; 
#        $countLanguages +=1;
#    }
#    
#     if ($L7 ne ''){
#        $languages[$countLanguages] = 'portugiesisch';
#        $values[$countLanguages] = decodeValue($L7);
#        $languageid[$countLanguages] = "7"; 
#        $countLanguages +=1;
#    }
#           
#    srand(); 
#    $fromLanguage = int( rand($countLanguages) );
#    srand();
#    $toLanguage = int( rand($countLanguages) );
#    if($fromLanguage == $toLanguage){
#        while($fromLanguage == $toLanguage){
#            srand();
#            $toLanguage = int( rand($countLanguages) );
#        }
#    }
#}
# =========================================================================================================================
srand();
$methodOfSelection = int( rand(3) );

if($methodOfSelection eq '1'){

    # neue methode - d.h. nur in 1 drittel der fälle die ibere methode verwenden:

    srand();
    $randomRecord = int( rand(3) );
    $recCount = 0;

    @zeile = $objDataBusinessLayer->getContentNotLearned();
    
    $id = $zeile[0];
    $L1 = $zeile[1];
    $L2 = $zeile[2];     
    $maxRatio = $zeile[3];  
    
    $fromLanguage = substr($L1,1) - 1;
    $toLanguage = substr($L2,1) - 1;

    @zeile = $objDataBusinessLayer->getOneWord($L1 , $L2 , $id);
    
    $values[$fromLanguage] = decodeOpenOffice(decodeValue($zeile[0]));
    $values[$toLanguage] = decodeOpenOffice(decodeValue($zeile[1]));
    
    $languages[0] = "deutsch";
    $languages[1] = "englisch";
    $languages[2] = "spanisch";
    $languages[3] = "franz&ouml;sisch";
    $languages[4] = "italienisch";
    $languages[5] = "portugiesisch";
    $languages[6] = "russisch";

    $languageid[0] = "1"; 
    $languageid[1] = "2"; 
    $languageid[2] = "3"; 
    $languageid[3] = "4"; 
    $languageid[4] = "5"; 
    $languageid[5] = "6"; 
    $languageid[6] = "7"; 

}else{

    # if we want to get random content
    @zeile = $objDataBusinessLayer->getRandomContent();
    
        $id = $zeile[0] . "";
        $L1 = $zeile[1] . "";
        $L2 = $zeile[4] . "";
        $L3 = $zeile[7] . "";
        $L4 = $zeile[10] . "";
        $L5 = $zeile[13] . "";
        $L6 = $zeile[16] . "";
        $L7 = $zeile[19] . "";
    
    $countLanguages = 0;
    
    if ($L1 ne ''){
        $languages[$countLanguages] = 'deutsch';
        $values[$countLanguages] = decodeOpenOffice(decodeValue($L1));
        $languageid[$countLanguages] = "1";        
        $countLanguages +=1;
    }
    
    if ($L2 ne ''){
        $languages[$countLanguages] = 'englisch';
        $values[$countLanguages] = decodeOpenOffice(decodeValue($L2));
        $languageid[$countLanguages] = "2"; 
        $countLanguages +=1;
    }
    
    if ($L3 ne ''){
        $languages[$countLanguages] = 'spanisch';
        $values[$countLanguages] = decodeOpenOffice(decodeValue($L3));
        $languageid[$countLanguages] = "3"; 
        $countLanguages +=1;
    }
    
    if ($L4 ne ''){
        $languages[$countLanguages] = 'franz&ouml;sisch';
        $values[$countLanguages] = decodeOpenOffice(decodeValue($L4));
        $languageid[$countLanguages] = "4"; 
        $countLanguages +=1;
    }
    
    if ($L5 ne ''){
        $languages[$countLanguages] = 'italienisch';
        $values[$countLanguages] = decodeOpenOffice(decodeValue($L5));
        $languageid[$countLanguages] = "5"; 
        $countLanguages +=1;
    }
    if ($L6 ne ''){
        $languages[$countLanguages] = 'portugiesisch';
        $values[$countLanguages] = decodeOpenOffice(decodeValue($L6));
        $languageid[$countLanguages] = "6"; 
        $countLanguages +=1;
    }
    
     if ($L7 ne ''){
        $languages[$countLanguages] = 'portugiesisch';
        $values[$countLanguages] = decodeOpenOffice(decodeValue($L7));
        $languageid[$countLanguages] = "7"; 
        $countLanguages +=1;
    }
     
    # now we choose from the available combination by random one      
    srand(); 
    $fromLanguage = int( rand($countLanguages) );
    srand();
    $toLanguage = int( rand($countLanguages) );
    if($fromLanguage == $toLanguage){
        while($fromLanguage == $toLanguage){
            srand();
            $toLanguage = int( rand($countLanguages) );
        }
    }

}
# ==========================================================================================================================

my $objTable = Table->new();

$objPage->setEncoding('xhtml');
$objPage->initialize();


$objPage->setTitle($objConfig->get("page-title"));

$objPage->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'classes.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'language.css');
$objPage->addJavaScript($objConfig->jsPath() . 'classes.js');
$objPage->addJavaScript($objConfig->jsPath() . 'language.js');


#$objPage->addContent( modulHeader($v_u,$v_s,'language') );
#$objPage->addContent( languageHeader($v_u,$v_s) );

$objTable->addRow();

$objTable->addField('xxx','vokabel_label','&nbsp;');
$objTable->addField('xxx','vokabel_label',$languages[$fromLanguage]);
$objTable->addField('xxx','vokabel_label',$values[$fromLanguage]);

$objTable->addRow();

$objTable->addField('id-of-field','vakabel_label',$objPage->getPopLink('vokabel_label','./edit.pl?v_id='.$id,'?') );
$objTable->addField('xxx','vokabel_label',$languages[$toLanguage]);
$objTable->addField('xxx','vokabel_label', $objPage->getContainer('vokabel','hiddenVoc',$values[$toLanguage]) );

$objTable->addRow();

$objTable->addField('id-of-field','vokabel_label',$objPage->getButton('OK','vokabel_button','OK','sendOk()'));
$objTable->addField('id-of-field','vokabel_label',$objPage->getButton('Answer','vokabel_button','? ? ?','showHide(\'vokabel\')'));
$objTable->addField('id-of-field','vokabel_label',$objPage->getButton('NO','vokabel_button','NO','sendNo()'));


my $elapsed = Time::HiRes::tv_interval( $start );


if($methodOfSelection eq '1'){
    $objTable->addRow();
    $objTable->addField('','',"sorted " . $objDataBusinessLayer->getVersion() . "  " . $elapsed);
    $objTable->addField('','',"&nbsp;"  );
    $objTable->addField('','',"&nbsp;"  );
}else{
    $objTable->addRow();
    $objTable->addField('','',"random " . $objDataBusinessLayer->getVersion() . "  " . $elapsed);
    $objTable->addField('','',"&nbsp;"  );
    $objTable->addField('','',"&nbsp;"  );
}

$tableAndForm = "";
$tableAndForm .=  $objPage->getHidden('v_s',$v_s);
$tableAndForm .=  $objPage->getHidden('v_u',$v_u);
$tableAndForm .=  $objPage->getHidden('id',$id);
$tableAndForm .=  $objPage->getHidden('toLanguage',$languageid[$toLanguage]);
$tableAndForm .=  $objPage->getHidden('fromLanguage',$languageid[$fromLanguage]);
$tableAndForm .=  $objPage->getHidden('result','');

$tableAndForm .=  $objTable->getTable();

$objPage->addContent(  $objPage->getForm('this_form','form_class','./index.pl', $objPage->getContainer('centeredContainer', 'language_positioner', $tableAndForm)   ));

$objPage->positionContainerAbsolut("centeredContainer", "CENTER", "CENTER", 100, 100, 100,100);

# ====== ab hier darf kein content mehr agefügt werden ==================================
$objPage->display();
 print $L1 . $L2 . $L3 . $L4 . $L5 . $L6;
# ==========================================================================================================================

sub encodeValue{    
    my $codestring = "";    
    $codestring = $_[0];
    $codestring =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;
    return $codestring; 
}

sub decodeValue{    
    my $codestring = "";    
    $codestring = $_[0];
    $codestring =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;
    return $codestring;      
}

sub decodeOpenOffice{
	my $codestring = "";    
	$codestring = $_[0];
	$codestring =~ s/_59_/ /g;

	$codestring =~ s/_1000_/&#1000;/g;
	$codestring =~ s/_1001_/&#1001;/g;
	$codestring =~ s/_1002_/&#1002;/g;
	$codestring =~ s/_1003_/&#1003;/g;
	$codestring =~ s/_1004_/&#1004;/g;
	$codestring =~ s/_1005_/&#1005;/g;
	$codestring =~ s/_1006_/&#1006;/g;
	$codestring =~ s/_1007_/&#1007;/g;
	$codestring =~ s/_1008_/&#1008;/g;
	$codestring =~ s/_1009_/&#1009;/g;
	$codestring =~ s/_1010_/&#1010;/g;
	$codestring =~ s/_1011_/&#1011;/g;
	$codestring =~ s/_1012_/&#1012;/g;
	$codestring =~ s/_1013_/&#1013;/g;
	$codestring =~ s/_1014_/&#1014;/g;
	$codestring =~ s/_1015_/&#1015;/g;
	$codestring =~ s/_1016_/&#1016;/g;
	$codestring =~ s/_1017_/&#1017;/g;
	$codestring =~ s/_1018_/&#1018;/g;
	$codestring =~ s/_1019_/&#1019;/g;
	$codestring =~ s/_1020_/&#1020;/g;
	$codestring =~ s/_1021_/&#1021;/g;
	$codestring =~ s/_1022_/&#1022;/g;
	$codestring =~ s/_1023_/&#1023;/g;
	$codestring =~ s/_1024_/&#1024;/g;
	$codestring =~ s/_1025_/&#1025;/g;
	$codestring =~ s/_1026_/&#1026;/g;
	$codestring =~ s/_1027_/&#1027;/g;
	$codestring =~ s/_1028_/&#1028;/g;
	$codestring =~ s/_1029_/&#1029;/g;
	$codestring =~ s/_1030_/&#1030;/g;
	$codestring =~ s/_1031_/&#1031;/g;
	$codestring =~ s/_1032_/&#1032;/g;
	$codestring =~ s/_1033_/&#1033;/g;
	$codestring =~ s/_1034_/&#1034;/g;
	$codestring =~ s/_1035_/&#1035;/g;
	$codestring =~ s/_1036_/&#1036;/g;
	$codestring =~ s/_1037_/&#1037;/g;
	$codestring =~ s/_1038_/&#1038;/g;
	$codestring =~ s/_1039_/&#1039;/g;
	$codestring =~ s/_1040_/&#1040;/g;
	$codestring =~ s/_1041_/&#1041;/g;
	$codestring =~ s/_1042_/&#1042;/g;
	$codestring =~ s/_1043_/&#1043;/g;
	$codestring =~ s/_1044_/&#1044;/g;
	$codestring =~ s/_1045_/&#1045;/g;
	$codestring =~ s/_1046_/&#1046;/g;
	$codestring =~ s/_1047_/&#1047;/g;
	$codestring =~ s/_1048_/&#1048;/g;
	$codestring =~ s/_1049_/&#1049;/g;
	$codestring =~ s/_1050_/&#1050;/g;
	$codestring =~ s/_1051_/&#1051;/g;
	$codestring =~ s/_1052_/&#1052;/g;
	$codestring =~ s/_1053_/&#1053;/g;
	$codestring =~ s/_1054_/&#1054;/g;
	$codestring =~ s/_1055_/&#1055;/g;
	$codestring =~ s/_1056_/&#1056;/g;
	$codestring =~ s/_1057_/&#1057;/g;
	$codestring =~ s/_1058_/&#1058;/g;
	$codestring =~ s/_1059_/&#1059;/g;
	$codestring =~ s/_1060_/&#1060;/g;
	$codestring =~ s/_1061_/&#1061;/g;
	$codestring =~ s/_1062_/&#1062;/g;
	$codestring =~ s/_1063_/&#1063;/g;
	$codestring =~ s/_1064_/&#1064;/g;
	$codestring =~ s/_1065_/&#1065;/g;
	$codestring =~ s/_1066_/&#1066;/g;
	$codestring =~ s/_1067_/&#1067;/g;
	$codestring =~ s/_1068_/&#1068;/g;
	$codestring =~ s/_1069_/&#1069;/g;
	$codestring =~ s/_1070_/&#1070;/g;
	$codestring =~ s/_1071_/&#1071;/g;
	$codestring =~ s/_1072_/&#1072;/g;
	$codestring =~ s/_1073_/&#1073;/g;
	$codestring =~ s/_1074_/&#1074;/g;
	$codestring =~ s/_1075_/&#1075;/g;
	$codestring =~ s/_1076_/&#1076;/g;
	$codestring =~ s/_1077_/&#1077;/g;
	$codestring =~ s/_1078_/&#1078;/g;
	$codestring =~ s/_1079_/&#1079;/g;
	$codestring =~ s/_1080_/&#1080;/g;
	$codestring =~ s/_1081_/&#1081;/g;
	$codestring =~ s/_1082_/&#1082;/g;
	$codestring =~ s/_1083_/&#1083;/g;
	$codestring =~ s/_1084_/&#1084;/g;
	$codestring =~ s/_1085_/&#1085;/g;
	$codestring =~ s/_1086_/&#1086;/g;
	$codestring =~ s/_1087_/&#1087;/g;
	$codestring =~ s/_1088_/&#1088;/g;
	$codestring =~ s/_1089_/&#1089;/g;
	$codestring =~ s/_1090_/&#1090;/g;
	$codestring =~ s/_1091_/&#1091;/g;
	$codestring =~ s/_1092_/&#1092;/g;
	$codestring =~ s/_1093_/&#1093;/g;
	$codestring =~ s/_1094_/&#1094;/g;
	$codestring =~ s/_1095_/&#1095;/g;
	$codestring =~ s/_1096_/&#1096;/g;
	$codestring =~ s/_1097_/&#1097;/g;
	$codestring =~ s/_1098_/&#1098;/g;
	$codestring =~ s/_1099_/&#1099;/g;
	$codestring =~ s/_1100_/&#1100;/g;
	$codestring =~ s/_1101_/&#1101;/g;
	$codestring =~ s/_1102_/&#1102;/g;
	$codestring =~ s/_1103_/&#1103;/g;
	$codestring =~ s/_1104_/&#1104;/g;
	$codestring =~ s/_1105_/&#1105;/g;
	$codestring =~ s/_1106_/&#1106;/g;
	$codestring =~ s/_1107_/&#1107;/g;
	$codestring =~ s/_1108_/&#1108;/g;
	$codestring =~ s/_1109_/&#1109;/g;
	$codestring =~ s/_1110_/&#1110;/g;
	$codestring =~ s/_1111_/&#1111;/g;
	$codestring =~ s/_1112_/&#1112;/g;
	$codestring =~ s/_1113_/&#1113;/g;
	$codestring =~ s/_1114_/&#1114;/g;
	$codestring =~ s/_1115_/&#1115;/g;
	$codestring =~ s/_1116_/&#1116;/g;
	$codestring =~ s/_1117_/&#1117;/g;
	$codestring =~ s/_1118_/&#1118;/g;
	$codestring =~ s/_1119_/&#1119;/g;
	$codestring =~ s/_1120_/&#1120;/g;
	$codestring =~ s/_1121_/&#1121;/g;
	$codestring =~ s/_1122_/&#1122;/g;
	$codestring =~ s/_1123_/&#1123;/g;
	$codestring =~ s/_1124_/&#1124;/g;
	$codestring =~ s/_1125_/&#1125;/g;
	$codestring =~ s/_1126_/&#1126;/g;
	$codestring =~ s/_1127_/&#1127;/g;
	$codestring =~ s/_1128_/&#1128;/g;
	$codestring =~ s/_1129_/&#1129;/g;
	$codestring =~ s/_1130_/&#1130;/g;
	$codestring =~ s/_1131_/&#1131;/g;
	$codestring =~ s/_1132_/&#1132;/g;
	$codestring =~ s/_1133_/&#1133;/g;
	$codestring =~ s/_1134_/&#1134;/g;
	$codestring =~ s/_1135_/&#1135;/g;
	$codestring =~ s/_1136_/&#1136;/g;
	$codestring =~ s/_1137_/&#1137;/g;
	$codestring =~ s/_1138_/&#1138;/g;
	$codestring =~ s/_1139_/&#1139;/g;
	$codestring =~ s/_1140_/&#1140;/g;
	$codestring =~ s/_1141_/&#1141;/g;
	$codestring =~ s/_1142_/&#1142;/g;
	$codestring =~ s/_1143_/&#1143;/g;
	$codestring =~ s/_1144_/&#1144;/g;
	$codestring =~ s/_1145_/&#1145;/g;
	$codestring =~ s/_1146_/&#1146;/g;
	$codestring =~ s/_1147_/&#1147;/g;
	$codestring =~ s/_1148_/&#1148;/g;
	$codestring =~ s/_1149_/&#1149;/g;
	$codestring =~ s/_1150_/&#1150;/g;
	$codestring =~ s/_1151_/&#1151;/g;
	$codestring =~ s/_1152_/&#1152;/g;
	$codestring =~ s/_1153_/&#1153;/g;
	$codestring =~ s/_1154_/&#1154;/g;
	$codestring =~ s/_1155_/&#1155;/g;
	$codestring =~ s/_1156_/&#1156;/g;
	$codestring =~ s/_1157_/&#1157;/g;
	$codestring =~ s/_1158_/&#1158;/g;
	$codestring =~ s/_1159_/&#1159;/g;
	$codestring =~ s/_1160_/&#1160;/g;
	$codestring =~ s/_1161_/&#1161;/g;
	$codestring =~ s/_1162_/&#1162;/g;
	$codestring =~ s/_1163_/&#1163;/g;
	$codestring =~ s/_1164_/&#1164;/g;
	$codestring =~ s/_1165_/&#1165;/g;
	$codestring =~ s/_1166_/&#1166;/g;
	$codestring =~ s/_1167_/&#1167;/g;
	$codestring =~ s/_1168_/&#1168;/g;
	$codestring =~ s/_1169_/&#1169;/g;
	$codestring =~ s/_1170_/&#1170;/g;
	$codestring =~ s/_1171_/&#1171;/g;
	$codestring =~ s/_1172_/&#1172;/g;
	$codestring =~ s/_1173_/&#1173;/g;
	$codestring =~ s/_1174_/&#1174;/g;
	$codestring =~ s/_1175_/&#1175;/g;
	$codestring =~ s/_1176_/&#1176;/g;
	$codestring =~ s/_1177_/&#1177;/g;
	$codestring =~ s/_1178_/&#1178;/g;
	$codestring =~ s/_1179_/&#1179;/g;
	$codestring =~ s/_1180_/&#1180;/g;
	$codestring =~ s/_1181_/&#1181;/g;
	$codestring =~ s/_1182_/&#1182;/g;
	$codestring =~ s/_1183_/&#1183;/g;
	$codestring =~ s/_1184_/&#1184;/g;
	$codestring =~ s/_1185_/&#1185;/g;
	$codestring =~ s/_1186_/&#1186;/g;
	$codestring =~ s/_1187_/&#1187;/g;
	$codestring =~ s/_1188_/&#1188;/g;
	$codestring =~ s/_1189_/&#1189;/g;
	$codestring =~ s/_1190_/&#1190;/g;
	$codestring =~ s/_1191_/&#1191;/g;
	$codestring =~ s/_1192_/&#1192;/g;
	$codestring =~ s/_1193_/&#1193;/g;
	$codestring =~ s/_1194_/&#1194;/g;
	$codestring =~ s/_1195_/&#1195;/g;
	$codestring =~ s/_1196_/&#1196;/g;
	$codestring =~ s/_1197_/&#1197;/g;
	$codestring =~ s/_1198_/&#1198;/g;
	$codestring =~ s/_1199_/&#1199;/g;
	$codestring =~ s/_1200_/&#1200;/g;
	$codestring =~ s/_1201_/&#1201;/g;
	$codestring =~ s/_1202_/&#1202;/g;
	$codestring =~ s/_1203_/&#1203;/g;
	$codestring =~ s/_1204_/&#1204;/g;
	$codestring =~ s/_1205_/&#1205;/g;
	$codestring =~ s/_1206_/&#1206;/g;
	$codestring =~ s/_1207_/&#1207;/g;
	$codestring =~ s/_1208_/&#1208;/g;
	$codestring =~ s/_1209_/&#1209;/g;
	$codestring =~ s/_1210_/&#1210;/g;
	$codestring =~ s/_1211_/&#1211;/g;
	$codestring =~ s/_1212_/&#1212;/g;
	$codestring =~ s/_1213_/&#1213;/g;
	$codestring =~ s/_1214_/&#1214;/g;
	$codestring =~ s/_1215_/&#1215;/g;
	$codestring =~ s/_1216_/&#1216;/g;
	$codestring =~ s/_1217_/&#1217;/g;
	$codestring =~ s/_1218_/&#1218;/g;
	$codestring =~ s/_1219_/&#1219;/g;
	$codestring =~ s/_1220_/&#1220;/g;
	$codestring =~ s/_1221_/&#1221;/g;
	$codestring =~ s/_1222_/&#1222;/g;
	$codestring =~ s/_1223_/&#1223;/g;
	$codestring =~ s/_1224_/&#1224;/g;
	$codestring =~ s/_1225_/&#1225;/g;
	$codestring =~ s/_1226_/&#1226;/g;
	$codestring =~ s/_1227_/&#1227;/g;
	$codestring =~ s/_1228_/&#1228;/g;
	$codestring =~ s/_1229_/&#1229;/g;
	$codestring =~ s/_1230_/&#1230;/g;
	$codestring =~ s/_1231_/&#1231;/g;
	$codestring =~ s/_1232_/&#1232;/g;
	$codestring =~ s/_1233_/&#1233;/g;
	$codestring =~ s/_1234_/&#1234;/g;
	$codestring =~ s/_1235_/&#1235;/g;
	$codestring =~ s/_1236_/&#1236;/g;
	$codestring =~ s/_1237_/&#1237;/g;
	$codestring =~ s/_1238_/&#1238;/g;
	$codestring =~ s/_1239_/&#1239;/g;
	$codestring =~ s/_1240_/&#1240;/g;
	$codestring =~ s/_1241_/&#1241;/g;
	$codestring =~ s/_1242_/&#1242;/g;
	$codestring =~ s/_1243_/&#1243;/g;
	$codestring =~ s/_1244_/&#1244;/g;
	$codestring =~ s/_1245_/&#1245;/g;
	$codestring =~ s/_1246_/&#1246;/g;
	$codestring =~ s/_1247_/&#1247;/g;
	$codestring =~ s/_1248_/&#1248;/g;
	$codestring =~ s/_1249_/&#1249;/g;
	$codestring =~ s/_1250_/&#1250;/g;
	$codestring =~ s/_1251_/&#1251;/g;
	$codestring =~ s/_1252_/&#1252;/g;
	$codestring =~ s/_1253_/&#1253;/g;
	$codestring =~ s/_1254_/&#1254;/g;
	$codestring =~ s/_1255_/&#1255;/g;
	$codestring =~ s/_1256_/&#1256;/g;
	$codestring =~ s/_1257_/&#1257;/g;
	$codestring =~ s/_1258_/&#1258;/g;
	$codestring =~ s/_1259_/&#1259;/g;
	$codestring =~ s/_1260_/&#1260;/g;
	$codestring =~ s/_1261_/&#1261;/g;
	$codestring =~ s/_1262_/&#1262;/g;
	$codestring =~ s/_1263_/&#1263;/g;
	$codestring =~ s/_1264_/&#1264;/g;
	$codestring =~ s/_1265_/&#1265;/g;
	$codestring =~ s/_1266_/&#1266;/g;
	$codestring =~ s/_1267_/&#1267;/g;
	$codestring =~ s/_1268_/&#1268;/g;
	$codestring =~ s/_1269_/&#1269;/g;
	$codestring =~ s/_1270_/&#1270;/g;
	$codestring =~ s/_1271_/&#1271;/g;
	$codestring =~ s/_1272_/&#1272;/g;
	$codestring =~ s/_1273_/&#1273;/g;
	$codestring =~ s/_1274_/&#1274;/g;
	$codestring =~ s/_1275_/&#1275;/g;
	$codestring =~ s/_1276_/&#1276;/g;
	$codestring =~ s/_1277_/&#1277;/g;
	$codestring =~ s/_1278_/&#1278;/g;
	$codestring =~ s/_1279_/&#1279;/g;
	$codestring =~ s/_1280_/&#1280;/g;
	$codestring =~ s/_1281_/&#1281;/g;
	$codestring =~ s/_1282_/&#1282;/g;
	$codestring =~ s/_1283_/&#1283;/g;
	$codestring =~ s/_1284_/&#1284;/g;
	$codestring =~ s/_1285_/&#1285;/g;
	$codestring =~ s/_1286_/&#1286;/g;
	$codestring =~ s/_1287_/&#1287;/g;
	$codestring =~ s/_1288_/&#1288;/g;
	$codestring =~ s/_1289_/&#1289;/g;
	$codestring =~ s/_1290_/&#1290;/g;
	$codestring =~ s/_1291_/&#1291;/g;
	$codestring =~ s/_1292_/&#1292;/g;
	$codestring =~ s/_1293_/&#1293;/g;
	$codestring =~ s/_1294_/&#1294;/g;
	$codestring =~ s/_1295_/&#1295;/g;
	$codestring =~ s/_1296_/&#1296;/g;
	$codestring =~ s/_1297_/&#1297;/g;
	$codestring =~ s/_1298_/&#1298;/g;
	$codestring =~ s/_1299_/&#1299;/g;
	$codestring =~ s/_1300_/&#1300;/g;
	$codestring =~ s/_10_/&#10;/g;
	$codestring =~ s/_11_/&#11;/g;
	$codestring =~ s/_12_/&#12;/g;
	$codestring =~ s/_13_/&#13;/g;
	$codestring =~ s/_14_/&#14;/g;
	$codestring =~ s/_15_/&#15;/g;
	$codestring =~ s/_16_/&#16;/g;
	$codestring =~ s/_17_/&#17;/g;
	$codestring =~ s/_18_/&#18;/g;
	$codestring =~ s/_19_/&#19;/g;
	$codestring =~ s/_20_/&#20;/g;
	$codestring =~ s/_21_/&#21;/g;
	$codestring =~ s/_22_/&#22;/g;
	$codestring =~ s/_23_/&#23;/g;
	$codestring =~ s/_24_/&#24;/g;
	$codestring =~ s/_25_/&#25;/g;
	$codestring =~ s/_26_/&#26;/g;
	$codestring =~ s/_27_/&#27;/g;
	$codestring =~ s/_28_/&#28;/g;
	$codestring =~ s/_29_/&#29;/g;
	$codestring =~ s/_30_/&#30;/g;
	$codestring =~ s/_31_/&#31;/g;
	$codestring =~ s/_32_/&#32;/g;
	$codestring =~ s/_33_/&#33;/g;
	$codestring =~ s/_34_/&#34;/g;
	$codestring =~ s/_35_/&#35;/g;
	$codestring =~ s/_36_/&#36;/g;
	$codestring =~ s/_37_/&#37;/g;
	$codestring =~ s/_38_/&#38;/g;
	$codestring =~ s/_39_/&#39;/g;
	$codestring =~ s/_40_/&#40;/g;
	$codestring =~ s/_41_/&#41;/g;
	$codestring =~ s/_42_/&#42;/g;
	$codestring =~ s/_43_/&#43;/g;
	$codestring =~ s/_44_/&#44;/g;
	$codestring =~ s/_45_/&#45;/g;
	$codestring =~ s/_46_/&#46;/g;
	$codestring =~ s/_47_/&#47;/g;
	$codestring =~ s/_48_/&#48;/g;
	$codestring =~ s/_49_/&#49;/g;
	$codestring =~ s/_50_/&#50;/g;
	$codestring =~ s/_51_/&#51;/g;
	$codestring =~ s/_52_/&#52;/g;
	$codestring =~ s/_53_/&#53;/g;
	$codestring =~ s/_54_/&#54;/g;
	$codestring =~ s/_55_/&#55;/g;
	$codestring =~ s/_56_/&#56;/g;
	$codestring =~ s/_57_/&#57;/g;
	$codestring =~ s/_58_/&#58;/g;
	$codestring =~ s/_59_/&#59;/g;
	$codestring =~ s/_60_/&#60;/g;
	$codestring =~ s/_61_/&#61;/g;
	$codestring =~ s/_62_/&#62;/g;
	$codestring =~ s/_63_/&#63;/g;
	$codestring =~ s/_64_/&#64;/g;
	$codestring =~ s/_65_/&#65;/g;
	$codestring =~ s/_66_/&#66;/g;
	$codestring =~ s/_67_/&#67;/g;
	$codestring =~ s/_68_/&#68;/g;
	$codestring =~ s/_69_/&#69;/g;
	$codestring =~ s/_70_/&#70;/g;
	$codestring =~ s/_71_/&#71;/g;
	$codestring =~ s/_72_/&#72;/g;
	$codestring =~ s/_73_/&#73;/g;
	$codestring =~ s/_74_/&#74;/g;
	$codestring =~ s/_75_/&#75;/g;
	$codestring =~ s/_76_/&#76;/g;
	$codestring =~ s/_77_/&#77;/g;
	$codestring =~ s/_78_/&#78;/g;
	$codestring =~ s/_79_/&#79;/g;
	$codestring =~ s/_80_/&#80;/g;
	$codestring =~ s/_81_/&#81;/g;
	$codestring =~ s/_82_/&#82;/g;
	$codestring =~ s/_83_/&#83;/g;
	$codestring =~ s/_84_/&#84;/g;
	$codestring =~ s/_85_/&#85;/g;
	$codestring =~ s/_86_/&#86;/g;
	$codestring =~ s/_87_/&#87;/g;
	$codestring =~ s/_88_/&#88;/g;
	$codestring =~ s/_89_/&#89;/g;
	$codestring =~ s/_90_/&#90;/g;
	$codestring =~ s/_91_/&#91;/g;
	$codestring =~ s/_92_/&#92;/g;
	$codestring =~ s/_93_/&#93;/g;
	$codestring =~ s/_94_/&#94;/g;
	$codestring =~ s/_95_/&#95;/g;
	$codestring =~ s/_96_/&#96;/g;
	$codestring =~ s/_97_/&#97;/g;
	$codestring =~ s/_98_/&#98;/g;
	$codestring =~ s/_99_/&#99;/g;
	$codestring =~ s/_100_/&#100;/g;
	$codestring =~ s/_101_/&#101;/g;
	$codestring =~ s/_102_/&#102;/g;
	$codestring =~ s/_103_/&#103;/g;
	$codestring =~ s/_104_/&#104;/g;
	$codestring =~ s/_105_/&#105;/g;
	$codestring =~ s/_106_/&#106;/g;
	$codestring =~ s/_107_/&#107;/g;
	$codestring =~ s/_108_/&#108;/g;
	$codestring =~ s/_109_/&#109;/g;
	$codestring =~ s/_110_/&#110;/g;
	$codestring =~ s/_111_/&#111;/g;
	$codestring =~ s/_112_/&#112;/g;
	$codestring =~ s/_113_/&#113;/g;
	$codestring =~ s/_114_/&#114;/g;
	$codestring =~ s/_115_/&#115;/g;
	$codestring =~ s/_116_/&#116;/g;
	$codestring =~ s/_117_/&#117;/g;
	$codestring =~ s/_118_/&#118;/g;
	$codestring =~ s/_119_/&#119;/g;
	$codestring =~ s/_120_/&#120;/g;
	$codestring =~ s/_121_/&#121;/g;
	$codestring =~ s/_122_/&#122;/g;
	$codestring =~ s/_123_/&#123;/g;
	$codestring =~ s/_124_/&#124;/g;
	$codestring =~ s/_125_/&#125;/g;
	$codestring =~ s/_126_/&#126;/g;
	$codestring =~ s/_127_/&#127;/g;
	$codestring =~ s/_128_/&#128;/g;
	$codestring =~ s/_129_/&#129;/g;
	$codestring =~ s/_130_/&#130;/g;
	$codestring =~ s/_131_/&#131;/g;
	$codestring =~ s/_132_/&#132;/g;
	$codestring =~ s/_133_/&#133;/g;
	$codestring =~ s/_134_/&#134;/g;
	$codestring =~ s/_135_/&#135;/g;
	$codestring =~ s/_136_/&#136;/g;
	$codestring =~ s/_137_/&#137;/g;
	$codestring =~ s/_138_/&#138;/g;
	$codestring =~ s/_139_/&#139;/g;
	$codestring =~ s/_140_/&#140;/g;
	$codestring =~ s/_141_/&#141;/g;
	$codestring =~ s/_142_/&#142;/g;
	$codestring =~ s/_143_/&#143;/g;
	$codestring =~ s/_144_/&#144;/g;
	$codestring =~ s/_145_/&#145;/g;
	$codestring =~ s/_146_/&#146;/g;
	$codestring =~ s/_147_/&#147;/g;
	$codestring =~ s/_148_/&#148;/g;
	$codestring =~ s/_149_/&#149;/g;
	$codestring =~ s/_150_/&#150;/g;
	$codestring =~ s/_151_/&#151;/g;
	$codestring =~ s/_152_/&#152;/g;
	$codestring =~ s/_153_/&#153;/g;
	$codestring =~ s/_154_/&#154;/g;
	$codestring =~ s/_155_/&#155;/g;
	$codestring =~ s/_156_/&#156;/g;
	$codestring =~ s/_157_/&#157;/g;
	$codestring =~ s/_158_/&#158;/g;
	$codestring =~ s/_159_/&#159;/g;
	$codestring =~ s/_160_/&#160;/g;
	$codestring =~ s/_161_/&#161;/g;
	$codestring =~ s/_162_/&#162;/g;
	$codestring =~ s/_163_/&#163;/g;
	$codestring =~ s/_164_/&#164;/g;
	$codestring =~ s/_165_/&#165;/g;
	$codestring =~ s/_166_/&#166;/g;
	$codestring =~ s/_167_/&#167;/g;
	$codestring =~ s/_168_/&#168;/g;
	$codestring =~ s/_169_/&#169;/g;
	$codestring =~ s/_170_/&#170;/g;
	$codestring =~ s/_171_/&#171;/g;
	$codestring =~ s/_172_/&#172;/g;
	$codestring =~ s/_173_/&#173;/g;
	$codestring =~ s/_174_/&#174;/g;
	$codestring =~ s/_175_/&#175;/g;
	$codestring =~ s/_176_/&#176;/g;
	$codestring =~ s/_177_/&#177;/g;
	$codestring =~ s/_178_/&#178;/g;
	$codestring =~ s/_179_/&#179;/g;
	$codestring =~ s/_180_/&#180;/g;
	$codestring =~ s/_181_/&#181;/g;
	$codestring =~ s/_182_/&#182;/g;
	$codestring =~ s/_183_/&#183;/g;
	$codestring =~ s/_184_/&#184;/g;
	$codestring =~ s/_185_/&#185;/g;
	$codestring =~ s/_186_/&#186;/g;
	$codestring =~ s/_187_/&#187;/g;
	$codestring =~ s/_188_/&#188;/g;
	$codestring =~ s/_189_/&#189;/g;
	$codestring =~ s/_190_/&#190;/g;
	$codestring =~ s/_191_/&#191;/g;
	$codestring =~ s/_192_/&#192;/g;
	$codestring =~ s/_193_/&#193;/g;
	$codestring =~ s/_194_/&#194;/g;
	$codestring =~ s/_195_/&#195;/g;
	$codestring =~ s/_196_/&#196;/g;
	$codestring =~ s/_197_/&#197;/g;
	$codestring =~ s/_198_/&#198;/g;
	$codestring =~ s/_199_/&#199;/g;
	$codestring =~ s/_200_/&#200;/g;
	$codestring =~ s/_201_/&#201;/g;
	$codestring =~ s/_202_/&#202;/g;
	$codestring =~ s/_203_/&#203;/g;
	$codestring =~ s/_204_/&#204;/g;
	$codestring =~ s/_205_/&#205;/g;
	$codestring =~ s/_206_/&#206;/g;
	$codestring =~ s/_207_/&#207;/g;
	$codestring =~ s/_208_/&#208;/g;
	$codestring =~ s/_209_/&#209;/g;
	$codestring =~ s/_210_/&#210;/g;
	$codestring =~ s/_211_/&#211;/g;
	$codestring =~ s/_212_/&#212;/g;
	$codestring =~ s/_213_/&#213;/g;
	$codestring =~ s/_214_/&#214;/g;
	$codestring =~ s/_215_/&#215;/g;
	$codestring =~ s/_216_/&#216;/g;
	$codestring =~ s/_217_/&#217;/g;
	$codestring =~ s/_218_/&#218;/g;
	$codestring =~ s/_219_/&#219;/g;
	$codestring =~ s/_220_/&#220;/g;
	$codestring =~ s/_221_/&#221;/g;
	$codestring =~ s/_222_/&#222;/g;
	$codestring =~ s/_223_/&#223;/g;
	$codestring =~ s/_224_/&#224;/g;
	$codestring =~ s/_225_/&#225;/g;
	$codestring =~ s/_226_/&#226;/g;
	$codestring =~ s/_227_/&#227;/g;
	$codestring =~ s/_228_/&#228;/g;
	$codestring =~ s/_229_/&#229;/g;
	$codestring =~ s/_230_/&#230;/g;
	$codestring =~ s/_231_/&#231;/g;
	$codestring =~ s/_232_/&#232;/g;
	$codestring =~ s/_233_/&#233;/g;
	$codestring =~ s/_234_/&#234;/g;
	$codestring =~ s/_235_/&#235;/g;
	$codestring =~ s/_236_/&#236;/g;
	$codestring =~ s/_237_/&#237;/g;
	$codestring =~ s/_238_/&#238;/g;
	$codestring =~ s/_239_/&#239;/g;
	$codestring =~ s/_240_/&#240;/g;
	$codestring =~ s/_241_/&#241;/g;
	$codestring =~ s/_242_/&#242;/g;
	$codestring =~ s/_243_/&#243;/g;
	$codestring =~ s/_244_/&#244;/g;
	$codestring =~ s/_245_/&#245;/g;
	$codestring =~ s/_246_/&#246;/g;
	$codestring =~ s/_247_/&#247;/g;
	$codestring =~ s/_248_/&#248;/g;
	$codestring =~ s/_249_/&#249;/g;
	$codestring =~ s/_250_/&#250;/g;
	$codestring =~ s/_251_/&#251;/g;
	$codestring =~ s/_252_/&#252;/g;
	$codestring =~ s/_253_/&#253;/g;
	$codestring =~ s/_254_/&#254;/g;
	$codestring =~ s/_255_/&#255;/g;
	$codestring =~ s/_256_/&#256;/g;

    return $codestring;    
}





# =========================================================================================================================
# =========================================================================================================================
# =========================================================================================================================
# =========================================================================================================================
# =========================================================================================================================
# =========================================================================================================================
# =========================================================================================================================


package LanguageBusinessLayer;



#-------------------------------------------------------------------------------------------------
#    constructor
#-------------------------------------------------------------------------------------------------
sub new {
	my ($class) = @_;
	my $self =
	{ _sql => undef, 
	_server => undef
	};
	bless $self, $class;
	return $self;
}

#-------------------------------------------------------------------------------------------------
#    setting the server
#-------------------------------------------------------------------------------------------------

sub setServer{
	my ($self, $name) = @_;
	$self->{_server} =  $name;
}

#-------------------------------------------------------------------------------------------------
# 
#-------------------------------------------------------------------------------------------------
# getVersion

sub getVersion{
	my ($self) = @_;
	return "2011-12-30-A";
}
#-------------------------------------------------------------------------------------------------
# getVocByID

sub getVocByID{
	my ($self, $v_id) = @_;
	my $objDAL = DataAccessLayer->new();
	my $sql_string;
	my @arr;
	my $counter;
		
	$objDAL->setModul('data');
	$sql_string = "SELECT id , L1, L2, L3, L4, L5 , L6, L7    FROM dictionary WHERE id = " . $v_id;

	@arr = $objDAL->getOneLineArray($sql_string);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
# getVocIdByContent

sub getVocIdByContent{
	my ($self, $L1, $L2, $L3, $L4, $L5, $L6, $L7) = @_;
	my $objDAL = DataAccessLayer->new();
	my $sql_string;
	my @arr;
	my $counter;
		
	$objDAL->setModul('data');

	$sql_string = "SELECT id,  L1, L2, L3, L4, L5 , L6, L7   FROM dictionary WHERE L1 = '" . $L1 . "' AND  L2 = '" . $L2 . "' AND  L3 = '" . $L3 . "' AND  L4 = '" . $L4 . "' AND  L5 = '" . $L5 . "' AND  L6 = '" . $L6 . "' AND  L7 = '" . $L7 . "'";

	@arr = $objDAL->getOneLineArray($sql_string);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
# updateVocById

sub updateVocById{

	my ($self, $v_id, $L1, $L2, $L3, $L4, $L5, $L6 , $L7 ) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @languages;
	my @languages2;
	my $lCount;
	my $tl1;
	my $tl2;

	$sql_string = "Update dictionary SET ";
	$sql_string .= "L1 = '".$L1."',";
	$sql_string .= "L2 = '".$L2."',";
	$sql_string .= "L3 = '".$L3."',";
	$sql_string .= "L4 = '".$L4."',";
	$sql_string .= "L5 = '".$L5."',";
	$sql_string .= "L6 = '".$L6."',";
	$sql_string .= "L7 = '".$L7."'";

	$sql_string .= " WHERE id = " . $v_id;

	$objDAL->executeSQL($sql_string);
		
	# eintag in die statistik tabelle - nur die kombinationen die es auch gibt
	$lCount = 0;
	if($L1 ne ''){$lCount += 1; $languages[$lCount] = 1; $languages2[$lCount] = 1;};
	if($L2 ne ''){$lCount += 1; $languages[$lCount] = 2; $languages2[$lCount] = 2;};
	if($L3 ne ''){$lCount += 1; $languages[$lCount] = 3; $languages2[$lCount] = 3;};
	if($L4 ne ''){$lCount += 1; $languages[$lCount] = 4; $languages2[$lCount] = 4;};
	if($L5 ne ''){$lCount += 1; $languages[$lCount] = 5; $languages2[$lCount] = 5;};
	if($L6 ne ''){$lCount += 1; $languages[$lCount] = 6; $languages2[$lCount] = 6;};
	if($L7 ne ''){$lCount += 1; $languages[$lCount] = 7; $languages2[$lCount] = 7;};

	$sql_string = "DELETE FROM dictionary_tracker WHERE id_dictionary = " . $v_id;
	$objDAL->executeSQL($sql_string);



	foreach (@languages) {
		$tl1 =  $_ ;
			
		foreach (@languages2) {      
			$tl2 =  $_ ;
				
			if($tl2 ne $tl1){
				if($tl2 ne ''){
					if($tl1 ne ''){
						$sql_string = "INSERT INTO dictionary_tracker (id_dictionary, from_language, to_language, result) VALUES (" . $v_id . ",'L" . $tl1 . "','L" . $tl2 . "','No')";
						$objDAL->executeSQL($sql_string);
					}
				}
			}      
		}
	} 




	return 1;
}

#-------------------------------------------------------------------------------------------------

sub insertVoc{

	my ($self, $L1, $L2, $L3, $L4, $L5, $L6 , $L7 ) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @arr;
	my $loop1;
	my $loop2;
	my @languages;
	my @languages2;
	my $lCount;
	my $tl1;
	my $tl2;

	$L1 =~ s/^\s+//;
	$L1 =~ s/\s+$//;
	$L2 =~ s/^\s+//;
	$L2 =~ s/\s+$//;
	$L3 =~ s/^\s+//;
	$L3 =~ s/\s+$//;
	$L4 =~ s/^\s+//;
	$L4 =~ s/\s+$//;
	$L5 =~ s/^\s+//;
	$L5 =~ s/\s+$//;
	$L6 =~ s/^\s+//;
	$L6 =~ s/\s+$//;
	$L7 =~ s/^\s+//;
	$L7 =~ s/\s+$//;

	$sql_string = "INSERT INTO dictionary (L1, L2, L3, L4, L5, L6, L7 ) VALUES  ('".$L1."','".$L2."','".$L3."','".$L4."','".$L5."','".$L6."','".$L7."') ";
	$objDAL->executeSQL($sql_string);

	# now get max id 

	$sql_string = "SELECT max(id) from dictionary";

	@arr = $objDAL->getOneLineArray($sql_string);

	# eintag in die statistik tabelle - nur die kombinationen die es auch gibt

	$lCount = 0;

	if($L1 ne ''){$lCount += 1; $languages[$lCount] = 1; $languages2[$lCount] = 1;};
	if($L2 ne ''){$lCount += 1; $languages[$lCount] = 2; $languages2[$lCount] = 2;};
	if($L3 ne ''){$lCount += 1; $languages[$lCount] = 3; $languages2[$lCount] = 3;};
	if($L4 ne ''){$lCount += 1; $languages[$lCount] = 4; $languages2[$lCount] = 4;};
	if($L5 ne ''){$lCount += 1; $languages[$lCount] = 5; $languages2[$lCount] = 5;};
	if($L6 ne ''){$lCount += 1; $languages[$lCount] = 6; $languages2[$lCount] = 6;};
	if($L7 ne ''){$lCount += 1; $languages[$lCount] = 7; $languages2[$lCount] = 7;};

	foreach (@languages) {
		$tl1 =  $_ ;
		
		foreach (@languages2) {      
			$tl2 =  $_ ;
			
			if($tl2 ne $tl1){
				if($tl1 ne '' && $tl1 ne '-' ){
					if($tl2 ne '' && $tl2 ne '-'){
						  $sql_string = "INSERT INTO dictionary_tracker (id_dictionary, from_language, to_language, result) VALUES (" . $arr[0] . ",'L" . $tl1 . "','L" . $tl2 . "','No')";
						   $objDAL->executeSQL($sql_string);
					}
				}
			}      
		}
	} 



	return 1;
}
#-------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------

sub registerResult{
	my ($self, $result, $id, $fromLanguage, $toLanguage) = @_;
	my $objDAL = DataAccessLayer->new();
	my $sql_string;
	my @arr;
	my $counter;
		
	$objDAL->setModul('data');

	# resultat von der letzten abfrage eintragen

		if ($result ne ''){

			if ($result eq 'No'){        
				$sql_string = "SELECT N" . $toLanguage . " FROM dictionary WHERE id = " . $id;    
			}else{        
				$sql_string = "SELECT P" . $toLanguage . " FROM dictionary WHERE id = " . $id;      
			}
		
			@arr = $objDAL->getOneLineArray($sql_string);
			#return @arr;

			$counter = 0;
			$counter = $arr[0];  
		
			$counter = $counter + 1;
		
			if ($result eq 'No'){   
				$sql_string = "UPDATE dictionary SET   N" . $toLanguage . " = " .$counter. "  WHERE id = " . $id;    
			}else{        
				$sql_string = "UPDATE dictionary SET   P" . $toLanguage . " = " .$counter. "  WHERE id = " . $id;      
			}

			$objDAL->executeSQL($sql_string);		
			$sql_string = "INSERT INTO dictionary_tracker (id_dictionary, from_language, to_language, result) VALUES (" . $id . ",'L" . $fromLanguage . "','L" . $toLanguage . "','" . $result . "')";
			$objDAL->executeSQL($sql_string);   
		}
		return 1;
}

#-------------------------------------------------------------------------------------------------
# zufalls eintrag auswählen - 2 methoden gibt es - davon zu 2 dritteln 

sub getRandomContent{
	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @arr;

	$sql_string = " SELECT a.id , a.L1 , a.P1 , a.N1,  a.L2,  a.P2,  a.N2,  a.L3 , a.P3 , a.N3 , a.L4 , a.P4 , a.N4 , a.L5,  a.P5 , a.N5,  a.L6,  a.P6,  a.N6,  a.L7,  a.P7 , a.N7,  a.L8 , a.P8,  a.N8,  COMMENT   FROM dictionary a";
#	$sql_string .= " WHERE a.L1 NOT LIKE '%(%' ";
#	$sql_string .= " AND L2 NOT LIKE '%(%' ";
#	$sql_string .= " AND L3 NOT LIKE '%(%' ";
#	$sql_string .= " AND L4 NOT LIKE '%(%' ";
#	$sql_string .= " AND L5 NOT LIKE '%(%' ";
#	$sql_string .= " AND L6 NOT LIKE '%(%' ";
#	$sql_string .= " AND L7 NOT LIKE '%(%' ";
#        $sql_string .= " WHERE a.id IN (SELECT b.id  FROM  dictionary b WHERE b.L1 NOT LIKE '%Substantive%' AND b.L2 NOT LIKE '%Substantive%'  AND b.L3 NOT LIKE '%Substantive%'  AND b.L4 NOT LIKE '%Substantive%'  AND b.L5 NOT LIKE '%Substantive%'  AND b.L6 NOT LIKE '%Substantive%'  AND b.L7 NOT LIKE '%Substantive%' ) ";
        $sql_string .= " WHERE a.id IN (SELECT b.id  FROM  dictionary b WHERE b.L1 NOT LIKE '%Substantive%' AND b.L2 NOT LIKE '%Substantive%'  AND b.L3 NOT LIKE '%Substantive%'  AND b.L4 NOT LIKE '%Substantive%'  AND b.L5 NOT LIKE '%Substantive%'  AND b.L6 NOT LIKE '%Substantive%'  AND b.L7 NOT LIKE '%Substantive%' ";
        $sql_string .= " AND b.L1 NOT LIKE '%Substantive%' AND b.L2 NOT LIKE '%Substantive%'  AND b.L3 NOT LIKE '%Substantive%'  AND b.L4 NOT LIKE '%Substantive%'  AND b.L5 NOT LIKE '%Substantive%'  AND b.L6 NOT LIKE '%Substantive%'  AND b.L7 NOT LIKE '%Substantive%' "; 
        $sql_string .= " AND b.L1 NOT LIKE '%Verben%' AND b.L2 NOT LIKE '%Verben%'  AND b.L3 NOT LIKE '%Verben%'  AND b.L4 NOT LIKE '%Verben%'  AND b.L5 NOT LIKE '%Verben%'  AND b.L6 NOT LIKE '%Verben%'  AND b.L7 NOT LIKE '%Verben%' "; 
        $sql_string .= " AND b.L1 NOT LIKE '%Nomen%' AND b.L2 NOT LIKE '%Nomen%'  AND b.L3 NOT LIKE '%Nomen%'  AND b.L4 NOT LIKE '%Nomen%'  AND b.L5 NOT LIKE '%Nomen%'  AND b.L6 NOT LIKE '%Nomen%'  AND b.L7 NOT LIKE '%Nomen%' "; 
        $sql_string .= " AND b.L1 NOT LIKE '%Pronomen%' AND b.L2 NOT LIKE '%Pronomen%'  AND b.L3 NOT LIKE '%Pronomen%'  AND b.L4 NOT LIKE '%Pronomen%'  AND b.L5 NOT LIKE '%Pronomen%'  AND b.L6 NOT LIKE '%Pronomen%'  AND b.L7 NOT LIKE '%Pronomen%' "; 
        $sql_string .= " AND b.L1 NOT LIKE '­jektive%' AND b.L2 NOT LIKE '­jektive%'  AND b.L3 NOT LIKE '­jektive%'  AND b.L4 NOT LIKE '­jektive%'  AND b.L5 NOT LIKE '­jektive%'  AND b.L6 NOT LIKE '­jektive%'  AND b.L7 NOT LIKE '­jektive%' ";
        $sql_string .= " AND b.L1 NOT LIKE '­verbien%' AND b.L2 NOT LIKE '­verbien%'  AND b.L3 NOT LIKE '­verbien%'  AND b.L4 NOT LIKE '­verbien%'  AND b.L5 NOT LIKE '­verbien%'  AND b.L6 NOT LIKE '­verbien%'  AND b.L7 NOT LIKE '­verbien%' ) ";
	$sql_string .= " ORDER BY RAND( )  LIMIT 1 ";
		
	@arr = $objDAL->getOneLineArray($sql_string);
	return @arr;
}





#-------------------------------------------------------------------------------------------------

sub getContentNotLearned{

	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @arr;
	my @arrRet;
	my $randomRecord;
	my $recCount;
	my $maxRatio;
	my $y;
	my $stopLoop;

	$sql_string = " SELECT a.id_dictionary, a.from_language, a.to_language, ( ";
	$sql_string .= " if( sum( if( a.result = 'No', 1, 0 ) ) = 0, 0.1, sum( if( a.result = 'No', 1, 0 ) ) ) / if( sum( if( a.result <> 'No', 1, 0 ) ) =0, 0.001, sum( if( a.result <> 'No', 1, 0 ) ) ) ";
	$sql_string .= " ) AS ratio ";
	$sql_string .= " FROM dictionary_tracker a ";
	$sql_string .= " WHERE a.from_language <> a.to_language  and a.from_language <> '' and a.to_language <> '' ";
      #  $sql_string .= " AND  a.id_dictionary IN (SELECT id  FROM  dictionary WHERE L1 NOT LIKE '%Substantive%' AND L2 NOT LIKE '%Substantive%'  AND L3 NOT LIKE '%Substantive%'  AND L4 NOT LIKE '%Substantive%'  AND L5 NOT LIKE '%Substantive%'  AND L6 NOT LIKE '%Substantive%'  AND L7 NOT LIKE '%Substantive%' ) ";


        $sql_string .= " AND  a.id_dictionary IN (SELECT b.id  FROM  dictionary b WHERE b.L1 NOT LIKE '%Substantive%' AND b.L2 NOT LIKE '%Substantive%'  AND b.L3 NOT LIKE '%Substantive%'  AND b.L4 NOT LIKE '%Substantive%'  AND b.L5 NOT LIKE '%Substantive%'  AND b.L6 NOT LIKE '%Substantive%'  AND b.L7 NOT LIKE '%Substantive%' ";
        $sql_string .= " AND b.L1 NOT LIKE '%Substantive%' AND b.L2 NOT LIKE '%Substantive%'  AND b.L3 NOT LIKE '%Substantive%'  AND b.L4 NOT LIKE '%Substantive%'  AND b.L5 NOT LIKE '%Substantive%'  AND b.L6 NOT LIKE '%Substantive%'  AND b.L7 NOT LIKE '%Substantive%' "; 
        $sql_string .= " AND b.L1 NOT LIKE '%Verben%' AND b.L2 NOT LIKE '%Verben%'  AND b.L3 NOT LIKE '%Verben%'  AND b.L4 NOT LIKE '%Verben%'  AND b.L5 NOT LIKE '%Verben%'  AND b.L6 NOT LIKE '%Verben%'  AND b.L7 NOT LIKE '%Verben%' "; 
        $sql_string .= " AND b.L1 NOT LIKE '%Nomen%' AND b.L2 NOT LIKE '%Nomen%'  AND b.L3 NOT LIKE '%Nomen%'  AND b.L4 NOT LIKE '%Nomen%'  AND b.L5 NOT LIKE '%Nomen%'  AND b.L6 NOT LIKE '%Nomen%'  AND b.L7 NOT LIKE '%Nomen%' "; 
        $sql_string .= " AND b.L1 NOT LIKE '%Pronomen%' AND b.L2 NOT LIKE '%Pronomen%'  AND b.L3 NOT LIKE '%Pronomen%'  AND b.L4 NOT LIKE '%Pronomen%'  AND b.L5 NOT LIKE '%Pronomen%'  AND b.L6 NOT LIKE '%Pronomen%'  AND b.L7 NOT LIKE '%Pronomen%' "; 
        $sql_string .= " AND b.L1 NOT LIKE '­­jektive%' AND b.L2 NOT LIKE '­jektive%'  AND b.L3 NOT LIKE '­jektive%'  AND b.L4 NOT LIKE '­jektive%'  AND b.L5 NOT LIKE '­jektive%'  AND b.L6 NOT LIKE '­jektive%'  AND b.L7 NOT LIKE '­jektive%' ";
        $sql_string .= " AND b.L1 NOT LIKE '­­verbien%' AND b.L2 NOT LIKE '­verbien%'  AND b.L3 NOT LIKE '­verbien%'  AND b.L4 NOT LIKE '­verbien%'  AND b.L5 NOT LIKE '­verbien%'  AND b.L6 NOT LIKE '­verbien%'  AND b.L7 NOT LIKE '­verbien%' ) ";


	#$sql_string .= " and a.from_language <> NULL and a.to_language <> NULL ";
	$sql_string .= " GROUP BY a.id_dictionary, a.from_language, a.to_language ";
	$sql_string .= " ORDER BY ratio DESC ";
		$sql_string .= " LIMIT 0 , 10 ";

	@arr = $objDAL->getArray($sql_string);

	srand();
	$randomRecord = int( rand(3) );
	$recCount = 0;
	$maxRatio;
	$stopLoop = 0;

	for $y (0.. $#arr ) { 

	if($stopLoop eq 0){
		if($self->vocExists($arr[$y][1], $arr[$y][2], $arr[$y][0]) eq 1){
		
			if($recCount == $randomRecord){
				$arrRet[0] = $arr[$y][0];
				$arrRet[1] = $arr[$y][1];
				$arrRet[2] = $arr[$y][2];
				$stopLoop = 1;
			}
			
			if($recCount == 0){
				$arrRet[4] = $arr[$y][3];            
			}
			$recCount = $recCount + 1;
			}
		}
	}

	#$objDAL->executeSQL("DELETE FROM dictionary_tracker");
#	$objDAL->executeSQL("DELETE FROM dictionary ");

	return @arrRet;
}

#-------------------------------------------------------------------------------------------------

sub vocExists{

	my @arr;
	my ($self, $L1 , $L2 , $id) = @_;
#   my $objDAL = DataAccessLayer->new();
#   $objDAL->setModul('data');
#   my $sql_string;
#   my $ret;
#   $sql_string = "SELECT " . $L1 . ", " . $L2 . " FROM  dictionary where id = " . $id;
#   @arr = $objDAL->getOneLineArray($sql_string);
#   if($arr[0] ne '' && $arr[1] ne ''){
#      $ret = 1;
#   }else{
#      $ret = 0;
#   }
#   #$ret = 1;
#   return $ret;   

	return 1; 

}

# -------------------------------------------------------------------------------------------------


sub getOneWord{
	my @arr;
	my ($self, $L1 , $L2 , $id) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;

	$sql_string = "SELECT " . $L1 . ", " . $L2 . " FROM  dictionary where id = " . $id;

	@arr = $objDAL->getOneLineArray($sql_string);
	return @arr;    
}

# -------------------------------------------------------------------------------------------------

sub test{
	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	return $objDAL->test();
}
#-------------------------------------------------------------------------------------------------
1; 


exit 0