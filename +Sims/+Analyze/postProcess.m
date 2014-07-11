% script to post process data

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
        [EIG, DISLDENS, GRAINSIZE] = Analyze.savedResultsPar( Dir, SET, eigenMask, SAVE, NAMES);

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
        