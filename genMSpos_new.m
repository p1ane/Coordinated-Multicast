function [ MsPos ] = genMSpos_new( R,N,a,b )
%GENMSPOS_NE Summary of this function goes here
%   Detailed explanation goes here
MsPos=zeros(3,N);
r=disrnd(N,R);
theta=a+rand(N).*(b-a);
% figure;
for i=1:N
    MsPos(1,i) = r(i)*cosd(theta(i));
    MsPos(2,i) = r(i)*sind(theta(i));
    MsPos(:,i) = round(MsPos(:,i));
    MsPos(3,i) = 1.5;
%     plot(MsPos(1,i),MsPos(2,i),'o');hold on;
end
% hold off;
% MsPos = round(MsPos);

end

