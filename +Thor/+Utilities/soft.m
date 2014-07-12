function [ cdist, esoft ] = soft( cdist, CONN, xc, ec )
% [ cdist, esoft ] = soft( cdist, CONN, xc, ec ) calculates the softness
% parameter for a crystal from the interaction between a crystal and its
% nearest neighbors.
%
%   cdist is the structure holding the crystal distribution outlined in
%   Thor.setup.
%
%   CONN is a 1xN array containing the crystal numbers for the N nearest
%   neighbors in the distribution.   
%
%   xc is the Nearest Neighbor Interaction, NNI, contribution from the
%   crystal. 
%
%   ec is the contribution from each neighboring crystal. 
%
% Soft returns the crystal distribution cdist and the scalar esoft which is
% the softness parameter for the crystal. 
%
%   See also Thor.setup

if ec == 0
    
    esoft = ones(size(cdist.MRSS)); % -
    
else
    
    load(['+Thor/+Build/Settings/CONN/' CONN])
    
    sumrss = @(x) sum(cdist.MRSS(x)); % Pa

    N  = cellfun('size', CONN,2); % -
    Ti = cellfun(sumrss, CONN); % Pa
    
    esoft = 1./(xc + N*ec).*(xc + ec.*Ti./cdist.MRSS); % -
    esoft(esoft > 10)= 10; % -


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


