function [EIG, DISLDENS, GRAINSIZE] = savedResultsPar( Dir, elems, runs, eigenMask, SAVE, NAMES)
% [EIG, DISLDENS, GRAINSIZE] = savedResultsPar( Dir, in, runs, eigenMask,
% SAVE, NAMES) calculates the eigenvalues, dislocation densities, and grain
% sizes of all the saved crystal distrobutions from a model simulation.
%   
%   Dir is the directory the simulations results are saved in. The crystal
%   distributions will be in the sub forlder RunX, where X is a run nuber.
%   
%   SET is the settings structure arrayfrom the simulation results. It will
%   be sized 1xRuns where Runs is the number of model runs.
%
%   eigenMask is a NxM logical array that determins if the nth crystal is
%   in the mth layer. 
%
%   SAVE is a 1XS array of the S steps that were saved in each run.
%
%   NAMES is a 1xRuns structure holding the names of the crystal
%   distributions for each run. Names(Run).field is a vector of all
%   the files names where the index corresponds to the element number.
%
% savedResultsPar returns:
%   
%   EIG is an array holding the eigenvalues for each crystal distribution
%   saved and is stuctured as such:  
%       ([e1;e2;e3],# of masks, # of saves, # of elements, # number of runs )
%
%   DISLDENS is an array holding the dislocation densities for each crystal
%   distribution saved and is stuctured as such:  
%       ([min;max;mean],# of masks, # of saves, # of elements, # number of runs )
%
%   GRAINSIZE is an array holding the grain sizes for each crystal
%   distribution saved and is stuctured as such:  
%       ([min;max;mean],# of masks, # of saves, # of elements, # number of runs )

 %% setup reuslts array and hidden array
    EIG = zeros(3,size(eigenMask,2),size(SAVE,2),elems, runs);
    eig = zeros(3,size(eigenMask,2),size(SAVE,2), elems);
    % EIG is ([e1;e2;e3],# of masks, # of saves, # of elements, # number of runs )
    
    DISLDENS = zeros(3,size(eigenMask,2),size(SAVE,2), elems, runs);
    disldens = zeros(3,size(eigenMask,2),size(SAVE,2), elems);
    % DISLDENS is ([min;max;mean],# of masks, # of saves, # of elements, # number of runs )
    
    GRAINSIZE = zeros(3,size(eigenMask,2),size(SAVE,2), elems, runs);
    grainsize = zeros(3,size(eigenMask,2),size(SAVE,2), elems);
    % GRAINSIZE is ([min;max;mean],# of masks, # of saves, # of elements, # number of runs )

%% Use hidePar function because matlab is too dumb...
    parfor oo = 1:runs
        [EIG(:,:,:,:,oo), DISLDENS(:,:,:,:,oo), GRAINSIZE(:,:,:,:,oo)]  =...
            hidePar(eig, disldens, grainsize, Dir, elems, eigenMask, SAVE, NAMES, oo);
    end
    
end


function [eig, disldens, grainsize] = hidePar (eig, disldens, grainsize, Dir, elems, eigenMask, SAVE, NAMES, oo)

    for mm = 1:elems
        for nn = 1:size(SAVE,2)

            % load in saved crystal distrobutions
            cdist = load([Dir, '/Run' num2str(oo) '/Step'...
                           num2str(SAVE(nn), '%05.0f') '_' NAMES(oo).files{mm}]);

            % calculate eigenvalue
            [eig(:,:,nn,mm), disldens(:,:,nn,mm), grainsize(:,:,nn,mm)] =... 
                Sims.Analyze.distroDetails( cdist, eigenMask );
        end
    end
end