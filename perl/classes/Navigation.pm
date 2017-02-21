package Navigation;

# ===========================================================================================

#constructor
sub new {
	my ($class) = @_;
	my $self =
	{ _html => undef };
	bless $self, $class;
	return $self;
}

# ===========================================================================================

sub closeButton{
	my $returnstring;
	$returnstring .= '<span onclick="window.close()">close</span>';
	return $returnstring;
}

# ===========================================================================================

sub get{
	my ($self, $v_u,$v_s, $module, $company) = @_;

	my $returnstring = "";
	$returnstring .=  "<form id='navigationForm' name='navigationForm' action='' method='get'>";

	# the org button must be there always
	#if ($module ne 'org'){
		$returnstring .= "\n".$self->getLinkButton('../data/org.pl?category=week&v_u='.$v_u.'&v_s='.$v_s.'',"ORG");
	#}

	# have button for new mail always
	if ($module ne 'mail'){
		$returnstring .= "\n".$self->getJavaScriptButton('navigationNewMail()',"New mail");
	}

	if ($module ne 'accounting'){
		$returnstring .= "\n".$self->getLinkButton('../accounting/index.pl?v_u='.$v_u.'&v_s='.$v_s.'',"ACC");
	}
	if ($module ne 'invest'){
			$returnstring .= "\n".$self->getLinkButton('../invest/portfolioValue.pl?v_u='.$v_u.'&v_s='.$v_s.'',"INV");
	}

	if ($module ne 'language'){
		$returnstring .= "\n".$self->getLinkButton('../language/index.pl?v_u='.$v_u.'&v_s='.$v_s.'',"LANG");
	}
	if ($module ne 'mail'){
		$returnstring .= "\n".$self->getLinkButton('../mail/indexCompact.pl?v_u='.$v_u.'&v_s='.$v_s.'',"MAIL");
	}
	#if ($module ne 'mindmap'){
		$returnstring .= "\n".$self->getLinkPopUpButton('../data/mindmap.pl?id=0&v_u='.$v_u.'&v_s='.$v_s.'',"MAP");
		$returnstring .= "\n".$self->getLinkPopUpButton('../data/cms.pl?id=0&v_u='.$v_u.'&v_s='.$v_s.'',"CMS");
	#}
	if ($module ne 'data'){
		$returnstring .= "\n".$self->getLinkButton('../data/data.pl?action=search&v_u='.$v_u.'&v_s='.$v_s.'',"DATA");
	}


	$returnstring .= "\n".$self->getLinkPopUpButton('../editor/editCodeAjax.pl?v_u='.$v_u.'&v_s='.$v_s.'',"W. BENCH");
	#$returnstring .= "\n".$self->getLinkPopUpButton('../editor/sqlEditor.pl?v_u='.$v_u.'&v_s='.$v_s.'',"SQL2");
	$returnstring .= "\n".$self->getLinkButton('../admin/logout.pl?v_u='.$v_u.'&v_s='.$v_s.'',"LOGOUT");
		
	my $objConfig = DbConfig->new();

	#$returnstring .= "<span id='loadcheck' style='background: #00ff00;'>&nbsp;&nbsp;&nbsp;</span>";
		
	$returnstring .= "&nbsp;&nbsp;<span id='loadcheck' >&nbsp;&nbsp;" . $objConfig->serverloc . "&nbsp;&nbsp;</span>";

	if ($module ne'org'){
		$returnstring .= "\n".'<span class="currentModule" onclick="orgShowHideCalendarAlert();" >CAL</span>';
	}

	$returnstring .= "\n".'<a href="' . '../data/data.pl?action=search&v_u='.$v_u.'&v_s='.$v_s . '" >CLN</a>';

	# add the current module 

	if ($module eq 'data'){
		$returnstring .= "\n".'<span class="currentModule" onclick="showHideLog();" >Data</span><br />' . $self->dataHeader($v_u, $v_s);
	}
	if ($module eq 'admin'){
		$returnstring .= "\n".'<span class="currentModule" onclick="showHideLog();" >Admin</span><br />' . $self->dataHeader($v_u, $v_s);
	}   
	if ($module eq 'accounting'){
		$returnstring .= "\n".'<span class="currentModule" onclick="showHideLog();" >Accounting</span><br />' . $self->accountingHeader($v_u, $v_s, $company);
	}
	if ($module eq 'invest'){
		$returnstring .= "\n".'<span class="currentModule" onclick="showHideLog();" >Invest</span><br />' . $self->investHeader($v_u, $v_s);
	}
	if ($module eq 'mail'){
		$returnstring .= "\n".'<span class="currentModule" onclick="showHideLog();" >Mail</span><br />' . $self->mailHeader($v_u, $v_s);
	}
	if ($module eq 'language'){
		$returnstring .= "\n".'<span class="currentModule" onclick="showHideLog();" >Language</span><br />' . $self->languageHeader($v_u, $v_s);
	}

	if ($module eq 'org'){
		$returnstring .= "\n".'<span class="currentModule" onclick="showHideLog();" >Org.</span><br />' . $self->orgHeader($v_u, $v_s);
	}
		
	

	$returnstring .= "</form>";
	$returnstring .= $self->getNavigationJavaScript();

	if ($module ne'org'){
		$returnstring .= $self->getOrgJavaScript();
	}

	$returnstring .= "<!-- Navigation.pm version 2012-12-21 -->";
	return $returnstring;
};

# ===========================================================================================
# modul data
# ===========================================================================================

sub dataHeader{
	my ($self, $v_u,$v_s) = @_;    
	my $returnstring = "";
	$returnstring .= "\n". $self->getLinkButton('../data/cross.pl?v_u='.$v_u.'&v_s='.$v_s.'&v_p_id=0&v_action=',"Explorer");
	$returnstring .= "\n". $self->getLinkButton('../data/explorer.pl?v_u='.$v_u.'&v_s='.$v_s.'&v_p_id=0&v_action=',"Explorer Ajax");
	$returnstring .= "\n".$self->getLinkButton('../data/data.pl?action=search&v_u='.$v_u.'&v_s='.$v_s.'&mode=full&action=search&v_search=&id=&dateiname=',"Search");
	# $returnstring .= "\n".$self->getLinkButton('../data/data.pl?v_u='.$v_u.'&v_s='.$v_s.'&mode=full&action=new',"Entry");
	$returnstring .= "\n".$self->getLinkButton('../data/timesheet.pl?action=list&v_u='.$v_u.'&v_s='.$v_s.'',"Timesheet");
	$returnstring .= "\n".$self->getLinkButton('../data/todo.pl?action=list&v_u='.$v_u.'&v_s='.$v_s.'',"To Do");
	$returnstring .= "\n".$self->getLinkPopUpButton('../data/test.pl?action=test&v_u='.$v_u.'&v_s='.$v_s.'',"Test");
	$returnstring .= "\n".$self->getLinkButton('../data/statistics.pl?action=test&v_u='.$v_u.'&v_s='.$v_s.'',"File-Statistics");	
	return $returnstring;
}

# ===========================================================================================
# modul accounting
# ===========================================================================================

sub accountingHeader{
	my ($self, $v_u,$v_s, $company) = @_;    
	my $returnstring = "";
	$returnstring .= "\n".$self->getLinkButton('./index.pl?v_u='.$v_u.'&v_s='.$v_s.'&company=' . $company,"select system");
	$returnstring .= "\n".$self->getLinkButton('./transaction.pl?v_u='.$v_u.'&v_s='.$v_s.'&company=' . $company,"transact");
	$returnstring .= "\n".$self->getLinkButton('./sell.pl?v_u='.$v_u.'&v_s='.$v_s.'&company=' . $company,"sell");

	$returnstring .= "\n".$self->getLinkButton('./writeBill.pl?v_u='.$v_u.'&v_s='.$v_s.'&company=' . $company,"(sell) write bill");
	$returnstring .= "\n".$self->getLinkButton('./clientPays.pl?v_u='.$v_u.'&v_s='.$v_s.'&company=' . $company,"(sell) client pays");

	$returnstring .= "\n".$self->getLinkButton('./buy.pl?v_u='.$v_u.'&v_s='.$v_s.'&company=' . $company,"buy");

	$returnstring .= "\n".$self->getLinkButton('./getProduct.pl?v_u='.$v_u.'&v_s='.$v_s.'&company=' . $company,"(buy) get product");
	$returnstring .= "\n".$self->getLinkButton('./payBill.pl?v_u='.$v_u.'&v_s='.$v_s.'&company=' . $company,"(buy) pay bill");


	$returnstring .= "\n".$self->getLinkButton('./show.pl?v_u='.$v_u.'&v_s='.$v_s.'&company=' . $company,"show acc.");
	$returnstring .= "\n".$self->getLinkButton('./show_by_date.pl?v_u='.$v_u.'&v_s='.$v_s.'&company=' . $company,"show acc. by date");
	$returnstring .= "\n".$self->getLinkButton('./find.pl?v_u='.$v_u.'&v_s='.$v_s.'&company=' . $company,"find");
        # ust va is called bia popup on page index.pl - hence no need to do it here
	#$returnstring .= "\n".$self->getLinkButton('./ust_va.pl?v_u='.$v_u.'&v_s='.$v_s.'&company=' . $company,"ust va");
        # balance is called bia popup on page index.pl - hence no need to do it here
	#$returnstring .= "\n".$self->getLinkButton('./balance.pl?v_u='.$v_u.'&v_s='.$v_s.'&company=' . $company,"balance");
	$returnstring .= "\n".$self->getLinkButton('./create.pl?v_u='.$v_u.'&v_s='.$v_s.'&company=' . $company,"create account");
	return $returnstring;
}

# ===========================================================================================
# modul investment
# ===========================================================================================

sub investHeader{
	my ($self, $v_u,$v_s) = @_;        
	my $returnstring = "";

	#$returnstring .= "\n".$self->getLinkButton('./investment_deals_actual_value.pl?v_u='.$v_u.'&v_s='.$v_s.'',"value");
	#$returnstring .= "\n".$self->getLinkButton('./mycronjob.cgi?v_u='.$v_u.'&v_s='.$v_s.'',"update&nbsp;all");
	#$returnstring .= "\n".$self->getLinkButton('./investment_deals.pl?v_u='.$v_u.'&v_s='.$v_s.'',"deals");
	#$returnstring .= "\n".$self->getLinkButton('./investments_filter_01.pl?v_u='.$v_u.'&v_s='.$v_s.'',"filter&nbsp;1");
	#$returnstring .= "\n".$self->getLinkButton('./investments_filter_02.pl?v_u='.$v_u.'&v_s='.$v_s.'',"filter&nbsp;2");
	#$returnstring .= "\n".$self->getLinkButton('./investments_filter_03.pl?v_u='.$v_u.'&v_s='.$v_s.'',"filter&nbsp;3");
	#$returnstring .= "\n".$self->getLinkButton('./symbol.cgi?v_u='.$v_u.'&v_s='.$v_s.'',"symbols");
	#$returnstring .= "\n".$self->getLinkButton('./investment_companies.pl?v_u='.$v_u.'&v_s='.$v_s.'',"companies");
	#$returnstring .= "\n".$self->getLinkButton('./news.pl?section=basic&v_u='.$v_u.'&v_s='.$v_s.'',"news-basic");
	#$returnstring .= "\n".$self->getLinkButton('./news.pl?section=special&v_u='.$v_u.'&v_s='.$v_s.'',"news-special");

	$returnstring .= "\n".$self->getLinkButton('./portfolioValue.pl?v_u='.$v_u.'&v_s='.$v_s.'',"Portfolio value");
	$returnstring .= "\n".$self->getLinkButton('./cashFlows.pl?v_u='.$v_u.'&v_s='.$v_s.'',"Cash flows");
	$returnstring .= "\n".$self->getLinkButton('./portfolioGraph.pl?v_u='.$v_u.'&v_s='.$v_s.'',"Graph");

	return $returnstring;
}

# ===========================================================================================
# modul mail
# ===========================================================================================

sub mailHeader{
	my ($self, $v_u,$v_s) = @_;        
	my $returnstring = "";

	$returnstring .= "\n".$self->getJavaScriptButton('newMail()',"New mail");
	$returnstring .= "\n".$self->getLinkButton('./index.pl?v_u='.$v_u.'&v_s='.$v_s.'',"Inbox");
	$returnstring .= "\n".$self->getLinkButton('./indexCompact.pl?v_u='.$v_u.'&v_s='.$v_s.'',"Inbox Comp.");
	$returnstring .= "\n".$self->getLinkButton('./search.pl?v_u='.$v_u.'&v_s='.$v_s.'',"Search");
	$returnstring .= "\n".$self->getLinkButton('../admin/dropDownEditor.pl?v_u='.$v_u.'&v_s='.$v_s.'&modul=mail&drop_down_name=folder',"Folder");
	$returnstring .= "\n".$self->getLinkButton('../admin/dropDownEditor.pl?v_u='.$v_u.'&v_s='.$v_s.'&modul=mail&drop_down_name=spam',"Spam");
	$returnstring .= "\n".$self->getLinkButton('../admin/dropDownEditor.pl?v_u='.$v_u.'&v_s='.$v_s.'&modul=mail&drop_down_name=defaultfolder',"Default");
	$returnstring .= "\n".$self->getLinkButton('./moveFolder.pl?v_u='.$v_u.'&v_s='.$v_s.'',"Move folder");
	$returnstring .= "\n".$self->getLinkButton('./sent.pl?v_u='.$v_u.'&v_s='.$v_s.'',"Sent");
	#$returnstring .= "\n".$self->getLinkPopUpButton('./popClean.pl?v_u='.$v_u.'&v_s='.$v_s.'',"Clean");
	#    ajaxGetMethodAnswerInMsgBox(url)
	$returnstring .= "\n".$self->getJavaScriptButton('mailCleanTrash(\''.$v_u.'\',\''.$v_s.'\')',"Clean trash");
	$returnstring .= "\n".$self->getJavaScriptButton('mailClearClip(\''.$v_u.'\',\''.$v_s.'\')',"Clear clip");
	#$returnstring .= ' <span class="linkLike" onclick="showPop(\'./sendMailSmtpForm.pl?v_u='.$v_u.'&v_s='.$v_s.'\')',"create</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
	return $returnstring;
}

# ===========================================================================================
# modul language
# ===========================================================================================

sub languageHeader{
	my ($self, $v_u,$v_s) = @_;    
	my $returnstring = "";
	$returnstring .= $self->getLinkButton('./insert.pl?v_u='.$v_u.'&v_s='.$v_s.'',"insert");
	$returnstring .= $self->getLinkButton('./insertBulk.pl?v_u='.$v_u.'&v_s='.$v_s.'',"insert Bulk");
	# $returnstring .= $self->getLinkButton('./test.pl?v_u='.$v_u.'&v_s='.$v_s.'',"test");
	# $returnstring .= $self->getLinkButton('./clear.pl?v_u='.$v_u.'&v_s='.$v_s.'',"clear DB");
	$returnstring .= $self->getLinkButton('./index.pl?v_u='.$v_u.'&v_s='.$v_s.'',"cross");
	$returnstring .= $self->getLinkButton('./showAll.pl?v_u='.$v_u.'&v_s='.$v_s.'',"show all");
	$returnstring .= $self->getLinkButton('./statisticSorted.pl?v_u='.$v_u.'&v_s='.$v_s.'',"statistic");

	return $returnstring;
}

# ===========================================================================================
# modul organizer - ORG
# ===========================================================================================

sub orgHeader{
	my ($self, $v_u,$v_s) = @_;    
	my $returnstring = "";
	#$returnstring .= "\n".$self->getJavaScriptButton('orgAddElement()',"Add item");
#	$returnstring .= "\n".$self->getLinkButton('../data/org.pl?category=day&v_u='.$v_u.'&v_s='.$v_s.'',"Day");
	$returnstring .= "\n".$self->getLinkButton('../data/org.pl?category=week&v_u='.$v_u.'&v_s='.$v_s.'',"Week");
#	$returnstring .= "\n".$self->getLinkButton('../data/org.pl?category=15d&v_u='.$v_u.'&v_s='.$v_s.'',"15 Days");
	$returnstring .= "\n".$self->getLinkButton('../data/org.pl?category=month&v_u='.$v_u.'&v_s='.$v_s.'',"Month");
	$returnstring .= "\n".$self->getLinkButton('../data/org.pl?category=year&v_u='.$v_u.'&v_s='.$v_s.'',"Year");
	$returnstring .= "\n".$self->getLinkButton('../data/org.pl?category=action&v_u='.$v_u.'&v_s='.$v_s.'',"Actions");
	$returnstring .= "\n".$self->getLinkButton('../data/org.pl?category=waiting&v_u='.$v_u.'&v_s='.$v_s.'',"Waiting");
	$returnstring .= "\n".$self->getLinkButton('../data/org.pl?category=pending&v_u='.$v_u.'&v_s='.$v_s.'',"Pending");
	$returnstring .= "\n".$self->getLinkButton('../data/org.pl?category=search&v_u='.$v_u.'&v_s='.$v_s.'',"Search");
	$returnstring .= "\n".$self->getLinkButton('../data/org.pl?category=calendarlist&v_u='.$v_u.'&v_s='.$v_s.'',"Calendar List");
	return $returnstring;
}

# ===========================================================================================

sub getLinkButton{
	my $returnvalue = "";
	my ($self, $javascript, $content) = @_;
		
	my $name = $content;
	my $style = "naviButton";
		
	$returnvalue .= '<input type="button" ';
	if ($name ne ''){
		$returnvalue  .= 'id="' . $name . '" ';
	}    
	if ($name ne ''){
		$returnvalue  .= 'name="' . $name . '" ';
	}
		
	if ($style ne ''){
		$returnvalue  .= 'class="' . $style . '" ';
	}
		
	$returnvalue .= ' value="' . $content . '" ';
	$returnvalue .= ' onclick="jumpToPage(\'' . $javascript . '\')" ';
	#$returnvalue .= ' onclick="actionSubmit(\'' . $javascript . '\',document.navigationForm)" ';

	$returnvalue .= ' />';
	return $returnvalue;
}

# ===========================================================================================


sub getJavaScriptButton{
	my $returnvalue = "";
	my ($self, $javascript, $content) = @_;
		
	my $name = $content;
	my $style = "naviButton";
		
	$returnvalue .= '<input type="button" ';
	if ($name ne ''){
		$returnvalue  .= 'id="' . $name . '" ';
	}    
	if ($name ne ''){
		$returnvalue  .= 'name="' . $name . '" ';
	}
		
	if ($style ne ''){
		$returnvalue  .= 'class="' . $style . '" ';
	}
		
	$returnvalue .= ' value="' . $content . '" ';
	$returnvalue .= ' onclick="' . $javascript . '" ';

	$returnvalue .= ' />';
	return $returnvalue;
}

# ===========================================================================================


sub getLinkPopUpButton{
	my $returnvalue = "";
	my ($self, $javascript, $content) = @_;
		
	my $name = $content;
	my $style = "naviButton";
		
	$returnvalue .= '<input type="button" ';

	if ($name ne ''){
		$returnvalue  .= 'id="' . $name . '" ';
	}    
	if ($name ne ''){
		$returnvalue  .= 'name="' . $name . '" ';
	}
		
	if ($style ne ''){
		$returnvalue  .= 'class="' . $style . '" ';
	}
		
	$returnvalue .= ' value="' . $content . '" ';
	$returnvalue .= ' onclick="window.open(\'' . $javascript .'\',\'' . $content . '\',\'resizable=yes,scrollbars=yes, widht=950, height=700\')" ';
		
	$returnvalue .= ' />';
	return $returnvalue;
}




# ===========================================================================================
# here are navigation functions

sub getNavigationJavaScript{

	my $return = "" . "\n";
	$return .= "	<script  type='text/javascript'>" . "\n"; 
	$return .= "	function navigationNewMail() {	 " . "\n";
	$return .= "	var objReadMailWindow;	" . "\n";
	$return .= "	var v_u = getUrlParameter('v_u');	" . "\n";
	$return .= "	var v_s = getUrlParameter('v_s');	" . "\n";
	$return .= "	var fileName = 'sendMail.pl';	" . "\n";
	$return .= '	var relativeUrl = "../mail/" + fileName + "?v_u=" + v_u + "&v_s=" + v_s;	' . "\n";
	$return .= "	var jetzt = new Date();	" . "\n";
	$return .= '	var x = "newWin " + jetzt.getTime();	' . "\n";
	$return .= '	objReadMailWindow = window.open(relativeUrl, x, "width=800,height=600,left=100,top=200,scrollbars=no");	' . "\n";
	$return .= "	objReadMailWindow.focus();	" . "\n";
	$return .= '	objReadMailWindow.document.title = "new mail";	' . "\n";
	$return .= "	}" . "\n";
	$return .= "	</script>" . "\n";

	return $return ;

}

sub getOrgJavaScript{
	my $return = "" . "\n";
	$return .= "	<script  type='text/javascript'>" . "\n"; 
	$return .= '	orgCalendarAlert();	' . "\n";
	$return .= "	</script>" . "\n";
	return $return ;
}


# ===========================================================================================

1;


