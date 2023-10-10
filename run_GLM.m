% Column 1 is the dependent variable, and Columns 2 to 9 are independent variables (sensor values).

load("trainingData2.mat");

% Create a Table to Store the Data
dataTable = array2table(trainingData, 'VariableNames', {'Y', 'X1', 'X2', 'X3', 'X4', 'X5', 'X6', 'X7', 'X8'});

% Fit the General Linear Model
% Syntax: glm = fitglm(tbl, formula)
% where, tbl is the input data table and formula is a string that describes the model.

% Example: Fit a Model where Y ~ X1 + X2 + X3 + X4 + X5 + X6 + X7 + X8
glm = fitglm(dataTable, 'Y ~ X1 + X2 + X3 + X4 + X5 + X6 + X7 + X8');

% Display the Summary of GLM
disp(glm)

% Make Predictions using the Fitted Model
% Example: Predict Y for new data
newData = array2table([11, 12, 13, 14, 15, 16, 17, 18], 'VariableNames', {'X1', 'X2', 'X3', 'X4', 'X5', 'X6', 'X7', 'X8'});
predictions = predict(glm, newData);

% Display the Predictions
disp(predictions)

%%
% Predict values using the GLM
predicted_values = predict(glm, dataTable);

% Extract observed values
observed_values = dataTable.Y;

% Plot observed vs. predicted values
figure;
subplot(311);
scatter(observed_values, predicted_values, 'MarkerEdgeColor', 'b');
hold on;
plot([min(observed_values), max(observed_values)], [min(observed_values), max(observed_values)], 'k--'); % 45-degree line
xlabel('Observed Values');
ylabel('Predicted Values');
title('Observed vs. Predicted Values');
hold off;

% Calculate residuals
residuals = observed_values - predicted_values;

% Plot residuals vs. predicted values
subplot(312);
scatter(predicted_values, residuals, 'MarkerEdgeColor', 'b');
hold on;
plot([min(predicted_values), max(predicted_values)], [0, 0], 'k--'); % Reference line at 0
xlabel('Predicted Values');
ylabel('Residuals');
title('Residuals vs. Predicted Values');
hold off;

% Histogram of residuals
subplot(313);
histogram(residuals, 'EdgeColor', 'k');
xlabel('Residuals');
ylabel('Frequency');
title('Histogram of Residuals');


