function [ vel ] = bvel( cdist )
% [vel]=bvel(cdist, SET) calculates the modeled bulk velocity gradient for
% the crystal distribution specified by cdist
%
%   cdist is the structure holding the crystal distribution outlined in
%   Thor.setup. 
%
% bvel returns vel, a 3x3 array holding the modeled bulk velocity gradient.
%
%   See also Thor.setup

    % weight crystals by size
    A = cdist.size.^(3/2);
    W = reshape(repmat(A,1,9)',3,3,[]);

    % % equal weight to all crystals
    % A = cdist.numbcrys;
    % W = 1;


    % calculate bulk velocity gradient
    vel = sum(W.*cdist.vel,3)/sum(A);

end
