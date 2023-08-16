% Logistic Map mod 1 - Bifurcation Diagram

clear all;
close all;
clc;

M = 500;              % Total number of "mu" values to simulate
a = 254;              % Starting value of the parameter "mu"
b = 258;              % Final value of the parameter "mu"
Mu = linspace(a,b,M); % Vector of "mu" values
N = 1499;             % Number of iterations

for i = 1:length(Mu)
    x = zeros(N,1);   % Allocate memory
    x(1) = 0.5;       % Initial condition
    mu = Mu(i);
    for j = 1:N
        x(j+1) = mod(mu*x(j)*(1-x(j)),1);
    end
    out{i} = unique(round(10000*x(end-999:end))); % Save unique values
end

% Rearrange cell array
data = [];
for k = 1:length(Mu)
    n = length(out{k});
    data = [data; Mu(k)*ones(n,1),out{k}];
end

figure(1)
plot(data(:,1),data(:,2)/10000,'LineStyle','none','MarkerSize',1,'Marker','.','Color',[.3 .3 .3]);
set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName', 'Times New Roman')
xlabel('$\mu$','Interpreter','latex')
ylabel('$x$','Interpreter','latex')