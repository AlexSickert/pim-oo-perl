package PageConfig;

#------------------------------------------------------------------------------------
sub new {
    my ($class) = @_;
    my $self =
      {  _body => undef, 
        _value => undef };
    bless $self, $class;
    
    return $self;
}
#------------------------------------------------------------------------------------

sub get{
    my ( $self, $param ) = @_;
    
    my %configValues =(
        "page-title" => "AS",
        "application-base-path" => "",
        "db-root-name" => "root",
        "db-root-password" => "F4XB64eU",
        "mail-download-path" => "/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/",
        "mail-download-virtual-path" => "https://ssl-id1.de/alex-admin.net/alex-admin/",
        "mail-sent-download-path" => "",
        "application-virtual-path" => "",
        "db-dump-path" => "/var/www/vhosts/alex-admin.net/httpdocs/db_backup/",
        "db-import-path" => "/var/www/vhosts/alex-admin.net/httpdocs/db_import/",
        "data-upload-path" => "/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/",
        "data-upload-virtual-path" => "https://ssl-id1.de/alex-admin.net/alex-admin/",
        "dev-server-path" => "/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/dev/perl",  
        "live-server-path" => "/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl",
        "server-path" => "/var/www/vhosts/alex-admin.net/",
        "css-relative-path" => "../../style/",
        "js-relative-path" => "../../javascript/",
        "js-css-absolute-path" => "https://ssl-id1.de/alex-admin.net/alex-admin/",
        "code-absolute-path" => "https://ssl-id1.de/alex-admin.net/alex-admin/",
        "cms-path" => "/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/",

        "mail_0_default" => "xxxxxxxxxxxxxxxxxxxxxxx", 

        "mail_1_name" => "xxxxxxxxxx",
        "mail_1_email" => "xxxxxxxxxxxxx",
        "mail_1_server" => "xxxxxxxxxxxxxxxxx",
        "mail_1_login" => "xxxxxxxxxxxxxxx",
        "mail_1_password" => "xxxxxxxxxxxxxxxxx",
        "mail_1_signature" => "\n____________________________________________\n\n Alexander Sickert\n MBA, MSc Int. Fin. Mgmt.\n Owner\n\n  Mail\: alexander\.Sickert\@cusoto\.com\n Phone Germany\: +498923513326\n Mobile Phone Germany\: +4917620607353 \n Mobile Phone Ukraine\: +380974796793\n Web: www.cusoto.com\n\n CUSOTO GmbH\n Projects - Management - Marketing\n\n Lindenstr\. 12a\n 81545 M\x{00FC}nchen\n\n Amtsgericht M\x{00FC}nchen HRB 167932\n USt-IdNr\.\: DE254367867\n\n____________________________________________",

        "mail_2_name" => "xxxxxxxxxxxxxxxx",
        "mail_2_email" => "xxxxxxxxxxxxxxxxx",
        "mail_2_server" => "xxxxxxxxxxxxxxxxx",
        "mail_2_login" => "xxxxxxxxxxxxxxxxxx",
        "mail_2_password" => "xxxxxxxxxxxxxxxxx",
        "mail_2_signature" => "\n____________________________________________\n\nSolenski Photography\nKnollerstr\. 5\n80802 München\nUSt\.id-Nr\.\: DE 199 345 742\nMail\: alex\@solenski\.com\nPhone\: +49 (0)176-2060-7353\nWeb: www.solenski.com\n\n____________________________________________",

        "mail_3_name" => "xxxxxxxxxxxxxxxxxxx",
        "mail_3_email" => "xxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "mail_3_server" => "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "mail_3_login" => "xxxxxxxxxxxxxxxxxxxxxxx",
        "mail_3_password" => "xxxxxxxxxxxxxxxxxxxxxx",   
        "mail_3_signature" => "-------- alex\@alexandersickert.com --------"

        );
   
    return $configValues{$param};
}
#------------------------------------------------------------------------------------
sub mailLogin{
    my ( $self, $id, $param ) = @_;

    return $self->get("mail_" . $id . "_" . $param );   ;    
}
#------------------------------------------------------------------------------------
sub moduleArr{
    my ( $self ) = @_;
    my @returnValue =(
        "admin",
        "data",
        "invest",
        "mail",
        "accounting");
    return @returnValue;    
}
#------------------------------------------------------------------------------------
sub serverloc{
    my ( $self ) = @_;
    my $test = $self->get("live-server-path");   
    my $check = $ENV{'SCRIPT_FILENAME'};
    
    if(index($check, $test) > -1){
        return 'live';
    }else{
        return 'dev';
    }
};

#------------------------------------------------------------------------------------
sub mailDownloadPath{   
    my ( $self ) = @_;    
    my $string = $self->get("mail-download-path") . $self->serverloc() . "/mail/received/"; 
    return $string;
}

#------------------------------------------------------------------------------------
sub mailDownloadVirtualPath{   
    my ( $self ) = @_;    
    my $string = $self->get("mail-download-virtual-path") . $self->serverloc() . "/mail/received/"; 
    return $string;
}

#------------------------------------------------------------------------------------
sub jsPath{   
    my ( $self ) = @_;    
    my $string = $self->get("js-relative-path"); 
    return $string;
}
#------------------------------------------------------------------------------------
sub jsPathAbsolut{   
    my ( $self ) = @_;    
    my $string = $self->get("js-css-absolute-path") . $self->serverloc() . "/javascript/"; 
    return $string;
}
#------------------------------------------------------------------------------------
sub codePathAbsolut{   
    my ( $self ) = @_;    
    my $string = $self->get("code-absolute-path") . $self->serverloc() . "/perl/"; 
    return $string;
}
#------------------------------------------------------------------------------------
sub cssPath{    
    my ( $self ) = @_;    
    my $string = $self->get("css-relative-path"); 
    return $string;
}
#------------------------------------------------------------------------------------
sub uploadPath{    
    my ( $self ) = @_;    
    my $string = $self->get("data-upload-path") . $self->serverloc() . "/upload/"; 
    return $string;
}
#------------------------------------------------------------------------------------
sub cmsPath{    
    my ( $self ) = @_;    
    my $string = $self->get("cms-path") . $self->serverloc() . "/cms/"; 
    return $string;
}
#------------------------------------------------------------------------------------
sub uploadVirtualPath{    
    my ( $self ) = @_;    
    my $string = $self->get("data-upload-virtual-path") . $self->serverloc() . "/upload/"; 
    return $string;
}
#------------------------------------------------------------------------------------


1; 