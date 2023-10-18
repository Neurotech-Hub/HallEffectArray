function [mm,k,err] = hallEffectCalcFromFeatures(sensorData,trainingData)
doPlot = true;
% % mmHistory = 51;
trainingFeatures = hallFeatures(trainingData(:,2:end));
sensorFeatures = hallFeatures(sensorData);

searchArr = NaN(height(trainingData),1);
sensorFeatureDiff = NaN(height(trainingData),width(trainingFeatures));
for ii = 1:height(trainingFeatures)
    sensorFeatureDiff(ii,:) = abs(sensorFeatures-trainingFeatures(ii,:));
    % searchArr(ii) = sum(sensorFeatureDiff(ii,:));
end

sensorDiff = abs(trainingData(:,2:end)-sensorData);
% [~,multMask] = sort(sensorData);
% multMask = (numel(sensorData)-multMask); % shape for multiplication
searchArr = sum(sensorDiff,2).^2;
searchArr = smoothdata(searchArr,'gaussian',10);
[err,k] = min(searchArr);
mm = trainingData(k,1);

% use mmHistory to break a "tie"
% % windowWidth = 5;
% % for ii = mmHistory-windowWidth:mmHistory+windowWidth
% % 
% % end

if doPlot
    rows = 3;
    cols = 5;
    % close all;
    % figure('Position',[0 0 800 700]);
    % set(gcf,'color','w');
    subplot(rows,cols,1:5);
    plot(trainingData(:,1),trainingData(:,2:end),'linewidth',2);
    title("Training Data");
    legend(compose("S%i",1:width(trainingData)-1),'autoupdate','off');
    xlim([min(trainingData(:,1)),max(trainingData(:,1))]);
    xlabel('mm');
    ylabel("sensor (V)");
    hold on;
    xline(trainingData(k,1),'r-','LineWidth',2);
    hold off;
    grid on;

    subplot(rows,cols,7:8);
    imagesc(trainingFeatures');
    set(gca,'ydir','normal');
    colormap(jet);
    c = colorbar; % grab clim
    title("Features");
    xlabel("mm");

    subplot(rows,cols,6);
    imagesc(sensorFeatures');
    set(gca,'ydir','normal');
    colormap(jet);
    % colorbar;
    clim(c.Limits);
    title("Sensors");
    xticks(1);
    xticklabels({"Currnet Position"});
    ylabel("sensor");

    subplot(rows,cols,9:10);
    imagesc(sensorFeatureDiff');
    set(gca,'ydir','normal');
    colormap(jet);
    colorbar;
    title("Sensors-Features [abs(diff)]");
    xlabel("mm");

    subplot(rows,cols,11:15);

    yyaxis right;
    plot(trainingData(:,1),searchArr,'k-','linewidth',2);
    title("Lookup Search (find minimum)");
    xlabel('mm');
    xline(trainingData(k,1),'r-','LineWidth',2);
    xlim([min(trainingData(:,1)),max(trainingData(:,1))]);
    yticks([]);

    yyaxis left;
    imagesc(trainingData(:,1),[0,1],searchArr');
    yticks([]);
    ylabel("sum(abs(diff))");
    drawnow;
end