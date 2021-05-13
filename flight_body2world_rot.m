function [ y ] = flight_body2world_rot( X, t, u0, pos_start )
 
% Input:
%       x: Body Velocity Changes [d_u
%                                 d_w 
%                                 d_q 
%                                 d_theta
%                                 d_v
%                                 d_p
%                                 d_r
%                                 d_phi]
%       t: Time Vector
%       u0: Initial Velocity (body x axis) / Ref Flight condition
%       pos_start: Initial World Position (x,y,z)
%
% Output:
%       y: World State Vector [pos, vel, euler, dot(euler)]

%%    % Preallocate our extended state matrix
    y = zeros(length(X),12);
    
    % Initialise World State    
    y(1,1:3) = pos_start;       % Position
    y(1,4:6) = [u0 0 0]';       % Velocity (We can do this because the frames are initially aligned)
    y(1,7:9) = zeros(3,1);      % Euler Angles
    y(1,10:12) = zeros(3,1);    % Euler Rates
    
    for i = 2:length(X)     
        dt = t(i) - t(i-1);
        
        % body angle rates
        phi_b = X(i,8);     % roll
        theta_b = X(i,3);   % pitch
        psi_b = 0;          % yaw

        % Rot from body to world
        rot_angrates = [1 sin(phi_b)*tan(theta_b) cos(phi_b)*tan(theta_b);
                        0 cos(phi_b) -sin(phi_b);
                        0 sin(phi_b)*sec(theta_b) cos(phi_b)*sec(theta_b)];
        y(i,10:12) = rot_angrates*[X(i,6) X(i,3) X(i,7)]';
        
        % --------------------- IMPORTANT NOTE ----------------------------
        % Strictly speaking, we actually had to rotate the body angular
        % rates into roll, pitch and yaw rates then use these to update the
        % roll, pitch and yaw angle before we create the DCM above (R).
        %------------------------------------------------------------------
           
        % Update Euler Angles
        y(i,7:9) = y(i-1,7:9) + dt*y(i,10:12); 
        
        phi = 0 + y(i,7);    % Roll Angle (ref phi + change)        
        theta = 0 + y(i,8);  % Pitch Angle (ref pitch + change)
        psi = 0 + y(i,9);    % Yaw Angle (ref psi + change)
              
        % Construct the DCM
        Rx = [1,         0,         0; ...
              0,  cos(phi), -sin(phi); ...
              0,  sin(phi),  cos(phi)];
         
        Ry = [ cos(theta), 0, sin(theta); ...
                        0, 1,          0; ...
              -sin(theta), 0, cos(theta)];
         
        Rz = [cos(psi), -sin(psi), 0; ...
              sin(psi),  cos(psi), 0; ...
                     0,         0, 1];
        
        R = Rz*Ry*Rx;

        % Find the Body Velocity (ref + change)   
        vb(1) = u0 + X(i-1,1);  % Vx (ref x vel + change)
        vb(2) = 0 + X(i-1,5);   % Vy velocity is not simulated
        vb(3) = 0 + X(i-1,2);   % Vz (ref z vel + change)
        
        % Find World Velocity    
        vw = R'*vb';    
        y(4:6,i) = vw;
        
        % Find World Position
        y(i,1:3) = y(i-1,1:3) + vw'*dt;     
          
    end

end