package Organizer;

# -------------------------------------------------------------------------------------------------------
# constructor
# -------------------------------------------------------------------------------------------------------

sub new {
	my ($class) = @_;
	my $self =
	{ 
		_content => '', 
		_from => "",
		_to => "", 
		_contentFlag => 0,
		_isContent => ''
	};

	$self->{attachmentFiles}  = [];	
	$self->{attachmentDescription}  = [];
	$self->{attachmentFileTypes}  = [];
	$self->{attachmentFileSize}  = [];
	$self->{allBoundaries}  = [];

	bless $self, $class;
	return $self;
}

# -------------------------------------------------------------------------------------------------------
# update a singe field
# -------------------------------------------------------------------------------------------------------
sub updateField{
	my ($self, $row, $field, $content) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql = "UPDATE todo SET " . $field . "='" . $content . "'  WHERE id=" . $row;
	$objDAL->executeSQL($sql);
	return 1;	

}
# -------------------------------------------------------------------------------------------------------
# 
# -------------------------------------------------------------------------------------------------------
sub createNewElement{
	my ($self, $category) = @_;
	$self->insertNewElement($self->getShortCategory($category) , $self->getDate(), $self->getTime(), "new");
}
# -------------------------------------------------------------------------------------------------------
# category
# -------------------------------------------------------------------------------------------------------
sub getShortCategory{
	my ($self, $category) = @_;
	my $shortCategory = "?";
	if($category =~ m/day/i){ $shortCategory = "c"};
	if($category =~ m/week/i){ $shortCategory = "c"};
	if($category =~ m/month/i){ $shortCategory = "c"};
	if($category =~ m/year/i){ $shortCategory = "c"};
	if($category =~ m/calendarlist/i){ $shortCategory = "c"};
	if($category =~ m/action/i){ $shortCategory = "a"};
	if($category =~ m/wait/i){ $shortCategory = "w"};
	if($category =~ m/pend/i){ $shortCategory = "p"};
	return $shortCategory;
}

# -------------------------------------------------------------------------------------------------------
# decide if retun type is html or a different format
# -------------------------------------------------------------------------------------------------------
sub getReturnType{
	my ($self, $category) = @_;
	my $shortCategory = "?";
	if($category =~ m/day/i){ $shortCategory = "p"};
	if($category =~ m/week/i){ $shortCategory = "p"};
	if($category =~ m/month/i){ $shortCategory = "p"};
	if($category =~ m/year/i){ $shortCategory = "p"};
	if($category =~ m/calendarlist/i){ $shortCategory = "h"};
	if($category =~ m/action/i){ $shortCategory = "h"};
	if($category =~ m/wait/i){ $shortCategory = "h"};
	if($category =~ m/pend/i){ $shortCategory = "h"};
	return $shortCategory;
}

# -------------------------------------------------------------------------------------------------------
# category
# -------------------------------------------------------------------------------------------------------
sub getLongCategory{
	my ($self, $category) = @_;
	my $shortCategory = "?";
	if($category =~ m/day/i){ $shortCategory = "DAY"};
	if($category =~ m/week/i){ $shortCategory = "WEEK"};
	if($category =~ m/month/i){ $shortCategory = "MONTH"};
	if($category =~ m/year/i){ $shortCategory = "YEAR"};
	if($category =~ m/action/i){ $shortCategory = "ACTION"};
	if($category =~ m/wait/i){ $shortCategory = "WAITING"};
	if($category =~ m/pend/i){ $shortCategory = "PENDING"};
	if($category =~ m/list/i){ $shortCategory = "CALENDAR LIST"};
	return $shortCategory;
}

# -------------------------------------------------------------------------------------------------------
# insert a new element in the table
# -------------------------------------------------------------------------------------------------------
sub insertNewElement{
	my ($self, $category, $date, $time, $content) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql = "INSERT INTO todo (category, title, date_insert, date_action, time_action_from, time_action_to, done) VALUES (";
	$sql  .= "'" . $category . "', ";
	$sql  .= "'" . $content . "', ";
	$sql  .= "'" . $date . "', ";
	$sql  .= "'" . $date . "', ";
	$sql  .= "'" . $time . "', ";
	$sql  .= "'" . $time . "', ";
	$sql  .= "'no') ";
	#print $sql;
	$objDAL->executeSQL($sql);
	return 1;	
}

# -------------------------------------------------------------------------------------------------------
# get ID of a newly inserted item
# -------------------------------------------------------------------------------------------------------
sub getIdOfNewElement{

	my ($self, $content) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql = "SELECT  id FROM todo WHERE  title= '" . $content . "' ";
	my @arr;
	@arr = $objDAL->getArray($sql);
	return $arr[0][0];
}

# -------------------------------------------------------------------------------------------------------
# get the minimal content for callback
# -------------------------------------------------------------------------------------------------------
sub getCallbackContentOfNewElement{

	my ($self, $id) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql = "SELECT  id,  date_action, title FROM todo WHERE  id = " . $id;
	my @arr;
	@arr = $objDAL->getArray($sql);
	return $arr[0][0] . "|" . $arr[0][1] . "|" . $arr[0][2] ;
}
# -------------------------------------------------------------------------------------------------------
# get the list for being parsed by javascript
# -------------------------------------------------------------------------------------------------------
sub getListForParser{
	my ($self, $formDate, $toDate) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql = "SELECT  id, title, date_insert, date_action, time_action_from, time_action_to, project FROM todo WHERE  category = 'c' AND date_action >= '" . $formDate . "' AND date_action <= '" . $toDate . "'  ";

	$sql .= " ORDER BY date_action asc, title asc, project  asc";
	
	my $y;
	my @arr;
	@arr = $objDAL->getArray($sql);
	my $ret;
	my $tmp;
	my $cont;
	$ret = "";
	for $y (0.. $#arr){
		$ret .=  $arr[$y][3] . "<f>" . $arr[$y][0] . "<f>" .$arr[$y][1] . "<r>";			
	}
	return $ret;
}

# -------------------------------------------------------------------------------------------------------
# get the list
# -------------------------------------------------------------------------------------------------------
sub getListNotDone{
	my ($self, $category, $date) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql = "SELECT  id, title, date_insert, date_action, time_action_from, time_action_to, project FROM todo WHERE done = 'no' AND title = 'new' AND category = '" . $category . "'";

	if($date ne 'all'){
		$sql .= " AND date_action = '" . $date . "'  ";
	}

	$sql .= " UNION ALL ";
	$sql .= "SELECT  id, title, date_insert, date_action, time_action_from, time_action_to, project FROM todo WHERE done = 'no' AND title <> 'new'  AND category = '" . $category . "'";

	if($date ne 'all'){
		$sql .= " AND date_action = '" . $date . "'  ";
	}

	if($category eq 'c'){
		$sql .= " ORDER BY date_action desc ";
	}
	#print $sql;
	my $y;
	my @arr;
	@arr = $objDAL->getArray($sql);
	my $ret;
	my $tmp;
	my $cont;
	$ret = "<table>";
	for $y (0.. $#arr){
		$ret .= "<tr  id='tr_" . $arr[$y][0] . "' >";
			$cont = $self->stringToHtml($arr[$y][1])  ;
			$tmp = $self->getLineTemplateForList();
			$tmp  =~ s/<id>/$arr[$y][0]/g; 
			$tmp  =~ s/<date>/$arr[$y][3]/g; 
			$tmp  =~ s/<action>/$cont/g; 
			$cont = $self->stringToHtml($arr[$y][6])  ;
			if($cont eq ''){
				$cont = "other";
			}
			$tmp  =~ s/<project>/$cont/g; 
			$ret .= $tmp;
		$ret .= "</tr>";
	}
	$ret .= "</table>";
	return $ret;
}
# -------------------------------------------------------------------------------------------------------
# convert umlaute
# -------------------------------------------------------------------------------------------------------
sub stringToHtml{
	my ($self, $tmp) = @_;
#	$tmp  =~ s/ä/&auml;/g; 
#	$tmp  =~ s/Ä/&Auml;/g; 
#	$tmp  =~ s/ö/&ouml;/g; 
#	$tmp  =~ s/Ö/&Ouml;/g; 
#	$tmp  =~ s/ü/&uuml;/g; 
#	$tmp  =~ s/Ü/&Uuml;/g; 
	return $tmp;
}
# -------------------------------------------------------------------------------------------------------
# structure of table
# -------------------------------------------------------------------------------------------------------

#CREATE TABLE `todo` (
#  `id` int(11) NOT NULL auto_increment,
#  `important` char(3) default NULL,
#  `urgent` char(3) default NULL,
#  `category` char(1) default NULL,
#  `title` text,
#  `comment` text,
#  `project` varchar(250) default NULL,
#  `reference` text,
#  `date_insert` datetime default NULL,
#  `date_action` date default NULL,
#  `time_action_from` time default NULL,
#  `time_action_to` time default NULL,
#  `quadrant` int(11) default NULL,
#  `history` text,
#  `done` varchar(5) default 'no',
#  `done_date` datetime default NULL,
#  PRIMARY KEY  (`id`)
#) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=290 ;

# -------------------------------------------------------------------------------------------------------
# list of methods used
# -------------------------------------------------------------------------------------------------------

# 	getOpenActions()

#	getTdEditableWithCheangeAction()
#	getTdWithOnClick()
#	getTdWithButton()
# 	getCalendarDay
# 	getCalendarWeek
# 	getCalendarMonth
# 	getCalendarYear

#	addRowGetId()
# 	setValue(id, field, value)

# -------------------------------------------------------------------------------------------------------
# structure of table
# -------------------------------------------------------------------------------------------------------
sub xxxxxxxxxxxxxxxxxgetOpenActions{
	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();	
	$objDAL->setModul('data');
	my @arr;
	my $sql = "SELECT FROM WHERE ";
	@arr = $objDAL->getArray($sql);
	my $y;
	 my $return;
	my $mailId;
	my $dropTemplateCurr;
	my $dropTemplate;

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

# -------------------------------------------------------------------------------------------------------
# insert action
# -------------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------------
# template for a line inthe lists
# -------------------------------------------------------------------------------------------------------
sub getLineTemplateForList{
	my ($self) = @_;
	my $string = "";
	# onkeyup="alert('changed')" onmouseup
	$string .= "<td id=\"row_<id>\">";
		$string .= "<div id=\"date_<id>\" contenteditable=\"true\"   onkeyup=\"orgProcessChange('date_<id>')\" >";
			$string .= "<date>";
		$string .= "</div>";
	$string .= "</td>";

	# buttons
	$string .= "<td>";
		$string .= "<input type=\"button\" name =\"done\" value=\"&nbsp;C&nbsp;\" onclick=\"orgToCategory('c', '<id>')\">";
	$string .= "</td>";
	$string .= "<td>";
		$string .= "<input type=\"button\" name =\"done\" value=\"&nbsp;A&nbsp;\" onclick=\"orgToCategory('a', '<id>')\">";
	$string .= "</td>";
	$string .= "<td>";
		$string .= "<input type=\"button\" name =\"done\" value=\"&nbsp;W&nbsp;\" onclick=\"orgToCategory('w', '<id>')\">";
	$string .= "</td>";
	$string .= "<td>";
		$string .= "<input type=\"button\" name =\"done\" value=\"&nbsp;P&nbsp;\" onclick=\"orgToCategory('p', '<id>')\">";
	$string .= "</td>";

	$string .= "<td>";
		$string .= "<div id=\"project_<id>\"  onkeyup=\"orgProcessChange('project_<id>')\" contenteditable=\"true\">";
			$string .= "<project>";
		$string .= "</div>";
	$string .= "</td>";

	$string .= "<td>";
		$string .= "<div id=\"action_<id>\"  onkeyup=\"orgProcessChange('action_<id>')\" contenteditable=\"true\">";
			$string .= "<action>";
		$string .= "</div>";
	$string .= "</td>";

	$string .= "<td>";
		$string .= "<input type=\"button\" name =\"done\" value=\"done\" onclick=\"orgSetDone('<id>')\">";
	$string .= "</td>";
	return $string ;
}
# -------------------------------------------------------------------------------------------------------
# get date
# -------------------------------------------------------------------------------------------------------
sub getDate{
	my ($self) = @_;
	my $v_day = (localtime())[3];
	my $v_month = (localtime())[4];
	my $v_year = (localtime())[5];
	$v_year = $v_year + 1900;
	$v_month = $v_month + 1;
	my $ret;
	$ret = $v_year . "-" . $self->makeTwoDigit($v_month) . "-" . $self->makeTwoDigit($v_day);
	return $ret;
}
# -------------------------------------------------------------------------------------------------------
# template for a line inthe lists
# -------------------------------------------------------------------------------------------------------
sub getTime{
	my ($self) = @_;
	my $v_minute = (localtime())[1];
	my $v_hour = (localtime())[2];
	my $ret;
	$ret = $self->makeTwoDigit($v_hour) . ":" . $self->makeTwoDigit($v_minute) . ":00";
	return $ret;
}

# -------------------------------------------------------------------------------------------------------
# make number two digit string
# -------------------------------------------------------------------------------------------------------
sub makeTwoDigit{
	my ($self, $x) = @_;

	if($x < 10){
		$x = "0". $x;
	}
	return $x;
}

# -------------------------------------------------------------------------------------------------------
1;
# -------------------------------------------------------------------------------------------------------
# END OF CLASS
# -------------------------------------------------------------------------------------------------------


