function [ cdist, R1, R2, R3 ] = shmidt( cdist, nc, stress )
% [cdist, R1, R2, R3]=SHMIDT( cdist, nc, stress ) returns the crystal
% distribution structure with the Shmidt tensors and magnitude of the RSS
% for each of the three slip systems on each crystal in the distribution.  
% 
%   cdist the structure holding the crystal distribution outlined in
%   Thor.setup.
%
%   nc is the number of crystals in the distribution.
%
%   stress is a 3X3Xnc matrix holding the stress.
%
% SHMIDT returns the crystal distribution structure with the added fields
% of S1, S2, S3 (size 3x3xnc) and MRSS (size ncx1) which give the Shmidt
% tensor for each of the three slip systems and the magnitude of the RSS.
% SHMIDT also returns the RSS on each slip system; R1, R2 and R3 
% (size ncx1).
%
% see also Thor.setup.

%% Calculate the Shmidt tensors
    
    % sines and cosines so calculation only has to be preformed once
    st = sin(cdist.theta); ct = cos(cdist.theta);
    sp = sin(cdist.phi);   cp = cos(cdist.phi); sq3 = sqrt(3);

    % Basal plane vectors
    B1 = [ct.*cp/3, ct.*sp/3, -st/3]; % -
    B2 = [(-ct.*cp - sq3.*sp)/6, (-ct.*sp+sq3.*cp)/6, st/6]; % -
    B3 = [(-ct.*cp + sq3.*sp)/6, (-ct.*sp-sq3.*cp)/6, st/6]; % -
    
    % C-axis orientation
    N = [st.*cp, st.*sp, ct]; % -
    
    % Shmidt tensor (outer product -- B'*N for each crystal)
    j=1:3;
    cdist.S1 = reshape(repmat(B1',3,1).* N(:,j(ones(3,1),:)).',[3,3,nc]); % -
    cdist.S2 = reshape(repmat(B2',3,1).* N(:,j(ones(3,1),:)).',[3,3,nc]); % -
    cdist.S3 = reshape(repmat(B3',3,1).* N(:,j(ones(3,1),:)).',[3,3,nc]); % -
    
    % expand the stress for RSS
    stress = repmat(stress,[1,1,nc]); 
    
    % calculate the RSS on each slip system (Nx1 vector)
    R1 = reshape(sum(sum(cdist.S1.*stress)),1,[])'; % Pa
    R2 = reshape(sum(sum(cdist.S2.*stress)),1,[])'; % Pa
    R3 = reshape(sum(sum(cdist.S3.*stress)),1,[])'; % Pa
    
    % calculate the magnitude of the RSS on each crystal
    cdist.MRSS = sqrt( sum( ( B1.*repmat(R1,[1,3])...
                             +B2.*repmat(R2,[1,3])...
                             +B3.*repmat(R3,[1,3]) ).^2,2) );  % Pa


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


