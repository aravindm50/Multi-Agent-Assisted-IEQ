import serial
import time
import csv
 
ser = serial.Serial('COM12')
ser.flushInput()
max_readings = 100000
readings = 1
 
while True:
        ser_bytes = ser.readline()
        decoded_bytes = float(ser_bytes[0:len(ser_bytes)-2].decode("utf-8"))
        print(decoded_bytes)
        with open("arduino_hcho.csv","a", newline='') as csvfile:
            writer = csv.writer(csvfile,delimiter=",")
            writer.writerow([int(time.time()),decoded_bytes])
        if readings >= max_readings :
            break
        else:
            readings = readings +1
        
