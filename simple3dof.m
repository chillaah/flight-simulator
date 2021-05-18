function [f2] = simple3dof(t,v,yaw,pitch)
%circuit sim creates a basic 3DOF simulation of an aircraft
%   Detailed explanation goes here
%t: time vector
%v: velocity vector
%yaw: yaw vector
%pitch: pitch vector
%pos: starting position (Lat, Lon, Alt)

dt = t(2)-t(1); % Time step (sampling time)
Nsamps = length(t);
tf = t(end);

%TODO: initialise the state vectors (x,y and z) with the airplane position
x = zeros(1,length(t));
y = zeros(1,length(t));
z = zeros(1,length(t));
%% (Task 3) Simulation 
%TODO: Simulate the 2D trajectory based on the speed and yaw vectors
% (hint: use a for-loop)
for i = 2:Nsamps
    %TODO: Implement the 2D kinematic equations of motion for every sample
    x(i) = x(i-1) + dt*v(i-1)*cos(pitch(i-1))*cos(yaw(i-1));
    y(i) = y(i-1) + dt*v(i-1)*cos(pitch(i-1))*sin(yaw(i-1));
    z(i) = z(i-1) + dt*v(i-1)*sin(pitch(i-1));
end
%% (Task 4) Plotting 
%TODO: Plot the 2D (x,y) trajectory
f1 = figure; hold off
    plot3(x,y,z,'LineWidth',1); grid on
    title('3D trajectory');
    xlabel('x (m)');
    ylabel('y (m)');
    zlabel('z (m)');
    axis equal

%TODO: Create a two-axis plot showing the airplane's yaw (left) and 
% x position (left) versus time.
f2 = figure; hold off
    clf; hold on;
    yyaxis left
    plot(t,yaw);
    ylabel('Yaw (rad)');
%     ylim([-200,800]);
    yyaxis right
    plot(t,x, '--');
    ylabel('x (m)');
%     ylim([-200,800]);
    hold off;
    grid on;
    
    title('Flight Yaw and Position in x');
    xlabel('Time (s)');
    xlim([0,tf]);

end

