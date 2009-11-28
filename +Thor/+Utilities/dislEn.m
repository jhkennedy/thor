function [ cdist ] = dislEn( cdist )
%DISLEN Summary of this function goes here
%   Detailed explanation goes here
% dislocation energy calculation

rho = cell2mat(cdist(:,8));

kappa = 0.35; % adjustible parameter -- Thor2002 eqn. 19 -- value set [38]
G = 3.4e9; % Pa
b = 4.5e-10; % m

Re = 1/(rho.^(1/2)); 

Edis = kappa*G*b^2*log(Re/b);

cdist(:,9) = num2cell(Edis);

end

