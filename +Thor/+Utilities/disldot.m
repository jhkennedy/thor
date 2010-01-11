function [ rhodot ] = disldot( T, D, edot, rho )
% [rhodot]=DISLDOT(T,D,edot,rho) calculates the time change of the dislocation density
% of a crystal from the temperature, T, the grain size, D, the single crystal strain rate,
% edot, and the current dislocation density, rho.
%   T is the temperature for the crystal usually specified from SETTINGS.T outlined in
%   Thor.setup.
%   
%   D is the diameter of the crystal usually specified from a crystal distrobution
%   outlined in Thor.setup.
%
%   edot is the strain rate of the crystal usually specified from a crystal distrobution
%   outlined in Thor.setup.
%
%   rho is the dislocation density of the crystal usually specified from a crystal
%   distrobution outlined in Thor.setup.
%
% DISLDOT returns rhodot a scalar value that specifies the time change of the disloaction
% density for a crystal. 
%
%   See also Thor.setup

    Medot = ( edot(1,1)*edot(2,2)+edot(2,2)*edot(3,3)+edot(3,3)*edot(1,1)...
                   -(edot(1,2)^2+edot(2,3)^2+edot(3,1)^2) )^(1/2); % s^{-1}

    Ko = 9.2e-9; % m^2 s^{-1}
    Q = 40; % kJ mol^{-1}
    R = 0.008314472; % kJ K^{-1} mol^{-1}
    b = 4.5e-10; % m
    alpha = 2; % constant greater than 1, thor 2002
    
    % calculate grain growth factor
    K = Ko*exp(-Q/(R*(273.13+T))); % m^2 s^{-1}
    
    % claclulate the change in the dislocation density
    rhodot = (Medot/(b*D))-alpha*rho*K/(D^2); % m^{-2} s^{-1}
    
end

