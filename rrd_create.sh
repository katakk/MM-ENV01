#!/bin/sh

rrdtool create /var/lib/rrd/hdc1000_humidity.rrd      -s 60  DS:hdc1000_humidity:GAUGE:240:U:U RRA:AVERAGE:0.5:1:1200 RRA:AVERAGE:0.5:6:1200 RRA:AVERAGE:0.5:24:1200 RRA:AVERAGE:0.5:144:1200
rrdtool create /var/lib/rrd/hdc1000_tempC.rrd         -s 60  DS:hdc1000_tempC:GAUGE:240:U:U RRA:AVERAGE:0.5:1:1200 RRA:AVERAGE:0.5:6:1200 RRA:AVERAGE:0.5:24:1200 RRA:AVERAGE:0.5:144:1200
rrdtool create /var/lib/rrd/mpl311_press.rrd          -s 60  DS:mpl311_press:GAUGE:240:U:U RRA:AVERAGE:0.5:1:1200 RRA:AVERAGE:0.5:6:1200 RRA:AVERAGE:0.5:24:1200 RRA:AVERAGE:0.5:144:1200
rrdtool create /var/lib/rrd/mpl311_tempC.rrd          -s 60  DS:mpl311_tempC:GAUGE:240:U:U RRA:AVERAGE:0.5:1:1200 RRA:AVERAGE:0.5:6:1200 RRA:AVERAGE:0.5:24:1200 RRA:AVERAGE:0.5:144:1200
rrdtool create /var/lib/rrd/opt3001_lux.rrd           -s 60  DS:opt3001_lux:GAUGE:240:U:U RRA:AVERAGE:0.5:1:1200 RRA:AVERAGE:0.5:6:1200 RRA:AVERAGE:0.5:24:1200 RRA:AVERAGE:0.5:144:1200
rrdtool create /var/lib/rrd/veml6075_uva.rrd          -s 60  DS:veml6075_uva:GAUGE:240:U:U RRA:AVERAGE:0.5:1:1200 RRA:AVERAGE:0.5:6:1200 RRA:AVERAGE:0.5:24:1200 RRA:AVERAGE:0.5:144:1200
rrdtool create /var/lib/rrd/veml6075_uvb.rrd          -s 60  DS:veml6075_uvb:GAUGE:240:U:U RRA:AVERAGE:0.5:1:1200 RRA:AVERAGE:0.5:6:1200 RRA:AVERAGE:0.5:24:1200 RRA:AVERAGE:0.5:144:1200


