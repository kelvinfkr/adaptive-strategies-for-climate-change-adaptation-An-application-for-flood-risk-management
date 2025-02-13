head_settings;
tic;

%temp = diff(seawallcost_set(:,2));
%seawallcost_set(:,2) = [seawallcost_set(1,2);seawallcost_set(1,2)+cumsum(min(diff(seawallcost_set(:,2)),temp(190)))];

sigma_slr = var(SROCC_kopp).^(1/2);
sigma_slr = max(ceil(sigma_slr*10),1);
mean_slr = ceil(mean(SROCC_kopp*10));

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

toc;

dp_storage_cost = [];
for case_1 = 1:sample_size_for_case
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

    dp_strategy = dp_opt_real;
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
    
    %dp_storage(case_1,1:10) = bdp_opt;
    dp_storage_cost(case_1) = cost_construction+cost_damage;
end
mean(dp_storage_cost)


