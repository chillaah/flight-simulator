%% EGB243 Task B Part 3 - Flight Guidance, Navigation & Control Software

% Given a nominal aircraft departure (start) time and cruise speed (consistent with general
% aviation aircraft), augment your software to calculate expected arrival times and indicate
% 10-minute markers (locations) along the track.

 % start time [hrs]
start = 1200;
% the typical cruising airspeed for a long-distance commercial passenger 
% aircraft is approximately 880–926 km/h
cruisespeed = (926 - 880)/2;
% path distance [km]
distance = 1000;
% time to fly
time = cruisespeed / distance;
%
hours = fix(time);
mins = (time - hours) * 60;
arrivaltime = start + (hours*100) + mins;




