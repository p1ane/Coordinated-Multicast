function [ rate_sum ] = cal_rate_ergodic(Lambda)
% 遍历和速率
% Lambda Nt*Nb

global h_freq;
global Nu;
global Nb;

[Nr,~,NF,NoSamples,~]=size(h_freq);

rate_sum = 0;
K = zeros(Nr,Nr);

for i = 1:Nb               %第i个小区
    rate_i = zeros(1,Nu);  %第i个小区的各个用户的速率 1*Nu
    for u = 1:Nu           %第i个小区第u个用户
        rate_i(1,u) = 0;
        K = get_K(i,u,Lambda);                    %第i个小区第u个用户收到的干扰
        for freq_i = 1:NF
            for n_sample = 1:NoSamples
                A = h_freq(:,:,freq_i,n_sample,Nb*Nu*(i-1)+Nu*(i-1)+u);                
                rate_i(1,u) = rate_i(1,u) + log(abs(det(K+A*diag(Lambda(:,i))*A')));
            end
        end
        
        rate_i(1,u) = rate_i(1,u)/NoSamples/NF;                 %第一项的期望
        
        
        
        rate_i(1,u) = rate_i(1,u) - log(abs(det(K)));           %公式（8）
        rate_i(1,u) = max(rate_i(1,u),0);
       
    end
    rate = min(rate_i);
    rate_sum = rate_sum + rate;
end
    rate_sum = rate_sum/log(2);



end

