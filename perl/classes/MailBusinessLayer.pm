package MailBusinessLayer;


use MIME::Base64;

require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailParser.pm';

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
sub getVersion{
   	my ($self) = @_;
	return '2012-09-22-A';
}


#-------------------------------------------------------------------------------------------------
# register attachment
# new method - nt teste yest - 
# created in july 2010
# add replacement for start sign!!!
#-------------------------------------------------------------------------------------------------
sub unRegisterAttachment{

   	my ($self, $id, $nameLocal, $nameDescription, $type, $size) = @_;
   	my $objDAL = DataAccessLayer->new();   
   	$objDAL->setModul('mail');
   	my $sql;	

   	$sql = "DELETE FROM  attachments WHERE mail_id = " . $id;
      	return $objDAL->executeSQL($sql);
}
#-------------------------------------------------------------------------------------------------
# register attachment
#-------------------------------------------------------------------------------------------------
sub registerAttachment{

   	my ($self, $id, $nameLocal, $nameDescription, $type, $size) = @_;
   	my $objDAL = DataAccessLayer->new();   
   	$objDAL->setModul('mail');
   	my $sql;	

	my $v_day = (localtime())[3];
	my $v_month = (localtime())[4];
	$v_month = $v_month + 1;
	my $v_year = (localtime())[5] + 1900;

	my $date = $v_year . "-" . $v_month . "-" . $v_day;

   	$sql = "INSERT INTO attachments(mail_id, local_name, original_name, mime_type, size, date_saved) values(";
	$sql .= "'" . $id . "', ";
	$sql .= "'" . $nameLocal . "', ";
	$sql .= "'" . $nameDescription . "', ";
	$sql .= "'" . $type . "', ";
	$sql .= " " . $size . ", ";
	$sql .= "'" . $date . "') ";

      	return $objDAL->executeSQL($sql);
}
#-------------------------------------------------------------------------------------------------
# create list of links
#-------------------------------------------------------------------------------------------------
sub getAttachmentLinks{

   	my ($self, $id, $v_s, $v_u) = @_;
   	my $objDAL = DataAccessLayer->new();
   
   	$objDAL->setModul('mail');
   	my $sql;	
   	$sql =  "SELECT id, mail_id, original_name FROM attachments WHERE mail_id = " . $id ;

  	 my @arr;
   	@arr = $objDAL->getArray($sql);
	my $ret = "";
	my $y;
	my $pageTmp = Page->new();

   	for $y (0.. $#arr){
		#$ret .= "<a href='./attachmentStreamer.pl?v_s=".$v_s."&v_u=".$v_u."&att=". $arr[$y][0] ."' target='_blank'>" . $arr[$y][2] . "</a>"
		$ret .= "&nbsp;" . $pageTmp->getPopLink("mailAttachmentStyle", "./attachmentStreamer.pl?v_s=".$v_s."&v_u=".$v_u."&att=". $arr[$y][0] , $arr[$y][2]);
	}
	return $ret;
}
#-------------------------------------------------------------------------------------------------
# get parameters to stream the file
#-------------------------------------------------------------------------------------------------
sub getAttachmentParams{

   	my ($self, $id) = @_;
   	my $objDAL = DataAccessLayer->new();
   	$objDAL->setModul('mail');
   	my $sql;	
   	$sql =  "SELECT mail_id, local_name,  mime_type, original_name FROM attachments WHERE id = " . $id ;
  	 my @arr;
	@arr = $objDAL->getOneLineArray($sql);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getFolderName{

   my ($self) = @_;

   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('admin');
   my $sql;	
   $sql =  "SELECT drop_down_text, drop_down_value FROM drop_down WHERE modul = 'mail' and drop_down_name = 'folder'  " ;

   my @arr;
   @arr = $objDAL->getArray($sql);
   return @arr;

}
#-------------------------------------------------------------------------------------------------
sub getDefaultFolderName{

   my ($self) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('admin');
   my $sql;	
   $sql =  "SELECT drop_down_text, drop_down_value FROM drop_down WHERE modul = 'mail' and drop_down_name = 'defaultfolder'  " ;

   my @arr;
   @arr = $objDAL->getArray($sql);
   return @arr;

}

# -------------------------------------------------------------------------------------------------
# Get emails addresses to be moved to spam
# -------------------------------------------------------------------------------------------------
sub getSpamAdresses{

   my ($self) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('admin');
   my $sql;	
   $sql =  "SELECT drop_down_text, drop_down_value FROM drop_down WHERE modul = 'mail' and drop_down_name = 'spam'  " ;

   my @arr;
   @arr = $objDAL->getArray($sql);
   return @arr;

}
#-------------------------------------------------------------------------------------------------

sub setMailRead{


   my ($self, $id) = @_;

   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('mail');
   my $sql;	
   $sql = "UPDATE mail set mail_status = 'r' WHERE id=" . $id;

   if($id ne '' && $id ne 'id' && $id ne '*' ){
      return $objDAL->executeSQL($sql);
   }else{
      return "error";
   }


}
#-------------------------------------------------------------------------------------------------

sub setMailDeleted{

   my ($self) = @_;

   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('mail');
   my $sql;	

   $sql = "UPDATE mail set mail_status = 'd', ";
   $sql .= " sender = '',";
   $sql .= " recipient = '',";
   $sql .= " mail_subject = '',";
   $sql .= " read_version = '',";
   $sql .= " content = '',";
   $sql .= " mail_date_string = '' ";
   $sql .= " WHERE folder = '0' "  ;


      #print $sql;
   return $objDAL->executeSQL($sql);
   #return $sql;

}
#-------------------------------------------------------------------------------------------------


sub moveFolder{
   my ($self, $fromFolder, $toFolder) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('mail');
   my $sql;	
   $sql = "UPDATE mail set folder = '" . $toFolder . "' WHERE folder =" . $fromFolder;

   if($fromFolder ne '' && $fromFolder ne 'id' && $toFolder ne '' && $toFolder ne 'folder'){
      return $objDAL->executeSQL($sql);
   }else{
      return "error";
   }

}


#-------------------------------------------------------------------------------------------------
sub moveMail{
   my ($self, $id, $folder) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('mail');
   my $sql;	
   $sql = "UPDATE mail set folder = '" . $folder . "' WHERE id=" . $id;

   if($id ne '' && $id ne 'id' && $folder ne '' && $folder ne 'folder'){
      return $objDAL->executeSQL($sql);
   }else{
      return "error";
   }

}
#-------------------------------------------------------------------------------------------------
sub getMailById{
   my ($self, $id) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('mail');
   my $sql;	
   $sql = "SELECT id, sender, recipient, mail_subject, load_year, load_month, folder, read_version, folder_name, uid FROM mail WHERE id =" . $id;
   my @arr;
   @arr = $objDAL->getOneLineArray($sql);

   $arr[1] = decode_base64($arr[1]);
   $arr[2] = decode_base64($arr[2]);
   $arr[3] = decode_base64($arr[3]);

   return @arr;
}


#-------------------------------------------------------------------------------------------------
# get mail id by uid    
#-------------------------------------------------------------------------------------------------
sub getMailIdByUid{

   	my ($self, $uid) = @_;
   	my $objDAL = DataAccessLayer->new();
   	$objDAL->setModul('mail');
   my $sql;	
   	$sql =  "SELECT id  FROM mail WHERE uid = '" . $uid . "'";
  	 my @arr;
	@arr = $objDAL->getArray($sql);
        return $arr[0][0];

}

#-------------------------------------------------------------------------------------------------
# this one is used by the link list ajax method
#-------------------------------------------------------------------------------------------------
sub getMailsByIds{
   my ($self, $id) = @_;
   my $objDAL = DataAccessLayer->new();
   $objDAL->setModul('mail');
   my $sql;	
   $sql = "SELECT id, sender, recipient, mail_subject, load_year, load_month FROM mail WHERE id in (" . $id . ") ORDER BY id desc";
   my @arr;
   @arr = $objDAL->getArray($sql);
   return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getNextMailId{
   my ($self) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('mail');
   my $sql;	
   $sql = "SELECT max(id) + 1 FROM mail  ";
   my @arr;
   @arr = $objDAL->getArray($sql);

   return $arr[0][0];

}
#-------------------------------------------------------------------------------------------------
sub registerMail{

   my ($self, $uid, $sender , $recipient, $mail_subject, $load_year, $load_month, $folder_name, $readVersion, $content, $mailDateString, $mailDateDate ) = @_;
   my $objDAL = DataAccessLayer->new();
   
   $objDAL->setModul('mail');

   $uid = $self->cleanForSql($uid);
   $sender = $self->cleanForSql($sender );
   $recipient = $self->cleanForSql($recipient);
   $mail_subject = $self->cleanForSql($mail_subject);
   $load_year = $self->cleanForSql($load_year);
   $load_month = $self->cleanForSql($load_month);
   $folder_name = $self->cleanForSql($folder_name);
   $readVersion = $self->cleanForSql($readVersion);
   $content = $self->cleanForSql($content);
   $mailDateString = $self->cleanForSql($mailDateString);
   $mailDateDate = $self->cleanForSql($mailDateDate );
   # august 2009 - add the file size

   my $sql;	
   $sql = "INSERT INTO mail (uid, sender, recipient, mail_subject, load_year, load_month, folder_name, mail_status, folder, read_version, content, mail_date_string, mail_date_date) VALUES ( ";
   $sql .=  "'" . $uid . "'," ;
   $sql .=  "'" . $sender . "'," ;
   $sql .=  "'" . $recipient   . "'," ;
   $sql .=  "'" . $mail_subject . "'," ;
   $sql .=  "'" . $load_year . "'," ;
   $sql .=  "'" . $load_month . "'," ;
   $sql .=  "'" . $folder_name . "'," ;
   $sql .=  "'n'," ;
   $sql .=  " '1'," ;
   $sql .=  "'" . $readVersion  . "'," ;
   $sql .=  "'" . $content . "'," ;
   $sql .=  "'" . $mailDateString . "'," ;
   $sql .=  "'" . $mailDateDate . "'" ;
   $sql .=  " )" ;
   #print $sql;
   return $objDAL->executeSQL($sql);

}
#-------------------------------------------------------------------------------------------------
sub getUidArray{
	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('mail');
	my @arr;
	my $sql =  "SELECT uid, id FROM mail ORDER BY id desc LIMIT 0, 9000" ;  
	@arr = $objDAL->getArray($sql);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getNewMail{
   my ($self, $id) = @_;
   my $objDAL = DataAccessLayer->new();
	
   $objDAL->setModul('mail');
   my @arr;
   my @a;
   my $a;
   my $y;
   my $return;
   my $sql =  "SELECT id, sender, recipient, mail_subject, mail_date_date FROM mail WHERE id >= " . $id;  
   @arr = $objDAL->getArray($sql);


   my $page = Page->new();
   my $dropTemplate ;
   my $dropTemplateCurr ;
   my $mailId;
   $dropTemplate = Page->getDropdownEditableWithOnChange('', '','mail', 'folder', '1', 'moveMail(#id#, this)' );

    
   #transform into div
   for $y (0.. $#arr){
      $return .= "<table style='width: 900px;'><tr  id='mail_" . $arr[$y][0] . "' class='mail_new'>";

         $return .= "<td class='mail_from' >getNewMail()<input type='button' value='T' onclick='trashMail(". $arr[$y][0] .")' /></td>";
         $return .= "<td class='mail_from' >" . $self->formatFromTo($self->noHtml(decode_base64($arr[$y][1]))) . "&nbsp;</td>";

         $mailId = $arr[$y][0];
         $dropTemplateCurr = $dropTemplate;
         $dropTemplateCurr =~ s/#id#/$mailId/gi;

         #$return .= "<td class='mail_from' ><input type='button' value='".$arr[$y][1]."' >" . $dropTemplateCurr . "</td>";

         $return .= "<td class='mail_subject'  onclick='showMail(".$arr[$y][0].")'>" . $self->limitLength($self->noHtml($self->formatSubject(decode_base64($arr[$y][3])))) . "&nbsp;</td>";
         $return .= "<td class='mail_to' >" . $self->formatFromTo($self->noHtml(decode_base64($arr[$y][2]))) . "&nbsp;</td>";
         #$return .= "<td class='mail_date' >" . $self->noHtml($arr[$y][4]) . "&nbsp;</td>";

      $return .= "</tr></table>getNewMail";
   }

   return $return ;
}
#-------------------------------------------------------------------------------------------------
sub limitLength{
   my ($self, $string) = @_;

   if(length($string) > 50){
      return substr($string,0,50) . " (...)";
   }else{
      return $string;
  }
}
#-------------------------------------------------------------------------------------------------
sub formatFromTo{
   my ($self, $string) = @_;
   my @arr;


   my $objMail = MailParser->new();
  
   $string = $objMail->cleanFromToSubject($string);

   if($string =~ m/\[/){
      @arr = split(/\[/, $string);
      #$string = substr($arr[0],0,30) . "<br />[" . substr($arr[1],0,30);
      $string = substr($arr[0],0,30) . "&nbsp;[" . substr($arr[1],0,30);
   }else{
      $string = substr($string ,0,30);
   }
   return $string;
}
#-------------------------------------------------------------------------------------------------
sub formatSubject{

   my ($self, $string) = @_;
   my $objMail = MailParser->new();
   $string = $objMail->cleanFromToSubject($string) ;

   if($string eq ''){
      $string = '(none)';
   }

   return $string;
}
#-------------------------------------------------------------------------------------------------
sub getRawMailsByFolderAndSearch{
   my ($self, $folder, $search) = @_;

   my $objDAL = DataAccessLayer->new();	
   $objDAL->setModul('mail');

   my @arr;
   my @a;
   my $a;
   my $y;
   my $return;
   my $sql;

   if($folder ne 'allFolders'){
      $sql =  "SELECT  id, sender, recipient, mail_subject, load_year, load_month, folder, read_version, folder_name, mail_status  FROM mail WHERE folder = '" . $folder . "' and content like '%" . $search . "%'   and mail_status <> 'd'  order by mail_date_date desc, id desc  LIMIT 0, 200";  
   }else{
      $sql =  "SELECT  id, sender, recipient, mail_subject, load_year, load_month, folder, read_version, folder_name, mail_status  FROM mail WHERE content like '%" . $search . "%'   and mail_status <> 'd'  order by mail_date_date desc, id desc   LIMIT 0, 200";  
   }

   @arr = $objDAL->getArray($sql);

   return @arr;
}
#-------------------------------------------------------------------------------------------------
sub getMailsByFolderAndSearch{
   my ($self, $folder, $search) = @_;

   my $objDAL = DataAccessLayer->new();	
   $objDAL->setModul('mail');
   my $sql;
   my $sqlCount;
   my $return;

   if($folder ne 'allFolders'){
	$sql =  "SELECT id, sender, recipient, mail_subject, mail_date_date, mail_status, folder  FROM mail WHERE folder = '" . $folder . "' and content like '%" . $search . "%'  and mail_status <> 'd' order by mail_date_date desc, id desc    LIMIT 0, 200";  
        $sqlCount =  "SELECT count(id) FROM mail WHERE folder = '" . $folder . "' and content like '%" . $search . "%'  and mail_status <> 'd' order by mail_date_date desc, id desc    LIMIT 0, 200";  
   }else{
	$sql =  "SELECT id, sender, recipient, mail_subject, mail_date_date, mail_status, folder  FROM mail WHERE  content like '%" . $search . "%'  and mail_status <> 'd' order by mail_date_date desc, id desc    LIMIT 0, 200"; 
        $sqlCount =  "SELECT count(id) FROM mail WHERE  content like '%" . $search . "%'  and mail_status <> 'd' order by mail_date_date desc, id desc    LIMIT 0, 200";   
   }

   $return = $self->getMailsBySql($sql, $sqlCount, 100) ;
   $return .= " getMailsByFolderAndSearch () - " . $self->getVersion(); 
   return $return ;
}
#-------------------------------------------------------------------------------------------------

sub getUnreadMails{
   my ($self) = @_;
   return $self->getMailsbyCategory('n');
}
#-------------------------------------------------------------------------------------------------

sub getReadMails{
   my ($self) = @_;
   return $self->getMailsbyCategory('r');
}

#-------------------------------------------------------------------------------------------------

sub getInboxMails{
   my ($self) = @_;
   return $self->getMailsbyCategory('inbox');
}
# -------------------------------------------------------------------------------------------------
# 
# -------------------------------------------------------------------------------------------------

sub getMailsbyCategory{
   my ($self, $category) = @_;

   my $objDAL = DataAccessLayer->new();	
   $objDAL->setModul('mail');

   my $sql; 
   my $sqlCount; 
   my $return;

   if ($category eq 'inbox'){
      # $sql =  "SELECT id, sender, recipient, mail_subject, mail_date_date,mail_status, folder  FROM mail WHERE  folder = '1' order by mail_date_date desc, id desc";  
      $sql =  "SELECT id, sender, recipient, mail_subject, mail_date_date,mail_status, folder  FROM mail WHERE  folder = '1' order by sender, id desc    LIMIT 0, 200";  
      $sqlCount = "SELECT count(id)  FROM mail WHERE  folder = '1' order by sender asc, id desc    LIMIT 0, 200";  
   }

   if ($category eq 'r' || $category eq 'u'){
      # $sql =  "SELECT id, sender, recipient, mail_subject, mail_date_date,mail_status, folder  FROM mail WHERE mail_status = '".$category."' and folder = '1' order by mail_date_date desc, id desc";  
      $sql =  "SELECT id, sender, recipient, mail_subject, mail_date_date,mail_status, folder  FROM mail WHERE mail_status = '".$category."' and folder = '1' order by sender, id desc    LIMIT 0, 200";  
      
      $sqlCount =  "SELECT count(id)  FROM mail WHERE mail_status = '".$category."' and folder = '1' order by mail_date_date desc, id desc    LIMIT 0, 200";  
   }

   $return = $self->getMailsBySql($sql, $sqlCount, 100) . " getMailsbyCategory ()" . $self->getVersion(); 
   return $return ;
}


# -------------------------------------------------------------------------------------------------
#   getMailsbyCategoryCompact - for compact display
# -------------------------------------------------------------------------------------------------

sub getMailsbyCategoryCompact{
   my ($self, $category) = @_;

   my $objDAL = DataAccessLayer->new();	
   $objDAL->setModul('mail');

   my $sql; 
   my $sqlCount; 
   my $return;

   if ($category eq 'inbox'){
      $sql =  "SELECT id, sender, recipient, mail_subject, mail_date_date,mail_status, folder  FROM mail WHERE  folder = '1' order by mail_date_date desc, id desc    LIMIT 0, 200";  
      $sqlCount = "SELECT count(id)  FROM mail WHERE  folder = '1' order by mail_date_date desc, id desc    LIMIT 0, 200";  
   }

   if ($category eq 'r' || $category eq 'u'){
      $sql =  "SELECT id, sender, recipient, mail_subject, mail_date_date,mail_status, folder  FROM mail WHERE mail_status = '".$category."' and folder = '1' order by mail_date_date desc, id desc    LIMIT 0, 200";  
      $sqlCount =  "SELECT count(id)  FROM mail WHERE mail_status = '".$category."' and folder = '1' order by mail_date_date desc, id desc    LIMIT 0, 200";  
   }

   $return = $self->getMailsBySqlCompact($sql, $sqlCount, 100) . " getMailsBySqlCompact()" . $self->getVersion(); 
   return $return ;
}
# -------------------------------------------------------------------------------------------------
# 
# -------------------------------------------------------------------------------------------------
sub getMailsBySql{
   my ($self, $sqlContent,$sqlCount, $limit) = @_;
	#my ($self, $sqlContent,$sqlCount, $limit);

   my $objDAL = DataAccessLayer->new();
	
   $objDAL->setModul('mail');
   my @arr;
   my @a;
   my $a;
   my $y;
   my $iFolder;
   my $iDefault;
   my $iDefaultFolderString;
   my $iDefaultFolderName;
   my $return;
   my $classPart;
   my $senderString; 

   # text, value
   my @arrDefaultFolder = $self->getDefaultFolderName();
   my @arrFolder = $self->getFolderName();

   @arr = $objDAL->getArray($sqlContent);

   my $page = Page->new();
   my $dropTemplate ;
   my $dropTemplateCurr ;
   my $mailId;
   my $currFolder;
   my $iDefaultFolderStringDescription;
   $dropTemplate = $page->getDropdownEditableWithOnChange('', '','mail', 'folder', '1', 'moveMail(#id#, this)' );

   #transform into div
   $return = "<table style='width: 900px;'>";
   for $y (0.. $#arr){
      		$return .= "<tr style='position: relative; float:none'  id='mail_" . $arr[$y][0] . "' class='mail_unread'>";
	      if($arr[$y][5] eq 'r' ){
	         $classPart = "read";
	      }else{
	         $classPart = "unread";
	      }
	      $return .= "<td  id='mail_button_" . $arr[$y][0] . "' class='mail_button' ><input type='button' value='&nbsp;X&nbsp;' onclick='trashMail(". $arr[$y][0] .")' /></td>";  
	      $return .= "<td  id='mail_from_" . $arr[$y][0] . "' class='mail_".$classPart."' onclick='showMail(".$arr[$y][0].")' >" . $self->formatFromTo($self->noHtml(decode_base64($arr[$y][1]))) . "<br />" . $self->limitLength($self->noHtml($self->formatSubject(decode_base64($arr[$y][3])))) . "</td>";
	      $mailId = $arr[$y][0];
	      $dropTemplateCurr = $dropTemplate;
	      $dropTemplateCurr =~ s/#id#/$mailId/gi;
	      
	      # find default folder id
	      $iDefaultFolderString = $arr[$y][6] ;
	      $senderString = decode_base64($arr[$y][1]) . decode_base64($arr[$y][2]) ;
	      for $iDefault (0.. $#arrDefaultFolder){
	         if ($senderString =~ m/$arrDefaultFolder[$iDefault ][0]/i){
	            $iDefaultFolderString = $arrDefaultFolder[$iDefault ][1];
	         }
	      }
	      # find folder id
	      $iDefaultFolderName = "";
	      for $iFolder (0.. $#arrFolder){
	         if ($iDefaultFolderString =~ m/$arrFolder[$iFolder ][1]/i){
	            $iDefaultFolderName = $arrFolder[$iFolder ][0];
	         }
	      }
		if($iDefaultFolderString < 10){
			$iDefaultFolderStringDescription = "0" . $iDefaultFolderString ;
		}else{
			$iDefaultFolderStringDescription = $iDefaultFolderString ;
		}
	      $return .= "<td class='mail_from' ><input type='button' onclick='mailSetOrgAction(".$arr[$y][0].")' value='Org' ></td>";
	      $return .= "<td class='mail_from' ><input type='button' onclick='moveToDefaultFolder(".$arr[$y][0].",".$iDefaultFolderString.",1)' value='&rarr;&nbsp;" . $iDefaultFolderStringDescription ."' ></td>";
	      # recipient
	      $return .= "<td  id='mail_to_" . $arr[$y][0] . "' class='mail_".$classPart."' >" . $self->formatFromTo($self->noHtml(decode_base64($arr[$y][2]))) . "&nbsp;</td>";
	     # show the drop down for selecting the folder

		$currFolder = $arr[$y][6];
		if($currFolder < 10){
			$currFolder = "0" . $currFolder;
		}

	      $return .= "<td class='mail_from' ><input type='button' onclick='showFolderDropDown(".$arr[$y][0].")' value='&rarr;&nbsp;? (" . $currFolder . ")' ></td>";  
	      $return .= "<td class='mail_from' ><input type='button' onclick='mailReparse(".$arr[$y][0].")' value='R' ></td>";   
	      $return .= "</tr>";
   }

   $return .= "</table>getMailsBySql-" . $self->getVersion(); 
   return $return ;
}

# -------------------------------------------------------------------------------------------------
# getMailsBySqlCompact
# -------------------------------------------------------------------------------------------------

sub getMailsBySqlCompact{
   my ($self, $sqlContent,$sqlCount, $limit) = @_;
	#my ($self, $sqlContent,$sqlCount, $limit);

   my $objDAL = DataAccessLayer->new();
	
   $objDAL->setModul('mail');
   my @arr;
   my @a;
   my $a;
   my $y;
   my $iFolder;
   my $iDefault;
   my $iDefaultFolderString;
   my $iDefaultFolderName;
   my $return;
   my $classPart;
   my $senderString; 

   # text, value
   my @arrDefaultFolder = $self->getDefaultFolderName();
   my @arrFolder = $self->getFolderName();

   @arr = $objDAL->getArray($sqlContent);

   my $page = Page->new();
   my $dropTemplate ;
   my $dropTemplateCurr ;
   my $mailId;
   my $currFolder;
   my $iDefaultFolderStringDescription;
   $dropTemplate = $page->getDropdownEditableWithOnChange('', '','mail', 'folder', '1', 'moveMail(#id#, this)' );

   #transform into div
   $return = "<table style='width: 100%;'>";
   for $y (0.. $#arr){
      		$return .= "<tr style='position: relative; float:none'  id='mail_" . $arr[$y][0] . "' class='mail_unread'>";
	      if($arr[$y][5] eq 'r' ){
	         $classPart = "read";
	      }else{
	         $classPart = "unread";
	      }
	      # just the button
	      $return .= "<td  id='mail_button_" . $arr[$y][0] . "' class='mail_button' ><input type='button' value='&nbsp;X&nbsp;' onclick='trashMail(". $arr[$y][0] .")' /></td>";  
	      # just the text
              $return .= "<td  id='mail_from_" . $arr[$y][0] . "' class='mail_".$classPart."' onclick='showMailAjaxInline(".$arr[$y][0].")' >" . $self->formatFromTo($self->noHtml(decode_base64($arr[$y][1]))) . "<br />" . $self->formatFromTo($self->noHtml(decode_base64($arr[$y][2])))   . "<br />" .  $self->limitLength($self->noHtml($self->formatSubject(decode_base64($arr[$y][3])))) . "</td>";
	      $mailId = $arr[$y][0];
	      $dropTemplateCurr = $dropTemplate;
	      $dropTemplateCurr =~ s/#id#/$mailId/gi;
	      
	      # find default folder id
	      $iDefaultFolderString = $arr[$y][6] ;
	      $senderString = decode_base64($arr[$y][1]) . decode_base64($arr[$y][2]) ;
	      for $iDefault (0.. $#arrDefaultFolder){
	         if ($senderString =~ m/$arrDefaultFolder[$iDefault ][0]/i){
	            $iDefaultFolderString = $arrDefaultFolder[$iDefault ][1];
	         }
	      }
	      # find folder id
	      $iDefaultFolderName = "";
	      for $iFolder (0.. $#arrFolder){
	         if ($iDefaultFolderString =~ m/$arrFolder[$iFolder ][1]/i){
	            $iDefaultFolderName = $arrFolder[$iFolder ][0];
	         }
	      }
		if($iDefaultFolderString < 10){
			$iDefaultFolderStringDescription = "0" . $iDefaultFolderString ;
		}else{
			$iDefaultFolderStringDescription = $iDefaultFolderString ;
		}
	      $return .= "<td class='mail_from' ><input type='button' onclick='mailSetOrgAction(".$arr[$y][0].")' value='Org' ></td>";
	      $return .= "<td class='mail_from' ><input type='button' onclick='moveToDefaultFolder(".$arr[$y][0].",".$iDefaultFolderString.",1)' value='&rarr;&nbsp;" . $iDefaultFolderStringDescription ."' ></td>";

		$currFolder = $arr[$y][6];
		if($currFolder < 10){
			$currFolder = "0" . $currFolder;
		}

	      $return .= "<td class='mail_from' ><input type='button' onclick='showFolderDropDown(".$arr[$y][0].")' value='&rarr;&nbsp;? (" . $currFolder . ")' ></td>";  
	      $return .= "<td class='mail_from' ><input type='button' onclick='mailReparse(".$arr[$y][0].")' value='R' ></td>";   
	      $return .= "</tr>";
   }

   $return .= "</table>getMailsBySqlCompact-" . $self->getVersion(); 
   return $return ;
}
# -------------------------------------------------------------------------------------------------
# 
# -------------------------------------------------------------------------------------------------
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
sub noHtml{
my ($self, $str  ) = @_;

$str =~ s/</[/i;
$str =~ s/>/]/i;

return $str;
}
#-------------------------------------------------------------------------------------------------
sub cleanForSql{
my ($self, $str  ) = @_;

$str =~ s/'//i;
$str =~ s/"/]/i;

return $str;
}

#-------------------------------------------------------------------------------------------------
# clean database from old stuff
sub cleanDatabase{

	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('mail');
	my $sql;	
	my $yearVal;

	$sql = "SELECT max( load_year - 1 ) FROM  mail";
	my @arr;
	@arr = $objDAL->getArray($sql);
	$yearVal = $arr[0][0];

	if($yearVal > 1900){
		$sql = "DELETE FROM mail where mail_status = 'd' AND  folder = '0' AND  load_year < " . $yearVal;
		$objDAL->executeSQL($sql);
		return "ok";
	}else{
		return "error";
	}	
}
#-------------------------------------------------------------------------------------------------
1; 
