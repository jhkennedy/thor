function taylorMovie(results)
%
%

% add the MATLAB path in
addpath /joe/Documents/MATLAB

% load in results
SAVE = [];
eigenMask = [];

load(results,'SAVE','eigenMask','Dir','SET', 'DEAPTH', 'TLR');

depth = DEAPTH;
age = interp1(TLR.AGE(:,2), TLR.AGE(:,1), depth,'linear', 'extrap');

%% Pick which run and element to use
mxRuns = size(SET,2);
mxElems = SET(1).nelem;

run = input(['There are results from ',num2str(mxRuns),' different runs. \n Please provide an array of runs you would like to make a movie for: \n']);
% make sure is integer
run = floor(run);
if any(run > mxRuns) || any(run < 1)
    error(['Values must be given in the range of 1 to ',num2str(mxRuns)]);
end

display(['Processing ',num2str(size(run,2)),' runs with ',num2str(mxElems),' elements.']);

for ii = run
    for jj = 1:mxElems

        %% Video setup

        % which saves to use
        cptr = SAVE;
        % number of frames
        frames = size(cptr,2);
        % initialize move structure
        M = moviein(frames);
        
        
        frameSize = [0,0,560*1.5,420];

        %% make each frame of video

        % create figure
        h = figure(1); clf;
        % set figure size
        set(h,'Units','pixels','Position',frameSize,'PaperPositionMode','auto','DoubleBuffer','on');


        % set contour axis
        con_ax = axes('Position', [0,0,.5,1], 'parent',h,'layer','top');
                                 %[left, bottom, width, height]
        % set depth axis
        depth_ax = axes('Position', [.6,.1,.35,.8], 'parent',h,'layer','top');
                         %[left, bottom, width, height]


        %% make all frames
        for ff = 1:frames

            % load in crystal distribution
            cdist = load([Dir,'/Run',num2str(ii),'/Step',num2str(cptr(ff),'%05d'),'_EL',num2str(jj,'%09d'),'.mat']);

            % make the contour plot
            equalAreaContour(con_ax,[cdist.theta(eigenMask(:,2)),cdist.phi(eigenMask(:,2))],'Cmap','jet','Fcolor','white');
            
            % make the depth-age plot
            depthAge = plot(depth_ax,TLR.AGE(:,1),TLR.AGE(:,2),'-b');

            xmin = -25;
            ymax = 600;
            set(depth_ax,'YDir','Reverse','XLim',[xmin,250],'YLim',[0,ymax])
            set(depthAge, 'Linewidth',3 )
            xlabel(depth_ax,'Age (ka)')
            ylabel(depth_ax,'Depth (m)')

            % make the current position lines
            hold(depth_ax, 'on')
            % vertical line
            vline = plot([age(ff), age(ff)],[ymax,depth(ff)],'--r');
            % horizontal line
            hline = plot([xmin, age(ff)],[depth(ff),depth(ff)],'--r');

            set(vline,'LineWidth', 3)
            set(hline,'LineWidth', 3)
            
            hold(depth_ax, 'off')
            
            % capture frame
            drawnow;
            M(ff) = getframe(h,frameSize);

        end

        movie2avi(M,[Dir,'/TaylorRun',num2str(ii,'%03d'),'elem',num2str(jj,'%03d'),'.avi'],'fps',4,'compression', 'none')
        
        display(['finished Run ',num2str(ii),', Element ',num2str(jj),'of ',num2str(mxElems)]);
        
        close all;
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


