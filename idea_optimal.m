function [Lambda_new,rate_sum] = idea_optimal( Lambda_ini,P )
%% 小区间无干扰的理想情况 K=I
    global Nb;
    global Nu;
    global Omega;
    [Nr,Nt,~] = size(Omega);
    
    
    cvx_begin quiet
    variable Lambda_new(Nt,Nb)
    expression rate_sum;
    rate_sum = idea_objectFunction(Lambda_new,Lambda_ini);
    maximize rate_sum
    subject to
    0 <= Lambda_new(:,1);
    0 <= Lambda_new(:,2);
    0 <= Lambda_new(:,3);
    sum(Lambda_new(:,1)) <= P;
    sum(Lambda_new(:,2)) <= P;
    sum(Lambda_new(:,3)) <= P;
    cvx_end
    
    
end
