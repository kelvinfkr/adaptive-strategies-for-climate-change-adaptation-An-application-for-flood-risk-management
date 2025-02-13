head_settings;
bdp_storage = [];
bdp_storage_cost = [];
tic;
%partial_dp(start_level,damage_set,seawallcost_set,observed_sealevel,mu,Sigma,pset_1,discount_rate,urban_development,seawall_set,transaction_rate,discount_rate_seawall)
for case_1 = 1:sample_size_for_case
    for ii = 1:10
        observed_sealevel = SROCC_kopp(case_1,1:ii);
        if ii ==1
            bdp_opt(ii) = partial_dp(0,damage_set,seawallcost_set,observed_sealevel,mu,Sigma,pset_1,discount_rate,urban_development,seawall_set,transaction_rate,discount_rate_seawall);
        else
            bdp_opt(ii) = partial_dp(bdp_opt(ii-1),damage_set,seawallcost_set,observed_sealevel,mu,Sigma,pset_1,discount_rate,urban_development,seawall_set,transaction_rate,discount_rate_seawall);
        end
    end

    for ii = 2:10
        if bdp_opt(ii)-bdp_opt(ii-1)<10
            bdp_opt(ii) = bdp_opt(ii-1);
        end
    end
    sigma_slr = ones(1,10);
    mean_slr = ceil((SROCC_kopp(case_1,:)*10));
    
    p = [];
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

    dp_strategy = bdp_opt;
    %dp_strategy = dp_opt(:,2);    
    cost_construction = 0;
    for ii = 1:10
        if ii == 1
        cost_construction = cost_construction + seawallcost_set(dp_strategy(ii),2)*(1+discount_rate_seawall).^(-10*(ii-1));
        end
        if ii > 1
            if dp_strategy(ii)>dp_strategy(ii-1)
                cost_construction = cost_construction + (seawallcost_set(dp_strategy(ii),2)- seawallcost_set(dp_strategy(ii-1),2))*(1+discount_rate_seawall).^(-10*(ii-1))+transaction_rate*seawallcost_set(dp_strategy(ii-1),2)*(1+discount_rate_seawall).^(-10*(ii-1));
            end
        end
    end
    
    cost_damage = 0;
    for ii = 1:10
        cost_damage = cost_damage + sum(exp_damage(ii,dp_strategy(ii):401));
    end
    
    bdp_storage(case_1,1:10) = bdp_opt;
    bdp_storage_cost(case_1) = cost_construction+cost_damage;
end
toc;
mean(bdp_storage_cost)








