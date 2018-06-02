function bT = testSchur(rvP,rvQ)
% TEST SCHUR test if a product of two polynomials is Schur stable and plot
% the product of polynomials in the interval [-10,10]
% Inputs:   - rvP,rvQ: input polynomials
% Outputs:  - bT: set to true if the product polynomial is stable, set to
% false otherwise

rvProdPQ = conv(rvP,rvQ);
if abs(roots(rvProdPQ))<1
    bT = true;
else
    bT = false;
end

rvT = -10:0.01:10;

plot(rvT,polyval(rvProdPQ,rvT), ...
    'LineStyle', '-',...
    'LineWidth', 2,...
    'Color', [0 0 0]);

ax = gca;
ax.FontUnits = 'points';
ax.FontSize = 22;
ax.XLabel.Interpreter = 'latex';
ax.XLabel.String = '$x$';
ax.XLim = [-10 10];
ax.YLabel.Interpreter = 'latex';
ax.YLabel.String = '$p(x)q(x)$';
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridLineStyle = ':';
ax.TickLabelInterpreter = 'latex';
ax.Units = 'normalized';
ax.TickLength = [0.02 0.02];
ax.LineWidth = 1.5;
ax.TickDir = 'in';

end