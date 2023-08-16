% Logistic Map mod 1 - Lyapunov Exponent Spectrum

clear all;
close all;
clc;

M = 500;              % Total number of "mu" values to simulate
a = 254;              % Starting value of the parameter "mu"
b = 258;              % Final value of the parameter "mu"
mu = linspace(a,b,M); % Vector of "mu" values
N = 1499;             % Number of iterations
x(1) = 0.1;           % Initial condition

for i = 1:length(mu)
    sum = 0;
    for j = 1:N
        x(j+1) = mod(mu(i)*x(j)*(1-x(j)),1);  % Logistic map
        sum = sum+log(abs(mu(i)*(1-2*x(j))));
    end
    LE(i) = sum/N;                            % Lyapunov exponent
end

figure(1)
plot(mu,LE,'LineStyle','none','MarkerSize',5,'Marker','.','Color',[.3 .3 .3]);
hold on
A=[254;258];
B=[0;0];
plot(A,B,'r')
hold off
set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName', 'Times New Roman')
xlabel('$\mu$','Interpreter','latex')
ylabel('Lyapunov exponent','Interpreter','latex')