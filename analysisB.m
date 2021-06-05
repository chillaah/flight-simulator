%% EGB243 Task B - Team Bombardier
close all; clear; clc
 
%% Section 1 a
%Flight Simulator Data Fields
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

Nflights = 7;   %Hardcode number of flights
S = referenceSphere('earth'); % Define sphere for mapping toolbox functions

%PREALLOCATION of values that need to be extracted from the loop
l_rw = zeros(1,Nflights);  
heading_rw = zeros(1,Nflights);
tf = zeros(1,Nflights);
v_av = zeros(1,Nflights);
pitch_rms = zeros(1,Nflights);

% For loop to process data for every flight
for i = 1:Nflights
    
    
    %Manually set each flight to an index of the loop
    if i == 1
        fltData = f4;
    elseif i == 2
        fltData = f6;
    elseif i == 3
        fltData = f9;
    elseif i == 4
        fltData = f11;
    elseif i == 5
        fltData = f13;
    elseif i == 6
        fltData = f17;
    elseif i == 7
        fltData = f25;        
    end
    
    %Extract information from flight data and convert to SI units
    gndSpeed = fltData(:, 1)/1.944;
    Alt = fltData(:, 2)/3.281;
    heading = fltData(:, 3);
    Lon = fltData(:, 4);
    Lat = fltData(:, 5);
    
    Nsamps = length(gndSpeed);  %Find number of samples
    Tsamp = 0.4;                %Hardcode sampling time
   
    %Tsamp in the time interval between samples. Therefore there will be 1
    %less sampling interval than samples
    Tsim = Tsamp*(Nsamps-1);    %Find flight time
    t = 0:0.4:Tsim;             %Create time vector
    
    %Plot latitude and longitude on the same axis
    figure
    subplot(3,2,1)
    %Produce colours for each point
    cmap = jet(max(round(gndSpeed))+1); % # of colours is the maximum groundspeed + 1 (zero velocity must have a colour)
    SpeedColours = cmap(round(gndSpeed)+1,:); %produce a vector of colours based on the ground speed vector
    
    scatter(Lon, Lat, 10, SpeedColours, 'filled');
    grid on
    box on
    title('Flight Top-view');
    ylabel('Latitude [deg]');
    xlabel('Longitude [deg]');
    colormap(cmap);
    cbar = colorbar;
    cbar.Ticks = linspace( 0, max(round(gndSpeed)), 5 );
    caxis([0,max(round(gndSpeed))])
    cbar.Label.String = 'Ground Speed (m/s)';

    subplot(3,2,3)
    scatter(t, Alt, 10, SpeedColours, 'filled');
    grid on
    box on
    title('Flight Altitude');
    ylabel('Altitude [m]');
    xlabel('t [seconds]');
    colormap(cmap);
    cbar = colorbar;
    cbar.Ticks = linspace( 0, max(round(gndSpeed)), 5 );
    caxis([0,max(round(gndSpeed))])
    cbar.Label.String = 'Ground Speed (m/s)';

    %Get the velocity components in each direction
    Vdown = zeros(1,Nsamps);
    Xeast = zeros(1,Nsamps);
    Xnorth = zeros(1,Nsamps);
    Veast = zeros(1,Nsamps);
    Vnorth = zeros(1,Nsamps);
    
    for ii = 2:Nsamps
       %Down velocity = change in altitude / change in time
       Vdown(ii-1) = -((Alt(ii)- Alt(ii-1))/Tsamp);
       
       %Use heading to find the east and north velocity components
       Veast(ii-1) = sin(deg2rad(heading(ii-1)))*gndSpeed(ii-1);
       Vnorth(ii-1) = cos(deg2rad(heading(ii-1)))*gndSpeed(ii-1);

    end
    
    %Find moving average of the data
    Mdown = movmean(Vdown,10);
    Meast = movmean(Veast,10);
    Mnorth = movmean(Vnorth,10);
    
    %Plot the three sets of velocity data on different axes
    subplot(3,2,2)
    %plot(t, Alt, 'm--', 'LineWidth', 1.5);   
    hold on, plot(t, Veast), plot(t, Meast)
    legend("Raw Data","Moving Average")
    title('East Velocity');
    ylabel('Velocity [m/s]');
    xlabel('t [seconds]');
    grid on
    box on
    subplot(3,2,4)
    hold on,plot(t, Vnorth),plot(t, Mnorth)
    legend("Raw Data","Moving Average")
    title('North Velocity');
    ylabel('Velocity [m/s]');
    xlabel('t [seconds]');
    grid on
    box on
    subplot(3,2,6)
    hold on,plot(t, Vdown),plot(t, Mdown)
    legend("Raw Data","Moving Average")
    title('Down Velocity');
    ylabel('Velocity [m/s]');
    xlabel('t [seconds]');
    grid on
    box on

   %Find runway length
   threshold = 1; %Below 1m altitude, the plane is considered grounded.
   indexes_gnd = find(Alt-Alt(1) < threshold ); % find indexes where plane is grounded
   [~,index_takeoff] = max(diff(indexes_gnd)); %find index of takeoff
   index_land = index_takeoff + 1;  %index of landing must come straight after takeoff
   i_rw = indexes_gnd([index_takeoff,index_land]);  %find indexes of the two runway extrema
   l_rw(i) = distance(Lat(i_rw(1)),Lon(i_rw(1)),Lat(i_rw(2)),Lon(i_rw(2)),S); %use distance to calculate runway length
   Lat_rw = Lat(i_rw); %Assign latitude and longitude values of runway extrema to a variable.
   Lon_rw = Lon(i_rw);
 
   
   %find runway heading
   angle_rw = heading(1:i_rw(1));
   %angle_rw(gndSpeed(1:i_rw(1)) < threshold) = [];
   heading_rw(i) = mean(angle_rw);
   
   
   %plot 3D visualisation
   subplot(3,2,5)
   plot3(Lat, Lon, Alt)
   hold on
   %set width of the runway (arbitrary)
   W_rw = 0.001;
   %create runway rectangular plane for plotting
   runway_lat = [Lat_rw(1)-sin(deg2rad(heading_rw(i)))*W_rw, Lat_rw(1)+sin(deg2rad(heading_rw(i)))*W_rw, Lat_rw(2)+sin(deg2rad(heading_rw(i)))*W_rw, Lat_rw(2)-sin(deg2rad(heading_rw(i)))*W_rw, Lat_rw(1)-sin(deg2rad(heading_rw(i)))*W_rw];
   runway_lon = [Lon_rw(1)+cos(deg2rad(heading_rw(i)))*W_rw, Lon_rw(1)-cos(deg2rad(heading_rw(i)))*W_rw, Lon_rw(2)-cos(deg2rad(heading_rw(i)))*W_rw, Lon_rw(2)+cos(deg2rad(heading_rw(i)))*W_rw, Lon_rw(1)+cos(deg2rad(heading_rw(i)))*W_rw];
   plot3( runway_lat,runway_lon , [0,0,0,0,0],'k-' )
    title('3D flight path');
    xlabel('x (m)');
    ylabel('y (m)');
    zlabel('z (m)');
   
   %create annotations
   if i == 4
    dim = [.15 .05 .3 .3];          
    str = 'Best Circuit Flown';     
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
   end
   
   if (i == 6 || i == 7)
    dim = [.15 .05 .3 .3];
    str = 'Flown in windy conditons';
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
   end
   
   a_lift = zeros(1,Nsamps);
   for ii = 2:Nsamps
    %Find down acceleration to find lift 
    a_lift(ii-1) = -(Vdown(ii)- Vdown(ii-1))/Tsamp; 
   end
    
   %save the final time of each simulation
   tf(i) = t(end);
    
    %find the pitch angle from the down velocity component of the velocity
    pitch = atan((-Vdown)./(sqrt(Vnorth.^2 + Veast.^2)));
    pitch(isnan(pitch)) = 0;
    %Get RMS of pitch to account for negative values
    pitch_rms(i) = rms(pitch);

%Save values from 6th and 7th flights to estimate wind
    if i == 6
        gndSpeed_6 = gndSpeed;
        heading_6 = heading;
    end
    
    if i == 7
        gndSpeed_7 = gndSpeed;
        heading_7 = heading;
    end

%Save values from 4th flight for later replication
    if i == 4
        t_4 = t;
        v_4 = sqrt(Vnorth.^2 + Veast.^2 + Vdown.^2);
        yaw_4 = deg2rad(heading);
        pitch_4 = pitch;
        
    end
    %save the average velocity of each flight
    v_av(i) = mean(gndSpeed);
end

l_rw_max  = max(l_rw); % max length between take off and touch down (rw length)
h_rw = mean(heading_rw); %find average runway heading
tf_av = mean (tf);  %find average duration of flight

%Estimate wind direction and magnitude 
%Graphically find 2 indices of wind [tailwind, headwind]
i_wind_6 = round([47.6/Tsamp, 96/Tsamp]);
i_wind_7 = round([150/Tsamp, 319.2/Tsamp]);

%For Flight 6
%Find airspeed as the average of headwind and tailwind
airSpeed_6 = mean(gndSpeed_6(i_wind_6));

%windspeed is found by subtracting groundspeed from airspeed
windSpeed_6 = gndSpeed_6(i_wind_6) - airSpeed_6; 
%Select 1st value of windspeed (tailwind) as it will be positive
windSpeed_6 = windSpeed_6(1); 

%find azimuth angle (heading) the direction the wind is at it's greatest
windDir_6 = heading_6(i_wind_6);
%Choose 1st value of wind direction (tailwind) to find wind heading
windDir_6 = windDir_6(1);

%Repeat process for flight 7
airSpeed_7 = mean(gndSpeed_7(i_wind_7));
windSpeed_7 = gndSpeed_7(i_wind_7) - airSpeed_7;
windSpeed_7 = windSpeed_7(1);
windDir_7 = heading_7(i_wind_7);
windDir_7 = windDir_7(1);



%% Section 1 b
%Create time vector for perfect circuit simulation
t_p = 0:0.4:tf_av; 
Nsamps_p = length(t_p);
%Create input vectors for perfect circuit simulation
%velocity vector
%perfect top speed is 150kts = 77m/s
%accelerate to top spee quickly and then decelerate quickly
v_p = [linspace(0,48.5,round(Nsamps_p/10)) ...
     48.5*ones(1,round(4*Nsamps_p/5))...
     linspace(48.5,0,round(Nsamps_p/10))];

%pitch vector 
%critical airfoil angle is 15 for many aircraft
pitch_p = deg2rad([zeros(1,ceil(Nsamps_p/20)),...
                   linspace(0,10,ceil(Nsamps_p/20)),...
                   10*ones(1,ceil(Nsamps_p/20)),...
                   linspace(10,0,ceil(Nsamps_p/20)),...
                   zeros(1,ceil(3*Nsamps_p/5)),...
                   linspace(0,-10,ceil(Nsamps_p/20)),...
                   -10*ones(1,ceil(Nsamps_p/20)),...
                   linspace(-10,0,ceil(Nsamps_p/20)),...
                   zeros(1,ceil(Nsamps_p/20))]);
pitch_p = pitch_p(1:Nsamps_p);          

%yaw vector
%perfect circuit involves 4 90 degree turns. The first turn should start as
%soon as the aircraft reaches its peak height.

yaw_p = deg2rad([zeros(1,ceil(Nsamps_p/6)),...
                   linspace(0,90,ceil(Nsamps_p/15)),...
                   90*ones(1,ceil(Nsamps_p/15)),...
                   linspace(90,180,ceil(Nsamps_p/15)),...
                   180*ones(1,ceil(Nsamps_p/3.75)),...
                   linspace(180,270,ceil(Nsamps_p/15)),...
                   270*ones(1,ceil(Nsamps_p/15)),...
                   linspace(270,360,ceil(Nsamps_p/15)),...
                   zeros(1,ceil(Nsamps_p/6))] + h_rw );

 yaw_p = yaw_p(1:Nsamps_p);
 
 %simulate perfectly flown circuit
 simple3dof(t_p,v_p,yaw_p,pitch_p)
 
 
 %Replicate flight 4
 simple3dof(t_4,v_4,yaw_4,pitch_4)
 
 
 
