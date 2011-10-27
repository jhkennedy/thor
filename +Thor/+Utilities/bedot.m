function [ edot ] = bedot( cdist )
% [edot]=bedot(cdist) claculates the modeled bulk velocity gradient for the
% crystal distrobution specified by cdist
%
%   cdist is the structure holding the crystal distrobution outlined in
%   Thor.setup. 
%
% bedot returns vel, a 3x3 array holding the modeled bulk velocity gradient.
%
%   See also Thor.setup
    
    % calculate weights
    A = cdist.size.^(3/2);
    W = reshape(repmat(A,1,9)',3,3,[]);
    
    % find the bulk strain rate
    edot = sum(W.*cdist.ecdot,3)./sum(A);
    
end