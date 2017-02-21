package Page;


# ===========================================================================================
# constructor
# ===========================================================================================


#constructor
#sub new {
#    my ($class) = @_;
#    my $self =
#      { _stylesheet => "", _body => "", _xmlHead => "", _xmlEnd => "", _mode => "", _encoding => "", _title => "", _javascript => "", _body => "", _value => "",  _javaBlock => "", _bodyOnLoad => "", _bodyClass => "", _javaWindowChanged => ""};
#    bless $self, $class;
#    return $self;
#}


#constructor
sub new {
    my ($class) = @_;
    my $self =
      { _stylesheet => "", 
	  _body => "", 
	  _xmlHead => "", 
	  _xmlEnd => "", 
	  _mode => "", 
	  _encoding => "", 
	  _title => "", 
	  _javascript => "", 
	  _body => "", 
	  _value => "",  
	  _javaBlock => "", 
	  _bodyOnLoad => "", 
	  _bodyClass => "", 
	  _vs => "undefined session", 
	  _vu => "undefined user", 
	  _javaWindowChanged => ""};
    bless $self, $class;
    return $self;
}

# ===========================================================================================
# constructor
# ===========================================================================================

sub setBodyOnLoad{
   my ( $self,  $functionToAdd) = @_; 
   $self->{_bodyOnLoad} .= $functionToAdd;

}

# ===========================================================================================
# set global variables
# ===========================================================================================

sub setGlobalVariables{
   my ( $self,  $v_s,  $v_u) = @_; 
   $self->{_vs } = $v_s;
   $self->{_vu } = $v_u;
}

# ===========================================================================================
# constructor
# ===========================================================================================

sub setBodyClass{
   my ( $self,  $class) = @_; 
   $self->{_bodyClass} .= $class;

}

# ===========================================================================================
# constructor
# ===========================================================================================

sub positionContainerPercent{
    my ( $self,  $name, $left, $top, $width  ) = @_;
    $self->{_javaBlock } .= "\n" . "positionContainerPercent(\"" . $name . "\"," . $left . "," . $top . "," . $width . ");";
}

# ===========================================================================================
# add function to be executed if window size changed
# ===========================================================================================

sub addPositionContainerAbsoluteOnWindowResize{
    my ( $self,  $divTag, $verticalOrientation, $horizontalOrientation, $spaceLeft, $spaceRight, $spaceTop,$spaceBottom  ) = @_;
    $self->{_javaWindowChanged } .= "\n" . "positionContainerAbsolut(\"" . $divTag. "\",\"" . $verticalOrientation . "\",\"" . $horizontalOrientation. "\"," . $spaceLeft. "," . $spaceRight . "," . $spaceTop . "," . $spaceBottom . ");";
}

# ===========================================================================================
# constructor
# ===========================================================================================

sub positionContainerAbsolut{
    my ( $self,  $divTag, $verticalOrientation, $horizontalOrientation, $spaceLeft, $spaceRight, $spaceTop,$spaceBottom  ) = @_;
    #positionContainerAbsolut(divTag, verticalOrientation, horizontalOrientation, spaceLeft, spaceRight, spaceTop,spaceBottom){

    $self->{_javaBlock } .= "\n" . "positionContainerAbsolut(\"" . $divTag. "\",\"" . $verticalOrientation . "\",\"" . $horizontalOrientation. "\"," . $spaceLeft. "," . $spaceRight . "," . $spaceTop . "," . $spaceBottom . ");";
}

# ===========================================================================================
# same function like before but maximized
# ===========================================================================================

sub positionContainerAbsolutMax{
    my ( $self,  $divTag, $verticalOrientation, $horizontalOrientation, $spaceLeft, $spaceRight, $spaceTop,$spaceBottom  ) = @_;
    #positionContainerAbsolut(divTag, verticalOrientation, horizontalOrientation, spaceLeft, spaceRight, spaceTop,spaceBottom){

    $self->{_javaBlock } .= "\n" . "positionContainerAbsolutMax(\"" . $divTag. "\",\"" . $verticalOrientation . "\",\"" . $horizontalOrientation. "\"," . $spaceLeft. "," . $spaceRight . "," . $spaceTop . "," . $spaceBottom . ");";
}

# ===========================================================================================
# constructor
# ===========================================================================================

sub positionContainerPercentPos{
    my ( $self,  $name, $left, $top, $width, $pos  ) = @_;
    $self->{_javaBlock } .= "\n" . "positionContainerPercentPos(\"" . $name . "\"," . $left . "," . $top . "," . $width . ",'" . $pos  . "');";
        
}    

sub getSimpleLink{
    my ( $self,  $link, $value  ) = @_;
    $self->{_value } = $value if defined($value );
    return "<a href='" . $link . "'>" .  ($self->{_value }) . "</a>";
}

sub setTitle{
    my ( $self,  $title  ) = @_;
    $self->{_title } = $title;
}

sub getLink{
    my ( $self, $style, $link, $value  ) = @_;
    $self->{_value } = $value if defined($value );
    return "<a class='".$style."' href='" . $link . "'>" .  ($self->{_value }) . "</a>";
}

sub getPopLink{
    my ( $self, $style,$link, $value  ) = @_;    
    return "<span class='".$style."' onclick=\"showPop('" . $link . "')\">" .  $value . "</span>";
    #return '';
}

# ===========================================================================================
# 
# ===========================================================================================


sub getJavaScriptButton{
    my $returnvalue = "";
	my ($self, $name,  $style , $content, $javascript) = @_;
    
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
# 
# ===========================================================================================

sub getPopLinkTwoFunction{
    my ( $self, $style,$link, $value, $function ) = @_;    
    return "<span class='".$style."' onclick=\"showMail('" . $link . "');".$function  ."\">" .  $value . "</span>";
    #return '';
}

# ===========================================================================================
# 
# ===========================================================================================

sub getPopLink2{
    my ( $self, $style,$link, $value  ) = @_;    
    return "<span class='".$style."' onclick=\"showMail2('" . $link . "')\">" .  $value . "</span>";
    #return '';
}

# ===========================================================================================
# 
# ===========================================================================================

sub getPopLink3{
    my ( $self, $style,$link, $value  ) = @_;    
    return "<span class='".$style."' onclick=\"showMail3('" . $link . "')\">" .  $value . "</span>";
    #return '';
}

sub getIframe{
    my ( $self, $style,$link, $name  ) = @_;    
    return "<iframe class='".$style."' src='".$link."' id='".$name."'  name='".$name."' >this is an iframe</iframe>";
    #return '';
}


# $name, $class,$dropdown, $default

sub getDropdown{
   my ( $self, $name, $class, $dropdown, $default, $defaultDisplay) = @_; 
   my $somethingFound = 0;
   my $valueFound = 0;
   my $returnValue = '<select name="'.$name.'"  class="'.$class.'" >';
   my $y;
   my $x;
   my @rows;
   my @fields;
   
   @rows = split(/<r>/, $dropdown);
   
   for $y (0.. $#rows){
      $somethingFound = 1;
      $returnValue .= "<option value='";
      
      $rows[$y] .= '';
      
      if ($rows[$y] ne ''){
          @fields = split(/<f>/, $rows[$y]);
          
          $returnValue .= $fields[0];
          
          if ($fields[0] eq $default ){
             $valueFound = 1;
             $returnValue .= "' selected >";
          }else{
             $returnValue .= "' >";
          }      
          $returnValue .= $fields[1];
          $returnValue .= "</option >";	
        }      
   }

   if($valueFound != 1){
      $returnValue .= "<option value='".$default."' selected>".$defaultDisplay."</option >";
   }
   $returnValue .= '</select>';
   return $returnValue ;
}


# ==========================================================================================================

sub getDropdownEditableWithOnChange{
   my ( $self, $name, $class,$modul, $dropdown, $default, $javaScript ) = @_; 
   my $somethingFound = 0;
   my $valueFound = 0;
   my $returnValue = '<select name="'.$name.'" id="'.$name.'"  class="'.$class.'" onchange="'.$javaScript .'">';
   my $y;
   my $x;

   my $objAdminBusinessLayer = AdminBusinessLayer->new();

   my @arr;
   
   @arr = $objAdminBusinessLayer->getDropDown($modul, $dropdown);
  
   for $y (0.. $#arr){
      $somethingFound = 1;
      $returnValue .= "<option value='";
      $returnValue .= $arr[$y][1];
      if ($arr[$y][1] eq $default ){
         $valueFound = 1;
         $returnValue .= "' selected >";
      }else{
         $returnValue .= "' >";
      }      
      $returnValue .= $arr[$y][2];
      $returnValue .= "</option >";		
   }

   if($somethingFound != 1){
     # $returnValue .= "<option value='".$default."' selected>".$default."</option >";
   }
   if($valueFound != 1){
      $returnValue .= "<option value='".$default."' selected>".$default."</option >";
   }
   $returnValue .= '</select>';

   return $returnValue ;
}

# ==========================================================================================================

sub getDropdownEditable{
   my ( $self, $name, $class,$modul, $dropdown, $default, $v_u, $v_s ) = @_; 
   my $somethingFound = 0;
   my $valueFound = 0;
   my $returnValue = '<select name="'.$name.'" id="'.$name.'"  class="'.$class.'" >';
   my $y;
   my $x;

   my $objAdminBusinessLayer = AdminBusinessLayer->new();

   my @arr;
   
   @arr = $objAdminBusinessLayer->getDropDown($modul, $dropdown);
  
   for $y (0.. $#arr){
      $somethingFound = 1;
      $returnValue .= "<option value='";
      $returnValue .= $arr[$y][1];
      if ($arr[$y][1] eq $default ){
         $valueFound = 1;
         $returnValue .= "' selected >";
      }else{
         $returnValue .= "' >";
      }      
      $returnValue .= $arr[$y][2];
      $returnValue .= "</option >";		
   }

   if($somethingFound != 1){
     # $returnValue .= "<option value='".$default."' selected>".$default."</option >";
   }
   if($valueFound != 1){
      $returnValue .= "<option value='".$default."' selected>".$default."</option >";
   }
   $returnValue .= '</select>';

   # link to edit
   $returnValue .= '&nbsp;<a href="../admin/dropDownEditor.pl?v_u='.$v_u.'&v_s='.$v_s.'&modul='.$modul.'&drop_down_name='.$dropdown.'">*</a>';
   
   return $returnValue ;
}

# ==========================================================================================================

sub getInput{
    my $returnvalue = "";
	my ($self, $name, $class, $content) = @_;
	$returnvalue .= '<input type="text" ';
	if ($name ne ''){
		$returnvalue  .= 'id="' . $name . '" ';
        $returnvalue  .= 'name="' . $name . '" ';
	}

	if ($class ne ''){
		$returnvalue  .= 'class="' . $class . '" ';
	}

	$returnvalue  .= 'onchange="onChFrmBack(this)" ';
	$returnvalue  .= 'oninput="onChFrmBack(this)" ';
	$returnvalue  .= 'onclick="onChFrmBack(this)" ';
	$returnvalue  .= 'onfocus="onChFrmBack(this)" ';

	$returnvalue .= ' value="' . $content;
	$returnvalue .= '" />';
    return $returnvalue;
}

# this one is ToDo !!!
sub getCheckBox{
    my $returnvalue = "";
	my ($self, $name, $class, $content) = @_;
	$returnvalue .= '<input type="text" ';
	if ($name ne ''){
		$returnvalue  .= 'id="' . $name . '" ';
        $returnvalue  .= 'name="' . $name . '" ';
	}

	if ($class ne ''){
		$returnvalue  .= 'class="' . $class . '" ';
	}
	$returnvalue .= ' value="' . $content;
	$returnvalue .= '" />';
    return $returnvalue;
}


sub getPassword{
    my $returnvalue = "";
	my ($self, $name, $class, $content) = @_;
	$returnvalue .= '<input type="password" ';
	if ($name ne ''){
		$returnvalue  .= 'id="' . $name . '" ';
        $returnvalue  .= 'name="' . $name . '" ';
	}

	if ($class ne ''){
		$returnvalue  .= 'class="' . $class . '" ';
	}
	$returnvalue .= ' value="' . $content;
	$returnvalue .= '" />';
    return $returnvalue;
}

sub getFile{
    my $returnvalue = "";
	my ($self, $name, $class) = @_;
	$returnvalue .= '<input type="file" ';
	if ($name ne ''){
		$returnvalue  .= 'id="' . $name . '" ';
        $returnvalue  .= 'name="' . $name . '" ';
	}

	if ($class ne ''){
		$returnvalue  .= 'class="' . $class . '" ';
	}

	$returnvalue .= ' />';
    return $returnvalue;
}

sub getHidden{
    my $returnvalue = "";
	my ($self, $name, $content) = @_;
	$returnvalue .= "\n".'<input type="hidden" ';
	if ($name ne ''){
		$returnvalue  .= 'id="' . $name . '" ';
	}    
    if ($name ne ''){
		$returnvalue  .= 'name="' . $name . '" ';
	}
	$returnvalue .= ' value="' . $content;
	$returnvalue .= '" />';
    return $returnvalue;
}

sub getSubmit{
    my $returnvalue = "";
	my ($self, $name, $class, $content) = @_;
	$returnvalue .= '<input type="submit" ';
	if ($name ne ''){
		$returnvalue  .= 'id="' . $name . '" ';
	}
    
    if ($name ne ''){
		$returnvalue  .= 'name="' . $name . '" ';
	}
        $returnvalue .= ' class="' . $class . '" ';
	$returnvalue .= ' value="' . $content;
	$returnvalue .= '" />';
    return $returnvalue;
}


sub getButton{
    my $returnvalue = "";
	my ($self, $name, $style, $content, $javascript) = @_;
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
    $returnvalue .= ' onclick="' . $javascript;
	$returnvalue .= '" />';
    return $returnvalue;
}


sub getLinkButton{
    my $returnvalue = "";
	my ($self, $name, $style, $content, $javascript) = @_;
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

	$returnvalue .= '" />';
   return $returnvalue;
}

sub jumpToPage{
    my $returnvalue = "";
	my ($self, $pageName) = @_;

    $self->{_javaBlock } = "\n" . 'jumpToPage(\'' . $pageName . '\'); ' . "\n" . $self->{_javaBlock }  ;

}


sub getArea{
    my $returnvalue = "";
	my ($self, $name, $class, $content) = @_;
	$returnvalue .= '<textarea ';
	if ($name ne ''){
		$returnvalue  .= 'id="' . $name . '" ';
	}
    
    if ($name ne ''){
		$returnvalue  .= 'name="' . $name . '" ';
	}

	if ($class ne ''){
		$returnvalue  .= 'class="' . $class . '" ';
	}


	$returnvalue  .= 'onchange="onChFrmBack(this)" ';
	$returnvalue  .= 'oninput="onChFrmBack(this)" ';
	$returnvalue  .= 'onclick="onChFrmBack(this)" ';
	$returnvalue  .= 'onfocus="onChFrmBack(this)" ';

    $returnvalue .= ' >';
	$returnvalue .= $content;
	$returnvalue .= '</textarea>';
    return $returnvalue;
}

sub getForm{
    my $returnvalue = "";
	my ($self, $name, $class, $target, $content) = @_;
	$returnvalue .= "\n" . '<form method="post" enctype="multipart/form-data" ';
	if ($name ne ''){
		$returnvalue  .= 'id="' . $name . '" ';
	}
    
    if ($name ne ''){
		$returnvalue  .= 'name="' . $name . '" ';
	}
    
    $returnvalue  .= ' action="' . $target . '" ';

	if ($class ne ''){
		$returnvalue  .= 'class="' . $class . '" ';
	}
    $returnvalue .= ' >';
	$returnvalue .= $content;
	$returnvalue .= "\n".'</form>'."\n";
    return $returnvalue;
}

sub addStyleSheet{
	my ($self, $value) = @_;
	$self->{_stylesheet} .= "\n".'<link rel="stylesheet" type="text/css" href="';
    $self->{_stylesheet} .= $value;
    $self->{_stylesheet} .= '" />'."\n";    
}

sub addJavaScript{
	my ($self, $value) = @_;
    $self->{_javascript} .= "\n".'<script src="';
	$self->{_javascript} .= $value ;
    $self->{_javascript} .='" type="text/javascript"></script>'."\n";
}

sub setMaximised{
	my ($self) = @_;   
    my $temp;   
    $temp = "\n"; 
    $temp .= "maximizeWindow();";
    $temp .= "\n"; 
    $temp .= $self->{_javaBlock } .= "\n";
    $self->{_javaBlock } = $temp;
}

sub addContent{
	my ($self, $value) = @_;
	$self->{_body} .= $value;
}

# ===========================================================================================
# 
# ===========================================================================================

sub addContainer{
	my ($self, $name, $class, $content) = @_;
	$self->{_body} .= '<div ';
	if ($name ne ''){
		$self->{_body}  .= 'id="' . $name . '" ';
	}

	if ($class ne ''){
		$self->{_body}  .= 'class="' . $class . '" ';
	}
        $self->{_body} .= ' >';
	$self->{_body} .= $content;
	$self->{_body} .= '</div>';
}

# ===========================================================================================
# 
# ===========================================================================================

sub getContainer{
	my ($self, $name, $class, $content) = @_;
	my $returnValue;
	$returnValue .= '<div ';
	if ($name ne ''){
		$returnValue  .= 'id="' . $name . '" ';
	}

	if ($class ne ''){
		$returnValue  .= 'class="' .$class . '" ';
	}
        $returnValue .= ' >';
	$returnValue .= $content;
	$returnValue .= '</div>';
	return $returnValue;
}

# ===========================================================================================
# 
# ===========================================================================================

sub addText{
	my ($self, $name, $class, $content) = @_;
	$self->{_body} .= '<span ';
	if ($name ne ''){
		$self->{_body}  .= 'id="' . $self->{_name} . '" ';
	}

	if ($class ne ''){
		$self->{_body}  .= 'class="' . $self->{_class} . '" ';
	}
	$self->{_body} .= '>' . $content;
	$self->{_body} .= '</span>';

}

sub getText{
	my ($self, $name, $class, $content) = @_;
	my $returnValue;
	$returnValue .= '<span ';
	if ($name ne ''){
		$returnValue  .= 'id="' . $self->{_name} . '" ';
	}

	if ($class ne ''){
		$returnValue  .= 'class="' . $self->{_class} . '" ';
	}
	$returnValue .= '>' . $content;
	$returnValue .= '</span>';
	return $returnValue;
}

sub display{
	my ($self) = @_;
	
	print $self->{_xmlHead} . "\n";
        print "<head>". "\n";
	print '<link rel="icon" href="https://ssl-id1.de/alex-admin.net/alex-admin/live/upload/107318115539/favicon3-1081013113341.ico" />';
        print "<title>";
	print $self->{_title} ;
        print "</title>". "\n";
	print $self->{_stylesheet} . "\n";
	print $self->{_javascript} . "\n";
        print "\n<script type=\"text/javascript\">\n";   
        print "/* <![CDATA[ */"."\n\n";    
        print "var globalSession = '" . $self->{_vs } . "';\n";    
        print "var globalUser = '" . $self->{_vu } . "';\n";    
        print "\n/* ]]> */"."\n"; 
        print "</script>\n";
        print "</head>". "\n";
        print "<body ";
        print " class='". $self->{_bodyClass} ."' ";
        print " onload='". $self->{_bodyOnLoad} ."'";
        print " >". "\n";

	print "<div id='logDiv' class='logger'></div>";
	print "<div id='calendarAlert' class='calendarAlertClass'></div>";

        #print "<body>". "\n";
        #print "<div class=\"bodydiv\" style='z-index:1;'  id=\"bodydiv\"></div>";


	print $self->{_body} . "\n";
    
    
    if ($self->{_javaBlock } ne ""){
    
        print "\n<script type=\"text/javascript\">\n";   
        print "/* <![CDATA[ */"."\n";        
        print $self->{_javaBlock };
        print "\n/* ]]> */"."\n"; 
        print "</script>\n";
    }


	if($self->{_javaWindowChanged } ne ""){

        print "\n<script type=\"text/javascript\">\n";   
        print "/* <![CDATA[ */"."\n";   
        print "\nfunction myResize(){\n";
        print $self->{_javaWindowChanged };
	print "\n}\n";
	print "\nwindow.onresize = myResize;\n";
        print "\n/* ]]> */"."\n"; 
        print "</script>\n";

	}
    
    
    print "</body>". "\n";
    print $self->{_xmlEnd} . "\n";
}

sub addTitle{
	my ($self, $value) = @_;
	$self->{_title } .= $value;
}

sub showError{
	my ($self, $value) = @_;
	print "Error: " .  $value;
}

sub setMode{
	my ($self, $value) = @_;
	$self->{_mode } .= $value;
}

sub setEncoding{
	my ($self, $value) = @_;
	$self->{_encoding } .= $value;    
}

sub stripLinks{
   my ($self, $value, $hrefStart, $mode) = @_;
   my $stringLength = length($value);
   my $position = 0;
   my $startPosition = 0;
   my $endPosition = 0;
   my $link;
   my @returnArr;

   while($position < $stringLength){
      $startPosition = index($value, "<a", $position) ;
      if($startPosition <= 0 ){
         $position = $stringLength;
      }else{
         $position = $startPosition;
         $endPosition = index($value, "</a", $position) ;
         if($endPosition <= 0 ){
            $position = $stringLength;
         }else{
            $position = $endPosition;
            $link = "\n". substr($value, $startPosition, $endPosition - $startPosition + 4);
            if($mode eq 'blank'){
               $link =~ s/target="_blank"//gi;
               $link =~ s/<a/<a target="_blank"/gi;
            }
            if($link =~ m/http:\/\//g){
              # do nothing so far
              #$link = "hat alles" . $link;
            }else{
               if($link =~ m/www\./g){ 
                  #$link = "hat www" . $link;
                  $link =~ s/href="/href="http:\/\//gi;
               }else{
                  #$link = "hat nix" . $link;
                  $link =~ s/href="/href="$hrefStart/gi;
                  $link =~ s/href='/href='$hrefStart/gi;
               }
            }
            $link =~ s/\/\//\//gi;
            $link =~ s/p:\//p:\/\//gi;



            push(@returnArr, $link);
         }
      }
   }
   return @returnArr;
}

sub setWindowSize{
	my ($self, $value) = @_;
        # hier muss hin dass die verschiednene groessen der windows hier festegelt wird. 
        # 0 = fullscreen
        # 1 = 800 x 600
        # 2 = 600 x 400
        # 3 = 400 x 300
	$self->{_encoding } .= $value;    
}

sub initialize{
	my ($self) = @_;
	# wenn debug mode dann direkt header schreiben ansonsten in variable specihern
	# wennencoding xhtml dann diesen 
	
	if ($self->{_encoding } eq 'xhtml'){  
		# $self->{_xmlHead} = "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";
		# <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		# do not change to utf8 because it has other side effects !!!
		# changed again to utf8 on 19th may 2011
		$self->{_xmlHead} = "Content-type: text/html;Charset=utf-8". "\n\n\n\n\n";
		# print  "Content-type: text/html;Charset=utf-8". "\n\n"; # for debugging
		# $self->{_xmlHead} .= '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
		$self->{_xmlHead} .= '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' . "\n";
		$self->{_xmlHead} .= '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">' . "\n";
        
        $self->{_xmlEnd} = '<!-- Page object version 01.09.2009 --></html>' . "\n";            
	}
	if ($self->{_mode } eq 'debug'){		
		print $self->{_xmlHead};
	}
}
# -----------------------------------------------------------------------------------------------------------
1;
