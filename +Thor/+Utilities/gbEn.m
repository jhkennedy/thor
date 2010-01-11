function [ Egb ] = gbEn( D )
% [Egb]=gbEn(D) calculates the grain boundry energy of a crystal of size D.
%   D is the crystal diameter. 
% 
% gbEn return the grain boundy energy of a crystal.


GAMMAgb = 0.0065; % J m^{-2}

Egb = 3*GAMMAgb/D; % J m^{-3}

end