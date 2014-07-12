function [ cdist] = vec( cdist, SET, elem)
% [cdist]=vec(cdist, SET, elem) calculates the velocity gradient and single
% crystal strain rate for every crystal in cdist. cdist is the crystal
% disribution for element elem. Vec uses the settings in SET and the
% connectivity structure specified by CONN.   
%   
%   cdist is the structure holding the crystal distribution outlined in
%   Thor.setup.   
%
%   SET is a structure holding the model settings as outlined in Thor.setup.
%
%   elem is the element number that cdist is a part of.
%
% vec returns cdist with new fields for the Shmidt tensors on each slip
% system (.S1, .S2, .S3 size 3x3xN) magnitude of the RSS (.MRSS size Nx1),
% velocity gradient on the crystals (.vel size 3x3xN) and the strain rate
% on the crystals (.ecdot size 3x3xN).  
%
%   See also Thor.setup


%% Initialize variables
    
    ALPHA = interp1(SET.A(1,:), SET.A(2,:),SET.T(elem,1));% s^{-1} Pa^{-n}
    BETA = 630; % from Thors 2001 paper (pg 510, above eqn 16)
    
    % glen exponent
    n = SET.glenexp(elem,1); % -
    
    % get the Shmidt tensor and resolved shear stress, RSS, for each slip system
    [cdist, R1, R2, R3] = Thor.Utilities.shmidt(cdist, SET.numbcrys, SET.stress(:,:,elem));
    
    % get the softness parameter 
    [cdist, esoft] = Thor.Utilities.soft(cdist, SET.CONN, SET.xcec(elem,1), SET.xcec(elem,2)); 

    % calculate the rate of shearing on each slip system (size Nx1)
    G1 = ALPHA*BETA*esoft.*R1.*abs(esoft.*R1).^(n-1); % s^{-1}
    G2 = ALPHA*BETA*esoft.*R2.*abs(esoft.*R2).^(n-1); % s^{-1}
    G3 = ALPHA*BETA*esoft.*R3.*abs(esoft.*R3).^(n-1); % s^{-1}
    
    % calculate the velocity gradient (size 3x3xN)
    cdist.vel = cdist.S1.*reshape(repmat(G1',[9,1]),3,3,[])...
               +cdist.S2.*reshape(repmat(G2',[9,1]),3,3,[])... 
               +cdist.S3.*reshape(repmat(G3',[9,1]),3,3,[]); % s^{-1}
           
    % calculate the strain rate (size 3x3xN)
    cdist.ecdot = cdist.vel/2 + permute(cdist.vel,[2,1,3])/2; % s^{-1}

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


