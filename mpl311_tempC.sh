MPL331_ADDR=0x60

### ----- MPL331
i2cset -y 1 $MPL331_ADDR 0x26 0x39
i2cset -y 1 $MPL331_ADDR 0x13 0x07
temp_raw=0x\
`i2cget -y 1 $MPL331_ADDR 0x04 b| cut -b 3-4`
temp_rawp=0x\
`i2cget -y 1 $MPL331_ADDR 0x05 b| cut -b 3`
temp_raw=`printf '%d' $temp_raw`
temp_rawp=`printf '%d' $temp_rawp`
echo "$temp_raw.$temp_rawp"

