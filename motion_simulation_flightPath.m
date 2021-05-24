function [x, y, z] = motion_simulation_flightPath(t_vect, dt, x0, y0, z0, T_vect, psi_vect, gamma_vect, v_vect)
%% Given Variables
% Length of time vector
N_t = length(t_vect); 

% Find where the time changes are in the t_vect
pos_Tc = arrayfun(@(x) find(t_vect==x, 1),T_vect);
pos_Tc(end+1) = N_t;
N_Tc = length(pos_Tc);

%% Create heading, pitch, and velocity for each Time Change
% Equate array elements to N_Tc
if (N_Tc > length(psi_vect))
   psi_vect(length(psi_vect):N_Tc) = psi_vect(end); 
end

if (N_Tc > length(gamma_vect))
   gamma_vect(length(gamma_vect):N_Tc) = gamma_vect(end); 
end

if (N_Tc > length(v_vect))
   v_vect(length(v_vect):N_Tc) = v_vect(end); 
end

%% Extend it for all t_vect
% at the right time changes
psi_t = zeros(0, N_t); 
gamma_t = zeros(0, N_t);
v_t = zeros(0, N_t);

% -1 lookup
prev = 1;
curr = 0;
for k = 1:(N_Tc)
    % Boundary case
    % Obtain current Time Change
    curr = pos_Tc(k);
    
    % Boundary Case
    if (k == N_Tc)
        prev = pos_Tc(k-1);
        curr = pos_Tc(k)+1;
    end

    % Common Case
    psi_t(prev:curr-1) = psi_vect(k);
    gamma_t(prev:curr-1) = gamma_vect(k);
    v_t(prev:curr-1) = v_vect(k);
    
    % update previous
    prev = curr;
end


%% Generate Flight Path
%Simulate the motion
x = zeros(1,N_t);
y = zeros(1,N_t);
z = zeros(1,N_t);
    
% Summation method
for k = 1:N_t
    x(k) = x0 + dt * sum (v_t(1:k) .*cos (gamma_t(1:k)) .* cos (psi_t(1:k)) );
    y(k) = y0 + dt * sum (v_t(1:k) .*cos (gamma_t(1:k)) .* sin (psi_t(1:k)) );
    z(k) = z0 + dt * sum (v_t(1:k) .*sin (gamma_t(1:k)));
end

