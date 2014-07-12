% script to test eigenvalue and strain enhancement

trials = 1000;

% number of crystals
N = 8000; 

k = -1; 

E = 10;

edotz = zeros(1,trials);
eig = zeros(1,trials);

parfor ii = 1:trials;
    
[edotz(ii), eig(ii)] = Test.eigRotate(N,k,E);

end; clear ii;


fprintf('Results of %d tials with %d crystals.\n\n',trials,N)
fprintf(' Eigenvalue enhancement:\n  Max:  %f\n  Min:  %f\n  Mean: %f\n\n',max(eig), min(eig),mean(eig))
fprintf(' strain rate enhancement:\n  Max:  %f\n  Min:  %f\n  Mean: %f\n\n',max(edotz), min(edotz),mean(edotz))



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


