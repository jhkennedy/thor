%
%

% add the MATLAB path in
addpath /joe/Documents/MATLAB

%% Pick which run and element to use
run  = 3;
elem = 1;

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

% figure properties
FWeight = 'normal';
FSize = 14;
LWidth = 2;
MSize = 7;

% set contour axis
con_ax = axes('Position', [0,0,1,1], 'parent',h,'layer','top');
                         %[left, bottom, width, height]

%% make all frames
for ff = 1:frames
    
    % load in crystal distribution
    cdist = load([Dir,'/Run',num2str(run),'/Step',num2str(cptr(ff),'%05d'),'_EL',num2str(elem,'%09d'),'.mat']);
    
    % make the contour plot
    equalAreaContour(con_ax,[cdist.theta(eigenMask(:,2)),cdist.phi(eigenMask(:,2))],'Cmap','jet','Fcolor','white');
    
    % capture frame
    drawnow;
    M(ff) = getframe(h,[0,0,560,420]);
    
end

movie2avi(M,[Dir,'/run',num2str(run,'%03d'),'elem',num2str(elem,'%03d'),'.avi'],'fps',4,'compression', 'none')
