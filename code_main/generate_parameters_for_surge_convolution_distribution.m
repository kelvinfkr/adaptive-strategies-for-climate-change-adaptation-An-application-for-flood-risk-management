case_idx = 1;%% 1 = 585 0 =245
% load('/Users/kairuifeng/Downloads/IPCC6_SLR_NYC.mat')
 SROCC_kopp = double([slr_585_1(:,2:11);slr_585_2(:,2:11);slr_585_3(:,2:11);slr_585_4(:,2:11)]/1000*3.3);
% SROCC_kopp = SROCC_kopp(randsample(80000,80000,false),:);
 SROCC_kopp(isnan(SROCC_kopp)) = 0;
% load('temp_space_1.mat', 'surge_distribution')
 SROCC_kopp(:,1) = normrnd(0,0.01,80000,1);

tag_num = 1;
for ii = 1:11
	for jj = 1:25
		year1 = ii*10-10;
		prob_idx = 2;%%% 3.33% exceedence rate
		norm_sigma1 = (jj-1)/10;
		sample_size = 1000000;

        surge_file = surge_distribution(2,:)*(100-year1)/100+surge_distribution(4-case_idx,:)*(year1)/100;

		tic;x = randsample(surge_file,sample_size,true,surge_distribution(5,:))*3.3+normrnd(0,norm_sigma1,1,sample_size);toc;
        
        for pp = 0:40
            p_dis(pp+1) = length(find(x>pp))/sample_size;
        end

		pset_1(tag_num,1:43) = [year1,norm_sigma1,p_dis];
		tag_num = tag_num + 1;
	end
end

%X = linspace(min(pset_1(:,1)),max(pset_1(:,1)),25); 
%Y = linspace(min(pset_1(:,2)),max(pset_1(:,2)),25);
%[xq, yq] = meshgrid(X,Y); 
%zq1_1 = griddata(pset_1(:,1),pset_1(:,2),pset_1(:,3),xq,yq); 
%zq1_2 = griddata(pset_1(:,1),pset_1(:,2),pset_1(:,4),xq,yq); 
%zq1_3 = griddata(pset_1(:,1),pset_1(:,2),pset_1(:,5),xq,yq); 

%tic;
%for i = 1:1000
%treshold1_1 = interp2(xq,yq,zq1_1,10,0.35);
%k1_1 = interp2(xq,yq,zq1_2,10,0.35);
%sigma1_1 = interp2(xq,yq,zq1_3,10,0.35);
%end
toc;





