function [ W ] = watsonUnnorm( k, x )
% [W]=waston(K,X) calculates the Unnormalized Watson Parameterized
% Orientation Distribution function (PODF) for concentration K at angle X
% away from the principle axis of the distribution.  
%
%   K is the concentration parameter. Positive values specify girdle type
%   distributions, negative values specify single maximum type
%   distributions, and K=0 specifies a uniform distribution. All these
%   distributions are  specified around a primary axis. K must be a scalar
%   value. 
%
%   X is the angle of the c-axis away from the principal axis of the
%   distribution NOT the c-axis co-latitude angle unless the principle
%   distribution axis is same as the crystal measurement axis. X can be a
%   scalar value or an array of doubles. 
%
% Watson returns W which is an array of size(X) giving the Watson PODF for
% concentration K at angles X.
%
% See also Thor.ODF.fisher Thor.ODF.fisherGenerate, Thor.ODF.watson,
% Thor.ODF.watsonK and Thor.ODF.watsonGenerate


    W = exp(-k*cos(x).^2);

end
