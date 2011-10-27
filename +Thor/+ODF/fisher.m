function [ F ] = fisher( k, x )
% [F]=fisher(K,X) calculates the Fisher Parameterized Orientation Distrobution
% function (PODF) for concentation K at angle X away from the principle axis of
% the distrobution. 
%
%   K is the concentation parameter. Negitive values are not allowed, positive
%   values specify single maximum type distrobutions, and K=0 specifies a
%   uniform distrobution. All these distrobutions are specified around a primary
%   axis. K must be a scalar value.  
%
%   X is the angle of the c-axis away from the priniciple axis of the
%   distrobution NOT the c-axis co-latitude anlge unless the principle
%   distrobution axis is same as the crystal measurement axis. X can be a scalar
%   value or an array of doubles.
%
% fisher returns F which is an array of size(X) giving the Fisher PODF for
% concentation K at anlges X.
%
% See also Thor.ODF.watson Thor.ODF.watsonGenerate and Thor.ODF.fisherGenerate

F = (k/(4*pi*sinh(k)))*exp(k*cos(x));

end