%% Test script for functions predKalman and predKalmanSS
clc
clear all
close all

% state space model (mB and mD are weighted by the standard deviations of
% v(t) and w(t))
mA = [-1 0.5; 0 0.5];
mB = 0.1*[1; 0];
mC = [1 0.5];
mD = 0.1;

sys = ss(mA,mB,mC,mD,-1);

% generating measurements and ground truth values
cvU = randn(31,1);
cvT = 0:30;
cvX0sim = [1; 0];
cvYmeas = lsim(sys,cvU,cvT,cvX0sim)+randn(31,1);
cvYreal = lsim(sys,zeros(31,1),cvT,cvX0sim);

% initialization step
cvX0 = randn(2,1);
mP0 = eye(2);

cvYhat = zeros(1,31);
cvYhatSS = zeros(1,31);
cvYhat(1) = nan;
cvYhatSS(1) = nan;

% Kalman prediction
for t=2:31
    [cvXhattmp,mPtmp] = predKalman(sys,cvYmeas(t-1),cvX0,mP0);
    [cvXhattmpSS,~] = predKalmanSS(sys,cvYmeas(t-1),cvX0);
    cvYhat(t) = mC*cvXhattmp;
    cvYhatSS(t) = mC*cvXhattmpSS;
    cvX0 = cvXhattmp;
    mP0 = mPtmp;
end

% plotting results

rvT = 0:30;
fig = figure('Position', [100, 100, 1000, 600]);
plot(rvT,cvYreal, ...
    'LineStyle', '-',...
    'LineWidth', 1.5,...
    'Color', [0 0 0]);
hold on
plot(rvT,cvYhat, ...
    'LineStyle', '-',...
    'LineWidth', 1.5,...
    'Color', [1 0 0]);
hold on
plot(rvT,cvYhatSS, ...
    'LineStyle', '-',...
    'LineWidth', 1.5,...
    'Color', [0 0 1]);
hold on
scatter(rvT,cvYmeas,'*');

legend({'$y(t)$','$\hat{y}(t|t-1)$','$\hat{y}_\infty(t|t-1)$','measurements'})

ax = gca;
ax.FontUnits = 'points';
ax.FontSize = 22;
ax.Legend.Interpreter = 'latex';
ax.Legend.FontSize = 22;
ax.Legend.Location = 'northoutside';
ax.Legend.Orientation = 'horizontal';
ax.Legend.Box = 'off';
ax.Legend.Color = [0 0 0];
ax.XLabel.Interpreter = 'latex';
ax.XLabel.String = '$t$';
ax.XLim = [0 30];
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridLineStyle = ':';
ax.TickLabelInterpreter = 'latex';
ax.Units = 'normalized';
ax.TickLength = [0.02 0.02];
ax.LineWidth = 1.5;
ax.TickDir = 'in';
