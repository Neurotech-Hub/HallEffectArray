function [fitresult, gof] = smooothSpline(x, y)
%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% % % % % Plot fit with data.
% % % % figure( 'Name', 'untitled fit 1' );
% % % % h = plot( fitresult, xData, yData );
% % % % legend( h, 'y vs. x', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % % % % Label axes
% % % % xlabel( 'x', 'Interpreter', 'none' );
% % % % ylabel( 'y', 'Interpreter', 'none' );
% % % % grid on


