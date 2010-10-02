function [ EIG ] = eigen( cdist )
% [EIG]=eigen( cdist SET) calulates the orientation eigenvalues of the crystal
% distrobution cdist. 
%   cdist is a crystal distrobution is aranged in an (SET.numbcrys)x10 cell array. The
%   crystal distrubution structure is outlined in Thor.setup.
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
% eigen returns EIG which is a 3x1 vector holding the orientation eigenvalues for the
% crystal distrobution. 
%
%   eigen fallows the method as outlined in 
%       Gagliardini, Durand, and Wang. Journal of Glaciology, Vol. 50, No. 168, 2004
%           Grain Area as a statistical weight for polycrystal constituents
%
% see also Thor.setup

    % calculate weights for average
    V = cdist.size.^3; % m^3
    V = reshape(repmat(V/sum(V),[9,1]),3,3,[]); % -
    
    % C-axis orientations
    N   = [sin(cdist.theta).*cos(cdist.phi) sin(cdist.theta).*sin(cdist.phi) cos(cdist.theta)]; % -
    
    % build orientation matricies
    j=1:3;
    eigmat = V.*reshape(repmat(N',3,1).* N(:,j(ones(3,1),:)).',3,3,[]); % -
    
    % claculate the eigenvalues
    EIG = eig(sum(eigmat,3));
    
end