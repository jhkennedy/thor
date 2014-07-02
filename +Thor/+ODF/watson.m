function [ W ] = watson( k, x )
% [W]=wason(K,X) calculates the Watson Parameterized Orientation
% Distribution function (PODF) for concentration K at angle X away from the
% principle axis of the distribution.
%
%   K is the concentration parameter. Positive values specify girdle type
%   distributions, negative values specify single maximum type
%   distributions, and K=0 specifies a uniform distribution. All these
%   distributions are specified around a primary axis. K must be a scalar
%   value.  
%
%   X is the angle of the c-axis away from the principal axis of the
%   distribution NOT the c-axis co-latitude angle unless the principle
%   distribution axis is same as the crystal measurement axis. X can be a
%   scalar value or an array of doubles. 
%
% watson returns W which is an array of size(X) giving the Watson PODF for
% concentration K at angles X.
%
% See also Thor.ODF.fisher Thor.ODF.fisherGenerate, Thor.ODF.watsonK and
% Thor.ODF.watsonGenerate 

    if k > 0
        W = 1/(2*pi)*sqrt(k/pi)*erf(sqrt(k))^(-1)*exp(-k*cos(x).^2);
    else
        
        D = mfun( 'dawson',sqrt(abs(k)) );
        
        W = 1/(4*pi)*sqrt(abs(k))*exp(k)/D*exp(-k*cos(x).^2); 
    end
end
