close all; clear; clc

t = 1:0.1:10;
X(4,:) = ones(1, length(t) - 2);
A = randn(4,4);
B = ones(size(A,1),1);
dt = 1/t(end);
% kml stuff
for i = 2:length(t)
    if (i==find(t==3))
        %u(1)=0.1;
        X(4,i-1) = deg2rad(5);
    else
        ref(1) = 0;
        error(i-1) = X(4,i-1)-ref(1);
        K = 0.5;
        u(1) = K*error(i-1);
    end
    % Integration using Euler method
    X_d = A * X(:,i-1) + B * u;
    X(:,i) = X(:,i-1) + dt*X_d;
end

C = eye(4);
D = zeros(size(C,2),1);