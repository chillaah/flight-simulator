%% Preamble and Configuration
addpath('../EGB243SupportingFiles') % Makes the supporting functions available 
% to Matlab by adding the path to the Matlab Search Path for this session 
% (it gets removed when matlab is closed).
close all; clear; clc
%% Parameters
% Time
dt = 5e-2;  % Time step
tf = 50;    % Final time

% Time vector
t = 0:dt:tf-dt;
num_samples = length(t);

% Starting Flight Conditions
u0 = 275;               % Equilibrium/Trim Point velocity 	(m/s)

%%%%%%% Velocity Notes %%%%%%%
% [Mach 0.158, 54.2m/s]
% [Mach 0.5, 175m/s]
% [Mach 0.8, 275m/s]
% Velocity Conversions
% 1/ms = 1.94kts
% 1kts = 0.514m/s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Starting State
pos_start = [0;         % Starting X (m)
             0;         % Starting Y (m)
             -1000];    % Starting Z (m)
         
% We have most of the states coming from the longitudinal and lateral models 
x0_lon = [0 ...     % u - forward velocity
    0 ...           % w - vertical velocity
    0 ...           % q - pitch rate
    deg2rad(0) ...  % theta - pitch angle 
    ];

x0_lat = [0 ...   % v - lateral velocity
    0 ...         % p - roll rate
    0 ...         % r - yaw rate
    0 ...         % phi - roll angle
    ];

X_lon = [x0_lon; zeros(num_samples-1,length(x0_lon))];
X_lat = [x0_lat; zeros(num_samples-1,length(x0_lat))];

% Starting input
u_lon = [0 ... % elevator
        0  ...  % thrust
        ];
u_lat = [0 ... % rudder
        0  ...  % aileron
        ];
  
% We need to simulate the longitudinal and lateral dynamics then rotate
% those to states in the world frame

c = loadparam('B747');

% Simulating
% longitudinal dynamics - euler integration
for i = 2:length(t)
    if i > 1/dt && i < 1.2/dt
        u_lon(1) = deg2rad(5);
    else
        u_lon(1) = 0;
    end
    dX = dynamics_lab4_lon(X_lon(i-1,:)',u_lon',c,u0);
    X_lon(i,:) = X_lon(i-1,:) + dt*dX';
end

% lateral dynamics - euler integration
for i = 2:length(t)
    if i > 1/dt && i < 2/dt
        u_lat(2) = deg2rad(5);
    else
        u_lat(2) = 0;
    end
    dX = dynamics_lab4_lat(X_lat(i-1,:)',u_lat',c,u0);
    X_lat(i,:) = X_lat(i-1,:) + dt*dX';
end

% Rotating from Body to World frame
% Starting states
%X0 = [100*0.514; ... 	% Forward Velocity (m/s)
X0 = [pos_start(1); ... % x - position in x (m)
      pos_start(2); ... % y - position in y (m)
      pos_start(3); ... % z - position in z (m)      
      x0_lon(1); ...    % u - velocity in x / Forward Velocity (m/s)
      x0_lat(1); ...    % v - velocity in y / Lateral Velocity (m/s)
      x0_lon(2); ...    % w - velocity in z / Vertical Velocity
      x0_lat(4); ...    % phi - Roll (rad)
      x0_lon(4); ...    % theta - Pitch (rad)
      0; ...            % psi - Yaw (rad)
      x0_lat(2); ...    % p - Roll Rate (rad/s)
      x0_lon(3); ...    % q - Pitch Rate (rad/s)
      x0_lat(3)];       % r - Yaw Rate (rad/s)

DX = [X_lon X_lat]; % combining both models

y = flight_body2world_rot(DX,t,u0,pos_start);

f2 = figure();
    box on
    plot3(y(:,1),y(:,2),y(:,3))
axis('square');
set(gca, 'Zdir', 'reverse') % Reverse the z axis direction (improves viualisation when using NED coordinate systems)
grid on;
%     axis('equal')
    xlabel('x (m)');
    ylabel('y (m)');
    zlabel('z (m)');
    grid on;
    view(3)