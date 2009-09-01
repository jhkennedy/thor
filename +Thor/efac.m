function ef = efac(thetas, phis, isothetas, isophis, stress, n)
%% Test code to recreate the anisotrpy model in Throstur Thorsteinsson's paper
%   An analytic approach to deformation of anisotropic ice-crystal
%       aggregates
%   Journal of Glaciology, Vol.47, No. 158, 2001 pg 507-516
%
% EFAC(THETAS, PHIS, ISOTHETAS, ISOPHIS, STRESS, N) returns the ehancement 
% factor of the bulk strain rate for anisotropic ice. 
%
%   THETAS, PHIS are the theta and phi values for all the crystals within a 
%   crystal distribution
%
%   ISOTHETAS, ISOPHIS are the theta and phi values for all the crystals within 
%   an isotropic crystal distribution
%
%   STRESS is a 3x3 matrix containing the stress tensor elements.
%
%   N is the exponent to be used in the flow law.
%
% EFAC returns a 3x3 matrix containing the enhancement factors for each
% element of the bulk strain rate. 

    %% Begin Program
    % check to see if crystal distrobution type was passed, in not set defualt
    % value to 'iso' for isotropic
    
    number = 20*20*20; % number of crystals 
    tol = 0.025; % tolerance for removing near zero components
    edot = zeros(3,3); % initialize bulk strain rate
    isoedot = zeros(3,3); % initialize ideal isotropic bulk strain rate
    
    % initilize the ODF, orientation distribution funcion, normalizing
    % constant for both crystal distributions
    F = 0;  
    isoF = 0;
    
    % sum single crystal strain rates over all crystals and find
    % normalizing constant for the ODF 
    parfor ii = 1:number
       F = F + Thor.Utilities.odf(thetas(ii));
       isoF = isoF + Thor.Utilities.odf(isothetas(ii));
       edot = edot + Thor.Utilities.ecdot(stress, [thetas(ii) phis(ii)], n);
       isoedot = isoedot + Thor.Utilities.ecdot(stress, [isothetas(ii) isophis(ii)], n);
    end


    % apply ODF normalizing constant
    edot = edot/F;
    isoedot=isoedot/isoF;

    % test edot and isoedot against tolerance
    edot(abs(edot/edot(3,3))<=tol)=0;
    isoedot(abs(isoedot/isoedot(3,3))<=tol)=0;

    % claculate the enhancement factor and test against tolerance
    ef = edot./isoedot;
    ef(abs(ef)<=(tol/100)) = 0;
    ef(isnan(ef)) = 0;

end
