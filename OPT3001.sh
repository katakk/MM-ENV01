OPT3001_ADDR=0x44

### ----- OPT3001
i2cset -y 1 $OPT3001_ADDR 0x01 0x10C6 w
result=`i2cget -y 1 $OPT3001_ADDR 0x00 w`
result=0x`echo $result|cut -b 5-6``echo $result|cut -b 3-4`
exponent=0x`echo $result|cut -b 3`
exponent=`printf '%d' $exponent`
lux_raw=0x`echo $result|cut -b 4-6`
lux_raw=`printf '%d' $lux_raw`
lux=`echo "0.01 * (2 ^ $exponent ) * $lux_raw" | bc`
echo "LUX = $lux"




