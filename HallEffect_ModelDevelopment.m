% load("HallEffectData.mat");

% normVals = normalize(adcVals,2,"range",[0,1]);

normVals = adcVals; %normalize(adcVals);
x_large = linspace(min(x),max(x),1000);

fitVals = zeros(numel(x_large),size(normVals,2));
for ii = 1:size(normVals,2)
    f = smooothSpline(x,normVals(:,ii)'); % gauss2fit
    fitVals(:,ii) = f(x_large);
end

close all;
figure;
subplot(311);
plot(x,adcVals);
subplot(312);
plot(x,normVals);
subplot(313);
plot(x_large,fitVals);

[trainedModel, validationRMSE] = trainRegressionModel(fitVals,x_large);

