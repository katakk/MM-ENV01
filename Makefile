
all:
	$(CC) -lwiringPi hdc1000_humidity.c -o hdc1000_humidity
	$(CC) -lwiringPi hdc1000_tempC.c -o hdc1000_tempC

clean:
	$(RM) hdc1000_humidity hdc1000_tempC
