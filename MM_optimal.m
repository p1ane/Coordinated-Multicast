function [ Lambda_new ,rate_sum_ergodic,rate_sum_de] = MM_optimal( Lambda_ini , P  )
%% 小区间协作
%MM迭代优化
%Lambda Nt*Nb
global Nb;
global Omega;
[~,Nt,~] = size(Omega);
Lambda_i = Lambda_ini;
 
 cvx_begin quiet
 variable Lambda_new(Nt,Nb)
 expression object;
 object = objectFunction(Lambda_new,Lambda_i);
 maximize object
 subject to
 0 <= Lambda_new(:,1);
 0 <= Lambda_new(:,2);
 0 <= Lambda_new(:,3);
 sum(Lambda_new(:,1)) <= P;
 sum(Lambda_new(:,2)) <= P;
 sum(Lambda_new(:,3)) <= P;
 cvx_end
    
  
[rate_sum_ergodic] = cal_rate_ergodic(Lambda_new); 
[rate_sum_de] = cal_rate_de(Lambda_new); 
