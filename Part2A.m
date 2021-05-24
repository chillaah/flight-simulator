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
t_sim = linspace(0, 10, 100);
dt = t_sim(2) - t_sim(1);

%% Longitudinal Motion
%% State Vector Xs
% Forward Velocity (ft/s) (Vx)
% Vertical Velocity (ft/s) (Vz)
% Pitch Rate (rad/s)
% Pitch Angle (rad)
Xs0 = [0; 0; 0; 0];
Xs = zeros(4, length(t_sim));
Xs(:, 1) = Xs0;

%% Input Vector du
% Elevator
% Thrust
du0 = [0; 0];
du = zeros(2, length(t_sim));
du(:, 1) = du0;

%% A & B Matrix
% Xs_dot = A * Xs + B * du

[A, B] = long_dynamics(c, V0);

% Full Equation, by integration
% Xs_dot_current = A * Xs_previous + B * du_current
% Xs_current = Xs_previous + dt * Xs_dot_current

%% Lateral Motion
%% State Vector Xs_lat
% Lateral Velocity (ft / s)
% Roll Rate (rad/s)
% Yaw Rate (rad/s)
% Roll Angle (rad)
Xs_lat0 = [0; 0; 0; 0];
Xs_lat = zeros(4, length(t_sim));
Xs_lat(:, 1) = Xs_lat0;

%% Input Vector du
% Rudder
% Aileron
du_lat0 = [0; 0];
du_lat = zeros(2, length(t_sim));
du_lat(:, 1) = du_lat0;

%% C & D Matrix
% Xs_dot = C * Xs + D * du
[C, D] = long_dynamics(c, V0);

% Full Equation, by integration
% Xs_dot_current = C * Xs_previous + D * du_current
% Xs_current = Xs_previous + dt * Xs_dot_current

%% Simulate
% Change the thrust
du(2, 25:end) = 0.01;

% Change elevation at some point
du(1, 50) = deg2rad(-30);

% Change aileron at some point
du_lat(1, 25) = deg2rad(10);

% Simulate..The simulation equations are solved via the integration method: 
%𝑥̇ = 𝐴𝑥 + 𝐵𝑢. for all time instances
for i = 2:length(t_sim)
    
   % Longitudinal
   Xs_dot = A * Xs(:, i-1) + B * du(:, i);
   Xs(:, i) = Xs(:, i-1) + dt * Xs_dot; 
   
   % Lateral
   Xs_dot_lat = C * Xs_lat(:, i-1) + D * du_lat(:, i);
   Xs_lat(:, i) = Xs_lat(:, i-1) + dt * Xs_dot_lat;
end

%% Extract X, Y, Z positions
Vx = Xs(1, :);
Vy = Xs_lat(1, :);
Vz = Xs(2, :);

Xpos = dt .* Vx;
Ypos = dt .* Vy;
Zpos = dt .* Vz;

figure();
plot3(Xpos, Ypos, Zpos, 'rO');
grid on;
xlabel ("Xpos (ft)");
zlabel ("Zpos (ft)");
ylabel ("Ypos (ft)");

