

return_periods = 5:5:500;  % Example return periods from 5 to 500 years
return_levels = surge_return_period_current(2,:);  % Corresponding return levels for each return period

initial_params = [0.1, 1];  % Initial guess for shape (k) and scale (sigma) parameters
options = optimset('Display', 'iter');

estimated_params = fminsearch(@(params) negloglik(params, return_levels), initial_params, options);

k = estimated_params(1);
sigma = estimated_params(2);
threshold = min(return_levels);

desired_return_periods = 500:5:5000;  % Example desired return periods from 500 to 5000 years
desired_exceedance_prob = 1 ./ desired_return_periods;
desired_return_levels = gpinv(desired_exceedance_prob, k, sigma, threshold);

figure;
plot(return_periods, return_levels, 'bo', 'MarkerSize', 6);
hold on;
plot(desired_return_periods, desired_return_levels, 'r-', 'LineWidth', 1.5);
xlabel('Return Period (years)');
ylabel('Storm Surge Return Level (m)');
legend('Original Data', 'Estimated Return Levels', 'Location', 'best');
grid on;