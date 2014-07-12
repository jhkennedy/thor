function contourMovie(results)
% contourMovie(results) creates a time laps .avi video of Shmidt
% (equal area) plots of a layer from all the saved crystal distrobutions in
% a model simulation. 
%
%   results is the name of the ,mat file holding the processed results of a
%   simulation. 
%
%   see also Sims.Analyze.postProcess, and Sims.Analyze.equalAreaContour 

% load in results
SAVE = [];
eigenMask = [];

load(results,'SAVE','eigenMask','Dir','SET');

%% Pick which runs and elements to use
mxRuns = size(SET,2);
mxElems = SET(1).nelem;
mxMasks = size(eigenMask,2);

run = input(['There are results from ',num2str(mxRuns),' different runs. Each run has ',num2str(mxElems),' elements. \n Please provide an array of runs you would like to make a move for: \n']);
% make sure is integer
run = floor(run);
if any(run > mxRuns) || any(run < 1)
    error(['Values must be given in the range of 1 to ',num2str(mxRuns)]);
end

elem = input('Please provide an array of elements you would like to make a move for: \n');
% make sure is integer
elem = floor(elem);
if any(elem > mxElems) || any(elem < 1)
    error(['Values must be given in the range of 1 to ',num2str(mxElems)]);
end

mask = input(['There are ',num2str(mxMasks),' layers in the crystal distrubution. Which layer would you like to use? \n']);
% make sure is integer
mask = floor(mask);
if mask > mxMasks || mask < 1
    error(['Values must be given in the range of 1 to ',num2str(mxMasks)]);
end


display(['Processing ',num2str(length(run)),' runs and ',num2str(length(elem)),' of the elements using layer number ',num2str(mask),'.']);


%% set up video frames
% create figure
h = figure(1); clf;
% set figure size
set(h,'Units','pixels','Position',[0,0,560,420],'PaperPositionMode','auto','DoubleBuffer','on');


% set contour axis
con_ax = axes('Position', [0,0,1,1], 'parent',h,'layer','top');
                                 %[left, bottom, width, height]

% which saves to use
cptr = SAVE(1:1:end);
% number of frames
frames = size(cptr,2);

%% make each video
for ii = run
    for jj = elem

        % initialize move structure
        M = moviein(frames);
        % make each frame of the video
        for ff = 1:frames

            % load in crystal distribution
            cdist = load([Dir,'/Run',num2str(ii),'/Step',num2str(cptr(ff),'%05d'),'_EL',num2str(jj,'%09d'),'.mat']);

            % make the contour plot
            Sims.Analyze.equalAreaContour(con_ax,[cdist.theta(eigenMask(:,mask)),cdist.phi(eigenMask(:,mask))],'Cmap','jet','Fcolor','white');

            % capture frame
            drawnow;
            M(ff) = getframe(h,[0,0,560,420]);

        end

        movie2avi(M,[Dir,'/run',num2str(ii,'%03d'),'elem',num2str(jj,'%03d'),'.avi'],'fps',4,'compression', 'none')
        
        display(['finished Run ',num2str(ii),', Element ',num2str(jj),'of ',num2str(mxElems)]);
        
        clear M;
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


