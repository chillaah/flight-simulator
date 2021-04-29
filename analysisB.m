%% EGB243 Task B
close all; clear; clc

% Flight Simulator Data Fields
% ----------------------------
% 
% Col 1: Ground Speed (kts)
% Col 2: Altitude (feet)
% Col 3: Heading (deg - from North)
% Col 4: Latitude (deg)
% Col 5: Longitude (deg)
% 
% Each row denotes a specific timestamp or epoch. 
% 
% The timestamps are montonically increasing as you move down the rows. 
% 
% The time interval between each timestamp is 0.4 seconds.

% loading data
flight4 = importdata('Flight4.csv');
flight6 = importdata('Flight6.csv');
flight9 = importdata('Flight9.csv');
flight11 = importdata('Flight11.csv');
flight13 = importdata('Flight13.csv');
flight17 = importdata('Flight17.csv');
flight25 = importdata('Flight25.csv');

% flight data
f4 = flight4.data;
f6 = flight6.data;
f9 = flight9.data;
f11 = flight11.data;
f13 = flight13.data;
f17 = flight17.data;
f25 = flight25.data;

% ground speed data
groundSpeed = [  f4(:, 1);
                 f6(:, 1);
                 f9(:, 1);
                f11(:, 1);
                f13(:, 1);
                f17(:, 1);
                f25(:, 1) ];

% altitude data
flightAlt = [  f4(:, 2);
               f6(:, 2);
               f9(:, 2);
              f11(:, 2);
              f13(:, 2);
              f17(:, 2);
              f25(:, 2) ];
          
% heading angle data
heading = [  f4(:, 3);
             f6(:, 3);
             f9(:, 3);
            f11(:, 3);
            f13(:, 3);
            f17(:, 3);
            f25(:, 3) ];

% latitude data
flightLat = [  f4(:, 4);
               f6(:, 4);
               f9(:, 4);
              f11(:, 4);
              f13(:, 4);
              f17(:, 4);
              f25(:, 4) ];

% longitude data
flightLon = [  f4(:, 5);
               f6(:, 5);
               f9(:, 5);
              f11(:, 5);
              f13(:, 5);
              f17(:, 5);
              f25(:, 5) ];

% general data plots
figure(1);
t = linspace(0, 10, size(flightLat,1) + 1); t(end) = [];
plot(t, flightLat, 'r--', 'LineWidth', 1.5);
grid on
box on
title('Latitude Motion vs Time');
ylabel('degrees [deg]');
xlabel('t [seconds]');
labelprop = get(gca,'ylabel');
set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
set(gca,'FontSize',20);

figure(2);
plot(t, flightLon, 'b--', 'LineWidth', 1.5);
grid on
box on
title('Longitudinal Motion vs Time');
ylabel('degrees [deg]');
xlabel('t [seconds]');
labelprop = get(gca,'ylabel');
set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
set(gca,'FontSize',20);

figure(3);
plot(t, flightAlt, 'm--', 'LineWidth', 1.5);
grid on
box on
title('Altitude vs Time');
ylabel('feet [ft]');
xlabel('t [seconds]');
labelprop = get(gca,'ylabel');
set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
set(gca,'FontSize',20);

figure(4);
plot(t, groundSpeed, 'k--', 'LineWidth', 1.5);
grid on
box on
title('Ground Speed vs Time');
ylabel('knots [kts]');
xlabel('t [seconds]');
labelprop = get(gca,'ylabel');
set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
set(gca,'FontSize',20);

figure(5);
plot(t, heading, 'g--', 'LineWidth', 1.5);
grid on
box on
title('Heading Angle vs Time');
ylabel('degrees [deg]');
xlabel('t [seconds]');
labelprop = get(gca,'ylabel');
set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
set(gca,'FontSize',20);


