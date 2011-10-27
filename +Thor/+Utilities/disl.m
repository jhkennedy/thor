function [ cdist ] = disl( cdist, SET, elem )
% [cdist]=DISL(cdist, SET, elem) calculates the new dislocation density for each
% crystal in the distrobution cdist of element elem, bassed on the settings
% specified in SET.  
%   cdist is the structure holding the crystal distrobution outlined in
%   Thor.setup. 
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number of the crystal distrobution, cdist.
%
% DISL returns the crystal distrobution, cdist, with new dislocation densities. 
%   
%   See also Thor.setup

    % Physicsal constants
    Ko = 9.2e-9; % m^2 s^{-1}
    Q = 40; % kJ mol^{-1}
    R = 0.008314472; % kJ K^{-1} mol^{-1}
    b = 4.5e-10; % m
    alpha = 2; % constant greater than 1, thor 2002

    % claculate the grain growth factor
    K  = Ko*exp(-Q/(R*(273.13+SET.T(elem)) ) ); % m^2 s^{-1}

    % calculate the Magnitude of the strain rate
    Medot = squeeze(sqrt(sum(sum(cdist.ecdot.^2,2),1)/2)); % s^{-1}
    
    % claclulate the change in the dislocation density
    rhodot = (Medot./(b.*cdist.size) )-alpha.*cdist.dislDens.*K./(cdist.size.^2); % m^{-2} s^{-1}
    
    % set the new dislocation density
    cdist.dislDens = cdist.dislDens + rhodot*SET.tstep(elem); % m^{-2}
    
end

