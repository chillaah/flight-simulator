%% EGB243 Task B
close all; clear; clc

% Flight Simulator Data Fields
% ----------------------------
% 
% Col 1: Ground Speed (kts)
% Col 2: Altitude (feet)
% COl 3: Heading (deg - from North)
% Col 4: Latitude (deg)
% Col 5: Longitude (deg)
% 
% Each row denotes a specific timestamp or epoch. 
% 
% The timestamps are montonically increasing as you move down the rows. 
% 
% The time interval between each timestamp is 0.4 seconds.

flight4 = importdata('Flight4.csv');
flight6 = importdata('Flight6.csv');
flight9 = importdata('Flight9.csv');
flight11 = importdata('Flight11.csv');
flight13 = importdata('Flight13.csv');
flight17 = importdata('Flight17.csv');
flight25 = importdata('Flight25.csv');

f4 = flight4.data;
f6 = flight6.data;
f9 = flight9.data;
f11 = flight11.data;
f13 = flight13.data;
f17 = flight17.data;
f25 = flight25.data;

flightAlt = [  f4(:, 1);
               f6(:, 1);
               f9(:, 1);
              f11(:, 1);
              f13(:, 1);
              f17(:, 1);
              f25(:, 1) ];

flightLat = [  f4(:, 4);
               f6(:, 4);
               f9(:, 4);
              f11(:, 4);
              f13(:, 4);
              f17(:, 4);
              f25(:, 4) ];
          
flightLon = [  f4(:, 5);
               f6(:, 5);
               f9(:, 5);
              f11(:, 5);
              f13(:, 5);
              f17(:, 5);
              f25(:, 5) ];

figure();
grid on
box on
t = linspace(0, 10, size(flightLat,1) + 1); t(end) = [];
plot(t, flightLat, '--');
title('Latitude Motion vs Time');
ylabel('meters [m]');
xlabel('t [seconds]');
labelprop = get(gca,'ylabel');
set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
set(gca,'FontSize',20);
%  legend('Practical Data','Simulated Data','Max');


figure();
plot(t, flightLon, '--');
grid on
box on



