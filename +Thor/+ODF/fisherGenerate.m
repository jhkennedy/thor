function [ F ] = fisherGenerate(N, K)
% [F]=fisherGenerate(N,K) generates a random sampling of the fisher
% distribution of size Nx1 elements and concentration parameter K and a
% vertical principal axis; (0,0,1).  
%   
%   N is the integer number of elements in the distribution.
%
%   K is the concentration parameter of the distribution. K must be a
%   double between 0 and inf. K > 0 creates a single maximum distribution
%   and K = 0 creates a uniform distribution.
%
% fisherGenerate returns a Nx3 array containing the x,y,z components of
% each sample. 
%
%   see also Thor.ODF.fisher, Thor.ODF.watson, Thor.ODF.watsonK, and
%   Thor.ODF.watsonGenerate 
    
    % check what type of fabric
    if K > 0 % single maximum 
        % make sure N is an integer
        n = round(N);

        % normalizing constant
        c = 2/K*(sinh(K));

        % generate random uniform distibution
        y = rand(n,1);

        % sample quantile function
        Q = 1/K * log( exp(-K) + K * c * y ); 

        % generate uniform random distribution of x,y points
        P = 2*pi*rand(n,1);
        P = [cos(P) sin(P)];

        % make fisher distribution
        F = [repmat(sqrt(1-Q.^2),1,2).*P Q];
    
    elseif K < 0
        
        error('Thor:ODF:fisherGenerate','K >= 0 !!!')
        
    else % isotropic
        
        % generate isotropic distribution
        f = randn(N,3);
        F = f./repmat(sqrt(sum(f.^2,2)),1,3);
        
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


