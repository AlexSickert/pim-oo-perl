package Grid;


#constructor
sub new {
    my ($class) = @_;
	
    my $self =
      { _col1 => 0, 
	_col2 => 0,
	_col3 => 0, 
	_col4 => 0, 
	_arr => undef,
	_table_class => undef,
	_header_class => undef,
	_field_class1 => undef,
	_field_class2 => undef,
	_hidden => undef , 
	_value => undef };
	
	$self->{content}  = [[]];
	$self->{links_id}  = [];	
	$self->{links_description}  = [];	
	$self->{links_href}  = [];	
	$self->{links_style}  = [];	
	$self->{pop_links_id}  = [];	
	$self->{pop_links_description}  = [];	
	$self->{pop_links_href}  = [];	
	$self->{pop_links_style}  = [];	
	$self->{header}  = [];	
	$self->{header_sort_marker}  = [];
	$self->{header_sort_values}  = [];
	$self->{header_sort_position}  = [];
	$self->{glob_repl_id}  = [];	
	$self->{glob_repl_text}  = [];	
	$self->{rec_repl_id}  = [];	
	$self->{rec_repl_col}  = [];	
	$self->{button_id}  = [];	
	$self->{button_name_id}  = [];	
	$self->{button_label}  = [];	
	$self->{button_java}  = [];	
	$self->{button_style}  = [];	

	$self->{file_list_pos}  = [];	
	$self->{file_list_class_1}  = [];	
	$self->{file_list_class_2}  = [];	
	$self->{file_list_path}  = [];	
	$self->{file_list_virtual_path}  = [];	
	$self->{file_list_folder}  = [];	
	
	bless $self, $class;
	return $self;
}

# set array (normale array, kein asssoc)
sub setContent{
	my ($self, @content) = @_;
	push(@{ $self->{content}} , @content);
}

sub setDefaultClass{
	my ($self, $table, $header, $field1, $field2) = @_;
	$self->{_table_class}  = $table;
	$self->{_header_class}  = $header;
	$self->{_field_class1}  = $field1;
	$self->{_field_class2}  = $field2;

}

sub addLink{
	my ($self, $pos, $class, $link, $description) = @_;
	push(@{ $self->{links_id} } , $pos );	
	push(@{ $self->{links_description} } , $description );	
	push(@{ $self->{links_href} } , $link );	
	push(@{ $self->{links_style} } , $class );	
}

sub addLink{
	my ($self, $pos, $class, $link, $description) = @_;
	push(@{ $self->{links_id} } , $pos );	
	push(@{ $self->{links_description} } , $description );	
	push(@{ $self->{links_href} } , $link );	
	push(@{ $self->{links_style} } , $class );	
}

# das hier ist noch nicht implementiert !!!!!!
sub addPopLink{
	my ($self, $pos, $class, $link, $description) = @_;
	push(@{ $self->{pop_links_id} } , $pos );	
	push(@{ $self->{pop_links_description} } , $description );	
	push(@{ $self->{pop_links_href} } , $link );	
	push(@{ $self->{pop_links_style} } , $class );	
}

sub addFileList{
	my ($self, $pos, $class1, $class2, $path,$virtual,$folder) = @_;
	push(@{ $self->{file_list_pos} } , $pos );	
	push(@{ $self->{file_list_class_1} } , $class1 );	
	push(@{ $self->{file_list_class_2} } , $class2 );	
	push(@{ $self->{file_list_path} } , $path );	
	push(@{ $self->{file_list_virtual_path} } , $virtual );	
	push(@{ $self->{file_list_folder} } , $folder );	
}

sub addButton{
	my ($self, $pos, $class, $java, $description) = @_;
	push(@{ $self->{button_id} } , $pos );	
        push(@{ $self->{button_name_id} } , '' );
	push(@{ $self->{button_label} } , $description );	
	push(@{ $self->{button_java} } , $java );	
	push(@{ $self->{button_style} } , $class );	
}


sub addButtonWithId{
	my ($self, $pos, $name_id, $class, $java, $description) = @_;
	push(@{ $self->{button_id} } , $pos );	
        push(@{ $self->{button_name_id} } , $name_id );
	push(@{ $self->{button_label} } , $description );	
	push(@{ $self->{button_java} } , $java );	
	push(@{ $self->{button_style} } , $class );	
}

sub addGlobalReplacement{
	my ($self, $id, $replacment) = @_;
	push(@{ $self->{glob_repl_id} } , $id );	
	push(@{ $self->{glob_repl_text} } , $replacment );		
}

sub addRecordReplacement{
	my ($self, $id, $col) = @_;
	push(@{ $self->{rec_repl_id} } , $id );	
	push(@{ $self->{rec_repl_col} } , $col);		
}

sub addHeader{
	my ($self, $content) = @_;
	push(@{ $self->{header} } , $content );
	push(@{ $self->{header_sort_marker} } , 'no' );
	push(@{ $self->{header_sort_values} } , '0' );	
	push(@{ $self->{header_sort_position} } , '0' );
}

sub addHeaderSortable{
	my ($self, $content, $sortPosition, $sortMethod) = @_;
	push(@{ $self->{header} } , $content );
	push(@{ $self->{header_sort_marker} } , 'yes' );
	push(@{ $self->{header_sort_values} } , $sortMethod );
	push(@{ $self->{header_sort_position} } ,$sortPosition);	
}

sub build{
	my ($self, $name) = @_;
	my $table = Table->new();
	$table->setStyle($self->{_table_class});
	my $page = Page->new();
	$table->addRow();
	my @arr = @{ $self->{header}};
	my @arrMarker = @{ $self->{header_sort_marker}};
	my @arrSortValues = @{ $self->{header_sort_values}};
	my @arrSortPosition = @{ $self->{header_sort_position}};
	my $counter = 0;
	foreach ( @arr ) {
		if($arrMarker[$counter] eq 'yes'){
			$table->addFieldSortable('',$self->{_header_class},$_, $arrSortPosition[$counter], $arrSortValues[$counter]);
		}else{
			$table->addField('',$self->{_header_class},$_);
		}
		$counter = $counter + 1;
	}

	my $lpos;
	my $link;
	my $button;
	my $fileList;
	my @row;
	#my @links = @{ $self->{links}};
	my @content = @{ $self->{content}};
	my $rowSwitch = 0;
	my $thisFieldClass;
	my $y;
	my $x;
	for $y (0.. $#content) {
		$table->addRow();

		if($rowSwitch == 0){
			$thisFieldClass = $self->{_field_class1};
			$rowSwitch +=1;
		}else{
			$thisFieldClass = $self->{_field_class2};
			$rowSwitch =0;
		}

		for $x (0.. $#{ $content[$y] }) {	
			$link = $self->getLinkPos($x);
			$button = $self->getButtonPos($x);
			$fileList = $self->getFilePos($x, $content[$y]);

			if($link ne ''){			
				$link = $self->makeRecordReplacements($link,  $content[$y] );
				$link = $self->makeGlobalReplacements($link );
				$table->addField('',$thisFieldClass ,$link);
			}elsif($button ne ''){
				$button = $self->makeRecordReplacements($button,  $content[$y] );
				$button = $self->makeGlobalReplacements($button );
				$table->addField('',$thisFieldClass,$button);
			}elsif($fileList ne ''){
				$fileList = $self->makeRecordReplacements($fileList,  $content[$y] );
				$fileList = $self->makeGlobalReplacements($fileList );
				$table->addField('',$thisFieldClass,$fileList);
			}else{
				if($content[$y][$x] eq ''){
                                   $table->addField('','','&nbsp;');
                                }else{
                                   $table->addField('',$thisFieldClass,$content[$y][$x] );
                                }
			}
		}
	}
	return $table->getTable();
}

sub getLinkPos{
	my ($self, $posX) = @_;
	my $page = Page->new();
	my @arrId = @{ $self->{links_id}};
	my @arrHref = @{ $self->{links_href}};
	my @arrDes = @{ $self->{links_description}};
	my @arrClass = @{ $self->{links_style}};
	my $posArr = 0;
	my $ret = '';
	my @arr;
	foreach my $x (@arrId) {
		if($x == $posX){
			$ret =$page->getLink($arrClass[$posArr], $arrHref[$posArr],  $arrDes[$posArr]);
		}
		$posArr += 1;
	}
	return $ret;
}

sub getButtonPos{
	my ($self, $posX) = @_;
	my $page = Page->new();
	my @arrId = @{ $self->{button_id}};
        my @nameId = @{ $self->{button_name_id}};
	my @label = @{ $self->{button_label}};
	my @java = @{ $self->{button_java}};
	my @arrClass = @{ $self->{button_style}};
	my $posArr = 0;
	my $ret = '';
	my @arr;
	foreach my $x (@arrId) {
		if($x == $posX){
			$ret =$page->getButton($nameId[$posArr],$arrClass[$posArr], $label[$posArr],  $java[$posArr]);
		}
		$posArr += 1;
	}
	return $ret;
}

sub getFilePos{
	my ($self, $posX, $currLine) = @_;
	my @arrPosition = @{ $self->{file_list_pos}};
	my @arrClass1 = @{ $self->{file_list_class_1}};
	my @arrClass2 = @{ $self->{file_list_class_2}};
	my @arrPath = @{ $self->{file_list_path}};
	my @arrVirtualPath = @{ $self->{file_list_virtual_path}};
	my @arrFolder = @{ $self->{file_list_folder}};
	my $posArr = 0;
	my $ret = '';
	my @arr;
	foreach my $x (@arrPosition) {
		if($x == $posX){
			$ret = $self->getFileListAsTable($arrPath[$posArr],  $arrVirtualPath[$posArr],$arrFolder[$posArr], $currLine);
		}
		$posArr += 1;
	}
	return $ret;
}

#sub getButtonbefor(pos)
# liefert aus dem array den button zurück der noch nicht verbraucht ist und der kleiner oder gleich der pos ist
# replace  1,1,
sub makeRecordReplacements{
	my ($self, $content, $currLine) = @_;
	my $y;
	my @arrId =  @{$self->{rec_repl_id}};
    my @arrCol =  @{$self->{rec_repl_col}};
	my @arrRep =@{$currLine};
	for $y (0.. $#arrId){
		my $search = $arrId[$y];
		#my $replace = $arrRep[$y];
        my $replace = $arrRep[$arrCol[$y]];
		$content =~ s/$search/$replace/gi;
	}	
	return $content;
}

sub makeGlobalReplacements{
	my $y;
	my ($self, $content) = @_;
	my @arrId = @{$self->{glob_repl_id}};
	my @arrRep =@{$self->{glob_repl_text}};
	for $y (0.. $#arrId){
		my $search = $arrId[$y];
		my $replace = $arrRep[$y];
		$content =~ s/$search/$replace/gi;
	}	
	return $content;
}

sub getFileListAsTable{
	my ($self, $path,$virtual, $folder,$currLine) = @_;
	my $page = Page->new();
	my $table = Table->new();
	my $updir = $path. "/" . $folder ;
        $updir = $self->makeRecordReplacements($updir, $currLine);
	my @files = ();
	my @filesSorted;
	my $y;
	my $i = 0;
	my $datei;

	if(-e $updir) 
	{ 
	   opendir(DIR,$updir);
	   while($datei = readdir(DIR)) { 	
		if($datei ne "." && $datei ne ".."){
		   $files[$i] =  $datei ;
		   $i = $i + 1;     
		}
	   }
	   closedir(DIR);
	}

    	@filesSorted =  sort(@files);
	for $y (0.. $#filesSorted){
		$table->addRow();
		$table->addField('','',	$page->getLink('',$virtual."/".$folder."/".$filesSorted[$y],$filesSorted[$y]) )
	}

	return $table->getTable();
}


sub test{
	my ($self, $pos) = @_;
print @{ $self->{links}};
}

1; 
