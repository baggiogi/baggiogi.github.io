%% Kalman one-step prediction applied to 2016 US president polls data
clc
clear all
close all

%% Loading and plotting data...

% loading data... (1st column polls date (in absolute matlab format), 
% 2nd column Clinton data, 3rd column Trump data)
load('USpresident_polls_data_2016.mat');

% plots polls data
fig = figure('Position', [100, 100, 1000, 600]);
scatter(polls_data(:,1),polls_data(:,2),'r.')
hold on
scatter(polls_data(:,1),polls_data(:,3),'b.')
datetick('x','dd mmm yy','keeplimits','keepticks')
hold on

%% Kalman prediction

% simplest state space model: x(t+1) = x(t) + v(t), y(t) = y(t) + w(t)
mA = 1;
mB = 1; % st. dev. v(t)
mC = 1;
mD = 5; % st. dev. w(t)

sys = ss(mA,mB,mC,mD,-1);

iN = length(polls_data);
cvU = randn(iN,1);
cvT = [polls_data(:,1);polls_data(end,1)+1];

% initialization step
cvX0C = 40+randn(1,1);
mP0C = 1;
cvX0T = 40+randn(1,1);
mP0T = 1;

cvYhatC = zeros(1,iN);
cvYhatC(1) = nan;
cvYhatT = zeros(1,iN);
cvYhatT(1) = nan;

% Kalman prediction
for t=2:iN+1
    [cvXhattmpC,mPtmpC] = predKalman(sys,polls_data(t-1,2),cvX0C,mP0C);
    cvYhatC(t) = mC*cvXhattmpC;
    cvX0C = cvXhattmpC;
    mP0C = mPtmpC;
    
    [cvXhattmpT,mPtmpT] = predKalman(sys,polls_data(t-1,3),cvX0T,mP0T);
    cvYhatT(t) = mC*cvXhattmpT;
    cvX0T = cvXhattmpT;
    mP0T = mPtmpT;
end

% plotting results...

plot(cvT,cvYhatC, ...
    'LineStyle', '-',...
    'LineWidth', 1.5,...
    'Color', [1 0 0]);
hold on
plot(cvT,cvYhatT, ...
    'LineStyle', '-',...
    'LineWidth', 1.5,...
    'Color', [0 0 1]);

legend({'Clinton polls data','Trump polls data','Clinton one-step pred.', 'Trump one-step pred.'})

ax = gca;
ax.FontUnits = 'points';
ax.FontSize = 18;
ax.Legend.Interpreter = 'latex';
ax.Legend.FontSize = 18;
ax.Legend.Location = 'southeast';
ax.Legend.Orientation = 'vertical';
ax.Legend.Box = 'on';
ax.Legend.Color = [0.95 0.95 0.95];
ax.XLim = [736276 736644];
ax.YLabel.Interpreter = 'latex';
ax.YLabel.String = 'poll value [$\%$]';
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridLineStyle = ':';
ax.TickLabelInterpreter = 'latex';
ax.Units = 'normalized';
ax.TickLength = [0.02 0.02];
ax.LineWidth = 1.5;
ax.TickDir = 'in';


% Prediction result on election day
disp('======================================================')
disp('Prediction result on election day (8th Nov 2016)')
if cvYhatT(end) > cvYhatC(end)
    disp('The winner is: Donald Trump!')
    disp(['Votes: ' num2str(cvYhatT(end)) '%, st. dev.: ' num2str(sqrt(mP0T(end))) '%'])
else
    disp('The winner is: Hillary Clinton!')
    disp(['Votes: ' num2str(cvYhatC(end)) '%, st. dev.: ' num2str(sqrt(mP0C(end))) '%'])
end
disp('======================================================')
