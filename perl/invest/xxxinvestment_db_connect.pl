
sub investment_connectionstring{

	my $version = $_[0];
	my $return_string = '';

	if (length(serverloc()) < 3 )
	{
		print "<b>!!! --- NO SERVERLOC --- !!!</b>";
		die;		
	}

	if (serverloc() ne 'live')
	{
		# dev
		$return_string = 'dbi:mysql:d002af77:localhost';
	}
	else
	{
		# live
		$return_string = 'dbi:mysql:d002af2d:localhost';
	}

return $return_string;
};

sub investment_connectionuser{
	
	my $return_string = '';

	if (length(serverloc()) < 3 )
	{
		print "<b>!!! --- NO SERVERLOC --- !!!</b>";
		die;		
	}

	if (serverloc() ne 'live')
	{
		# dev
		$return_string = 'd002af77';
	}
	else
	{
		# live
		$return_string = 'd002af2d';
	}

return $return_string;
};

sub investment_connectionpassword{

	my $return_string = '';

	if (length(serverloc()) < 3 )
	{
		print "<b>!!! --- NO SERVERLOC --- !!!</b>";
		die;		
	}

	if (serverloc() ne 'live')
	{
		# dev
		$return_string = 'aDxfgH';
	}
	else
	{
		# live
		$return_string = 'aDxfgH';
	}

return $return_string;
};
