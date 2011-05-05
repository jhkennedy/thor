function [ EIG ] = eigenLayers( cdist , eigenMask)
% [EIG]=eigenLayers( cdist, eigenMask) calulates the orientation eigenvalues of
% the crystal distrobution  layers defined in eigenMask.  
%
%   cdist is the structure holding the crystal distrobution outlined in
%   Thor.setup. 
% 
%   eigenMask is a NxM logical array where eigenMask(:,m) is the mth layer in
%   of the crystal distrobution.
%
% eigen returns EIG which is a 3xM array holding the orientation eigenvalues
% for each layer. 
%
%   eigen follows the method as outlined in 
%       Gagliardini, Durand, and Wang. Journal of Glaciology, Vol. 50, No. 168,
%       2004, Grain Area as a statistical weight for polycrystal constituents
%
% see also Thor.setup and Thor.Utilities.eigen

    M = size(eigenMask,2);
    EIG = zeros(3,M);
    
    % for each mask
    for ii = 1:M
        % get crystal info
        SIZE = cdist.size(eigenMask(:,ii));
        THETA = cdist.theta(eigenMask(:,ii));
        PHI = cdist.phi(eigenMask(:,ii));
        
        % calculate weights for average
        Vol = SIZE.^3; % m^3
        Vol = repmat(Vol/sum(Vol),[1,3]);

        % C-axis orientations
        N   = [sin(THETA).*cos(PHI) sin(THETA).*sin(PHI) cos(THETA)]; % -
        
        % calculate eigenvalues
        sv = svd(Vol.*N);
        EIG(:,ii) = (sv/norm(sv)).^2;
    end
end