%% test time for a single time step

SET = load('/home/joseph/Documents/Programs/Thor/trunk/+Test/timing.mat','A');
SET.nelem = 1;
SET.numbcrys = 8000;
SET.stress = [ 1, 0, 1;...
               0, 0, 0;...
               1, 0,-1]*10000; 
SET.xcec = [6, 1];
SET.T = -10; 
SET.glenexp = 3;
SET.width = [20 20 20];
SET.tstep = 1000*365*24*60*60;
SET.CONN = 'cube8000.mat';
SET.to = zeros(SET.numbcrys,SET.nelem);
SET.ti = zeros(SET.nelem, 1);
SET.poly = true;
SET.migre = true;
SET.run = 1; 

load home/joseph/Documents/Programs/Thor/trunk/+Test/timing.mat eigenMask

ctemp = load('/home/joseph/Documents/Programs/Thor/trunk/+Sims/+Param/Settings/w_tb2p0_m_2p4_gs0p0015.mat');

cdist.theta = ctemp.theta(eigenMask(:,1),1);
cdist.phi = ctemp.phi(eigenMask(:,1),1);
cdist.size = ctemp.size(eigenMask(:,1),1);
cdist.dislDens = ctemp.dislDens(eigenMask(:,1),1);

SET.Do = cdist.size;

clear ctemp;
icdist = cdist;
iSET = SET;

eigenMask = ones(8000,1);

ii = 1; 

NPOLY = zeros(SET.nelem,size(eigenMask,2));
NMIGRE = zeros(SET.nelem,size(eigenMask,2));

% preform time step
tic
    % calculate velocity gradients and crystal strain rates
    cdist = Thor.Utilities.vec( cdist, SET, ii);        

    % calculate bulk strain rate
    [bedot] = Thor.Utilities.bedot( cdist );

    % grow the crystals
    [cdist, K] = Thor.Utilities.grow(cdist, SET, ii);

    % calculate new dislocation density
    [cdist, ~] = Thor.Utilities.disl(cdist, SET, ii, K);

    % check for migration recrystallization
    if (SET.migre)
        [cdist, SET, NMIGRE(ii,:)] = Thor.Utilities.migre(cdist, SET, ii, eigenMask);
    end

    % check for polygonization
    if (SET.poly)
        [cdist, SET, NPOLY(ii,:)] = Thor.Utilities.poly(cdist, SET, ii, eigenMask);
    end

    % check crystal orientation bounds
    cdist = Thor.Utilities.bound(cdist);

    % rotate the crystals from last time steps calculations
    cdist = Thor.Utilities.rotate(cdist, SET, ii );
    
toc    


fcdist = cdist;
fSET = SET;