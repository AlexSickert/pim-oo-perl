

sub currency_interpolation{


my $currency_factor;
my $value_to_convert;
my $end_result;

$currency_factor = $_[0];
$value_to_convert = $_[1];

$end_result = '&nbsp;';


if ($currency_factor ne '')
{
	if ($value_to_convert ne '')
	{
	$end_result = $currency_factor * $value_to_convert;
	}
	else
	{
	$end_result = '&nbsp;';	
	};
		
	
}
else
{
$end_result = 'no currency';	
};

return $end_result;

};


sub fill_empty{

my $value_to_check;
my $end_result;

$value_to_check = $_[0];

$end_result = '&nbsp;';


if ($value_to_check ne '')
{	
$end_result = $_[0];	
}
else
{
$end_result = '&nbsp;';	
};

return $end_result;

};