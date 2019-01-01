function [ output ] = get_K( i,u,Lambda)     % sum H*Lambda*H
%% 得到干扰项 K 项   i为小区编号 u为用户编号 该用户收到其他基站的信号,Nb为小区数，需要传入
% Lambda Nt * Nu
global h_freq;
global Omega;
global Nu;
global Nb;
[Nr,~,~]=size(h_freq);

K_noise = zeros(Nr,Nr);
K_noise_sum = zeros(Nr,Nr);
for k=1:Nb
    if(k~=i)
         for n = 1:Nr
                   K_noise(n,n) = Omega(n,:,Nb*Nu*(k-1)+Nu*(i-1)+u)*Lambda(:,k);                  
         end
    end
    
    K_noise_sum = K_noise_sum + K_noise;
end

output = eye(Nr) + K_noise_sum;

