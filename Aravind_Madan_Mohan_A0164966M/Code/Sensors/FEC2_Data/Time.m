close all
clear all
clc
data = readtable('E11_timestamp.csv');
x = datetime(data{:,7}, 'InputFormat', 'dd/MM/yyyy HH:mm');
%y = str2double(strrep(data{:,4}, ',','.'));
rh = data{:,4};
plot(x, rh,'.r')
title('Relative Humidity vs Time')
xlabel('Time')
ylabel('% Relative Humidity')
legend('Relative Humidity')

%% 

figure
ot = data{:,5};
it = data{:,6};
plot(x, ot,'.r')
hold on 
plot(x, it,'.b')
title('Temperature vs Time in FEC2 room')
xlabel('Time')
ylabel('% Temperature deg. C')
legend('Outside Temperature','Inside Temperature')