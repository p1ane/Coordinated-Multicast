clear all;
clc;

SNR = -10:5:20;    %–≈‘Î±»∑∂Œß
NSNR = length(SNR);

load result;

figure;
hold on;


plot(SNR,rate_ergodic_ave_know,'b-','LineWidth',1.5);
plot(SNR,rate_de_ave_know,'b-.s','LineWidth',1.5);
plot(SNR,rate_ergodic_ave_unknow,'r-','LineWidth',1.5);
plot(SNR,rate_de_ave_unknow,'r-.o','LineWidth',1.5);


legend('Proposed','DE of Proposed','Uncoordinated','DE of Uncoordinated','location','NorthWest');
box on;
grid minor;

hold off;

xlabel('SNR (dB)');
ylabel('Multicast sum rate (bits/s/Hz)');

save_fig_name = ['main_pic'];
saveas(gcf,['.\figure\',save_fig_name],'fig');
saveas(gcf,['.\figure\',save_fig_name],'tif');
saveas(gcf,['.\figure\',save_fig_name],'epsc');%±£¥ÊÕº∆¨