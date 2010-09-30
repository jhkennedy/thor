function [ cdist ] = bound( cdist )
% [cdist]=bound(cdist,SET,elem) checks the crystal orientation bounds and fixes
% orientations outside the bounds. 
%   cdist is the structure holding the crystal distrobution outlined in Thor.setup.
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number of the crystal distrobution, cdist.
%
% bound returns a crystal distrobution, cdist, with propperly bounded crystals.
%
%   See also Thor.setup

    % check angles are within allowed bounds
    cdist.theta(cdist.theta > pi/2) = pi - cdist.theta(cdist.theta > pi/2);
    cdist.phi(cdist.theta > pi/2) = cdist.phi(cdist.theta > pi/2) + pi;
    cdist.theta(cdist.theta < 0) = abs(cdist.theta(cdist.theta < 0));
    cdist.phi(cdist.theta < 0) = cdist.phi(cdist.theta < 0) + pi;
    cdist.phi = rem(cdist.phi +2*pi, 2*pi);