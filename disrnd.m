function d=disrnd(num,rmax)
% DISTRND Distance from BS in a circular cell
%   D=DISTRND(K,RMAX) generates K random variables from the pdf
%   p(r)=2*r/RMAX^2. This is the pdf of distance from base station when
%   users are uniformly (in area) distributed in a cell with radius RMAX.
 
%   Authors: Jari Salo (HUT), Marko Milojevic (TUI)
%   $Revision: 0.1$  $Date: Sep 30, 2004$
 
% create random variables from triangular pdf whose width is 2*rmax
a=sum(rmax*rand(2,num));
 
% fold the random variables about the rmax
inds=find(a>rmax);
a(inds)=-a(inds)+2*rmax;
 
d=a(:).';