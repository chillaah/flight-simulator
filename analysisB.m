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
flight6 = importdata('Flight4.csv');
flight9 = importdata('Flight4.csv');
flight11 = importdata('Flight4.csv');
flight13 = importdata('Flight4.csv');
flight17 = importdata('Flight4.csv');
flight25 = importdata('Flight4.csv');

f4 = flight4.data;
f6 = flight6.data;
f9 = flight9.data;
f11 = flight11.data;
f13 = flight13.data;
f17 = flight17.data;
f25 = flight25.data;



