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

    % C-axis orientations
    N   = [sin(cdist.theta).*cos(cdist.phi) sin(cdist.theta).*sin(cdist.phi) cos(cdist.theta)]; % -

    % calculate eigenvalues
    EIG = svd(diag((cdist.size.^(3/2)/sum(cdist.size.^(3/2))).^(1/2),0)*N).^2;
    
end