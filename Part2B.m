%% Setup for Simulation
%close all;
clear all;
clc;

%% Parameters for plane 1
t0 = 0;
tf = 50;
dt = 1;
t = t0:dt:tf;

x0 = 0;
y0 = 0;
z0 = 0;

% Second set of yaw and pitch angles
psi1 = deg2rad(45);
psi2 = deg2rad(20);
gamma1 = deg2rad(30);
gamma2 = deg2rad(90);

v1 = 10;
v2 = 13;

%% Simulation

% Returns positions of the aircraft in both x and y co-ords 

v_vect = [v1 v1];

Alt_max = 330; % m
Drawing_radius = 330; %m
v_cruise = 33; % Cruising speed 33 m/s

t1 = floor(Alt_max/(v_cruise*sin(deg2rad(45))));
t2 = floor(t1 + Drawing_radius /2/v_cruise);
t3 = floor(t2 + 150/v_cruise);
t4 = floor(t3 + Drawing_radius /2/v_cruise);
t5 = floor(t4 + abs(Drawing_radius/4/(v_cruise*sin(deg2rad(225)))));
T_vect = [t1 t2 t3 t4 t5]; 
psi_vect = [deg2rad(45)...
            deg2rad(270)...
            deg2rad(0)...
            deg2rad(90)...
            deg2rad(225)...
            deg2rad(0)];
gamma_vect = [deg2rad(45) 0];
v_vect = [v_cruise];

[xc, yc, zc] = motion_simulation_flightPath(t, dt, x0, y0, z0, T_vect, psi_vect, gamma_vect, v_vect);

% Reference x,y,z coordinates for Brisbane
% 27.4705° S, 153.0260° E, 500m of elevation
% or (Lat, Long) = (-27.4705°, +153.0260)
lat_sp = deg2km(-27.4705)*1000;% * 111*1000; % Degree lat to km
long_sp = deg2km(153.0260)*1000; % * 111*1000; % Degree lat to km

% We are flying East
% Xc is the direction of East to West
% Yc is the directiopn of North - South
xc = xc + long_sp;
yc = yc + lat_sp;
zc = zc + 500;

% Convert km back to deg lat, long
xc_long = km2deg(xc./1000);
yc_lat = km2deg(yc./1000);
zc_alt = zc;

%% graph 
figure (1)
clf;
for idx = 1:1:tf
    plot3(xc_long(idx), yc_lat(idx), zc_alt(idx), 'ko');
    grid on
    hold on
end

%axis('equal');
xlabel('X Position (deg lat)');
ylabel('Y Position (deg long)');
zlabel('Altitude (m)'); % reference Z from sea level

figure(2)
geoplot(yc_lat, xc_long,'g-*')


