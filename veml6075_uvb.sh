VEML6075_ADDR=0x10

i2cset -y 1 $VEML6075_ADDR 0x00 0x0010 w
uvb_raw=`i2cget -y 1 $VEML6075_ADDR 0x09 w`
uvcomp1=`i2cget -y 1 $VEML6075_ADDR 0x0A w`
uvcomp2=`i2cget -y 1 $VEML6075_ADDR 0x0B w`
uvb_raw=`printf '%d' $uvb_raw`
uvcomp1=`printf '%d' $uvcomp1`
uvcomp2=`printf '%d' $uvcomp2`
uvb_calc=`echo "scale=5; $uvb_raw - 2.95 * $uvcomp1 - 1.74 * $uvcomp2" | bc`
echo "$uvb_calc"



