function [ BSpos,RMAX ] = genBSpos( R )
%GEN Summary of this function goes here
%   R=cell radius
%   BSpos 3x19 matrix
%   RMAX for layoutparset
%   19 cells
BSpos=zeros(3,19);
BSpos(1,:)=[0 0 3/2 3/2 0 -3/2 -3/2 0 3/2 3 3 3 3/2 0 -3/2 -3 -3 -3 -3/2];
a=sqrt(3);
BSpos(2,:)=[0 a a/2 -a/2 -a -a/2 a/2 2*a 3*a/2 a 0 -a -3*a/2 -2*a -3*a/2 -a 0 a 3*a/2]; 
BSpos(3,:)=32;
BSpos=BSpos.*R;
RMAX=5*a*R;
bias=RMAX/2;
BSpos(1,:)=round(BSpos(1,:)+bias);% 取整数很重要
BSpos(2,:)=round(BSpos(2,:)+bias);

BSpos(3,:)=25.*ones(1,19);% 基站高度。如果不设定，会对passloss计算结果造成致命错误：NaN


end

