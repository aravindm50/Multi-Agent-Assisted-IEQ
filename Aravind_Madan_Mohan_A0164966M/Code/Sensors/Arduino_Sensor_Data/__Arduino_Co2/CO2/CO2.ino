#include <SoftwareSerial.h>
#include <LP8.h>

#define LP8_RX_PIN     13 // LP8 RX pin to Arduino pin 13
#define LP8_TX_PIN     12 // LP8 TX pin to Arduino pin 12
#define LP8_RDY_PIN     2 // LP8 RDY pin to Arduino pin  2
#define LP8_EN_VBB_PIN  3 // LP8 EN_VBB pin to Arduino pin  3

// Setup a virtual serial port
SoftwareSerial co2sensor_serial(
  LP8_TX_PIN, // Arduino RX is LP8 TX
  LP8_RX_PIN  // Arduino TX is LP8 RX
);

// Setup an instance of the LP8 class
/* You may as well leave the RDY pin out, the library does not rely
  implicitly on the RDY pin communication.*/
LP8<SoftwareSerial> co2sensor(&co2sensor_serial, LP8_EN_VBB_PIN, LP8_RDY_PIN );

void setup()
{
  Serial.begin(9600); // Initialize Serial Monitor communication
  co2sensor.begin(); // Initialize sensor communication
  /* See LP8_MODBUS.h for more calibration modes with explanations */
  co2sensor.calibrate( LP8_MODBUS_CONTROL_BYTE::BACK_CALIB_NOISY_NONFILTERED_RESET );
}

void loop()
{
  co2sensor.measure();
  summary();
}

void summary()
{
  //  Serial.print("      sensor temperature [deg. C] ");
  //    Serial.println(co2sensor.space_temp_celsius);
  //  Serial.print("                  noisy CO2 [ppm] ");
  //    Serial.println(co2sensor.co2_raw_ppm);
  //  Serial.print("     pressure-corrected CO2 [ppm] ");
  Serial.println(co2sensor.co2_pres_ppm + 300);
  /* 300 is added for 400ppm offset */
  //  Serial.print("         noise-filtered CO2 [ppm] ");
  //    Serial.println(co2sensor.co2_filt_ppm);
  //  Serial.print("noise-filt.+pres.-corr. CO2 [ppm] ");
  //    Serial.println(co2sensor.co2_filt_pres_ppm);
}
