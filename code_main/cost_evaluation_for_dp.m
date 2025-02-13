head_settings;
%temp = diff(seawallcost_set(:,2));
%seawallcost_set(:,2) = [seawallcost_set(1,2);seawallcost_set(1,2)+cumsum(min(diff(seawallcost_set(:,2)),temp(190)))];

sigma_slr = var(SROCC_kopp).^(1/2);
sigma_slr = ceil(sigma_slr*10);
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


%dp_strategy = [95,105,116,131,147,164,183,201,224,254];
dp_strategy = ones(10,1)*16;
%dp_strategy = dp_opt_real;
%dp_strategy = dp_opt(:,2);
for case_num = 1:1
    %dp_strategy = ceil(dp_strategy+ones(10,1)*rand()*20-10);

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
(cost_construction+cost_damage)
end

