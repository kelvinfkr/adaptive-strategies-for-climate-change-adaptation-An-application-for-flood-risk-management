function current_bdp_level = partial_dp(start_level,damage_set,seawallcost_set,observed_sealevel,mu_sealevel,sigma_sealevel,pset_1,discount_rate,urban_development,seawall_set,transaction_rate,discount_rate_seawall)


    start_period = length(observed_sealevel);
    
    if start_period > 1
    [mu_future_sealevel,sigma_future_sealevel] = conditionalMVN(mu_sealevel,sigma_sealevel,observed_sealevel);
    
    %size(observed_sealevel)

    sigma_slr = diag(sigma_future_sealevel).^(1/2);
    sigma_slr((start_period+1):10) = max(ceil(sigma_slr*10),1);
    sigma_slr(start_period) = 1;
    mean_slr = ceil(mu_future_sealevel*10);
    mean_slr((start_period+1):10) = mean_slr;
    mean_slr(start_period) = ceil(observed_sealevel(start_period)*10);

    p = zeros(10,length(seawall_set));

    for ii = start_period:10
        p(ii,1:mean_slr(ii)) = 1;
        tag_num = (ii-1)*25+sigma_slr(ii);
        list_num = (mean_slr(ii)+1):length(seawall_set);
        p(ii,list_num) = interp1(0:40,pset_1(tag_num,3:43),(list_num-(mean_slr(ii)+1))/10);
    end

    p(:,2:401) = [-diff(p')'];
    p(:,1) = 0;
    p = movmean(p,11,2);


    for ii = 1:10
    exp_damage(ii,:) = p(ii,:).*damage_set*(1+discount_rate).^(-10*(ii-1))*10*urban_development(ii);
    end

    exp_damage = movmean(exp_damage,11,2);

    dp_opt_strategy = zeros(length(seawall_set),10);
    dp_opt_cost = zeros(length(seawall_set),10);


    for ii = 10:-1:(start_period)
        if ii > (start_period)
        for jj = 1:length(seawall_set)
            temp_cost = (cumsum(exp_damage(ii,:),'reverse')'+ (max(seawallcost_set(:,2)-seawallcost_set(jj,2),0)+transaction_rate*seawallcost_set(jj,2))*(1+discount_rate_seawall)^(-10*(ii-1)) + dp_opt_cost(:,ii));
            temp_cost(jj) = temp_cost(jj) - transaction_rate*seawallcost_set(jj,2)*(1+discount_rate_seawall)^(-10*(ii-1));
            dp_opt_strategy(jj,ii) = max(find(temp_cost == min(temp_cost)),jj);%% the ii year opt seawall height based on the last year seawall level jj
            dp_opt_cost(jj,ii-1) = min(temp_cost);
        end
        else
            temp_cost = cumsum(exp_damage(ii,:),'reverse')'+ (max(seawallcost_set(:,2)-seawallcost_set(start_level,2),0)+transaction_rate*seawallcost_set(start_level,2))*(1+discount_rate_seawall)^(-10*(ii-1)) + dp_opt_cost(:,ii);
            dp_opt_strategy(:,ii) = min(find(temp_cost == min(temp_cost)));
            dp_opt_cost = min(temp_cost);
        end
    end
    current_bdp_level = min(find(temp_cost == min(temp_cost)));
    end

    if start_period == 1
        
        sigma_slr = sigma_sealevel;
        sigma_slr = max(ceil(sigma_slr*10),1);
        mean_slr = ceil(mu_sealevel*10);
        %size(mean_slr)

        p = zeros(10,length(seawall_set));
        for ii = 1:10
        p(ii,1:mean_slr(ii)) = 1;
        tag_num = (ii-1)*25+sigma_slr(ii);
        list_num = (mean_slr(ii)+1):401;
        p(ii,list_num) = interp1(0:40,pset_1(tag_num,3:43),(list_num-(mean_slr(ii)+1))/10);
        end
        
        p(:,2:401) = [-diff(p')'];
        p(:,1) = 0;
        p = movmean(p,11,2);
        
        for ii = 1:10
        exp_damage(ii,:) = p(ii,:).*damage_set*(1+discount_rate).^(-10*(ii-1))*10*urban_development(ii);
        end
        
        exp_damage = movmean(exp_damage,11,2);
        
        dp_opt_strategy = zeros(length(seawall_set),10);
        dp_opt_cost = zeros(length(seawall_set),10);
        
        for ii = 10:-1:1
            if ii >1
            for jj = 1:length(seawall_set)
                temp_cost = (cumsum(exp_damage(ii,:),'reverse')'+ (max(seawallcost_set(:,2)-seawallcost_set(jj,2),0)+transaction_rate*seawallcost_set(jj,2))*(1+discount_rate_seawall)^(-10*(ii-1)) + dp_opt_cost(:,ii));
                temp_cost(jj) = temp_cost(jj) - transaction_rate*seawallcost_set(jj,2)*(1+discount_rate_seawall)^(-10*(ii-1));
                dp_opt_strategy(jj,ii) = max(find(temp_cost == min(temp_cost)),jj);%% the ii year opt seawall height based on the last year seawall level jj
                dp_opt_cost(jj,ii-1) = min(temp_cost);
            end
            else
                temp_cost = cumsum(exp_damage(ii,:),'reverse')'+ (seawallcost_set(:,2) + dp_opt_cost(:,ii));
                dp_opt_strategy(:,ii) = find(temp_cost == min(temp_cost));
                dp_opt_cost = min(temp_cost);
            end
        end
        
        for ii = 1:10
            if ii == 1
                dp_opt_real(ii) = dp_opt_strategy(1,1);
            else
                dp_opt_real(ii) = dp_opt_strategy(dp_opt_real(ii-1),ii);
            end
        end
        current_bdp_level = dp_opt_real(1);
    end
end