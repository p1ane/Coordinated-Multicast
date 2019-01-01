function [ output ] = eta( X,i,u)  

global Omega;
global Nb;
global Nu;

output = diag(Omega(:,:,Nb*Nu*(i-1)+Nu*(i-1)+u)'*diag(X));



