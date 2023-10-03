load("trainingData.mat");
% [trainedModel, validationRMSE] = trainRegressionModel(trainingData);

selectedPort = "/dev/cu.usbmodem111301"; % serialportlist
close all;
clc;
% Define the serial port settings
baudRate = 115200;
% Define the format of the data you expect (assuming 4 float values)
dataFormat = '%f\t%f\t%f\t%f';
numValues = 4;

fprintf('Selected COM Port: %s\n', selectedPort);
try
    s = serialport(selectedPort,baudRate);
catch
    delete(s);
    clear s;
    s = serialport(selectedPort,baudRate);
end

figure('Position',[0 0 800 700]);
ButtonHandle = uicontrol('Style', 'PushButton', ...
                         'String', 'Stop loop', ...
                         'Callback', 'delete(gcbf)');

while(ishandle(ButtonHandle))
    if isvalid(s)
        % Read data from the serial port
        % data = read(s, dataFormat, numValues);
        dataString = readline(s);
        dataValues = strsplit(dataString,'\t');    % split at tab characters
        % Check if the correct number of values was read
        if numel(dataValues) == numValues
            sensorData = cellfun(@str2double, dataValues); % convert each split string to double
            [mm,k,err] = hallEffectCalcFromFeatures(sensorData,trainingData);
            % disp(trainedModel.predictFcn(sensorData));
            drawnow;
        end
    end
end

% Close and clean up the serial port
close all;
delete(s);
clear s;
