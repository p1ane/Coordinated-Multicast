function [sumrate] = idea_objectFunction(Lambda_new,Lambda_ini)
%% Lambda_new  Nt*Nb  公式(19)  小区间无干扰
% cvx 优化目标
global Nu;
global Nb;
global Omega;
[Nr,Nt,~] = size(Omega);
sumrate = 0;

for i = 1:Nb
    for u = 1:Nu
        K= eye(Nr);
        [~,Gamma,Gamma_tilide,Phi_tilide] = cal_rate_de_par(i,u,Lambda_ini(:,i),K);
        object_i(1,u) = log_det(eye(Nt)+Gamma*diag(Lambda_new(:,i))) + log_det(Gamma_tilide+K) - trace(eye(Nr)-inv(Phi_tilide));
       
    end
    k = min(object_i);
    sumrate = sumrate + k;
end


end


