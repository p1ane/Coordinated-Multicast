function [ output ] = eta_tilide( X,i,u )

global Omega;
global Nu;
global Nb;

output = diag(Omega(:,:,Nb*Nu*(i-1)+Nu*(i-1)+u)*diag(X));
end

