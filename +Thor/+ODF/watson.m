function [ W ] = watson( k, x )
% [W]=wason(K,X) calculates the Watson Parameterized Orientation
% Distribution function (PODF) for concentration K at angle X away from the
% principle axis of the distribution.
%
%   K is the concentration parameter. Positive values specify girdle type
%   distributions, negative values specify single maximum type
%   distributions, and K=0 specifies a uniform distribution. All these
%   distributions are specified around a primary axis. K must be a scalar
%   value.  
%
%   X is the angle of the c-axis away from the principal axis of the
%   distribution NOT the c-axis co-latitude angle unless the principle
%   distribution axis is same as the crystal measurement axis. X can be a
%   scalar value or an array of doubles. 
%
% watson returns W which is an array of size(X) giving the Watson PODF for
% concentration K at angles X.
%
% See also Thor.ODF.fisher Thor.ODF.fisherGenerate, Thor.ODF.watsonK and
% Thor.ODF.watsonGenerate 

    if k > 0
        W = 1/(2*pi)*sqrt(k/pi)*erf(sqrt(k))^(-1)*exp(-k*cos(x).^2);
    else
        
        D = mfun( 'dawson',sqrt(abs(k)) );
        
        W = 1/(4*pi)*sqrt(abs(k))*exp(k)/D*exp(-k*cos(x).^2); 
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


