function [meanCond, sigmaCond] = conditionalMVN(mean, sigma, n, observed_values)
    % Check if n is valid
    if n <= 0 || n > length(mean)
        error('Invalid value of n.');
    end

    % Split the mean and covariance matrix into observed and unobserved parts
    mean_observed = mean(1:n);
    mean_unobserved = mean(n+1:end);
    sigma_observed = sigma(1:n, 1:n);
    sigma_unobserved = sigma(n+1:end, n+1:end);
    sigma_cross = sigma(1:n, n+1:end);

    % Calculate conditional mean and covariance
    meanCond = mean_unobserved + sigma_cross' * (sigma_observed \ (observed_values - mean_observed));
    sigmaCond = sigma_unobserved - sigma_cross' * (sigma_observed \ sigma_cross);
end