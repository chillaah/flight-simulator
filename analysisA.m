%% EGB243 Task A - Analysis
close all; clear; clc

% Main Diagrams
% Cl vs Alpha
% Cd vs Alpha
% Cl vs Cd
% Cl/Cd vs Alpha
% Cm vs Alpha


%% Practical & Simulated Data

% Air Velocity [m/sec] | Normal Force [N] | Axial Force [N] | q [kPa] | Pitch Moment [Nm] | Pitch Angle [deg]
% Pich Angle is also the Angle of Attack

% practical data
pangM10 = importdata('Mar19131028.xlsx');
pangM8 = importdata('Mar19131130.xlsx');
pangM6 = importdata('Mar19131243.xlsx');
pangM4 = importdata('Mar19131338.xlsx');
pangM2 = importdata('Mar19131429.xlsx');
pangZERO = importdata('Mar19131613.xlsx');
pangP2 = importdata('Mar19131653.xlsx');
pangP4 = importdata('Mar19131752.xlsx');
pangP6 = importdata('Mar19131853.xlsx');
pangP8 = importdata('Mar19131938.xlsx');
pangP10 = importdata('Mar19132021.xlsx');

pracNF = [ pangM10.data(:,2);
            pangM8.data(:,2);
            pangM6.data(:,2);
            pangM4.data(:,2);
            pangM2.data(:,2);
          pangZERO.data(:,2);
            pangP2.data(:,2);
            pangP4.data(:,2);
            pangP6.data(:,2);
            pangP8.data(:,2);
           pangP10.data(:,2)];

pracAF = [ pangM10.data(:,3);
            pangM8.data(:,3);
            pangM6.data(:,3);
            pangM4.data(:,3);
            pangM2.data(:,3);
          pangZERO.data(:,3);
            pangP2.data(:,3);
            pangP4.data(:,3);
            pangP6.data(:,3);
            pangP8.data(:,3);
           pangP10.data(:,3)];
       
pracPM = [ pangM10.data(:,5);
            pangM8.data(:,5);
            pangM6.data(:,5);
            pangM4.data(:,5);
            pangM2.data(:,5);
          pangZERO.data(:,5);
            pangP2.data(:,5);
            pangP4.data(:,5);
            pangP6.data(:,5);
            pangP8.data(:,5);
           pangP10.data(:,5)];

AoA = [   pangM10.data(:,6);
           pangM8.data(:,6);
           pangM6.data(:,6);
           pangM4.data(:,6);
           pangM2.data(:,6);
         pangZERO.data(:,6);
           pangP2.data(:,6);
           pangP4.data(:,6);
           pangP6.data(:,6);
           pangP8.data(:,6);
          pangP10.data(:,6)];

      
% xtrf =   1.000 (top)        1.000 (bottom)
% Mach =   0.073     Re =     0.215 e 6     Ncrit =   9.000

%  alpha     CL        CD       CDp       Cm    Top Xtr Bot Xtr   Cpmin    Chinge    XCp  

% simulated data
simD = readtable('eppler387.txt');
simD(1:8,:) = []; simD(197,:) = []; simD(:,11:12) = []; % irrelevant
simD = table2array(simD);

simAoA = simD(:,1); % simulated AoA
simCL = simD(:,2); % simulated CL
simCD = simD(:,3); % simulated CD
simCM = simD(:,5); % simulated CM

% Coefficient General Calculations
rho = 1.225; % pressure
V = 25; % velocity
q = 0.5 * rho * V^2; % dynamic pressure
c = 0.13; b = 0.25;  % chord length & wingspan
S = b * c;


%% Cl vs AoA Plots

% Lift Calculations

% Lift = Normal * cos(alpha) - Axial * sin(alpha)
L = pracNF .* cosd(AoA) - pracAF .* sind(AoA);

% CL = Lift / (q * S)
CL = L ./ (q * S);

% max Cl prac
[maxCL, maxCLpos] = max(CL);
maxCLAoA = AoA(maxCLpos);

% max Cl sim
[maxsimCL, maxsimCLpos] = max(simCL);
maxsimCLAoA = simAoA(maxsimCLpos);

% Plots
figure(1);
hold on
grid on
box on
plot(AoA, CL, 'r', 'LineWidth', 1.5);
plot(simAoA, simCL, 'b', 'LineWidth', 1.5);
title('Coefficient of Lift vs Angle of Attack');
ylabel('C_l');
xlabel('\alpha [degrees]');
labelprop = get(gca,'ylabel');
set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
set(gca,'FontSize', 20);
legend('Practical Data','Simulated Data');
hold off


%% Cd vs AoA Plots

% Drag Calculations

% Drag = Normal * sin(alpha) + Axial * cos(alpha)
D = pracNF .* sind(AoA) + pracAF .* cosd(AoA);

% CD = Drag / (q * S)
CD = D ./ (q * S);

% min Cd prac
[minCD, minCDpos] = min(CD);
minCDAoA = AoA(minCDpos);

% min Cd sim
[minsimCD, minsimCDpos] = min(simCD);
minsimCDAoA = simAoA(minsimCDpos);

% Plots
figure(2);
hold on
grid on
box on
plot(AoA, CD, 'r', 'LineWidth', 1.5);
plot(simAoA, simCD, 'b', 'LineWidth', 1.5);
title('Coefficient of Drag vs Angle of Attack');
ylabel('C_d');
xlabel('\alpha [degrees]');
labelprop = get(gca,'ylabel');
set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
set(gca,'FontSize',20);
legend('Practical Data','Simulated Data');
hold off


%% Cl vs Cd Plots

% Plots
figure(3);
hold on
grid on
box on
plot(CD, CL);
plot(simCD, simCL);
title('Coefficient of Lift vs Coefficient of Drag');
ylabel('C_l');
xlabel('C_d');
labelprop = get(gca,'ylabel');
set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
set(gca,'FontSize',12);
legend('Practical Data','Simulated Data');
hold off


%% Cl/Cd vs AoA Plots

% Lift to Drag Ratio - Practical
LtoDratio = CL ./ CD;

% Lift to Drag Ratio - Simulation
simLtoDratio = simCL ./ simCD;

% max Cl to Cd prac
[maxCLtoCD, maxCLtoCDpos] = max(LtoDratio);
maxCLtoCDAoA = AoA(maxCLtoCDpos);

% max Cl to Cd sim
[maxsimCLtoCD, maxsimCLtoCDpos] = max(simLtoDratio);
maxsimCLtoCDAoA = simAoA(maxsimCLtoCDpos);

% Plots
figure(4);
hold on
grid on
box on
plot(AoA, LtoDratio, 'r', 'LineWidth', 1.5);
plot(simAoA, simLtoDratio, 'b', 'LineWidth', 1.5);
plot(maxCLtoCDAoA, maxCLtoCD, 'g*', 'LineWidth', 10);
plot(maxsimCLtoCDAoA, maxsimCLtoCD, 'g*', 'LineWidth', 10);
title('CL / CD vs Angle of Attack');
ylabel('^{C_l }/_{C_d}');
xlabel('\alpha [degrees]');
labelprop = get(gca,'ylabel');
set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
set(gca,'FontSize',20);
legend('Practical Data','Simulated Data','Max');
hold off


%% Cm vs AoA Plots

% Quarter Chord Moment Calculations
% Quarter Chord Moment = Pitching Moment - Normal Force * (Xbc - Xc,1/4)
Xbc = 0.08287;
Xqc = c;
M = pracPM - (pracNF .* (Xbc - Xqc));
CM = M ./ (q * S * c);
% Practical

% CM = CL ./ c * 1/4;

% Simulation


% Plots
% figure(5);
% hold on
% grid on
% box on
% plot(AoA, CM);
% plot(simAoA, simCM);
% title('Coefficient of Moment vs Angle of Attack');
% ylabel('C_m');
% xlabel('\alpha [degrees]');
% labelprop = get(gca,'ylabel');
% set(labelprop,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right');
% set(gca,'FontSize',12);
% legend('Practical Data','Simulated Data');
% hold off






