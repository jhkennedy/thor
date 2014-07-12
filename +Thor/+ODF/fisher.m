function [ F ] = fisher( k, x )
% [F]=fisher(K,X) calculates the Fisher Parameterized Orientation
% Distribution function (PODF) for concentration K at angle X away from the
% principle axis of the distribution.
%
%   K is the concentration parameter. Negative values are not allowed,
%   positive values specify single maximum type distributions, and K=0
%   specifies a uniform distribution. All these distributions are specified
%   around a primary axis. K must be a scalar value.  
%
%   X is the angle of the c-axis away from the principal axis of the
%   distribution NOT the c-axis co-latitude angle unless the principle
%   distribution axis is same as the crystal measurement axis. X can be a
%   scalar value or an array of doubles.
%
% fisher returns F which is an array of size(X) giving the Fisher PODF for
% concentration K at angles X.
%
% See also Thor.ODF.watson Thor.ODF.watsonGenerate and
% Thor.ODF.fisherGenerate 

F = (k/(4*pi*sinh(k)))*exp(k*cos(x));

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


