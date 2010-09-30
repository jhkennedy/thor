function [ vel ] = bvel( cdist, SET )
% [vel]=bvel(cdist, SET) claculates the modeled bulk velocity gradient for the crystal
% distrobution specified by cdist
%   cdist is the structure holding the crystal distrobution outlined in Thor.setup.
%
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
% bvel returns vel, a 3x3 array holding the modeled bulk velocity gradient.
%
%   See also Thor.setup

vel = sum(cdist.vel,3)/SET.numbcrys;

end

