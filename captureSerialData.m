close all;
baudRate = 115200;
dataFormat = '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t';
fprintf('Selected COM Port: %s\n', selectedPort);

try
    s = serialport(selectedPort,baudRate);
catch
    delete(s);
    clear s;
    s = serialport(selectedPort,baudRate);
end

figure('Position',[0 0 200 200]);
ButtonHandle = uicontrol('Style', 'PushButton', ...
                         'String', 'Stop loop', ...
                         'Callback', 'delete(gcbf)');
rows = 1;
cols = 4;

dataCapture = [];
iData = 0;
fprintf("\n\nStarting sensor capture...\n\n");
while(ishandle(ButtonHandle))
    if isvalid(s)
        % Read data from the serial port
        % data = read(s, dataFormat, numValues);
        dataString = readline(s);
        dataValues = strsplit(dataString,'\t');    % split at tab characters
        dataValues = dataValues(1:end-1); % !! last tab character
        % Check if the correct number of values was read
        if numel(dataValues) == 8
            sensorData = cellfun(@str2double, dataValues); % convert each split string to double
            fprintf("%i",iData);
            disp(sensorData);
            iData = iData + 1;
            dataCapture(iData,:) = sensorData;
            pause(0.1);
        end
    end
end
save("dataCapture","dataCapture");
disp("Saved");