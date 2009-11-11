function [ vel ] = bvel( cdist )
% BVEL(CDIST) claculates the modeled bulk velocity gradient for the crystal distrobution
% specified by CDIST
%   CDIST is a 8000x5 cell aray holding the modeled crystal distrobution
%
%   BVEl returns a 3x3 array holding the modeled bulk velocity gradient.

    vel = zeros(3,3);

    for ii = 1:8000
        vel = vel + cdist{ii,3};
    end
    
    vel = vel/8000;
end

