import numpy
import pandas as pd
from datetime import datetime
import time
from matplotlib import pyplot
timee = []


df = pd.read_csv('Aeroqual_CO2_timestamp.csv', sep = ',')
df1 = pd.read_csv('Photon_CO2_S8.csv', sep = ',')


aeroqual_co2 = df[' CO2(ppm)']
photon_co2 = []

photon_co2 = [df1['CO2'][i]  for i  in range(len(df1['CO2'])) if df1['CO2'][i] != 0 ]
p_time = [df1['Timestamp'][i]  for i  in range(len(df1['CO2'])) if df1['CO2'][i] != 0 ]
a_time = df['Date Time']
a_t = pd.to_datetime(df['Date Time'])
p_t1 = [datetime.fromtimestamp(p_time[i]) for i in range(len(p_time))]
p_t = pd.to_datetime(p_t1)
p_t = [p_t[i] for i in range(31000,len(p_t))]
photon_co2 = [photon_co2[i] for i in range(31000,len(photon_co2))]
a_t = [a_t[i] for i in range(3261,len(a_t))]
aeroqual_co2 = [aeroqual_co2[i] for i in range(3261,len(aeroqual_co2))]

pyplot.plot(p_t,photon_co2,'k.',label='Inhouse Sensor Array\'s CO2 sensor')
pyplot.plot(a_t,aeroqual_co2,'r+',label='Commerical CO2 sensor')
pyplot.legend(fontsize = 12)
pyplot.title('Inhouse vs Commercial CO2 sensor readings',fontsize = 20)
pyplot.xlabel('Time',fontsize = 20)
pyplot.ylabel('CO2 (ppm)',fontsize = 20)
pyplot.show()