%% Param
% T   runs 1-4 then 5-8 ---> -30,-15
% st. runs 1,2,3,4 repeat 5-8 ---> 1D, 4D, 1R, 4R
% NNI elem 1-3 repeat to 12 ---> 10,61,11
% gs  elem 1-3,4-6,7-9,10-12  ---> 0015, 0030, 0150, 0300


% Param runs:
    % run 1
    elem = 1; run = 1;
    % run 2
%     elem = 1; run = 2;
    % run 3
%     elem = 2; run = 1;
    % run 4
%     elem = 2; run = 2;
    % run 5
%     elem = 3; run = 1;
    % run 6
%     elem = 3; run = 2;
    % run 7
%     elem = 1; run = 3;
    % run 8
%     elem = 1; run = 4;
    % run 9
%     elem = 2; run = 3;
    % run 10
%     elem = 2; run = 4;
    % run 11
%     elem = 3; run = 3;
    % run 12
%     elem = 3; run = 4;

% Simple Shear Runs
    % run 13
%     elem = 1; run = 3;
    % run 14
%     elem = 1; run = 4;
    % run 15
%     elem = 2; run = 3;
    % run 16
%     elem = 2; run = 4;
    % run 17
%     elem = 3; run = 3;
    % run 18
%     elem = 3; run = 4;

addpath /joe/Documents/MATLAB/

%% save --> 0:500
for ii = 1:1:1500
    cla
    cdist = load([Dir,'/Run',num2str(run),'/SavedSteps/Step',num2str(SAVE(ii),'%05d'),'_EL',num2str(elem,'%09d'),'.mat']);
    equalAreaPoint([cdist.theta(eigenMask(:,2)),cdist.phi(eigenMask(:,2))])
    title(num2str(ii/100))
    pause(0.1)

    
end

%%
ii = 1;

lvl= [0,2,4,6,8,10];

cdist = load([Dir,'/Run',num2str(run),'/Step',num2str(SAVE(ii),'%05d'),'_EL',num2str(elem,'%09d'),'.mat']);
figure
[h, ax, cbax] = equalAreaContour([cdist.theta(eigenMask(:,2)),cdist.phi(eigenMask(:,2))],'Contours',lvl,'Cbar','on');

