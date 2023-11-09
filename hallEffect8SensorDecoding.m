load("trainingData2.mat");
sensorMap = [8,4,7,3,6,2,5,1];

trainingStd = [];
trainingMean = [];
trainingNorm = trainingData(:,2:end);
for ii = 1:width(trainingNorm)
    trainingStd(ii) = std(trainingNorm(:,ii));
    trainingMean(ii) = mean(trainingNorm(:,ii));
    trainingNorm(:,ii) = normalize(trainingNorm(:,ii));
end

selectedPort = "/dev/cu.usbmodem111301"; % serialportlist
selectedPort = "/dev/cu.usbmodem111201";

close all;
clc;

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

figure('Position',[0 0 1200 500]);
ButtonHandle = uicontrol('Style', 'PushButton', ...
                         'String', 'Stop loop', ...
                         'Callback', 'delete(gcbf)');
rows = 1;
cols = 4;

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
            normSense = sensorData;
            for ii = 1:numel(sensorData)
                normSense(ii) = (sensorData(ii) - trainingMean(ii)) / trainingStd(ii);
            end

            searchArr = sum(abs(trainingNorm-normSense),2);
            smoothSearch = smoothdata(searchArr,'gaussian',10);
            [v,k] = min(smoothSearch);

            subplot(rows,cols,1);
            bar(normSense(sensorMap));
            ylim([-4 4]);
            ylabel("Sensor Value (Z)");
            xlabel("Sensor #");
            title("Sensor Values");

            subplot(rows,cols,2:4);
            plot(trainingData(:,1),searchArr);
            hold on;
            plot(trainingData(:,1),smoothSearch,'r','LineWidth',2);
            xline(trainingData(k,1),'r:');
            xlim([trainingData(1,1),trainingData(end,1)]);
            ylabel("Sensor Distance (Z)");
            xlabel("mm");
            title("Search Minimization");
            hold off;

            drawnow;
        end
    end
end

% Close and clean up the serial port
close all;
delete(s);
clear s;