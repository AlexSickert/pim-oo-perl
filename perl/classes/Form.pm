package Form;


# --------------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------------

#constructor
sub new {
    my ($class) = @_;
	
    my $self =
      { _col1 => 0, 
	_col2 => 0,
	_col3 => 0, 
	_col4 => 0, 
	_arr => undef,
	_hidden => undef , 
	_value => undef };
	
        
        $self->{fields}  = [[],[],[],[]];	
        $self->{labels}  = [[],[],[],[]];	
    bless $self, $class;
    return $self;
}

# mach tabelle mit 4 spalten 
# pro spalte eine tabelle

#tarrays und tabellenobjetke werden agelegt in den jeweiligen methioden zum adden wird dann ein flag gesetzt wenn 
# die jeweige tabelle überhaupt verwendet wird

# addInput(col, name....) fürgt in dein array den jeweiligen content hinzu
# --------------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------------
sub addInput{
	my ($self, $col, $name, $class, $label, $content) = @_;
	$self->setCol($col);
	my $objPage = Page->new();
	my @arr;
        push(@{ $self->{labels}[$col-1] } ,$label);	
	push(@{ $self->{fields}[$col-1] } ,$objPage->getInput($name, $class,$content));	
}

# --------------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------------
sub addContainer{
	my ($self, $col, $name, $class, $label, $content) = @_;
	$self->setCol($col);
	my $objPage = Page->new();
	my @arr;
        push(@{ $self->{labels}[$col-1] } ,$label);	
	push(@{ $self->{fields}[$col-1] } ,$objPage->getContainer($name, $class,$content));	
}
# --------------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------------
sub addLabel{
	my ($self, $col, $label) = @_;
	$self->setCol($col);
	my $objPage = Page->new();
	my @arr;
    push(@{ $self->{labels}[$col-1] } ,$label);
    push(@{ $self->{fields}[$col-1] } ,'&nbsp;');		
	
}
# --------------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------------
sub addPassword{
	my ($self, $col, $name, $class, $label, $content) = @_;
	$self->setCol($col);
	my $objPage = Page->new();
	my @arr;
        push(@{ $self->{labels}[$col-1] } ,$label);	
	push(@{ $self->{fields}[$col-1] } ,$objPage->getPassword($name, $class,$content));	
}
# --------------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------------
# addArea
sub addArea{
	my ($self, $col, $name, $class,$label, $content) = @_;
	$self->setCol($col);
	my $objPage = Page->new();
	my @arr;
        push(@{ $self->{labels}[$col-1] } ,$label);	
	push(@{ $self->{fields}[$col-1] } ,$objPage->getArea($name, $class,$content));	
}
# --------------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------------
# addDropdown
sub addDropdownEditable{
	my ($self, $col, $name, $class, $label, $modul, $dropdown, $default, $v_u, $v_s) = @_;
	$self->setCol($col);
	my $objPage = Page->new();
	my @arr;
        push(@{ $self->{labels}[$col-1] } ,$label);	
	push(@{ $self->{fields}[$col-1] } ,$objPage->getDropdownEditable($name, $class,$modul, $dropdown, $default, $v_u, $v_s));	
}

# --------------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------------    
sub addDropdown{
	my ($self, $col, $name, $class, $label, $dropdown, $default, $defaultDisplay, $size) = @_;
    
    #  $name, $class, $dropdown, $default, $defaultDisplay
    
	$self->setCol($col);
	my $objPage = Page->new();
	my @arr;
        push(@{ $self->{labels}[$col-1] } ,$label);	
	push(@{ $self->{fields}[$col-1] } ,$objPage->getDropdown($name, $class,$dropdown, $default, $defaultDisplay));	
}
# --------------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------------
# addFile    
sub addFile{
	my ($self, $col, $name, $class, $label) = @_;
	$self->setCol($col);
	my $objPage = Page->new();
	my @arr;
        push(@{ $self->{labels}[$col-1] } ,$label);	
	push(@{ $self->{fields}[$col-1] } ,$objPage->getFile($name, $class));	
}

# --------------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------------
#addButton
sub addButton{
	my ($self, $col,$name, $style, $content, $javascript) = @_;
	$self->setCol($col);
	my $objPage = Page->new();
	my @arr;
        push(@{ $self->{labels}[$col-1] } ,'');	
	push(@{ $self->{fields}[$col-1] } ,$objPage->getButton($name, $style, $content, $javascript));	
}
# --------------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------------
# addHidden
sub addHidden{
	my ($self, $name, $content) = @_;
	my $objPage = Page->new();
	my @arr;
	$self->{_hidden}  .=  $objPage->getHidden($name,$content);	
}
# --------------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------------
sub setCol{
	my ($self, $col) = @_;
	if($col == 1){$self->{_col1} = 1;}
	if($col == 2){$self->{_col2 } = 1;}
	if($col == 3){$self->{_col3 } = 1;}
	if($col == 4){$self->{_col4} = 1;}
}
# --------------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------------
sub getForm{
		my ($self, $action) = @_;
	
	# create a table
	my $tab = Table->new();
    $tab->setStyle("f_table");
        my $y;
	
	$tab->addRow();
	#add col if 1
	if( $self->{_col1} == 1 ){
		my $tab1 = Table->new();
		my @formFields = @{ $self->{fields}[0] };
                my @labels = @{ $self->{labels}[0] };
                for $y (0.. $#formFields){
			$tab1->addRow();
                        $tab1->addField('','f_td',$labels[$y]);
			$tab1->addField('','f_td',$formFields[$y]);
		}
		$tab->addField('name','f_td', $tab1->getTable());	
	}
	#add col if 2
	if( $self->{_col2} == 1 ){
		my $tab2 = Table->new();
		my @formFields = @{ $self->{fields}[1] };
                my @labels = @{ $self->{labels}[1] };
		for $y (0.. $#formFields){
			$tab2->addRow();
                        $tab2->addField('','f_td',$labels[$y]);
			$tab2->addField('','f_td',$formFields[$y]);
		}
		$tab->addField('name','f_td', $tab2->getTable());	
	}	
	#add col if 3
	if( $self->{_col3} == 1 ){
		my $tab3 = Table->new();
		my @formFields = @{ $self->{fields}[2] };
                my @labels = @{ $self->{labels}[2] };
		for $y (0.. $#formFields){
			$tab3->addRow();
                        $tab3->addField('','f_td',$labels[$y]);
			$tab3->addField('','f_td',$formFields[$y]);
		}
		$tab->addField('name','f_td', $tab3->getTable());	
	}	
	#add col if 4
	if( $self->{_col4} == 1 ){
		my $tab4 = Table->new();
		my @formFields = @{ $self->{fields}[3] };
                my @labels = @{ $self->{labels}[3] };
		for $y (0.. $#formFields){
			$tab4->addRow();
                        $tab4->addField('','f_td',$labels[$y]);
			$tab4->addField('','',$formFields[$y]);
		}
		$tab->addField('name','f_td', $tab4->getTable());	
	}

	my $page = Page->new();
	return $page->getForm('myform', 'class', $action, $self->{_hidden} . $tab->getTable());
}



1; 
