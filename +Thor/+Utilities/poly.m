function [ cdist, SET, npoly ] = poly( cdist, SET, elem, eigMask)
% [cdist, SET, npoly] = poly(cdist, SET, elem, eigMask) polygonizes
% crystals favorable do so.
% 
%   cdist is the structure holding the crystal distribution outlined in
%   Thor.setup.    
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number associated with the crystal distribution
%   cdist.
%
%   eigenMask is a N by M logical array where each M column contains N
%   logicals that are True if the nth crystal in the distribution belongs
%   to the mth layer. 
%
% poly returns: the crystal distribution cdist with polygonized crystals;
% SET with updated times of last recrystallization and grain sizes at last
% recrystallization; npoly, an 1xM array holding the number of
% polygonization events in each layer specified by eigMask.
%
%   See also Thor.setup

    % physical constants
    del = 0.065; % ratio threshold -- Thor 2002 [26]
    rhop = 5.4e10; % m^{-2} dislocation density needed to form a wall -- Thor 2002 [26]
    
    % magnitude (second invariant) of the stress
    S = SET.stress(:,:,elem); % Pa
    Mstress = sqrt( sum(sum(S.*S))/2 ); % Pa
    
    % see if polygonize is favorable
    mask = (cdist.MRSS/Mstress < del) & (cdist.dislDens > rhop);
    
    % number of polygonization events in each layer
    npoly = zeros(1,size(eigMask,2));
    for ii = 1:size(eigMask,2)
        npoly(1,ii) = sum(mask & eigMask(:,ii));
    end
    
    if any(mask)
        % reduce dislocation density
        cdist.dislDens(mask) = cdist.dislDens(mask) -rhop; % m^{-2}
        % halve the crystal size
        cdist.size(mask) = cdist.size(mask)/2;
        SET.Do(mask,elem) = cdist.size(mask);
        SET.to(mask,elem) = SET.ti(elem);
        % rotate the crystal
        task = cdist.theta < pi/6;
        % if withing 30 degrees of vertical move crystal away by 5 degrees
        cdist.theta(mask & task) = cdist.theta(mask & task) + pi/36; % -
        % else choose sign at random and then move crystal +/- 5 degrees
        rask = rand(SET.numbcrys,1) <= 0.5;
        cdist.theta(mask & ~task & rask) = cdist.theta(mask & ~task & rask) + pi/36;
        cdist.theta(mask & ~task & ~rask) = cdist.theta(mask & ~task & ~rask) - pi/36;
    else
        return
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


