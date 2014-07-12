function [EIG, DISLDENS, GRAINSIZE] = savedResultsPar( Dir, elems, runs, eigenMask, SAVE, NAMES)
% [EIG, DISLDENS, GRAINSIZE] = savedResultsPar( Dir, in, runs, eigenMask,
% SAVE, NAMES) calculates the eigenvalues, dislocation densities, and grain
% sizes of all the saved crystal distrobutions from a model simulation.
% savedResultsPar uses matlabs parallel computing toolbox and analyzes each
% run in parallel. 
%   
%   Dir is the directory the simulations results are saved in. The crystal
%   distributions will be in the sub forlder RunX, where X is a run nuber.
%   
%   elems is the number of elements associated with 
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
        % FIXME: Need to add a check for all in(i) and SET(i) structures
        % such that nelem is the same for all runs.
 
    EIG = zeros(3,size(eigenMask,2),size(SAVE,2),elems, runs);
    % EIG is ([e1;e2;e3],# of masks, # of saves, # of elements, # number of runs )
    
    DISLDENS = zeros(3,size(eigenMask,2),size(SAVE,2), elems, runs);
    % DISLDENS is ([min;max;mean],# of masks, # of saves, # of elements, # number of runs )
    
    GRAINSIZE = zeros(3,size(eigenMask,2),size(SAVE,2), elems, runs);
    % GRAINSIZE is ([min;max;mean],# of masks, # of saves, # of elements, # number of runs )

parfor oo = 1:runs
    for mm = 1:elems
        for nn = 1:size(SAVE,2)

            % load in saved crystal distrobutions
            cdist = load([Dir, '/Run' num2str(oo) '/Step'...
                           num2str(SAVE(nn), '%05.0f') '_' NAMES(oo).files{mm}]);

            % calculate eigenvalue
            [EIG(:,:,nn,mm,oo), DISLDENS(:,:,nn,mm,oo), GRAINSIZE(:,:,nn,mm,oo)]  =...
                Sims.Analyze.distroDetails( cdist, eigenMask );
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


