#!/usr/bin/perl

use RRDs;

%database = (
hdc1000_humidity => "/var/lib/rrd/hdc1000_humidity.rrd",
hdc1000_tempC    => "/var/lib/rrd/hdc1000_tempC.rrd",
mpl311_press     => "/var/lib/rrd/mpl311_press.rrd",
mpl311_tempC     => "/var/lib/rrd/mpl311_tempC.rrd",
opt3001_lux      => "/var/lib/rrd/opt3001_lux.rrd",
veml6075_uva     => "/var/lib/rrd/veml6075_uva.rrd",
veml6075_uvb     => "/var/lib/rrd/veml6075_uvb.rrd",
);

foreach(keys %database)
{
	system(qq{rrdtool dump $database{$_} | grep "`date +%Y-%m-%d`\ `date +%H`" | sort});
}


