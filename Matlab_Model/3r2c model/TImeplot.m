% figure
% subplot(2,2,1)
% plot(S1AQI,'r.')
% ylabel('Air Quality Index')
% xlabel('Time (sec)')
% title('Air Quality Index Variation over a day Table 1')
% subplot(2,2,2)
% plot(S2AQI,'r.')
% ylabel('Air Quality Index')
% xlabel('Time (sec)')
% title('Air Quality Index Variation over a day Table 2')
% subplot(2,2,3)
% plot(S3AQI,'r.')
% ylabel('Air Quality Index')
% xlabel('Time (sec)')
% title('Air Quality Index Variation over a day Table 3')
% subplot(2,2,4)
% plot(S4AQI,'r.')
% ylabel('Air Quality Index')
% xlabel('Time (sec)')
% title('Air Quality Index Variation over a day Table 4')
% 
% 
% figure
% subplot(2,2,1)
% plot(S1CO,'*')
% hold on
% plot(S1HCHO,'*')
% hold on
% plot(S1O3,'*')
% hold on
% plot(S1PM10,'*')
% hold on
% plot(S1PM25,'*')
% xlabel('Time (sec)')
% ylabel('Concentration of gas(ppm)')
% title('Concentration of Gases in FEC2 at Table 1')
% legend('CO','HCHO','O3','PM 10','PM 2.5')
% subplot(2,2,2)
% plot(S2CO,'*')
% hold on
% plot(S2HCHO,'*')
% hold on
% plot(S2O3,'*')
% hold on
% plot(S2PM10,'*')
% hold on
% plot(S2PM25,'*')
% xlabel('Time (sec)')
% ylabel('Concentration of gas(ppm)')
% title('Concentration of Gases in FEC2 at Table 2')
% legend('CO','HCHO','O3','PM 10','PM 2.5')
% subplot(2,2,3)
% plot(S3CO,'*')
% hold on
% plot(S3HCHO,'*')
% hold on
% plot(S3O3,'*')
% hold on
% plot(S3PM10,'*')
% hold on
% plot(S3PM25,'*')
% xlabel('Time (sec)')
% ylabel('Concentration of gas(ppm)')
% title('Concentration of Gases in FEC2 at Table 3')
% legend('CO','HCHO','O3','PM 10','PM 2.5')
% subplot(2,2,4)
% plot(S4CO,'*')
% hold on
% plot(S4HCHO,'*')
% hold on
% plot(S4O3,'*')
% hold on
% plot(S4PM10,'*')
% hold on
% plot(S4PM25,'*')
% xlabel('Time (sec)')
% ylabel('Concentration of gas(ppm)')
% title('Concentration of Gases in FEC2 at Table 4')
% legend('CO','HCHO','O3','PM 10','PM 2.5')
% 
% figure
% subplot(2,2,1)
% plot(S1CO2,'r.')
% hold on
% plot(S1CO2_variation,'k*')
% xlabel('Time (sec)')
% ylabel('Concentration of CO2(ppm)')
% legend('Indoor CO2', 'Outdoor CO2')
% title('Indoor CO2 vs Outdoor CO2 for Room FEC2 at Table 1')
% subplot(2,2,2)
% plot(S2CO2,'r.')
% hold on
% plot(S2CO2_variation,'k*')
% xlabel('Time (sec)')
% ylabel('Concentration of CO2(ppm)')
% legend('Indoor CO2', 'Outdoor CO2')
% title('Indoor CO2 vs Outdoor CO2 for Room FEC2 at Table 2')
% subplot(2,2,3)
% plot(S3CO2,'r.')
% hold on
% plot(S3CO2_variation,'k*')
% xlabel('Time (sec)')
% ylabel('Concentration of CO2(ppm)')
% legend('Indoor CO2', 'Outdoor CO2')
% title('Indoor CO2 vs Outdoor CO2 for Room FEC2 at Table 3')
% subplot(2,2,4)
% plot(S4CO2,'r.')
% hold on
% plot(S4CO2_variation,'k*')
% xlabel('Time (sec)')
% ylabel('Concentration of CO2(ppm)')
% legend('Indoor CO2', 'Outdoor CO2')
% title('Indoor CO2 vs Outdoor CO2 for Room FEC2 at Table 4')
% 
% 
% figure
% plot(S1AQI,'r.')
% ylabel('Air Quality Index')
% xlabel('Time (sec)')
% title('Air Quality Index Variation over a day Table 1')
% 
% figure
% plot(S2CO,'*')
% hold on
% plot(S2HCHO,'*')
% hold on
% plot(S2O3,'*')
% hold on
% plot(S2PM10,'*')
% hold on
% plot(S2PM25,'*')
% xlabel('Time (sec)')
% ylabel('Concentration of gas(ppm)')
% title('Concentration of Gases in FEC2 at Table 1')
% legend('CO','HCHO','O3','PM 10','PM 2.5')
% 
% figure
% plot(S1CO2,'r.')
% hold on
% plot(S1CO2_variation,'k*')
% xlabel('Time (sec)')
% ylabel('Concentration of CO2(ppm)')
% legend('Indoor CO2', 'Outdoor CO2')
% title('Indoor CO2 vs Outdoor CO2 for Room FEC2 at Table 1')


figure
plot(STB-273,'*')
hold on
plot(STF-273,'*')
hold on
plot(STR-273,'*')
hold on
plot(STFl-273,'*')
hold on
plot(STL-273,'*')
hold on
plot(STRoof-273,'*')
hold on
plot(STRoom-273,'*')
legend('Outside Temp','Front Side Temp','Right Side Temp','Floor Temp','Left Side Temp','Roof Temp','Room Temp')
xlabel('Time (sec)')
ylabel('Temp. deg C')
title('Temperature influencing Room temperature vs Time')

figure
plot(SQhvac,'*')
hold on
plot(SQEquip,'*')
hold on
plot(SQHuman,'*')
hold on
plot(SQLight,'*')
legend('Q ACMV','Q Equipment','Q Human','Q Light')
xlabel('Time (sec)')
ylabel('Q (Watts)')
title('Variation of Quantity of Heat from Different Sources')

figure
PMV = getdatasamples(SPMV,[1:87000]);
PPD = getdatasamples(SPPD,[1:87000]);
plot(PMV,PPD,'r.')
xlabel('Predicted Mean Value')
ylabel('Percentage Dissatisfaction')
title('Variation of Predicted Mean Value for Room FEC2')

figure
plot(SPPD,'r.')
xlabel('Time (sec)')
ylabel('Percentage Dissatisfaction')
legend('Percentage Dissatisfaction')
title('Variation of Percentage of Dissatisfaction for Room FEC2')

figure
plot(SPMV,'r.')
xlabel('Time (sec)')
ylabel('Predicted Mean Value')
legend('Predicted Mean Value')
title('Variation of Predicted Mean Value for Room FEC2')

figure
plot(SEnergy,'r.')
xlabel('Time (sec)')
ylabel('Total Energy Utilised in KW/hr')
title('Total Energy Utilised in KW/hr for Room FEC2')


