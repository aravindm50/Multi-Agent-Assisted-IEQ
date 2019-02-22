//#include <Arduino.h>
#include "application.h"
//#include "LP8_MODBUS.h"
#include "LP8.h"

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

//
LP8::LP8(
      //SERIAL_TYPE * port,   // serial port reference
      unsigned int vbb_pin, // power
      unsigned int rdy_pin  // ready
      )
{
  //_serial = port;
  _vbb_pin = vbb_pin;
  _rdy_pin = rdy_pin;
  _initialized = false;
  reset_time();
  begin();
}


void LP8::begin(void)
{
  if(_rdy_pin != LP8_RDY_PIN_UNUSED) // if RDY pin was specified
  {
    pinMode(_rdy_pin, INPUT);  // rdy pin is input
  }
  pinMode(_vbb_pin, OUTPUT); // vbb pin is output
  reset(); // initial reset of cached sensor RAM
  power_down(); // initially power down the sensor
}

//template<class SERIAL_TYPE>
void LP8::_begin_serial(void)
{
  //D3("Beginning serial communication at ", LP8_SERIAL_BAUDRATE, " baud");
  //_serial->begin(LP8_SERIAL_BAUDRATE);
  //_discard_serial_input();   // discard any previous buffered input
  Serial1.begin(LP8_SERIAL_BAUDRATE);
}

//template<class SERIAL_TYPE>
void LP8::_end_serial(void)
{
  //D("Stopping serial communication with sensor");
  //_serial->end();
  Serial1.end();
}


void LP8::restart(void)
{
  //D("Restarting sensor");
  power_down();
  power_up();
}


void LP8::reset_time(void)
{
  //D("Resetting last measurement time");
  _last_meas_time = millis() - LP8_MIN_MEAS_PERIOD_MS;
}


void LP8::_discard_serial_input()
{
  if(Serial1.available())
  {
    //D3("WARNING: Discarding ",Serial1.available(),
    //  " bytes of previous input from the sensor...");
    //while(Serial1.available()) // discard any input
	while(Serial1.available()) // discard any input
    {
      #ifdef LP8_DEBUG
        uint8_t tmpbyte;
        tmpbyte = Serial1.read();
        //DSH("Discarding input byte ", tmpbyte);
      #else
        Serial1.read();
      #endif
      delay(10);
    }
  }
}

/* #ifdef PinState
#define PinState 
enum PinState { PinLow = LOW, PinHigh = HIGH };
#endif
 */
//void LP8::_wait_for_ready(PinState state)
void LP8::_wait_for_ready(int state)
{
  if(_rdy_pin == LP8_RDY_PIN_UNUSED)
  {
    //D2("The RDY pin was not specified. Waiting worst-case time [ms] ",       LP8_RDY_TIMEOUT_MS);
    delay(LP8_RDY_TIMEOUT_MS);
  }
  else
  {
    unsigned long time = millis();
    if (digitalRead(_rdy_pin) != state)
    {
      //D4("Waiting for RDY pin ",_rdy_pin," to go to state ", state);
      while(millis() - time < LP8_RDY_TIMEOUT_MS)
      {
        if (digitalRead(_rdy_pin) == state)
        {
          //D5("RDY pin ",_rdy_pin," is now at state ", state," --> sensor is ready!");
          return;
        };
      }
      //D7("WARNING: RDY pin ",_rdy_pin," didn't change to state ", state, " within ", LP8_RDY_TIMEOUT_MS, " ms. Continuing anyway...");
    }
    else
    {
      // D4("WARNING: RDY pin ",_rdy_pin," is already at state ", state);
    }
  }
}


void LP8::power_up(void)
{
  //D3("Setting VBB pin ",_vbb_pin," to HIGH to switch the sensor on");
  digitalWrite(_vbb_pin, HIGH);
  //D("Sensor is now powered up.");
  //_wait_for_ready(PinLow);
  _wait_for_ready(LOW);
}


void LP8::power_down(void)
{
  //D3("Setting VBB pin ",_vbb_pin," to LOW to switch the sensor off");
  digitalWrite(_vbb_pin, LOW);
  //D("Sensor is now powered down.");
}


void LP8::reset(void)
{
  //D("Resetting cached sensor RAM");
  for(unsigned int i = 0; i < LP8_RAM_SIZE; i++)
  {
    _sensor_ram[i] = 0;
  }
  _initialized = false;
  reset_time();
}

// read n_bytes from sensor RAM, starting at lp8_ram_pointer_start_adr and
// write them into response

bool LP8::_read_RAM(
  LP8_RAM_ADDRESS lp8_ram_pointer_start_adr,
  uint8_t n_bytes,
  uint8_t ram_content[],
  size_t max_retry
  )
{
  // set up the PDU (protocol data unit)
  uint8_t pdu[] = {
    (uint8_t) LP8_MODBUS_FUNC_CODE::READ, // READ from sensor RAM
    0x00, // adress high byte is always 0x00 because of small RAM,
    (uint8_t) lp8_ram_pointer_start_adr, // ram pointer start adress
    n_bytes // number of bytes to read
    };
  // 2 more bytes for responded function code and number of bytes
  uint8_t response_pdu[n_bytes + 2] = {0};
  bool success = _modbus_communicate(
    MODBUS_ADDRESS_ALL, // the sensor MODBUS device address
    pdu, // communicate this PDU via MODBUS
    arraysize(pdu), // the pdu has this size
    response_pdu, // write the full response pdu into this buffer
    arraysize(response_pdu), // the full reponse pdu has this size
    max_retry // max_retry
    );
  if(not success)
  {
    //D("Could not instruct sensor to output RAM");
    return success;
  }
  for (unsigned int i = 0; i < n_bytes; i++ )
  {
    ram_content[i] = response_pdu[i + 2];
  }
  if(response_pdu[0] != (uint8_t)LP8_MODBUS_FUNC_CODE::READ)
  {
    //DSHSH("WARNING: responded PDU contains function code ", response_pdu[0]," instead of ", (uint8_t)LP8_MODBUS_FUNC_CODE::READ);
    if(response_pdu[0] == (uint8_t)LP8_MODBUS_FUNC_CODE::ERROR_READ)
    {
      //DSH("WARNING: responded PDU contains READ ERROR code ",(uint8_t)LP8_MODBUS_FUNC_CODE::ERROR_READ);
      return false;
    }
  }
  if(response_pdu[1] != n_bytes)
  {
    //D4("WARNING: responded PDU tells to contain ", response_pdu[1], " bytes of RAM content, but should have been ", n_bytes);
    return false;
  }
  return true;
}

// write n_bytes of ram_content to sensor RAM, starting at
// lp8_ram_pointer_start_adr and write response into response

bool LP8::_write_RAM(
  LP8_RAM_ADDRESS lp8_ram_pointer_start_adr,
  uint8_t n_bytes,
  uint8_t ram_content[],
  size_t max_retry
  )
{
  // set up the PDU (protocol data unit)
  uint8_t pdu[4 + n_bytes] = {0};
  pdu[0] = (uint8_t) LP8_MODBUS_FUNC_CODE::WRITE; // READ from sensor RAM
  pdu[1] = 0x00; // adress high byte is always 0x00 because of small RAM,
  pdu[2] = (uint8_t) lp8_ram_pointer_start_adr; // ram pointer start adress
  pdu[3] = n_bytes; // number of bytes to write
  for (uint8_t i = 0; i < n_bytes; i++ )
  {
    pdu[i + 4] = ram_content[i];
  }
  // 2 more bytes for responded function code and number of bytes
  uint8_t response_pdu[1] = {0};
  bool success = _modbus_communicate(
    MODBUS_ADDRESS_ALL, // the sensor MODBUS device address
    pdu, // communicate this PDU via MODBUS
    arraysize(pdu), // the pdu has this size
    response_pdu, // write the full response pdu into this buffer
    arraysize(response_pdu), // the full reponse pdu has this size
    max_retry // max_retry
    );
  if(not success)
  {
    //D("Could not instruct sensor to write RAM");
    return success;
  }
  if(response_pdu[0] != (uint8_t)LP8_MODBUS_FUNC_CODE::WRITE)
  {
    //DSHSH("WARNING: responded PDU contains function code ", response_pdu[0],  " instead of ", (uint8_t)LP8_MODBUS_FUNC_CODE::WRITE);
    if(response_pdu[0] == (uint8_t)LP8_MODBUS_FUNC_CODE::ERROR_READ)
    {
      //DSH("WARNING: responded PDU contains WRITE ERROR code ",(uint8_t)LP8_MODBUS_FUNC_CODE::ERROR_WRITE);
      return false;
    }
  }
  return success;
}

// send a pdu to modbus_device_address and fill the response array with the
// responded pdu while performing the cyclic redundancy check

bool LP8::_modbus_communicate(
  uint8_t modbus_device_address, // MODBUS device address
  uint8_t pdu[], // protocol data unit (function code + function data)
  unsigned int n_pdu, // length of protocol data unit
  uint8_t response_pdu[], // response array reference
  unsigned int n_response_pdu, // length of response
  size_t max_retry // max_retry on failure
  )
{
  uint8_t adu[n_pdu + 3] = {0};
  uint8_t response_adu[n_response_pdu + 3] = {0};
  uint8_t attempts = 0;
  unsigned int i = 0;
  unsigned long time = 0;
  //D3("Attempting to communicate a ", arraysize(adu),"-byte ADU via MODBUS");
  _crc16_init();
  // begin with the modbus device address
  i = 0;
  adu[i++] = modbus_device_address;
  _crc16_update(adu[i - 1]); // update CRC16 checksum with last byte
  // append the PDU to the ADU
  for(unsigned int k = 0; k < n_pdu; k++)
  {
    adu[i++] = pdu[k];
    _crc16_update(adu[i - 1]); // update CRC16 checksum with last byte
  }
  // append CRC16 checksum
  //adu[i++] =  lowByte(_crc16);
  //adu[i++] = highByte(_crc16);
  adu[i++] =  _crc16;
  for(unsigned int k = 0; k < arraysize(adu); k++)
  {
    //DSNSH("ADU[",k,"] = ",adu[k]);
  }
  _begin_serial();
  top:
  _discard_serial_input();
  // keep sending request until we start to get a response_pdu
  do
  {
    attempts++;
    if(attempts > 1 + max_retry)
    {
      //D("Reached maximum number of sending attempts");
      _end_serial();
      return false;
    }
    //D4("Send attempt Nr. ", attempts,"/",1 + max_retry);
    delay(LP8_REQUEST_DELAY_MS);
    //D3("Sending ", arraysize(adu), " bytes of ADU to sensor...");
    time = millis();
    Serial1.write(adu, arraysize(adu));
    Serial1.flush();
    //D3("Waiting ",LP8_REQUEST_DELAY_MS, "ms to get consistent loading");
    delay(LP8_REQUEST_DELAY_MS);
  } while (not Serial1.available());
  i = 0;
  _crc16_init(); // reset the CRC
  while (i < arraysize(response_adu))
  {
    if((millis() - time) > LP8_COMM_TIMEOUT_MS)
    {
      //D3("WARNING: Timeout: Sensor communication took longer than ",LP8_COMM_TIMEOUT_MS, " ms.");
      goto top;
    }
    if(Serial1.available() > 0) // if we got response bytes waiting
    {
      response_adu[i++] = Serial1.read(); // read one byte
      //DSNSH("response ADU[",i - 1,"] = ",response_adu[i - 1]);
      if(i - 1 < 1 + n_response_pdu) // if we not yet reached the CRC checksum
      {
        _crc16_update(response_adu[i - 1]); // update CRC with last used byte
        if(i - 1 > 0) // we are in the reponse PDU region
        {
          response_pdu[i - 2] = response_adu[i - 1]; // copy PDU from ADU
        }
      }
    }
  };
  _end_serial();
  //D3("We received all ", arraysize(response_adu), " ADU bytes from the sensor.");
  //uint16_t response_adu_crc_lo = response_adu[arraysize(response_adu)-2];
  uint16_t response_adu_crc = response_adu[arraysize(response_adu)-1];
  //DSHSH("CRC16 high byte: responded = ", response_adu_crc_hi,", calculated = ", highByte(_crc16));
  //DSHSH("CRC16 low byte: responded = ", response_adu_crc_lo,", calculated = ", lowByte(_crc16));
  bool matches = (
    //response_adu_crc_lo ==  lowByte(_crc16) and
    //response_adu_crc_hi == highByte(_crc16)
	response_adu_crc == _crc16
    );
  if(matches)
  {
    //D("CRC16-checksum matches");
    //D("MODBUS communication was successful");
    return true;
  }
  else
  {
    //D("WARNING: CRC16-checksum DOES NOT match!!!");
    goto top;
  }
}


bool LP8::_read_full_sensor_ram(size_t max_retry)
{
  _wait_for_ready(HIGH);
  return _read_RAM(
    LP8_RAM_ADDRESS::CALC_CONTROL,
    LP8_RAM_SIZE, // LP8 ram size
    _sensor_ram, // write response into this array
    max_retry // max_retry
    );
}
//#endif

bool LP8::_extract_ram_information(void)
{
  vcap_1_mV = bytes2uint(
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::VCAP1_HI)],
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::VCAP1_LO)]
    );
  //D2("   capacitor voltage 1 [mV]: ", vcap_1_mV);
  vcap_2_mV = bytes2uint(
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::VCAP2_HI)],
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::VCAP2_LO)]
    );
  //D2("   capacitor voltage 2 [mV]: ", vcap_2_mV);
  host_pressure_daPa = bytes2int(
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::HOST_PRESSURE_HI)],
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::HOST_PRESSURE_LO)]
    );
  //D2("       host pressure [daPa]: ", host_pressure_daPa);
  space_temp_celsius = (float)(bytes2int(
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::SPACE_TEMP_HI)],
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::SPACE_TEMP_LO)]
    )) / 100.0;
  //D2(" space temperature [deg. C]: ", space_temp_celsius);
  co2_raw_ppm = bytes2int(
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::CO2_CONC_HI)],
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::CO2_CONC_LO)]
    );
  //D2("raw CO2 concentration [ppm]: ", co2_raw_ppm);
  co2_filt_ppm = bytes2int(
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::CO2_CONC_FILT_HI)],
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::CO2_CONC_FILT_LO)]
    );
  //D2("  filtered  CO2 conc. [ppm]: ", co2_filt_ppm);
  co2_pres_ppm = bytes2int(
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::CO2_CONC_PRES_HI)],
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::CO2_CONC_PRES_LO)]
    );
  //D2("pres.-corr. CO2 conc. [ppm]: ", co2_pres_ppm);
  co2_filt_pres_ppm = bytes2int(
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::CO2_CONC_FILT_PRES_HI)],
    _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::CO2_CONC_FILT_PRES_LO)]
    );
  //D2("pres.-corr.+filt. CO2 [ppm]: ", co2_filt_pres_ppm);
  error_status_0 = _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::ERROR0)];
  error_status_1 = _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::ERROR1)];
  error_status_2 = _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::ERROR2)];
  error_status_3 = _sensor_ram[LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::ERROR3)];
  /* if(error_status_0)
    DSB("             error status 0: ", error_status_0);
  if(error_status_1)
    DSB("             error status 1: ", error_status_1);
  if(error_status_2)
    DSB("             error status 2: ", error_status_2);
  if(error_status_3)
    DSB("             error status 3: ", error_status_3); */
  return(error_diag());
}


bool LP8::error_diag(void)
{
  bool noerror = true;
  if(IsBitSet(error_status_0, BIT((uint8_t) LP8_ERROR0_BITS::FatalError)))
  {
    noerror = false;
    //D("WARNING: Fatal Error occured");
  }
  if(IsBitSet(error_status_0, BIT((uint8_t) LP8_ERROR0_BITS::AlgError)))
  {
    noerror = false;
    //D("WARNING: Algorithm Error occured");
  }
  if(IsBitSet(error_status_0, BIT((uint8_t)LP8_ERROR0_BITS::CalibrationError)))
  {
    noerror = false;
    //D("WARNING: Calibration Error occured (out of range error)");
  }
  if(IsBitSet(error_status_0, BIT((uint8_t) LP8_ERROR0_BITS::SelfDiag)))
  {
    noerror = false;
    //D("WARNING: Self Diag. Error occured (HW-error or corr. EEPROM params)");
  }
  if(IsBitSet(error_status_0, BIT((uint8_t) LP8_ERROR0_BITS::OutOfRange)))
  {
    noerror = false;
    //D("WARNING: Out Of Range (OOR) Error occured");
    if(error_status_2)
    {
     /*  //D("WARNING: OOR error during unfiltered concentration calculation")
      if(IsBitSet(error_status_2,
        BIT((uint8_t) LP8_ERROR2_BITS::UnfilteredPressureCorrectOOR)))
        //D("WARNING: host pressure is out of specification");
      if(IsBitSet(error_status_2,
        BIT((uint8_t) LP8_ERROR2_BITS::UnfilteredTableEntryOOR)))
        //D("WARNING: IR signal to CO2 conc. conversion does not find a match");
      if(IsBitSet(error_status_2,
        BIT((uint8_t) LP8_ERROR2_BITS::UnfilteredTempCompOOR)))
        //D("WARNING: Temperature effect on thermopile is out of specification");
      if(IsBitSet(error_status_2,
        BIT((uint8_t) LP8_ERROR2_BITS::UnfilteredIRSignalOOR)))
        //D("WARNING: raw IR signal from emitter is out of specification"); */
    }
    if(error_status_3)
    {
      /* //D("WARNING: OOR error during filtered concentration calculation")
      if(IsBitSet(error_status_3,
        BIT((uint8_t) LP8_ERROR3_BITS::FilteredPressureCorrectOOR)))
        //D("WARNING: host pressure is out of specification");
      if(IsBitSet(error_status_3,
        BIT((uint8_t) LP8_ERROR3_BITS::FilteredTableEntryOOR)))
        //D("WARNING: IR signal to CO2 concentration does not find a match");
      if(IsBitSet(error_status_3,
        BIT((uint8_t) LP8_ERROR3_BITS::FilteredTempCompOOR)))
        //D("WARNING: Temperature effect on thermopile is out of specification");
      if(IsBitSet(error_status_3,
        BIT((uint8_t) LP8_ERROR3_BITS::FilteredIRSignalOOR)))
        //D("WARNING: raw IR signal from emitter is out of specification"); */
    }
  }
  if(IsBitSet(error_status_0, BIT((uint8_t) LP8_ERROR0_BITS::Memory)))
  {
    noerror = false;
    //D("WARNING: Memory Error occured (virt. EEPROM/FLASH checksum error)");
  }
  if(IsBitSet(error_status_0, BIT((uint8_t) LP8_ERROR0_BITS::WarmUp)))
  {
    noerror = false;
    //D("WARNING: WarmUp-bit is set - should only happen @SenseAir");
  }

  if(IsBitSet(error_status_1, BIT((uint8_t) LP8_ERROR1_BITS::VCAP1low)))
  {
    noerror = false;
    //D("WARNING: VCAP voltage prior to lamp pulse is below 2.8V+-3%");
  }
  if(IsBitSet(error_status_1, BIT((uint8_t) LP8_ERROR1_BITS::VCAP2low)))
  {
    noerror = false;
    //D("WARNING: VCAP voltage at beginning of lamp pulse is below 2.7V+-3%");
  }
  if(IsBitSet(error_status_1, BIT((uint8_t) LP8_ERROR1_BITS::ADCError)))
  {
    noerror = false;
    //D("WARNING: Analog-Digital-converter out-of-range error has occurred");
  }
  if(IsBitSet(error_status_1,
    BIT((uint8_t)LP8_ERROR1_BITS::ParameterOverride0)))
  {
    noerror = false;
    //D("WARNING: Param. Override 0 bit is set - should only happen @SenseAir");
  }
  if(IsBitSet(error_status_1,
    BIT((uint8_t)LP8_ERROR1_BITS::ParameterOverride1)))
  {
    noerror = false;
    //D("WARNING: Param. Override 1 bit is set - should only happen @SenseAir");
  }
  if(IsBitSet(error_status_1,
    BIT((uint8_t)LP8_ERROR1_BITS::ParameterOverride2)))
  {
    noerror = false;
    //D("WARNING: Param. Override 2 bit is set - should only happen @SenseAir");
  }
  if(IsBitSet(error_status_1,
    BIT((uint8_t)LP8_ERROR1_BITS::ParameterOverride3)))
  {
    noerror = false;
    //D("WARNING: Param. Override 3 bit is set - should only happen @SenseAir");
  }
  return(noerror);
}



bool LP8::ready_for_measurement()
{
  return(millis() - _last_meas_time > LP8_MIN_MEAS_PERIOD_MS);
}



void LP8::wait_for_next_meas_cycle()
{
  if(_last_meas_time)
  {
    //D("Waiting until the sensor is ready for another measurement...");
    while(not ready_for_measurement())
    {
      delay(500);
    }
    //D("The sensor should now be ready for another measurement.");
  }
  else
  {
    //D("No need to wait, seems to be the first measurement.")
  }
}


bool LP8::calibrate(
  LP8_MODBUS_CONTROL_BYTE calc_code, int16_t pressure_daPa,
  size_t max_retry, size_t max_restart)
{
  bool success = false;
  size_t attempts = 0;
  wait_for_next_meas_cycle(); // wait long enough
  power_up(); // make sure sensor is on
  while(true)
  {
    attempts++;
    if(pressure_daPa == LP8_NO_PRESSURE_DAPA)
    {
      //D2("Telling sensor to perform calibration without pressure in mode ",(uint8_t) calc_code);
      success = _measurement_with_state(
        calc_code, // mode
        max_retry // max_retry
        );
    }
    else
    {
      ///DSNSH("Telling sensor to perform calibration with pressure ",pressure_daPa," daPa in mode ", (uint8_t) calc_code);
      
	  success = _measurement_with_state(
        calc_code, // mode
        pressure_daPa, // pressure
        max_retry // max_retry
        );
    }
    if(success)
    {
      break;
    }
    else
    {
      //D("Telling sensor to perform calibration didn't work.");
      if(attempts > max_restart)
      {
        //D("Reached maximum number of restart attempts");
        break;
      }
      else
      {
        //D4("Restart ", attempts, "/", max_restart);
        restart();
      }
    }
  }
  if(not success)
  {
    //D("Could not instruct the sensor to perform calibration");
    power_down();
    return success;
  }
  //D("Reading full sensor RAM");
  success = _read_full_sensor_ram(max_retry);
  power_down();
  if(not success)
  {
    //D("Could not read full sensor RAM");
    return success;
  }
  //D("Extracting information from sensor RAM");
  success = _extract_ram_information();
  if(not success)
  {
    //D("The sensor reported an error.");
  }
  return success;
}


bool LP8::measure(int16_t pressure_daPa,
  size_t max_retry, size_t max_restart)
{
  bool success = false;
  size_t attempts = 0;
  wait_for_next_meas_cycle(); // wait long enough
  power_up(); // make sure sensor is on
  while(true)
  {
    attempts++;
    if(_initialized)
    {
      if(pressure_daPa == LP8_NO_PRESSURE_DAPA)
      {
        //D("Telling sensor to do sequential measurement without pressure");
        success = _measurement_with_state(
          LP8_MODBUS_CONTROL_BYTE::SEQUENTIAL_MEASUREMENT, // mode
          max_retry // max_retry
          );
      }
      else
      {
        //D3("Telling sensor to do sequential measurement with ",pressure_daPa, " daPa");
        success = _measurement_with_state(
          LP8_MODBUS_CONTROL_BYTE::SEQUENTIAL_MEASUREMENT, // mode
          pressure_daPa, // pressure
          max_retry // max_retry
          );
      }
    }
    else
    {
      if(pressure_daPa == LP8_NO_PRESSURE_DAPA)
      {
        //D("Telling sensor to do initial measurement without pressure");
        success = _measurement_without_state(
          LP8_MODBUS_CONTROL_BYTE::INITIAL_MEASUREMENT, // mode
          max_retry // max_retry
          );
      }
      else
      {
        //D3("Telling sensor to do initial measurement with pressure = ",pressure_daPa, " daPa");
        success = _measurement_with_state(
          LP8_MODBUS_CONTROL_BYTE::INITIAL_MEASUREMENT, // mode
          pressure_daPa, // pressure
          max_retry // max_retry
          );
      }
    }
    if(success)
    {
      break;
    }
    else
    {
      //D("Telling sensor to do measurment didn't work.");
      if(attempts > max_restart)
      {
        //D("Reached maximum number of restart attempts");
        break;
      }
      else
      {
        //D4("Restart ", attempts, "/", max_restart);
        restart();
      }
    }
  }
  if(not success)
  {
    //D("Could not instruct the sensor to perform measurement");
    power_down();
    return success;
  }
  //D("Reading full sensor RAM");
  success = _read_full_sensor_ram(max_retry);
  power_down();
  if(not success)
  {
    //D("Could not read full sensor RAM");
    return success;
  }
  else
  {
    //D("Extracting information from sensor RAM");
    success = _extract_ram_information();
    if(not success)
    {
     // D("The sensor reported an error");
    }
  }
  return success;
}


bool LP8::_measurement_without_state(
  LP8_MODBUS_CONTROL_BYTE calc_code, size_t max_retry
  )
{
  uint8_t ram_content[] = { (uint8_t) calc_code };
  wait_for_next_meas_cycle();
  bool success = _write_RAM(
    LP8_RAM_ADDRESS::CALC_CONTROL, // address
    arraysize(ram_content), // write one byte
    ram_content, // ram content array
    max_retry // max_retry
    );
  if (success)
  {
    // record the time of time measurement
    _last_meas_time = millis();
    // sensor was now initialized
    _initialized = true;
  }
  return success;
}


bool LP8::_measurement_with_state(
  LP8_MODBUS_CONTROL_BYTE calc_code, size_t max_retry)
{
  uint8_t ram_content[1 + 23];
  unsigned int i = 0;
  // begin with sequential measurement control byte
  ram_content[i++] = (uint8_t) calc_code;
  // copy over old sensor state
  for (unsigned int k = 0; k < 23; k++)
  {
    ram_content[i++] = _sensor_ram[
      LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::SENSOR_STATE_1) + k
      ];
  }
  wait_for_next_meas_cycle();
  bool success = _write_RAM(
    LP8_RAM_ADDRESS::CALC_CONTROL, // write from calc control byte
    arraysize(ram_content), // write this many bytes
    ram_content, // save response into this array
    max_retry // max_retry
    );
  if(success)
  {
    // record the time of time measurement
    _last_meas_time = millis();
    // sensor was now initialized
    _initialized = true;
  }
  return success;
}


bool LP8::_measurement_with_state(
  LP8_MODBUS_CONTROL_BYTE calc_code, int16_t pressure_daPa, size_t max_retry)
{
  uint8_t ram_content[1 + 23 + 2];
  unsigned int i = 0;
  // begin with sequential measurement control byte
  ram_content[i++] = (uint8_t) calc_code;
  // copy over old sensor state
  for (unsigned int k = 0; k < 23; k++)
  {
    ram_content[i++] = _sensor_ram[
      LP8_REL_RAM_ADDRESS(LP8_RAM_ADDRESS::SENSOR_STATE_1) + k
      ];
  }
  // append pressure
  //ram_content[i++] = highByte(pressure_daPa);
  //ram_content[i++] =  lowByte(pressure_daPa);
  ram_content[i++] =  pressure_daPa;
  wait_for_next_meas_cycle();
  bool success = _write_RAM(
    LP8_RAM_ADDRESS::CALC_CONTROL, // write from calc control byte
    arraysize(ram_content), // write this many bytes
    ram_content, // save response into this array
    max_retry // max_retry
    );
  if(success)
  {
    // record the time of time measurement
    _last_meas_time = millis();
    // sensor was now initialized
    _initialized = true;
  }
  return success;
}


void LP8::_crc16_init(void)
{
  _crc16 = CRC16_MB_INIT;
}


void LP8::_crc16_update(uint8_t databyte)
{
  _crc16 = crc16_update(_crc16, databyte); // update the current internal CRC
}

// This CRC16 implementation operates in the reverse direction for easier
// implementation.

uint16_t LP8::crc16_update(uint16_t crc, uint8_t data)
{
  crc ^= (uint16_t)data; // XOR the data byte into the least sig. byte of the crc
  for ( int i = 0; i < 8; i++ ) // loop over all shifts of the data byte
  {
    if(crc & 1) // if the LSB is set, we are aligned
    {
      crc >>= 1; // shift one bit to the right
      crc ^= CRC16_MB_POLYNOM; // perform polynomial division via XOR
    }
    else
      crc >>= 1; // only shift one bit to the right
  }
  return crc;
}