mu = mean(SROCC_kopp);
Sigma = cov(SROCC_kopp);

mvncond2(mu,Sigma,5,[0,0,0,0,0])