function [ MsPos ] = genMSpos_ring( R,N,a,b )
%GENMSPOS_RING 生成弧形pos（[a,b]），半径R，共N个点
%   Detailed explanation goes here
MsPos=zeros(3,N);
r=0.5*R;
theta0 = abs(b-a)/(N-1);
for i=1:N
    MsPos(1,i) = r*cosd(a + theta0*(i-1));
    MsPos(2,i) = r*sind(a + theta0*(i-1));
    MsPos(:,i) = round(MsPos(:,i));
    MsPos(3,i) = 1.5;
end
% MsPos = round(MsPos);
end

