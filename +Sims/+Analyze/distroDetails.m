function [EIG, DISLINFO, SIZEINFO] = distroDetails( cdist , eigenMask)
% [EIG, DISLINFO, SIZEINFO]=analyzeDistro( cdist, eigenMask) calulates the
% orientation eigenvalues of the crystal distrobution layers defined in
% eigenMask, the min/max/mean dislocation density for each lay, and the
% min/max/mean grain size for each layer. 
%
%   cdist is the structure holding the crystal distrobution outlined in
%   Thor.setup. 
% 
%   eigenMask is a NxM logical array where eigenMask(:,m) is the mth layer
%   in of the crystal distrobution.
%
% eigen returns EIG which is a 3xM array holding the orientation
% eigenvalues for each layer, SIZEINFO which is a 3xM array holding the
% [min, max, mean] grain size for each layer, and DISLINFO which is a 3xM
% array holding the  [min, max, mean] dislocation density for each layer.
%
%   eigen follows the method as outlined in 
%       Gagliardini, Durand, and Wang. Journal of Glaciology, Vol. 50, No. 168,
%       2004, Grain Area as a statistical weight for polycrystal constituents
%
% see also Thor.setup and Thor.Utilities.eigenLayers

    M = size(eigenMask,2);
    EIG = zeros(3,M);
    SIZEINFO = zeros(3,M);
    DISLINFO = zeros(3,M);
    
    % for each mask
    for ii = 1:M
        % get crystal info
        THETA = cdist.theta(eigenMask(:,ii));
        PHI = cdist.phi(eigenMask(:,ii));
        SIZE = cdist.size(eigenMask(:,ii));
        DISL = cdist.dislDens(eigenMask(:,ii));
        
        % C-axis orientations
        N   = [sin(THETA).*cos(PHI) sin(THETA).*sin(PHI) cos(THETA)]; % -
        
        % calculate eigenvalues
        EIG(:,ii) = svd(diag((SIZE.^(3/2)/sum(SIZE.^(3/2))).^(1/2),0)*N).^2;
        
        % calculate size info
        SIZEINFO(:,ii) = [min(SIZE); max(SIZE); mean(SIZE)];
        
        % calculate disl info
        DISLINFO(:,ii) = [min(DISL); max(DISL); mean(DISL)];
    end
end