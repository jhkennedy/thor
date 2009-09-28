%% Test new version
matlabpool

global NAMES  %#ok<NUSED>
nelem = 1000;
contype = 'cube';
distype = 'iso';
disangles = repmat([0 pi/2], nelem, 1);
tic; eldata = Thor.setup(nelem, contype, distype, disangles); toc

matlabpool close