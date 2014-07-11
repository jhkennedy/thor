function [SET, NPOLY, NMIGRE] = stepStrain(NAMES, SET, StrainStep, RUN, STEP, SAVE, eigenMask )
% [SET, NPOLY, NMIGRE] = stepStrain(NAMES, SET, StrainStep, RUN, STEP, SAVE, eigenMask) 
% performs a time step long enough to reach a strain specified by
% StrainStep on all the crystal distributions in NAMES. The inputs are:
%
%   NAMES holds all the files names for the crystal distributions. NAMES is
%   outlined in Thor.setup.
%
%   SET is a structure holding the model settings as outlined in
%   Thor.setup. 
%
%   StrainStep is a scalar holding the size of the strain step.
%
%   RUN is a scalar holding the current run number.
%
%   STEP is a scalar holding the current time step being preformed.
%
%   SAVE is a vector containing all the timesteps that should be saved.
%
%   eigenMask is a N by M logical array where each M column contains N
%   logicals that are True if the nth crystal in the distribution belongs
%   to the mth layer. 
%
% stepStrain loads in a crystal distribution for each element and
% calculates new velocity gradients, crystal strain rates, dislocation
% densities, dislocation energies, grain sizes, as well as checking for
% polygonization and migration recrystallization. stepStrain then rotates
% the crystals, saves the stepped crystal distributions to disk, and saves
% a copy of the distribution if the current time step is listed in SAVE.
% stepTime returns [SET, NPOLY, NMIGRE, StrainStep] where: 
%
%   SET is a structure holding the model settings as outlined in
%   Thor.setup. 
%
%   NPOLY is a (SET.nelem) by size(eigenMask,2) array holding the number of
%   polygonization events in each layer of the distribution described by 
%   eigenMask.
%
%   NMIGRE is a (SET.nelem) by size(eigenMask,2) array holding the number
%   of migration recrystallization events in each layer of the distribution
%   described by eigenMask.
%
%   See also Thor.setup.

    NPOLY = zeros(SET.nelem,size(eigenMask,2));
    NMIGRE = zeros(SET.nelem,size(eigenMask,2));

    for ii = 1:SET.nelem

        % load element ii
        cdist = load(['./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii}]);
        
        % calculate velocity gradients and crystal strain rates
        cdist = Thor.Utilities.vec( cdist, SET, ii);        
        
        % calculate bulk strain rate
        edot = Thor.Utilities.bedot( cdist );
        
        % calculate time step
        medot = sqrt(1/2*(edot(1,1)^2+edot(2,2)^2+edot(3,3)^2+2*(edot(1,2)^2+edot(2,3)^2+edot(3,2)^2)));
        SET.tstep(ii) = StrainStep/medot; 
        
        % set model time
        SET.ti(ii) = SET.ti(ii) + SET.tstep(ii);
        
        % grow the crystals
        [cdist, K] = Thor.Utilities.grow(cdist, SET, ii);
        
        % calculate new dislocation density
        [cdist, ~] = Thor.Utilities.disl(cdist, SET, ii, K);
        
        % check for migration recrystallization
        if (SET.migre)
            [cdist, SET, NMIGRE(ii,:)] = Thor.Utilities.migre(cdist, SET, ii, eigenMask);
        end
        
        % check for polygonization
        if (SET.poly)
            [cdist, SET, NPOLY(ii,:)] = Thor.Utilities.poly(cdist, SET, ii, eigenMask);
        end
        
        % check crystal orientation bounds
        cdist = Thor.Utilities.bound(cdist);
        
        % rotate the crystals from last time steps calculations
        cdist = Thor.Utilities.rotate(cdist, SET, ii ); %#ok<ASGLU>
        
        % save crystal distributions
        eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
        
        % save a copy of crystal distributions at specified time steps
        if any(SAVE == STEP)
            eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step' num2str(STEP,'%05.0f') '_' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
        end
    end
end
