HDC1080_ADDR=0x40

i2cset -y 1 $HDC1080_ADDR 0x02 0x10 w;
sleep 1 
i2cget -y 1 $HDC1080_ADDR 0x00 w
