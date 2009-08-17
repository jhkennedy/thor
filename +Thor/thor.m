function edot = thor(stress,angles, crysdist)
%% Test code to recreate the anisotrpy model in Throstur Thorsteinsson's paper
%   An analytic approach to deformation of anisotropic ice-crystal
%       aggregates
%   Journal of Glaciology, Vol.47, No. 158, 2001 pg 507-516
%
% THOR(STRESS,CRYSDIST) returns the ehancement factor of the bulk strain
% rate for anisotropic ice. 
%
%   STRESS is a 3x3 matrix containing the stress tensor elements.
%
%   ANGLES is a 1x2 vector containing [Ao A] where Ao is the girdle angle
%   of the fabric and A is the cone angle of the fabric.
%
%   CRYSDIST is a string containing the type of crystal distrobution to use
%   for calculating the bulk strain rate.
%
%   THOR returns a 3x3 matrix containing the enhancement factors for each
%   element of the bulk strain rate. 

% check to see if crystal distrobution type was passed, in not set defualt
% value to 'iso' for isotropic
if ~exist(crysdist, 'var')
    crysdist = 'iso';
end


