function [GS] = grainSizePar( Dir, in, runs, eigenMask, SAVE, NAMES)
    
 %% calculate min max mean grain size at each saved time step for each run
    GS = zeros(3,size(eigenMask,2),size(SAVE,2),in(1).nelem, runs);
    gs = zeros(3,size(eigenMask,2),size(SAVE,2),in(1).nelem);
    % GS is ([min; max; mean grain size], # of masks, # of saves, # of elements, # number of runs )
    parfor oo = 1:runs
        GS(:,:,:,:,oo) = hidePar( gs, Dir, in, eigenMask, SAVE, NAMES, oo);
    end
    
end


    function [gs] = hidePar (gs, Dir, in, eigenMask, SAVE, NAMES, oo)
        for mm = 1:in(1).nelem
            for nn = 1:size(SAVE,2)

                % load in saved crystal distrobutions
                cdist = load([Dir, '/Run' num2str(oo) '/Step'...
                               num2str(SAVE(nn), '%05.0f') '_' NAMES(oo).files{mm}]);

                for ii = 1:size(eigenMask,2)
                    % get crystal info
                    gs(:,ii,nn,mm) = [min(cdist.size(eigenMask(:,ii)));...
                                      max(cdist.size(eigenMask(:,ii)));...
                                      mean(cdist.size(eigenMask(:,ii)))];
                end
                
            end
        end
    end