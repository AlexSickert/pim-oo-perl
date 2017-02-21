package Table;


sub new {
    my ($class) = @_;
    my $self =
      { _name => undef, 
	_id => undef, 
	_class => undef, 
	_content => undef, 
	_value => undef };
    bless $self, $class;
    return $self;
}

sub setName{
	my ($self, $value) = @_;
	$self->{_name} .= $value;
}

sub setStyle{
	my ($self, $value) = @_;
	$self->{_class} .= $value;
}

sub addRow{
	my ($self, $value) = @_;
	if ($self->{_content} eq '')
	{
		$self->{_content} .= "\n".'<tr>';
	}
	else
	{
		$self->{_content} .= "\n".'</tr>'."\n".'<tr>';
	}	
}

sub addField{
	my ($self, $name, $style, $content) = @_;
	$self->{_content} .= "\n".'<td ';
	if ($name ne ''){
		$self->{_content} .= 'id="' . $name . '" ';
	}

	if ($style ne ''){
		$self->{_content} .= 'class="' . $style . '"';
	}
	$self->{_content} .= " >" .$content .'</td>';
}

sub addFieldSortable{
	my ($self, $name, $style, $content, $sortPos, $sortValue) = @_;
	$self->{_content} .= "\n".'<td ';
	if ($name ne ''){
		$self->{_content} .= 'id="' . $name . '" ';
	}

	$self->{_content} .= ' onclick="coreSimpleTableSort(this, ' . $sortPos . ', \'' . $sortValue . '\')" ';

	if ($style ne ''){
		$self->{_content} .= 'class="' . $style . '"';
	}
	$self->{_content} .= " >" .$content .'</td>';
}

sub addFieldOnClick{
	my ($self, $name, $style, $content, $click) = @_;
	$self->{_content} .= "\n".'<td ';
	if ($name ne ''){
		$self->{_content} .= 'id="' . $name . '" ';
	}

	if ($style ne ''){
		$self->{_content} .= 'class="' . $style . '"';
	}
	if ($click ne ''){
		$self->{_content} .= ' onclick="' . $click . '"';
	}
	$self->{_content} .= " >" .$content .'</td>';
}

sub getTable{
	my ($self) = @_;
	my $finalContent;
	$finalContent = "\n".'<table cellpadding="0" cellspacing="0" ';
	if ($self->{_name} ne ''){
		$finalContent .= ' id="' . $self->{_name} . '" ';
	}

	if ($self->{_class} ne ''){
		$finalContent .= ' class="' . $self->{_class} . '" ';
	}
	$finalContent .= ' >';
	$finalContent .= $self->{_content} . "\n".'</tr></table>';
	return $finalContent;
}
1;