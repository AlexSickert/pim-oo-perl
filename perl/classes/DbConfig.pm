package DbConfig;



sub new {
    my ($class) = @_;
    my $self =
      {  _body => undef, _value => undef };
    bless $self, $class;
    return $self;
}

sub getDB{
    my ( $self, $modul ) = @_;
    if($self->serverloc() eq 'live' ){ return "DBI:mysql:" . $modul.'Live:0000000000000000000000';}
    if($self->serverloc() eq 'dev' ){ return "DBI:mysql:" . $modul.'Dev:0000000000000000000000';}
    return 'error';
}

sub getDbUser{
    my ( $self, $modul ) = @_;
    if($self->serverloc() eq 'live' ){ return $modul.'Live';}
    if($self->serverloc() eq 'dev' ){ return $modul.'Dev';}
    return 'error';
}

sub getPassword{
    my ( $self, $modul ) = @_;
    return 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
}

sub serverloc{
    
    my $config = PageConfig->new();
    my $test = $config->get("live-server-path");   
    my $check = $ENV{'SCRIPT_FILENAME'};
    
    if(index($check, $test) > -1){
        return 'live';
    }else{
        return 'dev';
    }
};

1; 
