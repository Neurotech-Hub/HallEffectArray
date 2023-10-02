% function searchArr_adj = hallAdjustSearchByHistory(searchArr,centerPoint)
% Define the number of elements
n = 111;

% Create a sample curve with values ranging from 0 to 1
curve = linspace(0, 1, n);

% Specify the x-axis location around which you want to attenuate
xAxisLocation = 0.5;  % Adjust this to your desired location

% Specify the attenuation factor (how much to attenuate the values)
attenuationFactor = 0.5;  % Adjust this as needed

% Calculate the distances of each element from the specified location
distances = abs(linspace(-1, 1, n) - xAxisLocation);

% Calculate the attenuation factor for each element
attenuationFactors = 1 - attenuationFactor * distances;

% Ensure that attenuation factors are between 0 and 1
attenuationFactors(attenuationFactors < 0) = 0;
attenuationFactors(attenuationFactors > 1) = 1;

% Apply the attenuation to the curve
attenuatedCurve = curve .* attenuationFactors;

figure
% Plot the original and attenuated curves
subplot(2, 1, 1);
plot(curve);
title('Original Curve');
xlabel('Element Index');
ylabel('Value');

subplot(2, 1, 2);
plot(attenuatedCurve);
title('Attenuated Curve');
xlabel('Element Index');
ylabel('Value');
