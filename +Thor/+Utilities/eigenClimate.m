function [ EIG ] = eigenClimate( cdist , eigenMask)
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
    for ii = 1:M
        SIZE = cdist.size(eigenMask(:,ii));
        THETA = cdist.theta(eigenMask(:,ii));
        PHI = cdist.phi(eigenMask(:,ii));
        
        % calculate weights for average
        V = SIZE.^3; % m^3
        V = reshape(repmat(V/sum(V),[9,1]),3,3,[]); % -

        % C-axis orientations
        N   = [sin(THETA).*cos(PHI) sin(THETA).*sin(PHI) cos(THETA)]; % -

        % build orientation matricies
        j=1:3;
        eigmat = V.*reshape(repmat(N',3,1).* N(:,j(ones(3,1),:)).',3,3,[]); % -

        % claculate the eigenvalues
        EIG(:,ii) = eig(sum(eigmat,3));
    end
end