% code to explore the parameter space of my model:
    % Stress -> compression, shear, combined, real (Ray. 1983 in Taylor)
        % stress range from 0.1 to 0.4 bar [10000 - 40000 Pa](Pettit 2003)
    % Fabric -> isotropic, 80 deg. cone, 60 deg. cone, 30 deg. cone
    % NNI    -> none, mild, full
    % other? -> grain size, types of layering, # of crystals / layer
    % 
    % average antarctic ice temp. -30 deg C ... Tim

try
    % clean up the enironment and set up parallel processing
    close all; clear all;
    matlabpool open
    
    % start timing
    tic;     DATE = now;
    display(sprintf('\n Run started %s \n', datestr(DATE)))
    
    % manually load in initial setting structure
    in = struct([]);
    load ./+Param/Settings/2013_04_08_SimpleShear.mat 
    
    runs = length(in);        
    
       
        
    %% set up the model
    
    MaxStrain  = 1;
    StrainStep = 0.0005;
    TimeSteps = ceil(MaxStrain/StrainStep);
    
    SAVE = [0,1:TimeSteps];
    ModelTime = cell(1,runs);
    PolyEvents = cell(1,runs);
    MigreEvents= cell(1,runs);
    
    parfor ii = 1:runs
       [NAMES(ii), SET(ii)] = Thor.setup(in(ii), ii); 
    end
    
    TIME(1) = toc;
    display(sprintf('\n Time to set up Thor is %g seconds. \n', TIME(1)))
    
    %% step the model
    parfor jj = 1:runs
        
        ModelTime{jj} = zeros(SET(jj).nelem, size(SAVE,2) );
        PolyEvents{jj} = zeros(SET(jj).nelem, size(eigenMask,2), TimeSteps);
        MigreEvents{jj} = zeros(SET(jj).nelem, size(eigenMask,2), TimeSteps);
        i = 1;
        
        for kk = 1:TimeSteps
            [SET(jj), PolyEvents{jj}(:,:,kk), MigreEvents{jj}(:,:,kk)] = Thor.stepStrain(NAMES(jj), SET(jj), StrainStep, jj, kk, SAVE, eigenMask); % % s^{-1}
            
            
            % save model time for steps specified in SAVE
            if any(SAVE == kk)
                ModelTime{jj}(:,i+1) = SET(jj).ti;
                i = i+1;
            end
        end
    end
   
    TIME(2) = toc;
    display(sprintf('\n Time to step Thor through %d time steps for %d runs is \n     %g seconds. \n', TimeSteps, runs, TIME(2)-TIME(1) ) )
    

    %% save results
    
    save ./+Param/exploreResults.mat
    
    %% close the matlab pool
    matlabpool close;
    TIME(8) = toc;
    display(sprintf('\n Total time to run PARAM is \n     %g seconds. \n', TIME(8) ) )
    display(sprintf('\n Goodbye! \n'))
    display(sprintf('\n Run ended %s \n', datestr(now)))
    
    % email me to tell me the run is done
    !mail -s THOR:DONE jhkennedy@alaska.edu < ./+Param/explore.log
    
catch ME
    matlabpool close;
    TIME(9) = toc;
    display(sprintf('Total elapsed time before crash is %f seconds.', TIME(9)))
    display(sprintf('\n Goodbye! \n'))
    display(sprintf('\n Run ended %s \n', datestr(now)))
    
    display(ME.message);
    
    % email me to tell me run has crashed
    !mail -s THOR:CRASH jhkennedy@alaska.edu < ./+Param/explore.log
    
    save ./+Param/exploreCRASH.mat
    
    rethrow(ME);
    
end

quit;
    



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


