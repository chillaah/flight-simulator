%% Preamble and Configuration
addpath('../EGB243SupportingFiles') % Makes the supporting functions available 
% to Matlab by adding the path to the Matlab Search Path for this session 
% (it gets removed when matlab is closed).
%% Parameters
clear all
% Time
tf = 250;   % Simulation duration
dt = 5e-2; % Time step (sampling time)

% Time vector
t = 0:dt:tf-dt;
num_samples = length(t);

u0 = 275; % equilibrium forward velocity

% Flight Parameters
c = loadparam('B747');

%% Longitudinal Dynamics
% Initial state vector (first column of the state matrix) - Perturbations
x0_lon = [0 ...     % u - forward velocity
    0 ...           % w - vertical velocity
    0 ...           % q - pitch rate
    deg2rad(0) ...           % theta - pitch angle 
    ];

X_lon = [x0_lon; zeros(num_samples-1,length(x0_lon))];

% Initial input vector
u_lon = [0 ... % elevator
        0  ...  % thrust
        ];
    
% Simulating
% - euler integration
for i = 2:length(t)
    if i > 1/dt && i < 1.2/dt
        u_lon(1) = deg2rad(5);
    else
        u_lon(1) = 0;
    end
    dX = dynamics_lab4_lon(X_lon(i-1,:)',u_lon',c,u0);
    X_lon(i,:) = X_lon(i-1,:) + dt*dX';
end

% Plotting
f1 = figure(1);
    clf;
    subplot(2,1,1)
        hold on;
        plot(t,X_lon(:,1))
        plot(t,X_lon(:,2))
        hold off;
        grid on;
        legend('Forward Velocity [m/s]', 'Vertical Velocity [m/s]')
        xlabel('time [s]')
    subplot(2,1,2)
        hold on;
        plot(t,rad2deg(X_lon(:,3)))
        plot(t,rad2deg(X_lon(:,4)))
        hold off;
        grid on;
        legend('Pitch Velocity [deg/s]', 'Pitch Angle [deg]')
        xlabel('time [s]')
        
%% Lateral Dynamics
% Time
tf = 50;   % Simulation duration
dt = 5e-2; % Time step (sampling time)

% Time vector
t = 0:dt:tf-dt;
num_samples = length(t);

% Initial state vector (first column of the state matrix)
x0_lat = [0 ...   % v - lateral velocity
    0 ...           % p - roll rate
    0 ...           % r - yaw rate
    0 ...           % phi - roll angle
    ];

X_lat = [x0_lat; zeros(num_samples-1,length(x0_lat))];

% Initial input vector
u_lat = [0 ... % rudder
        0  ...  % aileron
        ];

% Simulating
% - euler integration
for i = 2:length(t)
    if i > 1/dt && i < 1.2/dt
        u_lat(2) = deg2rad(1);
    else
        u_lat(2) = 0;
    end
    dX = dynamics_lab4_lat(X_lat(i-1,:)',u_lat',c,u0);
    X_lat(i,:) = X_lat(i-1,:) + dt*dX';
end

% Plotting
f2 = figure(2);
    clf;
    subplot(2,1,1)
        hold on;
        plot(t,X_lat(:,1))
        plot(t,X_lat(:,2))
        hold off;
        grid on;
        legend('Lateral Velocity [m/s]', 'Yaw Rate [deg/s]')
        xlabel('time [s]')
    subplot(2,1,2)
        hold on;
        plot(t,rad2deg(X_lat(:,3)))
        plot(t,rad2deg(X_lat(:,4)))
        hold off;
        grid on;
        legend('Roll Angle [deg]', 'Roll Rate [deg/s]')
        xlabel('time [s]')