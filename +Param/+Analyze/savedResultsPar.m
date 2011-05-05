function [EIG] = savedResultsPar( Dir, in, runs, eigenMask, SAVE, NAMES)
    
 %% calculate eigenvalues at each saved time step for each run
    EIG = zeros(3,size(eigenMask,2),size(SAVE,2),in(1).nelem, runs);
    eig = zeros(3,size(eigenMask,2),size(SAVE,2),in(1).nelem);
    % EIG is ([e1;e2;e3],# of masks, # of saves, # of elements, # number of runs )
    parfor oo = 1:runs
        EIG(:,:,:,:,oo) = hidePar(eig, Dir, in, eigenMask, SAVE, NAMES, oo);
    end
    
end


    function [eig] = hidePar (eig, Dir, in, eigenMask, SAVE, NAMES, oo)
        for mm = 1:in(1).nelem
            for nn = 1:size(SAVE,2)

                % load in saved crystal distrobutions
                cdist = load([Dir, 'Run' num2str(oo) '/SavedSteps/Step'...
                               num2str(SAVE(nn), '%05.0f') '_' NAMES(oo).files{mm}]);

                % calculate eigenvalue
                eig(:,:,nn,mm) = Thor.Utilities.eigenLayers( cdist, eigenMask );
            end
        end
    end