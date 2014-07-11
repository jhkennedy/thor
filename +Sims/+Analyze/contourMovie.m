function contourMovie(results)
%
%

% add the MATLAB path in
addpath /joe/Documents/MATLAB

% load in results
SAVE = [];
eigenMask = [];

load(results,'SAVE','eigenMask','Dir','SET');

%% Pick which run and element to use
mxRuns = size(SET,2);
mxElems = SET(1).nelem;

run = input(['There are results from ',num2str(mxRuns),' different runs. \n Please provide an array of runs you would like to make a move for: \n']);
% make sure is integer
run = floor(run);
if any(run > mxRuns) || any(run < 1)
    error(['Values must be given in the range of 1 to ',num2str(mxRuns)]);
end

display(['Processing ',num2str(size(run,2)),' runs with ',num2str(mxElems),' elements.']);

for ii = run
    for jj = 2 %1:mxElems

        %% Video setup

        % which saves to use
        cptr = SAVE(1:1:end);
        % number of frames
        frames = size(cptr,2);
        % initialize move structure
        M = moviein(frames);


        %% make each frame of video

        % create figure
        h = figure(1); clf;
        % set figure size
        set(h,'Units','pixels','Position',[0,0,560,420],'PaperPositionMode','auto','DoubleBuffer','on');


        % set contour axis
        con_ax = axes('Position', [0,0,1,1], 'parent',h,'layer','top');
                                 %[left, bottom, width, height]

        %% make all frames
        for ff = 1:frames

            % load in crystal distribution
            cdist = load([Dir,'/Run',num2str(ii),'/Step',num2str(cptr(ff),'%05d'),'_EL',num2str(jj,'%09d'),'.mat']);

            % make the contour plot
            equalAreaContour(con_ax,[cdist.theta(eigenMask(:,2)),cdist.phi(eigenMask(:,2))],'Cmap','jet','Fcolor','white');

            % capture frame
            drawnow;
            M(ff) = getframe(h,[0,0,560,420]);

        end

        movie2avi(M,[Dir,'/run',num2str(ii,'%03d'),'elem',num2str(jj,'%03d'),'.avi'],'fps',4,'compression', 'none')
        
        display(['finished Run ',num2str(ii),', Element ',num2str(jj),'of ',num2str(mxElems)]);
        
        close all;
    end
end