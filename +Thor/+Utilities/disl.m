function [ cdist, rhoDotStrain ] = disl( cdist, SET, elem, K )
% [cdist, rhoDotStrain]=DISL(cdist, SET, elem, K) calculates the new
% dislocation density for each crystal in the distribution cdist of element
% elem, based on the settings specified in SET.
%
%   cdist is the structure holding the crystal distribution outlined in
%   Thor.setup. 
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number of the crystal distribution, cdist.
%
%   K is the crystal growth rate factor.
%
% DISL returns the crystal distribution cdist with new dislocation
% densities and rhoDotStrain, the increase in dislocation density from
% strain hardening.
%   
%   See also Thor.setup, Thor.Utilities.grow

    % Physicsal constants
    b = 3.69e-10; % m
    alpha = 1; % constant greater than 1, Thor 2002 -- yet every uses 1 (Thor 2002, De La Chapelle 1998, Montagnant 2000)
    
    % calculate the Magnitude (second invariant) of the strain rate
    Medot = squeeze(sqrt(sum(sum(cdist.ecdot.^2,2),1)/2)); % s^{-1}

    % dislocations from strain hardening
    rhoDotStrain = (Medot./(b.*cdist.size) );

    % calculate the change in the dislocation density
    rhodot = rhoDotStrain-alpha.*cdist.dislDens.*K./(cdist.size.^2); % m^{-2} s^{-1}
    
    % set the new dislocation density
    cdist.dislDens = cdist.dislDens + rhodot*SET.tstep(elem); % m^{-2}
    
    % set boundary condition (can't have negative dislocation density)
    cdist.dislDens(cdist.dislDens <= 0 ) = 0;
    
end

