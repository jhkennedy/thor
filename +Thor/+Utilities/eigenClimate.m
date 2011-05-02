function [ EIG, V, N ] = eigenClimate( cdist , eigenMask)
% [EIG]=eigen( cdist SET) calulates the orientation eigenvalues of the crystal
% distrobution cdist. 
%   cdist is a crystal distrobution is aranged in an (SET.numbcrys)x10 cell array. The
%   crystal distrubution structure is outlined in Thor.setup.
% 
%   eigenMask is a NxM array where M is the number of masks (layers) to place over the
%   crsyal distrobution. 
%
% eigen returns EIG which is a 3x1 vector holding the orientation eigenvalues for the
% crystal distrobution. 
%
%   eigen fallows the method as outlined in 
%       Gagliardini, Durand, and Wang. Journal of Glaciology, Vol. 50, No. 168, 2004
%           Grain Area as a statistical weight for polycrystal constituents
%
% see also Thor.setup

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