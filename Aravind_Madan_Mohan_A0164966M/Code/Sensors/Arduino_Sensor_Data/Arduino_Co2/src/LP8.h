#ifndef LP8_h
#define LP8_h

//#include <Arduino.h>
#include "application.h"
#include "LP8_MODBUS.h"

/* #ifdef LP8_DEBUG
#define LP8_DEBUG_PREFIX "LP8: "
#define D(x) {Serial.print(F(LP8_DEBUG_PREFIX));\
  Serial.println(x);Serial.flush();}
#define D2(x,y) {Serial.print(F(LP8_DEBUG_PREFIX));Serial.print(x);\
  Serial.println(y);Serial.flush();}
#define D3(x,y,z) {Serial.print(F(LP8_DEBUG_PREFIX));Serial.print(x);\
  Serial.print(y);Serial.println(z);Serial.flush();}
#define D4(w,x,y,z) {Serial.print(F(LP8_DEBUG_PREFIX));Serial.print(w);\
  Serial.print(x);Serial.print(y);Serial.println(z);Serial.flush();}
#define D5(w,x,y,z,z1) {Serial.print(F(LP8_DEBUG_PREFIX));Serial.print(w);\
  Serial.print(x);Serial.print(y);Serial.print(z);Serial.println(z1);\
  Serial.flush();}
#define D6(w,x,y,z,z1,z2) {Serial.print(F(LP8_DEBUG_PREFIX));Serial.print(w);\
  Serial.print(x);Serial.print(y);Serial.print(z);Serial.println(z1);\
  Serial.println(z2);Serial.flush();}
#define D7(w,x,y,z,z1,z2,z3) {Serial.print(F(LP8_DEBUG_PREFIX));\
  Serial.print(w);Serial.print(x);Serial.print(y);Serial.print(z);\
  Serial.print(z1);Serial.print(z2);Serial.println(z3);Serial.flush();}
#define DSH(s,h) {Serial.print(F(LP8_DEBUG_PREFIX));Serial.print(s);\
  Serial.println(h,HEX);Serial.flush();}
#define DSB(s,h) {Serial.print(F(LP8_DEBUG_PREFIX));Serial.print(s);\
  Serial.println(h,BIN);Serial.flush();}
#define DSNSH(s,n,s1,h) {Serial.print(F(LP8_DEBUG_PREFIX));Serial.print(s);\
  Serial.print(n);Serial.print(s1);Serial.println(h,HEX);Serial.flush();}
#define DSHSH(s,n,s1,h) {Serial.print(F(LP8_DEBUG_PREFIX));Serial.print(s);\
  Serial.print(n,HEX);Serial.print(s1);Serial.println(h,HEX);Serial.flush();}
#else
#define D(x)
#define D2(x,y)
#define D3(x,y,z)
#define D4(w,x,y,z)
#define D5(w,x,y,z,z1)
#define D6(w,x,y,z,z1,z2)
#define D7(w,x,y,z,z1,z2,z3)
#define DSH(s,h)
#define DSB(s,h)
#define DSNSH(s,n,s1,h)
#define DSHSH(s,n,s1,h)
#endif
 */
#define bytes2uint(hi,lo) (unsigned int)(256 * hi + lo)
#define bytes2int(hi,lo) (int)(256 * hi + lo)
#define arraysize(a) (unsigned int)(sizeof(a)/sizeof(*a))

const long LP8_SERIAL_BAUDRATE = 9600;  // LP8 serial communication baudrate

// request delay
const unsigned long LP8_REQUEST_DELAY_MS = 300;
// min. measurement period
const unsigned long LP8_MIN_MEAS_PERIOD_MS = 16e3;
// amount of time for communication timeout
const unsigned long LP8_COMM_TIMEOUT_MS = 3e3;
// amount of time for RDY pin transition
const unsigned long LP8_RDY_TIMEOUT_MS = 200;

const int16_t LP8_DEFAULT_PRESSURE_DAPA = 10124; // default LP8 pressure
const int16_t LP8_NO_PRESSURE_DAPA = -9999; // value for no LP8 pressure

// this high pin number will never be used
const uint16_t LP8_RDY_PIN_UNUSED = 0xFFFF;

// templates to check if bit is set
// taken from https://stackoverflow.com/a/524032
template<class TYPE>
inline TYPE
BIT(const TYPE & x)
{
  return TYPE(1) << x;
}

template<class TYPE>
inline bool
IsBitSet(const TYPE & x, const TYPE & y)
{
  return 0 != (x & y);
}



// 
class LP8
{
  public:
    LP8(
      unsigned int vbb_pin,                      // power
      unsigned int rdy_pin = LP8_RDY_PIN_UNUSED  // ready
      );
    void begin(void);
    void power_down(void);
    void power_up(void);
    bool measure(
      int16_t pressure_daPa = LP8_NO_PRESSURE_DAPA,
      size_t max_retry = 4,
      size_t max_restart = 1
      );
    bool calibrate(
      LP8_MODBUS_CONTROL_BYTE calc_code,
      int16_t pressure_daPa = LP8_NO_PRESSURE_DAPA,
      size_t max_retry = 4,
      size_t max_restart = 1
      );
    bool ready_for_measurement(void);
    void wait_for_next_meas_cycle(void);
    bool error_diag(void);
    void restart(void);
    void reset(void);
    void reset_time(void);

    // specified as INT, NOT unsigned!
    int16_t co2_raw_ppm;
    int16_t co2_pres_ppm;
    int16_t co2_filt_ppm;
    int16_t co2_filt_pres_ppm;
    uint8_t error_status_0;
    uint8_t error_status_1;
    uint8_t error_status_2;
    uint8_t error_status_3;
    float  space_temp_celsius;
    uint16_t vcap_1_mV;
    uint16_t vcap_2_mV;
    int16_t host_pressure_daPa;
	
/* 	#ifdef PinState
	#define PinState 
	enum PinState { PinLow = LOW, PinHigh = HIGH };
	#endif */

  private:
    //SERIAL_TYPE * _serial;   // serial port reference
    unsigned int _vbb_pin; // power
    unsigned int _rdy_pin; // ready
    unsigned long _last_meas_time; // millis() of last measurement
    uint8_t _sensor_ram[LP8_RAM_SIZE] = {0}; // size of full RAM
    uint16_t _crc16;       // CRC
    bool _initialized;     // initialized state
    // methods
    void _begin_serial(void);
    void _end_serial(void);
    bool _measurement_without_state(
      LP8_MODBUS_CONTROL_BYTE calc_code, size_t max_retry);
    bool _measurement_with_state(
      LP8_MODBUS_CONTROL_BYTE calc_code, size_t max_retry);
    bool _measurement_with_state(
      LP8_MODBUS_CONTROL_BYTE calc_code, int16_t pressure_daPa, size_t max_retry);
    void _wait_for_ready(int state);
    bool _modbus_communicate(
      uint8_t modbus_device_address,
      uint8_t packet[],
      unsigned int n_packet,
      uint8_t response[],
      unsigned int n_response,
      size_t max_retry = 0
      );
    bool _read_full_sensor_ram(size_t max_retry);
    bool _read_RAM(
      LP8_RAM_ADDRESS lp8_ram_pointer_start_adr,
      uint8_t n_bytes,
      uint8_t response[],
      size_t max_retry
      );
    bool _write_RAM(
      LP8_RAM_ADDRESS lp8_ram_pointer_start_adr,
      uint8_t n_bytes,
      uint8_t response[],
      size_t max_retry
      );
    bool _extract_ram_information(void);
    void _discard_serial_input(void);
    void _crc16_init(void);
    void _crc16_update(uint8_t databyte);
    static uint16_t crc16_update(uint16_t crc, uint8_t data);
};

#endif
