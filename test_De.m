%% I 阵测试确定性等同De
close all;

Xloop = 1;
global Nu;
global Nb;
%global noisepower;
Nu = 4;    %与channel_generation中Nu Nt 相对应
Nb = 3;


SNR = -5:5:20;    %信噪比范围
NSNR = length(SNR);

rate_ergodic = zeros(Xloop,NSNR);
rate_de = zeros(Xloop,NSNR);


for loop = 1:Xloop
    
  %  channel_generation;
    
    
    global h_freq;
    global Omega;
    
    
    load h_freq;
    load Omega;
    
    [Nr,Nt,nofreq,NoSamples,NumOfLinks] = size(h_freq);
    Lambda_ini = zeros(Nt,Nb,NSNR);
    
    for nSNR = 1:NSNR
        snr = 10^(SNR(nSNR)/10);
        for i = 1:Nb
            Lambda_ini(:,i,nSNR) = snr/Nt;
        end
             
        rate_ergodic(loop,nSNR) = cal_rate_ergodic(Lambda_ini(:,:,nSNR));

        rate_de(loop,nSNR) = cal_rate_de(Lambda_ini(:,:,nSNR));
    end
end
save Lambda_ini Lambda_ini;
rate_ergodic_ave = sum(rate_ergodic,1)/Xloop;
rate_de_ave = sum(rate_de,1)/Xloop;

figure;
hold on;
plot(SNR,rate_ergodic_ave,'b-s','LineWidth',1);
plot(SNR,rate_de_ave,'r-*','LineWidth',1);
legend('ergodic','DE');

xlabel('SNR (in dB)');
ylabel('Sum rate (in bits/s/Hz)');

