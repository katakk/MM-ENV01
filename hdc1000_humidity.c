// https://qiita.com/satorukun/items/0d8457df566975195f97

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <wiringPi.h>
#include <wiringPiI2C.h>

#define HDC1000_ADDRESS             0x40
#define HDC1000_RDY_PIN             4

#define TEMPERATURE	0x00
#define HUMIDITY	0x01
#define CONFIG		0x02


void i2c_write(int fd, unsigned char addr, unsigned char msb, unsigned char lsb)
{
    int ret;
    unsigned char set_value[3];
    set_value[0] = addr;
    set_value[1] = msb;
    set_value[2] = lsb;
    ret = write(fd, set_value, 3);
    if (ret < 0) {
        perror("error: set configuration value\n");
        exit(1);
    } 
}

int i2c_read(int fd, unsigned char addr)
{
    int ret;
    unsigned char result[2];
    unsigned char get_value[1];
    get_value[0] = addr;
    ret = write(fd, get_value, 1);
    if (ret < 0) {
        perror("error: get value\n");
        exit(1);
    }

    // 変換待ち
    usleep(62500); // 0.0625
    // 値取得
    ret = read(fd, result, 2);
    if (ret < 0) {
        perror("error: read value\n");
        exit(1);
    }

    return (result[0] << 8 | result[1]);
   
}

int main(void) {

    int fd;
    int Data; 

    fd = wiringPiI2CSetup(HDC1000_ADDRESS);

    i2c_write(fd, CONFIG, 0x10, 0x00 );
    Data = i2c_read(fd, HUMIDITY);
    printf("%.2f\n", (Data / 65536.0 * 100));

    return 0;
}
