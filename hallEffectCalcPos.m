% function mm = hallEffectCalcPos(sensorData)

doPlot = true;
trainingData = readmatrix('/Users/mattgaidica/Library/CloudStorage/Box-Box/Neurotech Hub/Projects/TubeTrode/tubeTrode_ZAxisTest.csv');
sensorData = trainingData(35,2:5); % !!RM
% !! these could be derived from a calibration routine
sensorMean = zeros(1,4);
sensorStd = zeros(1,4);
sensorNorm = zeros(1,4);
trainingNorm = zeros(height(trainingData),4); % 4 sensors
for ii = 1:4
    sensorMean(1,ii) = mean(trainingData(:,ii+1));
    sensorStd(1,ii) = std(trainingData(:,ii+1));
    sensorNorm(1,ii) = (sensorData(ii) - sensorMean(ii)) / sensorStd(ii);
    trainingNorm(:,ii) = (trainingData(:,ii+1) - sensorMean(ii)) / sensorStd(ii);
end

minPos = 0;
minVal = NaN;
diffArr = zeros(height(trainingNorm),1);
% lookup minimum deviation row: use a loop for Arduino
for ii = 1:height(trainingData)
    for jj = 1:4
        diffArr(ii,1) = diffArr(ii,1) + abs(trainingNorm(ii,jj) - sensorNorm(jj));
    end
end
% estimate pos
[k,mm] = min(diffArr);
lColors = lines(5);
if doPlot
    lws = [2,0.5];
    titleLabels = {"Training Data (normalized)","Sensor Values"};
    legendLabels = {["T1","T2","T3","T4"],["S1","S2","S3","S4","diff"]};
    rows = 2;
    cols = 1;
    close all;
    figure('Position',[0 0 800 700]);
    for ii = 1:2
        subplot(rows,cols,ii);
        plot(trainingNorm,'linewidth',lws(ii));
        title(titleLabels{ii});
        legend(legendLabels{ii},'autoupdate','off');
        xlim([1,height(trainingData)]);
        xlabel('mm');
        ylabel("Z");
    end
    hold on;
    for ii = 1:4
        yline(sensorNorm(ii),'--','color',lColors(ii,:),'linewidth',2);
    end
    xline(mm,'r','linewidth',2);
    yyaxis right;
    plot(diffArr,'r','linewidth',3);
    set(gca,'ycolor','r');
    ylabel('diff');
end