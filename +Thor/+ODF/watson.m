function [ W ] = watson( k, x )
% [W]=wason(K,X) calculates the Watson Parameterized Orientation Distrobution
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

    if k > 0
        W = 1/(2*pi)*sqrt(k/pi)*erf(sqrt(k))^(-1)*exp(-k*cos(x).^2);
    else
        
        D = mfun( 'dawson',sqrt(abs(k)) );
        
        W = 1/(4*pi)*sqrt(abs(k))*exp(k)/D*exp(-k*cos(x).^2); 
    end
end