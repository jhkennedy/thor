function [DISLDENS] = dislDensPar( Dir, in, runs, eigenMask, SAVE, NAMES)
    
 %% calculate the max min and mean dislocation density at each saved time step for each run
    DISLDENS = zeros(1,3,size(SAVE,2),in(1).nelem, runs);
    dislDens = zeros(1,3,size(SAVE,2),in(1).nelem);
    % EIG is ([e1;e2;e3],# of masks, # of saves, # of elements, # number of runs )
    parfor oo = 1:runs
        DISLDENS(:,:,:,:,oo) = hidePar(dislDens, Dir, in, eigenMask, SAVE, NAMES, oo);
    end
    
end


    function [dislDens] = hidePar (dislDens, Dir, in, eigenMask, SAVE, NAMES, oo)
        for mm = 1:in(1).nelem
            for nn = 1:size(SAVE,2)

                % load in saved crystal distrobutions
                cdist = load([Dir, '/Run' num2str(oo) '/Step'...
                               num2str(SAVE(nn), '%05.0f') '_' NAMES(oo).files{mm}]);

                % calculate eigenvalue
                dislDens(1,:,nn,mm) =  [max(cdist.dislDens), min(cdist.dislDens), mean(cdist.dislDens) ];
            end
        end
    end