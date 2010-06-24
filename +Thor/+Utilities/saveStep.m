function saveStep( NAMES, SET, RUN, STEP, SAVE)
% saveStep( NAMES, SET, RUN, STEP, SAVE) saves the crystal distrobutions for each STEP
% listed in SAVE. 
%   NAMES 
%
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   RUN is the run number the crystal distrobutions are saved under.
%
%   STEP is the current time step.
%
%   SAVE is a vector containing the time steps to save.
%
%   saveStep does not return anything, it does however copy the crystal distrobutions
%   currently being worked on for the RUN into SavedSteps directory. The directory is
%   located at:
%      ['./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/']

    if any(SAVE == STEP)

        for ii = 1:SET.nelem

            % load element ii
            tmp = load(['./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii}]);
            isave(['./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step' num2str(STEP) '_' NAMES.files{ii}], tmp.(NAMES.files{ii}), NAMES.files{ii});
        end
    end

end

%% extra functions
function isave(file, fin, var) %#ok<INUSL>
    eval([var '=fin;']);
    save(file, var);
end