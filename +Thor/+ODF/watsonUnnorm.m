function [ W ] = watsonUnnorm( k, x )
% [W]=wason(K,X) calculates the Unnormalized Watson Parameterized Orientation Distrobution
% function (PODF) for concentation K at angle X away from the principle axis of
% the distrobution. 
%
%   K is the concentation parameter. Positive values specify girdle type
%   distrobutions, negative values specify single maximum type distrobutions,
%   and K=0 specifies a uniform distrobution. All these distrobutions are
%   specified around a primary axis. K must be a scalar value.
%
%   X is the angle of the c-axis away from the priniciple axis of the
%   distrobution NOT the c-axis co-latitude anlge unless the principle
%   distrobution axis is same as the crystal measurement axis. X can be a scalar
%   value or an array of doubles.
%
% watson returns W which is an array of size(X) giving the Watson PODF for
% concentation K at anlges X.
%
% See also Thor.ODF.fisher Thor.ODF.fisherGenerate and Thor.ODF.watsonGenerate


    W = exp(-k*cos(x).^2);

end