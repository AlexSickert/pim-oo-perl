package Utility;

# ----------------------------------------------------------------------------------------------------------------------------------
# constructor
# ----------------------------------------------------------------------------------------------------------------------------------

sub new {
	my ($class) = @_;
	my $self = { _col1 => 0, _col2 => 0 };
	bless $self, $class;
	return $self;
}

# ----------------------------------------------------------------------------------------------------------------------------------
# check in and out of a FILE - used by data.pl 
# Problem - if we registered a file and we chekc it in the the relation is lost
# an additional probme is that the tar file will have the name of the original file but what if it already exists?
# ----------------------------------------------------------------------------------------------------------------------------------

#sub checkInFile{
#}
#sub checkOutFile{
#}


# ----------------------------------------------------------------------------------------------------------------------------------
# check in and out of a FOLDER - used by mail
# Problem - if we registered a file and we chekc it in the the relation is lost
# an additional probme is that the tar file will have the name of the original file but what if it already exists?
# ----------------------------------------------------------------------------------------------------------------------------------

#sub checkInFolder{
#}
#sub checkOutFolder{
#}

# ----------------------------------------------------------------------------------------------------------------------------------
# get a random string with default length 20 characters
# ----------------------------------------------------------------------------------------------------------------------------------

sub getRandomString{
	my ($self, $length) = @_;

	my $password;
	my $_rand;

	my $password_length = $length;

	if (!$password_length) {
		$password_length = 20;
	}

	my @chars = split(",", "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z");

	srand;

	for (my $i=0; $i <= $password_length ;$i++) {
		$_rand = int(rand 60);
		$password .= $chars[$_rand];
	}
	return $password;
}
# ----------------------------------------------------------------------------------------------------------------------------------
# get a random string with default length 20 characters
# ----------------------------------------------------------------------------------------------------------------------------------

sub getRandomNumericString{
	my ($self, $length) = @_;

	my $password;
	my $_rand;

	my $password_length = $length;

	if (!$password_length) {
		$password_length = 20;
	}

	my @chars = split(",", "0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9");

	srand;

	for (my $i=0; $i <= $password_length-1 ;$i++) {
		$_rand = int(rand 10);
		$password .= $chars[$_rand];
	}
	return $password;
}

# ----------------------------------------------------------------------------------------------------------------------------------
# 
# ----------------------------------------------------------------------------------------------------------------------------------
1; 
