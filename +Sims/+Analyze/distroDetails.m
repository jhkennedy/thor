function [EIG, DISLINFO, SIZEINFO] = distroDetails( cdist , eigenMask)
% [EIG, DISLINFO, SIZEINFO]=distroDetails( cdist, eigenMask) calulates the
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
%   eigen follows the method as outlined in:
%       Gagliardini, O., Durand, G., & Wang, Y. (2004). 
%       Grain area as a statistical weight for polycrystal constituents.
%       Journal of Glaciology, 50(168), 87–95. 
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FEvoR: Fabric Evolution with Recrystallization %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2009-2014  Joseph H Kennedy
%
% This file is part of FEvoR.
%
% FEvoR is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software 
% Foundation, either version 3 of the License, or (at your option) any later 
% version.
%
% FEvoR is distributed in the hope that it will be useful, but WITHOUT ANY 
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more 
% details.
%
% You should have received a copy of the GNU General Public License along 
% with FEvoR.  If not, see <http://www.gnu.org/licenses/>.
%
% Additional permission under GNU GPL version 3 section 7
%
% If you modify FEvoR, or any covered work, to interface with
% other modules (such as MATLAB code and MEX-files) available in a
% MATLAB(R) or comparable environment containing parts covered
% under other licensing terms, the licensors of FEvoR grant
% you additional permission to convey the resulting work.


