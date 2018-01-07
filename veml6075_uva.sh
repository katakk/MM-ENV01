VEML6075_ADDR=0x10

i2cset -y 1 $VEML6075_ADDR 0x00 0x0010 w
uva_raw=`i2cget -y 1 $VEML6075_ADDR 0x07 w`
uvcomp1=`i2cget -y 1 $VEML6075_ADDR 0x0A w`
uvcomp2=`i2cget -y 1 $VEML6075_ADDR 0x0B w`
uva_raw=`printf '%d' $uva_raw`
uvcomp1=`printf '%d' $uvcomp1`
uvcomp2=`printf '%d' $uvcomp2`
uva_calc=`echo "scale=5; $uva_raw - 2.22 * $uvcomp1 - 1.33 * $uvcomp2" | bc`
echo "$uva_calc"



