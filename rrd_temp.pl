#!/usr/bin/perl

use RRDs;
my $img = '/var/www/html';

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

%database = (
hdc1000_humidity => "/var/lib/rrd/hdc1000_humidity.rrd",
hdc1000_tempC    => "/var/lib/rrd/hdc1000_tempC.rrd",
mpl311_press     => "/var/lib/rrd/mpl311_press.rrd",
mpl311_tempC     => "/var/lib/rrd/mpl311_tempC.rrd",
opt3001_lux      => "/var/lib/rrd/opt3001_lux.rrd",
veml6075_uva     => "/var/lib/rrd/veml6075_uva.rrd",
veml6075_uvb     => "/var/lib/rrd/veml6075_uvb.rrd",
);


sub update
{
 my($name,$value) = @_;
print ">update $database{$name}:$name = $value
" if(@ARGV);
 RRDs::update $database{$name}, '-t', $name, "N:" . $value;
}

&update("hdc1000_humidity", "$hdc1000_humidity") if($hdc1000_humidity);
&update("hdc1000_tempC", "$hdc1000_tempC") if($hdc1000_tempC);
&update("mpl311_press", "$mpl311_press") if($mpl311_press);
&update("mpl311_tempC", "$mpl311_tempC") if($mpl311_tempC);
&update("opt3001_lux", "$opt3001_lux") if($opt3001_lux);
&update("veml6075_uva", "$veml6075_uva") if($veml6075_uva);
&update("veml6075_uvb", "$veml6075_uvb") if($veml6075_uvb);


        foreach(qw/day week month year/)
        {
                RRDs::graph "$img/$_" . "temp.png",
                        "--lazy",
                        "-s -1$_",
                        "-h", "320", "-w", "640",
                        "-a", "PNG",
			"-r", "-u", "40",

"DEF:hdc1000_tempC=$database{hdc1000_tempC}:hdc1000_tempC:AVERAGE",
"DEF:mpl311_tempC=$database{mpl311_tempC}:mpl311_tempC:AVERAGE",
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

"DEF:hdc1000_humidity=$database{hdc1000_humidity}:hdc1000_humidity:AVERAGE",
"LINE2:hdc1000_humidity#00BFFF:humidity" . "\\n";


                RRDs::graph "$img/$_" . "press.png",
                        "--lazy",
                        "-s -1$_",
                        "-h", "320", "-w", "640",
                        "-a", "PNG",
			"-r", "-u", "1032",

"DEF:mpl311_press=$database{mpl311_press}:mpl311_press:AVERAGE",
"LINE1:mpl311_press#7B68EE:press",
"LINE2:1030#CC0000:1030", 
"LINE2:1013.25#CCCCCC:1013.25", 
"LINE2:990#0000CC:990" . "\\n";


                RRDs::graph "$img/$_" . "lux.png",
                        "--lazy",
                        "-s -1$_",
                        "-h", "320", "-w", "640",
                        "-a", "PNG",

"DEF:opt3001_lux=$database{opt3001_lux}:opt3001_lux:AVERAGE",
"LINE2:opt3001_lux#FFD700:lux" . "\\n";



                RRDs::graph "$img/$_" . "uv.png",
                        "--lazy",
                        "-s -1$_",
                        "-h", "320", "-w", "640",
                        "-a", "PNG",

"DEF:veml6075_uva=$database{veml6075_uva}:veml6075_uva:AVERAGE",
"DEF:veml6075_uvb=$database{veml6075_uvb}:veml6075_uvb:AVERAGE",
"LINE2:veml6075_uva#EE42EE:uva",
"LINE2:veml6075_uvb#9932CC:uvb"  . "\\n";


                if ($ERROR = RRDs::error) { print "$0: unable to generate $img/$_ graph: $ERROR\n"; }
        }



