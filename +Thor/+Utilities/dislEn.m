function [ cdist ] = dislEn( cdist )
% [cdist]=dislEn(cdist) calculates the dislocation energy for each crystal in the crystal
% distrobution specifided by cdist.
%   cdist is a crystal distrobution is aranged in an (SET.numbcrys)x10 cell array. The crystal
%   distrubution structure is outlined in Thor.setup.
%
% dislEn retruns the crystal distrobution with new values for the dislocation energy. 
%   
%   See also Thor.setup


rho = cell2mat(cdist(:,8));

kappa = 0.35; % adjustible parameter -- Thor2002 eqn. 19 -- value set [38]
G = 3.4e9; % Pa
b = 4.5e-10; % m

Re = 1/(rho.^(1/2)); 

Edis = kappa*G*b^2*log(Re/b);

cdist(:,9) = num2cell(Edis);

end

