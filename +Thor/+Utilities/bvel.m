function [ vel ] = bvel( cdist )
% [vel]=bvel(cdist, SET) claculates the modeled bulk velocity gradient for
% the crystal distrobution specified by cdist
%
%   cdist is the structure holding the crystal distrobution outlined in
%   Thor.setup. 
%
% bvel returns vel, a 3x3 array holding the modeled bulk velocity gradient.
%
%   See also Thor.setup

% calculate weights
A = cdist.size.^(3/2);
W = reshape(repmat(A,1,9)',3,3,[]);

% calculate bulk velocity gradient
vel = sum(W.*cdist.vel,3)/sum(A);

end