function [ cdist ] = bound( cdist )
% [cdist]=bound(cdist,SET,elem) checks the crystal orientation bounds and
% fixes orientations outside the bounds. 
%
%   cdist is the structure holding the crystal distribution outlined in
%   Thor.setup. 

% bound returns a crystal distribution, cdist, with properly bounded
% crystals. 
%
%   See also Thor.setup

    % check angles are within allowed bounds 
    % (0 <= cdist.theta <= pi/2, 0 <= cdist.phi <= 2*pi)
        % cdist.theta < 0 -- flip to positive cdist.theta and rotate cdist.phi
        % by pi 
        cdist.phi(cdist.theta < 0) = cdist.phi(cdist.theta < 0) + pi;
        cdist.theta(cdist.theta < 0) = abs(cdist.theta(cdist.theta < 0));
        
        % cdist.theta > pi/2 -- use `other end' of c-axis (symmetric: can't
        % tell which side is which)    
        cdist.phi(cdist.theta > pi/2) = cdist.phi(cdist.theta > pi/2) + pi;
        cdist.theta(cdist.theta > pi/2) = pi - cdist.theta(cdist.theta > pi/2);
        
        % make sure cdist.phi is within bounds
        cdist.phi = rem(cdist.phi +2*pi, 2*pi);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FEvoR: Fabric Evolution with Recrystallization %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2009-2014  Joseph H Kennedy
%
% This file is part of FEvoR.
%
% FEvoR is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software 
% Foundation, either version 3 of the License, or (at your option) any later 
% version.
%
% FEvoR is distributed in the hope that it will be useful, but WITHOUT ANY 
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more 
% details.
%
% You should have received a copy of the GNU General Public License along 
% with FEvoR.  If not, see <http://www.gnu.org/licenses/>.
%
% Additional permission under GNU GPL version 3 section 7
%
% If you modify FEvoR, or any covered work, to interface with
% other modules (such as MATLAB code and MEX-files) available in a
% MATLAB(R) or comparable environment containing parts covered
% under other licensing terms, the licensors of FEvoR grant
% you additional permission to convey the resulting work.


