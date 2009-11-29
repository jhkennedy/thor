function [ vel ] = bvel( cdist )
% [vel]=bvel(cdist) claculates the modeled bulk velocity gradient for the crystal
% distrobution specified by cdist
%   cdist is a crystal distrobution is aranged in an 8000x10 cell array. The crystal
%   distrubution structure is outlined in Thor.setup.
%
% bvel returns vel, a 3x3 array holding the modeled bulk velocity gradient.
%
%   See also Thor.setup

    vel = zeros(3,3);

    for ii = 1:8000
        vel = vel + cdist{ii,4};
    end
    
    vel = vel/8000;
end

