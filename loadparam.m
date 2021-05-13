function [ c ] = loadparam(aircraft)

% Note this file will load the aircraft parameters. This include the 
% physical parameters such as mass, inertia, wing span, etc. As well as the
% aerodynamic coefficients and environmental parameters (air density).

% There is no expectation to know and understand how these parameters are
% derived, but you are expected to be able to source them if required (textbook,
% online, library etc.).

if strcmp(aircraft,'A-4D')
    %----------------------------------------------------------------------
    %               Define Aircraft Characteristics
    %----------------------------------------------------------------------
    
    % Aircraft Parameters (at M = 0.8 and alt = 40,000)
    c.rho = 3.65;       % Density           (kg/m^3)
    c.g = 9.80665;      % Gravity           (m/s^2)
    c.m = 7990.0;       % Mass              (kg)
    c.Ix = 10968.5672;  % Inertia x         (kg m^2)
    c.Iy = 35115.684905;% Inertia y         (kg*m^2)
    c.Iz = 34166.6123;  % Inertia z         (kg*m^2)
    c.Ixz = 1762.56333; % Inertia xz        (kg*M^2)
    c.S = 24.154;       % Wing Surface Area (m^2)
    c.b =8.38;          % Wing Span         (m)
    c.cbar = 3.3;       % Mean Chord Length (m)

    % Longitudinal Characteristics/Coefficients 
    % (at M = 0.8 and alt = 35,000)
    c.CL = 0.3;
    c.CD = 0.038;
    c.CLa = 4.0;
    c.CDa = 0.56;
    c.Cma = -0.41;
    c.CLa = 1.12;
    c.Cmad = -1.65;
    c.CLq = 0.0;
    c.Cmq = -4.3;
    c.CLM = 0.15;
    c.CDM = 0.03;
    c.Cmu = -0.05; 
    c.CLde = 0.4;
    c.CZde = 0; 
    c.CMde = -0.60;
    c.CZ_alphad = 0.0;
    c.Czq = 0.0;
    c.AR = (c.b^2)/c.S;
    c.CL0 = c.CL; 
    c.CDi = (c.CL^2)/(pi*c.AR*exp(1));
    c.CD0 = c.CD - c.CDi;
         
    % Lateral Characteristics/Coefficients (at M = 0.8 and alt = 35,000)
    c.Cyb = -1.04;
    c.Clb = -0.14;   
    c.Cnb = 0.27;
    c.Clp = -0.24;
    c.Cnp = 0.029;
    c.Clr = 0.17;
    c.Cnr = -0.39;
    c.Clda = 0.072;
    c.Cnda = 0.04;
    c.Cyda = 0;
    c.Cydr = 0.17;
    c.Cldr = -0.105;
    c.Cndr = 0.032;
    c.Cyp = 0;
    c.Cyr = 0;

elseif strcmp(aircraft,'B747')
    % Aircraft Characteristics for a B747
    % Flight Parameters - See Lecture slides and notes
    
    % Aircraft Parameters (at M = 0.8 and alt = 40,000)
    c.rho = 0.3045;             % Density     (slug/ft^3)
    c.W = 288773.232;           % weight      (kg) 
    c.g = 9.80;                 % Gravity     (m/s^2)
    c.m = c.W/c.g;              % Mass        (kg)
    c.Ix = 24675886.69;         % Inertia x         (kg m^2)
    c.Iy = 44877574.145;        % Inertia y         (kg*m^2)
    c.Iz = 67384152.11500001;   % Inertia z         (kg*m^2)
    c.Ixz = 1315143.4115000002; % Inertia xz        (kg*M^2)
    c.S = 510.96;               % Wing Surface Area (m^2)
    c.b = 59.64;                % Wing Span         (m)
    c.cbar = 8.32;              % Mean Chord Length (m)
    
    % Longitudinal Characteristics/Coefficients 
    % (at M = 0.8 and alt = 40,000)
    c.CL = 0.66;
    c.CD = 0.0415;
    c.CDo = 0.0415;
    c.CDu = 0;
    c.CLu = 0;
    c.CLa = 4.92;
    c.CDa = 0.425;
    c.Cma = -1.03;
    c.CLad = 5.91;
    c.Cmad = -6;
    c.CLq = 6.58;
    c.Cmq = -24;
    c.CLM = 0.2;
    c.CDM = 0.0275;
    c.CmM = -0.10;
    c.CLde = 0.3;
    c.CMde = -1.2;
    c.CZq = 0;
    c.Czad = 0;
    c.Cza = -c.CLa - c.CDo;
    c.CZde = 0;
    c.Cmu = 0;
    c.Cmq = -4.3;
    c.CZ_alphad = 0.0;
    c.Czq = 0.0;
    c.AR = (c.b^2)/c.S;
    c.CL0 = c.CL; 
    c.CDi = (c.CL^2)/(pi*c.AR*exp(1));
    c.CD0 = c.CD - c.CDi;
         
    % Lateral Characteristics/Coefficients (at M = 0.8 and alt = 40,000)
    c.Cyb = -1.04;
    c.Clb = -0.14;   
    c.Cnb = 0.27;
    c.Clp = -0.24;
    c.Cnp = 0.029;
    c.Clr = 0.17;
    c.Cnr = -0.39;
    c.Clda = 0.072;
    c.Cnda = 0.04;
    c.Cyda = 0;
    c.Cydr = 0.17;
    c.Cldr = -0.105;
    c.Cndr = 0.032;
    c.Cyp = 0;
    c.Cyr = 0;
    
    
elseif strcmp(aircraft,'navion')
    % Aircraft Characteristics for a general aviation aircraft
    
    % Flight Parameters - See if you can source these (check Nelson, Flight
    % Stability and Automatic Control or other Aerodynamics texts/online
    % sources.
    
    
    
else 
    c = [];
    warning('No matching aircraft found');

end
