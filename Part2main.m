%%Reference Documents 
%https://au.mathworks.com/videos/fly-a-747-with-matlab-68730.html
%https://au.mathworks.com/help/aeroblks/simulink-project-template-for-flight-simulation-applications.html
%%https://courses.cit.cornell.edu/mae5070/Caughey_2011_04.pdf
%EGB243_computer_lab_3_solutions.m
%EGB243_computer_lab_5_solutions.m
%Flight_Data provided on the blackboard 
%Function flight_body2world_rot function for reference for body to world
%frame
%EGB243_2021_LEC_wk4, EGB243_2021_LEC_wk5, EGB243_2021_LEC_wk7 slide 24,25
%
%%%%%%% Velocity Notes %%%%%%%
% [Mach 0.158, 54.2m/s]
% [Mach 0.5, 175m/s]
% [Mach 0.8, 275m/s]
% Velocity Conversions
% 1/ms = 1.94kts
% 1kts = 0.514m/s
%%%%%%%%%%%%%%%%%%%%%%%%%
%% Closing Previous Directories
close all;
clear;
clc;

%% Parameters
% Time
dt = 1; % Time step
tf = 200;%time for simulation

% Time Vector
t = 0:dt:tf;
num_sample = length(t);
% Rotating from Body to World frame
% Starting states
X0 = [0; ... % Position X - x (ft)
  0; ...    % Position Y - y(ft)
  10000; ... % Position Z - z(ft)
  0; ...    % Roll - phi(rad)
  0; ...    % Pitch - theta (rad)
  0; ...    % Yaw - psi (rad)
  100; ...  % Velocity X - u (fts) 
  0; ...    % Velocity Y - v (fts)
  deg2rad(10); ...%Velocity Z - w (fts)
  0; ...    % Roll Rate - p (rad/s)
  0; ...    % Pitch Rate - q (rad/s)
  0];       % Yaw Rate - r rad/s)
%We will now give the input and allocate our state vector
number_of_states = length(X0);
X = zeros(number_of_states, num_sample); 
X(:,1) = X0; %Starting state

mu0=[0; ... % forward velocity (Kt)
    0; ...  % Climb Speed (fts/s)
    0];   % Yaw Rate (rad/s)
  
% Calling and Simulating using a autopilot function
for i = 2:num_sample
    if i<=23
        mu = [100; 0; deg2rad(10)]; 
    elseif i<=40
        mu = [100; 0; 0]; 
    elseif i<=53
        mu = [25; 0; -deg2rad(10)]; 
    elseif i<=100
        mu = [100;0; 0]; 
    elseif i<=109
        mu = [25; 0; -deg2rad(10)]; 
    elseif i<=132
        mu = [100;0;0]; 
    elseif i<=146
        mu = [25; 0; -deg2rad(10)]; 
    elseif i<=160
        mu = [100;0; 0]; 
    elseif i<=173
        mu = [25; 0; -deg2rad(10)]; 
    elseif i<=210
        mu = [100; 0; 0]; 
    elseif i<=228
        mu = [100; 0; deg2rad(10)]; 
    elseif i<=237
        mu = [25; 0; deg2rad(10)];
    elseif i<=247
        mu = [90; 0; 0]; 
    elseif i<=256
        mu = [25; 0; deg2rad(10)];
    elseif i<=274
        mu = [100; 0; -deg2rad(10)];
    else
        mu = [0;0;0];
    end
    
    % directions at different points in time 
    %calc world position
    X(:,i) = flight_positioning( X(:,i-1), mu, dt);
end


%% Plotting
disp('Visualizing...')
figure(1)
     plot3(X(1,:),X(2,:),X(3,:), 'b');
     hold on
     plot3(X(1,65:109),X(2,65:109),X(3,65:109), 'white');
    xlabel('X(ft)');
    ylabel('Y(ft)');
    zlabel('Z(ft)');
     axis('equal')
       %grid on;
    
f2 = figure(2); 
%Viewpoint axis size for the plot flight...vector   
vp = [8000, 15000, 8000]; 
plot_flight(f2, vp, t, X);

% Animation of the aircraft
f2 = figure(2); hold on;
xlabel('X (ft)')
ylabel('Y (ft)')
zlabel('Z (ft)')
disp('Done!')


%% 
f3 = figure(3);
plot(t,X)
legend('x','y','z','phi','theta','psi','dx','dy')
title('State values over the duration of the simulation')
xlabel('Time (s)')
ylabel('Values')

%%
% f4 = figure(4);
%     clf; hold on;
%     yyaxis left
%     plot(t,X(6,:)); %yaw
%     ylabel('Heading (rad)');
%     ylim([-max(abs(X(:,6)))-0.5,max(abs(X(:,6)))+0.5]);
%     yyaxis right
%     plot(t,X(12,:), '--');
%     ylabel('Yaw Rate (rad/s)'); %Yaw Rate 
%     ylim([-max(abs(X(:,12)))-0.5,max(abs(X(:,12)))+0.5]);
%     hold off;
%     grid on;    
%     title('Flight Heading and Yaw Rate');
%     xlabel('Time (s)');
%     xlim([0,tf]);   
    
    %%

% Reference x,y,z coordinates for Valcourt *where Bombardier was founded
% Bombardier library
%45.495 N 72.31417 W 
% or (Lat, Long) = (45.495,-72.31417)
lat_sp = deg2km(45.495)*1000;
long_sp = deg2km(-72.31417)*1000;

% We are flying East
% Xc is the direction of East to West
% Yc is the directiopn of North - South



xc = X(1,:) + long_sp; 
yc = X(2,:)+ lat_sp;

xc_off = X(1,63:109)+long_sp;
yc_off = X(2,63:109)+lat_sp;

xc_long = km2deg(xc./1000);
yc_lat = km2deg(yc./1000);

xc_longo = km2deg(xc_off./1000);
yc_lato = km2deg(yc_off./1000);

figure(5)
geoplot(yc_lat, xc_long,'b-')
hold on 
geoplot(yc_lato, xc_longo,'w')
%plot3(X(1,65:100),,X(3,65:100), 'white');

    
    
%% 
%%Implementing Autopilot
function [ Xi ] = flight_positioning( Xi_minus_1, mu, dt)
%calculating position
%At X(7) and X(8) we update velocities with respect to the dynamics
%   positon and angle
    Xi(1) = Xi_minus_1(1) + Xi_minus_1(7)*dt;
    Xi(2) = Xi_minus_1(2) + Xi_minus_1(8)*dt;
    Xi(3) = Xi_minus_1(3) + Xi_minus_1(9)*dt;
    Xi(4) = Xi_minus_1(4) + Xi_minus_1(10)*dt;
    Xi(5) = Xi_minus_1(5) + Xi_minus_1(11)*dt;
    Xi(6) = Xi_minus_1(6) + Xi_minus_1(12)*dt;
    Xi(7) = mu(1)*cos( Xi_minus_1(6) )*1.68781;%kt to fts/s
    Xi(8) = mu(1)*sin( Xi_minus_1(6) )*1.68781;
    Xi(9) = mu(2);  
    Xi(10) = 0; % No roll rate
    Xi(11) = 0; % No pitch rate
    Xi(12) = mu(3);

end
