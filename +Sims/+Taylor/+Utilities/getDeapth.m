function [z] = getDeapth(to, step, stepsize, TLR)
% [z] = getDeapth(to, step, stepsize, AGE) returns the deapth, z (1x1), at time
% to+step*stepsize according to the deapth age relation in AGE. 

% convert from seconds to kyr
stepsize = stepsize/(365*24*60*60*1000); % kyr

% get current time
t = to+step*stepsize; %  kyr

% get depth at current time
z = interp1(TLR.AGE(:,1), TLR.AGE(:,2), t,'linear', 'extrap');


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


