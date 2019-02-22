import pandas as pd
import matplotlib.pyplot as plt
import time
from datetime import datetime

while (True):
    d = pd.read_csv("arduino_co2.csv")
    d  = pd.DataFrame(d)
    datax = d[d.columns[0]]
    datay = d[d.columns[1]]
    plt.plot(datax,datay)
    plt.axis([1529919394, 1530106307,0,1000])
    plt.show()
    time.sleep(60)
