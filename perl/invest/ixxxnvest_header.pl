

sub header{

print "Content-type: text/html;Charset=iso-8859-1";

print '

<html>
	<head>
	
	<title>AS Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-1">


 <link rel="stylesheet" type="text/css" href="http://www.as-admin.net/live/style/basicstyle.css" >


	</head>

	<body>

';



print '<a href="./accounting.pl?v_u='.$_[0].'&v_s='.$_[1].'">ACCOUNTING</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';


print '<a href="../admin/index.pl?v_u='.$_[0].'&v_s='.$_[1].'">INDEX</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';

print '<br>';


print '<a href="./investment_deals_actual_value.pl?v_u='.$_[0].'&v_s='.$_[1].'">value</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';

print '<a href="./mycronjob.cgi?v_u='.$_[0].'&v_s='.$_[1].'">update&nbsp;all</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';

print '<a href="./investment_deals.pl?v_u='.$_[0].'&v_s='.$_[1].'">deals</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';


print '<a href="./investments_filter_01.pl?v_u='.$_[0].'&v_s='.$_[1].'">filter&nbsp;1</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';

print '<a href="./investments_filter_02.pl?v_u='.$_[0].'&v_s='.$_[1].'">filter&nbsp;2</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';

print '<a href="./investments_filter_03.pl?v_u='.$_[0].'&v_s='.$_[1].'">filter&nbsp;3</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';

print '<a href="./symbol.cgi?v_u='.$_[0].'&v_s='.$_[1].'">symbols</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';

print '<a href="./news.pl?v_u='.$_[0].'&v_s='.$_[1].'">news</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
print '<a href="./investment_companies.pl?v_u='.$_[0].'&v_s='.$_[1].'">companies</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
print "DB: " . serverloc() . "<br>";



};


