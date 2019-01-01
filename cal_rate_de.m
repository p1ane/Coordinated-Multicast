function [ rate_sum ] = cal_rate_de( Lambda )   
%%%%%%%%%%%%%%%确定性等同
% Lambda Nt*Nb     

global Nu;
global Nb;

rate_sum = 0;

for i = 1:Nb               %第i个小区
    rate_i = zeros(1,Nu);  %第i个小区的各个用户的速率 1*Nu
    for u = 1:Nu           %第i个小区第u个用户
        rate_i(1,u) = 0;
        K = get_K(i,u,Lambda);   % Nr * Nr 第i个小区第u个用户收到干扰
        [rate_i(1,u),~,~,~] = cal_rate_de_par(i,u,Lambda(:,i),K);       %公式(13)(14)
        rate_i(1,u)= rate_i(1,u) - log(abs(det(K)));
        rate_i(1,u) = max(0,rate_i(1,u));       
    end
    rate = min(rate_i);
    rate_sum = rate_sum + rate;
end
 rate_sum = rate_sum/log(2);


end

