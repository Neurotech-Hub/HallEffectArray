% load("trainingData2.mat");
load("lookupTable.mat");
trainingData = table2array(look);
load("dataCapture.mat"); % calibration data
sensorMap = 1:8; % could rm, used for prototype sensor montage

trainingStd = [];
trainingMean = [];
trainingNorm = trainingData(:,2:end); % init
for ii = 1:width(trainingNorm)
    trainingStd(ii) = std(trainingNorm(:,ii));
    trainingMean(ii) = mean(trainingNorm(:,ii));
end

for ii = 1:height(trainingNorm)
    trainingNorm(ii,:) = (trainingNorm(ii,:) - trainingMean) ./ trainingStd;
end

sensorStd = [];
sensorMean = [];
for ii = 1:width(dataCapture)
   sensorStd(ii) = std(dataCapture(:,ii));
   sensorMean(ii) = mean(dataCapture(:,ii));
end

selectedPort = "/dev/cu.usbmodem111301"; % serialportlist
% selectedPort = "/dev/cu.usbmodem111201";

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

figure('Position',[0 0 1300 500]);
ButtonHandle = uicontrol('Style', 'PushButton', ...
                         'String', 'Stop loop', ...
                         'Callback', 'delete(gcbf)');
rows = 1;
cols = 5;

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

            % get these from calibration
            for ii = 1:numel(sensorData)
                normSense(ii) = (sensorData(ii) - sensorMean(ii)) / sensorStd(ii);
            end
            sensorFeatures = hallFeatures(normSense);
            trainingFeatures = hallFeatures(trainingNorm);

            searchArr = sum(abs(trainingFeatures-sensorFeatures),2);
            smoothSearch = smoothdata(searchArr,'gaussian',10);
            [v,k] = min(smoothSearch);

            subplot(rows,cols,1);
            bar(sensorData(sensorMap));
            ylim([0.8 1.2]);
            ylabel("Sensor Value (raw)");
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
            ylim([0 45]);
            grid on;

            subplot(rows,cols,5);
            bar(trainingData(k,1),'facecolor','r');
            hold on;
            yline(trainingData(k,1),'r:');
            title("Liquid Level");
            ylabel("A.U.");
            xticklabels([]);
            ylim([0 120]);
            hold off;

            drawnow;
            flush(s);
        end
    end
end

% Close and clean up the serial port
close all;
delete(s);
clear s;