function [ R_2_i_u ] = linear_part2( Lambda_i , Lambda_new ,i,u)
%% 计算线性化项 第i个小区 第u个用户  小区间无相互协作的目标函数 K=I
% Lambda_i Lambda_new  Nt*Nb 其中Lambda_new 待cvx优化      
global Nb;
global Omega
[~,Nt,~]= size(Omega);

a = 0;
for k = 1:Nb
    if k ~= i
          a = a  + trace( gradient(i,u,k,Lambda_i) * diag(Lambda_new(:,k)) - gradient(i,u,k,Lambda_i) * diag(Lambda_i(:,k))) ;         %公式(19)线性部分
    end
end

%R_2_i_u = a + log_det(get_K(i,u,Lambda_i));

R_2_i_u = a;

