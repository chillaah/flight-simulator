function [x, y, z] = motion_simulation_flightPath(t_matrix, dt, x0, y0, z0, T_vect, psi_matrix, gamma_vect, v_matrix)
%% Given Variables
% Length of time vector
t_forN = length(t_matrix); 

% Find where the time changes are in the t_vect
position_Tc = arrayfun(@(x) find(t_matrix==x, 1),T_vect);
position_Tc(end+1) = t_forN;
Tc_forN = length(position_Tc);

%% Create heading, pitch, and velocity for each Time Change
% Equate array elements to N_Tc
if (Tc_forN > length(psi_matrix))
   psi_matrix(length(psi_matrix):Tc_forN) = psi_matrix(end); 
end

if (Tc_forN > length(gamma_vect))
   gamma_vect(length(gamma_vect):Tc_forN) = gamma_vect(end); 
end

if (Tc_forN > length(v_matrix))
   v_matrix(length(v_matrix):Tc_forN) = v_matrix(end); 
end

%% Extend it for all t_vect
% at the right time changes
psi_t = zeros(0, t_forN); 
gamma_t = zeros(0, t_forN);
v_t = zeros(0, t_forN);

% -1 lookup
prev = 1;
curr = 0;
for k = 1:(Tc_forN)
    % Boundary case
    % Obtain current Time Change
    curr = position_Tc(k);
    
    % Boundary Case
    if (k == Tc_forN)
        prev = position_Tc(k-1);
        curr = position_Tc(k)+1;
    end

    % Common Case
    psi_t(prev:curr-1) = psi_matrix(k);
    gamma_t(prev:curr-1) = gamma_vect(k);
    v_t(prev:curr-1) = v_matrix(k);
    
    % update previous
    prev = curr;
end


%% Generate Flight Path
%Simulate the motion
x = zeros(1,t_forN);
y = zeros(1,t_forN);
z = zeros(1,t_forN);
    
% Summation method
for k = 1:t_forN
    x(k) = x0 + dt * sum (v_t(1:k) .*cos (gamma_t(1:k)) .* cos (psi_t(1:k)) );
    y(k) = y0 + dt * sum (v_t(1:k) .*cos (gamma_t(1:k)) .* sin (psi_t(1:k)) );
    z(k) = z0 + dt * sum (v_t(1:k) .*sin (gamma_t(1:k)));
end

