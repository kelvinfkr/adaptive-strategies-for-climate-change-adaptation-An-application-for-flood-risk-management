function [meanCond, sigmaCond] = conditionalMVN(mean, sigma, observed_values)
    n = length(observed_values);
    sql = length(mean);
    observed_set = 1:n;
    conditiona_set = (n+1):sql;

    
    sigma_11 = sigma(observed_set,observed_set);
    sigma_12 = sigma(observed_set,conditiona_set);
    sigma_21 = sigma_12';
    sigma_22 = sigma(conditiona_set,conditiona_set);

    temp = sigma_21*(sigma_11)^(-1);
    meanCond = mean(conditiona_set)' + temp*(observed_values-mean(observed_set))';
    
    sigmaCond = sigma_22 - sigma_21*(sigma_11)^(-1)*sigma_12; 
end