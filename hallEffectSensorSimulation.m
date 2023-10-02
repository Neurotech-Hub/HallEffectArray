% Neodymium magnet parameters
radius_mm = 10;      % Magnet radius in millimeters
thickness_mm = 3;    % Magnet thickness in millimeters
M = 1.0;             % Magnetization in A m (adjust this value)

% Conversion factor from Gauss to voltage change
gauss_to_voltage = 1.5 / 1000;

% Permeability of free space
mu0 = 4 * pi * 1e-7;

% Convert dimensions to meters
radius = radius_mm * 1e-3;
thickness = thickness_mm * 1e-3;

% Create a range of distances from the magnet's surface
r_mm = linspace(0, radius_mm*2, 100); % Going up to 2 times the radius for visualization
r = r_mm * 1e-3; % Convert to meters

% Calculate the magnetic field strength using the formula
z = thickness;
B = (mu0 * M / (4 * pi)) * (1 - (2 * z) ./ sqrt(r.^2 + z^2));

% Convert magnetic field strength to voltage change
voltage_change = (B - B(1)) * gauss_to_voltage;

% Plot the results
figure;
plot(r_mm, voltage_change, 'b-', 'LineWidth', 2);
xlabel('Distance from Magnet Surface (mm)');
ylabel('Voltage Change (V)');
title('Voltage Change vs. Distance from Magnet Surface');
grid on;

saveas(gcf,'HallEffectSensorSimulation.jpg');