function [ F ] = fisherGenerate(N, K)
% [F]=fisherGenerate(N,K) generates a random sampling of the fisher
% distribution of size Nx1 elements and concentration parameter K and a
% vertical principal axis; (0,0,1).  
%   
%   N is the integer number of elements in the distribution.
%
%   K is the concentration parameter of the distribution. K must be a double
%   between 0 and inf. K > 0 creates a single maximum distribution and K = 0
%   creates a uniform distribution.
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
