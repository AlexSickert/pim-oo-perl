package AccountingBusinessLayer;




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

#-------------------------------------------------------------------------------------------------
# getBalance
sub getBalance{
	my ($self, $account, $year) = @_;
	my $objDAL = DataAccessLayer->new();
        my $ret;
	
	$objDAL->setModul('accounting');
	my @arr;
        my @arrRet;
        my $sql;

        $arrRet[0] = $account;

        # values this year

	$sql =  "SELECT sum(in_amount)   FROM " . $account . " WHERE year(in_date) <= " . $year . " ";  
    
	@arr = $objDAL->getOneLineArray($sql);
	$arrRet[1] = $arr[0];

	$sql =  "SELECT sum(out_amount)   FROM " . $account . " WHERE year(out_date) <= " . $year . " ";  
    
	@arr = $objDAL->getOneLineArray($sql);
	$arrRet[2] = $arr[0];


        #values of last year

	$sql =  "SELECT sum(in_amount)   FROM " . $account . " WHERE year(in_date) < " . $year . " ";  
    
	@arr = $objDAL->getOneLineArray($sql);
	$arrRet[3] = $arr[0];

	$sql =  "SELECT sum(out_amount)   FROM " . $account . " WHERE year(out_date) < " . $year . " ";  
    
	@arr = $objDAL->getOneLineArray($sql);
	$arrRet[4] = $arr[0];

        return @arrRet;
}

#-------------------------------------------------------------------------------------------------
#getInflowByMonth
sub getInflowByMonth{
	my ($self, $account, $year, $month) = @_;
	my $objDAL = DataAccessLayer->new();
       my $ret;        
	
	$objDAL->setModul('accounting');
	my @arr;
	my $sql =  "SELECT sum(in_amount)   FROM " . $account . " WHERE year(in_date) = " . $year . " and  month(in_date) = " . $month. " ";  
       #print $sql;
	@arr = $objDAL->getOneLineArray($sql);
	$ret = $arr[0];
       return $ret;
}
#-------------------------------------------------------------------------------------------------
#getOutflowByMonth

sub getOutflowByMonth{
	my ($self, $account, $year, $month) = @_;
	my $objDAL = DataAccessLayer->new();
       my $ret;        
	
	$objDAL->setModul('accounting');
	my @arr;
	my $sql =  "SELECT sum(out_amount)   FROM " . $account . " WHERE year(out_date) = " . $year . " and  month(out_date) = " . $month. " ";  
       #print $sql;
	@arr = $objDAL->getOneLineArray($sql);
	$ret = $arr[0];
       return $ret;
}

#-------------------------------------------------------------------------------------------------
# getBalanceByMonth
sub getBalanceByMonth{
	my ($self, $account, $year, $month) = @_;
	my $objDAL = DataAccessLayer->new();
        my $outAmount;
        my $inAmount;
        my $ret;
        my $monthAdjusted;
        my $yearAdjusted;
        my $dateAdjusted;

        if($month eq '12'){        
           $yearAdjusted = $year + 1;
           $dateAdjusted = $yearAdjusted . '-01-01'
        }else{
           $monthAdjusted = $month + 1;
           $dateAdjusted = $year . '-' . $monthAdjusted  . '-01';
        }
        
	
	$objDAL->setModul('accounting');
	my @arr;
	my $sql =  "SELECT sum(in_amount)   FROM " . $account . " WHERE in_date < '" . $dateAdjusted . "' ";  
    
	@arr = $objDAL->getOneLineArray($sql);
	$inAmount= $arr[0];

	$sql =  "SELECT sum(out_amount)   FROM " . $account . " WHERE out_date < '" . $dateAdjusted . "' ";  
    
	@arr = $objDAL->getOneLineArray($sql);
	$outAmount = $arr[0];

        $ret = $inAmount - $outAmount;
        return $ret;
}

#-------------------------------------------------------------------------------------------------
# getInflow (year)
sub getInflow{
	my ($self, $account, $year) = @_;
	my $objDAL = DataAccessLayer->new();
        my $ret;
	
	$objDAL->setModul('accounting');
	my @arr;
	my $sql =  "SELECT sum(in_amount)   FROM " . $account . " WHERE year(in_date) = " . $year . " ";  
    
	@arr = $objDAL->getOneLineArray($sql);
        if($arr[0] ne ''){
           $ret = $arr[0];
        }else{
           $ret = 0;
        }
	return $ret;
}
#-------------------------------------------------------------------------------------------------
# getOutflow
sub getOutflow{
	my ($self, $account, $year) = @_;
	my $objDAL = DataAccessLayer->new();
	my $ret;
	$objDAL->setModul('accounting');
	my @arr;
	my $sql =  "SELECT sum(out_amount)   FROM " . $account . " WHERE year(out_date) = " . $year . " ";  
    
	@arr = $objDAL->getOneLineArray($sql);

	if($arr[0] ne ''){
           $ret = $arr[0];
        }else{
           $ret = 0;
        }
	return $ret;
}
#-------------------------------------------------------------------------------------------------
# getOpeningBalance
sub getOpeningBalance{
	my ($self, $account, $year) = @_;
	my $objDAL = DataAccessLayer->new();
        my $outAmount;
        my $inAmount;
        my $ret;
	
	$objDAL->setModul('accounting');
	my @arr;
	my $sql =  "SELECT sum(in_amount)   FROM " . $account . " WHERE year(in_date) < " . $year . " ";  
    
	@arr = $objDAL->getOneLineArray($sql);
	$inAmount= $arr[0];

	$sql =  "SELECT sum(out_amount)   FROM " . $account . " WHERE year(out_date) < " . $year . " ";  
    
	@arr = $objDAL->getOneLineArray($sql);
	$outAmount = $arr[0];

        $ret = $inAmount - $outAmount;
        return $ret;
}

#-------------------------------------------------------------------------------------------------
# getClosingBalance
sub getClosingBalance{
	my ($self, $account, $year) = @_;
	my $objDAL = DataAccessLayer->new();
        my $outAmount;
        my $inAmount;
        my $ret;
	
	$objDAL->setModul('accounting');
	my @arr;
	my $sql =  "SELECT sum(in_amount)   FROM " . $account . " WHERE year(in_date) <= " . $year . " ";  
    
	@arr = $objDAL->getOneLineArray($sql);
	$inAmount= $arr[0];

	$sql =  "SELECT sum(out_amount)   FROM " . $account . " WHERE year(out_date) <= " . $year . " ";  
    
	@arr = $objDAL->getOneLineArray($sql);
	$outAmount = $arr[0];

        $ret = $inAmount - $outAmount;
        return $ret;
}
#-------------------------------------------------------------------------------------------------
sub getAccount{
	my ($self, $account) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('accounting');
	my @arr;
	my $sql =  "SELECT in_date , in_account, in_currency, in_amount, in_comment, out_date, out_account, out_currency, out_amount, out_comment  FROM " . $account . " order by id desc";  
    
	@arr = $objDAL->getArray($sql);
	return @arr;
}


#--------------------------------------------------------------------------------------------------------------------------------------------------------------
#  new method inserted January 2010
# SELECT if(in_date > out_date, in_date, out_date) as xxx, in_amount FROM `account_UST_7` WHERE 1 order by xxx desc
#--------------------------------------------------------------------------------------------------------------------------------------------------------------

sub getAccountByDate{
	my ($self, $account, $from, $to) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('accounting');
	my @arr;

        # new sort order:  SELECT  if(in_date > out_date, in_date, out_date) as sort_date, .... order by  sort_date desc
	my $sql =  "SELECT if(in_date > out_date, in_date, out_date) as sort_date,  in_date , in_account, in_currency, in_amount, in_comment, out_date, out_account, out_currency, out_amount, out_comment  FROM " . $account . " WHERE (in_date >= '" . $from . "' AND in_date <= '" . $to . "') OR (out_date >= '" . $from . "' AND out_date <= '" . $to . "')  order by sort_date desc";  
    
	@arr = $objDAL->getArray($sql);
	return @arr;
}

#-------------------------------------------------------------------------------------------------
sub getAccountInOutBalance{
	my ($self, $account) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('accounting');
	my @arr;
	my $sql =  "SELECT sum(in_amount), sum(out_amount), (sum(in_amount) - sum(out_amount))   FROM " . $account;  
    
	@arr = $objDAL->getOneLineArray($sql);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getMaxTransactionId{

    my ($self) = @_;
    my $objDAL = DataAccessLayer->new();
    $objDAL->setModul('accounting');
    my $sql_string;	
    my @arr;    
        
    $sql_string = 'Select max(id)  from accounting_tracker';

    @arr = $objDAL->getOneLineArray($sql_string);
    return $arr[0];
    
    
}

#-------------------------------------------------------------------------------------------------
# this is the standard way to insert a transaction !!!!!!!
sub  makeTransaction{
    my ($self, $transactionFrom, $transactionTo, $transactionDate, $transactionAmount, $transactionComment) = @_;
    my $objDAL = DataAccessLayer->new();
    
    $objDAL->setModul('accounting');
    my $sql_string;	

    $sql_string = 'insert into ' . $transactionFrom . ' (   
    out_date ,
    out_account,
    out_currency,
    out_amount,
    out_comment  ) values  (';
    
    $sql_string .= "'" . $transactionDate . "',";
    $sql_string .= "'" . $transactionTo . "',";
    $sql_string .= "'EUR',";
    $sql_string .= "" . $transactionAmount . ",";
    $sql_string .= "'" . $transactionComment . "')";
    
    $objDAL->executeSQL($sql_string);
    
    $sql_string = 'insert into ' . $transactionTo . ' (   
    in_date ,
    in_account,
    in_currency,
    in_amount,
    in_comment  ) values  (';
    
    $sql_string .= "'" . $transactionDate . "',";
    $sql_string .= "'" . $transactionFrom . "',";
    $sql_string .= "'EUR',";
    $sql_string .= "" . $transactionAmount . ",";
    $sql_string .= "'" . $transactionComment . "')";
    
    $objDAL->executeSQL($sql_string);
    
    $sql_string = 'insert into accounting_tracker (  
    trans_date,
    from_account,
    to_account,
    currency,
    amount,
    comment  ) values  (';    
    
    $sql_string .= "'" . $transactionDate . "',";
    $sql_string .= "'" . $transactionFrom . "',";
    $sql_string .= "'" . $transactionTo . "',";
    $sql_string .= "'EUR',";
    $sql_string .= "" . $transactionAmount . ",";
    $sql_string .= "'" . $transactionComment . "')";
    
    $objDAL->executeSQL($sql_string);
    
}

#-------------------------------------------------------------------------------------------------
sub getCompanies{
	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('accounting');
	my @arr;
	my $sql =  "SELECT id, prefix, name FROM company" ;  
	@arr = $objDAL->getArray($sql);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getCompanyById{
    my ($self, $v_id) = @_;
    my $objDAL = DataAccessLayer->new();
    $objDAL->setModul('accounting');
    my $sql_string;	
    my @arr;    
        
    $sql_string =  "SELECT id, prefix, name FROM company where ";
    $sql_string = $sql_string . "id = ".$v_id."  " ;

    @arr = $objDAL->getOneLineArray($sql_string);
    return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getAccountsByPrefix{
	my ($self, $prefix) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('accounting');
	my @arr;
	my $sql =  "SELECT id, company, table_name, description FROM acc_accounts WHERE company = '" . $prefix . "'  " ;  
    
    if ($prefix eq ''){
        $sql .=  " or company is null";
    }
    
	@arr = $objDAL->getArray($sql);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getAccountsForExport{
    my $returnValue;
	my @arr;
    my $y;
    
    $returnValue = "";
    
    my ($self, $prefix) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('accounting');

	my $sql =  "SELECT table_name, description FROM acc_accounts WHERE visible = 'yes' and company = '" . $prefix . "'  " ;  
    
    if ($prefix eq ''){
        $sql .=  " or company is null";
    }
    
    $sql .=  " order by description ";

	@arr = $objDAL->getArray($sql);
        
    return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getAccountsForExportSorted{
    my $returnValue;
	my @arr;
    my $y;
    
    $returnValue = "";
    
    my ($self, $prefix) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('accounting');

	my $sql =  "SELECT table_name, description, ";  
        $sql .=  " sales_vat, ";
        $sql .=  " sales_account, ";
        $sql .=  " sales_debtors, ";
        $sql .=  " sales_pay_type, ";
        $sql .=  " supplier_product_type, ";
        $sql .=  " supplier_vat, ";
        $sql .=  " supplier_account_liability, ";
        $sql .=  " supplier_pay_type ";

        $sql .=  " FROM acc_accounts WHERE visible = 'yes' and company = '" . $prefix . "'" ;  
       
        $sql .=  " ORDER BY sales_vat desc, sales_account desc, sales_debtors desc, sales_pay_type desc, supplier_product_type desc, supplier_vat desc, supplier_account_liability desc, supplier_pay_type desc ";


    @arr = $objDAL->getArray($sql);
    return @arr;
}
# ------------------------------------------------------------------------------------------------
sub getAccountsForDropdownByCategory{

    my $returnValue;
    my @arr;
    my $y;
    
    $returnValue = "";
    
    my ($self, $prefix, $filterField) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('accounting');

	my $sql =  "SELECT table_name, description FROM acc_accounts WHERE visible = 'yes' and " . $filterField . "= 'yes' and company = '" . $prefix . "'  " ;  
    
    if ($prefix eq ''){
        $sql .=  " or company is null";
    }
    
    $sql .=  " order by description ";

	@arr = $objDAL->getArray($sql);
    
    $returnValue = '';
    
    for $y (0.. $#arr){
        $returnValue .= $arr[$y][0] . '<f>' . $arr[$y][1] . '<r>';
    }
    
    return $returnValue;
}
#-------------------------------------------------------------------------------------------------
sub getAccountsForDropdown{
    my $returnValue;
	my @arr;
    my $y;
    
    $returnValue = "";
    
    my ($self, $prefix) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('accounting');

	my $sql =  "SELECT table_name, description FROM acc_accounts WHERE visible = 'yes' and company = '" . $prefix . "'  " ;  
    
    if ($prefix eq ''){
        $sql .=  " or company is null";
    }
    
    $sql .=  " order by description ";

	@arr = $objDAL->getArray($sql);
    
    $returnValue = '';
    
    for $y (0.. $#arr){
        $returnValue .= $arr[$y][0] . '<f>' . $arr[$y][1] . '<r>';
    }
    
    return $returnValue;
}
#-------------------------------------------------------------------------------------------------
sub createAccountandRegister{
    my ($self, $companyPrefix, $prefix,$description) = @_;
    my $newAccountSql;
    my $newAccountName;
    my $insertAccountName;
    
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('accounting');    
    
    $newAccountName = $companyPrefix . '_' . $prefix;
    
    $newAccountSql = "
                       CREATE TABLE IF NOT EXISTS  `" . $newAccountName . "` (
                       `id` int(11) NOT NULL auto_increment,
                       `code` varchar(100) default NULL,
                       `in_date` date default '0000-00-00',
                       `in_currency` varchar(100) default 'EUR',
                       `in_account` varchar(100) default NULL,
                       `in_amount` decimal(10,2) default '0.00',
                       `in_comment` text,
                       `out_date` date default '0000-00-00',
                       `out_account` varchar(100) default NULL,
                       `out_currency` varchar(100) default 'EUR',
                       `out_amount` decimal(10,2) default '0.00',
                       `out_comment` text,
                       `last_update` datetime default NULL,
                       `last_update_by` varchar(10) default NULL,
                       `document_data` date default '0000-00-00',
                       PRIMARY KEY  (`id`)
                       ) ENGINE=MyISAM DEFAULT CHARSET=latin1;
                 ";
                 
    $objDAL->executeSQL($newAccountSql);
    
    $insertAccountName = "insert into acc_accounts(table_name,description,company) values ('".$newAccountName."','".$description."','".$companyPrefix."')";
    
    $objDAL->executeSQL($insertAccountName);
    
    
}
#-------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------
sub getCrossLinkString{
   my ($self, $v_p_id, $class, $baseLink) = @_;
   my $objDAL = DataAccessLayer->new();
   $objDAL->setModul('accounting');
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
        
    $sql_string =  "select * from the_list_cross where ";
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
sub getCompanieskkkkkk{
	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('accounting');
	my @arr;
    my @a;
    my $a;
    my $y;
	my $sql =  "SELECT id, prefix, name FROM company ";  
	
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

#-------------------------------------------------------------------------------------------------
sub getTimesheetMoneyOpen{
	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('data');
	my @arr;
	my $sql =  "SELECT  sum((sheet_bill_time * rate_per_hour)+ fixed_price) as money_made FROM timesheet WHERE status <> 'billed' " ;  
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


#-------------------------------------------------------------------------------------------------
sub updateExistingData{
   my ($self, $id, $name, $phone, $email, $comment) = @_;
   my $objDAL = DataAccessLayer->new();
   $objDAL->setModul('data');
   my $sql;	
   $sql = "UPDATE the_list SET ";
   $sql .=  "name = '" . $name . "'," ;
   $sql .=  "phone = '" . $phone . "'," ;
   $sql .=  "email = '" . $email . "'," ;
   $sql .=  "comment = '" . $comment . "' " ;
   $sql .=  " WHERE id = " . $id . " " ;
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
	my $sql =  "select id, name, phone, email, comment , 'file' as uploads from the_list where id = ".$id."  " ;  
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
# -------------------------------------------------------------------------------------------------

sub test{
my ($self) = @_;
my $objDAL = DataAccessLayer->new();
return $objDAL->test();
}
#-------------------------------------------------------------------------------------------------
1; 
