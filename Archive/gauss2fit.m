function [fitresult, gof] = gauss2fit(x, y)
%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'gauss2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
% opts.Lower = [-Inf -Inf 0 -Inf -Inf 0];
% opts.StartPoint = [1.60382247694756 4 0.27452176207875 1.14778885541151 3.5 0.336242101658167];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% % % % % Plot fit with data.
% % % % figure( 'Name', 'untitled fit 1' );
% % % % h = plot( fitresult, xData, yData );
% % % % legend( h, 'y vs. x', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % % % % Label axes
% % % % xlabel( 'x', 'Interpreter', 'none' );
% % % % ylabel( 'y', 'Interpreter', 'none' );
% % % % grid on


