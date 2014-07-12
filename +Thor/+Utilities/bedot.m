function [ edot ] = bedot( cdist )
% [edot]=bedot(cdist) calculates the modeled bulk velocity gradient for the
% crystal distribution specified by cdist
%
%   cdist is the structure holding the crystal distribution outlined in
%   Thor.setup. 
%
% bedot returns edot, a 3x3 array holding the modeled bulk velocity
% gradient. 
%
%   See also Thor.setup
    
    % weight crystals by size
    A = cdist.size.^(3/2);
    W = reshape(repmat(A,1,9)',3,3,[]);
    
    % % equal weight to all crystals
    % A = cdist.numbcrys;
    % W = 1;
    
    % find the bulk strain rate
    edot = sum(W.*cdist.ecdot,3)./sum(A);
    
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


