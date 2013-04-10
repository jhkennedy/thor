%% setup

load('/joe/Documents/Programs/Thor/trunk/+Param/Results/2013_03_18_Second/exploreResults.mat','StrainStep','SET','eigenMask');

cdist = load('/joe/Documents/Programs/Thor/trunk/+Param/Results/2013_03_18_Second/Run1/Step00000_EL000000001.mat');
cnext = load('/joe/Documents/Programs/Thor/trunk/+Param/Results/2013_03_18_Second/Run1/Step00001_EL000000001.mat');

SET = SET(1);
SET.to = zeros(24000,12);
SET.ti = zeros(12,1);
SET.Do = repmat(cdist.size,[1,12]);

%% strain step

corig = cdist;

% display('VEC')
% tic, 
cdist = Thor.Utilities.vec(cdist,SET,1);
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
% display('VEC')
tic, cdist = Thor.Utilities.vec(cdist,SET,1);
% toc

cvec = cdist;

edot = Thor.Utilities.bedot(cvec);
medot = sqrt(1/2*(edot(1,1)^2+edot(2,2)^2+edot(3,3)^2+2*(edot(1,2)^2+edot(2,3)^2+edot(3,2)^2)));
SET.tstep(1) = StrainStep/medot;
SET.ti(1) = SET.ti(1)+SET.tstep(1);

%% Rotate
display('ROTATE')
tic, crot = Thor.Utilities.rotate(cvec,SET,1); toc

