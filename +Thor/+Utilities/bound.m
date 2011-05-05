function [ cdist ] = bound( cdist )
% [cdist]=bound(cdist,SET,elem) checks the crystal orientation bounds and fixes
% orientations outside the bounds.
%
%   cdist is the structure holding the crystal distrobution outlined in
%   Thor.setup. 

% bound returns a crystal distrobution, cdist, with propperly bounded crystals.
%
%   See also Thor.setup

    % check angles are within allowed bounds 
    % (0 <= cdist.theta <= pi/2, 0 <= cdist.phi <= 2*pi)
        % cdist.theta < 0 -- flip to positive cdist.theta and rotate cdist.phi
        % by pi 
        cdist.phi(cdist.theta < 0) = cdist.phi(cdist.theta < 0) + pi;
        cdist.theta(cdist.theta < 0) = abs(cdist.theta(cdist.theta < 0));
        
        % cdist.theta > pi/2 -- use `other end' of c-axis (symetric: can't
        % tell which side is which)    
        cdist.phi(cdist.theta > pi/2) = cdist.phi(cdist.theta > pi/2) + pi;
        cdist.theta(cdist.theta > pi/2) = pi - cdist.theta(cdist.theta > pi/2);
        
        % make sure cdist.phi is within bounds
        cdist.phi = rem(cdist.phi +2*pi, 2*pi);