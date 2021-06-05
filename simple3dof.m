function [f1,f2] = simple3dof(t,v,yaw,pitch)


dt = t(2)-t(1); %sampling time
Nsamps = length(t); %number of samples
tf = t(end); %find final simm time

%preallocate the output vectors
x = zeros(1,length(t));
y = zeros(1,length(t));
z = zeros(1,length(t));

%This for loop processes the 3DOF dynamics of the aircraft
for i = 2:Nsamps
    x(i) = x(i-1) + dt*v(i-1)*cos(pitch(i-1))*cos(yaw(i-1));
    y(i) = y(i-1) + dt*v(i-1)*cos(pitch(i-1))*sin(yaw(i-1));
    z(i) = z(i-1) + dt*v(i-1)*sin(pitch(i-1));
end

%plot 3D trajectory
f1 = figure; hold off
    plot3(x,y,z,'LineWidth',1); grid on
    title('3D trajectory');
    xlabel('x (m)');
    ylabel('y (m)');
    zlabel('z (m)');
    axis equal


end

