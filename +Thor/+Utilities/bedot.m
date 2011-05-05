function [ edot ] = bedot( cdist )
% [edot]=bvel(cdist) claculates the modeled bulk velocity gradient for the crystal
% distrobution specified by cdist
%
%   cdist is the structure holding the crystal distrobution outlined in
%   Thor.setup. 
%
% bvel returns vel, a 3x3 array holding the modeled bulk velocity gradient.
%
%   See also Thor.setup

    % calculate the orientation distrobution function
    ODF = reshape(repmat(sin(cdist.theta)',[9,1]),3,3,[]); % -
    
    % find the bulk strain rate
    edot = sum(ODF.*cdist.ecdot,3)./sum(ODF,3);
    
end