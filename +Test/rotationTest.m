%% setup

% load('/joe/Documents/Programs/Thor/trunk/+Param/Results/2013_04_08_UniCom_PureShear/exploreResults.mat','StrainStep','SET','eigenMask');
% corig = load('/joe/Documents/Programs/Thor/trunk/+Param/Results/2013_04_08_UniCom_PureShear/Run1/Step00000_EL000000001.mat');

load('~/Desktop/TMP/exploreResults.mat','StrainStep','SET','eigenMask');
corig = load('~/Desktop/TMP/Step00000_EL000000001.mat');

SET = SET(1);
SET.tstep = zeros(12,1);
SET.to = zeros(24000,12);
SET.ti = zeros(12,1);
SET.Do = repmat(corig.size,[1,12]);
SET.stress(:,:,1) = [0,0,10000;0,0,0;10000,0,0];

%% strain step

tic

cdist = corig; 

% display('VEC')
% tic, 
cdist = Thor.Utilities.vec(cdist,SET,1);
edot = Thor.Utilities.bedot(cdist);
medot = sqrt(1/2*(edot(1,1)^2+edot(2,2)^2+edot(3,3)^2+2*(edot(1,2)^2+edot(2,3)^2+edot(3,2)^2)));
SET.tstep(1) = StrainStep/medot;
SET.ti(1) = SET.ti(1)+SET.tstep(1);
% toc
% display('DISL')
% tic, 
[cdist, ~] = Thor.Utilities.disl(cdist,SET,1);
% toc
% display('GROW')
% tic, 
cdist = Thor.Utilities.grow(cdist,SET,1);
% toc
% display('POLY')
% tic, 
[cdist, SET, ~] = Thor.Utilities.poly(cdist,SET,1, eigenMask);
% toc
% display('MIGRE')
% tic, 
[cdist, SET, ~] = Thor.Utilities.migre(cdist,SET,1, eigenMask);
% toc
% display('BOUND')
% tic, 
cdist = Thor.Utilities.bound(cdist);
% toc

toc

%% Rotate
display('ROTATE')
tic
    crot0 = Thor.Utilities.oldRotate(cdist,SET,1); 
toc

tic
    crot1 = Thor.Utilities.rotate(cdist,SET,1); 
toc