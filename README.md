# adaptive-strategies-for-climate-change-adaptation-An-application-for-flood-risk-management
data and codes for adaptive strategies for climate change adaptation: An application for flood risk management
This is a dataset for submitted paper titiled "

Reinforcement learning-based adaptive strategies for climate change adaptation: An application for flood risk management

"

Authored by 

Kairui Fenga, Ning Lina, Robert E. Koppb,c, Siyuan Xiana, Michael Oppenheimerd,e,f

a Department of Civil and Environmental Engineering, Princeton University, Princeton, NJ, USA.

b Department of Earth and Planetary Sciences, Rutgers University, New Brunswick, NJ, USA.

c Rutgers Climate and Energy Institute, Rutgers University, New Brunswick, NJ, USA.

d School of Public and International Affairs, Princeton University, Princeton, NJ, USA.

e Department of Geosciences, Princeton University, Princeton, NJ, USA

f High Meadows Environmental Institute, Princeton University, Princeton, NJ, USA   



This work is supported by the U.S. National Science Foundation (1652448 and 2103754 as part of the Megalopolitan Coastal Transformation Hub), C3.ai Digital Transformation Institute (C3.ai DTI Research Award), and Princeton HMEI-STEP Graduate Fellowship.



Here we uploaded part of the codes as example.
The code would be compiled in the following procedure:
In the main code file, there are some optimization tool boxes from monopt which some of the optimization functions relies on. 

First we need to run the generate_parameters_for_surge_convolution_distribution (with slr cases prepared). 

Then we could run the main optimization files, for example, static optimal which solves the optimal seawall height under static case. 

And others like dp, bayesin_dp, etc... with the given name. 

The policies could be evaluated by static_evaluation or DP_evaluation, which gives an evaluation of the whole policies case by case. 

One could change the simulation area by editing the head settings, which is something like:

discount_rate = xxx;
transaction_rate = xxx;
discount_rate_seawall = xxx;
urban_development = xxx_vector(1:10);%shape 1x10

if case_idx == 0
load([slr_route,'slr_use_1f_245.mat'])
SROCC_kopp = double([slr(:,1:10,seg_idx_slr(seg_site))]/1000*3.3);
load([slr_route,'slr_use_2f_245.mat'])
SROCC_kopp = [SROCC_kopp;double([slr(:,1:10,seg_idx_slr(seg_site))]/1000*3.3)];
load([slr_route,'slr_use_3f_245.mat'])
SROCC_kopp = [SROCC_kopp;double([slr(:,1:10,seg_idx_slr(seg_site))]/1000*3.3)];
load([slr_route,'slr_use_4_245.mat'])
SROCC_kopp = [SROCC_kopp;double([slr(:,1:10,seg_idx_slr(seg_site))]/1000*3.3)];
slr = [];
%SROCC_kopp = double([slr_585_4(:,1:10)]/1000*3.3);
SROCC_kopp = SROCC_kopp(randsample(20000,20000,false),:);
end

seawall_set = 0:0.1:40;

seawallcost_set(:,1) = seawall_set';
seawallcost_set(:,2) = seg_length(seg_site)*cost_function(seawallcost_set(:,1));

damage_set = cumsum(interp1(seg_section/0.3028,seg_k(seg_site,:),seawall_set));


surge_distribution(1,:) = seg_return_period;
surge_distribution(2,:) = seg_return_level_ncep(seg_site,:);
surge_distribution(3,:) = seg_return_level_585(seg_site,:);
surge_distribution(4,:) = seg_return_level_245(seg_site,:);
surge_distribution(5,:) = 1./surge_distribution(1,:);
surge_distribution(5,:) =  surge_distribution(5,:)./ sum(surge_distribution(5,:));

An example mat file will be uploaded later.





