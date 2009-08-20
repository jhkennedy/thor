function ef = efac(stress,angles, crysdist, n)
%% Test code to recreate the anisotrpy model in Throstur Thorsteinsson's paper
%   An analytic approach to deformation of anisotropic ice-crystal
%       aggregates
%   Journal of Glaciology, Vol.47, No. 158, 2001 pg 507-516
%
% EFAC(STRESS,ANGLES, CRYSDIST, N) returns the ehancement factor of the bulk strain
% rate for anisotropic ice. 
%
%   STRESS is a 3x3 matrix containing the stress tensor elements.
%
%   ANGLES is a 1x2 vector containing [Ao A] where Ao is the girdle angle
%   of the fabric and A is the cone angle of the fabric.
%
%   CRYSDIST is a string containing the type of crystal distrobution to use
%   for calculating the bulk strain rate. Type 'help
%   Thor.Utilities.genCrystals' for possible values. 
%
%   N is the exponent to be used in the flow law.
%
%   EFAC returns a 3x3 matrix containing the enhancement factors for each
%   element of the bulk strain rate. 

    %% Begin Program
    % check to see if crystal distrobution type was passed, in not set defualt
    % value to 'iso' for isotropic
    if ~exist(crysdist, 'var')
        crysdist = 'iso';
    end

    number = 50; % sqare root of the number of crystals to use 
                 % ( sqare root because of case even in genCrystals)
    tol = 0.025; % tolerance for removing near zero components
    edot = zeros(3,3); % initialize bulk strain rate
    isoedot = zeros(3,3); % initialize ideal isotropic bulk strain rate
    
    isoangles = [0 pi/2]; % isotropic cone angles
    
    % generate underlying crystal distrobution for fabric
    crystals = Thor.Utilities.genCrystals(number, angles, crysdist);
    isocrystals = Thor.Utilities.genCrystals(number, isoangles, 'iso');
    
    % sum single crystal strain rates over all crystals 
    for ii = 1:number*number
       edot = edot + Thor.Utilities.ecdot(stress, crystals(ii,:), n);
       isoedot = isoedot + Thor.Utilities.ecdot(stress, isocrystals(ii,:), n);
    end
    
    % test edot and isoedot against tolerance
    edot(abs(edot/edot(3,3))<=tol)=0;
    isoedot(abs(isoedot/isoedot(3,3))<=tol)=0;

    % claculate the enhancement factor and test against tolerance
    ef = edot./isoedot;
    ef(abs(ef)<=(tol/100)) = 0;
    ef(isnan(ef)) = 0;
end
