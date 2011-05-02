function [EIG] = analyzeSavedResults( Dir, in, runs, eigenMask, SAVE, NAMES)
    


 %% calculate eigenvalues at each saved time step for each run
    EIG = zeros(3,size(eigenMask,2),size(SAVE,2),in(1).nelem,runs);
    % EIG is ([e1;e2;e3],# of masks, # of saves, # of elements, # number of runs )
    for oo = 1:runs
        for mm = 1:in(1).nelem
            for nn = 1:size(SAVE,2)

                % load in saved crystal distrobutions
                cdist = load([Dir, 'Run' num2str(oo) '/SavedSteps/Step'...
                               num2str(SAVE(nn), '%05.0f') '_' NAMES(oo).files{mm}]);

                % calculate eigenvalue
                EIG(:,:,nn,mm,oo) = Thor.Utilities.eigenClimate( cdist, eigenMask );
            end
        end
    end