function plot_flight( f, vp, t, varargin )
%PLOT_FLIGHT Plays back a simulation of a plane
%   Input:
%
%       t:  The time vector (N) used
%       x:  The states (MxN)of the aircraft as listed below
%       vp: A 3 element vector to set the axis viewport size
%
%   States:
%       Position X
%       Position Y
%       Position Z
%       Roll
%       Pitch
%       Yaw
%       Velocity X
%       Velocity Y
%       Velocity Z
%       Roll Rate
%       Pitch Rate
%       Yaw Rate

%% Load in the 
[model.v, model.f, model.n, model.c, model.stltitle] = stlread('plane.stl');
model.c(:,1) = 1; %Making the first column of matrix c 1
model.v = model.v/10; % Model is imported in mm

%%
num_planes = nargin() - 3;

if num_planes < 1
    error('At least 1 state vector must be provided')
end

planes = varargin;
cmap = jet(num_planes);

%%

for i = 1:length(t)   % For every step in the time sequence
    disp(['t: ', num2str(t(i))])
    
    figure(f);
    clf;
    hold on;
    
    for j = 1:num_planes
        x = planes{j};
        
        r = x(4,i);
        p = x(5,i);
        y = x(6,i);

        R_yaw = [cos(y), -sin(y), 0;...
                 sin(y), cos(y), 0;...
                 0, 0, 1]; 
        R_pitch =  [cos(p), 0, -sin(p);...
                    0, 1, 0;...
                    sin(p), 0, cos(p)];
        R_roll =  [1, 0, 0;...
                   0, cos(r), -sin(r);...
                   0, sin(r), cos(r);];

        verts = (R_yaw*R_pitch*R_roll*(model.v'))';

        verts(:,1) = verts(:,1) + x(1,i); %vertices
        verts(:,2) = verts(:,2) + x(2,i);
        verts(:,3) = verts(:,3) + x(3,i);

        if num_planes == 1
            c = cmap;
        else
            c = cmap(j,:);
        end
        
        patch('Faces',model.f,'Vertices',verts,'FaceVertexCData',model.c,'EdgeColor',c);
        plot3(x(1,1:i),x(2,1:i),x(3,1:i),'Color',c);  % Flight path

        axis('equal');
        view(45, 45);
        grid on;
        
        if num_planes == 1
            axis([x(1,i)-vp(1),x(1,i)+vp(1),x(2,i)-vp(2),x(2,i)+vp(2),x(3,i)-vp(3),x(3,i)+vp(3)]);
        end
    end
    
    hold off;

    drawnow;

    %Slow down the simulation display for large time steps
    if i < length(t)
        dt = t(i+1) - t(i);
        if dt > 0.1
            pause(0.001)
        end
    end
end

