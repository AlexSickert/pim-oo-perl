package DataAccessLayer;



use DBI;

# -----------------------------------------------------------------------------------------------------------
#constructor
sub new {
    #my ($class) = @_;
    my $self = {
	_server => "",
	_modul => ""
};
bless $self, 'DataAccessLayer';
return $self;}

# -----------------------------------------------------------------------------------------------------------
sub setModul{
	my ($self, $name) = @_;
	$self->{_modul} = $name;
}

# -----------------------------------------------------------------------------------------------------------
sub getArray{

	my ($self, $sql) = @_;
	my $objConfig;
	$objConfig  = DbConfig->new();
	my $dbCon = $objConfig->getDB($self->{_modul});
	my $user = $objConfig->getDbUser($self->{_modul});
	my $pw = $objConfig->getPassword($self->{_modul});
	my $db = DBI->connect($dbCon,$user,$pw) ;
    
	my $rs = $db->prepare($sql);
	$rs->execute();
	my @returnArray;
	
	while(my @zeile = $rs->fetchrow_array()) {
		push(@returnArray,[@zeile]);
	}	
	$rs->finish;
	$db->disconnect;
	return @returnArray;
}

# -----------------------------------------------------------------------------------------------------------
sub getAssocArray{
	my ($self, $sql) = @_;
	my $objConfig = DbConfig->new();
	my $dbCon = $objConfig->getDB($self->{_modul});
	my $user = $objConfig->getDbUser($self->{_modul});
	my $pw = $objConfig->getPassword($self->{_modul});
	my $db = DBI->connect($dbCon,$user,$pw) ;
	my $rs = $db->prepare($sql);
	$rs->execute();
	my @returnArray;
	while(my $arr = $rs->fetchrow_hashref()) {
		push(@returnArray,$arr);
	}	
	$rs->finish;
	$db->disconnect;
	return @returnArray;
}

# -----------------------------------------------------------------------------------------------------------
sub getFirstValue{
my ($self) = @_;
print getOneLineAssoc();

}

# -----------------------------------------------------------------------------------------------------------
sub getOneLineArray{
	my ($self, $sql) = @_;
	my $objConfig = DbConfig->new();
	my $dbCon = $objConfig->getDB($self->{_modul});
	my $user = $objConfig->getDbUser($self->{_modul});
	my $pw = $objConfig->getPassword($self->{_modul});
	my $db = DBI->connect($dbCon,$user,$pw) ;
	my $rs = $db->prepare($sql);
	$rs->execute();
    my @arr = $rs->fetchrow_array();
	$rs->finish;
	$db->disconnect;
	return @arr;
}

# -----------------------------------------------------------------------------------------------------------
sub executeSQL{
	my ($self, $sql) = @_;
	my $objConfig = DbConfig->new();
	my $dbCon = $objConfig->getDB($self->{_modul});
	my $user = $objConfig->getDbUser($self->{_modul});
	my $pw = $objConfig->getPassword($self->{_modul});
	my $db = DBI->connect($dbCon,$user,$pw) ;
	my $rs = $db->prepare($sql);
	$rs->execute();	
	$rs->finish;
	$db->disconnect;
	return $sql;
}


# -----------------------------------------------------------------------------------------------------------
1; 
