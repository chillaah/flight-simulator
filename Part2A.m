%% Pre-Script
clear all
close all
clc

%% Note
% Here, we are simulating B747 flying @ 11000m
% with velocity / ground speed of 780 ft/s
% Flight Parameters (MATLAB built in)
c = loadparam('B747');
V0 = 20;

%% Simulation Time
simulation_time = linspace(0, 10, 100);
dt = simulation_time(2) - simulation_time(1);

%% Longitudinal Motion
%% State Vector Xs
% Forward Velocity (ft/s) (Vx)
% Vertical Velocity (ft/s) (Vz)
% Pitch Rate (rad/s)
% Pitch Angle (rad)
Xs_init = [0; 0; 0; 0];
Xs = zeros(4, length(simulation_time));
Xs(:, 1) = Xs_init;

%% Input Vector du
% Elevator
% Thrust
derivative_u0 = [0; 0];
derivative_u = zeros(2, length(simulation_time));
derivative_u(:, 1) = derivative_u0;

%% A & B Matrix
% Xs_dot = A * Xs + B * du
[A, B] = long_dynamics(c, V0);
% Current state = Previous_state + time derivative * dot_current_State

%% Lateral Motion
%% State Vector Xs_lat
% Lateral Velocity (ft / s)
% Roll Rate (rad/s)
% Yaw Rate (rad/s)
% Roll Angle (rad)
lat0_Xs = [0; 0; 0; 0];
lat_Xs = zeros(4, length(simulation_time));
lat_Xs(:, 1) = lat0_Xs;

%% Input Vector du
% Rudder
% Aileron
lat0 = [0; 0];
latDu = zeros(2, length(simulation_time));
latDu(:, 1) = lat0;

%% C & D Matrix
% Xs_dot = C * Xs + D * du
[C, D] = long_dynamics(c, V0);

%% Simulate
% Change the thrust
derivative_u(2, 25:end) = 0.01;

% Change elevation at some point
derivative_u(1, 50) = deg2rad(-30);

% Change aileron at some point
latDu(1, 25) = deg2rad(10);

% Simulate..The simulation equations are solved via the integration method: 
%𝑥̇ = 𝐴𝑥 + 𝐵𝑢. for all time instances
for i = 2:length(simulation_time)
    
   % Longitudinal
   Xs_dot = A * Xs(:, i-1) + B * derivative_u(:, i);
   Xs(:, i) = Xs(:, i-1) + dt * Xs_dot; 
   
   % Lateral
   Xs_dot_lat = C * lat_Xs(:, i-1) + D * latDu(:, i);
   lat_Xs(:, i) = lat_Xs(:, i-1) + dt * Xs_dot_lat;
end

%% Extract X, Y, Z positions
Vx = Xs(1, :);
Vy = lat_Xs(1, :);
Vz = Xs(2, :);

X_pos = dt .* Vx;
Y_pos = dt .* Vy;
Z_pos = dt .* Vz;

figure();
plot3(X_pos, Y_pos, Z_pos, 'rO');
grid on;
xlabel ("Position in X direction(ft)");
zlabel ("Position in Z direction (ft)");
ylabel ("Position in Y direction(ft)");

