clear all;
close all;
clc;

% Logistic Map
mu = 4;     % Parameter of "mu" values
N = 10000;  % Number of iterations
x(1) = 0.3; % Initial condition

for j = 1:N
    x(j+1) = mu*x(j)*(1-x(j));
end

figure(1)
plot(x(1:end-1),x(2:end),'LineStyle','none','Marker','.','Color',[.3 .3 .3]);
set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName', 'Times New Roman')
xlabel('$x_{n}$','Interpreter','latex')
ylabel('$x_{n+1}$','Interpreter','latex')

% Logistic Map - Mod 1 - Example 1
mu = 128;   % Parameter of "mu" values
N = 10000;  % Number of iterations
x(1) = 0.3; % Initial condition

for j = 1:N
    x(j+1) = mod(mu*x(j)*(1-x(j)),1);
end

figure(2)
plot(x(1:end-1),x(2:end),'LineStyle','none','Marker','.','Color',[.3 .3 .3]);
set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName', 'Times New Roman')
xlabel('$x_{n}$','Interpreter','latex')
ylabel('$x_{n+1}$','Interpreter','latex')

% Logistic Map - Mod 1 - Example 2
mu = 256;   % Parameter of "mu" values
N = 10000;  % Number of iterations
x(1) = 0.3; % Initial condition

for j = 1:N
    x(j+1) = mod(mu*x(j)*(1-x(j)),1);
end

figure(3)
plot(x(1:end-1),x(2:end),'LineStyle','none','Marker','.','Color',[.3 .3 .3]);
set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName', 'Times New Roman')
xlabel('$x_{n}$','Interpreter','latex')
ylabel('$x_{n+1}$','Interpreter','latex')