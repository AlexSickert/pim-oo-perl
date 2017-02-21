package AdminBusinessLayer;




#constructor
sub new {
    my ($class) = @_;
    my $self =
      { _sql => undef, 
	_server => undef
	};
    bless $self, $class;
    return $self;
}

sub setServer{
	my ($self, $name) = @_;
	$self->{_server} =  $name;
}
#-----------------------------------------------------------------------------------------------------------------

# ICH DENKE DASS DIESE METHODE DELETED WERDEN KANN WEIL SIE NICHT GENUTZT WIRD

sub registerFileForSync{
   my ($self, $path, $status) = @_;
   my $objDAL = DataAccessLayer->new();
   $objDAL->setModul('admin');
   my $sql;	
   $sql = "INSERT INTO files_for_sync(path_to_file , status)VALUES ( ";
   $sql .=  " '" . $path . "'," ;
   $sql .=  " '" . $status . "'" ;
   $sql .=   ")" ;
  
   return $objDAL->executeSQL($sql);
}
#-----------------------------------------------------------------------------------------------------------------

# ICH DENKE DASS DIESE METHODE DELETED WERDEN KANN WEIL SIE NICHT GENUTZT WIRD

sub registerFolderForDelete{
   my ($self, $path, $fileOrFolder) = @_;
   my $objDAL = DataAccessLayer->new();
   $objDAL->setModul('admin');
   my $sql;	
   $sql = "INSERT INTO files_to_delete(path_to_file , file_or_folder)VALUES ( ";
   $sql .=  " '" . $path . "'," ;
   $sql .=  " '" . $fileOrFolder . "'" ;
   $sql .=   ")" ;
  
   return $objDAL->executeSQL($sql);
}
# ----------------------------------------------------------------------------------------------------------------
# setParameter  modul parameter value

sub setParameter{
   my ($self, $modul, $parameter, $value) = @_;
   my $objDAL = DataAccessLayer->new();
   $objDAL->setModul('admin');
   # delete old
   my $sql =  "DELETE FROM settings WHERE modul = '" . $modul . "' and parameter = '".$parameter."'  " ;  
   $objDAL->executeSQL($sql);

   # insert new
   $sql =  "INSERT INTO settings (modul, parameter, parameter_value) VALUES ('" . $modul . "','" . $parameter . "','" . $value . "')" ;  
   $objDAL->executeSQL($sql);
   return 1;
}
# ----------------------------------------------------------------------------------------------------------------
# getParameter modul parameter

sub getParameter{
   my ($self, $modul, $parameter) = @_;
   my $objDAL = DataAccessLayer->new();
	
   $objDAL->setModul('admin');
   my @arr;
   my $ret;
   $ret = "";
   my $sql =  "SELECT parameter_value FROM settings WHERE modul = '" . $modul . "' and parameter = '".$parameter."'  " ;  

   @arr = $objDAL->getOneLineArray($sql);
   if($arr[0] ne ''){
      $ret = $arr[0];
   }
   return $ret;
}
# ----------------------------------------------------------------------------------------------------------------
sub getDropDown{
	my ($self, $modul, $drop_down_name) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('admin');
	my @arr;
	my $sql =  "SELECT id, drop_down_value, drop_down_text FROM drop_down WHERE modul = '" . $modul . "' and drop_down_name = '" . $drop_down_name . "' and drop_down_text <> ''  ORDER BY drop_down_text " ;  
	@arr = $objDAL->getArray($sql);
	return @arr;
}
# ----------------------------------------------------------------------------------------------------------------
sub getDropDownById{
	my ($self, $id) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('admin');
	my @arr;
	my $sql =  "SELECT id, drop_down_value, drop_down_text FROM drop_down WHERE id = " . $id . "  " ;  
	#@arr = $objDAL->getArray($sql);
        @arr = $objDAL->getOneLineArray($sql);
	return @arr;
}
# ----------------------------------------------------------------------------------------------------------------
sub updateDropDown{
    my ($self, $id, $drop_down_value , $drop_down_text) = @_;
    my $objDAL = DataAccessLayer->new();
    
    $objDAL->setModul('admin');
    my $sql_string;	
    
    $sql_string = 'update drop_down set ';
    $sql_string = $sql_string . ' drop_down_value = "' . $drop_down_value . '",' ;
    $sql_string = $sql_string . ' drop_down_text = "' . $drop_down_text . '"' ;
    $sql_string = $sql_string . ' where id = ' . $id . '';
    
    $objDAL->executeSQL($sql_string);
    return 1;
}
# ----------------------------------------------------------------------------------------------------------------
sub insertDopDown{
   my ($self, $modul, $drop_down_name, $drop_down_value , $drop_down_text ) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('admin');
   my $sql;	
   $sql = "INSERT INTO drop_down (modul, drop_down_name, drop_down_value , drop_down_text)VALUES ( ";
   $sql .=  " '" . $modul. "'," ;
   $sql .=  " '" . $drop_down_name. "'," ;
   $sql .=  " '" . $drop_down_value . "'," ;
   $sql .=  " '" . $drop_down_text . "'" ;
   $sql .=   ")" ;
  
   return $objDAL->executeSQL($sql);
}
# ----------------------------------------------------------------------------------------------------------------
sub deleteDopDown{
   my ($self, $id ) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('admin');
   my $sql;	
   $sql = "DELETE FROM drop_down ";
   $sql .=  " WHERE id = " . $id . " " ;

   if($id ne '' && $id ne 'id'){
      return $objDAL->executeSQL($sql);
   }else{
      return "error";
   }
}
# ----------------------------------------------------------------------------------------------------------------
sub logout{
    my ($self, $v_u) = @_;
    my $sql;
    my $objDAL = DataAccessLayer->new();
    $objDAL->setModul('admin');
    $sql =  "update login set v_session = '' , REMOTE_ADDR = ''where v_user = '$v_u'  " ;
    $objDAL->executeSQL($sql);
    return 1;   
}
# ----------------------------------------------------------------------------------------------------------------

sub checkLogin{

    my ($self, $vu, $vs) = @_;
    my $sql;
    my $returnValue;
    $sql =  "select REMOTE_ADDR, v_user from login where ";
    $sql .= "v_session = '".$vs."' and " ;
    $sql .= "v_user = '".$vu."'  " ;
    my $objDAL ;
    $objDAL = DataAccessLayer->new;

    $objDAL->setModul('admin');
    #print "->debug sql...";
    #print $sql;
    my @arr;
    #print "->getArray ...";
    @arr = $objDAL->getArray($sql);
    #print "->getArray done...";


    $returnValue = 0;
    foreach my $i (@arr){
        $returnValue = 1;
    }

    return   $returnValue;
}


# ----------------------------------------------------------------------------------------------------------------

sub checkPassword{
    my ($self, $v_u, $v_p, $v_x) = @_;
    my $sql;


my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_second = (localtime())[0];
my $v_minute = (localtime())[1];
my $v_year = (localtime())[5];
my $v_day_of_week = (localtime())[6];
my $check = "";

   $check = $v_hour . $v_day . $v_month ;

#   $v_minute .  $v_year . $v_day_of_week;

    $sql =  "select * from login  ";
    $sql =  "select * from login where ";
    $sql .=  "v_password = '$v_p' and " ;
    $sql .=  "v_user = '$v_u'  " ;
    my $objDAL = DataAccessLayer->new();
    $objDAL->setModul('admin');
    my @arr = $objDAL->getArray($sql);



    my $returnValue = 0;
    foreach my $i (@arr){
        $returnValue = 1;
    }

   if ($check ne $v_x){
        $returnValue = 0;
   }




    return $returnValue;
    
}
# ----------------------------------------------------------------------------------------------------------------

sub getNewSession{
    my ($self, $v_u) = @_;
    my $sql;
    my $objDAL = DataAccessLayer->new();
    $objDAL->setModul('admin');
    my $session = rand(999);

    my $util;
    $util = Utility->new();
    $session = $util->getRandomString(50);

    $sql =  "update login set v_session = '$session' , REMOTE_ADDR = '0' where v_user = '$v_u'  " ;
    $objDAL->executeSQL($sql);
    return $session;     
}    

sub test{
my ($self) = @_;
my $objDAL = DataAccessLayer->new();
return $objDAL->test();
}
# ----------------------------------------------------------------------------------------------------------------

1; 
