
HDC1080_ADDR=0x40
VEML6075_ADDR=0x10
OPT3001_ADDR=0x44
MPL331_ADDR=0x60

### ----- MPL331
i2cset -y 1 $MPL331_ADDR 0x26 0x39
i2cset -y 1 $MPL331_ADDR 0x13 0x07
# TEMP
temp_raw=0x\
`i2cget -y 1 $MPL331_ADDR 0x04 b| cut -b 3-4`
temp_rawp=0x\
`i2cget -y 1 $MPL331_ADDR 0x05 b| cut -b 3`
temp_raw=`printf '%d' $temp_raw`
temp_rawp=`printf '%d' $temp_rawp`
echo "TEMP = $temp_raw.$temp_rawp"



# PRESS
press_raw=0x\
`i2cget -y 1 $MPL331_ADDR 0x01 b| cut -b 3-4`\
`i2cget -y 1 $MPL331_ADDR 0x02 b| cut -b 3-4`\
`i2cget -y 1 $MPL331_ADDR 0x03 b| cut -b 3`

press_raw=`printf '%d' $press_raw`
press_raw=`expr $press_raw / 4`
echo "PRES = $press_raw Pa "


### ----- OPT3001
i2cset -y 1 $OPT3001_ADDR 0x01 0xC610 w
result=`i2cget -y 1 $OPT3001_ADDR 0x00 w`
echo "ult $result lux_raw"
result=0x`echo $result|cut -b 5-6``echo $result|cut -b 3-4`
echo "ult $result lux_raw"
exponent=0x`echo $result|cut -b 3`
lux_raw=0x`echo $result|cut -b 5-6`\
`echo $result|cut -b 4`
lux_raw=`printf '%d' $lux_raw`
exponent=`printf '%d' $exponent`
lux=`echo "0.01 * (2 ^ $exponent ) * $lux_raw" | bc`
echo "LUX = $lux"

### ----- VEML6075
i2cset -y 1 $VEML6075_ADDR 0x00 0x0010 w
uva_raw=`i2cget -y 1 $VEML6075_ADDR 0x07 w`
uvb_raw=`i2cget -y 1 $VEML6075_ADDR 0x09 w`
uvcomp1=`i2cget -y 1 $VEML6075_ADDR 0x0A w`
uvcomp2=`i2cget -y 1 $VEML6075_ADDR 0x0B w`
uva_raw=`printf '%d' $uva_raw`
uvb_raw=`printf '%d' $uvb_raw`
uvcomp1=`printf '%d' $uvcomp1`
uvcomp2=`printf '%d' $uvcomp2`
uva_calc=`echo "scale=5; $uva_raw - 2.22 * $uvcomp1 - 1.33 * $uvcomp2" | bc`
uvb_calc=`echo "scale=5; $uvb_raw - 2.95 * $uvcomp1 - 1.74 * $uvcomp2" | bc`

echo "UVA = $uva_calc"
echo "UVB = $uvb_calc"



