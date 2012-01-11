function step(NAMES, SET, RUN, STEP, SAVE )
% step(NAMES, SET, RUN, TSTEP, SAVE) preforms a time step specified in SET on
% all the crystal distrobutions in NAMES. 
%
%   NAMES holds all the files names for the crystal distrobutions. NAMES is
%   outlined in Thor.setup.
%
%   SET is a structure holding the model settings as outlined in Thor.setup.
%
%   RUN is the current run number.
%
%   STEP is the current time step being preformed.
%
%   SAVE is a vector constaing all the timesteps that should be saved.
%
% step loads in a crystal distrobution for each element and  calulates new
% velocity gradients, crystal strain rates, dislocation densities, dislocation
% energies, grain sizes, as well as checking for polygonization and migration
% recrystallization. step then rotates the crystals, saves the stepped crystal
% distrobutions to disk, and saves a copy if the current time step is listed in
% SAVE.
%
%   See also Thor.setup, Thor.Utilities.vec, Thor.Utilities.disl,
%   Thor.Utilities.dislEn, Thor.Utilities.grow, Thor.Utilities.poly,
%   Thor.Utilities.migre, and Thor.Utilities.rotate.


    for ii = 1:SET.nelem

        % load element ii
        cdist = load(['./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii}]);
        
        % calculate velocity gradients and crystal strain rates
        cdist = Thor.Utilities.vec( cdist, SET, ii);        
        
        % calculate new dislocation density
        cdist = Thor.Utilities.disl(cdist, SET, ii);
        
        % grow the crystals
        cdist = Thor.Utilities.grow(cdist, SET, ii);
        
        % check for polyiginization
%         cdist = Thor.Utilities.poly(cdist, SET, ii);
        
        % check for migration recrystallization
        cdist = Thor.Utilities.migre(cdist, SET, ii);
        
        % check crystal orientation bounds
        cdist = Thor.Utilities.bound(cdist);
        
        % calculate new velocity gradients and crystal strain rates -- from poly and migre
        cdist = Thor.Utilities.vec( cdist, SET, ii);
        
        % rotate the crstals from last time steps calculations
        cdist = Thor.Utilities.rotate(cdist, SET ); %#ok<NASGU>
        
        % save crystal distrobutions
        eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
        
        % save a copy of crystal distrobutions at specified time steps
        if any(SAVE == STEP)
            eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step' num2str(STEP,'%05.0f') '_' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
        end
    end
end
