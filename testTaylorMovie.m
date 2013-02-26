% script to make plot for taylorMovie

load testTaylorMovieData.mat

N = 100;
k = -100;
w = Thor.ODF.watsonGenerate(N,k);

simIndx = randi(length(SAVE),1);

%% make each frame of video

% create figure
h = figure(1); clf;
% set figure size
set(h,'Units','pixels','Position',[0,0,560*1.5,420],'PaperPositionMode','auto','DoubleBuffer','on');


% set contour axis
con_ax = axes('Position', [0,0,.5,1], 'parent',h,'layer','top');
                         %[left, bottom, width, height]
% set contour axis
depth_ax = axes('Position', [.65,.2,.3,.7], 'parent',h,'layer','top');
                         %[left, bottom, width, height]

% make the contour plot
equalAreaContour(con_ax,w,'Cmap','jet','Fcolor','white');

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
vline = plot([age(simIndx), age(simIndx)],[ymax,depth(simIndx)],'--r');
% horizontal line
hline = plot([xmin, age(simIndx)],[depth(simIndx),depth(simIndx)],'--r');

set(vline,'LineWidth', 3)
set(hline,'LineWidth', 3)


hold(depth_ax,'off')