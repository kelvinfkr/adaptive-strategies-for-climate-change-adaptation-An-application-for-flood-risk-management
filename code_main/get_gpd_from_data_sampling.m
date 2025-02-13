surge_return_period_current(1,1:1000) = 5:5:5000;
for i = 2:393
return_periods = 5:5:500;  % Example return periods from 5 to 500 years
return_levels = surge_return_period_current(i,1:100);  % Corresponding return levels for each return period


% Ensure return_periods and return_levels are column vectors
return_periods = return_periods(:);
return_levels = return_levels(:);

% Apply logarithmic transformation to the return periods
log_return_periods = log(return_periods);

% Perform linear regression
X = [ones(size(return_levels)), return_levels];
y = log_return_periods;
coefficients = X \ y;

% Extract the estimated GPD parameters from the regression coefficients
mu = -coefficients(1) / coefficients(2);
sigma = 1 / coefficients(2);
k = 0;  % Assuming k = 0 for simplicity

% Define the desired return periods
desired_return_periods = 500:5:5000;

% Apply logarithmic transformation to the desired return periods
log_desired_return_periods = log(desired_return_periods);

% Estimate the return levels for the desired return periods using the GPD relationship
if k == 0
    desired_return_levels = mu + sigma * log_desired_return_periods;
else
    desired_return_levels = mu + (sigma / k) * (exp(k * log_desired_return_periods) - 1);
end
desired_return_levels = desired_return_levels-desired_return_levels(1)+(surge_return_period_current(i,100));

surge_return_period_current(i,100:1000) =desired_return_levels; 

% % Plot the results
% figure;
% plot(return_periods, return_levels, 'bo', 'MarkerSize', 6);
% hold on;
% plot(desired_return_periods, desired_return_levels, 'r-', 'LineWidth', 1.5);
% xlabel('Return Period (years)');
% ylabel('Storm Surge Return Level (m)');
% legend('Original Data', 'Estimated Return Levels', 'Location', 'best');
% grid on;
end

surge_return_period_future(1,1:1000) = 5:5:5000;
for i = 2:393
return_periods = 5:5:500;  % Example return periods from 5 to 500 years
return_levels = surge_return_period_future(i,1:100);  % Corresponding return levels for each return period


% Ensure return_periods and return_levels are column vectors
return_periods = return_periods(:);
return_levels = return_levels(:);

% Apply logarithmic transformation to the return periods
log_return_periods = log(return_periods);

% Perform linear regression
X = [ones(size(return_levels)), return_levels];
y = log_return_periods;
coefficients = X \ y;

% Extract the estimated GPD parameters from the regression coefficients
mu = -coefficients(1) / coefficients(2);
sigma = 1 / coefficients(2);
k = 0;  % Assuming k = 0 for simplicity

% Define the desired return periods
desired_return_periods = 500:5:5000;

% Apply logarithmic transformation to the desired return periods
log_desired_return_periods = log(desired_return_periods);

% Estimate the return levels for the desired return periods using the GPD relationship
if k == 0
    desired_return_levels = mu + sigma * log_desired_return_periods;
else
    desired_return_levels = mu + (sigma / k) * (exp(k * log_desired_return_periods) - 1);
end
desired_return_levels = desired_return_levels-desired_return_levels(1)+(return_levels(100));
surge_return_period_future(i,100:1000) =desired_return_levels; 

% % Plot the results
% figure;
% plot(return_periods, return_levels, 'bo', 'MarkerSize', 6);
% hold on;
% plot(desired_return_periods, desired_return_levels, 'r-', 'LineWidth', 1.5);
% xlabel('Return Period (years)');
% ylabel('Storm Surge Return Level (m)');
% legend('Original Data', 'Estimated Return Levels', 'Location', 'best');
% grid on;
end

