% This script selects a results file, and then runs the savedResultsPar
% function on the slected results. 

% FIXME: try/catch! for matlabpool

% get the results file name a directory
[resultsName, Dir] = uigetfile('*.mat','Select the results file you wish process:');
% strip dir of trailing slash so that it acts like a PWD command
if Dir(end) == '/'
    Dir = Dir(1:end-1);
end


% load in model run data
load([Dir,'/',resultsName]);

% check to see if already processed
if (exist('EIG','var') && exist('DISLDENS','var') && exist('GRAINSIZE','var'))
    choice = questdlg('These results have already been analyzed! Re-analyze the results?', ...
	                  'Re-analyze?', ...
	                  'Yes','No','No');
else
    choice = 'Yes';
end


switch choice
    % process the results
    case 'Yes'
        % open matlab pool for parallel processing
        matlabpool open
        
        display(' ')
        display('Analyzing the results. This may take a while...')
        display(' ')
        
        % Analyze the results
        elems = SET(1).nelem;
        runs = length(SET);
        [EIG, DISLDENS, GRAINSIZE] =... 
            Sims.Analyze.savedResultsPar( Dir, elems, runs, eigenMask, SAVE, NAMES);

        % save the results
        save([Dir,'/',resultsName]);

        % Notify script is finished
        display(' ')
        display('Done Analyzing! Results saved.')
        display(' ')

        % close the matlab pool
        matlabpool close
    
    % do nothing
    case 'No'
        
        display(' ')
        display('Done; already analyzed!')
        display(' ')
        
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


