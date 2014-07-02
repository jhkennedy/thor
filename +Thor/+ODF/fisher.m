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
