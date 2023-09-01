% load("HallEffectData.mat");

% normVals = normalize(adcVals,2,"range",[0,1]);

normVals = normalize(adcVals);
x_large = linspace(min(x),max(x),1000);

fitVals = zeros(numel(x_large),size(normVals,2));
for ii = 1:size(normVals,2)
    f = smoothSpline(x,normVals(:,ii)'); % gauss2fit
    fitVals(:,ii) = f(x_large);
end

close all;
subplot(311);
plot(x,adcVals);
title("Raw data");
ylabel('Volts');
xlabel('Position (cm)');
legend({'Sensor1','Sensor2','Sensor3'});

subplot(312);
plot(x,normVals);
title("Normalized data");
ylabel('Z');
xlabel('Position (cm)');

subplot(313);
plot(x_large,fitVals);
title("Smoothing spline/upsampled data");
ylabel('Z');
xlabel('Position (cm)');

exportgraphics(gcf, "20230901_hallEffectSampleData.jpg");

% [trainedModel, validationRMSE] = trainRegressionModel(fitVals,x_large);

