function [ cdist, K ] = grow( cdist, SET, elem )
% [cdist, K]=grow( cdist, SET, elem, step) calculates the new crystal sizes
% of cidst for an element elem, using the settings in SET. 
%
%   cdist is the structure holding the crystal distribution outlined in
%   Thor.setup. 
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number associated with the crystal distribution
%   cdist.
%
% grow returns the crystal distribution cdsit with updated crystal sizes
% and the scalar K which is the grain growth factor. 
%
%   See also Thor.setup

    % Physical constants
    Ko = 8.2e-9; % m^2 s^{-1}
    R = 0.008314472; % kJ K^{-1} mol^{-1}
    if SET.T(elem) >= -10
        Q = 0.7*115; % kJ mol^{-1}
    else
        Q = 0.7*60; % kJ mol^{-1}
    end % Patterson 2010 (4ed) pg 40.
    
    
    % calculate the grain growth factor
    K  = Ko*exp(-Q/(R*(273.13+SET.T(elem)) ) ); % m^2 s^{-1}
    
    % calculate new crystal diameter
    cdist.size = sqrt(K*(SET.ti(elem)-SET.to(:,elem)) + SET.Do(:,elem).^2);
    
end



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


