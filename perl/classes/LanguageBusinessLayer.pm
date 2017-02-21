
package LanguageBusinessLayer;

#-------------------------------------------------------------------------------------------------
#    constructor
#-------------------------------------------------------------------------------------------------
sub new {
	my ($class) = @_;
	my $self =
	{ _sql => undef, 
	_server => undef
	};
	bless $self, $class;
	return $self;
}

#-------------------------------------------------------------------------------------------------
#    setting the server
#-------------------------------------------------------------------------------------------------

sub setServer{
	my ($self, $name) = @_;
	$self->{_server} =  $name;
}

#-------------------------------------------------------------------------------------------------
# 
#-------------------------------------------------------------------------------------------------
# getVersion

sub getVersion{
	my ($self) = @_;
	return "2012-10-01-A";
}
#-------------------------------------------------------------------------------------------------
# getVocByID

sub getVocByID{
	my ($self, $v_id) = @_;
	my $objDAL = DataAccessLayer->new();
	my $sql_string;
	my @arr;
	my $counter;
		
	$objDAL->setModul('data');
	$sql_string = "SELECT id , L1, L2, L3, L4, L5 , L6, L7    FROM dictionary WHERE id = " . $v_id;

	@arr = $objDAL->getOneLineArray($sql_string);
	return @arr;
}



#-------------------------------------------------------------------------------------------------
# added 14th June 2012
#-------------------------------------------------------------------------------------------------
sub getVocAll{
	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	
	$objDAL->setModul('data');
	my @arr;
	my @arrRet = [[]];
	my $sql =  "SELECT id , L1, L2, L3, L4, L5 , L6, L7    FROM dictionary " ;  
	@arr = $objDAL->getArray($sql);
	my $y;
	my $x;
	my $tmp;

	# convert the array


	for $y (0.. $#arr ) { 
		$arr[$y][0] = $arr[$y][0] ;
		for $x (1.. 7){
			$tmp =  $arr[$y][$x];
			$tmp =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;
			$arr[$y][$x] = $tmp;
		}	
	}	

	return @arr;
}


#-------------------------------------------------------------------------------------------------
# getVocIdByContent

sub getVocIdByContent{
	my ($self, $L1, $L2, $L3, $L4, $L5, $L6, $L7) = @_;
	my $objDAL = DataAccessLayer->new();
	my $sql_string;
	my @arr;
	my $counter;
		
	$objDAL->setModul('data');

	$sql_string = "SELECT id,  L1, L2, L3, L4, L5 , L6, L7   FROM dictionary WHERE L1 = '" . $L1 . "' AND  L2 = '" . $L2 . "' AND  L3 = '" . $L3 . "' AND  L4 = '" . $L4 . "' AND  L5 = '" . $L5 . "' AND  L6 = '" . $L6 . "' AND  L7 = '" . $L7 . "'";

	@arr = $objDAL->getOneLineArray($sql_string);
	return @arr;
}
#-------------------------------------------------------------------------------------------------
# updateVocById

sub updateVocById{

	my ($self, $v_id, $L1, $L2, $L3, $L4, $L5, $L6 , $L7 ) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @languages;
	my @languages2;
	my $lCount;
	my $tl1;
	my $tl2;

	$sql_string = "Update dictionary SET ";
	$sql_string .= "L1 = '".$L1."',";
	$sql_string .= "L2 = '".$L2."',";
	$sql_string .= "L3 = '".$L3."',";
	$sql_string .= "L4 = '".$L4."',";
	$sql_string .= "L5 = '".$L5."',";
	$sql_string .= "L6 = '".$L6."',";
	$sql_string .= "L7 = '".$L7."'";

	$sql_string .= " WHERE id = " . $v_id;

	$objDAL->executeSQL($sql_string);
		
	# eintag in die statistik tabelle - nur die kombinationen die es auch gibt
	$lCount = 0;
	if($L1 ne ''){$lCount += 1; $languages[$lCount] = 1; $languages2[$lCount] = 1;};
	if($L2 ne ''){$lCount += 1; $languages[$lCount] = 2; $languages2[$lCount] = 2;};
	if($L3 ne ''){$lCount += 1; $languages[$lCount] = 3; $languages2[$lCount] = 3;};
	if($L4 ne ''){$lCount += 1; $languages[$lCount] = 4; $languages2[$lCount] = 4;};
	if($L5 ne ''){$lCount += 1; $languages[$lCount] = 5; $languages2[$lCount] = 5;};
	if($L6 ne ''){$lCount += 1; $languages[$lCount] = 6; $languages2[$lCount] = 6;};
	if($L7 ne ''){$lCount += 1; $languages[$lCount] = 7; $languages2[$lCount] = 7;};

	$sql_string = "DELETE FROM dictionary_tracker WHERE id_dictionary = " . $v_id;
	$objDAL->executeSQL($sql_string);



	foreach (@languages) {
		$tl1 =  $_ ;
			
		foreach (@languages2) {      
			$tl2 =  $_ ;
				
			if($tl2 ne $tl1){
				if($tl2 ne ''){
					if($tl1 ne ''){
						$sql_string = "INSERT INTO dictionary_tracker (id_dictionary, from_language, to_language, result) VALUES (" . $v_id . ",'L" . $tl1 . "','L" . $tl2 . "','No')";
						$objDAL->executeSQL($sql_string);

						#reset statistics
						$sql_string = "DELETE FROM INTO dictionary_statistics WHERE id_dictionary = " . $v_id . " AND L1 = '" .  $tl1 . "' AND L2 = '" . $tl2 . "'";
						$objDAL->executeSQL($sql_string);
						# inset new statistics 
						$sql_string = "INSERT INTO  dictionary_statistics (id_dictionary, L1, L2,  pos, neg, ratio, counter, last_access_number) VALUES (" . $v_id . ",'L" . $tl1 . "','L" . $tl2 . "', 100, 100, 1, 0, 0)";
						$objDAL->executeSQL($sql_string);
					}
				}
			}      
		}
	} 




	return 1;
}

#-------------------------------------------------------------------------------------------------

sub insertVoc{

	my ($self, $L1, $L2, $L3, $L4, $L5, $L6 , $L7 ) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @arr;
	my $loop1;
	my $loop2;
	my @languages;
	my @languages2;
	my $lCount;
	my $tl1;
	my $tl2;

	$L1 =~ s/^\s+//;
	$L1 =~ s/\s+$//;
	$L2 =~ s/^\s+//;
	$L2 =~ s/\s+$//;
	$L3 =~ s/^\s+//;
	$L3 =~ s/\s+$//;
	$L4 =~ s/^\s+//;
	$L4 =~ s/\s+$//;
	$L5 =~ s/^\s+//;
	$L5 =~ s/\s+$//;
	$L6 =~ s/^\s+//;
	$L6 =~ s/\s+$//;
	$L7 =~ s/^\s+//;
	$L7 =~ s/\s+$//;

	$sql_string = "INSERT INTO dictionary (L1, L2, L3, L4, L5, L6, L7 ) VALUES  ('".$L1."','".$L2."','".$L3."','".$L4."','".$L5."','".$L6."','".$L7."') ";
	$objDAL->executeSQL($sql_string);

	# now get max id 

	$sql_string = "SELECT max(id) from dictionary";

	@arr = $objDAL->getOneLineArray($sql_string);

	# eintag in die statistik tabelle - nur die kombinationen die es auch gibt

	$lCount = 0;

	if($L1 ne ''){$lCount += 1; $languages[$lCount] = 1; $languages2[$lCount] = 1;};
	if($L2 ne ''){$lCount += 1; $languages[$lCount] = 2; $languages2[$lCount] = 2;};
	if($L3 ne ''){$lCount += 1; $languages[$lCount] = 3; $languages2[$lCount] = 3;};
	if($L4 ne ''){$lCount += 1; $languages[$lCount] = 4; $languages2[$lCount] = 4;};
	if($L5 ne ''){$lCount += 1; $languages[$lCount] = 5; $languages2[$lCount] = 5;};
	if($L6 ne ''){$lCount += 1; $languages[$lCount] = 6; $languages2[$lCount] = 6;};
	if($L7 ne ''){$lCount += 1; $languages[$lCount] = 7; $languages2[$lCount] = 7;};

	foreach (@languages) {
		$tl1 =  $_ ;
		
		foreach (@languages2) {      
			$tl2 =  $_ ;
			
			if($tl2 ne $tl1){
				if($tl1 ne '' && $tl1 ne '-' ){
					if($tl2 ne '' && $tl2 ne '-'){
						$sql_string = "INSERT INTO dictionary_tracker (id_dictionary, from_language, to_language, result) VALUES (" . $arr[0] . ",'L" . $tl1 . "','L" . $tl2 . "','No')";
						$objDAL->executeSQL($sql_string);
						$sql_string = "INSERT INTO  dictionary_statistics (id_dictionary, L1, L2,  pos, neg, ratio, counter, last_access_number) VALUES (" . $arr[0] . ",'L" . $tl1 . "','L" . $tl2 . "', 100, 100, 1, 0, 0)";
						#print $sql_string;
						$objDAL->executeSQL($sql_string);
					}
				}
			}      
		}
	} 



	return 1;
}
#-------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------

sub registerResult{
	my ($self, $result, $id, $fromLanguage, $toLanguage) = @_;
	my $objDAL = DataAccessLayer->new();
	my $sql_string;
	my @arr;
	my $counter;
	my $val;
	my $categoryHistory;
	my $yesNoHistory;
	my $ratio;
		
	$objDAL->setModul('data');

	# resultat von der letzten abfrage eintragen

		if ($result ne ''){

			if ($result eq 'No'){        
				$sql_string = "SELECT N" . $toLanguage . " FROM dictionary WHERE id = " . $id;    
			}else{        
				$sql_string = "SELECT P" . $toLanguage . " FROM dictionary WHERE id = " . $id;      
			}
		
			@arr = $objDAL->getOneLineArray($sql_string);
			#return @arr;

			$counter = 0;
			$counter = $arr[0];  
		
			$counter = $counter + 1;
		
			if ($result eq 'No'){   
				$sql_string = "UPDATE dictionary SET   N" . $toLanguage . " = " .$counter. "  WHERE id = " . $id;    
			}else{        
				$sql_string = "UPDATE dictionary SET   P" . $toLanguage . " = " .$counter. "  WHERE id = " . $id;      
			}

			$objDAL->executeSQL($sql_string);		
			$sql_string = "INSERT INTO dictionary_tracker (id_dictionary, from_language, to_language, result) VALUES (" . $id . ",'L" . $fromLanguage . "','L" . $toLanguage . "','" . $result . "')";
			$objDAL->executeSQL($sql_string);   

			# register result in statistics
			$sql_string = "SELECT id, L1, L2,  pos, neg, ratio, counter FROM dictionary_statistics WHERE id_dictionary = " . $id . " AND L1 = '" . "L" . $fromLanguage . "' AND L2 = '" . "L" . $toLanguage . "'";  
			#print $sql_string;
			@arr = $objDAL->getOneLineArray($sql_string);
			# now update ratios and values
			if ($result eq 'No'){   
				$val = $arr[4] + 1;
				$sql_string = "UPDATE  dictionary_statistics SET neg = " . $val . " WHERE id = " . $arr[0];
				$objDAL->executeSQL($sql_string); 
				#print $sql_string;
				$val = $arr[3] / ($arr[4] + 1);
				$ratio = $val;
				$sql_string = "UPDATE  dictionary_statistics SET ratio = " . $val . " WHERE id = " . $arr[0];
				$objDAL->executeSQL($sql_string); 
				#print $sql_string;
			}else{   
				$val = $arr[3] + 1;
				$sql_string = "UPDATE  dictionary_statistics SET pos = " . $val  . " WHERE id = " . $arr[0];
				$objDAL->executeSQL($sql_string); 
				#print $sql_string;
				$val = ($arr[3] +1 ) / $arr[4];
				$sql_string = "UPDATE  dictionary_statistics SET ratio = " . $val . " WHERE id = " . $arr[0];
				$objDAL->executeSQL($sql_string); 
				$ratio = $val;
				#print $sql_string;
			}
			$val = $arr[6] + 1;
			$sql_string = "UPDATE  dictionary_statistics SET counter = " . $val . " WHERE id = " . $arr[0];
			$objDAL->executeSQL($sql_string);  
			$sql_string = "UPDATE  dictionary_statistics SET last_access_number = " . time() . " WHERE id = " . $arr[0];
			$objDAL->executeSQL($sql_string);  


			# new logic with categories and history added on 26th Oct 2013
			# add result to history but make sure history is not getting too long
			$sql_string = "SELECT history, category, category_history FROM dictionary_statistics WHERE id_dictionary = " . $id . " AND L1 = '" . "L" . $fromLanguage . "' AND L2 = '" . "L" . $toLanguage . "'";  
			@arr = $objDAL->getOneLineArray($sql_string);

			if ($result eq 'No'){   
				$val = "N" . $arr[0];
			} else { 
				$val = "Y" . $arr[0];
			}
			$val =  substr($val, 0, 199);
			$yesNoHistory = $val;
			$sql_string = "UPDATE  dictionary_statistics SET history = '" . $val . "' WHERE id_dictionary = " . $id . " AND L1 = '" . "L" . $fromLanguage . "' AND L2 = '" . "L" . $toLanguage . "'";  
			$objDAL->executeSQL($sql_string);  

			$categoryHistory = $arr[2];

			# if it is a new word then we move it to category 1 no matter if result was good or not 
			if($arr[1]  eq '0' ){
				$sql_string = "UPDATE  dictionary_statistics SET category = 1 WHERE id_dictionary = " . $id . " AND L1 = '" . "L" . $fromLanguage . "' AND L2 = '" . "L" . $toLanguage . "'";  
				$objDAL->executeSQL($sql_string);  
				$categoryHistory = "1" . $arr[2];
				$categoryHistory =  substr($categoryHistory, 0, 199);
				$sql_string = "UPDATE  dictionary_statistics SET category_history = '" . $categoryHistory . "' WHERE id_dictionary = " . $id . " AND L1 = '" . "L" . $fromLanguage . "' AND L2 = '" . "L" . $toLanguage . "'";  
				$objDAL->executeSQL($sql_string);  
			}	


			if ($result eq 'No'){   
				# if result was negative then we need to check if word needs to be move to category 1
				if($arr[1]  eq '2'  ||   $arr[1]  eq '3'){
					$sql_string = "UPDATE  dictionary_statistics SET category = 1 WHERE id_dictionary = " . $id . " AND L1 = '" . "L" . $fromLanguage . "' AND L2 = '" . "L" . $toLanguage . "'";  
					$objDAL->executeSQL($sql_string);  
					$categoryHistory = "1" . $arr[2];
					$categoryHistory =  substr($categoryHistory, 0, 199);
					$sql_string = "UPDATE  dictionary_statistics SET category_history = '" . $categoryHistory . "' WHERE id_dictionary = " . $id . " AND L1 = '" . "L" . $fromLanguage . "' AND L2 = '" . "L" . $toLanguage . "'";  
					$objDAL->executeSQL($sql_string);  
				}			
			} else { 
				# if result was positive then we need to check if it should be moved 
				if($ratio > 1.0 ){
					# if it was a new word then we move it to next category 
					if(substr($categoryHistory, 0, 2) eq '10'   ||   substr($categoryHistory, 0, 2) eq '11'  ){
						if(substr($yesNoHistory, 0, 2) eq 'YY' ){
							$sql_string = "UPDATE  dictionary_statistics SET category = 2 WHERE id_dictionary = " . $id . " AND L1 = '" . "L" . $fromLanguage . "' AND L2 = '" . "L" . $toLanguage . "'";  
							$objDAL->executeSQL($sql_string);  
						}
					}

					# if word was in category 2 and is not in category 1  then we need to check how often we knew it
					if(substr($categoryHistory, 0, 2) eq '12' || substr($categoryHistory, 0, 2) eq '13'){
						# we need to know the word four times in a row to move it
						if(substr($yesNoHistory, 0, 4) eq 'YYYY' ){
							$sql_string = "UPDATE  dictionary_statistics SET category = 2 WHERE id_dictionary = " . $id . " AND L1 = '" . "L" . $fromLanguage . "' AND L2 = '" . "L" . $toLanguage . "'";  
							$objDAL->executeSQL($sql_string); 
						} 
					}
					# if word is in category 2 then we can move it to categoy 3 if we really know it good
					if(substr($categoryHistory, 0, 1) eq '2'){
						if(substr($yesNoHistory, 0, 2) eq 'YY' ){
							$sql_string = "UPDATE  dictionary_statistics SET category = 3 WHERE id_dictionary = " . $id . " AND L1 = '" . "L" . $fromLanguage . "' AND L2 = '" . "L" . $toLanguage . "'";  
							$objDAL->executeSQL($sql_string);  
						}
					} # if category is 2
				} # if ratio is bigger than 1 
			} # if result is positive
 
			#print $sql_string;
		}   # if result is not empty
		return 1;
}

#-------------------------------------------------------------------------------------------------
# zufalls eintrag auswählen - 2 methoden gibt es - davon zu 2 dritteln 

sub getRandomContent{
	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @arr;

	$sql_string = " SELECT a.id , a.L1 , a.P1 , a.N1,  a.L2,  a.P2,  a.N2,  a.L3 , a.P3 , a.N3 , a.L4 , a.P4 , a.N4 , a.L5,  a.P5 , a.N5,  a.L6,  a.P6,  a.N6,  a.L7,  a.P7 , a.N7,  a.L8 , a.P8,  a.N8,  COMMENT   FROM dictionary a";
#	$sql_string .= " WHERE a.L1 NOT LIKE '%(%' ";
#	$sql_string .= " AND L2 NOT LIKE '%(%' ";
#	$sql_string .= " AND L3 NOT LIKE '%(%' ";
#	$sql_string .= " AND L4 NOT LIKE '%(%' ";
#	$sql_string .= " AND L5 NOT LIKE '%(%' ";
#	$sql_string .= " AND L6 NOT LIKE '%(%' ";
#	$sql_string .= " AND L7 NOT LIKE '%(%' ";
#        $sql_string .= " WHERE a.id IN (SELECT b.id  FROM  dictionary b WHERE b.L1 NOT LIKE '%Substantive%' AND b.L2 NOT LIKE '%Substantive%'  AND b.L3 NOT LIKE '%Substantive%'  AND b.L4 NOT LIKE '%Substantive%'  AND b.L5 NOT LIKE '%Substantive%'  AND b.L6 NOT LIKE '%Substantive%'  AND b.L7 NOT LIKE '%Substantive%' ) ";
        #$sql_string .= " WHERE a.id IN (SELECT b.id  FROM  dictionary b WHERE b.L1 NOT LIKE '%Substantive%' AND b.L2 NOT LIKE '%Substantive%'  AND b.L3 NOT LIKE '%Substantive%'  AND b.L4 NOT LIKE '%Substantive%'  AND b.L5 NOT LIKE '%Substantive%'  AND b.L6 NOT LIKE '%Substantive%'  AND b.L7 NOT LIKE '%Substantive%' ";
#        $sql_string .= " AND b.L1 NOT LIKE '%Substantive%' AND b.L2 NOT LIKE '%Substantive%'  AND b.L3 NOT LIKE '%Substantive%'  AND b.L4 NOT LIKE '%Substantive%'  AND b.L5 NOT LIKE '%Substantive%'  AND b.L6 NOT LIKE '%Substantive%'  AND b.L7 NOT LIKE '%Substantive%' "; 
#        $sql_string .= " AND b.L1 NOT LIKE '%Verben%' AND b.L2 NOT LIKE '%Verben%'  AND b.L3 NOT LIKE '%Verben%'  AND b.L4 NOT LIKE '%Verben%'  AND b.L5 NOT LIKE '%Verben%'  AND b.L6 NOT LIKE '%Verben%'  AND b.L7 NOT LIKE '%Verben%' "; 
#        $sql_string .= " AND b.L1 NOT LIKE '%Nomen%' AND b.L2 NOT LIKE '%Nomen%'  AND b.L3 NOT LIKE '%Nomen%'  AND b.L4 NOT LIKE '%Nomen%'  AND b.L5 NOT LIKE '%Nomen%'  AND b.L6 NOT LIKE '%Nomen%'  AND b.L7 NOT LIKE '%Nomen%' "; 
#        $sql_string .= " AND b.L1 NOT LIKE '%Pronomen%' AND b.L2 NOT LIKE '%Pronomen%'  AND b.L3 NOT LIKE '%Pronomen%'  AND b.L4 NOT LIKE '%Pronomen%'  AND b.L5 NOT LIKE '%Pronomen%'  AND b.L6 NOT LIKE '%Pronomen%'  AND b.L7 NOT LIKE '%Pronomen%' "; 
#        $sql_string .= " AND b.L1 NOT LIKE '­jektive%' AND b.L2 NOT LIKE '­jektive%'  AND b.L3 NOT LIKE '­jektive%'  AND b.L4 NOT LIKE '­jektive%'  AND b.L5 NOT LIKE '­jektive%'  AND b.L6 NOT LIKE '­jektive%'  AND b.L7 NOT LIKE '­jektive%' ";
#        $sql_string .= " AND b.L1 NOT LIKE '­verbien%' AND b.L2 NOT LIKE '­verbien%'  AND b.L3 NOT LIKE '­verbien%'  AND b.L4 NOT LIKE '­verbien%'  AND b.L5 NOT LIKE '­verbien%'  AND b.L6 NOT LIKE '­verbien%'  AND b.L7 NOT LIKE '­verbien%' ) ";
	$sql_string .= " ORDER BY RAND( )  LIMIT 1 ";
		
	@arr = $objDAL->getOneLineArray($sql_string);
	return @arr;
}


#-------------------------------------------------------------------------------------------------

sub getMaxRatio{

	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @arr;
	my @arrRet;
	my $randomRecord;
	my $recCount;
	my $maxRatio;
	my $y;
	my $stopLoop;

	$sql_string = " SELECT a.id_dictionary, a.from_language, a.to_language, ( ";
	$sql_string .= " if( sum( if( a.result = 'No', 1, 0 ) ) = 0, 0.1, sum( if( a.result = 'No', 1, 0 ) ) ) / if( sum( if( a.result <> 'No', 1, 0 ) ) =0, 0.001, sum( if( a.result <> 'No', 1, 0 ) ) ) ";
	$sql_string .= " ) AS ratio ";
	$sql_string .= " FROM dictionary_tracker a ";
	$sql_string .= " WHERE a.from_language <> a.to_language  and a.from_language <> '' and a.to_language <> '' ";
	$sql_string .= " GROUP BY a.id_dictionary, a.from_language, a.to_language ";
	$sql_string .= " ORDER BY ratio DESC ";
	$sql_string .= " LIMIT 0 , 2 ";

	@arr = $objDAL->getArray($sql_string);

	return  $arr[0][3];
}



#-------------------------------------------------------------------------------------------------

sub getStatisticsRatios{

	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @arr;
	my @arrRet;
	my $randomRecord;
	my $recCount;
	my $maxRatio;
	my $y;
	my $stopLoop;

	$sql_string = "SELECT  id_dictionary, L1, L2,  pos, neg, ratio FROM dictionary_statistics";
	$sql_string .= " ORDER BY ratio ASC ";


	@arr = $objDAL->getArray($sql_string);

	return @arr;

}

#-------------------------------------------------------------------------------------------------

sub getContentNotLearnedFromStatistics{

	my ($self, $id) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @arr;
	my @arrRet;
	my $randomRecord;
	my $recCount;
	my $maxRatio;
	my $y;
	my $stopLoop;

       	if ($id  eq ''){   
		$id = "0";    
	}

	$sql_string = "SELECT  id_dictionary, L1, L2,  ratio, pos, neg   FROM dictionary_statistics WHERE id_dictionary <> " . $id;
	$sql_string .= " ORDER BY ratio ASC ";
	$sql_string .= " LIMIT 0 , 10";

	@arr = $objDAL->getArray($sql_string);

	srand();
	$randomRecord = int( rand(5) );
	$recCount = 0;
	$maxRatio;
	$stopLoop = 0;

	for $y (0.. $#arr ) { 

	if($stopLoop eq 0){
		if($self->vocExists($arr[$y][1], $arr[$y][2], $arr[$y][0]) eq 1){
		
			if($recCount == $randomRecord){
				$arrRet[0] = $arr[$y][0];
				$arrRet[1] = $arr[$y][1];
				$arrRet[2] = $arr[$y][2];
				#$arrRet[3] = $arr[$y][4];
				#$arrRet[4] = $arr[$y][5];
				$arrRet[5] = $arr[$y][4];
				$arrRet[6] = $arr[$y][5];
				$stopLoop = 1;
			}
			
			if($recCount == 0){
				$arrRet[4] = $arr[$y][3];            
			}
			$recCount = $recCount + 1;
			}
		}
	}

	return @arrRet;

}

#-------------------------------------------------------------------------------------------------
# this one gets the next word with tatio 1 

sub getContentNotLearnedFromRatio{

	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @arr;
	my @arrRet;
	my $randomRecord;
	my $recCount;
	my $maxRatio;
	my $y;
	my $stopLoop;

	$sql_string = "SELECT  id_dictionary, L1, L2,  ratio, pos, neg FROM dictionary_statistics WHERE ratio >= 1";
	$sql_string .= " ORDER BY ratio ASC ";
	$sql_string .= " LIMIT 0 , 2";

	@arr = $objDAL->getArray($sql_string);

	srand();
	$randomRecord = 0;
	$recCount = 0;
	$maxRatio;
	$stopLoop = 0;

	for $y (0.. $#arr ) { 

	if($stopLoop eq 0){
		if($self->vocExists($arr[$y][1], $arr[$y][2], $arr[$y][0]) eq 1){
		
			if($recCount == $randomRecord){
				$arrRet[0] = $arr[$y][0];
				$arrRet[1] = $arr[$y][1];
				$arrRet[2] = $arr[$y][2];
				$arrRet[3] = $arr[$y][4];
				$arrRet[4] = $arr[$y][5];
				$stopLoop = 1;
			}
			
			if($recCount == 0){
				$arrRet[4] = $arr[$y][3];            
			}
			$recCount = $recCount + 1;
			}
		}
	}

	return @arrRet;
}
#-------------------------------------------------------------------------------------------------

sub getContentNotLearned{

	my ($self) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @arr;
	my @arrRet;
	my $randomRecord;
	my $recCount;
	my $maxRatio;
	my $y;
	my $stopLoop;

	$sql_string = " SELECT a.id_dictionary, a.from_language, a.to_language, ( ";
	$sql_string .= " if( sum( if( a.result = 'No', 1, 0 ) ) = 0, 0.1, sum( if( a.result = 'No', 1, 0 ) ) ) / if( sum( if( a.result <> 'No', 1, 0 ) ) =0, 0.001, sum( if( a.result <> 'No', 1, 0 ) ) ) ";
	$sql_string .= " ) AS ratio ";
	$sql_string .= " FROM dictionary_tracker a ";
	$sql_string .= " WHERE a.from_language <> a.to_language  and a.from_language <> '' and a.to_language <> '' ";
      #  $sql_string .= " AND  a.id_dictionary IN (SELECT id  FROM  dictionary WHERE L1 NOT LIKE '%Substantive%' AND L2 NOT LIKE '%Substantive%'  AND L3 NOT LIKE '%Substantive%'  AND L4 NOT LIKE '%Substantive%'  AND L5 NOT LIKE '%Substantive%'  AND L6 NOT LIKE '%Substantive%'  AND L7 NOT LIKE '%Substantive%' ) ";


    #    $sql_string .= " AND  a.id_dictionary IN (SELECT b.id  FROM  dictionary b WHERE b.L1 NOT LIKE '%Substantive%' AND b.L2 NOT LIKE '%Substantive%'  AND b.L3 NOT LIKE '%Substantive%'  AND b.L4 NOT LIKE '%Substantive%'  AND b.L5 NOT LIKE '%Substantive%'  AND b.L6 NOT LIKE '%Substantive%'  AND b.L7 NOT LIKE '%Substantive%' ";
#        $sql_string .= " AND b.L1 NOT LIKE '%Substantive%' AND b.L2 NOT LIKE '%Substantive%'  AND b.L3 NOT LIKE '%Substantive%'  AND b.L4 NOT LIKE '%Substantive%'  AND b.L5 NOT LIKE '%Substantive%'  AND b.L6 NOT LIKE '%Substantive%'  AND b.L7 NOT LIKE '%Substantive%' "; 
#        $sql_string .= " AND b.L1 NOT LIKE '%Verben%' AND b.L2 NOT LIKE '%Verben%'  AND b.L3 NOT LIKE '%Verben%'  AND b.L4 NOT LIKE '%Verben%'  AND b.L5 NOT LIKE '%Verben%'  AND b.L6 NOT LIKE '%Verben%'  AND b.L7 NOT LIKE '%Verben%' "; 
#        $sql_string .= " AND b.L1 NOT LIKE '%Nomen%' AND b.L2 NOT LIKE '%Nomen%'  AND b.L3 NOT LIKE '%Nomen%'  AND b.L4 NOT LIKE '%Nomen%'  AND b.L5 NOT LIKE '%Nomen%'  AND b.L6 NOT LIKE '%Nomen%'  AND b.L7 NOT LIKE '%Nomen%' "; 
#        $sql_string .= " AND b.L1 NOT LIKE '%Pronomen%' AND b.L2 NOT LIKE '%Pronomen%'  AND b.L3 NOT LIKE '%Pronomen%'  AND b.L4 NOT LIKE '%Pronomen%'  AND b.L5 NOT LIKE '%Pronomen%'  AND b.L6 NOT LIKE '%Pronomen%'  AND b.L7 NOT LIKE '%Pronomen%' "; 
#        $sql_string .= " AND b.L1 NOT LIKE '­­jektive%' AND b.L2 NOT LIKE '­jektive%'  AND b.L3 NOT LIKE '­jektive%'  AND b.L4 NOT LIKE '­jektive%'  AND b.L5 NOT LIKE '­jektive%'  AND b.L6 NOT LIKE '­jektive%'  AND b.L7 NOT LIKE '­jektive%' ";
#        $sql_string .= " AND b.L1 NOT LIKE '­­verbien%' AND b.L2 NOT LIKE '­verbien%'  AND b.L3 NOT LIKE '­verbien%'  AND b.L4 NOT LIKE '­verbien%'  AND b.L5 NOT LIKE '­verbien%'  AND b.L6 NOT LIKE '­verbien%'  AND b.L7 NOT LIKE '­verbien%' ) ";

	#$sql_string .= " and a.from_language <> NULL and a.to_language <> NULL ";
	$sql_string .= " GROUP BY a.id_dictionary, a.from_language, a.to_language ";
	$sql_string .= " ORDER BY ratio DESC ";
		$sql_string .= " LIMIT 0 , 10 ";

	@arr = $objDAL->getArray($sql_string);

	srand();
	$randomRecord = int( rand(9) );
	$recCount = 0;
	$maxRatio;
	$stopLoop = 0;

	for $y (0.. $#arr ) { 

	if($stopLoop eq 0){
		if($self->vocExists($arr[$y][1], $arr[$y][2], $arr[$y][0]) eq 1){
		
			if($recCount == $randomRecord){
				$arrRet[0] = $arr[$y][0];
				$arrRet[1] = $arr[$y][1];
				$arrRet[2] = $arr[$y][2];
				$stopLoop = 1;
			}
			
			if($recCount == 0){
				$arrRet[4] = $arr[$y][3];            
			}
			$recCount = $recCount + 1;
			}
		}
	}

	return @arrRet;
}

#-------------------------------------------------------------------------------------------------

sub getNextWordFromCategories{

	my ($self, $id) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @arr;
	my @arrRet;
	my $randomRecord;
	my $recCount;
	my $maxRatio;
	my $y;
	my $stopLoop;
	my  $category;
	my $randomCategory;
	my $minRatio;
	my $minRatioRef;

	# if we have enough in category 1 then we stay there, otherwise we use from category 0 

	$sql_string = " SELECT count( category ) FROM dictionary_statistics WHERE category =1 ";
	@arr = $objDAL->getArray($sql_string);

	if(  $arr[0][0]  > 10){
		# select word within category 1 
		$category = 1;
	}else{
		srand();
		$randomCategory = int( rand(100) ); 
		# in 50 percent of the cases we use a word from category 0 
		if($randomCategory  >= 50 ){
			$category = 0;
		}elsif($randomCategory  < 50 || $randomCategory  >= 20){
			# in 30 percent of the cases we use a word from category 2
			$category = 2;
		}elsif($randomCategory  < 20){
			# in 30 percent of the cases we use a word from category 3
			$category = 3;
		}
	}

 	if ($id  eq ''){   
		$id = "0";    
	}

	# check if there is a word that we absolutely do not learn. then focus on this word
	# this is only relevant for category 1
	$sql_string = "SELECT  min( ratio)   FROM dictionary_statistics WHERE id_dictionary <> " . $id . " AND category = " . $category;
	@arr = $objDAL->getArray($sql_string);
	$minRatio = $arr[0][0];

	# prepare the next sql 
	$sql_string = "SELECT  id_dictionary, L1, L2,  ratio, pos, neg, category, history, category_history   FROM dictionary_statistics WHERE id_dictionary <> " . $id . " AND category = " . $category;


	if($category eq "1"){
		#srand();
		#$randomRecord = int( rand(10) ); 
		$minRatioRef = 100 / 106;
		if($minRatio > $minRatioRef){
			# if we know most words, then chose a random word
			# use the words we know best
			# $sql_string .= " ORDER BY ratio DESC  ";    # only in category 1 we focus on the right sort order
			$sql_string .= " ORDER BY RAND() ";    # in 20 percent of cases we want random value
		}else{
			# use the words we know last
			$sql_string .= " ORDER BY ratio ASC ";    # only in category 1 we focus on the right sort order
		}
		# $sql_string .= " ORDER BY ratio ASC ";    # ensure we take the word we know last

	}else{
		$sql_string .= " ORDER BY RAND()  ";    # take random content for all other categories
	}
	$sql_string .= " LIMIT 0 , 10";     # this limitation can lead to an error because maybe we do not have that many elements in the category

	@arr = $objDAL->getArray($sql_string);

	srand();
	# $randomRecord = int( rand(7) );   # this limitation can lead to an error because maybe we do not have that many elements in the category
	$randomRecord = 0;
	$recCount = 0;
	$maxRatio;
	$stopLoop = 0;

	for $y (0.. $#arr ) { 

	if($stopLoop eq 0){
		if($self->vocExists($arr[$y][1], $arr[$y][2], $arr[$y][0]) eq 1){
		
			if($recCount == $randomRecord){
				$arrRet[0] = $arr[$y][0];
				$arrRet[1] = $arr[$y][1];
				$arrRet[2] = $arr[$y][2];
				#$arrRet[3] = $arr[$y][4];
				#$arrRet[4] = $arr[$y][5];
				$arrRet[5] = $arr[$y][4];
				$arrRet[6] = $arr[$y][5];
				$arrRet[7] = $arr[$y][6];
				$arrRet[8] = substr($arr[$y][7], 0, 20);
				$arrRet[9] = substr($arr[$y][8], 0, 10);
				$stopLoop = 1;
			}
			
			#if($recCount == 0){
				$arrRet[4] = $arr[$y][3];            
			#}
			$recCount = $recCount + 1;
			}
		}
	}

	return @arrRet;

}

#-------------------------------------------------------------------------------------------------

sub getCategoryStatistics{

	my ($self, $id) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @arrRet;

	$sql_string = " select category, count(category) from 	`dictionary_statistics` group by category ";
	@arrRet = $objDAL->getArray($sql_string);

	return @arrRet;
}

#-------------------------------------------------------------------------------------------------

sub getCategoryStatisticsTwo{

	my ($self, $id) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;
	my @arrRet;

	$sql_string = " SELECT sum( counter ) FROM `dictionary_statistics` ";
	@arrRet = $objDAL->getArray($sql_string);

	return @arrRet;
}


#-------------------------------------------------------------------------------------------------

sub vocExists{

	my @arr;
	my ($self, $L1 , $L2 , $id) = @_;
#   my $objDAL = DataAccessLayer->new();
#   $objDAL->setModul('data');
#   my $sql_string;
#   my $ret;
#   $sql_string = "SELECT " . $L1 . ", " . $L2 . " FROM  dictionary where id = " . $id;
#   @arr = $objDAL->getOneLineArray($sql_string);
#   if($arr[0] ne '' && $arr[1] ne ''){
#      $ret = 1;
#   }else{
#      $ret = 0;
#   }
#   #$ret = 1;
#   return $ret;   

	return 1; 

}

# -------------------------------------------------------------------------------------------------


sub getOneWord{
	my @arr;
	my ($self, $L1 , $L2 , $id) = @_;
	my $objDAL = DataAccessLayer->new();
	$objDAL->setModul('data');
	my $sql_string;

	$sql_string = "SELECT " . $L1 . ", " . $L2 . " FROM  dictionary where id = " . $id;

	@arr = $objDAL->getOneLineArray($sql_string);
	return @arr;    
}
#-------------------------------------------------------------------------------------------------
sub encodeValue{    
    my $codestring = "";    
    $codestring = $_[0];
    $codestring =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;
    return $codestring; 
}
#-------------------------------------------------------------------------------------------------
sub decodeValue{    
    my ($codestring) = @_;
    $codestring =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;
    return $codestring;      
}

#-------------------------------------------------------------------------------------------------
1; 

