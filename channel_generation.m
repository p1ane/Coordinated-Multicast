function  channel_generation(~)

addpath('.\wim')
addpath('.\about_channel')
%%
% 参数设置

Nb = 3;                         % 基站数, number of Bases.
Ns = 1;                         % 每小区扇区数
Nu = 4;                         % 小区中用户数
Nr = 4;                         % 接收天线
Nt = 128;                        % 发射天线
NoSamples = 500;
NoFreq = 2048;
nofreq = 1;  
Scen = 10;                      % 设置场景为C1=10
IsLOS = 0;                      % 是否存在视距信道
Center_freq = 2.6e9;            % 频段2.6GHz
R = 500;                        % 小区半径500m
Ring_Pos = 0;


dist_base = 3e8/(Center_freq*2);       % 天线元间距，单位m
dist_user = 10000*3e8/(Center_freq*2);       % 天线元间距，单位m

NumOfLinks = Nu * Nb * Nb * Ns; 

%% antenna
if(~exist('array','var'))
    fp = zeros(1,2,1,360);
    theta = -180:179;
    data = -12*(theta/70).^2;           %对应图5 小区天线图样
    for i=1:360
        if data(i)<-20;
            data(i)=-20;
        end
    end
    data = fftshift(data);              %把序列首元对应到0度
    
    fp(1,1,1,:)=data;                   %天线图样
    
    array(1)= AntennaArray('ULA',Nr,dist_user);                % 用户的天线结构体
    array(2) = AntennaArray('ULA',Nt,dist_base);                 % 基站端的结构体 ,'FP-ACS',fp
    array(3)=array(2);%S1
    array(4)=array(2);%S2
    array(5)=array(2);%S3
    
    array(3).Rot = [0,0,5*pi/6];         % 扇区1-1
    array(4).Rot = [0,0,9*pi/6];         % 扇区3-3
    array(5).Rot = [0,0,pi/6];           % 扇区2-2
    
    array(6)=AntennaArray('ULA',Nt,dist_base);
    %save array_config array;    
else
    disp('不重新生成array');
end

%% BS and MS position
US = zeros(1,Nu*Nb);                    %每小区用户数*小区数,用户所处的扇区号存在矩阵US中
BsPos = zeros(3,Nb);                  %BsPos和MsPos的第一行为x，第二行为y，第三行为z 
BsPos(1,:) = [0 0 3/2];
BsPos(2,:) = [0 sqrt(3) sqrt(3)/2];
BsPos = round(BsPos.*R);
BsPos(3,:) = 25;                        %基站高度
Rmax = 2*sqrt(3)*R;

if(Ring_Pos == 1)
    MsPos = genMSpos_ring(R,Nu,0,120);
    MsPos = [MsPos genMSpos_ring(R,Nu,240,360)];
    MsPos = [MsPos genMSpos_ring(R,Nu,120,240)];
else
    MsPos = genMSpos_new(R*sqrt(3)/2,Nu,0,120);    % 用户在扇形区域内的随机均匀分布
    MsPos = [MsPos genMSpos_new(R*sqrt(3)/2,Nu,240,360)];
    MsPos = [MsPos genMSpos_new(R*sqrt(3)/2,Nu,120,240)];
end

for i=1:Nu*Nb
    MsPos_i = MsPos(1:2,i);             %MsPos_i(1)=x, MsPos_i(2)=y;
    if MsPos_i(2)>0
        if MsPos_i(1)>0
            s=3;
        else
            s=1;
        end
    else
        if abs(MsPos_i(2)/MsPos_i(1))>=0.5774 % tan(210)
            s=2;
        elseif MsPos_i(1)>0
            s=3;
        else
            s=1;
        end
    end
    US(i) = s + (ceil(i/Nu)-1)*Ns;
    MsPos(1:2,i) = MsPos(1:2,i) + BsPos(1:2,ceil(i/Nu));
end

%% gen wimpar
wimpar = wimparset;
wimpar.CenterFrequency = Center_freq;
wimpar.NumTimeSamples = NoSamples;
wimpar.UniformTimeSampling = 'yes';
wimpar.PathLossModelUsed = 'No';
wimpar.ShadowingModelUsed = 'No';

%% gen layoutpar                             
BsAAIdxCell = {[3];[5];[4]};
MsAAIdx=ones(1,Nu*Nb);
layoutpar=layoutparset(MsAAIdx,BsAAIdxCell,NumOfLinks,array,Rmax); 
layoutpar.ScenarioVector = Scen.*ones(1,NumOfLinks);        % 设置场景为C1=10
layoutpar.PropagConditionVector=IsLOS.*zeros(1,NumOfLinks); % 全部改成NLOS。默认为随机值

% station position
for i=1:(Nb*Ns+Nu*Nb)                                       %3+36 Stations
    if (i<=Nb*Ns && i>=1)
        layoutpar.Stations(i).Pos = BsPos(:,ceil(i/Ns));
    else
        layoutpar.Stations(i).Pos = MsPos(:,(i-Nb*Ns));
    end
end

% pairing
for ss=1:(Nb*Ns)
    for ms=1:(Nu*Nb)
        layoutpar.Pairing(:,ms+Nu*Nb*(ss-1))=[ss;Nb*Ns+ms];
    end
end

%% draw layout
t=linspace(0,360,7);
figure;
NTlayout(layoutpar);
hold on
axis square
for bs=1:Nb
    x=R.*cosd(t)+BsPos(1,bs);    
    y=R.*sind(t)+BsPos(2,bs);
    plot(x,y,'-.r','linewidth',2);
end
hold off

%% gen h_freq,Omega,r
if(~exist('H','var'))
    [H,delay,~]=wim(wimpar,layoutpar);              % H是单元矩阵，每一个单元对应一个链路的信道矩阵
%      save H_config H ;
%      save delay_config delay ;
else
    disp('不重新生成H');
end

delay_ts = delay./wimpar.DelaySamplingInterval;
sizeH = size(H{1});
NoPath = sizeH(3);
r = zeros(Nt, NumOfLinks);
Rt = zeros(Nt,Nt,NumOfLinks);

Omega = zeros(Nr,Nt,NumOfLinks);
h_freq = zeros(Nr,Nt,nofreq,NoSamples,NumOfLinks);    % 接收天线，发射天线，子载波，采样，链路数

Ut = dftmtx(Nt)/sqrt(Nt);
% Ur = dftmtx(Nr)/sqrt(Nr);                            % 用户侧相关阵，假设为单位阵


Ur = zeros(Nr,Nr,NumOfLinks);
% for n_link=1:NumOfLinks
%     for n_path=1:NoPath
%         for n_sample=1:NoSamples
%             C =H{n_link}(:,:,n_path,n_sample);
%             Rr(:,:,n_link) = Rr(:,:,n_link) + C*C'/NoSamples;
%         end
%     end
%     [Ur(:,:,n_link),~] = eig(Rr(:,:,n_link));
% end

for n_link=1:NumOfLinks
    for n_path=1:NoPath                               % 对同一个链路的路径取平均
        for n_sample=1:NoSamples                      % 对时间取平均
            B = H{n_link}(:,:,n_path,n_sample)*Ut;
            B1 = H{n_link}(:,:,n_path,n_sample)*Ut;
            Rt(:,:,n_link) = Rt(:,:,n_link) + B'*B/NoSamples;
            r(:,n_link) = r(:,n_link)+diag(B1'*B1)/NoSamples;
            Omega(:,:,n_link ) = Omega(:,:,n_link )+B1.*conj(B1)/NoSamples;
            for freq_i = 1:nofreq
                h_freq(:,:,freq_i,n_sample,n_link ) = h_freq(:,:,freq_i,n_sample,n_link ) + ...
                    B*exp(-1j*2*pi*(freq_i -1)*delay_ts(n_link,n_path)/NoFreq);
            end
        end
    end       
end

h_energy = zeros(Nb*Ns,Nb*Nu);
user2sector = zeros(2,Nb*Nu);
user2sector(1,:) = 1:(Nb*Nu);
for user_i = 1:(Nb*Nu)
    for sector_i = 1:(Nb*Ns)
        h_energy(sector_i,user_i)=sum(r(:,user_i+(sector_i-1)*(Nu*Nb)));
    end
end
[~,user2sector_tmp]=max(h_energy);
user2sector(2,:)=user2sector_tmp;

% figure;         %每个用户波束强度图
% hold on
% semilogy(1:Nt,r(:,1),'r-s');
% semilogy(1:Nt,r(:,2),'b-*');
% semilogy(1:Nt,r(:,3),'b-+');
% semilogy(1:Nt,r(:,4),'k-p');
% semilogy(1:Nt,r(:,5),'k-^');
% semilogy(1:Nt,r(:,6),'c-^');
% semilogy(1:Nt,r(:,7),'c-p');
% semilogy(1:Nt,r(:,8),'m-p');
% semilogy(1:Nt,r(:,9),'m-<');
% semilogy(1:Nt,r(:,10),'m-d');
% semilogy(1:Nt,r(:,11),'g-s');
% semilogy(1:Nt,r(:,12),'g->');
% hold off
% legend('1','2','3','4','5','6','7','8','9','10','11','12');
% title('用户波数域强度分布');

save h_freq h_freq;
save Omega Omega;


