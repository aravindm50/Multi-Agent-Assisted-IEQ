import numpy
import pandas as pd
from datetime import datetime
import time
from matplotlib import pyplot
timee = []


df1 = pd.read_csv('all_sensors_data.csv', sep = ',')


photon_co2 = []

photon_co2 = [df1['Value'][i]  for i  in range(len(df1['Value'])) if df1['Type'][i] == 'inhouse' and df1['Sensor'][i] == 'hcho_ppm']
p_time = [df1['UnixTime'][i]  for i  in range(len(df1['Value'])) if df1['Type'][i] == 'inhouse'and df1['Sensor'][i] == 'hcho_ppm']
p_t1 = [datetime.fromtimestamp(p_time[i]) for i in range(len(p_time))]
p_t = pd.to_datetime(p_t1)


aeroqual_co2 = [df1['Value'][i]  for i  in range(len(df1['Value'])) if df1['Type'][i] == 'aeroqual' and df1['Sensor'][i] == 'hcho_ppm']
a_time = [df1['UnixTime'][i]  for i  in range(len(df1['Value'])) if df1['Type'][i] == 'aeroqual' and df1['Sensor'][i] == 'hcho_ppm']
a_t1 = [datetime.fromtimestamp(a_time[i]) for i in range(len(a_time))]
a_t = pd.to_datetime(a_t1)
#a_t = [a_t[i] for i in range(2556,len(a_t))]
#aeroqual_co2= [aeroqual_co2[i] for i in range(2556,len(a_t))]

pyplot.plot(p_t,photon_co2,'k.',label='Inhouse HCHO sensor')
pyplot.plot(a_t,aeroqual_co2,'r+',label='Commericial HCHO sensor')
pyplot.legend(fontsize=12)
pyplot.title('Inhouse vs Commercial HCHO sensor readings',fontsize=20)
pyplot.xlabel('Time',fontsize=20)
pyplot.ylabel('HCHO (ppm)',fontsize=20)
pyplot.show()