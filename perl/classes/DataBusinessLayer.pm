package DataBusinessLayer;




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
# -----------------------------------------------------------------------------------------------
# new function to do august 2009

# SQL query: 
# CREATE TABLE `files` (
# `id` BIGINT NOT NULL AUTO_INCREMENT ,
# `type` VARCHAR( 10 ) ,
# `ref_id` VARCHAR( 20 ) ,
# `file_name` VARCHAR( 255 ) ,
# `name_alias` VARCHAR( 255 ) ,
# `timestamp_created` BIGINT DEFAULT '0',
# `path_part` VARCHAR( 255 ) ,
# `upload_path` VARCHAR( 255 ) ,
# `mime_type` VARCHAR( 10 ) ,
# `file_size` BIGINT DEFAULT '0',
# PRIMARY KEY ( `id` ) ) TYPE = MYISAM ;



# registerCode(path, name)
# -----------------------------------------------------------------------------------------------
# registerMail(id, path, name)
# -----------------------------------------------------------------------------------------------
# registerData(id, path, name, alias)
# -----------------------------------------------------------------------------------------------
# registerAttachment(id, path, name, alias)
# -----------------------------------------------------------------------------------------------
# registerUpload(id, upload-path, path, name, alias, timestamp)

#-------------------------------------------------------------------------------------------------
sub getFile{
	my ($self, $uploadPathWithName) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my @arr;
	my $sql = "SELECT path_part, mime_type FROM files WHERE type = 'cms' AND upload_path = '" . $uploadPathWithName . "'";
        @arr = $objDAL->getOneLineArray($sql);

	if (! defined($arr[0])){ 
		$arr[0] = "";
		$arr[1] = "";
	}

	return @arr;
}

#-------------------------------------------------------------------------------------------------
sub getAllTimestamps{
	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();	
	$objDAL->setModul('data');
	my @arr;
	my $sql = "SELECT CONCAT(upload_path, '<F>', timestamp_created , '<R>') , 'childs' as childs FROM files WHERE type = 'cms' ";
	#my $sql =  "SELECT id,sheet_year, sheet_month, sheet_day , sheet_from, sheet_to, sheet_client, sheet_project, sheet_bill_time, rate_per_hour, fixed_price, ((sheet_bill_time * rate_per_hour)+ fixed_price) as money_made, comment , status FROM timesheet  WHERE status = 'open' ORDER BY sheet_year desc, sheet_month desc, sheet_day desc" ;  
	@arr = $objDAL->getArray($sql);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getTimestamp{
	my ($self, $uploadPathWithName) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my @arr;
	my $sql = "SELECT timestamp_created FROM files WHERE type = 'cms' AND upload_path = '" . $uploadPathWithName . "'";
        @arr = $objDAL->getOneLineArray($sql);

	if (! defined($arr[0])){ 
		$arr[0] = "0";
	}

	return $arr[0];
}
#-------------------------------------------------------------------------------------------------
sub registerCmsUpload{
	my ($self, $mimeType, $uploadPathWithName, $localPathWithName, $timestamp) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	# delete if existing
	my $sql = "DELETE from files WHERE type = 'cms' AND upload_path = '" . $uploadPathWithName . "'";
	$objDAL->executeSQL($sql);

	# enter the file	
	$sql = "INSERT INTO files (type, upload_path, path_part, mime_type, timestamp_created)VALUES ( ";
	$sql .=  " 'cms'," ;
	$sql .=  " '" . $uploadPathWithName . "'," ;
	$sql .=  " '" . $localPathWithName . "'," ;
	$sql .=  " '" . $mimeType. "'," ;
	$sql .=  " " . $timestamp. " " ;
	$sql .=  ")" ;
	$objDAL->executeSQL($sql);

	return 1;
}
#-------------------------------------------------------------------------------------------------
# ICH DENKE DASS DIESE METHODE DELETED WERDEN KANN WEIL SIE NICHT GENUTZT WIRD

sub registerFile{
   my ($self, $system, $dvd, $path) = @_;
   my $sql;
   my $objDAL = DataAccessLayer->new();
   my @arr;
   $objDAL->setModul('data');

   $sql = "SELECT count(dvd) FROM file_listing WHERE system_code = '". $system ."' AND dvd = '". $dvd ."' AND path = '". $path ."' ";

   @arr = $objDAL->getOneLineArray($sql);
   
    if($arr[0] == 0){

      $sql = "INSERT INTO file_listing (system_code, dvd, path ) VALUES ('". $system ."','". $dvd ."','". $path ."')";
      $objDAL->executeSQL($sql);
   }   



   return 1;
}
#-------------------------------------------------------------------------------------------------

sub getCrossLinkString{
   my ($self, $v_p_id, $class, $baseLink) = @_;
   my $objDAL = DataAccessLayer->new();
   $objDAL->setModul('data');
   my $stop = 0;
   my $sql_string;
   my $parent_id;
   my $returnString;
   my @arr;  

   $parent_id = $v_p_id;
   $returnString = "";

   while($stop != 1){
      $sql_string = 'select id, parent_id, description from the_list_cross where id = ' . $parent_id;
      @arr = $objDAL->getOneLineArray($sql_string);
      $parent_id = $arr[1] . '';
      
      
      if($parent_id eq '0' || $parent_id eq ''){
        $stop = 1;        
        $returnString = "<a href='".$baseLink."&v_p_id=".$arr[0]."' >". $arr[2] .  ":</a> " . $returnString;
        $returnString = "<a href='".$baseLink."&v_p_id=0' >root:</a> " . $returnString;
      }else{
         $returnString = "<a href='".$baseLink."&v_p_id=".$arr[0]."' >". $arr[2] .  ":</a> " . $returnString;
      }
   }
   return $returnString;
};
#-------------------------------------------------------------------------------------------------
sub prepareCross{
    my ($self, $v_id) = @_;
    my $objDAL = DataAccessLayer->new();
    $objDAL->setModul('data');
    my $sql_string;	
    my @arr;    
        
    $sql_string =  "select * from the_list_cross where description <> '' AND ";
    $sql_string = $sql_string . "id = ".$v_id."  " ;

    @arr = $objDAL->getOneLineArray($sql_string);
    return @arr;
}
#-------------------------------------------------------------------------------------------------
sub updateCross{
	my ($self, $v_parent_id, $v_description, $v_list_ids, $v_id) = @_;
    my $objDAL = DataAccessLayer->new();
    
    $objDAL->setModul('data');
    my $sql_string;	
    
    $sql_string = 'update the_list_cross set ';
    $sql_string = $sql_string . ' parent_id = "' . $v_parent_id . '",' ;
    $sql_string = $sql_string . ' description = "' . $v_description . '",' ;
    $sql_string = $sql_string . ' list_ids = "' . $v_list_ids . '"' ;
    $sql_string = $sql_string . ' where id = ' . $v_id . '';
    
    $objDAL->executeSQL($sql_string);
    return 1;
}
#-------------------------------------------------------------------------------------------------
sub  insertCross{
    my ($self, $v_parent_id, $v_description, $v_list_ids) = @_;
    my $objDAL = DataAccessLayer->new();
    
    $objDAL->setModul('data');
    my $sql_string;	

    $sql_string = 'insert into the_list_cross (   
    parent_id ,
    description,
    list_ids  ) values  (';


    $sql_string = $sql_string . '"' . $v_parent_id . '",' ;
    $sql_string = $sql_string . '"' . $v_description . '",' ;
    $sql_string = $sql_string . '"' . $v_list_ids . '")' ;
   
    $objDAL->executeSQL($sql_string);
    
    my @arr;
    my $sql =  "select max(id) from the_list_cross" ;    
    @arr = $objDAL->getOneLineArray($sql);
    #print "maaaaaaaaaaaaaaxxxxxxxxxxxxxxxxxxx: " . $arr[0];
	return $arr[0];
    
}
#-------------------------------------------------------------------------------------------------
sub getCrossByParentId{
	my ($self, $v_p_id) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('data');
	my @arr;
    my @a;
    my $a;
    my $y;
	my $sql =  "select id, parent_id, description, list_ids , 'childs' as childs  from the_list_cross where description <> '' and parent_id = '" . $v_p_id . "' order by description ";  
	@arr = $objDAL->getArray($sql);
    
    # count ids
	for $y (0.. $#arr){
        $a =  split(/,/,$arr[$y][3]);
		$arr[$y][3] = "" . $a;
        $arr[$y][4] = "" . $a;
	}
    
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getExplorerByParentId{
	my ($self, $v_p_id) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('data');
	my @arr;
    my @a;
    my $a;
    my $y;
	my $sql =  "select id, parent_id, description, list_ids , 'childs' as childs  from the_list_cross where description <> '' and parent_id = '" . $v_p_id . "' order by description ";  
	@arr = $objDAL->getArray($sql);
    
	return @arr;
}

#-------------------------------------------------------------------------------------------------
sub getExplorerGetHeader{
	my ($self, $v_p_id) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('data');
	my @arr;
    my @a;
    my $a;
    my $y;
	my $sql =  "select id, parent_id, description, list_ids , 'childs' as childs  from the_list_cross where description <> '' and id = '" . $v_p_id . "' order by description ";  
	#@arr = $objDAL->getArray($sql);
                @arr = $objDAL->getOneLineArray($sql);
    
	return @arr;
}

#-------------------------------------------------------------------------------------------------
sub getExplorerDataElements{
	my ($self, $ids) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('data');
	my @arr;
    my @a;
    my $a;
    my $y;
	#my $sql =  "select id, parent_id, description, list_ids , 'childs' as childs  from the_list_cross where description <> '' and id = '" . $id . "' order by description ";  
                my $sql =  "select id, name from the_list where id in ( ". $ids .")  " ;  

	@arr = $objDAL->getArray($sql);
    
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub setStatusTimesheet{

   my ($self, $id,$status) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('data');
   my $sql;	
   $sql = "UPDATE timesheet SET ";
   $sql .=  "status = '" . $status. "'" ;
   $sql .=  " WHERE id = " . $id . " " ;

   if($id ne '' && $id ne 'id'){
      return $objDAL->executeSQL($sql);
   }else{
      return "error";
   }
}
#-------------------------------------------------------------------------------------------------
sub updateExistingTimesheet{

   my ($self, $id,$sheet_year, $sheet_month, $sheet_day , $sheet_from, $sheet_to, $sheet_client, $sheet_project, $sheet_bill_time, $comment, $status, $rate , $fixed_price  ) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('data');
   my $sql;	
   $sql = "UPDATE timesheet SET ";
   $sql .=  "sheet_year = " . $sheet_year. "," ;
   $sql .=  "sheet_month = " . $sheet_month. "," ;
   $sql .=  "sheet_day = " . $sheet_day. "," ;
   $sql .=  "sheet_from = " . $sheet_from. "," ;
   $sql .=  "sheet_to = " . $sheet_to. "," ;
   $sql .=  "sheet_client = '" . $sheet_client. "'," ;
   $sql .=  "sheet_project = '" . $sheet_project. "'," ;
   $sql .=  "sheet_bill_time = " . $sheet_bill_time. "," ;   
   $sql .=  "rate_per_hour = " . $rate. "," ;
   $sql .=  "fixed_price = " . $fixed_price . "," ;
   $sql .=  "comment = '" . $comment. "'," ;
   $sql .=  "status = '" . $status. "'" ;
   $sql .=  " WHERE id = " . $id . " " ;

   if($id ne '' && $id ne 'id'){
      return $objDAL->executeSQL($sql);
   }else{
      return "error";
   }
}
#-------------------------------------------------------------------------------------------------
sub insertIntoTimesheet{

   my ($self, $sheet_year, $sheet_month, $sheet_day , $sheet_from, $sheet_to, $sheet_client, $sheet_project, $sheet_bill_time, $comment, $status , $rate , $fixed_price  ) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('data');
   my $sql;	
   $sql = "INSERT INTO timesheet (sheet_year, sheet_month, sheet_day , sheet_from, sheet_to, sheet_client, sheet_project, sheet_bill_time, rate_per_hour, fixed_price,comment, status)VALUES ( ";
   $sql .=  " " . $sheet_year. "," ;
   $sql .=  " " . $sheet_month. "," ;
   $sql .=  "" . $sheet_day. "," ;
   $sql .=  " " . $sheet_from. "," ;
   $sql .=  " " . $sheet_to. "," ;
   $sql .=  " '" . $sheet_client. "'," ;
   $sql .=  " '" . $sheet_project. "'," ;
   $sql .=  " " . $sheet_bill_time. "," ;
   $sql .=  " " . $rate . "," ;
   $sql .=  " " . $fixed_price  . "," ;
   $sql .=  " '" . $comment. "'," ;
   $sql .=  " '" . $status. "')" ;
  
   return $objDAL->executeSQL($sql);

}
#---------------------------------------------------------------------------------------------------------------------------------------
# auch die nachfolgende methode getTimesheetForExcelAll beachten !!!
#---------------------------------------------------------------------------------------------------------------------------------------
sub getTimesheetForExcel{
	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('data');
	my @arr;
	my $sql =  "SELECT id,sheet_year, sheet_month, sheet_day , sheet_from, sheet_to, sheet_client, sheet_project, sheet_bill_time, rate_per_hour, fixed_price, ((sheet_bill_time * rate_per_hour)+ fixed_price) as money_made, comment , status FROM timesheet WHERE status = 'open'" ;  
	$sql .=  " ORDER BY status desc, sheet_client, sheet_project, sheet_year desc, sheet_month desc, sheet_day desc, sheet_from";
        @arr = $objDAL->getArray($sql);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
# auch die vorhergehende methode beachten !!!
#-------------------------------------------------------------------------------------------------
sub getTimesheetForExcelAll{
	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('data');
	my @arr;
	my $sql =  "SELECT id,sheet_year, sheet_month, sheet_day , sheet_from, sheet_to, sheet_client, sheet_project, sheet_bill_time, rate_per_hour, fixed_price, ((sheet_bill_time * rate_per_hour)+ fixed_price) as money_made, comment , status FROM timesheet WHERE 1 = 1 " ;  
	$sql .=  " ORDER BY sheet_year desc, sheet_month desc, sheet_day desc, sheet_from";
        @arr = $objDAL->getArray($sql);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getTimesheet{
	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('data');
	my @arr;
	my $sql =  "SELECT id,sheet_year, sheet_month, sheet_day , sheet_from, sheet_to, sheet_client, sheet_project, sheet_bill_time, rate_per_hour, fixed_price, ((sheet_bill_time * rate_per_hour)+ fixed_price) as money_made, comment , status FROM timesheet  WHERE status = 'open' ORDER BY sheet_year desc, sheet_month desc, sheet_day desc" ;  
	@arr = $objDAL->getArray($sql);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getTimesheetMoneyOpen{
	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('data');
	my @arr;
	my $sql =  "SELECT  sum((sheet_bill_time * rate_per_hour)+ fixed_price) as money_made FROM timesheet WHERE status = 'open' " ;  
	@arr = $objDAL->getOneLineArray($sql);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getTimesheetById{
	my ($self,$id) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my @arr;
        my $sql =  "SELECT id , sheet_year, sheet_month, sheet_day , sheet_from, sheet_to, sheet_client, sheet_project, sheet_bill_time, comment, status, rate_per_hour, fixed_price  FROM timesheet  where id = ".$id."  " ;    
        @arr = $objDAL->getOneLineArray($sql);
	return @arr;
}


# -------------------------------------------------------------------------------------------------
sub deleteToDo{

   my ($self, $id ) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('data');
   my $sql;	
   $sql = "DELETE FROM todo  ";
   $sql .=  " WHERE id = " . $id . " " ;

   if($id ne '' && $id ne 'id'){
      return $objDAL->executeSQL($sql);
   }else{
      return "error";
   }
}
#-------------------------------------------------------------------------------------------------
sub insertIntoToDo{

   my ($self, $category,$important, $urgent, $title, $comment ) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('data');
   my $sql;	
   $sql = "INSERT INTO todo (category, important, urgent, title, comment)VALUES ( ";
   $sql .=  " '" . $category. "'," ;
   $sql .=  " '" . $important. "'," ;
   $sql .=  " '" . $urgent. "'," ;
   $sql .=  " '" . $title. "'," ;
   $sql .=  " '" . $comment. "')" ;

  
   return $objDAL->executeSQL($sql);

}
#-------------------------------------------------------------------------------------------------
sub updateExistingToDo{

   my ($self, $id,$category,$important, $urgent, $title, $comment ) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('data');
   my $sql;	
   $sql = "UPDATE todo SET ";
   $sql .=  "important = '" . $important. "'," ;
   $sql .=  "urgent = '" . $urgent. "'," ;
   $sql .=  "category = '" . $category. "'," ;
   $sql .=  "title = '" . $title. "'," ;
   $sql .=  "comment = '" . $comment. "'" ;
   $sql .=  " WHERE id = " . $id . " " ;

   if($id ne '' && $id ne 'id'){
      return $objDAL->executeSQL($sql);
   }else{
      return "error";
   }
}
#-------------------------------------------------------------------------------------------------
sub getToDoByCategory{
	my ($self,$important, $urgent) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('data');
	my @arr;
        my $sql =  "SELECT id ,category, title, id as id2  FROM todo where important  = '".$important."' and urgent =  '".$urgent."' " ;    
        @arr = $objDAL->getArray($sql);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getToDoById{
	my ($self,$id) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('data');
	my @arr;
        my $sql =  "SELECT id ,category, important, urgent, title, comment  FROM todo where id = ".$id."  " ;    
        @arr = $objDAL->getOneLineArray($sql);
	return @arr;
}

# -------------------------------------------------------------------------------------------------

sub getDataBySearch{
	my ($self,$search) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my @arr;
	my $sql;	

	$sql =  "select id, name, phone, email, concat(left(comment,200),'...') as x , 'file' as uploads from the_list where ";
	$sql .=  "name like '%$search%' or " ;
	$sql .=  "name_2 like '%$search%' or " ;
	$sql .=  "category like '%$search%' or " ;
	$sql .=  "category_detail like '%$search%' or " ;
	$sql .=  "name_2 like '%$search%' or " ;
	$sql .=  "comment like '%$search%' or " ;
	$sql .=  "name like '%$search%'  " ;
	@arr = $objDAL->getArray($sql);
	return @arr;
}
# -------------------------------------------------------------------------------------------------


sub getEmailAddressBySearch{
	my ($self,$search) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my @arr;
	my $sql;	

	$sql =  "select id, name, email from the_list where email  <>'' and (";
	$sql .=  "name like '%$search%' or " ;
	$sql .=  "name_2 like '%$search%' or " ;
	$sql .=  "category like '%$search%' or " ;
	$sql .=  "category_detail like '%$search%' or " ;
	$sql .=  "name_2 like '%$search%' or " ;
	$sql .=  "comment like '%$search%' or " ;
	$sql .=  "name like '%$search%'  )" ;
	$sql .=  " limit 0, 25 " ;
	@arr = $objDAL->getArray($sql);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub updateExistingData{
   my ($self, $id, $name, $phone, $email, $comment, $clip) = @_;
   my $objDAL = DataAccessLayer->new();
   $objDAL->setModul('data');
   my $sql;	
   $sql = "UPDATE the_list SET ";
   $sql .=  "name = '" . $name . "'," ;
   $sql .=  "phone = '" . $phone . "'," ;
   $sql .=  "email = '" . $email . "'," ;
   $sql .=  "comment = '" . $comment . "', " ;
   $sql .=  "mail_link = '" . $clip . "' " ;
   $sql .=  " WHERE id = " . $id . " " ;
   if($id ne '' && $id ne 'id'){
      return $objDAL->executeSQL($sql);
   }else{
      return "error";
   }
}
#-------------------------------------------------------------------------------------------------
sub insertNewData{
   my ($self, $id, $name, $phone, $email, $comment , $clip) = @_;
   my $objDAL = DataAccessLayer->new();
   $objDAL->setModul('data');
   my $sql;	
   $sql = "INSERT INTO the_list (id , name, phone, email, comment, mail_link) VALUES (";
   $sql .=  "'" . $id . "'," ;
   $sql .=  "'" . $name . "'," ;
   $sql .=  "'" . $phone . "'," ;
   $sql .=  "'" . $email . "'," ;
   $sql .=  "'" . $comment . "', " ;
   $sql .=  "'" . $clip . "' " ;
   $sql .=  ") " ;
   if($id ne '' && $id ne 'id'){
      return $objDAL->executeSQL($sql);
   }else{
      return "error";
   }
  
}
#-------------------------------------------------------------------------------------------------
sub getDataById{
	my ($self,$id) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my @arr;
	my $sql =  "select id, name, phone, email, comment , 'file' as uploads, mail_link from the_list where id = ".$id."  " ;  
	@arr = $objDAL->getOneLineArray($sql);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getDataByIdCross{
	my ($self,$id) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my @arr;
    my @arrIds;
    my $sql =  "select list_ids from the_list_cross where id = ".$id."  " ;  
    #print $sql;
	@arr = $objDAL->getOneLineArray($sql);
    my $ids = "";
    $ids = $arr[0];
	$sql =  "select id, name, phone, email, comment , 'file' as uploads from the_list where id in ( ". $ids .")  " ;  
    #print $sql;
    @arr = $objDAL->getArray($sql);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getDataForTableById{
	my ($self,$id) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my @arr;
	my $sql =  "select id, name, phone, email, concat(left(comment,200),'...') as x , 'file' as uploads from the_list where id = ".$id."  " ;  
	@arr = $objDAL->getArray($sql);
	return @arr;
}
# -----------------------------------------------------------------------------------------------------------
sub encodeValues{
	my ($self, $val) = @_;
        my $ret = '';
        $val =~ s/'/#apos;/gi;
        $val =~ s/"/#dpos;/gi ;  
        $val =~ s/</&lt;/gi ;  
        $val =~ s/>/&gt;/gi ;  
	return $val ;
}
# -----------------------------------------------------------------------------------------------------------
sub decodeValues{
	my ($self, $val) = @_;
        my $ret = '';
        $val =~ s/#apos;/'/g;
        $val =~ s/#dpos;/"/g ;  
	return $val ;
}
# -------------------------------------------------------------------------------------------------

sub test{
my ($self) = @_;
my $objDAL = DataAccessLayer->new();
return $objDAL->test();
}
#-------------------------------------------------------------------------------------------------
1; 
