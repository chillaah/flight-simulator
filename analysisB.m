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
    subplot(2,1,1)
    cmap = jet(max(round(gndSpeed))+1);
    SpeedColours = cmap(round(gndSpeed)+1,:); 
    scatter(Lon, Lat, 10, SpeedColours, 'filled');
    grid on
    box on
    title('Top-Down Flight View');
    ylabel('Latitude [deg]');
    xlabel('Longitude [deg]');
    labelprop = get(gca,'ylabel');
    set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
    colormap(cmap);
    cbar = colorbar;
    cbar.Ticks = linspace( 0, max(round(gndSpeed)), 5 );
    caxis([0,max(round(gndSpeed))])
    cbar.Label.String = 'Ground Speed (m/s)';


 %cbarprop = get(cbar,'Title');

    subplot(2,1,2)
    %plot(t, Alt, 'm--', 'LineWidth', 1.5);
    scatter(t, Alt, 10, SpeedColours, 'filled');
    grid on
    box on
    title('Altitude vs Time');
    ylabel('Altitude [m]');
    xlabel('t [seconds]');
    labelprop = get(gca,'ylabel');
    set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
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
    for ii = 2:Nsamps
       %Down velocity = change in altitude / change in time
       Vdown(ii-1) = (Alt(ii)- Alt(ii-1))/Tsamp;
       
       %Convert degrees of latitude and longitude to N and E distances
       [dist,angle] = distance('rh',Lat(ii-1),Lon(ii-1),Lat(ii),Lon(ii));
       xLat = dist*sin(angle);
       xLon = dist*cos(angle);
       %angle = 
       Veast(ii-1) = xLat/Tsamp;
       Vnorth(ii-1) = xLon/Tsamp;
    end
    
    Mdown = movmean(Vdown,10);
    Meast = movmean(Veast,10);
    Mnorth = movmean(Vnorth,10);
    
    figure
    subplot(3,1,1)
    %plot(t, Alt, 'm--', 'LineWidth', 1.5);   
    hold on, plot(t, Veast), plot(t, Meast)
    title('East Velocity');
    ylabel('Velocity [m/s]');
    xlabel('t [seconds]');
    labelprop = get(gca,'ylabel');
    set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
    subplot(3,1,2)
    hold on,plot(t, Vnorth),plot(t, Mnorth)
    subplot(3,1,3)
    hold on,plot(t, Vdown),plot(t, Mdown)
    grid on
    box on
    legend

   
    %set(gca,'FontSize',20);
end


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
