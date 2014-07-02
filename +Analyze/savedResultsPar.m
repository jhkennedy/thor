function [EIG, DISLDENS, GRAINSIZE] = savedResultsPar( Dir, in, runs, eigenMask, SAVE, NAMES)
% [EIG, DISLDENS, GRAINSIZE] = savedResultsPar( Dir, in, runs, eigenMask, SAVE, NAMES)
%
%   EIG is ([e1;e2;e3],# of masks, # of saves, # of elements, # number of runs )
%
%   DISLDENS is ([min;max;mean],# of masks, # of saves, # of elements, # number of runs )
%
%   GRAINSIZE is ([min;max;mean],# of masks, # of saves, # of elements, # number of runs )

 %% setup reuslts array and hidden array
    EIG = zeros(3,size(eigenMask,2),size(SAVE,2),in(1).nelem, runs);
    eig = zeros(3,size(eigenMask,2),size(SAVE,2),in(1).nelem);
    % EIG is ([e1;e2;e3],# of masks, # of saves, # of elements, # number of runs )
    
    DISLDENS = zeros(3,size(eigenMask,2),size(SAVE,2),in(1).nelem, runs);
    disldens = zeros(3,size(eigenMask,2),size(SAVE,2),in(1).nelem);
    % DISLDENS is ([min;max;mean],# of masks, # of saves, # of elements, # number of runs )
    
    GRAINSIZE = zeros(3,size(eigenMask,2),size(SAVE,2),in(1).nelem, runs);
    grainsize = zeros(3,size(eigenMask,2),size(SAVE,2),in(1).nelem);
    % GRAINSIZE is ([min;max;mean],# of masks, # of saves, # of elements, # number of runs )

%% Use hidePar function because matlab is too dumb...
    parfor oo = 1:runs
        [EIG(:,:,:,:,oo), DISLDENS(:,:,:,:,oo), GRAINSIZE(:,:,:,:,oo)]  =...
            hidePar(eig, disldens, grainsize, Dir, in, eigenMask, SAVE, NAMES, oo);
    end
    
end


    function [eig, disldens, grainsize] = hidePar (eig, disldens, grainsize, Dir, in, eigenMask, SAVE, NAMES, oo)
        for mm = 1:in(1).nelem
            for nn = 1:size(SAVE,2)

                % load in saved crystal distrobutions
                cdist = load([Dir, '/Run' num2str(oo) '/Step'...
                               num2str(SAVE(nn), '%05.0f') '_' NAMES(oo).files{mm}]);

                % calculate eigenvalue
                [eig(:,:,nn,mm), disldens(:,:,nn,mm), grainsize(:,:,nn,mm)] =... 
                    Analyze.distroDetails( cdist, eigenMask );
            end
        end
    end