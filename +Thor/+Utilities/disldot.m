function [ rhodot ] = disldot( T, D, edot, rho )
%DISLDOT Summary of this function goes here T D edot Rho
%   Detailed explanation goes here

    Ko = 9.2e-9; % m^2 s^{-1}
    Q = 40; % kJ mol^{-1}
    R = 0.008314472; % kJ K^{-1} mol^{-1}
    b = 4.5e-10; % m
    alpha = 2; % constant greater than 1, thor 2002
    
    % calculate grain growth factor
    K = Ko*exp(-Q/(R*T));
    
    rhodot = (edot/(b*D))-alpha*rho*K/(D^2);
    
end

