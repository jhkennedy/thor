function [ ALPHA ] = coneAngle( THETA )
% coneAngle returns the statistical cone angle of a crystal distrobution
%   
%   [ ALPHA] = coneAngle(THETA) returns the statistical cone anlge of a crystal
%   distrobution with colatitude of zenith angles THETA. THETA should be a
%   vector of zenith angles. ALPHA is the cone angle returned in radians. 
%

    % Ensure column vector
    THETA = THETA(:);
    
    % sort THETA
    THETA = sort(THETA);
    
    % find the biggest angle of the 90% of angles closest to the pole.
    FAR = ceil(.9*size(THETA,1));
    ALPHA = THETA(FAR);
    


end

