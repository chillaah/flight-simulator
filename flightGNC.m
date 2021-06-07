%% EGB243 Task B Part 3 - Flight Guidance, Navigation & Control Software

% given a nominal aircraft departure (start) time and cruise speed (consistent with general
% aviation aircraft), augment your software to calculate expected arrival times and indicate
% 10-minute markers (locations) along the track.
close all; clear; clc
format bank

 % start time [hrs]
start = 1200;

% the typical cruising airspeed for a long-distance commercial passenger 
% Cessna 172 is 226-260 [km/hrs]
cruiseSpeed = 250; % (226 + 260)/2;
cSknts = cruiseSpeed / 1.852; % [knots]

% path distance [km]
% please enter:
% north as +ve, south as -ve
% east as +ve, west as -ve
latlonBris = [ -27.4705, 153.0260 ];
latlonHervey = [ -25.2882, 152.7677 ];
lat1 = latlonBris(1); 
lon1 = latlonBris(2);
lat2 = latlonHervey(1);
lon2 = latlonHervey(2);
% bearing = azimuth(lat1,lon1,lat2,lon2);
[distance, bearing] = latlon2dist(latlonBris, latlonHervey);
nmDist = km2nm(distance); % nautical miles

% time to fly [hrs]
time = distance / cruiseSpeed;

% earth's mean radius [km]
radius = 6371;

% arrival time [hrs]
hour = fix(time);
mins = (time - hour) * 60;
secs = (mins - fix(mins))/100 * 60;
arrival = start + (hour*100) + fix(mins) + secs;

% display
disp('En route from Brisbane to Hervey Bay ');
disp('-------------------------------------');
fprintf('Start Time : %d Hours \n', start);
fprintf('Cruise Speed : %d Knots \n', cSknts);
fprintf('Distance : %d Nautical Miles \n', fix(nmDist));
fprintf('Arrival Time : %.2d Hours \n\n', round(arrival));

% 10-minute markers
n10m = hour * 6 + fix(mins/10);
wp = zeros(n10m,5);
hCheck = 60;

j = start;
range = distance;
brng = bearing;

latNew = lat1;
lonNew = lon1;
latGap = latlonHervey(1) - latlonBris(1);
lonGap = latlonHervey(2) - latlonBris(2);

d = nmDist;
alpha = abs(wrapTo180(bearing));

for i = 1:n10m+1
    
    wp(i,1) = j;
    wp(i,2) = range;
    wp(i,3) = brng;
    wp(i,4) = latNew;
    wp(i,5) = lonNew;
    
    if j - fix(j/100) * 100 >= 50
        j = j + 50;
    else
        j = j + 10;
    end
    
    range = range - 10/60 * cruiseSpeed;
    
    latNew = lat1 + (i * 10)/(time * 60) * km2deg(wp(1,2)) * cosd(alpha);
    
    lonNew = lon1 - (i * 10)/(time * 60) * km2deg(wp(1,2)) * sind(alpha);
      
    if fix(j/100) == 24
        j = 0000.00;
    end

end

diff = time * 60 - n10m * 10;
wp(end+1,:) = [ wp(end,1) + diff, 0, brng, lat1 + km2deg(wp(1,2)) * cosd(alpha),...
                lon1 - km2deg(wp(1,2)) * sind(alpha) ]; 
markers10min = wp(2:end-1,:);

Min10Markers = markers10min(:,1);
Range = markers10min(:,2);
Bearing = markers10min(:,3);
Latitude = markers10min(:,4);
Longitude = markers10min(:,5);
T = table(Min10Markers, Range, Bearing, Latitude, Longitude);
disp(T);
% fprintf('the last & first data points aren''t 10-minute markers! \n\n');

% disp(markers10min);
% fprintf('these are the 10-minute markers! \n\n');

figure(1);
geoplot(wp(:,4),wp(:,5), 'LineWidth', 2);
hold on
geoplot(markers10min(:,4),markers10min(:,5), 'go', 'LineWidth', 2);
geoplot(wp(1,4),wp(1,5),'ro', 'LineWidth', 3);
geoplot(wp(end,4),wp(end,5),'ko', 'LineWidth', 3);
title('En Route from Brisbane to Hervey Bay');
legend('Flight Path', '10 Minute Markers', 'Brisbane City', 'Hervey Bay');
geobasemap streets

% export kml to goole earth
filename = 'GEVideo';
latpoints = wp(:,4);
lonpoints  = wp(:,5);

% nominal altitude
altitude = 35000; % [feet]
nomAlt = distdim(altitude,'feet','m');
kmlwritepoint(filename, latpoints, lonpoints, nomAlt);

% constant notherly wind
% 20% of nominal speed
wind = 20/100 * nmDist; % [knots]

% from sine rule
A = asind(wind * sind(alpha)/d);
heading1 = alpha - A;

% constant southerly wind
heading2 = alpha + A;

% locations of aircraft at nominal arrival times for 20% notherly wind
nomArr1_lat = lat1 + km2deg(wp(1,2)) * cosd(heading1);
nomArr1_lon = lon1 - km2deg(wp(1,2)) * sind(heading1);
nomArrHalf1_lat = lat1 + 0.5 * km2deg(wp(1,2)) * cosd(heading1);
nomArrHalf1_lon = lon1 - 0.5 * km2deg(wp(1,2)) * sind(heading1);

% locations of aircraft at nominal arrival times for 20% southerly wind
nomArr2_lat = lat1 + km2deg(wp(1,2)) * cosd(heading2);
nomArr2_lon = lon1 - km2deg(wp(1,2)) * sind(heading2);
nomArrHalf2_lat = lat1 + 0.5 * km2deg(wp(1,2)) * cosd(heading2);
nomArrHalf2_lon = lon1 - 0.5 * km2deg(wp(1,2)) * sind(heading2);

figure(2);
geoplot(wp(:,4),wp(:,5), 'LineWidth', 2);
hold on
geoplot([lat1 nomArrHalf1_lat, nomArr1_lat], [lon1 nomArrHalf1_lon, nomArr1_lon], 'LineWidth', 2);
geoplot([lat1 nomArrHalf2_lat, nomArr2_lat], [lon1 nomArrHalf2_lon, nomArr2_lon], 'LineWidth', 2);
[LAT,LON] = scircle1(lat1,lon1,km2deg(wp(1,2)));
geoplot(LAT, LON, 'LineWidth', 2);
title('En Route from Brisbane to Hervey Bay');
legend('Flight Path', 'Northerly Wind Error Bound', 'Southerly Wind Error Bound');
geobasemap streets

% dead reckoning error arc
xc = -d * cosd(alpha); % north (x)
yc = -d * sind(alpha); % east (y)

% track error bounds
xcL = -d * cosd(heading1);
xcH = -d * cosd(heading2);
ycL = -d * sind(heading1);
ycH = -d * sind(heading2);
position = ["Actual"; "North Wind"; "South Wind"];
xc_pos = [xc; xcL; xcH];
yc_pos = [yc; ycL; ycH];
T2 = table(position, xc_pos, yc_pos);

% figure(3);
% plot([ 0 -nmDist*cosd(alpha)], [0 -nmDist*sind(alpha)]);
% hold on
% grid on
% box on
% plot([0 xcL], [0 ycL]);
% plot([0 xcH], [0 ycH]);
% [LAT,LON] = scircle1(0,0,km2deg(61900));
% plot(LAT, LON, 'LineWidth', 2);



% % define state space
% % state 1 - angle of attack
% % state 2 - pitch rate
% % state 3 - pitch angle
% % x_dot is state derivatives
% 
% % system dynamics
% A = [  -0.313   56.7 0;
%       -0.0139 -0.426 0;
%             0   56.7 0 ];
% 
% % system input
% B = [  0.232;
%       0.0203;
%            0 ];
%        
% % system output
% % output is all 3 states
% C = eye(size(A, 1));
% 
% D = zeros(size(C, 1),1);
% 
% % control gains
% K = [ 0.5, 0.5, 0.5 ];
% 
% h = 0.01;
% stoptime = 10;
% fl = sim('flightGNCSim', 'Solver', 'ode4', 'FixedStep', 'h', 'StopTime', 'stoptime');
% t = fl.tout;
% pA = fl.pitchAngle;
% pR = fl.pitchRate;
% AoA = fl.AoA;
% 
% figure();
% hold on
% grid on
% box on
% plot(t, pA);
% plot(t, pR);
% plot(t, AoA);
% legend('Pitch Angle', 'Pitch Rate', 'Angle of Attack');



