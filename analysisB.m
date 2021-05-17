%% EGB243 Task B - Team Bombardier
close all; clear; clc
 
%% Section 1
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

Nflights = 7;   %Manually set number of flights
S = referenceSphere('earth');
l_rw = zeros(1,Nflights);
heading_rw = zeros(1,Nflights);
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
    
    %plot latitude and longitude on the same axis
    figure
    subplot(3,2,1)
    cmap = jet(max(round(gndSpeed))+1);
    SpeedColours = cmap(round(gndSpeed)+1,:); 
    scatter(Lon, Lat, 10, SpeedColours, 'filled');
    grid on
    box on
    title('Top-Down Flight View');
    ylabel('Latitude [deg]');
    xlabel('Longitude [deg]');
    colormap(cmap);
    cbar = colorbar;
    cbar.Ticks = linspace( 0, max(round(gndSpeed)), 5 );
    caxis([0,max(round(gndSpeed))])
    cbar.Label.String = 'Ground Speed (m/s)';


 %cbarprop = get(cbar,'Title');

    subplot(3,2,3)
    %plot(t, Alt, 'm--', 'LineWidth', 1.5);
    scatter(t, Alt, 10, SpeedColours, 'filled');
    grid on
    box on
    title('Altitude vs Time');
    ylabel('Altitude [m]');
    xlabel('t [seconds]');
    colormap(cmap);
    cbar = colorbar;
    cbar.Ticks = linspace( 0, max(round(gndSpeed)), 5 );
    caxis([0,max(round(gndSpeed))])
    cbar.Label.String = 'Ground Speed (m/s)';
    %set(gca,'FontSize',20);
    

    
    %Get the velocity components in each direction
    Vdown = zeros(1,Nsamps);
    Veast = zeros(1,Nsamps);
    Vnorth = zeros(1,Nsamps);
    az = zeros(1,Nsamps);
    for ii = 2:Nsamps
       %Down velocity = change in altitude / change in time
       Vdown(ii-1) = -((Alt(ii)- Alt(ii-1))/Tsamp);
       
       %Convert degrees of latitude and longitude to N and E distances
       %[dist(ii),angle(ii)] = distance(Lat(ii-1),Lon(ii-1),Lat(ii),Lon(ii),S);
       xLat = distance(Lat(ii-1),Lon(ii),Lat(ii),Lon(ii),S);
       if (Lat(ii-1)> Lat(ii))
           xLat = -xLat;
       end
       
       xLon = distance(Lat(ii),Lon(ii-1),Lat(ii),Lon(ii),S);
       if (Lon(ii-1)> Lon(ii))
           xLon = -xLon;
       end
       
       Veast(ii-1) = xLat/Tsamp;
       Vnorth(ii-1) = xLon/Tsamp;
       az(ii-1) = azimuth(Lat(ii-1)-90,Lon(ii-1),Lat(ii)-90,Lon(ii));
    end
    
    Mdown = movmean(Vdown,10);
    Meast = movmean(Veast,10);
    Mnorth = movmean(Vnorth,10);
    
    subplot(3,2,2)
    %plot(t, Alt, 'm--', 'LineWidth', 1.5);   
    hold on, plot(t, Veast), plot(t, Meast)
    title('East Velocity');
    ylabel('Velocity [m/s]');
    xlabel('t [seconds]');
    grid on
    box on
    subplot(3,2,4)
    hold on,plot(t, Vnorth),plot(t, Mnorth)
    title('North Velocity');
    ylabel('Velocity [m/s]');
    xlabel('t [seconds]');
    grid on
    box on
    subplot(3,2,6)
    hold on,plot(t, Vdown),plot(t, Mdown)
    title('Down Velocity');
    ylabel('Velocity [m/s]');
    xlabel('t [seconds]');
    grid on
    box on

   %Find runway length
   threshold = 1;
   indexes_gnd = find(Alt-Alt(1) < threshold );
   [~,index_takeoff] = max(diff(indexes_gnd));
   index_land = index_takeoff + 1;
   indexes_rw = indexes_gnd([index_takeoff,index_land]);
   l_rw(i) =  distance(Lat(indexes_rw(1)),Lon(indexes_rw(1)),Lat(indexes_rw(2)),Lon(indexes_rw(2)),S);
   Lat_rw = Lat(indexes_rw);
   Lon_rw = Lon(indexes_rw);
   %set(gca,'FontSize',20);
   
   %find runway heading
   angle_rw = az(1:indexes_rw(1));
   angle_rw(gndSpeed(1:indexes_rw(1)) < threshold) = [];
   heading_rw(i) = mean(angle_rw);
   
   
   %plot runway
   subplot(3,2,5)
   plot3(Lat, Lon, Alt)
   hold on
   W_rw = 0.001;
   runway_lat = [Lat_rw(1)-sin(deg2rad(heading_rw(i)))*W_rw, Lat_rw(1)+sin(deg2rad(heading_rw(i)))*W_rw, Lat_rw(2)+sin(deg2rad(heading_rw(i)))*W_rw, Lat_rw(2)-sin(deg2rad(heading_rw(i)))*W_rw, Lat_rw(1)-sin(deg2rad(heading_rw(i)))*W_rw];
   runway_lon = [Lon_rw(1)+cos(deg2rad(heading_rw(i)))*W_rw, Lon_rw(1)-cos(deg2rad(heading_rw(i)))*W_rw, Lon_rw(2)-cos(deg2rad(heading_rw(i)))*W_rw, Lon_rw(2)+cos(deg2rad(heading_rw(i)))*W_rw, Lon_rw(1)+cos(deg2rad(heading_rw(i)))*W_rw];
   plot3( runway_lat,runway_lon , [0,0,0,0,0],'k-' )
   %sin(deg2rad(heading_rw(i)))*
   
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

    figure
    hold on
    plot(t,az) 
    plot(t,a_lift)
    plot(t,gndSpeed)
    plot(t,Alt)
end

l_rw_max  = max(l_rw); 
h_rw = mean(heading_rw);

%     hold on
%     plot(t, Lon, 'b--', 'LineWidth', 1.5);
%     grid on
%     box on
%     title('Longitude vs Time');
%     ylabel('degrees [deg]');
%     xlabel('t [seconds]');
%     labelprop = get(gca,'ylabel');
%     set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
%     %set(gca,'FontSize',20);
%     hold off

%     figure(4);
%     plot(t, groundSpeed, 'k--', 'LineWidth', 1.5);
%     grid on
%     box on
%     title('Ground Speed vs Time');
%     ylabel('knots [kts]');
%     xlabel('t [seconds]');
%     labelprop = get(gca,'ylabel');
%     set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
%     %set(gca,'FontSize',20);
% 
%     figure(5);
%     plot(t, heading, 'g--', 'LineWidth', 1.5);
%     grid on
%     box on
%     title('Heading Angle vs Time');
%     ylabel('degrees [deg]');
%     xlabel('t [seconds]');
%     labelprop = get(gca,'ylabel');
%     set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
%     %set(gca,'FontSize',20);
