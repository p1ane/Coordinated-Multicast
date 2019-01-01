%% 附加测试小区间无干扰的仿真

close all;

Xloop = 1;
global Nu;
global Nb;


Nu = 4;    %与channel_generation中Nu Nt 相对应
Nb = 3;

SNR = -10:5:20;    %信噪比范围
NSNR = length(SNR);
% 
% rate_ergodic_noPA = zeros(Xloop,NSNR);
% rate_ergodic_unknow = zeros(Xloop,NSNR);
% rate_ergodic_know = zeros(Xloop,NSNR);
% rate_de_unknow = zeros(Xloop,NSNR);
% rate_de_know = zeros(Xloop,NSNR);
 rate_idea = zeros(Xloop,NSNR);


for loop = 1:Xloop
    
    
    
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
        [~,rate_idea(loop,nSNR)] = idea_optimal(Lambda_ini(:,:,nSNR),snr);
    end
end
rate_ergodic_ave_idea = sum(rate_idea,1)/Xloop;



