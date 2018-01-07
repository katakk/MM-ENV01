#!/usr/bin/perl

use RRDs;
my $img = '/var/www/html';

=pod
rrdtool create /var/lib/rrd/hdc1000_humidity.rrd      -s 60  DS:hdc1000_humidity:GAUGE:240:U:U RRA:AVERAGE:0.5:1:1200 RRA:AVERAGE:0.5:6:1200 RRA:AVERAGE:0.5:24:1200 RRA:AVERAGE:0.5:144:1200
rrdtool create /var/lib/rrd/hdc1000_tempC.rrd         -s 60  DS:hdc1000_tempC:GAUGE:240:U:U RRA:AVERAGE:0.5:1:1200 RRA:AVERAGE:0.5:6:1200 RRA:AVERAGE:0.5:24:1200 RRA:AVERAGE:0.5:144:1200
rrdtool create /var/lib/rrd/mpl311_press.rrd          -s 60  DS:mpl311_press:GAUGE:240:U:U RRA:AVERAGE:0.5:1:1200 RRA:AVERAGE:0.5:6:1200 RRA:AVERAGE:0.5:24:1200 RRA:AVERAGE:0.5:144:1200
rrdtool create /var/lib/rrd/mpl311_tempC.rrd          -s 60  DS:mpl311_tempC:GAUGE:240:U:U RRA:AVERAGE:0.5:1:1200 RRA:AVERAGE:0.5:6:1200 RRA:AVERAGE:0.5:24:1200 RRA:AVERAGE:0.5:144:1200
rrdtool create /var/lib/rrd/opt3001_lux.rrd           -s 60  DS:opt3001_lux:GAUGE:240:U:U RRA:AVERAGE:0.5:1:1200 RRA:AVERAGE:0.5:6:1200 RRA:AVERAGE:0.5:24:1200 RRA:AVERAGE:0.5:144:1200
rrdtool create /var/lib/rrd/veml6075_uva.rrd          -s 60  DS:veml6075_uva:GAUGE:240:U:U RRA:AVERAGE:0.5:1:1200 RRA:AVERAGE:0.5:6:1200 RRA:AVERAGE:0.5:24:1200 RRA:AVERAGE:0.5:144:1200
rrdtool create /var/lib/rrd/veml6075_uvb.rrd          -s 60  DS:veml6075_uvb:GAUGE:240:U:U RRA:AVERAGE:0.5:1:1200 RRA:AVERAGE:0.5:6:1200 RRA:AVERAGE:0.5:24:1200 RRA:AVERAGE:0.5:144:1200

=cut


my $hdc1000_humidity = `hdc1000_humidity| head -1`;
my $hdc1000_tempC    = `hdc1000_tempC   | head -1`;
my $mpl311_press     = `mpl311_press    | head -1`;
my $mpl311_tempC     = `mpl311_tempC    | head -1`;
my $opt3001_lux      = `opt3001_lux     | head -1`;
my $veml6075_uva     = `veml6075_uva    | head -1`;
my $veml6075_uvb     = `veml6075_uvb    | head -1`;

chomp($hdc1000_humidity);
chomp($hdc1000_tempC   );
chomp($mpl311_press    );
chomp($mpl311_tempC    );
chomp($opt3001_lux     );
chomp($veml6075_uva    );
chomp($veml6075_uvb    );

print "
hdc1000_humidity($hdc1000_humidity)
hdc1000_tempC   ($hdc1000_tempC)
mpl311_press    ($mpl311_press)
mpl311_tempC    ($mpl311_tempC)
opt3001_lux     ($opt3001_lux)
veml6075_uva    ($veml6075_uva)
veml6075_uvb    ($veml6075_uvb)

" if(@ARGV);


my $database_hdc1000_humidity = "/var/lib/rrd/hdc1000_humidity.rrd";
my $database_hdc1000_tempC    = "/var/lib/rrd/hdc1000_tempC.rrd";
my $database_mpl311_press     = "/var/lib/rrd/mpl311_press.rrd";
my $database_mpl311_tempC     = "/var/lib/rrd/mpl311_tempC.rrd";
my $database_opt3001_lux      = "/var/lib/rrd/opt3001_lux.rrd";
my $database_veml6075_uva     = "/var/lib/rrd/veml6075_uva.rrd";
my $database_veml6075_uvb     = "/var/lib/rrd/veml6075_uvb.rrd";

RRDs::update "$database_hdc1000_humidity","-t","hdc1000_humidity"  ,"N:$hdc1000_humidity" if($hdc1000_humidity);
RRDs::update "$database_hdc1000_tempC"   ,"-t","hdc1000_tempC"     ,"N:$hdc1000_tempC"    if($hdc1000_tempC);
RRDs::update "$database_mpl311_press"    ,"-t","mpl311_press"      ,"N:$mpl311_press"     if($mpl311_press);
RRDs::update "$database_mpl311_tempC"    ,"-t","mpl311_tempC"      ,"N:$mpl311_tempC"     if($mpl311_tempC);
RRDs::update "$database_opt3001_lux"     ,"-t","opt3001_lux"       ,"N:$opt3001_lux"      if($opt3001_lux);
RRDs::update "$database_veml6075_uva"    ,"-t","veml6075_uva"      ,"N:$veml6075_uva"     if($veml6075_uva);
RRDs::update "$database_veml6075_uvb"    ,"-t","veml6075_uvb"      ,"N:$veml6075_uvb"     if($veml6075_uvb);


        foreach(qw/day week month year/)
        {
                RRDs::graph "$img/$_" . "temp.png",
                        "--lazy",
                        "-s -1$_",
                        "-h", "320", "-w", "640",
                        "-a", "PNG",
			"-r", "-u", "40",

"DEF:hdc1000_tempC=$database_hdc1000_tempC:hdc1000_tempC:AVERAGE",
"DEF:mpl311_tempC=$database_mpl311_tempC:mpl311_tempC:AVERAGE",
"VDEF:a=hdc1000_tempC,LSLSLOPE",
"VDEF:b=hdc1000_tempC,LSLINT",
"CDEF:ls=hdc1000_tempC,POP,a,COUNT,*,b,+",
"LINE1:ls#CCCCCC:LeastSquaresMethod",
"LINE2:hdc1000_tempC#32CD32:tempC",
"LINE2:mpl311_tempC#64FF64:tempC" . "\\n";



                RRDs::graph "$img/$_" . "humidity.png",
                        "--lazy",
                        "-s -1$_",
                        "-h", "320", "-w", "640",
                        "-a", "PNG",
#			"-r", "-u", "100",

"DEF:hdc1000_humidity=$database_hdc1000_humidity:hdc1000_humidity:AVERAGE",
"LINE2:hdc1000_humidity#00BFFF:humidity" . "\\n";


                RRDs::graph "$img/$_" . "press.png",
                        "--lazy",
                        "-s -1$_",
                        "-h", "320", "-w", "640",
                        "-a", "PNG",
			"-r", "-u", "1032",

"DEF:mpl311_press=$database_mpl311_press:mpl311_press:AVERAGE",
"LINE1:mpl311_press#7B68EE:press",
"LINE2:1030#CC0000:1030", 
"LINE2:1013.25#CCCCCC:1013.25", 
"LINE2:990#0000CC:990" . "\\n";


                RRDs::graph "$img/$_" . "lux.png",
                        "--lazy",
                        "-s -1$_",
                        "-h", "320", "-w", "640",
                        "-a", "PNG",

"DEF:opt3001_lux=$database_opt3001_lux:opt3001_lux:AVERAGE",
"LINE2:opt3001_lux#FFD700:lux" . "\\n";



                RRDs::graph "$img/$_" . "uv.png",
                        "--lazy",
                        "-s -1$_",
                        "-h", "320", "-w", "640",
                        "-a", "PNG",

"DEF:veml6075_uva=$database_veml6075_uva:veml6075_uva:AVERAGE",
"DEF:veml6075_uvb=$database_veml6075_uvb:veml6075_uvb:AVERAGE",
"LINE2:veml6075_uva#EE42EE:uva",
"LINE2:veml6075_uvb#9932CC:uvb"  . "\\n";


                if ($ERROR = RRDs::error) { print "$0: unable to generate $img/$_ graph: $ERROR\n"; }
        }



