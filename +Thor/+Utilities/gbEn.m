function [ Egb ] = gbEn( D )
%EGB Summary of this function goes here
%   Detailed explanation goes here
% calculate grain boundry energy


GAMMAgb = 0.0065; % J m^{-2}

Egb = 3*GAMMAgb/D;

end