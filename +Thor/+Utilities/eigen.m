function [ EIG ] = eigen( cdist )
% [EIG]=eigen( cdist ) calulates the orientation eigenvalues of the
% crystal distrobution.  
%
%   cdist is the structure holding the crystal distrobution outlined in
%   Thor.setup. 
%
% eigen returns EIG which is a 3x1 array holding the orientation eigenvalues of
% the distrobution.  
%
%   eigen follows the method as outlined in 
%       Gagliardini, Durand, and Wang. Journal of Glaciology, Vol. 50, No. 168,
%       2004, Grain Area as a statistical weight for polycrystal constituents
%
% see also Thor.setup and Thor.Utilities.eigenClimate

    % calculate weights for average
    Vol = cdist.size.^3; % m^3
    Vol = repmat(Vol/sum(Vol),[1,3]);

    % C-axis orientations
    N   = [sin(cdist.theta).*cos(cdist.phi) sin(cdist.theta).*sin(cdist.phi) cos(cdist.theta)]; % -

    % calculate eigenvalues
    sv = svd(Vol.*N);
    EIG = (sv/norm(sv)).^2;
    
end