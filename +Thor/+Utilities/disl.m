function [ cdist, rhoDotStrain ] = disl( cdist, SET, elem, K )
% [cdist, rhoDotStrain]=DISL(cdist, SET, elem, K) calculates the new
% dislocation density for each crystal in the distribution cdist of element
% elem, based on the settings specified in SET.
%
%   cdist is the structure holding the crystal distribution outlined in
%   Thor.setup. 
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number associated with the crystal distribution
%   cdist. 
%
%   K is the scalar crystal growth rate factor.
%
% DISL returns the crystal distribution cdist with new dislocation
% densities and rhoDotStrain, the increase in dislocation density from
% strain hardening.
%   
%   See also Thor.setup, Thor.Utilities.grow

    % Physicsal constants
    b = 4.5e-10; % m
    alpha = 1; % constant greater than 1, Thor 2002 -- yet every uses 1 (Thor 2002, De La Chapelle 1998, Montagnant 2000)
    
    % calculate the Magnitude (second invariant) of the strain rate
    Medot = squeeze(sqrt(sum(sum(cdist.ecdot.^2,2),1)/2)); % s^{-1}

    % dislocations from strain hardening
    rhoDotStrain = (Medot./(b.*cdist.size) );

    % calculate the change in the dislocation density
    rhodot = rhoDotStrain-alpha.*cdist.dislDens.*K./(cdist.size.^2); % m^{-2} s^{-1}
    
    % set the new dislocation density
    cdist.dislDens = cdist.dislDens + rhodot*SET.tstep(elem); % m^{-2}
    
    % set boundary condition (can't have negative dislocation density)
    cdist.dislDens(cdist.dislDens <= 0 ) = 0;
    
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


