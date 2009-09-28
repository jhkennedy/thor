function [ crystals isocrystals ] = fem2thor( nelem, angles, crysdist )
% FEM2THOR Summary of this function goes here
%   Detailed explanation goes here
%
%
%
%
%
%
 
    isoangles = [0 pi/2];

    % initialize crystal distrobution structure
    crystals = struct('theta', zeros(20,20,20,nelem),...
                        'phi', zeros(20,20,20,nelem),...
                        'rss', ones(20,20,20,nelem));
    isocrystals = struct('theta', zeros(20,20,20,nelem),...
                           'phi', zeros(20,20,20,nelem),...
                           'rss', ones(20,20,20,nelem));
                       
   % generate crystal distrobutions for each element
    for ii = 1:nelem
        crystals.theta(:,:,:,ii) = Thor.Utilities.genCrystals(angles, crysdist);
        crystals.phi(:,:,:,ii) = Thor.Utilities.genCrystals([0 2*pi], crysdist);
        isocrystals.theta(:,:,:,ii) = Thor.Utilities.genCrystals(isoangles, 'iso');
        isocrystals.phi(:,:,:,ii) = Thor.Utilities.genCrystals([0 2*pi], 'iso');
    end


end

