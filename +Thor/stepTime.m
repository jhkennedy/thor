function [SET, NPOLY, NMIGRE, StepStrain] = stepTime(NAMES, SET, RUN, STEP, SAVE, eigenMask )
% [SET, NPOLY, NMIGRE, StepStrain] = step(NAMES, SET, RUN, STEP, SAVE, eigenMask) 
% preforms a time step specified in SET on all the crystal distributions in NAMES.
% The inputs are: 
%
%   NAMES holds all the files names for the crystal distributions. NAMES is
%   outlined in Thor.setup.
%
%   SET is a structure holding the model settings as outlined in Thor.setup.
%
%   RUN is a scalar holding the current run number.
%
%   STEP is a scalar holding the current time step being preformed.
%
%   SAVE is a vector containing all the timesteps that should be saved.
%
%   eigenMask is a N by M logical array where each M column contains N logicals
%   that are True if the nth crystal in the distribution belongs to the mth layer.
%
% stepTime loads in a crystal distribution for each element and  calculates new
% velocity gradients, crystal strain rates, dislocation densities, dislocation
% energies, grain sizes, as well as checking for polygonization and migration
% recrystallization. stepTime then rotates the crystals, saves the stepped crystal
% distributions to disk, and saves a copy if the current time step is listed in
% SAVE. stepTime returns [SET, NPOLY, NMIGRE, StepStrain] where:
%
%   SET is a structure holding the model settings as outlined in Thor.setup.
%
%   NPOLY is a (SET.nelem) by size(eigenMask,2) array holding the number of
%   polygonization events in each layer of the distribution described by 
%   eigenMask.
%
%   NMIGRE is a (SET.nelem) by size(eigenMask,2) array holding the number of
%   migration recrystallization events in each layer of the distribution 
%   described by eigenMask.
%
%   StepStrain is an array, sized (SET.nelem) by 1, holding the strain the
%   distribution underwent.
%
%   See also Thor.setup.

    NPOLY = zeros(SET.nelem,size(eigenMask,2));
    NMIGRE = zeros(SET.nelem,size(eigenMask,2));
    StepStrain = zeros(SET.nelem,1);

    for ii = 1:SET.nelem

        % load element ii
        cdist = load(['./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii}]);
        
        % calculate velocity gradients and crystal strain rates
        cdist = Thor.Utilities.vec( cdist, SET, ii);        
        
        % calculate bulk strain rate
        edot = Thor.Utilities.bedot( cdist );
        
        % calculate strain step
        medot = sqrt(1/2*(edot(1,1)^2+edot(2,2)^2+edot(3,3)^2+2*(edot(1,2)^2+edot(2,3)^2+edot(3,2)^2)));
        StepStrain(ii,1) = SET.tstep(ii)*medot;
                
        % grow the crystals
        [cdist, K] = Thor.Utilities.grow(cdist, SET, ii);
        
        
        % calculate new dislocation density
        [cdist, ~] = Thor.Utilities.disl(cdist, SET, ii, K);
        
        % check for polygonization
        [cdist, SET, NPOLY(ii,:)] = Thor.Utilities.poly(cdist, SET, ii, eigenMask);
        
        % check for migration recrystallization
        [cdist, SET, NMIGRE(ii,:)] = Thor.Utilities.migre(cdist, SET, ii, eigenMask);
        
        % check crystal orientation bounds
        cdist = Thor.Utilities.bound(cdist);
        
        % rotate the crystals from last time steps calculations
        cdist = Thor.Utilities.rotate(cdist, SET, ii ); %#ok<NASGU>
        
        % save crystal distributions
        eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
        
        % save a copy of crystal distributions at specified time steps
        if any(SAVE == STEP)
            eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step' num2str(STEP,'%05.0f') '_' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
        end
    end
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


