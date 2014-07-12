% Code to model the fabric evolution in Taylor Dome. 
%   Grootes et all, 1994
%   Waddington et all, 1993
%   Kavanaugh et all, 2009 1-3
% remember to comment out quit for local job

try
    % clean up the environment and set up parallel processing
    close all; clear all;
    matlabpool 5;
    
    tic; DATE = now;
    display(sprintf('\n Run started %s \n', datestr(DATE)))

    % manually load in initial setting structure
    in = struct([]);
    load ./+Taylor/Settings/2012_10_10_evolve_Tm05.mat
    
    
    %% set up model

    % build the different runs
    runs = 5;
    timesteps = 2100; % step-size is definded in in.tstep 
    
    % Save at these time steps
    SAVE = [0,1,5:5:95,100:50:timesteps];
    PolyEvents = cell(1,runs);
    StrainStep = cell(1,runs);
    

    %% set up Taylor Dome

    
    % which type of symmetric divide?
    StressType = 'Dome'; % 'Dome' or 'Ridge'
    
    switch StressType
        case 'Dome'
            % load in Taylor data -- T, Z, vs, AGE
            TLR = load('./+Taylor/Data/TLRdome1p3.mat');
        case 'Ridge'
            % load in Taylor data -- T, Z, vs, AGE
            TLR = load('./+Taylor/Data/TLRridge1p3.mat');    
    end
    
    % initial starting time ~ 100 m
    to = 1.525; % kyr 
    
    % Deapths at saved time steps
    DEAPTH = Taylor.Utilities.getDeapth(to, SAVE, in(1).tstep, TLR); %#ok<NASGU> % m

    
    parfor jj = 1:runs
        [NAMES(jj),SET(jj) ] = Thor.setup(in(jj), jj);  
    end
    
    TIME(1) = toc;
    display(sprintf('\n Time to set up Thor is %g seconds. \n', TIME(1)))
    
    
    %% step each run
    parfor kk = 1:runs 
        
        PolyEvents{kk} = zeros(SET(kk).nelem, size(eigenMask,2), timesteps);
        MigreEvents{kk} = zeros(SET(kk).nelem, size(eigenMask,2), timesteps);
        StrainStep{kk} = zeros(SET(kk).nelem, timesteps);
        
        for ll = 1:timesteps
            % get current deapth
            depth = Taylor.Utilities.getDeapth(to, ll, SET(kk).tstep, TLR);
            
            % get current temperature
            temp = interp1q(TLR.Z',TLR.T',depth);
            SET(kk).T = SET(kk).T.*0+temp;
            
            % set current time
            SET(kk).ti = SET(kk).tstep*ll;
            
            % get current stress (RAYMOND 1983)
            S33 = interp1q(TLR.S33(:,2),TLR.S33(:,1),depth);
            S22 = interp1q(TLR.S22(:,2),TLR.S22(:,1),depth);
            S11 = interp1q(TLR.S11(:,2),TLR.S11(:,1),depth);
            SET(kk).stress(3,3,:) = SET(kk).stress(3,3,:).*0+S33; 
            SET(kk).stress(2,2,:) = SET(kk).stress(2,2,:).*0+S22; 
            SET(kk).stress(1,1,:) = SET(kk).stress(1,1,:).*0+S11; 
            

            % perform time step
            [SET(kk), PolyEvents{kk}(:,:,ll), MigreEvents{kk}(:,:,ll), StrainStep{kk}(:,ll)] = Thor.stepTime(NAMES(kk),SET(kk), kk, ll, SAVE, eigenMask);
        end
    end
    
    TIME(2) = toc;
    display(sprintf('\n Time to step Thor through %d time steps for %d runs is \n     %g seconds. \n', timesteps, runs, TIME(2)-TIME(1) ) )
    
        
%% save results

    save ./+Taylor/evolveResults.mat
    
    %%
    
    matlabpool close;
    TIME(4) = toc;
    display(sprintf('\n Total time to run EVOLVE is \n     %g seconds. \n', TIME(4) ) )
    display(sprintf('\n Goodbye! \n'))
    display(sprintf('\n Run ended %s \n', datestr(now)))
    
    % email me to tell me the run is done
    !mail -s THOR:DONE jhkennedy@alaska.edu < ./+Taylor/evolve.log


catch ME
    matlabpool close;
    TIME(5) = toc;
    display(sprintf('Total elapsed time before crash is %f seconds.', TIME(5)))
    display(sprintf('\n Goodbye! \n'))
    display(sprintf('\n Run ended %s \n', datestr(now)))
    
    display(ME.message);
    
    % email me to tell me run has crashed
    !mail -s THOR:CRASH jhkennedy@alaska.edu < ./+Taylor/evolve.log
    
    save ./+Taylor/evolveCrash.mat
    
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


