function [ W ] = watsonGenerate(N,K)
% [W]=watsonGenerate(N,K) generates a random sampling of the Watson
% distribution of size Nx1 elements and concentration parameter K and a
% vertical pricipal axis; (0,0,1).  
%   
%   N is the integer number of elements in the distribution.
%
%   K is the concentration parameter of the distribution. Positive values
%   specify girdle type distributions, negative values specify single
%   maximum type distributions, and K=0 specifies a uniform distribution.
%   All these distributions are  specified around a primary axis. K must be
%   a scalar value. 
%
% watsonGenerate returns W, a Nx3 array containing the x,y,z components of
% each sample. 
%
% see also Thor.ODF.watson, Thor.ODF.watsonK, Thor.ODF.fisher, and
% Thor.ODF.fisherGenerate.

    % make sure N is an integer
    n = round(N);
    
    % check type of distribution
    if K >500; % perfect girdle
        
        % generate theta and phi on equator
        TH = ones(n,1)*pi/2;
        PH = 2*pi*rand(n,1);
        
        % make Watson distribution
        W = [sin(TH).*cos(PH) sin(TH).*sin(PH) cos(TH)];
    
    elseif K < -700; % perfect bipolar (single maximum)
        
        W = repmat([0,0,1],n,1);
        
    elseif K == 0 % isotropic
        
        % generate isotropic distribution
        w = randn(N,3);
        W = w./repmat(sqrt(sum(w.^2,2)),1,3);
        
    elseif K > 0 % Girdle
        
        % normalizing constant
        a = sqrt(pi/K)*erf(sqrt(K));

        % generate random uniform distribution
        y = rand(n,1);

        % sample quantile function
        Q = 1/sqrt(K)*erfinv( 2*sqrt(K/pi)*a*y - erf(sqrt(K)) );

        % generate uniform random distribution of x,y points
        P = 2*pi*rand(n,1);
        P = [cos(P), sin(P)];
        
        % make Watson distribution
        W = [repmat(sqrt(1-Q.^2),1,2).*P, Q];
    
    elseif K < 0 % bipolar (single maximum)
        
        % generate PDF
        X = 0:.001:pi;
        WPDF = Thor.ODF.watson(K,X);
        
        % generate angles
        THETA = randsample(X,N,true,WPDF.*sin(X))';
        PHI   = rand(N,1)*2*pi;
        
        % make Watson distribution
        W = [sin(THETA).*cos(PHI) sin(THETA).*sin(PHI) cos(THETA)];
        
    else
        
        error(['Unknown K value: ', num2str(K)])
        
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


