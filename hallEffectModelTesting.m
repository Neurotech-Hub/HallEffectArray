trainingData = readmatrix('/Users/mattgaidica/Library/CloudStorage/Box-Box/Neurotech Hub/Projects/TubeTrode/tubeTrode_ZAxisTest.csv');
% sensorData = trainingData(5,2:5);

close all;
clc;
% Get a list of available serial ports
availablePorts = serialportlist;
% Define the serial port settings
baudRate = 115200;
% Define the format of the data you expect (assuming 4 float values)
dataFormat = '%f\t%f\t%f\t%f';
% Specify the number of values you expect to read at once (4 in this case)
numValues = 4;

if isempty(availablePorts)
    disp('No active COM ports found.');
else
    % Display available COM ports
    fprintf('Available COM Ports:\n');
    for i = 1:numel(availablePorts)
        fprintf('%d. %s\n', i, availablePorts{i});
    end
    % Prompt the user to select a COM port
    selectedPortIndex = input('Enter the number of the COM port to use: ');

    % Validate the user's input
    if selectedPortIndex >= 1 && selectedPortIndex <= numel(availablePorts)
        selectedPort = availablePorts{selectedPortIndex};
        fprintf('Selected COM Port: %s\n', selectedPort);
        % figure('Position',[0 0 800 700]);
        try
            s = serialport(selectedPort,baudRate);
            while(true)
                % if kbhit(1)
                %     % break;
                % end
                % while isvalid(s)
                %     % Read data from the serial port
                %     data = read(s, dataFormat, numValues);
                %     % Check if the correct number of values was read
                %     if numel(data) == numValues
                %         % Process the data as needed
                %         disp(data);
                %         % [mm,k,err] =
                %         % hallEffectCalcFromFeatures(sensorData,trainingData);
                %     end
                % end
            end
        catch
            disp('Error with serial port.');
        end

        % Close and clean up the serial port
        delete(s);
        clear s;
    else
        disp('Invalid selection. Please choose a valid COM port.');
    end
end