head_settings;
tic;

%seawallcost_set(:,1) = seawall_set;
%seawallcost_set(:,2) = interp1(sea_wall_cost(:,1),sea_wall_cost(:,2),seawall_set);

%damage_set = interp1(damage(:,1),damage(:,2),seawall_set);

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

for ii = 1:10
exp_damage(ii,:) = p(ii,:).*damage_set*(1+discount_rate).^(-10*(ii-1))*10*urban_development(ii);
end
damage_to_level = sum(exp_damage);
damage_above_seawall = cumsum(damage_to_level,'reverse');
total_cost = seawallcost_set(:,2)'+damage_above_seawall;
static_opt = seawall_set(find(total_cost == min(total_cost)));
toc;
static_opt
static_opt_cost = min(total_cost)