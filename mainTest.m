
close all;

Xloop = 1;
global Nu;
global Nb;

Nu = 4;    %与channel_generation中Nu Nt 相对应
Nb = 3;
eps = 1e-3;

SNR = -10:5:20;    %信噪比范围
NSNR = length(SNR);

%rate_ergodic_noPA = zeros(Xloop,NSNR);
rate_ergodic_unknow = zeros(Xloop,NSNR);
rate_ergodic_know = zeros(Xloop,NSNR);
rate_de_unknow = zeros(Xloop,NSNR);
rate_de_know = zeros(Xloop,NSNR);
%rate_idea = zeros(Xloop,NSNR);

time = zeros(1,Xloop);
for loop = 1:Xloop
    tic; 
    channel_generation;
    
    disp(['This is loop:',num2str(loop) ]);
    
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
        
         %% idea
  %      [~,rate_idea(loop,nSNR)] = idea_optimal(Lambda_ini(:,:,nSNR),snr);
        
        %% 均匀分配
  %      rate_ergodic_noPA(loop,nSNR) = cal_rate_ergodic(Lambda_ini(:,:,nSNR));
        
        %%  小区间协作
        rate_i = 0;
        Lambda_i = Lambda_ini(:,:,nSNR);
        while 1
            [Lambda_new,rate_ergodic_new,rate_de_new] = MM_optimal(Lambda_i,snr);             
            if  (rate_ergodic_new - rate_i)/rate_i <eps
                break;
            end
            Lambda_i = Lambda_new;
            rate_i = rate_ergodic_new;
            
        end
        rate_ergodic_know(loop,nSNR) = rate_i;
        rate_de_know(loop,nSNR) = cal_rate_de(Lambda_i);
        
        %% 小区间无协作
        rate_j = 0;
        Lambda_j = Lambda_ini(:,:,nSNR);
        while 1
            [Lambda_new,rate_ergodic_new,rate_de_new] = MM_optimal2(Lambda_j,snr);               %小区间无协作
            if  (rate_ergodic_new - rate_j)/rate_j <eps
                break;
            end
            Lambda_j = Lambda_new;
            rate_j = rate_ergodic_new;
            
        end
        rate_ergodic_unknow(loop,nSNR) = rate_j;
        rate_de_unknow(loop,nSNR) = cal_rate_de(Lambda_j);
        
        
       
    end
    time(loop) = toc;
    fprintf('loop%02d:\t%.2fs\n',loop,time(loop));
end


%rate_ergodic_ave_noPA = sum(rate_ergodic_noPA,1)/Xloop;
rate_ergodic_ave_unknow = sum(rate_ergodic_unknow,1)/Xloop;
rate_de_ave_unknow = sum(rate_de_unknow,1)/Xloop;
rate_ergodic_ave_know = sum(rate_ergodic_know,1)/Xloop;
rate_de_ave_know = sum(rate_de_know,1)/Xloop;
%rate_ave_idea = sum(rate_idea,1)/Xloop;

figure;
hold on;


plot(SNR,rate_ergodic_ave_know,'b-s','LineWidth',1);
plot(SNR,rate_de_ave_know,'b--*','LineWidth',1);
plot(SNR,rate_ergodic_ave_unknow,'r-+','LineWidth',1);
plot(SNR,rate_de_ave_unknow,'r--*','LineWidth',1);
%plot(SNR,rate_ergodic_ave_noPA,'b-d','LineWidth',1);
%plot(SNR,rate_ave_idea,'b-^','LineWidth',1);

legend('Proposed','DE of Proposed','Conventional','DE of Conventional');


xlabel('SNR (in dB)');
ylabel('Multicast sum rate (in bits/s/Hz)');

save result.all.mat rate_ergodic_know rate_de_know rate_ergodic_unknow rate_de_unknow
save result.mat rate_ergodic_ave_know rate_de_ave_know rate_ergodic_ave_unknow rate_de_ave_unknow 
