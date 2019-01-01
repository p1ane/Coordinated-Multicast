function [ obj ] = objectFunction( Lambda_new, Lambda_i )
%% Lambda_new Lambda_i Nt*Nb  公式(19)  小区间相互协作的目标函数
% cvx 优化目标
global Nu;
global Nb;
global Omega;
[Nr,Nt,~] = size(Omega);
obj = 0;
for i = 1:Nb
%      object_i=zeros(1,Nu);
    for u = 1:Nu
        K = get_K(i,u,Lambda_i);
        a = linear_part( Lambda_i , Lambda_new ,i,u);
        [~,Gamma,Gamma_tilide,Phi_tilide] = cal_rate_de_par(i,u,Lambda_i(:,i),K);
        b = log_det(eye(Nt)+Gamma*diag(Lambda_new(:,i))) + log_det(Gamma_tilide+K) - trace(eye(Nr)-inv(Phi_tilide));
        object_i(1,u) = b - a;
       
    end
    k = min(object_i);
    obj = obj + k;
end


end

