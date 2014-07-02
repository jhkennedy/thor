% Subpackage ODF contains a set of function used to build Orientation
% Distribution Functions (ODFs).
%
%  =========
%  Functions
%  =========
%
%   fisher
%       [ F ] = bedot(k, x)
%       This function calculates calculates the Fisher Parameterized
%       Orientation Distribution Function (PODF).
%
%   fisherGenerate
%       [ F ] = fisherGenerate(N, K)
%       This function generates a random sampling of the Fisher
%       distribution.
%
%   watson
%       [ W ] = watson(k, x)
%       This function calculates the Watson Parameterized Orientation
%       Distribution Function (PODF).
%
%   watsonContourPure
%       [X,Y,Z] = watsonContourPure( k, PA )
%       This function creates a contoured plot of a continuous Watson
%       distribution.
%
%   watsonGenerate
%       [ W ] = watsonGenerate(N, K)
%       This function generates a random sampling of the Watson
%       distribution.
%
%   watsonK
%       [ K ] = watsonK( e )
%       This function estimates the concentration parameter for the Watson
%       distribution from the eigenvalues of the orientation tensor. 
%
%   watsunUnnorm
%       [ W ] = watsonUnnorm(k, x)
%       This function calculates the Unnormalized Watson Parameterized
%       Orientation Distribution Function (PODF).







