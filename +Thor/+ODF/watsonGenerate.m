function [ W ] = watsonGenerate(N,K)
% [W]=watsonGenerate(N,K) generates a random sampling of the watson distribution of size
% Nx1 elements and concentation parameter K and a vertical priciple axis; (0,0,1). 
%   
%   N is the integer number of elements in the distribution.
%
%   K is the concentation parameter of the distribution. K must be a double between -inf
%   and inf. K<0 creates a sigle maximum distribution, K < 0 creates a equitorial girdle
%   distribution, and K = 0 creates a uniform distribution. 
%
% watsonGenerate returns a Nx3 array containing the x,y,z components of each sample.
%
% see also Thor.ODF.watson Thor.ODF.fisher and Thor.ODF.fisherGenerate 

    % make sure N is an integer
    n = round(N);
    
    % check type of distribution
    if K == inf; % perfect girdle
        
        % generate theta and phi on equator
        TH = ones(n,1)*pi/2;
        PH = 2*pi*rand(n,1);
        
        % make watson distribution
        W = [sin(TH).*cos(PH) sin(TH).*sin(PH) cos(TH)];
    
    elseif K == -inf; % perfect bipolar (single maximum)
        
        W = repmat([0,0,1],n,1);
        
    elseif K == 0 % isotropic
        
        % generate isotropic distribution
        w = randn(N,3);
        W = w./repmat(sqrt(sum(w.^2,2)),1,3);
        
    elseif K > 0 % Girdle
        
        % normalizing constant
        a = sqrt(pi/K)*erf(sqrt(K));

        % genrate random uniform disibution
        y = rand(n,1);

        % sample quantile function
        Q = 1/sqrt(K)*erfinv( 2*sqrt(K/pi)*a*y - erf(sqrt(K)) );

        % generate uniform random distribution of x,y points
        P = 2*pi*rand(n,1);
        P = [cos(P), sin(P)];
        
        % make watson distribution
        W = [repmat(sqrt(1-Q.^2),1,2).*P, Q];
    
    elseif K < 0 % bipolar (single maximum)
        
        % generate pdf function
        X = 0:.001:pi;
        WPDF = Thor.ODF.watson(K,X);
        
        % genearte angles
        THETA = randsample(X,N,true,WPDF.*sin(X))';
        PHI   = rand(N,1)*2*pi;
        
        % make watson distribution
        W = [sin(THETA).*cos(PHI) sin(THETA).*sin(PHI) cos(THETA)];
        
    else
        
        error(['Unknown K value: ', num2str(K)])
        
    end
end