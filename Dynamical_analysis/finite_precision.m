clear all
close all
clc

mu = 399/100;   % Parameter of "mu" values
N = 199;        % Number of iterations
x(1) = 100/399; % Initial condition
y(1) = 100/399;

for j = 1:N
    x(j+1) = mod(mu*x(j)*(1-x(j)),1);
    y(j+1) = mod(mu*y(j)-mu*y(j)^2,1);
end

figure(1)
plot(x,'Color',[.3 .3 .3]);
set(0,'DefaultAxesFontSize',22,'DefaultAxesFontName', 'Times New Roman')
xlabel('$N$','Interpreter','latex')
ylabel('$x_n$','Interpreter','latex')

figure(2)
plot(y,'Color',[.3 .3 .3]);
set(0,'DefaultAxesFontSize',22,'DefaultAxesFontName', 'Times New Roman')
xlabel('$N$','Interpreter','latex')
ylabel('$y_n$','Interpreter','latex')

aux = abs(x-y);

figure(3)
plot(aux,'Color',[.3 .3 .3]);
set(0,'DefaultAxesFontSize',22,'DefaultAxesFontName', 'Times New Roman')
xlabel('$N$','Interpreter','latex')
ylabel('$|x_n-y_n|$','Interpreter','latex')