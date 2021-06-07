function [r, b] = latlon2dist(latlon1, latlon2)

% Inputs:
% latlon1: latlon of start point [lat lon]
% latlon2: latlon of arrival point [lat lon]
%
% Outputs:
% dist: distance calculated by haversine formula

    % earth's mean radius [km]
    radius = 6371;

    % haversine distance
    lat1 = deg2rad(latlon1(1));
    lat2 = deg2rad(latlon2(1));
    deltaLat = lat2 - lat1;
    lon1 = deg2rad(latlon1(2));
    lon2 = deg2rad(latlon2(2));
    deltaLon = lon2 - lon1;
    a = sin((deltaLat)/2)^2 + cos(lat1)*cos(lat2) * sin(deltaLon/2)^2;
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    r = radius * c;

    % orthodome angle
    y = sin(lon2 - lon1) * cos(lat2);
    x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1);
    theta = atan2(y, x);
    b = rad2deg(mod(theta + 2*pi, 2*pi));

end