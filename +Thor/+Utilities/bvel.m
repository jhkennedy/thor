function [ vel ] = bvel( cdist, SET )
% [vel]=bvel(cdist) claculates the modeled bulk velocity gradient for the crystal
% distrobution specified by cdist
%   cdist is a crystal distrobution is aranged in an SET.NUMBCRYSx10 cell array. The crystal
%   distrubution structure is outlined in Thor.setup.
%
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
% bvel returns vel, a 3x3 array holding the modeled bulk velocity gradient.
%
%   See also Thor.setup

    vel = zeros(3,3); % s^{-1}

    for ii = 1:SET.numbcrys
        vel = vel + cdist{ii,4}; % s^{-1}
    end
    
    vel = vel/SET.numbcrys; % s^{-1}
end

